// zig run src/key.zig -lc -lX11 -lXi

const std = @import("std");
const c = @cImport({
    @cInclude("X11/XKBlib.h");
    @cInclude("X11/Xlib.h");
    @cInclude("X11/extensions/XInput2.h");
});

fn XISetMask(ptr: [*]u8, comptime event: c_int) void {
    ptr[event >> 3] |= (1 << (event & 7));
}

// https://github.com/anko/xkbcat/blob/master/xkbcat.c
pub fn main() !u8 {
    const alloc = std.heap.page_allocator;

    const args = try std.process.argsAlloc(alloc);
    if (args.len != 2) @panic("bad args. usage: key '…' (name from `pacmdn list-sources)");
    const source_name = args[1];

    const display = c.XOpenDisplay(null) orelse {
        std.log.crit("Cannot open X display", .{});
        return 1;
    };

    var xiOpcode: c_int = undefined;
    var queryEvent: c_int = undefined;
    var queryError: c_int = undefined;
    if (c.XQueryExtension(display, "XInputExtension", &xiOpcode, &queryEvent, &queryError) != 1) {
        std.log.crit("X Input extension not available", .{});
        return 2;
    }

    {
        var major: c_int = 2;
        var minor: c_int = 0;
        const query_result = c.XIQueryVersion(display, &major, &minor);
        if (query_result == c.BadRequest) {
            std.log.crit("Need XI 2.0 support (got {}.{})", .{ major, minor });
            return 3;
        } else if (query_result != c.Success) {
            std.log.crit("Internal error", .{});
            return 4;
        }
    }

    const mask_len = c.XIMaskLen(c.XI_LASTEVENT);

    const root = c.XDefaultRootWindow(display);
    var mask = c.XIEventMask{
        .deviceid = c.XIAllMasterDevices,
        .mask_len = mask_len,
        .mask = (try alloc.alloc(u8, mask_len)).ptr,
    };
    for (mask.mask[0..mask_len]) |*v| v.* = 0;
    XISetMask(mask.mask, c.XI_RawKeyPress);
    XISetMask(mask.mask, c.XI_RawKeyRelease);
    _ = c.XISelectEvents(display, root, &mask, 1);
    _ = c.XSync(display, 0);
    alloc.free(mask.mask[0..mask_len]);

    var ptt_pushed: bool = false;
    var v_pushed: bool = false;

    var prev_v_or_ptt_pushed: bool = false;
    // push_to_talk_pushed: bool = v_pushed or ptt_pushed

    while (true) {
        var event: c.XEvent = undefined;
        _ = c.XNextEvent(display, &event);
        const cookie: *c.XGenericEventCookie = &event.xcookie;

        // TODO track active window and stuff and be a full replacement for key
        if ((c.XGetEventData(display, cookie) != 0) and cookie.type == c.GenericEvent and cookie.extension == xiOpcode) {
            if (cookie.evtype == c.XI_RawKeyPress or cookie.evtype == c.XI_RawKeyRelease) {
                var ev = @intToPtr(*c.XIRawEvent, @ptrToInt(cookie.data));
                //std.log.info("{}: {}", .{ cookie.evtype, ev.detail });

                // detail 248 or detail 55 for push to talk::

                if (ev.detail == 55) v_pushed = cookie.evtype == c.XI_RawKeyPress;
                if (ev.detail == 248) ptt_pushed = cookie.evtype == c.XI_RawKeyPress;
                const v_or_ptt_pushed = v_pushed or ptt_pushed;

                if (v_or_ptt_pushed != prev_v_or_ptt_pushed) {
                    prev_v_or_ptt_pushed = v_or_ptt_pushed;
                    if (v_or_ptt_pushed) {
                        std.log.info("ptt down", .{});
                        // volume is 0%-100%: 0-65536. higher volume is allowed.
                        var cp = try std.ChildProcess.init(&[_][]const u8{ "pacmd", "set-source-volume", source_name, "98304" }, alloc);
                        _ = try cp.spawnAndWait();
                    } else {
                        std.log.info("ptt up", .{});
                        var cp = try std.ChildProcess.init(&[_][]const u8{ "pacmd", "set-source-volume", source_name, "0" }, alloc);
                        _ = try cp.spawnAndWait();
                    }
                }

                // pacmd set-source-volume 0 65000
                // pacmd set-source-volume 0 0
            }
        }
    }

    return 0;
}

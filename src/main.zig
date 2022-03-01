const std = @import("std");
const c = @cImport({
    @cInclude("linux/input.h");
    @cInclude("linux/uinput.h");
    @cInclude("workaround.h");
});

fn GenThingType(len: usize) type {
    return [len]?[]const u8;
}
fn genThing(comptime len: usize, items: []const []const u8) GenThingType(len) {
    var res: GenThingType(len) = [_]?[]const u8{null} ** len;
    @setEvalBranchQuota(items.len * 8);
    for (items) |item| {
        if (@hasDecl(c, item)) {
            res[@field(c, item)] = item;
        }
    }
    return res;
}

const event_names = genThing(c.EV_MAX + 1, &[_][]const u8{
    "EV_SYN", "EV_REL",       "EV_MSC", "EV_SND",
    "EV_FF",  "EV_FF_STATUS", "EV_KEY", "EV_ABS",
    "EV_LED", "EV_REP",       "EV_PWR", "EV_SW",
});
const key_names = genThing(c.KEY_MAX + 1, &[_][]const u8{
    "KEY_1",                     "KEY_2",                     "KEY_3",                   "KEY_4",                   "KEY_5",                        "KEY_6",
    "KEY_7",                     "KEY_8",                     "KEY_9",                   "KEY_0",                   "KEY_MINUS",                    "KEY_EQUAL",
    "KEY_BACKSPACE",             "KEY_TAB",                   "KEY_Q",                   "KEY_W",                   "KEY_E",                        "KEY_R",
    "KEY_T",                     "KEY_Y",                     "KEY_U",                   "KEY_I",                   "KEY_O",                        "KEY_P",
    "KEY_LEFTBRACE",             "KEY_RIGHTBRACE",            "KEY_ENTER",               "KEY_LEFTCTRL",            "KEY_A",                        "KEY_S",
    "KEY_D",                     "KEY_F",                     "KEY_G",                   "KEY_H",                   "KEY_J",                        "KEY_K",
    "KEY_L",                     "KEY_SEMICOLON",             "KEY_APOSTROPHE",          "KEY_GRAVE",               "KEY_LEFTSHIFT",                "KEY_BACKSLASH",
    "KEY_Z",                     "KEY_X",                     "KEY_C",                   "KEY_V",                   "KEY_B",                        "KEY_N",
    "KEY_M",                     "KEY_COMMA",                 "KEY_DOT",                 "KEY_SLASH",               "KEY_RIGHTSHIFT",               "KEY_KPASTERISK",
    "KEY_LEFTALT",               "KEY_SPACE",                 "KEY_CAPSLOCK",            "KEY_F1",                  "KEY_F2",                       "KEY_F3",
    "KEY_F4",                    "KEY_F5",                    "KEY_F6",                  "KEY_F7",                  "KEY_F8",                       "KEY_F9",
    "KEY_F10",                   "KEY_NUMLOCK",               "KEY_SCROLLLOCK",          "KEY_KP7",                 "KEY_KP8",                      "KEY_KP9",
    "KEY_KPMINUS",               "KEY_KP4",                   "KEY_KP5",                 "KEY_KP6",                 "KEY_KPPLUS",                   "KEY_KP1",
    "KEY_KP2",                   "KEY_KP3",                   "KEY_KP0",                 "KEY_KPDOT",               "KEY_ZENKAKUHANKAKU",           "KEY_102ND",
    "KEY_F11",                   "KEY_F12",                   "KEY_RO",                  "KEY_KATAKANA",            "KEY_HIRAGANA",                 "KEY_HENKAN",
    "KEY_KATAKANAHIRAGANA",      "KEY_MUHENKAN",              "KEY_KPJPCOMMA",           "KEY_KPENTER",             "KEY_RIGHTCTRL",                "KEY_KPSLASH",
    "KEY_SYSRQ",                 "KEY_RIGHTALT",              "KEY_LINEFEED",            "KEY_HOME",                "KEY_UP",                       "KEY_PAGEUP",
    "KEY_LEFT",                  "KEY_RIGHT",                 "KEY_END",                 "KEY_DOWN",                "KEY_PAGEDOWN",                 "KEY_INSERT",
    "KEY_DELETE",                "KEY_MACRO",                 "KEY_MUTE",                "KEY_VOLUMEDOWN",          "KEY_VOLUMEUP",                 "KEY_POWER",
    "KEY_KPEQUAL",               "KEY_KPPLUSMINUS",           "KEY_PAUSE",               "KEY_SCALE",               "KEY_KPCOMMA",                  "KEY_HANGEUL",
    "KEY_HANGUEL",               "KEY_HANJA",                 "KEY_YEN",                 "KEY_LEFTMETA",            "KEY_RIGHTMETA",                "KEY_COMPOSE",
    "KEY_STOP",                  "KEY_AGAIN",                 "KEY_PROPS",               "KEY_UNDO",                "KEY_FRONT",                    "KEY_COPY",
    "KEY_OPEN",                  "KEY_PASTE",                 "KEY_FIND",                "KEY_CUT",                 "KEY_HELP",                     "KEY_MENU",
    "KEY_CALC",                  "KEY_SETUP",                 "KEY_SLEEP",               "KEY_WAKEUP",              "KEY_FILE",                     "KEY_SENDFILE",
    "KEY_DELETEFILE",            "KEY_XFER",                  "KEY_PROG1",               "KEY_PROG2",               "KEY_WWW",                      "KEY_MSDOS",
    "KEY_COFFEE",                "KEY_SCREENLOCK",            "KEY_ROTATE_DISPLAY",      "KEY_DIRECTION",           "KEY_CYCLEWINDOWS",             "KEY_MAIL",
    "KEY_BOOKMARKS",             "KEY_COMPUTER",              "KEY_BACK",                "KEY_FORWARD",             "KEY_CLOSECD",                  "KEY_EJECTCD",
    "KEY_EJECTCLOSECD",          "KEY_NEXTSONG",              "KEY_PLAYPAUSE",           "KEY_PREVIOUSSONG",        "KEY_STOPCD",                   "KEY_RECORD",
    "KEY_REWIND",                "KEY_PHONE",                 "KEY_ISO",                 "KEY_CONFIG",              "KEY_HOMEPAGE",                 "KEY_REFRESH",
    "KEY_EXIT",                  "KEY_MOVE",                  "KEY_EDIT",                "KEY_SCROLLUP",            "KEY_SCROLLDOWN",               "KEY_KPLEFTPAREN",
    "KEY_KPRIGHTPAREN",          "KEY_NEW",                   "KEY_REDO",                "KEY_F13",                 "KEY_F14",                      "KEY_F15",
    "KEY_F16",                   "KEY_F17",                   "KEY_F18",                 "KEY_F19",                 "KEY_F20",                      "KEY_F21",
    "KEY_F22",                   "KEY_F23",                   "KEY_F24",                 "KEY_PLAYCD",              "KEY_PAUSECD",                  "KEY_PROG3",
    "KEY_PROG4",                 "KEY_DASHBOARD",             "KEY_SUSPEND",             "KEY_CLOSE",               "KEY_PLAY",                     "KEY_FASTFORWARD",
    "KEY_BASSBOOST",             "KEY_PRINT",                 "KEY_HP",                  "KEY_CAMERA",              "KEY_SOUND",                    "KEY_QUESTION",
    "KEY_EMAIL",                 "KEY_CHAT",                  "KEY_SEARCH",              "KEY_CONNECT",             "KEY_FINANCE",                  "KEY_SPORT",
    "KEY_SHOP",                  "KEY_ALTERASE",              "KEY_CANCEL",              "KEY_BRIGHTNESSDOWN",      "KEY_BRIGHTNESSUP",             "KEY_MEDIA",
    "KEY_SWITCHVIDEOMODE",       "KEY_KBDILLUMTOGGLE",        "KEY_KBDILLUMDOWN",        "KEY_KBDILLUMUP",          "KEY_SEND",                     "KEY_REPLY",
    "KEY_FORWARDMAIL",           "KEY_SAVE",                  "KEY_DOCUMENTS",           "KEY_BATTERY",             "KEY_BLUETOOTH",                "KEY_WLAN",
    "KEY_UWB",                   "KEY_UNKNOWN",               "KEY_VIDEO_NEXT",          "KEY_VIDEO_PREV",          "KEY_BRIGHTNESS_CYCLE",         "KEY_BRIGHTNESS_AUTO",
    "KEY_BRIGHTNESS_ZERO",       "KEY_DISPLAY_OFF",           "KEY_WWAN",                "KEY_WIMAX",               "KEY_RFKILL",                   "KEY_MICMUTE",
    "BTN_MISC",                  "BTN_0",                     "BTN_1",                   "BTN_2",                   "BTN_3",                        "BTN_4",
    "BTN_5",                     "BTN_6",                     "BTN_7",                   "BTN_8",                   "BTN_9",                        "BTN_MOUSE",
    "BTN_LEFT",                  "BTN_RIGHT",                 "BTN_MIDDLE",              "BTN_SIDE",                "BTN_EXTRA",                    "BTN_FORWARD",
    "BTN_BACK",                  "BTN_TASK",                  "BTN_JOYSTICK",            "BTN_TRIGGER",             "BTN_THUMB",                    "BTN_THUMB2",
    "BTN_TOP",                   "BTN_TOP2",                  "BTN_PINKIE",              "BTN_BASE",                "BTN_BASE2",                    "BTN_BASE3",
    "BTN_BASE4",                 "BTN_BASE5",                 "BTN_BASE6",               "BTN_DEAD",                "BTN_GAMEPAD",                  "BTN_SOUTH",
    "BTN_A",                     "BTN_EAST",                  "BTN_B",                   "BTN_C",                   "BTN_NORTH",                    "BTN_X",
    "BTN_WEST",                  "BTN_Y",                     "BTN_Z",                   "BTN_TL",                  "BTN_TR",                       "BTN_TL2",
    "BTN_TR2",                   "BTN_SELECT",                "BTN_START",               "BTN_MODE",                "BTN_THUMBL",                   "BTN_THUMBR",
    "BTN_DIGI",                  "BTN_TOOL_PEN",              "BTN_TOOL_RUBBER",         "BTN_TOOL_BRUSH",          "BTN_TOOL_PENCIL",              "BTN_TOOL_AIRBRUSH",
    "BTN_TOOL_FINGER",           "BTN_TOOL_MOUSE",            "BTN_TOOL_LENS",           "BTN_TOOL_QUINTTAP",       "BTN_STYLUS3",                  "BTN_TOUCH",
    "BTN_STYLUS",                "BTN_STYLUS2",               "BTN_TOOL_DOUBLETAP",      "BTN_TOOL_TRIPLETAP",      "BTN_TOOL_QUADTAP",             "BTN_WHEEL",
    "BTN_GEAR_DOWN",             "BTN_GEAR_UP",               "KEY_OK",                  "KEY_SELECT",              "KEY_GOTO",                     "KEY_CLEAR",
    "KEY_POWER2",                "KEY_OPTION",                "KEY_INFO",                "KEY_TIME",                "KEY_VENDOR",                   "KEY_ARCHIVE",
    "KEY_PROGRAM",               "KEY_CHANNEL",               "KEY_FAVORITES",           "KEY_EPG",                 "KEY_PVR",                      "KEY_MHP",
    "KEY_LANGUAGE",              "KEY_TITLE",                 "KEY_SUBTITLE",            "KEY_ANGLE",               "KEY_ZOOM",                     "KEY_MODE",
    "KEY_KEYBOARD",              "KEY_SCREEN",                "KEY_PC",                  "KEY_TV",                  "KEY_TV2",                      "KEY_VCR",
    "KEY_VCR2",                  "KEY_SAT",                   "KEY_SAT2",                "KEY_CD",                  "KEY_TAPE",                     "KEY_RADIO",
    "KEY_TUNER",                 "KEY_PLAYER",                "KEY_TEXT",                "KEY_DVD",                 "KEY_AUX",                      "KEY_MP3",
    "KEY_AUDIO",                 "KEY_VIDEO",                 "KEY_DIRECTORY",           "KEY_LIST",                "KEY_MEMO",                     "KEY_CALENDAR",
    "KEY_RED",                   "KEY_GREEN",                 "KEY_YELLOW",              "KEY_BLUE",                "KEY_CHANNELUP",                "KEY_CHANNELDOWN",
    "KEY_FIRST",                 "KEY_LAST",                  "KEY_AB",                  "KEY_NEXT",                "KEY_RESTART",                  "KEY_SLOW",
    "KEY_SHUFFLE",               "KEY_BREAK",                 "KEY_PREVIOUS",            "KEY_DIGITS",              "KEY_TEEN",                     "KEY_TWEN",
    "KEY_VIDEOPHONE",            "KEY_GAMES",                 "KEY_ZOOMIN",              "KEY_ZOOMOUT",             "KEY_ZOOMRESET",                "KEY_WORDPROCESSOR",
    "KEY_EDITOR",                "KEY_SPREADSHEET",           "KEY_GRAPHICSEDITOR",      "KEY_PRESENTATION",        "KEY_DATABASE",                 "KEY_NEWS",
    "KEY_VOICEMAIL",             "KEY_ADDRESSBOOK",           "KEY_MESSENGER",           "KEY_DISPLAYTOGGLE",       "KEY_BRIGHTNESS_TOGGLE",        "KEY_SPELLCHECK",
    "KEY_LOGOFF",                "KEY_DOLLAR",                "KEY_EURO",                "KEY_FRAMEBACK",           "KEY_FRAMEFORWARD",             "KEY_CONTEXT_MENU",
    "KEY_MEDIA_REPEAT",          "KEY_10CHANNELSUP",          "KEY_10CHANNELSDOWN",      "KEY_IMAGES",              "KEY_DEL_EOL",                  "KEY_DEL_EOS",
    "KEY_INS_LINE",              "KEY_DEL_LINE",              "KEY_FN",                  "KEY_FN_ESC",              "KEY_FN_F1",                    "KEY_FN_F2",
    "KEY_FN_F3",                 "KEY_FN_F4",                 "KEY_FN_F5",               "KEY_FN_F6",               "KEY_FN_F7",                    "KEY_FN_F8",
    "KEY_FN_F9",                 "KEY_FN_F10",                "KEY_FN_F11",              "KEY_FN_F12",              "KEY_FN_1",                     "KEY_FN_2",
    "KEY_FN_D",                  "KEY_FN_E",                  "KEY_FN_F",                "KEY_FN_S",                "KEY_FN_B",                     "KEY_BRL_DOT1",
    "KEY_BRL_DOT2",              "KEY_BRL_DOT3",              "KEY_BRL_DOT4",            "KEY_BRL_DOT5",            "KEY_BRL_DOT6",                 "KEY_BRL_DOT7",
    "KEY_BRL_DOT8",              "KEY_BRL_DOT9",              "KEY_BRL_DOT10",           "KEY_NUMERIC_0",           "KEY_NUMERIC_1",                "KEY_NUMERIC_2",
    "KEY_NUMERIC_3",             "KEY_NUMERIC_4",             "KEY_NUMERIC_5",           "KEY_NUMERIC_6",           "KEY_NUMERIC_7",                "KEY_NUMERIC_8",
    "KEY_NUMERIC_9",             "KEY_NUMERIC_STAR",          "KEY_NUMERIC_POUND",       "KEY_NUMERIC_A",           "KEY_NUMERIC_B",                "KEY_NUMERIC_C",
    "KEY_NUMERIC_D",             "KEY_CAMERA_FOCUS",          "KEY_WPS_BUTTON",          "KEY_TOUCHPAD_TOGGLE",     "KEY_TOUCHPAD_ON",              "KEY_TOUCHPAD_OFF",
    "KEY_CAMERA_ZOOMIN",         "KEY_CAMERA_ZOOMOUT",        "KEY_CAMERA_UP",           "KEY_CAMERA_DOWN",         "KEY_CAMERA_LEFT",              "KEY_CAMERA_RIGHT",
    "KEY_ATTENDANT_ON",          "KEY_ATTENDANT_OFF",         "KEY_ATTENDANT_TOGGLE",    "KEY_LIGHTS_TOGGLE",       "BTN_DPAD_UP",                  "BTN_DPAD_DOWN",
    "BTN_DPAD_LEFT",             "BTN_DPAD_RIGHT",            "KEY_ALS_TOGGLE",          "KEY_ROTATE_LOCK_TOGGLE",  "KEY_BUTTONCONFIG",             "KEY_TASKMANAGER",
    "KEY_JOURNAL",               "KEY_CONTROLPANEL",          "KEY_APPSELECT",           "KEY_SCREENSAVER",         "KEY_VOICECOMMAND",             "KEY_ASSISTANT",
    "KEY_BRIGHTNESS_MIN",        "KEY_BRIGHTNESS_MAX",        "KEY_KBDINPUTASSIST_PREV", "KEY_KBDINPUTASSIST_NEXT", "KEY_KBDINPUTASSIST_PREVGROUP", "KEY_KBDINPUTASSIST_NEXTGROUP",
    "KEY_KBDINPUTASSIST_ACCEPT", "KEY_KBDINPUTASSIST_CANCEL", "KEY_RIGHT_UP",            "KEY_RIGHT_DOWN",          "KEY_LEFT_UP",                  "KEY_LEFT_DOWN",
    "KEY_ROOT_MENU",             "KEY_MEDIA_TOP_MENU",        "KEY_NUMERIC_11",          "KEY_NUMERIC_12",          "KEY_AUDIO_DESC",               "KEY_3D_MODE",
    "KEY_NEXT_FAVORITE",         "KEY_STOP_RECORD",           "KEY_PAUSE_RECORD",        "KEY_VOD",                 "KEY_UNMUTE",                   "KEY_FASTREVERSE",
    "KEY_SLOWREVERSE",           "KEY_DATA",                  "KEY_ONSCREEN_KEYBOARD",   "BTN_TRIGGER_HAPPY",       "BTN_TRIGGER_HAPPY1",           "BTN_TRIGGER_HAPPY2",
    "BTN_TRIGGER_HAPPY3",        "BTN_TRIGGER_HAPPY4",        "BTN_TRIGGER_HAPPY5",      "BTN_TRIGGER_HAPPY6",      "BTN_TRIGGER_HAPPY7",           "BTN_TRIGGER_HAPPY8",
    "BTN_TRIGGER_HAPPY9",        "BTN_TRIGGER_HAPPY10",       "BTN_TRIGGER_HAPPY11",     "BTN_TRIGGER_HAPPY12",     "BTN_TRIGGER_HAPPY13",          "BTN_TRIGGER_HAPPY14",
    "BTN_TRIGGER_HAPPY15",       "BTN_TRIGGER_HAPPY16",       "BTN_TRIGGER_HAPPY17",     "BTN_TRIGGER_HAPPY18",     "BTN_TRIGGER_HAPPY19",          "BTN_TRIGGER_HAPPY20",
    "BTN_TRIGGER_HAPPY21",       "BTN_TRIGGER_HAPPY22",       "BTN_TRIGGER_HAPPY23",     "BTN_TRIGGER_HAPPY24",     "BTN_TRIGGER_HAPPY25",          "BTN_TRIGGER_HAPPY26",
    "BTN_TRIGGER_HAPPY27",       "BTN_TRIGGER_HAPPY28",       "BTN_TRIGGER_HAPPY29",     "BTN_TRIGGER_HAPPY30",     "BTN_TRIGGER_HAPPY31",          "BTN_TRIGGER_HAPPY32",
    "BTN_TRIGGER_HAPPY33",       "BTN_TRIGGER_HAPPY34",       "BTN_TRIGGER_HAPPY35",     "BTN_TRIGGER_HAPPY36",     "BTN_TRIGGER_HAPPY37",          "BTN_TRIGGER_HAPPY38",
    "BTN_TRIGGER_HAPPY39",       "BTN_TRIGGER_HAPPY40",
});

fn typename(typev: u16) []const u8 {
    if (typev > event_names.len) return "";
    return event_names[typev] orelse "";
}

fn codename(typev: u16, codev: u16) []const u8 {
    _ = typev;
    if (codev > key_names.len) return "";
    return key_names[codev] orelse "";
}

fn ioctl_read(fd: std.os.fd_t, request: u32, comptime ResT: type) !ResT {
    var res: ResT = undefined;
    try ioctl_write(fd, request, @ptrToInt(&res));
    return res;
}
fn ioctl_write(fd: std.os.fd_t, request: u32, value: usize) !void {
    while (true) {
        switch (std.os.errno(std.os.system.ioctl(fd, @intCast(c_int, request), value))) {
            .SUCCESS => break,
            .INTR => continue,
            else => return error.Error,
        }
    }
}
fn ioctl_trigger(fd: std.os.fd_t, request: u32) !void {
    return ioctl_write(fd, request, 0);
}

fn inputEvent(typev: u16, codev: u16, value: i32) c.struct_input_event {
    return c.struct_input_event{
        .time = undefined,
        .@"type" = typev,
        .code = codev,
        .value = value,
    };
}

const Shared = struct {
    enabled_lock: *std.Thread.Mutex,
    write_lock: *std.Thread.Mutex,
    writer: *const std.fs.File.Writer,
    lmb_active: *bool,
    rmb_active: *bool,
    timer_enabled: *bool,
};

pub fn timerThread(shared: Shared) !void {
    while (true) {
        shared.enabled_lock.lock();
        shared.enabled_lock.unlock();

        std.time.sleep(50 * std.time.ns_per_ms); // roughly 20 times a second

        shared.write_lock.lock();
        defer shared.write_lock.unlock();

        if (shared.timer_enabled.* and shared.lmb_active.*) {
            try shared.writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, c.BTN_LEFT, 1)));
            try shared.writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_SYN, c.SYN_REPORT, 0)));
            try shared.writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, c.BTN_LEFT, 0)));
            try shared.writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_SYN, c.SYN_REPORT, 0)));
        }
        if (shared.timer_enabled.* and shared.rmb_active.*) {
            try shared.writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, c.BTN_RIGHT, 1)));
            try shared.writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_SYN, c.SYN_REPORT, 0)));
            try shared.writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, c.BTN_RIGHT, 0)));
            try shared.writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_SYN, c.SYN_REPORT, 0)));
        }
    }
}

pub fn main() !void {
    std.log.info("Mousebuttons is starting", .{});
    var arena_alloc = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_alloc.deinit();

    const alloc = arena_alloc.allocator();

    // WRITER
    // huh this seems to be openable without root, interesting
    const file = std.fs.cwd().openFile("/dev/uinput", .{ .mode = .write_only, .lock_nonblocking = true }) catch |e| switch (e) {
        error.AccessDenied => {
            return std.log.err("This program requires root access to run.", .{});
        },
        else => {
            return std.log.err("Could not open /dev/uinput. {}", .{e});
        },
    };
    defer file.close();

    const writer = file.writer();

    // TODO::
    // read first
    // copy supported bits from read device
    // https://github.com/freedesktop-unofficial-mirror/evtest/blob/b8343ec1124da18bdabcc04809a8731b9e39295d/evtest.c#L995
    try ioctl_write(file.handle, c.UI_SET_EVBIT, c.EV_SYN);

    try ioctl_write(file.handle, c.UI_SET_EVBIT, c.EV_MSC);
    try ioctl_write(file.handle, c.UI_SET_MSCBIT, c.MSC_SCAN);

    try ioctl_write(file.handle, c.UI_SET_EVBIT, c.EV_KEY);
    try ioctl_write(file.handle, c.UI_SET_KEYBIT, c.BTN_LEFT); // !
    try ioctl_write(file.handle, c.UI_SET_KEYBIT, c.BTN_RIGHT); // !
    try ioctl_write(file.handle, c.UI_SET_KEYBIT, c.BTN_MIDDLE); // !
    try ioctl_write(file.handle, c.UI_SET_KEYBIT, 279);
    try ioctl_write(file.handle, c.UI_SET_KEYBIT, 280);
    try ioctl_write(file.handle, c.UI_SET_KEYBIT, c.KEY_UNKNOWN); // !
    try ioctl_write(file.handle, c.UI_SET_KEYBIT, c.KEY_VOLUMEUP); // !
    try ioctl_write(file.handle, c.UI_SET_KEYBIT, c.KEY_VOLUMEDOWN); // !

    try ioctl_write(file.handle, c.UI_SET_EVBIT, c.EV_REL);
    try ioctl_write(file.handle, c.UI_SET_RELBIT, c.REL_X);
    try ioctl_write(file.handle, c.UI_SET_RELBIT, c.REL_Y);
    try ioctl_write(file.handle, c.UI_SET_RELBIT, c.REL_HWHEEL); // 6
    try ioctl_write(file.handle, c.UI_SET_RELBIT, c.REL_WHEEL); // 8
    try ioctl_write(file.handle, c.UI_SET_RELBIT, 11); // REL_WHEEL_HI_RES
    try ioctl_write(file.handle, c.UI_SET_RELBIT, 12); // REL_HWHEEL_HI_RES

    // TODO copy from read device
    var usetup = std.mem.zeroes(c.struct_uinput_setup);
    usetup.id.bustype = c.BUS_USB;
    usetup.id.vendor = 0x046d;
    usetup.id.product = 0xc08b;
    usetup.id.version = 0x111;
    std.mem.copy(u8, &usetup.name, "mousebuttons Virtual Input");

    try ioctl_write(file.handle, c.UI_DEV_SETUP_2, @ptrToInt(&usetup));
    try ioctl_trigger(file.handle, c.UI_DEV_CREATE);
    defer ioctl_trigger(file.handle, c.UI_DEV_DESTROY) catch @panic("could not destroy");

    const args = try std.process.argsAlloc(alloc);
    if (args.len != 2) return std.log.err("Usage: `sudo mousebuttons /dev/input/eventXX`", .{});

    // READER
    const readfile = std.fs.cwd().openFile(args[1], .{}) catch |e| switch (e) {
        error.AccessDenied => {
            return std.log.err("This program requires root access to run.", .{});
        },
        else => {
            return std.log.err("Could not open {s}. {}", .{ args[1], e });
        },
    };
    defer readfile.close();

    try ioctl_write(readfile.handle, c.EVIOCGRAB, 1); // grab
    defer ioctl_write(readfile.handle, c.EVIOCGRAB, 0) catch @panic("could not ungrab");

    const reader = readfile.reader();

    // stuff
    var btn_state = false;
    var thbd_state = false;
    var timer_enabled = false; // for repeating mouse events on a short timer (eg 20/sec or something)
    // var timer = try std.time.Timer.start();

    var ignore_next = [_]bool{false} ** 3;
    var ignore_next_rpl_up = false;

    var write_lock = std.Thread.Mutex{};
    var lmb_active = false;
    var rmb_active = false;

    var enabled_lock = std.Thread.Mutex{};

    enabled_lock.lock();
    var enabled_lock_held: bool = true;

    const timer_shared = Shared{
        .write_lock = &write_lock,
        .enabled_lock = &enabled_lock,
        .writer = &writer,
        .lmb_active = &lmb_active,
        .rmb_active = &rmb_active,
        .timer_enabled = &timer_enabled,
    };
    const timer_thread = try std.Thread.spawn(.{}, timerThread, .{timer_shared});
    defer timer_thread.join(); // not necessary

    std.log.info("Waiting for X to find new device…", .{});
    std.time.sleep(100 * std.time.ns_per_ms); // TODO use x functions to detect on mouse connects

    std.log.info("Configuring mouse opts…", .{}); // TODO copy props from source device using x functions directly
    var configurator = try std.ChildProcess.init(&.{"xinput", "set-prop", "pointer:mousebuttons Virtual Input", "libinput Accel Profile Enabled", "0", "1"}, alloc);
    const res = try configurator.spawnAndWait();
    if(res != .Exited or res.Exited != 0) {
        std.log.err("E COULD NOT CONFIGURE MOUSE. {any}", .{res});
        std.process.exit(1);
    }
    std.log.info("Mousebuttons is running", .{});

    while (true) {
        var events = [_]c.struct_input_event{undefined} ** 64;
        const read_count = try reader.read(std.mem.sliceAsBytes(events[0..]));
        if (read_count % @sizeOf(c.struct_input_event) != 0) {
            @panic("bad read");
        }
        var wlpi: usize = 0;
        wlp: while (wlpi < read_count / @sizeOf(c.struct_input_event)) : (wlpi += 1) {
            write_lock.lock();
            write_lock.unlock();

            // timer.reset();
            // defer std.log.info("{}", .{timer.read()});
            var event = events[wlpi];
            if (event.@"type" == c.EV_REL and thbd_state) {
                if (event.code == 11) continue;
                if (event.code == c.REL_WHEEL) {
                    try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, if (event.value == 1) c.KEY_VOLUMEUP else c.KEY_VOLUMEDOWN, 1)));
                    try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_SYN, c.SYN_REPORT, 0)));
                    try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, if (event.value == 1) c.KEY_VOLUMEUP else c.KEY_VOLUMEDOWN, 0)));
                    continue;
                }
            }
            if (event.@"type" == c.EV_KEY) {
                if (event.code == 282) { // button 10
                    btn_state = event.value == 1;
                    continue;
                }
                if (event.code == 278) { // button 6
                    thbd_state = event.value == 1;
                    continue;
                }
                if (event.code == 277) { // button 5
                    timer_enabled = event.value == 1;
                    if (timer_enabled) {
                        if (enabled_lock_held) {
                            enabled_lock.unlock();
                            enabled_lock_held = false;
                        }
                    } else {
                        if (!enabled_lock_held) {
                            enabled_lock.lock();
                            enabled_lock_held = true;
                        }
                    }
                    if (timer_enabled and lmb_active) {
                        try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, c.BTN_LEFT, 0)));
                    }
                    if (timer_enabled and rmb_active) {
                        try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, c.BTN_RIGHT, 0)));
                    }
                    continue;
                }
                if (event.code == 280) { // button 8
                    try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, c.KEY_UNKNOWN, event.value)));
                    continue;
                }
                inline for (.{ .{ c.BTN_LEFT, 9001 }, .{ c.BTN_RIGHT, 9002 }, .{ c.BTN_MIDDLE, 9003 } }) |btninfo, i| {
                    const button = btninfo[0];
                    const scancode = btninfo[1];
                    if (event.code == button) {
                        if (ignore_next[i] and event.value == 0) {
                            ignore_next[i] = false;
                            continue :wlp;
                        }
                        if (btn_state and event.value == 1) {
                            ignore_next[i] = true;
                            try writer.writeAll(&std.mem.toBytes(event));
                            try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_SYN, c.SYN_REPORT, 0)));
                            try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_MSC, c.MSC_SCAN, scancode)));
                            try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, button, 0)));
                            continue :wlp;
                        }
                    }
                }
                if (event.code == c.BTN_LEFT) {
                    lmb_active = event.value == 1;
                    try writer.writeAll(&std.mem.toBytes(event));
                    if (timer_enabled and event.value == 1) {
                        try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_SYN, c.SYN_REPORT, 0)));
                        try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, c.BTN_LEFT, 0)));
                        // huh there's a chance for a missed syn_report here because of multithreading
                    }
                    continue;
                }
                if (event.code == c.BTN_RIGHT) {
                    rmb_active = event.value == 1;
                    try writer.writeAll(&std.mem.toBytes(event));
                    if (timer_enabled and event.value == 1) {
                        try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_SYN, c.SYN_REPORT, 0)));
                        try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, c.BTN_RIGHT, 0)));
                        // huh there's a chance for a missed syn_report here because of multithreading
                    }
                    continue;
                }
                if (event.code == 279) { // button 7
                    if (ignore_next_rpl_up and event.value == 0) {
                        ignore_next_rpl_up = false;
                        continue;
                    }
                    try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, c.BTN_LEFT, event.value)));
                    try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, c.BTN_RIGHT, event.value)));
                    try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_SYN, c.SYN_REPORT, 0)));
                    if (btn_state and event.value == 1) {
                        try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, c.BTN_LEFT, 0)));
                        try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_KEY, c.BTN_RIGHT, 0)));
                        try writer.writeAll(&std.mem.toBytes(inputEvent(c.EV_SYN, c.SYN_REPORT, 0)));
                    }
                    continue;
                }
                // if left down
                // send event
                // send up event
                // ignore next left up event
                // if right down
                // send event
                // send up event
                // ignore next right up event
            }
            // if (event.@"type" == c.BTN_LEFT)
            try writer.writeAll(&std.mem.toBytes(event));

            // if (event.@"type" == c.EV_SYN) switch (event.code) {
            //     c.SYN_MT_REPORT => std.log.info("++++++++++++++ {}, {} ++++++++++++", .{ typename(event.@"type"), event.code }),
            //     c.SYN_DROPPED => std.log.info(">>>>>>>>>>>>>> {}, {} <<<<<<<<<<<<", .{ typename(event.@"type"), event.code }),
            //     else => std.log.info("-------------- {}, {} ------------", .{ typename(event.@"type"), event.code }),
            // } else {
            //     std.log.info("type {}, code {}, value {}", .{ typename(event.@"type"), codename(event.@"type", event.@"code"), event.@"value" });
            // }
        }
    }

    // https://github.com/freedesktop-unofficial-mirror/evtest/blob/b8343ec1124da18bdabcc04809a8731b9e39295d/evtest.c#L1092
    // ioctl(fd, EVIOCGRAB, 1)
}

const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    {
        const exe = b.addExecutable("mousebuttons", "src/main.zig");
        exe.setTarget(target);
        exe.setBuildMode(mode);
        exe.linkLibC();
        exe.addIncludeDir("src/");
        exe.install();

        const run_cmd = exe.run();
        run_cmd.step.dependOn(&exe.install_step.?.step);
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }

        const exe_step = b.step("mousebuttons", "Build mousebuttons");
        exe_step.dependOn(&exe.install_step.?.step);
        const run_step = b.step("run-mousebuttons", "Run mousebuttons");
        run_step.dependOn(&run_cmd.step);
    }

    {
        const exe = b.addExecutable("key", "src/key.zig");
        exe.setTarget(target);
        exe.setBuildMode(mode);
        exe.linkLibC();
        exe.linkSystemLibrary("X11");
        exe.linkSystemLibrary("Xi");
        exe.install();

        const run_cmd = exe.run();
        run_cmd.step.dependOn(&exe.install_step.?.step);
        if(b.args) |args| {
            run_cmd.addArgs(args);
        }

        const exe_step = b.step("key", "Build key");
        exe_step.dependOn(&exe.install_step.?.step);
        const run_step = b.step("run-key", "Run key");
        run_step.dependOn(&run_cmd.step);
    }
}

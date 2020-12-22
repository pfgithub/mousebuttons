:: a program to allow mouse button chording. eg when you press a thumb button and scroll, change the volume. or when you press a thumb button and click, make the click release instantly. also allows configuring buttons such as setting a button to both left click and right click at the same time.

usage: edit src/main.zig to reference the right `/dev/input` file and configure stuff then `zig build -Drelease-fast && sudo zig-cache/bin/mousebutton` then `systemsettings5` and search `mouse` and toggle on a setting, apply, toggle it off, apply again. it now works.

performance: doesn't noticably impact things. a debug build was like 0.01ms or something. to test, disable mouse grabbing and evtest both event files at once, then check the difference in times. note that this will cause every mouse event you make to happen double so be careful while this is running.

developing: use evtest and stuff

usage:

- find your mouse in `xinput`
- use `xinput --list-props deviceid`
- find "Device Node (276). that is the dev input file for the mouse.
- `sudo mousebuttons /dev/input/eventXX`
- `systemsettings5 mouse`
- toggle someting on and back off and apply both times

TODO:

- detect mouse
- detect and copy bits (https://github.com/freedesktop-unofficial-mirror/evtest/blob/b8343ec1124da18bdabcc04809a8731b9e39295d/evtest.c#L996)
- fix speed by default (don't require going into systemsettings5 to fix the mouse speed)

long term:

- config? eg `src/config`
- keyboard too? for global hotkeys (not sure how to listen for two events at once though)
- button scroll emulation like the x one but actually working?
- x active window detection

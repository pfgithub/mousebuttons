## mousebuttons:

:: a program to allow mouse button chording. eg when you press a thumb button and scroll, change the volume. or when you press a thumb button and click, make the click release instantly. also allows configuring buttons such as setting a button to both left click and right click at the same time.

usage:

- edit src/main.zig to do the chording you want
- `zig build mousebuttons`
- find your mouse in `xinput`
  - make your terminal window bigger so it doesn't wrap. it's split into nice
    columns then.
  - look under "Virtual Core Pointer"
  - ignore items labeled "Consumer Control"
- use `xinput --list-props deviceid`
- find "Device Node (276). that is the dev input file for the mouse.
- `sudo zig-out/bin/mousebuttons /dev/input/eventXX`
- `xinput set-prop 'pointer:mousebuttons Virtual Input' 'libinput Accel Profile Enabled' '0' '1'` (or set it to match the same values as your previous mouse)
  - TODO: consider automatically copying xinput props from the starting mouse
  - NOTE: the above does not work on one of my computers for some reason. I still have to do that `systemsettings5` toggle mouse acceleration between 'accelerated' and 'flat'. TODO: figure out what's wrong

performance: doesn't noticably impact things. a debug build was like 0.01ms or something. to test, disable mouse grabbing and evtest both event files at once, then check the difference in times. note that this will cause every mouse event you make to happen double so be careful while this is running.

developing: use evtest and stuff

TODO:

- detect mouse
- detect and copy bits (https://github.com/freedesktop-unofficial-mirror/evtest/blob/b8343ec1124da18bdabcc04809a8731b9e39295d/evtest.c#L996)
- fix speed by default (don't require going into systemsettings5 to fix the mouse speed)

long term:

- config? eg `src/config`
- keyboard too? for global hotkeys (not sure how to listen for two events at once though)
- button scroll emulation like the x one but actually working?
- x active window detection

## key:

a program to run other programs when certain global hotkeys are pressed

usage:

- edit src/key.zig to do the things you want
- `zig build run-key`

performance: not tested yet

TODO:

- send fake keypresses
- block keypresses (glhf)
- watch the active window
- preferrably do those above things with `/dev/input` instead of through X
- although some things need x like moving the mouse to specific coordinates

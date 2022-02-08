const mb = @import("mousebuttons.zig");

// button names
// left: 1 (code c.BTN_LEFT) (scancode 9001)
// right: 3 (code c.BTN_RIGHT) (scancode 9002)
// middle: 2 (code c.BTN_MIDDLE) (scancode 9003)
// index_fwd: 7 (code 279)
// index_back: 8 (code 280)
// thumb_fwd: 5 (code 277)
// thumb_back: 6 (code 278)
// thumb_pick: 10 (code 282)

var thumb_back_held: bool = false;
var thumb_pick_held: bool = false;

// huh. should we wait for a sync event?
// then onEvent would be []mb.Event
// that would be a bit harder to handle and probably
// not worth it
pub fn onEvent(event: mb.Event) mb.AndSync {
    mb.trackAuto(event, thumb_back, &thumb_back_held);
    mb.trackAuto(event, thumb_pick, &thumb_pick_held);

    switch(event.type) {
        .rel => {
            if(thumb_back_held) {
                const key = if(event.value == 1) KEY_VOLUMEUP else KEY_VOLUMEDOWN;
		mb.emit(mb.keypress(key, .down);
		mb.sync();
		mb.emit(mb.keypress(key, .up);
		return mb.andSync();
	    }
	},
        .key => {
	    if(event.code == thumb_fwd) {
		// TODO repeat
	    }
	    if(event.code == index_back) {
		mb.emit(mb.keypress(KEY_UNKNOWN, event.direction));
		return mb.andSync();
	    }
	    // for(left, middle, right, index_fwd) |btn|
	    //    note: make sure to handle index_fwd as emitting left and right
	    //       rather than emitting some weird button
	    //    if(event.dir == .up && ignore_next[btn]) 
	    //       ignore_next[x] = false;
	    //       return andSync();
	    //    if(event.dir == .down && thumb_pick_held)
	    //       ignore_next[x] = true;
	    //       emit(event, .down);
	    //       sync();
	    //       emit(event, .up)
	    //       return andSync();
	    //    emit(evt)
	    //    return
	}
    };

    mb.emit(event);
    return mb.andSync();
}

// gui configuration utility version:
// layers: (priority is either most recent activated or top to bottom)
// - pick_held:
//   - left: pressAndRelease(left)
//   - middle: pressAndRelease(middle)
//   - right: pressAndRelease(right)
//   - thumb_fwd → pressAndRelease(left, right)
// - thumb_back_held:
//   - scroll_down_tick → volumedownbtn_down sync volumedownbtn_up
//   - scroll_up_tick → volumeupbtn_down sync volumeupbtn_up
// - thumb_fwd_held:
//   - left: autoclicker(left, 100)
//   - middle: autoclicker(middle, 100)
//   - right: autoclicker(right, 100)
//   - thumb_fwd: autoclicker(left right, 100)
// scenes:
// - main:
//   - left: press(left)
//   - right: press(right)
//   - middle: press(middle)
//   - thumb_fwd: press(left, right)
//   - pick: holdLayer(pick_held)
//   - thumb_back: holdLayer(thumb_back_held)
//   - index_back: press(keyptt)
//   - thumb_fwd: holdLayer(thumb_fwd_held)
//
// ok I think this is the most promising one we have
// it should handle the edge cases like if you start autoclicking while
// already holding the left button or if you start picking while already
// holding the left button … automatically
//
// this is basically steam input
// no wonder steam input is so good
//
// wow this is a good idea I think

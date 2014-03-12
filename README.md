AnimatedMetronome
=================

This class implements an animated and interactive virtual metronome.

This class is in charge of:

1) Multilayer image incorporation to the view.
2) Generate the typical metronome animation. Update the bar position using scheduledMethod
3) Detect and understand the touching event.
4) After a touch event, update the new tempo.

The touch event for controlling the tempo of the metronome is draging the finger on the screen. An upward draggin will increase the tempo and a downward dragging will decrease the tempo.

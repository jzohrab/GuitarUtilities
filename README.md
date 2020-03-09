# GuitarUtilities

## find_note.rb

Midi only tested on OSX.

`bundle install` to install Gems

*IMPORTANT* open GarageBand before running this!

## quicktime.rb

Will only work on OSX.

The following will play the current Quicktime video, starting at 11s,
looping at 13 s, play at a rate of 0.2x normal:

```
$ ruby quicktime.rb -s 11 -e 13 -r 0.2
```

After this, you're shown a menu:

```
Menu: s)tart, d)uration, r)ate, p)lay, l)oop, q)uit
```

and can hit a key to choose to edit the s)tart, d)uration, or r)ate, to
p)lay the clip, to l)oop it until you hit Ctrl-C, or q)uit.

### Example

Below is an example session, showing how I narrow down the section I
want to work on from the current location in the video:

```
MacBook-Air:Utilities jeff$ ruby quicktime.rb -d 2 -r 1
Clip: start: 13.51, duration: 2.0, rate: 1.0
[=> the clip is played here.  Note 13.51 was obtained from the video]

Menu: s)tart, d)uration, r)ate, p)lay, l)oop, q)uit
s
Clip: start: 13.51, duration: 2.0, rate: 1.0
Enter new start: 14.5
Clip: start: 14.5, duration: 2.0, rate: 1.0
[=> clip played with new start point]

Menu: s)tart, d)uration, r)ate, p)lay, l)oop, q)uit
s
Clip: start: 14.5, duration: 2.0, rate: 1.0
Enter new start: 14.7
Clip: start: 14.7, duration: 2.0, rate: 1.0
[=> clip played with new start point]

Menu: s)tart, d)uration, r)ate, p)lay, l)oop, q)uit
d
Clip: start: 14.7, duration: 2.0, rate: 1.0
Enter new duration: 1
Clip: start: 14.7, duration: 1.0, rate: 1.0
[=> clip played with new duration]

Menu: s)tart, d)uration, r)ate, p)lay, l)oop, q)uit
r
Clip: start: 14.7, duration: 1.0, rate: 1.0
Enter new rate: 0.5
Clip: start: 14.7, duration: 1.0, rate: 0.5
[=> clip played with new playback rate]

Menu: s)tart, d)uration, r)ate, p)lay, l)oop, q)uit
l
Hit Ctrl-C to stop loop
[=> clip loops]
^CQuitting

Menu: s)tart, d)uration, r)ate, p)lay, l)oop, q)uit
q
Quitting
```

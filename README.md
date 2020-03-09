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

Below is an example session, showing how I narrow down the section I
want to work on from the current location in the video:

```
$ ruby quicktime.rb -d 2 -r 0.5
Clip: start: 42.06, duration: 2.0, rate: 0.5
# (note the 42.06 was obtained from the video)

Menu: s)tart, d)uration, r)ate, p)lay, l)oop, q)uit
Enter start: 41.5
Clip: start: 41.5, duration: 2.0, rate: 0.5
# (clip plays)

Menu: s)tart, d)uration, r)ate, p)lay, l)oop, q)uit
Enter duration: 1
Clip: start: 41.5, duration: 1.0, rate: 0.5
# (clip plays)

Menu: s)tart, d)uration, r)ate, p)lay, l)oop, q)uit
Enter rate: 0.25
Clip: start: 41.5, duration: 1.0, rate: 0.25
# (clip plays)

Menu: s)tart, d)uration, r)ate, p)lay, l)oop, q)uit
Hit Ctrl-C to stop loop
# (clip plays)
^CQuitting

Menu: s)tart, d)uration, r)ate, p)lay, l)oop, q)uit
Quitting
```
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

You can then update the clip using a menu, replay, loop, etc.  See the
Example.


### Example

Below is an example session, showing how I narrow down the section I
want to work on from the current location in the video:

```
MacBook-Air:Utilities jeff$ ruby quicktime.rb -d 2 -r 1
Clip: start: 13.51, duration: 2.0, rate: 1.0
[the clip is played here.  Note 13.51 was obtained from the video]

Enter option (sdrucplq?): ?
Options:
 s: edit start
 d: edit duration
 r: edit rate
 u: update start to current position
 c: print clip settings
 p: play clip
 l: loop clip
 q: quit
 ?: show menu

Enter option (sdrucplq?): s
Enter new start: 14.5

Enter option (sdrucplq?): p
Clip: start: 14.5, duration: 2.0, rate: 1.0
[The clip is played with the above settings]

Enter option (sdrucplq?): s
Enter new start: 14.7

Enter option (sdrucplq?): d
Enter new duration: 1

Enter option (sdrucplq?): p
Clip: start: 14.7, duration: 1.0, rate: 1.0
[The clip is played with the above settings]

Enter option (sdrucplq?): r
Enter new rate: 0.5

Enter option (sdrucplq?): p
Clip: start: 14.7, duration: 1.0, rate: 0.5
[The clip is played with the above settings]

Enter option (sdrucplq?): l
Hit Ctrl-C to stop loop
[The clip is loop with the above settings]
......^C

Enter option (sdrucplq?): q
Quitting ...

```

# GuitarUtilities

## find_note.rb

Midi only tested on OSX.

`bundle install` to install Gems

*IMPORTANT* open GarageBand before running this!

## quicktime.rb

Will only work on OSX.

The following will play the current Quicktime video, starting at 11s,
looping at 13 s, play at a rate of 0.2x normal, and will loop 4 times
before stopping.

```
$ ruby quicktime.rb -s 11 -e 13 -r 0.2 -n 4
```
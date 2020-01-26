# Apple script to control QuickTime, set the current video time and playback rate.
# Perhaps useful for transcription.

t=$1
cmd="tell application \"QuickTime Player\" to set current time of document 1 to $t"
echo $cmd
osascript -e "$cmd"
osascript -e 'tell application "QuickTime Player" to set rate of document 1 to 0.5'

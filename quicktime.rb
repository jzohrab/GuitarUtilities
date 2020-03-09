# Apple script to control QuickTime, set the current video time and playback rate.
# Perhaps useful for transcription.

require 'optparse'

######################################
# Options

# Return a hash describing the options.
def parse_args(args)
  options = {
    :speed => 0.5,
    :count => 5
  }

  opt_parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} [options]"

    opts.separator ""
    opts.separator "Data options:"
    opts.on("-s T", Float, "Start time") do |t|
      options[:start] = t
    end
    opts.on("-e T", Float, "End time") do |t|
      options[:end] = t
    end
    opts.on("-r R", Float, "Rate (e.g. 0.5)") do |s|
      options[:rate] = s
    end
    opts.on("-l L", Float, "Loop length") do |s|
      options[:loop] = s
    end
    opts.on("-n N", Integer, "Loop count") do |n|
      options[:count] = n
    end
    
    opts.separator ""
    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end
  end

  opt_parser.parse!(args)
  options
end


######################################

def set_quicktime(option, value)
  cmd = "osascript -e 'tell application \"QuickTime Player\" to set #{option} of document 1 to #{value}'"
  # puts cmd
  `#{cmd}`
end

# Play the clip, then stop
def play_clip(clip)
  set_quicktime("current time", clip[:start])
  set_quicktime("rate", clip[:rate])
  Kernel.sleep(clip[:duration])
  set_quicktime("rate", 0)
end

class CtrlCException < StandardError
end

######################################
# MAIN

trap("SIGINT") { raise CtrlCException.new() }
options = parse_args(ARGV)

clip = {
  start: options[:start],
  duration: 5,
  rate: options[:rate]
}

if !options[:end].nil? then
  clip[:duration] = ((options[:end] - options[:start])/options[:rate]).to_f
end

begin
  options[:count].times.each do |i|
    puts "Repetition #{i + 1}"
    play_clip(clip)
  end
rescue CtrlCException => e
  puts "Quitting"
ensure
  set_quicktime("rate", 0)
end

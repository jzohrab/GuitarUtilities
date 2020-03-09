# Apple script to control QuickTime, set the current video time and playback rate.
# Perhaps useful for transcription.

require 'optparse'

######################################
# Options

# Return a hash describing the options.
def parse_args(args)
  options = {
    :start => get_quicktime("time").to_f,
    :rate => 0.5,
    :duration => 5,
    :count => 5
  }

  opt_parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} [options]"

    opts.separator ""
    opts.separator "Data options:"
    opts.on("-s T", Float, "Start time (default to current player time)") do |t|
      options[:start] = t
    end
    opts.on("-e T", Float, "End time") do |t|
      options[:end] = t
    end
    opts.on("-d T", Float, "Duration") do |t|
      options[:duration] = t
    end
    opts.on("-r R", Float, "Rate (e.g. 0.5)") do |s|
      options[:rate] = s
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
# Quicktime

def get_quicktime(option)
  cmd = "osascript -e 'tell application \"QuickTime Player\" to get #{option} of document 1'"
  ret = `#{cmd}`.strip
  # puts "GOT #{option}: #{ret}"
  ret
end

def set_quicktime(option, value)
  cmd = "osascript -e 'tell application \"QuickTime Player\" to set #{option} of document 1 to #{value}'"
  # puts cmd
  `#{cmd}`
end

# Play the clip, then stop
def play_clip(clip)
  set_quicktime("current time", clip[:start])
  set_quicktime("rate", clip[:rate])
  Kernel.sleep(clip[:duration] / clip[:rate])
  set_quicktime("rate", 0)
end

# Loop until Ctrl-C
def loop_clip(clip)
  begin
    while true
      play_clip(clip)
    end
  rescue CtrlCException => e
    puts "Quitting"
  ensure
    set_quicktime("rate", 0)
  end
end

######################################
# Menu

def print_clip(clip)
  tmp = [:start, :duration, :rate].map { |s| "#{s.to_s}: #{clip[s].round(2)}" }.join(', ')
  puts "Clip: #{tmp}"
end


def make_menu_item(sym, clip)
  func = lambda do
    print "Enter #{sym}: "
    clip[sym] = gets().to_f
    print_clip(clip)
    play_clip(clip)
  end
  [sym.to_s, func]
end


class CtrlCException < StandardError
end

######################################
# MAIN

trap("SIGINT") { raise CtrlCException.new() }
options = parse_args(ARGV)

clip = {
  start: options[:start],
  duration: options[:duration],
  rate: options[:rate]
}

if !options[:end].nil? then
  clip[:duration] = (options[:end] - options[:start]).to_f
end

menu_items = [
  make_menu_item(:start, clip),
  make_menu_item(:duration, clip),
  make_menu_item(:rate, clip),
  ['play', lambda { play_clip(clip) } ],
  ['loop', lambda { puts "Hit Ctrl-C to stop loop"; loop_clip(clip) } ],
  ['quit', lambda { puts "no-op" } ]
]
menu_options = menu_items.map { |s, lam| "#{s[0]})#{s[1..-1]}" }
menu_hash = menu_items.to_h
menu_items.each do |s, lam|
  menu_hash[s[0]] = lam
end

require 'io/console'
print_clip(clip)

c = 'p'

while c != 'q'
  if menu_hash[c].nil? then
    puts "Unknown option"
    c = 'p'
  end
  menu_hash[c].call

  puts
  puts "Menu: #{menu_options.join(', ')}"
  c = STDIN.getch
end
puts "Quitting"

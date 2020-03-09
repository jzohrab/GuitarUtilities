# Apple script to control QuickTime, set the current video time and playback rate.
# Perhaps useful for transcription.

require 'optparse'
require 'io/console'


# The video clip to play.  Needs to be a global variable b/c the main
# menu is built using lambdas which bind to this variable.  There are
# other ways to write this but this is fine for now.
$clip = {}


######################################
# Ctrl-C handling

class CtrlCException < StandardError
end

trap("SIGINT") { raise CtrlCException.new() }


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
# Options

# Return a hash describing the options.
def parse_args(args)
  options = {
    :start => get_quicktime("time").to_f,
    :duration => 2,
    :rate => 1
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
    opts.on("-d T", Float, "Duration (default #{options[:duration]})") do |t|
      options[:duration] = t
    end
    opts.on("-r R", Float, "Rate (default #{options[:rate]})") do |s|
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


def get_clip(options)
  clip = {
    start: options[:start],
    duration: options[:duration],
    rate: options[:rate]
  }

  if !options[:end].nil? then
    clip[:duration] = (options[:end] - options[:start]).to_f
  end

  clip
end


options = parse_args(ARGV)
$clip = get_clip(options)



######################################
# Menu

def print_clip(clip)
  tmp = [:start, :duration, :rate].map { |s| "#{s.to_s}: #{clip[s].round(2)}" }.join(', ')
  puts "Clip: #{tmp}"
end


def make_menu_item(sym, clip)
  func = lambda do
    puts "BEFORE"
    puts "NIL????" if clip.nil?
    puts clip.inspect
    print_clip(clip)
    print "Enter #{sym}: "
    clip[sym] = gets().to_f
    print_clip(clip)
    play_clip(clip)
  end
  [sym.to_s, func]
end


MENU_ITEMS = [
  make_menu_item(:start, $clip),
  make_menu_item(:duration, $clip),
  make_menu_item(:rate, $clip),
  ['play', lambda { print_clip($clip); play_clip($clip) } ],
  ['loop', lambda { puts "Hit Ctrl-C to stop loop"; loop_clip($clip) } ],
  ['quit', lambda { puts "no-op" } ]
].map do |s, lam|
  {
    letter: s[0],
    display: "#{s[0]})#{s[1..-1]}",
    action: lam
  }
end

MENU_OPTIONS = MENU_ITEMS.map { |h| h[:display] }.join(', ')
MENU_HASH = MENU_ITEMS.map { |h| [ h[:letter], h[:action] ] }.to_h



######################################
# MAIN

def main()
  # Play the clip when first entering the loop.
  user_menu_selection = 'p'

  while user_menu_selection != 'q'
    action = MENU_HASH[user_menu_selection]
    if !action.nil? then
      action.call
    else
      puts "Unknown option '#{user_menu_selection}'"
    end
    puts
    puts "Menu: #{MENU_OPTIONS}"
    user_menu_selection = STDIN.getch
    puts user_menu_selection
  end

  puts "Quitting"
end

######################################
# ENTRYPOINT

begin
  main()
rescue Exception => e
  puts "Error: #{e}"
  set_quicktime("rate", 0)
end

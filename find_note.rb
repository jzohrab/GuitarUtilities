# Command line, says string number from 1 (high E) to 6 (low E), and
# then the note to find on that string, then "plays" the note using
# midi.

require 'yaml'
require 'unimidi'
require_relative 'lib/neck'

class Array
  def shuffle!
    size.downto(1) { |n| push delete_at(rand(n)) }
    self
  end
end

class Voice
  def self.say(text)
    # OK: Alex, Karen, Samantha, Victoria
    # Bad: Daniel, Fred, Tessa
    %x(say -v Samantha "#{text}")
  end
end


def play(neck, string, note)
  f = neck.fret(string, note)
  m = neck.midi_note(string, f)
  output = UniMIDI::Output.first

  on = 0x90
  off = 0x80
  attack = 100
  duration = 0.5
  output.puts(on, m, attack)
  Kernel.sleep(duration)
  output.puts(off, m, attack)
end


class Question
  
  attr_accessor :string, :note

  def initialize(string, note)
    self.string = string
    self.note = note
  end

  def note_description()
    letter = @note[0]
    case @note[-1]
    when '#'
      "#{letter}-sharp"
    when 'b'
      "#{letter}-flat"
    else
      letter
    end
  end

  def to_s()
    "#{@string} #{self.note_description()}"
  end
  
end


# Main loop.

def main()
  puts "Reading base file"
  h = YAML.load_file('find_note.yaml')
  persistent = h[:persistent].map do |q|
    Question.new(q[:string].to_i, q[:note])
  end
  # puts persistent.inspect

  print "Enter notes to study: "
  notes = gets.split(' ')
  print "Enter strings: "
  strings = gets.split(' ')

  questions = []
  notes.each do |n|
    strings.each do |s|
      3.times { |i| questions << Question.new(s.to_i, n) }
    end
  end
  questions += persistent * 3
  questions.shuffle!

  Voice.say("Get ready!")
  Kernel.sleep 3

  n = 0
  neck = Guitar::Neck.new()
  questions.each do |q|
    n = n+1
    puts "(#{n} of #{questions.size})"
    puts q.to_s
    Voice.say(q.to_s())
    puts
    Kernel.sleep 3
    # Voice.say(neck.fret(q.string, q.note))
    play(neck, q.string, q.note)
    Kernel.sleep 1
  end

  Voice.say("All done!")  
end


def test_sound()
  puts "\nTesting midi -- you should hear a note.\n\n"
  neck = Guitar::Neck.new()
  play(neck, 3, "Db")
  Kernel.sleep 1
end

###################################
# Entry point

if (ARGV.size == 0)
  main()
else
  test_sound()
end

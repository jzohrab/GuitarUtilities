# Command line, says string number from 1 (high E) to 6 (low E), and
# then the note to find on that string, then "plays" the note using
# midi.

require 'rubygems'
require 'yaml'
require 'date'
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


def get_notes(notes_type)
  # All sets of notes, if cycling through notes.
  sets = [
    ['C', 'G'],
    ['D', 'A'],
    ['E', 'B'],
    ['F', 'C'],
    ['G', 'D'],
    ['A', 'E'],
    ['B', 'F#'],
    ['Cb', 'Gb'],
    ['Db', 'Ab'],
    ['Eb', 'Bb'],
    ['Gb', 'Db'],
    ['Ab', 'Eb'],
    ['Bb', 'F'],
    ['C#', 'G#'],
    ['D#', 'A#'],
    ['G#', 'D#'],
    ['A#', 'E#']
  ]

  result = nil
  case (notes_type)
  when 'cycle'
    i = Date.today.yday() / sets.size
    result = sets[i]
  when 'input'
    print "Enter notes to study: "
    result = gets.split(' ')
  when 'all'
    result = sets.flatten.sort.uniq
  else
    result = notes_type.split(' ')
  end

  return result
end

# Main loop.

def main()
  puts "Reading base file"
  config = File.join(File.dirname(__FILE__), 'find_note.yaml')
  h = YAML.load_file(config)
  persistent = h[:persistent].map do |q|
    Question.new(q[:string].to_i, q[:note])
  end
  # puts persistent.inspect

  notes = get_notes(h[:notes] || 'cycle')
  # print "Enter strings: "
  # strings = gets.split(' ')
  strings = [1, 2, 3, 4, 5, 6]

  qs = []
  notes.each do |n|
    strings.each do |s|
      qs << Question.new(s.to_i, n)
    end
  end
  qs += persistent
  puts "Testing the following: "
  puts qs.map { |q| "#{q.string()} #{q.note()}" }.join(', ')

  qs.shuffle!
  questions = qs + qs + qs
  # puts questions.inspect

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

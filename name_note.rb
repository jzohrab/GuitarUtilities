# Given a range of frets, and strings, say the string and fret, pause,
# and then say the corresponding notes.

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

class Note
  
  attr_accessor :name

  def initialize(name)
    self.name = name
  end

  # Phonetic description
  def description()
    letter = @name[0].downcase
    case @name[-1]
    when '#'
      "#{letter}-sharp"
    when 'b'
      "#{letter}-flat"
    else
      letter
    end
  end
  
end

class Question
  
  attr_accessor :string, :fret

  def initialize(string, fret)
    self.string = string
    self.fret = fret
  end

  def to_s()
    "#{@string} #{fret}"
  end

  def answer()
    get_notes(string, fret).map { |n| Note.new(n) }
  end

end


NOTE_NAMES = [
  ['A'],
  ['A#', 'Bb'],
  ['B'],
  ['C'],
  ['C#', 'Db'],
  ['D'],
  ['D#', 'Eb'],
  ['E'],
  ['F'],
  ['F#', 'Gb'],
  ['G'],
  ['G#', 'Ab']
]

# puts NOTE_NAMES.inspect

# High E is 1, low E is 6.
def get_notes(string, fret)
  raise "bad string" if string < 1 or string > 6
  raise "bad fret" if fret < 0 or fret > 15
  base_offset = 0
  base_offset =
    case(string)
    when 1 then 7
    when 2 then 2
    when 3 then 10
    when 4 then 5
    when 5 then 0
    when 6 then 7
    end
  offset = base_offset + fret
  # puts offset
  note_index = offset % NOTE_NAMES.size
  # puts note_index
  NOTE_NAMES[note_index]
end

# puts get_notes(1, 0).inspect
# puts get_notes(1, 5).inspect
# puts get_notes(5, 6).inspect
# puts get_notes(3, 6).inspect


###################################

print "Enter strings: "
STRINGS = gets.split(' ')
print "Enter low fret: "
LOWFRET = gets.strip
print "Enter high fret: "
HIGHFRET = gets.strip

questions = []
(LOWFRET..HIGHFRET).to_a.each do |f|
  STRINGS.each do |s|
    puts f, s
    3.times { |i| questions << Question.new(s.to_i, f.to_i) }
  end
end
questions.shuffle!

n = 0
questions.each do |q|
  n = n+1
  puts "(#{n} of #{questions.size})"
  puts q.to_s
  Voice.say(q.to_s())
  Kernel.sleep 4
  a = q.answer().map { |n| n.description }.join(', ')
  Voice.say(a)
end

Voice.say("All done!")

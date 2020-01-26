# Command line, says string number from 1 (low E) to 6 (high E),
# and then the note to find on that string.

# Edit these to focus on certain notes and strings
NOTES = %w(A Ab A# B Bb C C# Db D D# E Eb F F# G G# Gb)
NOTES = %w(F# Ab)
STRINGS = %w(1 2 3 4 5 6)
STRINGS = %w(5 6)

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
      "#{letter} sharp"
    when 'b'
      "#{letter} flat"
    else
      letter
    end
  end

  def to_s()
    "#{@string} #{self.note_description()}"
  end
  
end

questions = []
NOTES.each do |n|
  STRINGS.each do |s|
    3.times { |i| questions << Question.new(s, n) }
  end
end
questions.shuffle!

n = 0
questions.each do |q|
  n = n+1
  puts "(#{n} of #{questions.size})"
  puts q.to_s
  Voice.say(q.to_s())
  puts
  Kernel.sleep 4
end
Voice.say("All done!")  

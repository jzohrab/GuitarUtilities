module Music
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

  # Given note (e.g. 'Eb'), find "offset" from A
  # as given in NOTE_NAMES.
  def Music.find_offset(note_name)
    NOTE_NAMES.each_with_index do |e, i|
      return i if e.map { |s| s.downcase }.include?(note_name.downcase)
    end
    raise "Bad note #{note_name}"
  end

  def Music.find_offset_from(base_note, note_name)
    base = Music.find_offset(base_note)
    target = Music.find_offset(note_name)
    ret = target - base
    ret += 12 if ret < 0
    ret
  end

end


module Guitar

  STD_TUNING = {
    1 => { :midi => 88 - 12, :note => 'E' },
    2 => { :midi => 83 - 12, :note => 'B' },
    3 => { :midi => 79 - 12, :note => 'G' },
    4 => { :midi => 74 - 12, :note => 'D' },
    5 => { :midi => 69 - 12, :note => 'A' },
    6 => { :midi => 64 - 12, :note => 'E' },
  }

  class Neck

    def midi_note(string, fret)
      Guitar::STD_TUNING[string][:midi] + fret
    end

    def fret(string, note_name)
      raise "Bad string #{string}" if (string < 1 or string > 6)
      Music::find_offset_from(Guitar::STD_TUNING[string][:note], note_name)
    end

  end

end

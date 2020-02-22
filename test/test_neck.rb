require_relative '../lib/Neck'
require 'test/unit'

class Test_Music < Test::Unit::TestCase

  def test_find_A_offset()
    assert_equal(0, Music::find_offset('A'), 'A')
  end

  def test_find_Eb_offset()
    assert_equal(6, Music::find_offset('Eb'), 'Eb')
  end

  def test_find_offset_throws_for_bad_note()
    assert_raise { Music::find_offset('BADNOTE') }
  end

  def test_find_offset_from()
    assert_equal(2, Music::find_offset_from('E', 'F#'), "e to f#")
    assert_equal(5, Music::find_offset_from('E', 'A'))
  end

  def test_find_offset_from_works_with_lowercase()
    assert_equal(2, Music::find_offset_from('E', 'f#'), "e to f#")
    assert_equal(5, Music::find_offset_from('e', 'a'))
  end

end


class Test_Neck < Test::Unit::TestCase

  def setup()
    @neck = Guitar::Neck.new()
  end

  def test_open_string_midi_notes()
    (1..6).to_a.each do |s|
      assert_equal(Guitar::STD_TUNING[s][:midi], @neck.midi_note(s, 0), "string #{s}")
    end
  end

  def test_string_fret()
    (1..6).to_a.each do |s|
      assert_equal(Guitar::STD_TUNING[s][:midi] + 5, @neck.midi_note(s, 5), "string #{s}, 5th fret")
    end
  end

  def test_open_string_fret()
    assert_equal(0, @neck.fret(1, 'E'))
  end

  def test_f_sharp_all_strings()
    [
      [1, 2],
      [2, 7],
      [3, 11],
      [4, 4],
      [5, 9],
      [6, 2]
    ].each do |string, expected|
      assert_equal(expected, @neck.fret(string, 'F#'), "String #{string}")
    end
  end

end

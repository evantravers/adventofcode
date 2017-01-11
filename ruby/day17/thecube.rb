require 'minitest/autorun'
require 'digest'
require 'set'

md5 = Digest::MD5.new

start = [0,0]

def in_bounds x, y
  (0..3).include?(x) && (0..3).include?(y)
end

class MazeTest < Minitest::Test
  def test_1
    assert_equal solve('ihgpwlah'), 'DDRRRD'
  end

  def test_2
    assert_equal solve('kglvqrro'), 'DDUDRLRRUDRD'
  end

  def test_3
    assert_equal solve('ulqzkmiv'), 'DRURDRUDDLLDLUURRDULRLDUUDDDRR'
  end
end

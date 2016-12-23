#!/usr/bin/env ruby

input = [ 3,0,2,0,9,0,0,0,0,
          8,9,0,1,0,0,0,6,0,
          0,0,4,0,3,0,1,0,9,
          0,7,0,4,0,0,0,0,0,
          0,2,0,0,0,0,0,0,7,
          0,8,0,3,6,0,0,0,0,
          0,0,0,0,0,0,2,0,0,
          0,0,0,6,4,0,5,0,0,
          0,0,0,0,2,8,7,0,0]

class Puzzle

  UNSOLVED = 0

  def initialize(input_array)
    @input = input_array.map.with_index do |x , i|
      _make_cell(x, i)
    end
  end

  def _make_cell(x, i)
    { :row  => (i % 9),
      :col  => (i / 9),
      :cell => ((i % 9) / 3) + ((i / 27) * 3),
      :val  => x
    }
  end

  def _select(field, idx)
    @input.select { |x| x[field] == idx }.map { |x| x[:val] }
  end

  def set(idx, val)
    @input[idx] = _make_cell(val, idx)
  end

  def print
    (0..8).each { |i| puts "#{_select :col, i}" }
  end

  def solve

    unless valid?
      return false 
    end

    if @input.index { |x| x[:val] == UNSOLVED } == nil
      return true
    end

    solved = false

    idx = @input.index { |x| x[:val] == UNSOLVED }
    (1..9).each do |i|
      set(idx, i)
      solved = self.solve
      break if solved
    end

    set(idx, UNSOLVED) unless solved

    return solved
  end

  def valid?

    is_uniq = Proc.new do |ary|
      solved_portion = ary.select { |x| x != UNSOLVED }
      solved_portion.uniq.length == solved_portion.length
    end

    (0..8).each do |i|
      unless is_uniq.call(_select(:row  ,i)) and
             is_uniq.call(_select(:col  ,i)) and
             is_uniq.call(_select(:cell ,i))
        return false
      end
    end
    return true
  end

end

puzzle = Puzzle.new(input)
puzzle.solve
puzzle.print

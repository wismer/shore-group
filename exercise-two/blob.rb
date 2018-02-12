require 'pry'
# Boundary Challenge
# A Blob is a shape in two-dimensional integer coordinate space where all cells
# have at least one adjoining cell to the right, left, top, or bottom that is
# also occupied. Given a 10x10 array of boolean values that represents a Blob
# uniformly selected at random from the set of all possible Blobs that could
# occupy that array, write a program that will determine the Blob boundaries.
# Optimize for finding the correct result, performing a minimum number of cell
# Boolean value reads, and elegance and clarity of the solution.

#Sample input: (Please view in a monospaced font)
# 0000000000
# 0011100000
# 0011111000
# 0010001000
# 0011111000
# 0000101000
# 0000101000
# 0000111000
# 0000000000
# 0000000000
#
# Sample output:
# Cell Reads: 44
# Top: 1
# Left: 2
# Bottom: 7
# Right: 6


class Queue
  def initialize
    @queue = []
  end

  def empty?
    @queue.empty?
  end

  def pop
    @queue.pop
  end

  def add(coordinate)
    @queue.push(coordinate)
  end
end

class Grid
  # North/South/West/East
  DIRECTIONS = [
    { dir: 'top', coord: [-1, 0] },
    { dir: 'bottom', coord: [1, 0] },
    { dir: 'left', coord: [0, -1] },
    { dir: 'right', coord: [0, 1] }
  ]
  attr_reader :x, :y

  def initialize(grid)
    @grid = grid
    @queue = Queue.new
    @x = 4
    @y = 4
    @reads = 0
    @results = {
      left: 0,
      top: 0,
      right: 0,
      bottom: 0
    }
  end

  def calibrate
    cx = @grid.index do |row|
      row.any? do |r|
        @reads += 1
        r == 1
      end
    end
    cy = @grid[cx].index do |cell|
      @reads += 1
      cell == 1
    end

    @results[:left] = @y = cy
    @results[:top] = @x = cx
  end

  def size
    @size ||= @grid.size
  end

  def update_borders(direction, cx, cy)
    if direction[:dir] == 'left'
      @results[:left] = cy < @results[:left] ? cy : @results[:left]
    elsif direction[:dir] == 'right'
      @results[:right] = cy > @results[:right] ? cy : @results[:right]
    elsif direction[:dir] == 'top'
      @results[:top] = cx < @results[:top] ? cx : @results[:top]
    else
      @results[:bottom] = cx > @results[:bottom] ? cx : @results[:bottom]
    end
  end

  def out_of_bounds?(cx, cy)
    (cx > size || cx < 0) || (cy > size || cy < 0)
  end

  def get_cell(cx, cy)
    @reads += 1
    @grid[cx][cy]
  end

  def run
    @queue.add([x, y])
    path = []

    while !@queue.empty?
      coord = @queue.pop
      path.push(coord)

      DIRECTIONS.each do |c|
        cx, cy = c[:coord][0] + coord[0], c[:coord][1] + coord[1]

        if !out_of_bounds?(cx, cy)
          cell = get_cell(cx, cy)
        else
          cell = false
        end

        if !path.include?([cx, cy]) && cell == 1
          update_borders(c, cx, cy)
          path.push([cx, cy])
          @queue.add([cx, cy])
          break
        end
      end
    end
    puts "Results #{@results}, Reads: #{@reads}"
  end
end


sample_data = [
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 1, 1, 1, 0, 0, 0, 0, 0],
  [0, 0, 1, 1, 1, 1, 1, 0, 0, 0],
  [0, 0, 1, 0, 0, 0, 1, 0, 0, 0],
  [0, 0, 1, 1, 1, 1, 1, 0, 0, 0],
  [0, 0, 0, 0, 1, 0, 1, 0, 0, 0],
  [0, 0, 0, 0, 1, 0, 1, 0, 0, 0],
  [0, 0, 0, 0, 1, 1, 1, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
]

g = Grid.new(sample_data)

g.calibrate

g.run

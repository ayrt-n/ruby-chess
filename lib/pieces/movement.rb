# frozen_string_literal: true

# Module which defines chess piece movement (up/down/left/right/etc)
module Movement
  def up
    [-1, 0]
  end

  def down
    [1, 0]
  end

  def left
    [0, -1]
  end

  def right
    [0, 1]
  end

  def up_right
    [-1, 1]
  end

  def up_left
    [-1, -1]
  end

  def down_right
    [1, 1]
  end

  def down_left
    [1, -1]
  end

  def jump_up_left
    [-2, -1]
  end

  def jump_up_right
    [-2, 1]
  end

  def jump_left_up
    [-1, -2]
  end

  def jump_right_up
    [-1, 2]
  end

  def jump_down_left
    [2, -1]
  end

  def jump_down_right
    [2, 1]
  end

  def jump_right_down
    [1, 2]
  end

  def jump_left_down
    [1, -2]
  end

  def up_and_down
    [up, down]
  end

  def side_to_side
    [left, right]
  end

  def diagonally
    [up_left, up_right, down_left, down_right]
  end

  def jumps
    [jump_down_left, jump_down_right, jump_left_down, jump_left_up,
     jump_right_down, jump_right_up, jump_up_left, jump_up_right]
  end
end

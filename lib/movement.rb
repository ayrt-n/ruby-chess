# frozen_string_literal: true

# Module which defines chess piece movement (up/down/left/right/etc)
module Movement
  def up
    -8
  end

  def down
    8
  end

  def left
    -1
  end

  def right
    1
  end

  def up_right
    -9
  end

  def up_left
    -7
  end

  def down_right
    9
  end

  def down_left
    7
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

  def jump_up_left
    up + up + left
  end

  def jump_up_right
    up + up + right
  end

  def jump_left_up
    left + left + up
  end

  def jump_right_up
    right + right + up
  end

  def jump_down_left
    down + down + left
  end

  def jump_down_right
    down + down + right
  end

  def jump_right_down
    right + right + down
  end

  def jump_left_down
    left + left + down
  end
end

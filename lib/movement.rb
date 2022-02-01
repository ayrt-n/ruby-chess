# frozen_string_literal: true

# Module which defines chess piece movement (up/down/left/right/etc)
module Movement
  def up_and_down
    [up, down]
  end

  def side_to_side
    [left, right]
  end

  def diagonally
    [up_left, up_right, down_left, down_right]
  end

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
end
# frozen_string_literal: true

# Module for transforming chess coordinates (e.g., a8) into position in arrary coordinate ([0, 0])
#       0    1    2    3    4    5    6    7
#       a    b    c    d    e    f    g    h
# 0  8 [  ] [  ] [  ] [  ] [  ] [  ] [  ] [  ]
# 1  7 [  ] [  ] [  ] [  ] [  ] [  ] [  ] [  ]
# 2  6 [  ] [  ] [  ] [  ] [  ] [  ] [  ] [  ]
# 3  5 [  ] [  ] [  ] [  ] [  ] [  ] [  ] [  ]
# 4  4 [  ] [  ] [  ] [  ] [  ] [  ] [  ] [  ]
# 5  3 [  ] [  ] [  ] [  ] [  ] [  ] [  ] [  ]
# 6  2 [  ] [  ] [  ] [  ] [  ] [  ] [  ] [  ]
# 7  1 [  ] [  ] [  ] [  ] [  ] [  ] [  ] [  ]

module Coordinates
  def chess_to_array_index(chess_coord)
    x, y = chess_coord.split('')
    x = (x.ord - 'a'.ord)
    y = (y.to_i - 8).abs

    [y, x]
  end

  def valid_coord?(string)
    return false if string.size != 2

    !!string[0].match(/^[a-hA-H]/) && !!string[-1].match(/[0-8]/)
  end
end
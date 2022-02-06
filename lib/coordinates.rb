# frozen_string_literal: true

# Module for transforming chess coordinates (e.g., a8) into position in array (0)
#     a    b    c    d    e    f    g    h
# 8  [0]  [1]  [2]  [3]  [4]  [5]  [6]  [7]
# 7  [8]  [9] [10] [11] [12] [13] [14] [15]
# 6 [16] [17] [18] [19] [20] [21] [22] [23]
# 5 [24] [25] [26] [27] [28] [29] [30] [31]
# 4 [32] [33] [34] [35] [36] [37] [38] [39]
# 3 [40] [41] [42] [43] [44] [45] [46] [47]
# 2 [48] [49] [50] [51] [52] [53] [54] [55]
# 1 [56] [57] [58] [59] [60] [61] [62] [63]

module Coordinates
  def chess_to_array_index(chess_coord)
    x, y = chess_coord.split('')
    x = (x.ord - 'a'.ord)
    y = (y.to_i - 8).abs * 8

    x + y
  end

  def valid_coord?(string)
    return false if string.size != 2

    !!string[0].match(/^[a-hA-H]/) && !!string[-1].match(/[0-9]/)
  end
end
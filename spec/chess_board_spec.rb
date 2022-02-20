# frozen_string_literal: true

require './lib/chess_board'

describe ChessBoard do
  describe '#move' do
    context 'when making a regular move' do
      it 'moves object from one array location to another' do
        piece = ChessPiece.new(:white)
        example_board = ChessBoard.new([[nil, piece, nil], [nil, nil, nil]])
        starting = [0, 1]
        ending = [1, 1]

        example_board.move(starting, ending)
        expect(example_board.board).to eql([[nil, nil, nil], [nil, piece, nil]])
      end
    end

    context 'when player is castling' do
      let(:king) { King.new(:white) }
      let(:rook) { Rook.new(:white) }

      it 'moves the king and rook when castling to the right' do
        castling_board = [[nil, nil, nil, nil, nil, nil, nil, nil],
                          [rook, nil, nil, nil, king, nil, nil, rook]]
        board = ChessBoard.new(castling_board)

        right_castled_board = [[nil, nil, nil, nil, nil, nil, nil, nil],
                               [rook, nil, nil, nil, nil, rook, king, nil]]

        board.move([1, 4], [1, 6])
        expect(board.board).to eql(right_castled_board)
      end

      it 'moves the king and rook when castling to the left' do
        castling_board = [[nil, nil, nil, nil, nil, nil, nil, nil],
                          [rook, nil, nil, nil, king, nil, nil, rook]]
        board = ChessBoard.new(castling_board)

        left_castled_board = [[nil, nil, nil, nil, nil, nil, nil, nil],
                               [nil, nil, king, rook, nil, nil, nil, rook]]

        board.move([1, 4], [1, 2])
        expect(board.board).to eql(left_castled_board)
      end
    end

    context 'when player is taking en passant' do
      let(:wp) { Pawn.new(:white) }
      let(:bp) { Pawn.new(:black) }

      it 'takes adjacent pawn when moving en passant' do
        example_board = [[nil, nil, nil],
                         [nil, nil, nil],
                         [ wp,  bp, nil]]
        board = ChessBoard.new(example_board)
        board.en_passantable = [2, 1]

        en_pass_board = [[nil, nil, nil],
                         [nil,  wp, nil],
                         [nil, nil, nil]]

        board.move([2, 0], [1, 1])
        expect(board.board).to eql(en_pass_board)
      end
    end
  end

  describe '#in_bounds?' do
    it 'returns true when position is in bounds of board' do
      example_board = ChessBoard.new([[1, nil, nil], [nil, nil, nil]])
      expect(example_board).to be_in_bounds([0, 0])
    end

    it 'returns false when position is out of bounds of board' do
      example_board = ChessBoard.new([[1, nil, nil], [nil, nil, nil]])
      expect(example_board).not_to be_in_bounds([0, 5])
    end

    it 'returns false when position is out of bounds of board' do
      example_board = ChessBoard.new([[1, nil, nil], [nil, nil, nil]])
      expect(example_board).not_to be_in_bounds([-1, 0])
    end
  end

  describe '#at_index' do
    it 'returns the element given board coordinates' do
      example_board = ChessBoard.new([[1, nil, nil], [nil, nil, nil]])
      board_element = example_board.at_index([0, 0])
      expect(board_element).to eql(1)
    end
  end

  describe '#empty?' do
    it 'returns true if spot is empty (nil)' do
      example_board = ChessBoard.new([[1, nil, nil], [nil, nil, nil]])
      expect(example_board).to be_empty([1, 1])
    end

    it 'returns false if spot is not empty (nil)' do
      example_board = ChessBoard.new([[1, nil, nil], [nil, nil, nil]])
      expect(example_board).not_to be_empty([0, 0])
    end
  end

  describe '#color' do
    it 'returns the color attribute from a piece' do
      piece = double('piece')
      allow(piece).to receive(:color).and_return(:black)
      example_board = ChessBoard.new([[nil, piece, nil], [nil, nil, nil]])

      color = example_board.color([0, 1])

      expect(color).to eql(:black)
    end

    it 'returns nil when position is empty' do
      piece = double('piece')
      allow(piece).to receive(:color).and_return(:black)
      example_board = ChessBoard.new([[nil, piece, nil], [nil, nil, nil]])

      color = example_board.color([0, 2])

      expect(color).to eql(nil)
    end
  end

  describe '#return_all_valid_moves' do
    let(:wking) { King.new(:white) }
    let(:wpawn) { Pawn.new(:white) }
    let(:brook) { Rook.new(:black) }

    context 'when no threat of check from other player' do
      it 'returns hash of {[piece_position]: [valid_moves]}' do
        example_board = [[nil, nil, nil, nil],
                        [nil, nil, nil, nil],
                        [wpawn, wking, nil, nil]]
        board = ChessBoard.new(example_board)
        allow(wking).to receive(:valid_moves).and_return([[1, 0], [1, 1], [1, 2], [2, 2]])
        allow(wpawn).to receive(:valid_moves).and_return([[1, 0]])

        valid_moves = {
          [2, 0] => [[1, 0]],
          [2, 1] => [[1, 0], [1, 1], [1, 2], [2, 2]]
        }

        expect(board.return_all_valid_moves(:white)).to eql(valid_moves)
      end
    end

    context 'when player can move into a self check' do
      it 'does not allow the player to move into self check' do
        example_board = [[nil, nil, nil, nil],
                        [nil, nil, nil, nil],
                        [brook, nil, wpawn, wking]]
        board = ChessBoard.new(example_board)

        allow(wking).to receive(:valid_moves).and_return([[1, 2], [1, 3]])
        allow(wpawn).to receive(:valid_moves).and_return([[1, 0]])

        valid_moves = {
          [2, 2] => [],
          [2, 3] => [[1, 2], [1, 3]]
        }

        expect(board.return_all_valid_moves(:white)).to eql(valid_moves)
      end
    end
  end

  describe '#under_attack_at?' do
    let(:wking) { King.new(:white) }
    let(:brook) { Rook.new (:black) }

    it 'returns true if piece is under attack at certain position' do
      example_board = [[nil, brook, nil],
                       [nil, nil, nil],
                       [wking, nil, nil]]
      board = ChessBoard.new(example_board)
      allow(brook).to receive(:valid_moves).and_return([[1, 1], [2, 1]])

      is_under_attack = board.under_attack_at?([2, 1], :white)

      expect(is_under_attack).to eql(true)
    end

    it 'returns false if piece is not under attack at certain position' do
      example_board = [[nil, brook, nil],
                       [nil, nil, nil],
                       [wking, nil, nil]]
      board = ChessBoard.new(example_board)
      allow(brook).to receive(:valid_moves).and_return([[1, 1], [2, 1]])

      is_under_attack = board.under_attack_at?([1, 0], :white)

      expect(is_under_attack).to eql(false)
    end
  end

  describe '#checked' do
    let(:wking) { King.new(:white) }
    let(:wpawn) { Pawn.new(:white) }
    let(:brook) { Rook.new(:black) }

    it 'returns true when player is checked' do
      check_board = [[brook, nil, nil, nil, wking]]
      board = ChessBoard.new(check_board)
      allow(brook).to receive(:valid_moves).and_return([[0, 1], [0, 2], [0, 3], [0, 4]])
      white_checked = board.checked?(:white)

      expect(white_checked).to eql(true)
    end

    it 'returns false when player is checked' do
      check_board = [[brook, nil, nil, wpawn, wking]]
      board = ChessBoard.new(check_board)
      allow(brook).to receive(:valid_moves).and_return([[0, 1], [0, 2], [0, 3]])
      white_checked = board.checked?(:white)

      expect(white_checked).to eql(false)
    end
  end

  describe '#stalemate' do
    let(:wking) { King.new(:white) }
    let(:brook) { Rook.new(:black) }
    let(:bqueen) { Queen.new(:black) }

    context 'when player has no valid moves and is not in check' do
      it 'returns true' do
        example_board = [[bqueen, nil, nil],
                         [nil, nil, wking],
                         [brook, nil, nil]]
        board = ChessBoard.new(example_board)
        allow(bqueen).to receive(:valid_moves).and_return([[0, 1], [0, 2], [0, 3], [0, 4], [1, 0], [1, 1]])
        allow(brook).to receive(:valid_moves).and_return([[1, 0], [2, 1], [2, 2]])
        allow(wking).to receive(:valid_moves).and_return([[1, 1], [0, 1], [0, 2], [2, 1], [2, 2]])

        white_stalemate = board.stalemate?(:white)

        expect(white_stalemate).to eql(true)
      end
    end

    context 'when player has no valid moves and is in check' do
      it 'returns false' do
        example_board = [[brook, nil, nil],
                         [nil, nil, bqueen],
                         [wking, nil, nil]]
        board = ChessBoard.new(example_board)
        allow(brook).to receive(:valid_moves).and_return([[1, 0], [2, 0]])
        allow(bqueen).to receive(:valid_moves).and_return([[1, 0], [1, 1], [2, 1], [2, 2]])
        allow(wking).to receive(:valid_moves).and_return([[1, 0], [1, 1], [2, 1]])

        white_stalemate = board.stalemate?(:white)

        expect(white_stalemate).to eql(false)
      end
    end
  end

  describe '#checkmate' do
    let(:wking) { King.new(:white) }
    let(:wpawn) { Pawn.new(:white) }
    let(:brook) { Rook.new(:black) }
    let(:bqueen) { Queen.new(:black) }

    it 'returns true if player has no moves available (checkmate)' do
      example_board = [[brook, nil, nil],
                       [nil, nil, bqueen],
                       [wking, nil, nil]]
      board = ChessBoard.new(example_board)
      allow(brook).to receive(:valid_moves).and_return([[1, 0], [2, 0]])
      allow(bqueen).to receive(:valid_moves).and_return([[1, 0], [1, 1], [2, 1], [2, 2]])
      allow(wking).to receive(:valid_moves).and_return([[1, 0], [1, 1], [2, 1]])

      white_checkmate = board.checkmate?(:white)

      expect(white_checkmate).to eql(true)
    end

    it 'returns false if player has moves available (not checkmate)' do
      example_board = [[brook, nil, nil],
                       [nil, nil, nil],
                       [wking, nil, nil]]
      board = ChessBoard.new(example_board)
      allow(brook).to receive(:valid_moves).and_return([[1, 0], [2, 0]])
      allow(wking).to receive(:valid_moves).and_return([[1, 0], [1, 1], [2, 1]])

      white_checkmate = board.checkmate?(:white)

      expect(white_checkmate).to eql(false)
    end
  end
end
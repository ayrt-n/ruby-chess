# frozen_string_literal: true

require './lib/coordinates'

RSpec.configure do |c|
  c.include Coordinates
end

describe Coordinates do
  describe '#chess_to_array_index' do
    it 'converts chess coordinate into appropriate array index (0-63)' do
      chess_coord = 'a8'
      array_index = chess_to_array_index(chess_coord)
      expect(array_index).to eql(0)
    end

    it 'converts chess coordinate into appropriate array index (0-63)' do
      chess_coord = 'h1'
      array_index = chess_to_array_index(chess_coord)
      expect(array_index).to eql(63)
    end

    it 'converts chess coordinate into appropriate array index(0-63)' do
      chess_coord = 'e5'
      array_index = chess_to_array_index(chess_coord)
      expect(array_index).to eql(28)
    end
  end
end
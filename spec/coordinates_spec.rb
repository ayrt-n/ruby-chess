# frozen_string_literal: true

require './lib/coordinates'

RSpec.configure do |c|
  c.include Coordinates
end

describe Coordinates do
  describe '#chess_to_array_index' do
    it 'converts chess coordinate into appropriate array coordinate [y, x]' do
      chess_coord = 'a8'
      array_index = chess_to_array_index(chess_coord)
      expect(array_index).to eql([0, 0])
    end

    it 'converts chess coordinate into appropriate array index [y, x]' do
      chess_coord = 'h1'
      array_index = chess_to_array_index(chess_coord)
      expect(array_index).to eql([7, 7])
    end

    it 'converts chess coordinate into appropriate array index [y, x]' do
      chess_coord = 'e5'
      array_index = chess_to_array_index(chess_coord)
      expect(array_index).to eql([3, 4])
    end
  end

  describe '#valid_coord?' do
    it 'returns true when string is correctly formatted as chess coordinate' do
      chess_coord = 'a8'
      is_valid = valid_coord?(chess_coord)
      expect(is_valid).to eql(true)
    end

    it 'returns false when string is correctly formatted as chess coordinate' do
      chess_coord = ''
      is_valid = valid_coord?(chess_coord)
      expect(is_valid).to eql(false)
    end

    it 'returns false when string is correctly formatted as chess coordinate' do
      chess_coord = 'ax'
      is_valid = valid_coord?(chess_coord)
      expect(is_valid).to eql(false)
    end

    it 'returns false when string is correctly formatted as chess coordinate' do
      chess_coord = 'a9'
      is_valid = valid_coord?(chess_coord)
      expect(is_valid).to eql(false)
    end
  end
end
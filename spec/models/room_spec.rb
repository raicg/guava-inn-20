require 'rails_helper'

RSpec.describe Room, type: :model do
  let!(:room){ create(:room) }

  it 'validates presence of code' do
    room.update(code: nil)
    room.reload

    expect(room).to have_error_on(:code, :blank)
    expect(room.code).to_not be_nil
  end

  describe 'when you create a second room with the same code' do
    let!(:room2){ create(:room) }

    it 'validates uniqueness of code' do
      room2.update(code: room.code)
      room2.reload

      expect(room2).to have_error_on(:code, :taken)
      expect(room2.code).to_not eq(room.code)
    end
  end

  it 'validates presence of capacity' do
    room.update(capacity: nil)
    room.reload

    expect(room).to have_error_on(:capacity, :blank)
    expect(room.capacity).to_not be_nil
  end

  it 'validates that capacity should not be zero' do
    room.update(capacity: 0)
    room.reload

    expect(room).to have_error_on(:capacity, :greater_than)
    expect(room.capacity).to_not eq(0)
  end

  it 'validates that capacity should not be negative' do
    room.update(capacity: -1)
    room.reload

    expect(room).to have_error_on(:capacity, :greater_than)
    expect(room.capacity).to_not eq(-1)
  end

  it 'validates that capacity should not be greater than ten' do
    room.update(capacity: 20)
    room.reload

    expect(room).to have_error_on(:capacity, :less_than_or_equal_to)
    expect(room.capacity).to_not eq(20)
  end
end

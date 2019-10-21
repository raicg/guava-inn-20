require 'rails_helper'

RSpec.describe Room, type: :model do
  it 'validates presence of code' do
    room = Room.new

    expect(room).to_not be_valid
    expect(room).to have_error_on(:code, :blank)
  end

  it 'validates uniqueness of code' do
    Room.create!(code: '101', capacity: 2)

    room = Room.new(code: '101')
    expect(room).to_not be_valid
    expect(room).to have_error_on(:code, :taken)
  end

  it 'validates presence of capacity' do
    room = Room.new

    expect(room).to_not be_valid
    expect(room).to have_error_on(:capacity, :blank)
  end

  it 'validates that capacity should not be zero' do
    room = Room.new(capacity: 0)

    expect(room).to_not be_valid
    expect(room).to have_error_on(:capacity, :greater_than)
  end

  it 'validates that capacity should not be negative' do
    room = Room.new(capacity: -1)

    expect(room).to_not be_valid
    expect(room).to have_error_on(:capacity, :greater_than)
  end

  it 'validates that capacity should not be greater than ten' do
    room = Room.new(capacity: 11)

    expect(room).to_not be_valid
    expect(room).to have_error_on(:capacity, :less_than_or_equal_to)
  end
end

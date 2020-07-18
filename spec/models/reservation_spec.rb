require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let!(:room) { create(:room) }
  let!(:reservation) { create(:reservation, start_date: Date.tomorrow + 1.day, end_date: Date.tomorrow + 5.days) }

  it 'validates presence of room' do
    reservation.update(room_id: nil)
    reservation.reload

    expect(reservation).to have_error_on(:room, :blank)
    expect(reservation.room_id).to_not be_nil
  end

  it 'validates presence of start_date' do
    reservation.update(start_date: nil)
    reservation.reload

    expect(reservation).to have_error_on(:start_date, :blank)
    expect(reservation.start_date).to_not be_nil
  end

  it 'validates presence of end_date' do
    reservation.update(end_date: nil)
    reservation.reload

    expect(reservation).to have_error_on(:end_date, :blank)
    expect(reservation.end_date).to_not be_nil
  end

  it 'validates presence of guest_name' do
    reservation.update(guest_name: nil)
    reservation.reload

    expect(reservation).to have_error_on(:guest_name, :blank)
    expect(reservation.guest_name).to_not be_nil
  end

  it 'validates presence of number_of_guests' do
    reservation.update(number_of_guests: nil)
    reservation.reload

    expect(reservation).to have_error_on(:number_of_guests, :blank)
    expect(reservation.number_of_guests).to_not be_nil
  end

  it 'validates that number_of_guests should not be zero' do
    reservation.update(number_of_guests: 0)
    reservation.reload

    expect(reservation).to have_error_on(:number_of_guests, :greater_than)
    expect(reservation.number_of_guests).to_not eq(0)
  end

  it 'validates that number_of_guests should not be negative' do
    reservation.update(number_of_guests: -1)
    reservation.reload

    expect(reservation).to have_error_on(:number_of_guests, :greater_than)
    expect(reservation.number_of_guests).to_not eq(-1)
  end

  it 'validates that number_of_guests should not be greater than ten' do
    reservation.update(number_of_guests: 20)
    reservation.reload

    expect(reservation).to have_error_on(:number_of_guests, :less_than_or_equal_to)
    expect(reservation.number_of_guests).to_not eq(20)
  end

  it 'validates that start_date is before end_date' do
    reservation.update(start_date: Date.tomorrow, end_date: Date.today)
    reservation.reload

    expect(reservation).to have_error_on(:base, :invalid_dates)
    expect(reservation.start_date).to_not eq(Date.tomorrow)
    expect(reservation.end_date).to_not eq(Date.today)
  end

  it 'validates that start_date is not equal to end_date' do
    reservation.update(start_date: Date.tomorrow, end_date: Date.tomorrow)
    reservation.reload

    expect(reservation).to have_error_on(:base, :invalid_dates)
    expect(reservation.start_date).to_not eq(Date.tomorrow)
    expect(reservation.end_date).to_not eq(Date.tomorrow)
  end

  describe '#duration' do
    it 'returns the number of nights for the reservation' do
      reservation.update(start_date: Date.tomorrow, end_date: Date.tomorrow + 4.days)
      reservation.reload

      expect(reservation.duration).to eq(4)
    end
  end

  describe '#code' do
    it 'returns the room code and two-digit reservation id' do
      formatted_id = '%02d' % reservation.id

      expect(reservation.code).to eq("#{room.code}-#{formatted_id}")
    end

    context 'when the reservation id is greater than 99' do
      let!(:reservation2) { create(:reservation, id: 123, start_date: '2018-01-01', end_date: '2018-01-02') }
      it 'returns a code with the second part having more than two digits' do
        expect(reservation2.code).to eq("#{room.code}-123")
      end
    end

    context 'when the room is already reserved' do
      it 'should not accept the dates of the new reservation' do
        reservation2 = Reservation.create(start_date: reservation.start_date,
          end_date: reservation.end_date,
          room: reservation.room,
          number_of_guests: reservation.number_of_guests)

        expect(reservation2).to have_error_on(:base, :invalid_dates)
        expect(reservation2).to_not be_persisted
      end
    end

    it 'remaing_days_until_custom_date method should returns the remaing days' do
      reservation.update(start_date: Date.tomorrow, end_date: Date.tomorrow + 2.days)

      expect(reservation.remaing_days_until_custom_date(Date.tomorrow + 1.day)).to eq(1)
    end
  end

  describe 'testing scopes' do
    let!(:reservation2) { create(:reservation, start_date: Date.tomorrow + 8.days, end_date: Date.tomorrow + 15.days) }

    context 'scope: of_the_week' do
      it 'should shows all reservations of the week' do
        expect(Reservation.of_the_week.size).to eq(1)
      end
    end

    context 'scope: of_the_month' do
      it 'should shows all reservations of the month' do
        expect(Reservation.of_the_month.size).to eq(2)
      end
    end
  end
end

class Reservation < ApplicationRecord
  belongs_to :room

  validates :start_date, :end_date, :guest_name, :number_of_guests, presence: true
  validates :number_of_guests, numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  validate :start_date_is_before_end_date
  validate :already_reserved
  validate :room_with_insufficient_capacity

  scope :of_the_week, -> { where.not('start_date > ? OR end_date < ?', Date.tomorrow + 7.days, Date.tomorrow) }
  scope :of_the_month, -> { where.not('start_date > ? OR end_date < ?', Date.tomorrow + 30.days, Date.tomorrow) }
  

  def duration
    if start_date.present? && end_date.present? && end_date > start_date
      (end_date - start_date).to_i
    end
  end

  def remaing_days_until_custom_date(custom_date)
    if start_date.present? && end_date.present? && end_date > start_date
      if Date.tomorrow > end_date
        0
      elsif Date.tomorrow < start_date
        if custom_date <= end_date
          (custom_date - start_date).to_i
        else
          (end_date - start_date).to_i
        end
      else
        if custom_date <= end_date
          (custom_date - start_date).to_i - (Date.tomorrow - start_date).to_i
        else
          (end_date - start_date + 1).to_i - (Date.tomorrow - start_date).to_i
        end
      end
    end
  end

  def code
    if id.present? && room&.code.present?
      formatted_id = '%02d' % id
      "#{room.code}-#{formatted_id}"
    end
  end

  private

  def already_reserved
    if start_date.present? && end_date.present? && room_id.present?
      if (Reservation.where("room_id = ? AND start_date < ? AND end_date > ?", room_id, end_date, start_date)).any?
        errors.add(:base, :invalid_dates, message: 'The room is already reserved on these dates')
      end
    end
  end

  def room_with_insufficient_capacity
    if room_id.present? && number_of_guests.present? && Room.find(room_id).capacity < number_of_guests
      errors.add(:base, :invalid_number_of_guests, message: 'The selected room does not have enough capacity')
    end
  end

  def start_date_is_before_end_date
    if start_date.present? && end_date.present? && start_date >= end_date
      errors.add(:base, :invalid_dates, message: 'The start date should be before the end date')
    end
  end
end

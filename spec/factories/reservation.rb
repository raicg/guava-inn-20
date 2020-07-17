FactoryBot.define do
  factory :reservation do
    start_date { FFaker::Time.between(Date.tomorrow + 1.day, Date.tomorrow + 30.days) }
    end_date { FFaker::Time.between(Date.tomorrow + 31.days, Date.tomorrow + 60.days) }
    room { Room.last || create(:room) }
    number_of_guests { rand(room.capacity) + 1 }
    guest_name { FFaker::Name.name }
  end
end
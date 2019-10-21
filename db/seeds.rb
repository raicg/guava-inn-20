# Rooms

room_101 = Room.create!(
  code: '101',
  capacity: 2,
)

room_102 = Room.create!(
  code: '102',
  capacity: 4,
)

room_103 = Room.create!(
  code: '103',
  capacity: 5,
)

room_201 = Room.create!(
  code: '201',
  capacity: 4,
)

room_202 = Room.create!(
  code: '202',
  capacity: 6,
)

room_203 = Room.create!(
  code: '203',
  capacity: 2,
)

# Reservations

Reservation.create!(
  room: room_101,
  guest_name: 'Maria da Paz',
  number_of_guests: 2,
  start_date: '2020-07-28',
  end_date: '2020-07-29',
)

Reservation.create!(
  room: room_101,
  guest_name: 'José Santos',
  number_of_guests: 1,
  start_date: '2020-07-29',
  end_date: '2020-08-02',
)

Reservation.create!(
  room: room_102,
  guest_name: 'Rafaela Silva',
  number_of_guests: 4,
  start_date: '2020-07-28',
  end_date: '2020-07-31',
)

Reservation.create!(
  room: room_102,
  guest_name: 'Tiago Carvalho',
  number_of_guests: 4,
  start_date: '2020-07-30',
  end_date: '2020-08-04',
)

Reservation.create!(
  room: room_102,
  guest_name: 'Carolina Queiroz',
  number_of_guests: 5,
  start_date: '2020-08-04',
  end_date: '2020-08-10',
)

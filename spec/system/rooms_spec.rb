require 'rails_helper'

RSpec.describe 'Rooms', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  describe 'listing' do
    context 'when there are rooms' do
      let!(:room){ create(:room) }
      let!(:room2){ create(:room) }

      it 'shows all rooms in the system with their respective details' do
        visit rooms_path

        expect(page).to have_content('Rooms')

        within('table') do
          within('thead') do
            expect(page).to have_content('Code')
            expect(page).to have_content('Capacity')
            expect(page).to have_content('Occupation')
            expect(page).to have_content('Actions')
          end

          within('tbody tr:first-child') do
            expect(page).to have_content(room.code)
            expect(page).to have_content("#{room.capacity} people")
            expect(page).to have_link('Show', href: room_path(Room.first.id))
            expect(page).to have_link('Edit', href: edit_room_path(Room.first.id))
          end

          within('tbody tr:last-child') do
            expect(page).to have_content(room2.code)
            expect(page).to have_content("#{room2.capacity} people")
            expect(page).to have_link('Show', href: room_path(Room.last.id))
            expect(page).to have_link('Edit', href: edit_room_path(Room.last.id))
          end
        end
      end

      it 'allows users to delete a room' do
        visit rooms_path

        expect(page).to have_selector('table tbody tr', count: 2)

        within('table tbody tr:first-child') do
          accept_alert do
            click_link 'Destroy'
          end
        end

        expect(page).to have_selector('table tbody tr', count: 1)
        expect(page).to have_content('Room was successfully destroyed')
      end

      it 'has a link to create a new room' do
        visit rooms_path

        expect(page).to have_link('New Room', href: new_room_path)
      end

      it 'has a link to create a new reservation' do
        visit rooms_path

        expect(page).to have_link('New Reservation', href: search_reservations_path)
      end
    end
    
    context 'when there are no rooms' do
      it 'shows an empty listing' do
        visit rooms_path

        within('table') do
          expect(page).to have_content('There are no rooms')
        end
      end
    end
  end

  describe 'new room' do
    it 'allows users to create a new room' do
      visit new_room_path

      expect(page).to have_content('New Room')

      fill_in 'Code', with: '204'
      select '3', from: 'Capacity'
      click_on 'Create Room'

      expect(page).to have_current_path(room_path(Room.last.id))
      expect(page).to have_content('Room was successfully created')
    end

    it 'shows an error message when there is a validation error' do
      visit new_room_path
      click_on 'Create Room'

      expect(page).to have_content("can't be blank")
    end

    it 'has a link to go back to the listing' do
      visit new_room_path

      expect(page).to have_link('Back', href: rooms_path)
    end
  end

  describe 'show room' do
    let!(:room){ create(:room) }

    context 'when there are reservations' do
      let!(:reservation){ create(:reservation) }

      it 'shows the details of a room including its reservations' do
        visit room_path(room.id)

        expect(page).to have_content("Room #{room.code}")
        expect(page).to have_content("Code: #{room.code}")
        expect(page).to have_content("Capacity: #{room.capacity}")
        expect(page).to have_content("Notes: #{room.notes}")

        within('table') do
          within('thead') do
            expect(page).to have_content('Number')
            expect(page).to have_content('Period')
            expect(page).to have_content('Duration')
            expect(page).to have_content('Guest Name')
            expect(page).to have_content('# of guests')
            expect(page).to have_content('Actions')
          end

          within('tbody tr:first-child') do
            expect(page).to have_content("#{reservation.code}")
            expect(page).to have_content("#{reservation.start_date.to_s} to #{reservation.end_date.to_s}")
            expect(page).to have_content("#{reservation.duration} nights")
            expect(page).to have_content(reservation.guest_name)
            expect(page).to have_content("#{reservation.number_of_guests} guest")
          end
        end
      end

      it 'allows users to delete a reservation' do
        visit room_path(room.id)

        expect(page).to have_selector('table tbody tr', count: 1)

        within('table tbody tr:first-child') do
          accept_alert do
            click_link 'Destroy'
          end
        end

        expect(page).to have_selector('table tbody tr', count: 1)
        expect(page).to have_content("Reservation #{reservation.code} was successfully destroyed.")
        expect(page).to have_content('There are no reservations for this room yet.')
      end

      it 'has a link to edit the room details' do
        visit room_path(room.id)

        expect(page).to have_link('Edit', href: edit_room_path(room.id))
      end

      it 'has a link to go back to the listing' do
        visit room_path(room.id)

        expect(page).to have_link('Back', href: rooms_path)
      end
    end

    context 'when the room has no reservations' do
      it 'shows an empty listing' do
        visit room_path(room.id)

        within('table') do
          expect(page).to have_content('There are no reservations for this room')
        end
      end
    end
  end

  describe 'edit room' do
    let!(:room){ create(:room) }

    it 'allows users to change attributes of a room' do
      visit edit_room_path(room.id)

      fill_in 'Code', with: '190'
      click_on 'Update Room'

      expect(page).to have_current_path(room_path(room.id))
      expect(page).to have_content('Room was successfully updated')
    end

    it 'shows an error message when there is a validation error' do
      visit edit_room_path(room.id)

      fill_in 'Code', with: ''
      click_on 'Update Room'

      expect(page).to have_content("can't be blank")
    end

    it 'has a link to show the room details' do
      visit edit_room_path(room.id)

      expect(page).to have_link('Show', href: room_path(room.id))
    end

    it 'has a link to go back to the listing' do
      visit edit_room_path(room.id)

      expect(page).to have_link('Back', href: rooms_path)
    end
  end
end

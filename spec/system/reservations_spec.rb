require 'rails_helper'

RSpec.describe 'Reservations', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  describe 'searching' do
    let!(:room) { create(:room) }

    before do
      visit search_reservations_path

      expect(page).to have_content('New Reservation')

      fill_in 'From', with: Date.tomorrow
      fill_in 'To', with: Date.tomorrow + 5.days
      select '1', from: '# of guests'
      click_on 'Search for Available Rooms'
      visit search_reservations_path

      expect(page).to have_content('New Reservation')

      fill_in 'From', with: Date.tomorrow
      fill_in 'To', with: Date.tomorrow + 5.days
      select '1', from: '# of guests'
      click_on 'Search for Available Rooms'
    end

    it 'allows users to search for available rooms with a given capacity in a period' do
      expect(page).to have_content('Available Rooms')

      within('table') do
        within('thead') do
          expect(page).to have_content('Code')
          expect(page).to have_content('Capacity')
          expect(page).to have_content('Actions')
        end

        within('tbody tr:first-child') do
          expect(page).to have_content(room.code)
          expect(page).to have_content("#{room.capacity} people")
          expect(page).to have_link('Create Reservation')
        end
      end
    end

    context 'after search for available rooms' do
      before do
        click_on 'Create Reservation'

        expect(page).to have_content('New Reservation')

        fill_in 'Guest name', with: FFaker::Name.name
        click_on 'Create Reservation'
        @reservation = Reservation.last
      end

      it 'allows users to create new reservations' do
        expect(page).to have_content("Room #{room.code}")

        within('table') do
          within('thead') do
            expect(page).to have_content('Number')
            expect(page).to have_content('Period')
            expect(page).to have_content('Duration')
            expect(page).to have_content('Guest Name')
            expect(page).to have_content('# of guests')
            expect(page).to have_content('Actions')
          end

          within('tbody tr:last-child') do
            expect(page).to have_content(@reservation.code)
            expect(page).to have_content("#{@reservation.start_date} to #{@reservation.end_date}")
            expect(page).to have_content("#{@reservation.duration} nights")
            expect(page).to have_content(@reservation.guest_name)
            expect(page).to have_content(@reservation.number_of_guests)
            expect(page).to have_link('Destroy')
          end
        end
      end

      context 'after create a reservation' do
        it 'allows users to delete reservations' do
          within('tbody tr:last-child') do
            accept_alert do
              click_link 'Destroy'
            end
          end

          expect(page).to have_content("Reservation #{@reservation.code} was successfully destroyed.")
        end
      end
    end
  end
end

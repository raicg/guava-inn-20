require 'rails_helper'

RSpec.describe ReservationsController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/reservations/new').to route_to('reservations#new')
    end

    it 'routes to #create' do
      expect(post: '/reservations').to route_to('reservations#create')
    end

    it 'routes to #destroy' do
      expect(delete: '/reservations/1').to route_to('reservations#destroy', id: '1')
    end

    it 'routes to #search' do
      expect(get: '/reservations/search').to route_to('reservations#search')
    end
  end
end

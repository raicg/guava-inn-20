require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  let!(:room) { create(:room) }
  let!(:reservation) { create(:reservation) }
  let(:valid_attributes) { build(:reservation, start_date: '2019-01-01', end_date: '2019-02-02').attributes }

  describe "GET /reservations/new" do
    it "works!" do
      get new_reservation_path, params: { reservation: valid_attributes }

      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE /reservations/1" do
    it "works!" do
      expect {
        delete reservation_path(reservation)
      }.to change(Reservation, :count).by(-1)
    end

    it "should redirect to the rooms index" do
      delete reservation_path(reservation)

      expect(response).to redirect_to(room_url(room))
    end
  end

  describe "POST /reservations" do
    it "works!" do
      expect {
        post reservations_path, params: { reservation: valid_attributes }
      }.to change(Reservation, :count).by(1)
    end

    it "should redirect to the room" do
      post reservations_path, params: { reservation: valid_attributes }

      expect(response).to redirect_to(room_url(room))
    end
  end

  describe "get /reservations/search" do
    it "works!" do
      get search_reservations_path

      expect(response).to have_http_status(200)
    end
  end
end

require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  let!(:room) { create(:room) }
  let(:valid_attributes) { build(:room).attributes }

  describe "GET /rooms" do
    it "works!" do
      get rooms_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /rooms/1" do
    it "works!" do
      get room_path(room)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /rooms/new" do
    it "works!" do
      get new_room_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /rooms/1/edit" do
    it "works!" do
      get edit_room_path(room)
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE /rooms/1" do
    it "works!" do
      expect {
        delete room_path(room)
      }.to change(Room, :count).by(-1)
    end

    it "should redirect to the rooms index" do
      delete room_path(room)

      expect(response).to redirect_to(rooms_url)
    end
  end

  describe "PUT /rooms/1" do
    it "works!" do
      put room_path(room), params: { room: valid_attributes }
      room.reload

      expect(room.code).to eq(valid_attributes['code'])
    end

    it "should redirect to the room" do
      put room_path(room), params: { room: valid_attributes }
      room.reload

      expect(response).to redirect_to(room_url(room))
    end
  end

  describe "PATCH /rooms/1" do
    it "works!" do
      patch room_path(room), params: { room: valid_attributes }
      room.reload

      expect(room.code).to eq(valid_attributes['code'])
    end

    it "should redirect to the room" do
      patch room_path(room), params: { room: valid_attributes }
      room.reload

      expect(response).to redirect_to(room_url(room))
    end
  end

  describe "POST /rooms" do
    it "works!" do
      expect {
        post rooms_path, params: { room: valid_attributes }
      }.to change(Room, :count).by(1)
    end

    it "should redirect to the room" do
      post rooms_path, params: { room: valid_attributes }

      expect(response).to redirect_to(room_url(Room.last))
    end
  end
end

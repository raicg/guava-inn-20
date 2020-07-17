class ReservationsController < ApplicationController
  def search
    @should_show_results = params.dig(:reservation, :start_date).present? &&
      params.dig(:reservation, :end_date).present? &&
      params.dig(:reservation, :number_of_guests).present? &&
      params.dig(:reservation, :end_date) > params.dig(:reservation, :start_date)
    if @should_show_results
      @not_available_rooms = Room.joins(:reservations).where('start_date < ? AND end_date > ?', params.dig(:reservation, :end_date), params.dig(:reservation, :start_date))
      @available_rooms = (Room.where('capacity >= ?', params.dig(:reservation, :number_of_guests)) - @not_available_rooms).paginate(page: params[:page])
    else
      @available_rooms = Room.none.paginate(page: params[:page])
    end
  end

  def new
    @reservation = Reservation.new(reservation_params)
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      redirect_to @reservation.room,
        notice: "Reservation #{@reservation.code} was successfully created."
    else
      render :new
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    redirect_to room_path(@reservation.room),
      notice: "Reservation #{@reservation.code} was successfully destroyed."
  end

  private
    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date, :number_of_guests, :guest_name, :room_id)
    end
end

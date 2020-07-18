class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  def index
    @rooms = Room.all.paginate(page: params[:page])
    if @rooms.any?
      @occupations_per_room_on_week = {}
      @grouped_reservations_on_week = Reservation.of_the_week.group_by { |r| r.room_id }
      @grouped_reservations_on_week.each do |reservations|
        @occupations_per_room_on_week[reservations[0]] = get_percentage_of_reserved_days(reservations[1], 7)
      end

      @occupations_per_room_on_month = {}
      @grouped_reservations_on_month = Reservation.of_the_month.group_by { |r| r.room_id }
      @grouped_reservations_on_month.each do |reservations|
        @occupations_per_room_on_month[reservations[0]] = get_percentage_of_reserved_days(reservations[1], 30)
      end

      @global_week_occupation = average_sum_of_reserved_days(@occupations_per_room_on_week, @rooms.count)
      @global_month_occupation = average_sum_of_reserved_days(@occupations_per_room_on_month, @rooms.count)
    end
  end

  def show
    reservations_of_the_week = Reservation.of_the_week.where(room: @room)
    @room_week_occupation = get_percentage_of_reserved_days(reservations_of_the_week, 7)

    reservations_of_the_month = Reservation.of_the_month.where(room: @room)
    @room_month_occupation = get_percentage_of_reserved_days(reservations_of_the_month, 30)

    @reservations = @room.reservations.paginate(page: params[:page])
  end

  def new
    @room = Room.new
  end

  def edit
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      redirect_to @room, notice: 'Room was successfully created.'
    else
      render :new
    end
  end

  def update
    if @room.update(room_params)
      redirect_to @room, notice: 'Room was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @room.destroy
    redirect_to rooms_url, notice: 'Room was successfully destroyed.'
  end

  private
    def average_sum_of_reserved_days(occupations_per_room, rooms_count)
      occupations_per_room.map { |occupation| occupation[1] }.inject(0, :+) / rooms_count
    end

    def get_percentage_of_reserved_days(reservations, days_limit)
      reservations.map { |reservation| reservation.remaing_days_until_custom_date(Date.tomorrow + days_limit.days) }.inject(0, :+) / days_limit.to_f * 100
    end

    def room_params
      params.require(:room).permit(:code, :capacity, :notes)
    end

    def set_room
      @room = Room.find(params[:id])
    end
end

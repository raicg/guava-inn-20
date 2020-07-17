class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  def index
    @rooms = Room.all
    if @rooms.any?
      @occupations_per_room_on_week = {}
      @grouped_reservations_on_week = Reservation.where.not('start_date > ? OR end_date < ?', Date.tomorrow + 7.days, Date.tomorrow).group_by{ |r| r.room_id }
      @grouped_reservations_on_week.each do |reservations|
        @occupations_per_room_on_week[reservations[0]] = reservations[1].map{ |reservation| reservation.remaing_days_until_custom_date(Date.tomorrow + 7.days) }.inject(0, :+) / 7.0 * 100
      end
      
      @occupations_per_room_on_month = {}
      @grouped_reservations_on_month = Reservation.where.not('start_date > ? OR end_date < ?', Date.tomorrow + 30.days, Date.tomorrow).group_by{ |r| r.room_id }
      @grouped_reservations_on_month.each do |reservations|
        @occupations_per_room_on_month[reservations[0]] = reservations[1].map{ |reservation| reservation.remaing_days_until_custom_date(Date.tomorrow + 30.days) }.inject(0, :+) / 30.0 * 100 
      end
      
      @global_week_occupation = @occupations_per_room_on_week.map{ |occupation| occupation[1] }.inject(0, :+) / @rooms.count
      @global_month_occupation = @occupations_per_room_on_month.map{ |occupation| occupation[1] }.inject(0, :+) / @rooms.count
    end
  end

  def show
    @room_week_occupation = (Reservation.where(room: @room).where.not('start_date > ? OR end_date < ?', Date.tomorrow + 7.days, Date.tomorrow)
        .map { |r| r.remaing_days_until_custom_date(Date.tomorrow + 7.days) }).inject(0, :+) / 7.0 * 100
    
    @room_month_occupation = (Reservation.where(room: @room).where.not('start_date > ? OR end_date < ?', Date.tomorrow + 30.days, Date.tomorrow)
        .map { |r| r.remaing_days_until_custom_date(Date.tomorrow + 30.days) }).inject(0, :+) / 30.0 * 100
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
    def set_room
      @room = Room.find(params[:id])
    end

    def room_params
      params.require(:room).permit(:code, :capacity, :notes)
    end
end

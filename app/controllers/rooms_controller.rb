class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  def index
    @rooms = Room.all
    @global_week_occupation = ((Reservation.where.not('start_date > ? OR end_date < ?', Date.tomorrow + 7.days, Date.tomorrow)
        .map { |r| r.remaing_days_until_custom_date(Date.tomorrow + 7.days) }).inject(0, :+) / @rooms.count) / 7.0 * 100
    
    @global_month_occupation = ((Reservation.where.not('start_date > ? OR end_date < ?', Date.tomorrow + 30.days, Date.tomorrow)
        .map { |r| r.remaing_days_until_custom_date(Date.tomorrow + 30.days) }).inject(0, :+) / @rooms.count) / 30.0 * 100
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

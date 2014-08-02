class TwitterUsersController < ApplicationController

  before_action :set_twitter_user, only: [:show, :edit, :update, :destroy]

  # GET /twitter_users
  # GET /twitter_users.json
  def index
    @twitter_users = TwitterUser.all
    @friends = [ ]
    @twitter_users.each do |user|
      profile = JSON.parse(user[:profile], symbolize_names: true)
      size    = Math.log(profile[:friends_count])
      color   = { true => 'fill:cyan', false => 'fill:black' }[profile[:verified]]
      @friends << { handle: user[:handle], x: rand(1000), y: rand(800), r: size, c: color }
    end
    @user = TwitterUser.where( handle: 'BarackObama' ).first
    @profile = JSON.parse(@user[:profile], symbolize_names: true)
  end

  def profile
    respond_to do |format|
      @user = TwitterUser.where( handle: params[:id] ).first
      @profile = JSON.parse(@user[:profile], symbolize_names: true)
      
      format.json do 
        render json: @profile
      end

      format.html do
        render partial: "profile"
      end
    end
  end
  
  # GET /twitter_users/1
  # GET /twitter_users/1.json
  def show
  end
  
  # GET /twitter_users/new
  def new
    @twitter_user = TwitterUser.new
  end

  # GET /twitter_users/1/edit
  def edit
  end

  # POST /twitter_users
  # POST /twitter_users.json
  def create
    @twitter_user = TwitterUser.new(twitter_user_params)

    respond_to do |format|
      if @twitter_user.save
        format.html { redirect_to @twitter_user, notice: 'Twitter user was successfully created.' }
        format.json { render :show, status: :created, location: @twitter_user }
      else
        format.html { render :new }
        format.json { render json: @twitter_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /twitter_users/1
  # PATCH/PUT /twitter_users/1.json
  def update
    respond_to do |format|
      if @twitter_user.update(twitter_user_params)
        format.html { redirect_to @twitter_user, notice: 'Twitter user was successfully updated.' }
        format.json { render :show, status: :ok, location: @twitter_user }
      else
        format.html { render :edit }
        format.json { render json: @twitter_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /twitter_users/1
  # DELETE /twitter_users/1.json
  def destroy
    @twitter_user.destroy
    respond_to do |format|
      format.html { redirect_to twitter_users_url, notice: 'Twitter user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_twitter_user
    @twitter_user = TwitterUser.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def twitter_user_params
    params.require(:twitter_user).permit(:name, :handle, :stats, :profile, :twitter_id, :topics)
  end

end


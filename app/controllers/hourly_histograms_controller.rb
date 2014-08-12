class HourlyHistogramsController < ApplicationController
  before_action :set_hourly_histogram, only: [:show, :edit, :update, :destroy]

  # GET /hourly_histograms
  # GET /hourly_histograms.json
  def index
    @hourly_histograms = HourlyHistogram.all
  end

  # GET /hourly_histograms/1
  # GET /hourly_histograms/1.json
  def show
  end

  # GET /hourly_histograms/new
  def new
    @hourly_histogram = HourlyHistogram.new
  end

  # GET /hourly_histograms/1/edit
  def edit
  end

  # POST /hourly_histograms
  # POST /hourly_histograms.json
  def create
    @hourly_histogram = HourlyHistogram.new(hourly_histogram_params)

    respond_to do |format|
      if @hourly_histogram.save
        format.html { redirect_to @hourly_histogram, notice: 'Hourly histogram was successfully created.' }
        format.json { render :show, status: :created, location: @hourly_histogram }
      else
        format.html { render :new }
        format.json { render json: @hourly_histogram.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hourly_histograms/1
  # PATCH/PUT /hourly_histograms/1.json
  def update
    respond_to do |format|
      if @hourly_histogram.update(hourly_histogram_params)
        format.html { redirect_to @hourly_histogram, notice: 'Hourly histogram was successfully updated.' }
        format.json { render :show, status: :ok, location: @hourly_histogram }
      else
        format.html { render :edit }
        format.json { render json: @hourly_histogram.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hourly_histograms/1
  # DELETE /hourly_histograms/1.json
  def destroy
    @hourly_histogram.destroy
    respond_to do |format|
      format.html { redirect_to hourly_histograms_url, notice: 'Hourly histogram was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hourly_histogram
      @hourly_histogram = HourlyHistogram.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hourly_histogram_params
      params.require(:hourly_histogram).permit(:name, :tweet_count, :since_id, :histogram, :metric, :stream)
    end
end

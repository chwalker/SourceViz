class WeeklyHistogramsController < ApplicationController
  before_action :set_weekly_histogram, only: [:show, :edit, :update, :destroy]

  # GET /weekly_histograms
  # GET /weekly_histograms.json
  def index
    @weekly_histograms = WeeklyHistogram.all
  end

  # GET /weekly_histograms/1
  # GET /weekly_histograms/1.json
  def show
  end

  # GET /weekly_histograms/new
  def new
    @weekly_histogram = WeeklyHistogram.new
  end

  # GET /weekly_histograms/1/edit
  def edit
  end

  # POST /weekly_histograms
  # POST /weekly_histograms.json
  def create
    @weekly_histogram = WeeklyHistogram.new(weekly_histogram_params)

    respond_to do |format|
      if @weekly_histogram.save
        format.html { redirect_to @weekly_histogram, notice: 'Weekly histogram was successfully created.' }
        format.json { render :show, status: :created, location: @weekly_histogram }
      else
        format.html { render :new }
        format.json { render json: @weekly_histogram.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /weekly_histograms/1
  # PATCH/PUT /weekly_histograms/1.json
  def update
    respond_to do |format|
      if @weekly_histogram.update(weekly_histogram_params)
        format.html { redirect_to @weekly_histogram, notice: 'Weekly histogram was successfully updated.' }
        format.json { render :show, status: :ok, location: @weekly_histogram }
      else
        format.html { render :edit }
        format.json { render json: @weekly_histogram.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /weekly_histograms/1
  # DELETE /weekly_histograms/1.json
  def destroy
    @weekly_histogram.destroy
    respond_to do |format|
      format.html { redirect_to weekly_histograms_url, notice: 'Weekly histogram was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_weekly_histogram
      @weekly_histogram = WeeklyHistogram.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def weekly_histogram_params
      params.require(:weekly_histogram).permit(:name, :tweet_count, :since_id, :histogram, :metric, :stream)
    end
end

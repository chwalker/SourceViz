class DailyHistogramsController < ApplicationController
  before_action :set_daily_histogram, only: [:show, :edit, :update, :destroy]

  # GET /daily_histograms
  # GET /daily_histograms.json
  def index
    @daily_histograms = DailyHistogram.all
  end

  # GET /daily_histograms/1
  # GET /daily_histograms/1.json
  def show
  end

  # GET /daily_histograms/new
  def new
    @daily_histogram = DailyHistogram.new
  end

  # GET /daily_histograms/1/edit
  def edit
  end

  # POST /daily_histograms
  # POST /daily_histograms.json
  def create
    @daily_histogram = DailyHistogram.new(daily_histogram_params)

    respond_to do |format|
      if @daily_histogram.save
        format.html { redirect_to @daily_histogram, notice: 'Daily histogram was successfully created.' }
        format.json { render :show, status: :created, location: @daily_histogram }
      else
        format.html { render :new }
        format.json { render json: @daily_histogram.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /daily_histograms/1
  # PATCH/PUT /daily_histograms/1.json
  def update
    respond_to do |format|
      if @daily_histogram.update(daily_histogram_params)
        format.html { redirect_to @daily_histogram, notice: 'Daily histogram was successfully updated.' }
        format.json { render :show, status: :ok, location: @daily_histogram }
      else
        format.html { render :edit }
        format.json { render json: @daily_histogram.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /daily_histograms/1
  # DELETE /daily_histograms/1.json
  def destroy
    @daily_histogram.destroy
    respond_to do |format|
      format.html { redirect_to daily_histograms_url, notice: 'Daily histogram was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daily_histogram
      @daily_histogram = DailyHistogram.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def daily_histogram_params
      params.require(:daily_histogram).permit(:name, :tweet_count, :since_id, :histogram, :metric, :stream)
    end
end

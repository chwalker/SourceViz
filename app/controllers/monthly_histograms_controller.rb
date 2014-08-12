class MonthlyHistogramsController < ApplicationController
  before_action :set_monthly_histogram, only: [:show, :edit, :update, :destroy]

  # GET /monthly_histograms
  # GET /monthly_histograms.json
  def index
    @monthly_histograms = MonthlyHistogram.all
  end

  # GET /monthly_histograms/1
  # GET /monthly_histograms/1.json
  def show
  end

  # GET /monthly_histograms/new
  def new
    @monthly_histogram = MonthlyHistogram.new
  end

  # GET /monthly_histograms/1/edit
  def edit
  end

  # POST /monthly_histograms
  # POST /monthly_histograms.json
  def create
    @monthly_histogram = MonthlyHistogram.new(monthly_histogram_params)

    respond_to do |format|
      if @monthly_histogram.save
        format.html { redirect_to @monthly_histogram, notice: 'Monthly histogram was successfully created.' }
        format.json { render :show, status: :created, location: @monthly_histogram }
      else
        format.html { render :new }
        format.json { render json: @monthly_histogram.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /monthly_histograms/1
  # PATCH/PUT /monthly_histograms/1.json
  def update
    respond_to do |format|
      if @monthly_histogram.update(monthly_histogram_params)
        format.html { redirect_to @monthly_histogram, notice: 'Monthly histogram was successfully updated.' }
        format.json { render :show, status: :ok, location: @monthly_histogram }
      else
        format.html { render :edit }
        format.json { render json: @monthly_histogram.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /monthly_histograms/1
  # DELETE /monthly_histograms/1.json
  def destroy
    @monthly_histogram.destroy
    respond_to do |format|
      format.html { redirect_to monthly_histograms_url, notice: 'Monthly histogram was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monthly_histogram
      @monthly_histogram = MonthlyHistogram.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def monthly_histogram_params
      params.require(:monthly_histogram).permit(:name, :tweet_count, :since_id, :histogram, :metric, :stream)
    end
end

class BatchHistogramsController < ApplicationController
  before_action :set_batch_histogram, only: [:show, :edit, :update, :destroy]

  # GET /batch_histograms
  # GET /batch_histograms.json
  def index
    @batch_histograms = BatchHistogram.all
  end

  # GET /batch_histograms/1
  # GET /batch_histograms/1.json
  def show
  end

  # GET /batch_histograms/new
  def new
    @batch_histogram = BatchHistogram.new
  end

  # GET /batch_histograms/1/edit
  def edit
  end

  # POST /batch_histograms
  # POST /batch_histograms.json
  def create
    @batch_histogram = BatchHistogram.new(batch_histogram_params)

    respond_to do |format|
      if @batch_histogram.save
        format.html { redirect_to @batch_histogram, notice: 'Batch histogram was successfully created.' }
        format.json { render :show, status: :created, location: @batch_histogram }
      else
        format.html { render :new }
        format.json { render json: @batch_histogram.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /batch_histograms/1
  # PATCH/PUT /batch_histograms/1.json
  def update
    respond_to do |format|
      if @batch_histogram.update(batch_histogram_params)
        format.html { redirect_to @batch_histogram, notice: 'Batch histogram was successfully updated.' }
        format.json { render :show, status: :ok, location: @batch_histogram }
      else
        format.html { render :edit }
        format.json { render json: @batch_histogram.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /batch_histograms/1
  # DELETE /batch_histograms/1.json
  def destroy
    @batch_histogram.destroy
    respond_to do |format|
      format.html { redirect_to batch_histograms_url, notice: 'Batch histogram was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch_histogram
      @batch_histogram = BatchHistogram.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def batch_histogram_params
      params.require(:batch_histogram).permit(:name, :tweet_count, :since_id, :histogram, :metric)
    end
end

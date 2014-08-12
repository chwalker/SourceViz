module AggregationHelper

  include ApplicationHelper
  include TweetsHelper

  TARGETED_ENTITIES = [ :tokens, :mentions, :hashtags, :symbols, :urls ]  ## TODO: dry
  TARGETED_METRICS  = [ :document_frequency, :term_frequency ]
  TARGETED_STREAMS  = [ :home_timeline ]
  
  SOURCE_CLASS = {
    hour: BatchHistogram,
    day: HourlyHistogram,
    week: DailyHistogram,
    month: WeeklyHistogram,
    year: MonthlyHistogram
  }
  
  TARGET_CLASS = {
    hour: HourlyHistogram, 
    day: DailyHistogram,
    week: WeeklyHistogram,
    month: MonthlyHistogram
    # year: YearlyHistogram
  }

  GRAIN_INTERVAL = {
    hour: 1.hour,
    day: 1.day,
    week: 1.week,
    month: 1.month,
    year: 1.year
  }
  
  def aggregate(grain=:hour)
    t1 = DateTime.now()
    t0  = t1 - GRAIN_INTERVAL[grain] 
    TARGETED_STREAMS.each do |stream|
      TARGETED_ENTITIES.each do |name|
        TARGETED_METRICS.each do |metric|
          new_histogram = Hash.new(0.0)
          details = { tweet_count: 0, stream: stream, name: name, metric: metric }
          query = { created_at: t0..t1, stream: stream, name: name, metric: metric }
          SOURCE_CLASS[grain].where(query).each do |old_record|
            details[:since_id] ||= old_record.since_id
            details[:tweet_count] += old_record.tweet_count
            old_histogram = JSON.parse(old_record.histogram, symbolize_names: true)
            new_histogram = reduce_histograms([ new_histogram, old_histogram ]) 
          end
          details[:histogram] = new_histogram.to_json
          record = TARGET_CLASS[grain].new(details)
          warn "Failed to save batch: #{record.inspect}" unless record.save
          $stderr << '.'
        end
      end
    end
  end    

end

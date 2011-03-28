require "gattica"

class CingelAdmin::DashboardController < Admin::BaseController
  @@_ga_connection = nil
  
  def index
    set_start_and_end_date
  end
  
  def get_analytics_data
    set_start_and_end_date
    @referring_sites = ga_connection.get(ga_report(:dimensions => ["source", "medium"], :filters => "medium==referral"))
    @keywords = ga_connection.get(ga_report(:dimensions => "keyword", :filters => "keyword!=(not set)"))
    @countries = ga_connection.get(ga_report(:dimensions => "country"))
    @traffic_overview = ga_connection.get(ga_report(:dimensions => "medium"))
    @metrics_by_date = ga_connection.get(ga_report(:dimensions => "date", :metrics => ["pageviews", "visits", "visitors"], :max_results => 10000, :sort => "date"))
    @total_visitors, @total_visits, @total_pageviews = 0, 0, 0
    @visitors_chart_data, @visits_chart_data, @pageviews_chart_data = [], [], []
    @metrics_by_date.points.each do |point|
      miliseconds = Date.parse(point.dimensions[0][:date]).to_time.to_i * 1000
      pageviews = point.metrics[0][:pageviews].to_i
      visits = point.metrics[1][:visits].to_i
      visitors = point.metrics[2][:visitors].to_i
      @total_visitors += visitors
      @total_visits += visits
      @total_pageviews += pageviews
      @visits_chart_data << [miliseconds, visits]
      @pageviews_chart_data << [miliseconds, pageviews]
      @visitors_chart_data << [miliseconds, visitors]
    end
    render :update do |page|
      page.assign "Dashboard.startDate", @start_date.to_s(:db)
      page.assign "Dashboard.endDate", @end_date.to_s(:db)
      page.call "Dashboard.chart.series[0].setData", @visitors_chart_data, false
      page.call "Dashboard.chart.series[1].setData", @visits_chart_data, false
      page.call "Dashboard.chart.series[2].setData", @pageviews_chart_data, false
      page.call "Dashboard.chart.redraw"
      page.replace_html :period_option_0, "#{l(@start_date)} - #{l(@end_date)}"
      page.replace_html :reports_wrapper, :partial => "reports"
    end
  end
  
  private
  
    def set_start_and_end_date
      if params[:end_date] and params[:start_date]
        @end_date = Date.parse(params[:end_date])
        @start_date = Date.parse(params[:start_date])
      else
        @end_date = Date.today
        @start_date = Date.today.months_ago(1)
      end
    end
    
    def ga_connection
      @@_ga_connection ||= Gattica.new(CingelAdmin.google_analytics)
    end
    
    def ga_report(options = {})
      options[:metrics] ||= "visits"
      options[:end_date] ||= (@end_date || Date.today).to_s(:db)
      options[:start_date] ||= (@start_date || Date.today.months_ago(1)).to_s(:db)
      options[:sort] ||= "-#{options[:metrics].to_a.first}"
      options[:max_results] ||= 10
      options[:metrics] = options[:metrics].to_a
      options[:dimensions] = options[:dimensions].to_a
      options[:filters] = options[:filters].to_a
      options
    end
  
end

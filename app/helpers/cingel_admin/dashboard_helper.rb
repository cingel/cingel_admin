module CingelAdmin::DashboardHelper
  
  def options_for_period_select
    options = ""
    today = Date.today
    [
      ["#{l(@start_date)} - #{l(@end_date)}", "current"],
      ["Today", today, today],
      ["Yesterday", today.yesterday, today],
      ["Last week", today.ago(60*60*24*7).to_date, today],
      ["Last 2 weeks", today.ago(60*60*24*14).to_date, today],
      ["Last Month", today.months_ago(1), today],
      ["Custom Range", "custom"]
    ].each_with_index { |p,index| options << content_tag(:option, p[0], :value => p[2] ? "#{p[1].to_s(:db)}_#{p[2].to_s(:db)}" : p[1], :id => "period_option_#{index}") }
    raw options
  end
  
  def visits_percentage(visits, total_visits = @total_visits)
    total_visits > 0 ? (visits.to_f/total_visits)*100 : 0
  end
  
  def total_visitors
    @total_visitors ||= 0
  end
  
  def total_visits
    @total_visits ||= 0
  end
  
  def total_pageviews
    @total_pageviews ||= 0
  end
  
  def visits_per_visitor
    vpv = 0
    if total_visits > 0 and total_visitors > 0
      vpv = total_visits / total_visitors.to_f
    end
    number_with_precision(vpv, :precision => 2, :delimiter => ",")
  end
  
  def visits_per_day
    n_days = (@end_date - @start_date) + 1
    vpd = total_visits / n_days.to_f
    number_with_precision(vpd, :precision => 2, :delimiter => ",")
  end
  
  def pages_per_visit
    ppv = 0
    if total_visits > 0 and total_pageviews > 0
      ppv = total_pageviews / total_visits.to_f
    end
    number_with_precision(ppv, :precision => 2, :delimiter => ",")
  end
  
end

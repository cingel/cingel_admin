Rails.application.routes.draw do
  namespace :cingel_admin, :path => :admin, :as => :admin do
    root :to => "dashboard#index"
    match 'dashboard/get_analytics_data' => "dashboard#get_analytics_data", :as => :get_analytics_data
  end
end

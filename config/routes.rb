MinetworkMonitor::Application.routes.draw do
    root :to => 'application#index'

    get '/results', :to => 'application#results'
end

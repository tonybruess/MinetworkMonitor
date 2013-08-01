MinetworkMonitor::Application.routes.draw do
    root :to => 'application#index'

    match ':controller(/:action(/:id(.:format)))'
end

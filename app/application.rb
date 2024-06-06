module Delivery
  class Application < Rails::Application
    config.active_job.queue_adapter = :sidekiq
    config.payment = config_for(:payment)
  end
end
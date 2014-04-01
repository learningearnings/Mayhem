require_relative '../../lib/dynamic_fetch.rb'

Sidekiq.options.merge!({
  fetch: DynamicFetch
})

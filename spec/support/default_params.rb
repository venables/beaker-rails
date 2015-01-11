require 'active_support/concern'

module DefaultParams
  extend ActiveSupport::Concern

  def process_with_default_params(action, http_method = 'GET', *args)
    parameters = args.shift

    parameters = default_params.merge(parameters || {})
    args.unshift(parameters)

    process_without_default_params(action, http_method, *args)
  end

  included do
    let(:default_params) { {} }
    alias_method_chain :process, :default_params
  end
end

RSpec.configure do |config|
  config.include(DefaultParams, type: :controller)
end

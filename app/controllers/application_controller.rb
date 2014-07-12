class ApplicationController < ActionController::Base
  include Authentication
  respond_to :json
end

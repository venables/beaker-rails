class PagesController < ApplicationController
  def home
    render text: '', layout: 'application'
  end
end

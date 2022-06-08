class StaticPagesController < ApplicationController
  def home
    Rails.logger.debug "A debug message"
  end

  def help
    Rails.logger.debug "A debug message"
  end
end

class ApplicationController < ActionController::Base
  require 'will_paginate/array'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end

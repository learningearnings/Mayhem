class ErrorsController < ApplicationController
  
  def not_found
    render :layout => false
  end

  def server_error
    render :layout => false    
  end
  
  def unauthorized
    render :layout => false    
  end
end
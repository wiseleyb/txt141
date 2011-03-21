module ApplicationHelper

  def logged_in?
    !session[:login].blank?
  end
  
end

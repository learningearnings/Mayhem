class Spree::UserMailer < Devise::Mailer   

  def reset_password_instructions(user)
    @edit_password_reset_url = edit_user_password_url(:reset_password_token => user.reset_password_token)

    mail(:to => user.email, :from => "noreply@learningearnings.com",
         :subject => Spree::Config[:site_name] + ' ' + I18n.t(:password_reset_instructions))
  end
  
  def confirmation_instructions(user)
    if Rails.env == "production"
      @confirmation_url = "https://learningearnings.com/confirm/#{user.confirmation_token}"
    elsif Rails.env == "staging"
      @confirmation_url = "http://staging.learningearnings.com/confirm/#{user.confirmation_token}"
    else
      @confirmation_url = "http://lvh.me:3000/confirm/#{user.confirmation_token}"      
    end
    headers['X-MC-Track'] = "False, False"      
    if user.confirmed_at.nil?
      mail(:to => user.email, :from => "noreply@learningearnings.com",
         :subject => 'Learning Earnings user account activation required')
    end
  end  
  
end

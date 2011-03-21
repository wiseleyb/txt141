module ActionMailerMixins
  
  def deliver!(mail = @mail)
    unless ENV['RAILS_ENV'] == "production"
      mail.body = "Mail is disabled. Normally this would have gone to these users: " + [@recipients, @bcc].join(",") + 
                  "\n\n" + @body  
      mail.to = SEND_ALL_EMAIL_TO
      mail.cc = ""
      mail.bcc = ""
    end
    super
  end
  
end
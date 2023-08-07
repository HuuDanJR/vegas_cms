class SystemMailer < ApplicationMailer
  include CommonModule

  def send_email(email_to, email_subject, email_body)
    mail(to: email_to,
           body: email_body,
           content_type: 'text/html',
           subject: email_subject)
  end
end

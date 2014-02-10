class UserMailer < ActionMailer::Base
  
  default from: "santiago.blankleider@gmail.com"

  def welcome_email(provider)
    @provider = provider
    @url      = "localhost:3000/providers"
    mail(to: @provider.email, subject: "Welcome")
  end

end

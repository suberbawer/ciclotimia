class UserMailer < ActionMailer::Base
  
  default from: "santiago.blankleider@gmail.com"

  def new_articles_provider(provider)
    @provider = provider
    @url      = "localhost:3000/providers"
    mail(to: @provider.email, subject: "Welcome")
  end

end

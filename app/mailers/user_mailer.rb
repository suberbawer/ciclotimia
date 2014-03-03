class UserMailer < ActionMailer::Base
  
  default from: "ciclotimia.moda@gmail.com"

  def new_articles_provider(provider)
    @provider = provider
    @url      = "localhost:3000/providers"
    mail(to: @provider.email, subject: "Remito")
  end

end

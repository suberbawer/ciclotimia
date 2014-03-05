class UserMailer < ActionMailer::Base
  
  default from: "ciclotimia.moda@gmail.com"

  def new_articles_provider(provider)
    @provider = provider
    @list_articles_not_sent = @provider.get_articles_not_sent
    @url      = "localhost:3000/providers"
	mail(to: @provider.email, subject: "Remito")
  end
end

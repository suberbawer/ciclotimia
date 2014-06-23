class UserMailer < ActionMailer::Base
  
  default from: "ciclotimia.moda@gmail.com"

  def new_articles_provider(provider)
    @provider = provider
    @list_articles_not_sent = @provider.get_articles_not_sent
    @url      = "localhost:3000/providers"
    attachments.inline['logo.png'] = File.read('app/assets/images/logo.png')
	  mail(to: @provider.email, subject: "Remito")
  end

  def send_billing_monthly(provider)
  	@provider = provider
  	@url      = "localhost:3000/providers"
    attachments.inline['logo.png'] = File.read('app/assets/images/logo.png')
  	mail(to: @provider.email, subject: "Factura Mensual")
  end
end

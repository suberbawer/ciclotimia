class BillingsController < ApplicationController

	def index
		@providers_to_print = set_list_to_print
	end

	def own_facturation
		@providers_to_print = set_list_to_print
	end

	def provider_month_total
		@providers_to_print = set_list_to_print
		return_change_monthly
	end

	def rent_facturation
		@rents_to_print = set_list_of_rents_to_print
	end

	def send_billing_monthly
		sent = true
		@providers_to_print = set_list_to_print
		begin
			@providers_to_print.each do |provider|
				provider.instance_variable_get('@custom_input_list').each do |input|
					if input.sent.nil? || !input.sent
						sent = false
					end
				end
				
				if !sent 
					UserMailer.send_billing_monthly(provider).deliver
					provider.instance_variable_get('@custom_input_list').each do |input|
						input.sent = true
						input.save
					end
					flash[:notice] = 'Mails enviados correctamente.'
				else
					flash[:notice] = 'No quedan Mails pendientes para enviar.'
				end

			end
		rescue
			flash[:notice] = 'No se pudo enviar algun mail por un error interno, o de internet. Enviar nuevamente'
		end
		redirect_to action: :index
	end
	
	def set_list_to_print
		list_ids_of_providers  = Set.new
		list_inputs_this_month = Input.obtain_current_month_inputs

		# create set of provider ids related with the inputs to show
		list_inputs_this_month.each do |input|
			if (input.article)
				list_ids_of_providers.add(input.article.provider)
			end
		end
		
		@providers_to_print    = Provider.where("id in (?)", list_ids_of_providers);
		Billing.print_providers(@providers_to_print, list_inputs_this_month)
		return @providers_to_print
	end

	def set_list_of_rents_to_print
		list_rents_this_month = Input.obtain_current_month_rents_inputs
	end

	def return_change_monthly
		list_providers = set_list_to_print
		@mil 	 = 0
		@qui 	 = 0
		@doscien = 0
		@cien 	 = 0
		@cincue  = 0
		@veinte  = 0
		@diez 	 = 0
		@cinco 	 = 0
		@dos 	 = 0
		@uno 	 = 0
		@total   = 0
		
		list_providers.each do |provider|
			parcial = 0
			(provider.instance_variable_get "@custom_input_list").each do |input|
				parcial += input.amount.to_i
			end

			parcial = parcial - (parcial * 0.35 + parcial * 0.35 * 0.22).round
			@total  += parcial
			
			if parcial >= 1000
				@mil = @mil + (parcial.to_f / 1000).to_i
				parcial = parcial - (parcial.to_f / 1000).to_i * 1000
			end

			if parcial >= 500
				@qui = @qui + (parcial.to_f / 500).to_i
				parcial = parcial - (parcial.to_f / 500).to_i * 500
			end

			if parcial >= 200
				@doscien = @doscien + (parcial.to_f / 200).to_i
				parcial = parcial - (parcial.to_f / 200).to_i * 200
			end

			if parcial >= 100
				@cien = @cien + (parcial.to_f / 100).to_i
				parcial = parcial - (parcial.to_f / 100).to_i * 100
			end
			
			if parcial >= 50
				@cincue = @cincue + (parcial.to_f / 50).to_i
				parcial = parcial - (parcial.to_f / 50).to_i * 50
			end
			
			if parcial >= 20
				@veinte = @veinte + (parcial.to_f / 20).to_i
				parcial = parcial - (parcial.to_f / 20).to_i * 20
			end

			if parcial >= 10
				@diez = @diez + (parcial.to_f / 10).to_i
				parcial = parcial - (parcial.to_f / 10).to_i * 10
			end

			if parcial >= 5
				@cinco = @cinco + (parcial.to_f / 5).to_i
				parcial = parcial - (parcial.to_f / 5).to_i * 5
			end

			if parcial >= 2
				@dos = @dos + (parcial.to_f / 2).to_i
				parcial = parcial - (parcial.to_f / 2).to_i * 2
			end

			if parcial >= 1
				@uno = @uno + (parcial.to_f / 1).to_i
				parcial = parcial - (parcial.to_f / 1).to_i * 1
			end
		end
	end
end

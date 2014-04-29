class Rent < Input

    def build_input (input_data)
        self[:comission_per]  = 30
        self[:amount]         = 0
        self[:future_amount]  = input_data[:amount].to_i
        self.article          = Article.find input_data[:article]
        self[:comission_cash] = self[:amount]
    end

    def self.obtain_cash(amount, percent)
        return ((amount * percent/100) + (amount * percent/100 * 0.22)).round 
    end

    def obtain_human_label
        return self.retrieve_label(self.type || self.status)
    end

    def retrieve_label(type)
        case type
        when "sale", "Sale"
          return "Venta" 
        when "rent", "Rent"
          return "Alquiler"
        when "Output"
          return "Egreso"
        when "cancel_input"
          return "Anulación"    
        else
          puts "Tipo no reconocido"
        end
    end

    def self.set_final_rent_amount(rented_articles)
        rented_articles.each do |article|
            
            json_response = Collect.get_open_caja
            
            if json_response['result'] == 'ok'
                current_open = json_response['record']
                new_input = Rent.new
                current_open.caja_transactions.create!(:transaction => new_input)
            end
            
            # Si esta dentro de las 2 semanas 
            if article.input.created_at >= 2.week.ago
                new_input.amount         = Rent.obtain_cash(article.input.future_amount.to_i, article.input.comission_per.to_i)
                new_input.comission_per  = article.input.comission_per
            
            # Si esta entre la semana 3 y  la 2 ( una semana de atraso )
            elsif 2.week.ago > article.input.created_at &&  article.input.created_at >= 3.week.ago
                # Se le suma un 10% 
                new_input.amount = Rent.obtain_cash(article.input.future_amount.to_i, 40)
                new_input.comission_per = 40

            # Despues de un mes se cobra el 100% de la prenda
            elsif article.input.created_at < 4.week.ago
                # Se cobra el total de la prenda, luego se realiza la venta
                new_input.amount = article.input.future_amount
                new_input.comission_per = 100  
            end

            # Actualizo la ganancia neta
            new_input.comission_cash = new_input.amount
            # Salvo el nuevo input
            new_input.save
            
            # Cambio la relacion del articulo con el input
            article.input_id = new_input.id
            article.save
            # Salvo
            article.input.save
        end
    end 
end
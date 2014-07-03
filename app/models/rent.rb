class Rent < Input

    def build_input (input_data)
        self[:comission_per]  = 30
        self[:amount]         = 0
        self[:future_amount]  = input_data[:amount].to_i
        self.article          = Article.find input_data[:article]
        self[:comission_cash] = self[:amount]
        self[:article_desc]   = self.article.description
        self[:article_id]     = self.article.id
        self.staff            = Staff.find input_data[:staff]
        self[:staff_id]       = self.staff.id  
    end

    def self.obtain_cash(amount, percent)
        return ((amount * percent.to_f/100) + (amount * percent.to_f/100 * 0.22)).round
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

    def self.set_final_rent_amount(article, save)

        if !article.nil? && !article.input.nil?
        new_input              = Rent.new
        new_input.article_id   = article.id
        new_input.article_desc = article.description

            if save    
                json_response = Collect.get_open_caja
                
                if json_response['result'] == 'ok'
                    current_open = json_response['record']
                    current_open.caja_transactions.create!(:transaction => new_input)
                end
            end
            
            # Si esta entre la semana 4 y  la 2 ( dos semanas de atraso maximo )
            if 2.week.ago > article.input.created_at &&  article.input.created_at >= 4.week.ago
                # Se le suma un 10% 
                new_input.amount        = Rent.obtain_cash(article.input.future_amount.to_i, 40)
                new_input.comission_per = 40

            # Si esta dentro de las 2 semanas o es despues de un mes
            elsif article.input.created_at >= 2.week.ago || article.input.created_at < 4.week.ago
                new_input.amount         = Rent.obtain_cash(article.input.future_amount.to_i, article.input.comission_per.to_i)
                new_input.comission_per  = article.input.comission_per
            end

            # Actualizo la ganancia neta
            new_input.comission_cash = new_input.amount
            
            if save
                begin
                    # Salvo el nuevo input
                    new_input.save
                
                    # Cambio la relacion del articulo con el input
                    article.input_id = new_input.id
                    article.status   = ""
                    article.save
                    # Salvo
                    article.input.save

                    return new_input.id
                rescue
                    return "Hubo un error al devolver los artículos seleccionados, por favor reintentar"
                end
            else
                new_input.created_at = article.input.created_at
                article.input        = new_input
                return article
            end
        else
            return article
        end    
    end

    def self.calc_new_prices(article)
        return Rent.set_final_rent_amount(article, false)
    end

    def self.save_new_rent(articlesId)
        rented_articles = Article.find(:all, :conditions => ["id IN (?)", articlesId])
        inputIds        = Set.new

        rented_articles.each do |article|
            inputIds.add(set_final_rent_amount(article, true))
        end
        return inputIds
    end 
end
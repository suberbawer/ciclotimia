class Article < ActiveRecord::Base
    belongs_to :transaction
    belongs_to :input
    belongs_to :output
    belongs_to :provider

    # Devuelve true si el artículo tiene un input asociado, de otra forma false.
    def has_input
        # Mientras tenga input_id no se puede usar (se vendio, o esta siendo alquilada ahora,
        # cuando se devuelve el artículo se dessetea el input_id).
    end

    def set_status(input_status)
        new_status = ""
        case input_status
        when "Sale"
            new_status = "sold"  
        when "Rent"
            new_status = "rented"
        when "OtherInput"
            new_status = ""
        else
            new_status = "Output"
        end
        self.status = new_status
        self.save
    end
    
    def self.get_barcode(articleId)
        require 'barby'
        require 'barby/barcode/code_128' 
        require 'barby/outputter/svg_outputter'
        require 'barby/outputter/png_outputter'

        # if the barcode image doesn't already exist then generate and save it
        fname = articleId.to_s+'.png';

        if ! File.exists?(fname)
         
            str = 'Barcode.new("'+articleId.to_s+'")'
             
            begin
            barcode = eval str
        
            rescue Exception => exc
                barcode = Barby::Code128B.new(articleId) # fall back to Code128 type B
            end
                        
            File.open(File.join("app/assets/images/barcodes", fname), 'wb') do |f|
                f.write Barby::PngOutputter.new(barcode).to_png
            end
        end
    end
    
    def return_article
        if self.status == "rented"
            self.status = ""
            return self.save
        end
        return false    
    end

    def return_sold_article
        if !self.input.nil?
            if self.input.created_at.year == Time.now.year && self.input.created_at.month == Time.now.month 
                if self.status == "sold"
                    self.status = ""
                    self.save
                    return ''
                else
                   return 'El artículo seleccionado no se encuentra vendido'
                end
            else
                return 'El mes de cambio a finalizado, fecha de compra: '+self.input.created_at.to_s
            end
        else
            return 'El artículo seleccionado no tiene un ingreso relacionado'
        end
    end

    def destroy_input_related
        if !self.input.nil?
            return self.input.destroy
        end
        return false
    end

    def is_rented
        return self.status == 'rented'
    end
    
    def self.reutrn_provider_map(articles)
        providers       = Provider.where("id in (?)", articles.map(&:provider_id))
        providers_by_id = Hash[providers.map{ |c| [c.id, c] }]
        return providers_by_id
    end

    def self.return_input_map(articles)
        inputs = Input.where("article_id in (?) AND staff_id IS NOT NULL", articles.map(&:id))
        staffs = Staff.where("id in (?)", inputs.map(&:staff_id))
        
        staffs_by_id         = Hash[staffs.map{ |c| [c.id, c] }]
        staffs_by_article_id = Hash.new
        
        inputs.each do |input|
            staffs_by_article_id[input.article_id] = staffs_by_id[input.staff_id]
        end
                
        return staffs_by_article_id

    end
    
    def self.search(str)
        if !str.blank?
            cond_text   = str.split.map{|w| "description LIKE ?"}.join(" AND ")
            cond_text2  = str.split.map{|w| "id = ?"}.join(" OR ")
            cond_text3  = str.split.map{|w| "estimated_price LIKE ?"}.join(" OR ")
            cond_text.concat(" OR " + cond_text2).concat(" OR " + cond_text3)

            cond_values = str.split.map{|w| "%#{w}%"}
            cond_values2 = str.split.map{|w| w}
            Article.where(cond_text, *cond_values, *cond_values2, *cond_values)
        else
            Article.all
        end
    end

    def self.search_articles_debtors(search_text)
        articles_debtors = obtain_debtors

        if search_text != ''
            Article.where("id in (?) and (description like ? or id = ?)", articles_debtors.map(&:id), "%#{search_text}%", search_text)
        else
            return articles_debtors
        end
    end

    def self.obtain_debtors
        articles_rented  = Article.where("status = 'rented'");
        articles_debtors = Array.new
        articles_rented.each do |article|
            if 2.week.ago > article.input.created_at
                articles_debtors.push(article)
            end
        end
        return articles_debtors
    end

    def obtain_human_label
        return self.retrieve_label(self.status)
    end

    def retrieve_label(type)
        case type
        when "sold", "sold"
          return "Vendido" 
        when "rented", "Rented"
          return "Alquilado"    
        else
          return "Disponible"
        end
    end
end

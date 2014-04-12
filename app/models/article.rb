class Article < ActiveRecord::Base
    belongs_to :transaction
    belongs_to :input
    belongs_to :output
    belongs_to :provider

    # Devuelve true si el articulo tiene un input asociado, de otra forma false.
    def has_input
        # Mientras tenga input_id no se puede usar (se vendio, o esta siendo alquilada ahora,
        # cuando se devuelve el articulo se dessetea el input_id).
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
         
            File.open(File.join("app/assets/images/barcodes", fname), 'w') do |f|
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

    def self.search_articles(search_text)
        if search_text != ''
            return Article.find(:all, :conditions => ["description like ? or id = ?", "%#{search_text}%", search_text])
        else
            return Article.all
        end
    end

    def self.search_articles_debtors(search_text)
        articles_debtors = obtain_debtors

        if search_text != ''
            return Article.find(:all, :conditions => ["id in (?) and (description like ? or id = ?)", articles_debtors.map(&:id), "%#{search_text}%", search_text])
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
          puts "Tipo no reconocido"
        end
    end
end

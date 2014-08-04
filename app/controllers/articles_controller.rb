class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.find(:all, :order => "created_at DESC" ).sort_by{|article| - article.id}
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        Article.get_barcode(@article.id)
        format.html { redirect_to action: 'new' }
        format.json { render action: 'show', status: :created, location: @article }
        flash[:notice] = "El Artículo fue creado con éxito."
      else
        format.html { render action: 'new' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        @article.sent = false
        @article.save
        format.html { redirect_to @article, notice: 'El Artículo fue actualizado con éxito.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    respond_to do |format|
      if @article.input
        format.html { redirect_to articles_url, notice: 'No es posible eliminar un Artículo que ya ha sido vendido, o alquilado.'  }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      else
        @article.destroy
        format.html { redirect_to articles_url }
        format.json { head :no_content }
      end
    end
  end

  def list
    @articles = Article.all
    render :partial => 'list_articles', :content_type => 'text/html'
  end

  def devolution
    if request.post?
        begin
            article_to_return = Article.find(params['article_id'])
                        
            returned = article_to_return.return_article
            
            if returned
                flash[:notice] = "El artículo se devolvió correctamente"
            else
                flash[:notice] = "El artículo no se pudo devolver, verifique que esté siendo alquilado ahora"
            end
        rescue ActiveRecord::RecordNotFound
            flash[:notice] = "No hay artículos con ese id"
        end    
    end
  end

  def sold_devolution_article
    if request.post?
        begin
            article_to_return = Article.find(params['article_id'])
                        
            returned = article_to_return.return_sold_article
            
            if returned == ''
                if article_to_return.destroy_input_related
                  returned = "El artículo se devolvió correctamente"
                end
            end
        
        rescue ActiveRecord::RecordNotFound
            returned = "No hay artículos con ese id"
        end
        render json: {message: returned}
        flash[:notice] = returned
      end
  end
  
  def fetch_data
    @article = Article.find_by_id(params[:id])
    render :partial => 'article_detail', :content_type => 'text/html'
  end

  def fetch_rented_article
    @article = Article.find_by_id(params[:id])
    @article = Rent.calc_new_prices(@article)
    render :partial => 'rent_article_detail', :content_type => 'text/html'
  end

  def actual_billing_rent
    articles   = Article.where(id:params['id_list'])
    inputs_ids = Set.new
    
    articles.each do |article| 
      inputs_ids.add(article.input.id)
    end
    
    new_inputs = Input.where("id IN (?)", inputs_ids)
    @total     = Report.total_amount(new_inputs)
    @iva       = @total * 0.22
    @subtotal  = @total - @iva
    @rut       = new_inputs[0].staff_id.nil? ? '' : Staff.find_by_id(new_inputs[0].staff_id).productora.rut
    @prod      = new_inputs[0].staff_id.nil? ? '' : Staff.find_by_id(new_inputs[0].staff_id).productora.billing_name
    
    render :partial => 'actual_billing_rent', :content_type => 'text/html'
  end

  def return_list_articles
    created_new_rents = Rent.save_new_rent(params[:id_list])
    render json: {message: created_new_rents}
  end
  
  def filter
    @articles = Article.search_articles(params[:search_text]).sort_by{|article| - article.id}
    render :index
  end

  def filter_debtors
    @articles = Article.search_articles_debtors(params[:search_text]).sort_by{|article| - article.id}
    render :debtor
  end

  def batch_receipt
    @new_inputs = Input.where(id: params['inputs'])
    puts @new_inputs
  end

  def debtors
    @articles = Article.obtain_debtors
    render :debtor
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:description, :estimated_price, :entry_date, :commission_per, :commission_cash, :status, :provider_id)
    end
end
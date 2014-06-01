class ProvidersController < ApplicationController
  before_action :set_provider, only: [:show, :edit, :update, :destroy, :articles_not_sent, :send_articles_provider]

  # GET /providers
  # GET /providers.json
  def index
    @providers = Provider.all.sort_by{|provider| provider.name}
  end

  # GET /providers/1
  # GET /providers/1.json
  def show
    @article_list = @provider.articles.order('status DESC')
    @not_sent_articles = @provider.get_articles_not_sent
  end

  # GET /providers/new
  def new
    @provider = Provider.new
  end

  # GET /providers/1/edit
  def edit
  end

  # POST /providers
  # POST /providers.json
  def create
    @provider = Provider.new(provider_params)

    respond_to do |format|
      if @provider.save        
        format.html { redirect_to action: 'new' }
        format.json { render action: 'show', status: :created, location: @provider }
        flash[:notice] = "El Proveedor fue creado con éxito."
      else
        format.html { render action: 'new' }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /providers/1
  # PATCH/PUT /providers/1.json
  def update
    respond_to do |format|
      if @provider.update(provider_params)
        format.html { redirect_to @provider, notice: 'El Proveedor fue actualizado con éxito.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /providers/1
  # DELETE /providers/1.json
  def destroy
    respond_to do |format|
      if !@provider.articles.empty?
        format.html { redirect_to providers_url, notice: 'No es posible eliminar un Proveedor que contenga Artículos relacionados'  }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      else
        @provider.destroy
        format.html { redirect_to providers_url }
      format.json { head :no_content }
      end
    end
  end
  
  def filter
    @providers = Provider.filter_providers(params[:search_text]).sort_by{|provider| provider.name}
    render :index    
  end

  def filter_articles_provider
    @article_list = Provider.filter_provider_articles(params[:search_text], params[:id])
    render :show
  end
      
  def articles_not_sent
    @article_not_sent_list = @provider.get_articles_not_sent
  end
  
  def send_articles_provider
    begin
      provider = Provider.find(params[:id])

      UserMailer.new_articles_provider(provider).deliver
      
      provider.get_articles_not_sent.each do |article|
        article.sent = true
        article.save
      end

      flash[:notice] = "Mail enviado a proveedor correctamente"
    
    rescue
      flash[:notice] = "Mail no enviado por falta de internet, reconectar y volver a intentar. Gracias."
    end
      redirect_to action: :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider
      @provider = Provider.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def provider_params
      params.require(:provider).permit(:name, :lastname, :phone, :email, :address, :ci)
    end
end

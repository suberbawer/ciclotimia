class ProductorasController < ApplicationController
  before_action :set_productora, only: [:show, :edit, :update, :destroy]

  # GET /productoras
  # GET /productoras.json
  def index
    @productoras = Productora.all
  end

  # GET /productoras/1
  # GET /productoras/1.json
  def show
  end

  # GET /productoras/new
  def new
    @productora = Productora.new
  end

  # GET /productoras/1/edit
  def edit
  end

  # POST /productoras
  # POST /productoras.json
  def create
    @productora = Productora.new(productora_params)

    respond_to do |format|
      if @productora.save
        format.html { redirect_to action: 'new' }
        format.json { render action: 'show', status: :created, location: @productora }
        flash[:notice] = "La Productora fue creada con éxito."        
      else
        format.html { render action: 'new' }
        format.json { render json: @productora.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /productoras/1
  # PATCH/PUT /productoras/1.json
  def update
    respond_to do |format|
      if @productora.update(productora_params)
        format.html { redirect_to @productora, notice: 'La Productora fue actualizada con éxito.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @productora.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /productoras/1
  # DELETE /productoras/1.json
  def destroy
    respond_to do |format|
      if !@productora.staffs.empty?
        format.html { redirect_to productoras_url, notice: 'No es posible eliminar una Productora que contenga Vestuaristas relacionados'  }
        format.json { render json: @productora.errors, status: :unprocessable_entity }
      else
        @productora.destroy
        format.html { redirect_to productoras_url }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_productora
      @productora = Productora.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def productora_params
      params.require(:productora).permit(:name, :rut, :billing_name)
    end
end

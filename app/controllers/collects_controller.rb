class CollectsController < ApplicationController
    
    def today_collect
        @today_inputs = Collect.get_today_inputs
        @today_outputs = Collect.get_today_outputs
        @today_cajas_total = @today_inputs.inject(0){|sum,e| sum += e.amount } + @today_outputs.inject(0){|sum,e| sum += e.amount }
    end

    def cancel_transaction
        correctly_cancelled = Collect.cancel_transaction(params[:transaction_to_cancel], params[:cancel_type])
        # TODO manejar el error (pueden venir constantes).
        flash[:notice]      = (correctly_cancelled == "ok") ? "Transacción correctamente anulada": "Hubo un error en la anulación"
        redirect_to action: :today_collect
    end

    def open_today_caja
    	successfully_opened = Collect.open_caja
    	flash[:notice]      = (successfully_opened) ? 'La caja se abrio correctamente' : 'Ya hay una caja abierta'
    	redirect_to action: :index
    end

    def close_today_caja
    	successfully_closed = Collect.close_today_caja
    	flash[:notice]      = (successfully_closed) ? 'La caja de hoy fue correctamente cerrada' : 'No hay caja abierta o la caja abierta no es del día de hoy'
    	redirect_to action: :index
    end

    def close_another_caja
        successfully_closed = Collect.close_previous_caja
        flash[:notice]      = (successfully_closed) ? 'La caja anterior fue correctamente cerrada' : 'No hay caja abierta'
        redirect_to action: :index
    end

    def index
    	@today_open_caja = Collect.get_open_caja()
    end
end
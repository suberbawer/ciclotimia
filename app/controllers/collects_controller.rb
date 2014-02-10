class CollectsController < ApplicationController
    
    def today_collect
        @today_inputs = Collect.get_today_transactions
    end

    def cancel_transaction
        correctly_cancelled = Collect.cancel_transaction(params[:input_to_cancel])
        # TODO manejar el error (pueden venir constantes).
        flash[:notice]      = (correctly_cancelled == "ok") ? "Transacción correctamente anulada": "Hubo un error en la anulación"
        redirect_to action: :today_collect
    end
end
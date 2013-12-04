class CollectsController < ApplicationController
    
    def today_collect
        @today_inputs = Collect.get_today_transactions
    end
end
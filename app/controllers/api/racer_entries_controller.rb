module Api
    class RacerEntriesController < ApplicationController
        def index
            # @racer_entries = @racer.races
            if !request.accept || request.accept == "*/*"
                render plain: "/api/racers/#{params[:racer_id]}/entries"
            else
                #real implementation ...
            end
        end
        def show
            if !request.accept || request.accept == "*/*"
                render plain: "/api/racers/#{params[:racer_id]}/entries/#{params[:id]}"
            else
                #real implementation ...
            end
        end
    end
end
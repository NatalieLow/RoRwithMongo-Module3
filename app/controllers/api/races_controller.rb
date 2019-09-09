module Api
    class RacesController < ApplicationController
        protect_from_forgery with: :null_session
        before_action :find_results, only: [:index, :show]
        
        def index
            if !request.accept || request.accept == "*/*"
                render plain: "/api/races"
            else
                #real implementation ...
            end
        end
        def show
            if !request.accept || request.accept == "*/*"
                render plain: "/api/races/#{params[:id]}"
            else
                #real implementation ...
            end
        end

        def create
            if !request.accept || request.accept == "*/*"
                render plain: :nothing, status: :ok
            else
                #real implementation
            end
        end

        def find_results
            @results
        end
    end
end
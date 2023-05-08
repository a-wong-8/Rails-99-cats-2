class SessionsController < ApplicationController
    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.new(sessions_params)

        if @user.save
            redirect_to 
        else

        end
    end

    def destroy

    end

    def sessions_params
        params.require()
    end
end

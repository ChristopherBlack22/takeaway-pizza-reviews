class UsersController < ApplicationController

    get "/signup" do
        erb :"users/signup"
    end 

    post "/signup" do
        if params[:username] == "" || params[:email] == "" || params[:password] == ""
            redirect "/signup"
        else
            @user = User.create(params)
            session[:user_id] = @user.id
            redirect "/users/#{@user.id}" #replace @user.id with current_user ?
        end 
    end 

end 
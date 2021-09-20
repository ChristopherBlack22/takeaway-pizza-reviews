class UsersController < ApplicationController

    get "/signup" do
        if logged_in?
            redirect "/users/#{current_user.id}"
        else
            erb :"users/signup"
        end 
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

    get "/login" do
        erb :"users/login"
    end 

    post "/login" do 
        @user = User.find_by(username: params[:username])
        #binding.pry
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect "/users/#{@user.id}" #replace @user.id with current_user ?
        else
        redirect "/"
        end 
    end 

    get "/users/:id" do
        if logged_in?
            @user = User.find(params[:id])
            erb :"users/show"
        else
            redirect "/"
        end 
    end 

    get "/logout" do
        if logged_in?
            session.clear
            redirect "/login"
        else
            redirect "/"
        end 
    end 

end 
require "rack-flash"
class UsersController < ApplicationController
    use Rack::Flash

    get "/signup" do
        if logged_in?
            redirect "/users/#{current_user.id}"
        else
            erb :"users/signup"
        end 
    end 

    post "/signup" do
        if params[:username] == "" || params[:email] == "" || params[:password] == ""
            flash[:message] = "Error - All fields must be completed to create an account!"
            redirect "/signup"
        else
            @user = User.new(params)
            if !@user.valid?
                flash[:message] = "Error - Username already taken. Please choose a different one!"
                redirect "/signup"
            else
                @user.save
                session[:user_id] = @user.id
                redirect "/users/#{@user.id}" 
            end 
        end 
    end 

    get "/login" do
        if logged_in?
            redirect "/users/#{current_user.id}"
        else
            erb :"users/login"
        end 
    end 

    post "/login" do 
        @user = User.find_by(username: params[:username])
        if @user && @user.email == params[:email] && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect "/users/#{@user.id}" 
        else
            flash[:message] = "Error - Account not found. Please try again or create a new account!"
            redirect "/login"
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
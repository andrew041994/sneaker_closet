
class ApplicationController < Sinatra::Base
    configure do
		set :views, "app/views"
		enable :sessions
		set :session_secret, "password_security"
	end

    get '/' do 
    erb :home_page
    end

    get '/signup' do 
        erb :sign_up
    end

    post '/signup' do
        @user = User.new(username: params[:username], email: params[:email], password: params[:password])

        if @user.save
            session[:user_id] = @user.id
        redirect "/users/#{@user.id}"
        else
            redirect '/signup'
        end

    end

    get '/login' do
        erb :log_in
    end

    post '/login' do
        
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect "/users/#{@user.id}"
        else
            redirect '/login'
        end

    end

    get '/users/:id' do

        redirect_if_no_access
        @sneakers = current_user.sneakers             
			erb :index
    end

    get '/users/:id/sneakers/:sneaker_id' do
        redirect_if_no_access
        @sneaker = current_user.sneakers.find_by_id(params[:sneaker_id])
            
        if @sneaker

          erb :show
        else
            redirect "/users/#{session[:user_id]}"
        end
    end

    get '/new' do 
        erb :new
    end

    post '/new' do
    @sneaker = current_user.sneakers.new(brand: params[:brand], model: params[:model],
     color: params[:color], size: params[:size])
     @sneaker.save
  redirect "/users/#{session[:user_id]}"
    end

    get '/users/:user_id/sneakers/:sneaker_id/delete' do
        @sneaker = Sneaker.find_by_id(params[:sneaker_id])
        @sneaker.destroy 
       redirect "/users/#{session[:user_id]}"
    end

    get '/users/:id/logout' do
        session.clear

        redirect '/'
      end


    helpers do
        def logged_in?
            redirect '/login' unless session[:user_id]
                  
		end

		def current_user
		@user = User.find_by_id(session[:user_id])
        end
        
        def redirect_if_no_access
            logged_in? 

            redirect "/users/#{current_user.id}" if current_user.id != params[:id].to_i
        end
            
	end


end

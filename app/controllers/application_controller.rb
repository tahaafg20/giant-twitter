
class ApplicationController < Sinatra::Base

  register Sinatra::ActiveRecordExtension

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
		set :session_secret, "super secret password_security"
  end

  helpers do
    # This will return the current user, if they exist
    # Replace with code that works with your application
    def current_user
      if session[:user_id]
        @current_user ||= User.find(session[:user_id])
      end
    end
  
    # Returns true if current_user exists, false otherwise
    def logged_in?
      !current_user.nil?
    end
  end

  get '/' do
    if logged_in? 
      @following_id = current_user.followed.map(&:id).push(current_user.id)
      @maintweets = Tweet.where(user_id: @following_id).order("created_at DESC")
      @suggested_users = User.where.not(id: @following_id)
       erb :"static/main"
    else 
    erb :"static/index" 
    end
  end
  
  get '/main' do
    erb :"static/main"
  end
  
  

	post '/signup' do
    user = User.new(params)
    user.save
    if user.save
      session[:user_id] = user.id
      redirect "users/#{user.id}"
    else
      @signuperror = user.errors.full_messages.first #the error is from the validation whenever you try to save something in
      #so u cannot use the this same error method in /login because you're not trying to save anything to the database
      erb :"static/index" 
    end
  end 
  
  post '/login' do 
    # apply a authentication method to check if a user has entered a valid email and password
    # if a user has successfully been authenticated, you can assign the current user id to a session
    user = User.find_by(email: params[:user][:email])  # Check if the user exists
  
    if user.try(:authenticate, params[:user][:password]) 
        # Save the user id inside the browser cookie. This is how we keep the user 
        # logged in when they navigate around our website.
        session[:user_id] = user.id
        redirect "/"
  
    else
      # If user's login doesn't work, send them back to the login form.
        @error = "Invalid email or password"
        erb :"static/index"
    end
  end	
  
  post '/logout' do #User.destroy DOESNT WORK
    # kill a session when a user chooses to logout, for example, assign nil to a session
    # redirect to the appropriate page
    session[:user_id] = nil
    redirect '/'    
  end 
  
  get '/users/:id' do
    #if current_user && current_user.id == params[:id].to_i
    
      id = params[:id]
      @currenttweets = Tweet.where(user_id: id).order("created_at DESC")
      @user = User.find(id)
      erb :"users/profile" 
    #else 
    #  redirect '/' 
    #end 
  end
  
  get '/users/:id/edit' do  #load edit form
      @user = User.find(params[:id])
      erb :"users/edit"
  end
  
  patch '/users/:id' do #edit action
    @user = User.find(params[:id])
    @user.username = params[:username]
    @user.name = params[:name]
    @user.email = params[:email]
    @user.password = params[:password]
    @user.save
    redirect "/users/#{@user.id}"
  end
  
  get '/users/:id/checkfollowers' do
    #if current_user && current_user.id == params[:id].to_i
  
      id = params[:id]
      @user = User.find(id)
      erb :"users/checkfollowers" 
    #else 
    #  redirect '/' 
    #end 
  end
  
  get '/users/:id/checkfollowing' do
    #if current_user && current_user.id == params[:id].to_i
  
      id = params[:id]
      @user = User.find(id)
      erb :"users/checkfollowing" 
    #else 
    #  redirect '/' 
    #end 
  end
  
  get '/search' do 
    if params[:search]
      @users = User.search(params[:search])
    end
    erb :"users/results" 
  end
  
  post '/tweet' do
    tweet = Tweet.new(params[:tweet])
    tweet.user_id = current_user.id
    if tweet.save
      # redirect "users/#{current_user.id}/my_question"
      redirect "/"
    else
      @error = tweet.errors.full_messages.first #the error is from the validation whenever you try to save something in
     end
  end 
  
  get '/tweets/:id' do 
    # byebug
    @tweet = Tweet.find(params[:id])
    erb :"tweets/tweet"
  end
  
  
  delete '/tweets/:id' do
    @tweet = Tweet.delete(params[:id])
    redirect "/"
  end
  
  get '/tweets/:id/edit' do  #load edit form
      @tweet = Tweet.find(params[:id])
      erb :"tweets/edit"
  end
  
  patch '/tweets/:id' do #edit action
    @tweet = Tweet.find(params[:id])
    @tweet.title = params[:title]
    @tweet.save
    redirect "/tweets/#{@tweet.id}"
  end
  
  post "/users/:id/follow" do
    user = User.find(params[:id])
    current_user.follow!(user) if user
    redirect "users/#{user.id}"
  end
  
  delete '/users/:id/unfollow' do
    user = User.find(params[:id])
    current_user.relationships.find_by(followed_id: params[:id]).destroy
    redirect "users/#{user.id}"
  end  

end

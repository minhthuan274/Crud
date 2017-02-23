class UsersController < ApplicationController
	
	# ** Sign up
	get '/signup' do
		if logged_in? 
			redirect '/info'
		else
			erb :'users/signup'
		end
	end

	post '/signup' do 
    temp = User.find_by(:email => params[:email])
    if temp != nil 
      redirect '/signup'
    end
		if params[:email] == "" || params[:password] == ""
			redirect '/signup'
		else
      file = params[:file][:tempfile]
      File.open("./public/upload/images/#{params[:email]}", 'wb') do |f|
        f.write(file.read)
      end

			@user = User.create(
					:firstname =>   params[:firstname],
					:lastname =>    params[:lastname],
					:email =>       params[:email],
					:password =>    params[:password],
					:about_me =>    params[:about_me],
          :avatarpath =>  "./upload/images/#{params[:email]}"
			)
			session[:user_email] = @user.email
			redirect '/info'
		end
	end

  # ** Login
  get '/login' do
  	if logged_in?
  		redirect '/info'
  	else
  		erb :'users/login'
  	end
  end

  post '/login' do
  	@user = User.find_by(:email => params[:email])
  	if @user && @user.password == params[:password]
  		session[:user_email] = @user.email
  		redirect '/info'
  	else
  		redirect '/login'
  	end
  end

  # ** Logout

  get '/logout' do 
  	if session[:user_email] != nil
  		session.clear
  		redirect to '/login'
  	else
  		redirect to '/'
  	end
  end

  # ** Info
  get '/info' do 
  	@user = current_user
  	erb :'users/info'
  end

  put '/info' do 
    @user = current_user
    @user.firstname = params[:firstname]
    @user.lastname = params[:lastname]
    @user.password = params[:about_me]

    # Update avatar
    if params[:avatar] != nil
      fileUpload = params[:avatar][:tempfile]
      File.delete(@user.avatarpath) if File.exist?(@user.avatarpath)

      File.open("./public/upload/images/#{@user.email}", 'wb') do |f|
      f.write(fileUpload.read)
      end
    end
    @user.save
    redirect '/info'
  end

  delete '/delete/:id' do 
    @user = User.find_by_id(params[:id])
    @user.destroy
  end

  # ** Search 

  get '/search' do 
    if session[:result_search] != nil
      @user = User.find_by_id(session[:result_search])
    else
      @user = nil
    end
    erb :'users/search'
  end

  post '/search' do 
    @user = User.find_by(:email => params[:email])
    if @user == nil
      session[:result_search] = nil
    else
      session[:result_search] = @user.id
    end
    redirect '/search'
  end

end
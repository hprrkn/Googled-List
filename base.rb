require 'sinatra/base'

class Base < Sinatra::Base

    configure do
      enable :sessions
      set :session_secret, "mysessionsecret"
    end

    helpers do
      def validate(obj)
        if !obj.valid? then
          redirect request.referrer
          return
        end
      end 
    end

    before do
      if request.url =~ %r{/android} then
        if request.url =~ %r{/android/api/login} then
        else
            if !params[:token].nil? && !params[:userId].nil? && Token.where(params[:userId]).first.token == params[:token] then
                @loginOk = true
                @userId = params[:userId]
                @userWords = User.find(params[:userId]).words.order("created_at DESC")
                @userTags = User.find(params[:userId]).tags.order("created_at DESC")
            else
                @loginOk = false
            end
        end
      elsif request.url =~ %r{/login} then
      else
         if !session[:loginOk] then
           @msg = "Please LogIn"
           redirect '/login'
         else
           @userId = session[:uId]
           @userWords = User.find(@userId).words.order("created_at DESC")
           @userTags = User.find(@userId).tags.order("created_at DESC")

         end
      end
    end

end

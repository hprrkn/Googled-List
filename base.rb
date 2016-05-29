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
        if !params[:token].nil? && params[:token] == "tokenstring" && !params[:userId].nil? then
            @loginOk = true
            @userWords = User.find(params[:userId]).words
            @userTags = User.find(params[:userId]).tags
        else
            @loginOk = false
        end
      elsif request.url =~ %r{/login} then
        p "login"
        p request.url
      else
        p "other"
        p request.url
         if !session[:loginOk] then
           @msg = "Please LogIn"
           redirect '/login'
         else
           @userId = session[:uId]
           @userWords = User.find(@userId).words
           @userTags = User.find(@userId).tags
         end
      end
    end
end

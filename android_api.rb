require 'sinatra/base'
require './base.rb'
require './main.rb'

class AndroidAPI < Base
    post '/android/api/login' do
      @user = User.where({:username => params[:username]}).first
      if @user.present? && @user.password == params[:password]  then
        @loginOk = true;
        token = Digest::SHA1.hexdigest(@user.username)[0..10]
        Token.create({:user_id => @user.id, :token => token})
        res = {"userId" => @user.id, "token" => token, "loginOk" => true}
        res.to_json(:root => false)
      else
        res = {"loginOk" => "false", "token" => "", "userId" => ""}
        res.to_json(:root => false)
      end
    end

    get '/android/api/index' do
        if @loginOk then
            result = {}
            comjson = []
            @userWords.group("strftime('%Y-%m', created_at)").count.each do |com|
                comjson << {"month" => com[0], "count" => com[1]}
            end
            tags = @userTags.all
            result["coms"] = comjson
            result["tagList"] = tags
            result.to_json(:root => false)
        end
    end

    post '/android/api/add_word' do
      new_word = Word.create({:user_id => @userId, :wordtitle => params[:word], :memo => params[:memo]})
    end
end

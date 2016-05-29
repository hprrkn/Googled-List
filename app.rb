require 'sinatra/base'
require './base.rb'

class App < Base
    get '/login' do
      erb :login
    end

    post '/login/check' do
      @user = User.where({:username => params[:username]}).first
      if @user.present? && @user.password == params[:password]  then
        p "loginOk"
        session[:loginOk] = true
        session[:uId] = @user.id
        redirect '/index'
        erb :index
      else
        redirect '/login'
        erb :login
      end
    end

    get '/logout' do
      session.clear
      redirect '/login'
      erb :login
    end

    get '/setting' do
      erb :setting
    end

    post '/login/register' do
      @user = User.create({:username => params[:username], :password => params[:password]})
      validate(@user)
      session[:loginOk] = true
      session[:uId] = @user.id
      redirect 'index'
      erb :index
    end

    get '/index' do
      @countOfMonth = @userWords.group("strftime('%Y-%m', created_at)").count.each
      @tags = @userTags.all
        erb :index
    end

    get %r{/list/(\d{4})\-(\d{2})} do |y,m|
      from = Date::new(y.to_i,m.to_i,1)
      to = from >> 1
      @words = @userWords.where("created_at >= ? AND created_at < ?", from.strftime("%Y-%m-%d"), to.strftime("%Y-%m-%d"))
      erb :list
    end  

    get %r{/detail/([0-9]*)} do |id| 
      @word = @userWords.find(id)
        erb :detail
    end

    get %r{/edit/([0-9]*)} do |id|
      @word = @userWords.find(id)
      @tags = @userTags.all
      erb :edit
    end

    get '/tag/list' do
      @tags = @userTags.all
      erb :tagList
    end

    get %r{/tag/detaal/([0-9]*)} do |id|
      @tag = @userTags.find(id)
      @words = @userWords.includes(:tags).where('tags.id' => id)
      erb :tagDetail
    end

    get %r{/tag/ediit/([0-9]*)} do |id|
      @tag = @userTags.find(id)
      erb :tagEdit
    end

    post '/api/new' do
      new_word = Word.create({:user_id => @userId, :wordtitle => params[:word], :memo => params[:memo]})
      validate(new_word)
      if params['tag_id'].present? then
         params['tag_id'].each do |param|
           new_word.tags << @userTags.find(param)
         end
      end 
      redirect '/index'
        erb :index
    end

    post '/api/update' do
      wordid = params[:wordid]
      editWord = @userWords.find(wordid)
      editWord.update({:wordtitle => params[:word], :memo => params[:memo]})
      validate(editWord)
      editWord.tags.clear
      params['tag_id'].each do |param|
        editWord.tags << @userTags.find(param)
      end
      redirect "/detail/#{wordid}"
      erb :detail 
    end

    post '/api/delete' do 
      @userWords.destroy(params['wordid'])
      redirect '/index'
        erb :index
    end

    post '/api/new/tag' do
      newTag = Tag.create({:user_id => @userId, :tagname => params[:tagname]})
      validate(newTag)
      newTag.to_json(:root => false)
    end

    post '/api/tag/delete' do 
      @userTags.find(params['tagid']).destroy
      redirect '/tag/list'
      erb :tagList
    end

    post '/api/tag/update' do
      tagid = params[:tagid]
      editTag = @userTags.find(tagid)
      editTag.update({:tagname => params[:tagname]})
      validate(editTag)
      redirect "/tag/detaal/#{tagid}"
      erb :tagDetail
    end
end

require 'sinatra'
require 'active_record'
require './base.rb'
require './app.rb'
require './android_api.rb'
require 'logger'

require "sinatra/reloader" if development?

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./googledword.db"
)
ActiveRecord::Base.logger = Logger.new("/home/prrknh/SinatraApp/GoogledListBySinatra/log/activerecord.log")

class User < ActiveRecord::Base
  has_many :words
  has_many :tags
  validates :username, presence: true
  validates :password, presence: true
end

class Word < ActiveRecord::Base
  has_and_belongs_to_many :tags
  belongs_to :users
  validates :wordtitle, presence: true
end

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :words
  belongs_to :users
  validates :tagname, presence: true
end

class Token < ActiveRecord::Base
end

class Main < Sinatra::Base
    use AndroidAPI
    use App
end

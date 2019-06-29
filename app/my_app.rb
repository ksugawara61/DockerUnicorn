require 'bundler'
require 'sinatra'
Bundler.require

class MyApp < Sinatra::Base
  get '/' do
    "Hello World!\n"
  end
end

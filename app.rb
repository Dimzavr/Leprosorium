#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

# before вызывается каждый раз при перезапуске
# любой страницы

before do
	# инициализация бд
	init_db
end	

# configure вызывается каждый раз при конфигурации приложения
# когда изменился код программы И перезагрузилась страница

configure do
	# инициализация бд
	init_db

	#  создает таблицу если таблица не существует
	@db.execute 'create table if not exists Posts 
	(
		id INTEGER PRIMARY KEY AUTOINCREMENT, 
		created_date DATE, 
		content TEXT
	)'
end	

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

# обработчик get-запроса /new
#(браузер получает страницу с сервера)

get '/new' do
  erb :new
end

# обработчик post-запроса /new
#(браузер отправляет данные на сервер)

post '/new' do
	# получаем переменную из post-запроса
	content = params[:content]

	if content.length < 1
		@error = 'Type post text'
		return erb :new
	end	

	erb "You typed #{content}"
end
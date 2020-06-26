require 'rubygems'
require 'sinatra'
#require 'sinatra/reloader'
require 'sqlite3'

configure do
	@db = SQLite3::Database.new 'doctor.db'
	@db.execute 'create table if not exists
		"Users"
		(
			"id" integer primary key autoincrement,
			"username" text,
			"phone" text,
			"datestamp" text,
			"doctor" text
		)'
end

get '/' do
	erb "Hello!"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@doctor = params[:doctor]
	@datetime = params[:datetime]

	hh = {
		username: "Введите ваше имя",
		phone: "Введите телефон",
		datetime: "Введите дату и время"
	}

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	f = File.open "./public/users.txt", "a"
	f.write "#{@username}, #{@phone}, #{@doctor}, #{@datetime} "
	f.close
	erb "#{@doctor}, #{@phone},  #{@datetime}; Спасибо, #{@username}, будем вас ожидать!"
end

post '/contacts' do
	@email = params[:email]
	@message = params[:message]

	f = File.open "./public/contacts.txt", "a"
	f.write "#{@email}, #{@message} "
	f.close
	erb :contacts
end

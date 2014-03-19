require 'sinatra'

not_found do
  'That time is nowhere to be found.'
end

get "/:time_standard/:time" do
  begin
    d = DateTime.parse(params[:time]) 
  rescue
    halt 404 
  end
  time = d.strftime("%H:%M:%S")
  time_standard = params[:time_standard].upcase
  title = params[:time] + " " + time_standard
  if ["GMT", "UTC"].include? time_standard
    erb :index, locals: { title: title, time: time, time_standard: time_standard }
  else
    halt 404
  end
end

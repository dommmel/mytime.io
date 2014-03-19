require 'sinatra'

not_found do
  erb :not_found
end

get "/" do
  @page_title = "Convert any time to local time (your timezone)"
  erb :not_found
end

get "/:time/:time_standard" do
  begin
    d = DateTime.parse(params[:time]) 
  rescue
    halt 404 
  end
  
  @time = d.strftime("%H:%M:%S")
  @time_standard = params[:time_standard].upcase
  @title = params[:time] + " " + @time_standard
  @page_title = @title + "in local time (your timezone)"
  if ["GMT", "UTC", "UT", "PST", "PDT", "EST", "EDT", "CST", "CDT", "MST", "MDT"].include? @time_standard
    erb :index
  else
    halt 404
  end

end

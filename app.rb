require 'sinatra'

not_found do
  erb :not_found
end

get "/" do
  @page_title = "Convert any time to local time (your timezone)"
  erb :not_found
end

get "/:time/:time_standard" do

  parsable_timezones = ["GMT", "UTC", "UT", "PST", "PDT", "EST", "EDT", "CST", "CDT", "MST", "MDT"]
  

  # redirect from /timezone/time to /time/timezone
  begin
    d = DateTime.parse(params[:time_standard])
    if parsable_timezones.include? params[:time].upcase
      redirect to("/#{params[:time_standard]}/#{params[:time]}"), 301
    end
  rescue
  end

  # Parse date
  begin
    d = DateTime.parse(params[:time]) 
  rescue
    halt 404 
  end

  @time = d.strftime("%H:%M:%S")
  @time_standard = params[:time_standard].upcase

  @today_string = Time.now.strftime("%Y/%m/%d")
  @title = params[:time] + " " + @time_standard
  @page_title = @title + " in local time (your timezone)"
  if parsable_timezones.include? @time_standard
    erb :index
  else
    halt 404
  end

end

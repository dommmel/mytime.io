require 'sinatra'

not_found do
  erb :not_found
end

get "/" do
  @page_title = "Convert any time to local time (your timezone)"
  erb :not_found
end

get "/:time/:time_zone" do

  parsable_timezones = ["GMT", "UTC", "UT", "PST", "PDT", "EST", "EDT", "CST", "CDT", "MST", "MDT"]
  

  # redirect from /timezone/time to /time/timezone
  begin
    d = DateTime.parse(params[:time_zone])
    if parsable_timezones.include? params[:time].upcase
      redirect to("/#{params[:time_zone]}/#{params[:time].upcase}"), 301
    end
  rescue
  end

  # Redirect to uppercase time zones
  if !!/[[:lower:]]/.match(params[:time_zone])
    redirect to("/#{params[:time]}/#{params[:time_zone].upcase}"), 301
  end

  # Parse date
  begin
    d = DateTime.parse(params[:time]) 
  rescue
    halt 404 
  end

  @time = d.strftime("%H:%M:%S")
  @time_zone = params[:time_zone].upcase

  @today_string = Time.now.strftime("%Y/%m/%d")
  @title = params[:time] + " " + @time_zone
  @page_title = @title + " in local time (your timezone)"
  if parsable_timezones.include? @time_zone
    erb :index
  else
    halt 404
  end

end

require 'sinatra'
require 'sinatra/respond_with'
require 'newrelic_rpm'
require 'date'
require 'timezone_parser'

# Remove trailing slashes and redirect
before do
  url = request.url
  url.chomp!('/') if request.path_info =~ %r{^/(.*)/$}
  if url != request.url
    redirect to(url), 301
  end 
end

not_found do
  erb :not_found
end

get "/" do
  @page_title = "Convert any time to local time (your timezone)"
  erb :not_found
end

def parse_day(string)
  return nil if string.start_with? "UTC"
  begin
    return Date.parse(string).strftime
  rescue
    return nil
  end
end

UTC_OFFSET_WITH_COLON = '%s%02d:%02d'
UTC_OFFSET_WITHOUT_COLON = UTC_OFFSET_WITH_COLON.sub(':', '')
def seconds_to_utc_offset(seconds, colon = true)
  format = colon ? UTC_OFFSET_WITH_COLON : UTC_OFFSET_WITHOUT_COLON
  sign = (seconds < 0 ? '-' : '+')
  hours = seconds.abs / 3600
  minutes = (seconds.abs % 3600) / 60
  format % [sign, hours, minutes]
end

def parse_timezone(string)
  tz = string.upcase
  supported_timezones = ["GMT", "UTC", "UT", "PST", "PDT", "EST", "EDT", "CST", "CDT", "MST", "MDT"]
  if supported_timezones.include? tz
    @time_zone = tz
    return tz 
  else
    guessed_offset = TimezoneParser::Abbreviation.new(tz).getOffsets.first
    if guessed_offset.nil?
      if tz.start_with? "UTC" or tz.start_with? "GMT"
        offset_regex = /^([+]((14|(14[:]?00))|([0][0-9]|[1][01])|([0][0-9]|[1][01])[:]?[0-5][0-9]))|([-]((12|(12[:]?00))|([0][0-9]|[1][01])|([0][0-9]|[1][01])[:]?[0-5][0-9]))$/
        if  offset_regex.match(tz.sub(/^(UTC|GMT)/, '')).nil?
          return nil
        else
          @time_zone = tz
          return tz
        end
      else
        return nil
      end
    else
      @time_zone = "UTC"  + seconds_to_utc_offset(guessed_offset)
      return tz 
    end
  end
end

# we detect the time string by makeing sure DateTime parses it, but Date does not
def parse_time(string)
  return nil if string.start_with? "UTC"
  begin
    DateTime.parse(string)
    begin
      Date.parse(string)
    rescue
      # we return the original string since we want to have distinct urls/landingpages for 17:00 and 5am
      return string
    end
    return nil
  rescue
    return nil
  end
end

get "/:time/:timezone/?:day?" do

  t = params[:time]
  tz = params[:timezone]
  d = params[:day]

  is_url_elements = [t,tz,d].compact # remove nils resp. missing day
  should_url_elements = []

  # Sort parameters
  [method(:parse_time), method(:parse_timezone), method(:parse_day)].each_with_index do |m, index|
    is_url_elements.each do |element|
      parsed_element = m.call element
      unless parsed_element.nil?
        should_url_elements[index] = parsed_element 
        break
      end
    end
  end

  logger.info "SHOULD: " + should_url_elements.to_s
  logger.info "IS: " + is_url_elements.to_s

  # throw 404 if timezone or time is missing (day is optional)
  if should_url_elements[0].nil? or should_url_elements[1].nil?
    halt 404
  end

  # redirect to correct parameter order and spelling
  unless is_url_elements == should_url_elements
    redirect to("/" + should_url_elements.join("/"))
  end
 
  # I no day was given use "today"
  if d
    @day = d
    parsed_day = Date.parse(d)
  else
    @day= "today"
    parsed_day  = Time.now
   end
 
  @day_string_for_javascript = parsed_day.strftime("%Y/%m/%d")
  @time = DateTime.parse(t).strftime("%H:%M:%S")
  @hours = DateTime.parse(t).strftime("%H")
  @minutes = DateTime.parse(t).strftime("%M")
  @title = t + " " + tz
  @page_title = @title + " in local time (your timezone)"
  
  respond_to do |f|
    f.html { erb(:index) }
    f.txt { "#{@day_string_for_javascript} #{@time} #{@time_zone}"  }
  end
end

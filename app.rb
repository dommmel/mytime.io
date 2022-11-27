require 'sinatra'
require 'sinatra/respond_with'
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

get "/api" do
  erb :api
end

get "/examples" do
  timezones = ["GMT", "UTC", "UT", "PST", "PDT", "EST", "EDT", "CST", "CDT", "MST", "MDT"]
  minutes = [""]
  @examples = generate_examples(timezones,minutes).shuffle
  @show_more_links = true
  erb :examples
end

get "/more_examples" do
  timezones = ["ACDT","ACST","ACT","ACWT","ADDT","ADMT","ADT","AEDT","AEST","AET","AFT","AHDT","AHST","AKDT","AKST","AKT","AKTST","AKTT","ALMST","ALMT","AMST","AMT","ANAST","ANAT","ANT","APT","AQTST","AQTT","ARST","ART","ASB","ASHST","ASHT","AST","AT","AWDT","AWST","AWT","AZOMT","AZOST","AZOT","AZST","AZT","BAKST","BAKT","BDST","BDT","BEAT","BEAUT","BMT","BNT","BORT","BORTST","BOST","BOT","BRST","BRT","BST","BT","BTT","BURT","CANT","CAPT","CAST","CAT","CAWT","CCT","CDDT","CDT","CEMT","CEST","CET","CGST","CGT","CHADT","CHAST","CHAT","CHDT","CHOST","CHOT","CHUT","CKHST","CKT","CLST","CLT","CMT","COST","COT","CPT","CST","CT","CUT","CVST","CVT","CWT","CXT","ChST","DACT","DAVT","DDUT","DMT","DUSST","DUST","EASST","EAST","EAT","ECT","EDDT","EDT","EEST","EET","EGST","EGT","EHDT","EMT","EPT","EST","ET","EWT","FET","FFMT","FJST","FJT","FKST","FKT","FMT","FNST","FNT","FORT","FRUST","FRUT","GALT","GAMT","GBGT","GEST","GET","GFT","GHST","GILT","GMT","GST","GYT","HAC","HADT","HAE","HAP","HAR","HAST","HAT","HC","HDT","HE","HKST","HKT","HMT","HNC","HNE","HNP","HNR","HNT","HOVST","HOVT","HP","HR","HST","HT","ICT","IDDT","IDT","IHST","IMT","IOT","IRDT","IRKST","IRKT","IRST","ISST","IST","JAVT","JDT","JMT","JST","JWST","KART","KDT","KGST","KGT","KIZST","KIZT","KMT","KOST","KRAST","KRAT","KST","KUYST","KUYT","KWAT","LHDT","LHST","LHT","LINT","LKT","LRT","LST","MADMT","MADST","MADT","MAG","MAGST","MAGT","MALST","MALT","MART","MAWT","MDDT","MDST","MDT","MEST","MESZ","MET","MEZ","MHT","MIST","MMT","MOST","MOT","MPT","MSD","MSK","MST","MT","MUST","MUT","MVT","MWT","MYT","NCST","NCT","NDDT","NDT","NEGT","NEST","NET","NFT","NMT","NOVST","NOVT","NPT","NRT","NST","NT","NUT","NWT","NZDT","NZMT","NZST","NZT","OESZ","OEZ","OMSST","OMST","ORAST","ORAT","PDDT","PDT","PEST","PET","PETST","PETT","PGT","PHOT","PHST","PHT","PKST","PKT","PMDT","PMMT","PMST","PMT","PNT","PONT","PPMT","PPT","PST","PT","PWT","PYST","PYT","QMT","QYZST","QYZT","RET","RMT","ROTT","SAKST","SAKT","SAMST","SAMT","SAST","SBT","SCT","SDMT","SDT","SELČ","SET","SEČ","SGT","SHEST","SHET","SJMT","SMT","SRT","SST","STAT","SVEST","SVET","SWAT","SYOT","TAHT","TASST","TAST","TBIST","TBIT","TBMT","TFT","TJT","TKT","TLT","TMT","TOST","TOT","TRST","TRT","TSAT","TSB","TVT","ULAST","ULAT","URAST","URAT","UTC","UYHST","UYST","UYT","UZST","UZT","VET","VLAST","VLAT","VOLST","VOLT","VOST","VUST","VUT","WAKT","WARST","WART","WAST","WAT","WEMT","WEST","WESZ","WET","WEZ","WFT","WGST","WGT","WIB","WIT","WITA","WMT","WSDT","YAKST","YAKT","YDDT","YDT","YEKST","YEKT","YERST","YERT","YPT","YST","YWT"]
  minutes=["","00","10","15","20","30","40","45","50"]
  @examples = generate_examples(timezones,minutes).shuffle
  erb :examples
end

get "/sitemap.xml" do
  content_type 'text/xml'
  timezones = ["GMT", "UTC", "UT", "PST", "PDT", "EST", "EDT", "CST", "CDT", "MST", "MDT"]
  minutes = [""]
  @urls = generate_examples(timezones,minutes)
  timezones = ["ACDT","ACST","ACT","ACWT","ADDT","ADMT","ADT","AEDT","AEST","AET","AFT","AHDT","AHST","AKDT","AKST","AKT","AKTST","AKTT","ALMST","ALMT","AMST","AMT","ANAST","ANAT","ANT","APT","AQTST","AQTT","ARST","ART","ASB","ASHST","ASHT","AST","AT","AWDT","AWST","AWT","AZOMT","AZOST","AZOT","AZST","AZT","BAKST","BAKT","BDST","BDT","BEAT","BEAUT","BMT","BNT","BORT","BORTST","BOST","BOT","BRST","BRT","BST","BT","BTT","BURT","CANT","CAPT","CAST","CAT","CAWT","CCT","CDDT","CDT","CEMT","CEST","CET","CGST","CGT","CHADT","CHAST","CHAT","CHDT","CHOST","CHOT","CHUT","CKHST","CKT","CLST","CLT","CMT","COST","COT","CPT","CST","CT","CUT","CVST","CVT","CWT","CXT","ChST","DACT","DAVT","DDUT","DMT","DUSST","DUST","EASST","EAST","EAT","ECT","EDDT","EDT","EEST","EET","EGST","EGT","EHDT","EMT","EPT","EST","ET","EWT","FET","FFMT","FJST","FJT","FKST","FKT","FMT","FNST","FNT","FORT","FRUST","FRUT","GALT","GAMT","GBGT","GEST","GET","GFT","GHST","GILT","GMT","GST","GYT","HAC","HADT","HAE","HAP","HAR","HAST","HAT","HC","HDT","HE","HKST","HKT","HMT","HNC","HNE","HNP","HNR","HNT","HOVST","HOVT","HP","HR","HST","HT","ICT","IDDT","IDT","IHST","IMT","IOT","IRDT","IRKST","IRKT","IRST","ISST","IST","JAVT","JDT","JMT","JST","JWST","KART","KDT","KGST","KGT","KIZST","KIZT","KMT","KOST","KRAST","KRAT","KST","KUYST","KUYT","KWAT","LHDT","LHST","LHT","LINT","LKT","LRT","LST","MADMT","MADST","MADT","MAG","MAGST","MAGT","MALST","MALT","MART","MAWT","MDDT","MDST","MDT","MEST","MESZ","MET","MEZ","MHT","MIST","MMT","MOST","MOT","MPT","MSD","MSK","MST","MT","MUST","MUT","MVT","MWT","MYT","NCST","NCT","NDDT","NDT","NEGT","NEST","NET","NFT","NMT","NOVST","NOVT","NPT","NRT","NST","NT","NUT","NWT","NZDT","NZMT","NZST","NZT","OESZ","OEZ","OMSST","OMST","ORAST","ORAT","PDDT","PDT","PEST","PET","PETST","PETT","PGT","PHOT","PHST","PHT","PKST","PKT","PMDT","PMMT","PMST","PMT","PNT","PONT","PPMT","PPT","PST","PT","PWT","PYST","PYT","QMT","QYZST","QYZT","RET","RMT","ROTT","SAKST","SAKT","SAMST","SAMT","SAST","SBT","SCT","SDMT","SDT","SELČ","SET","SEČ","SGT","SHEST","SHET","SJMT","SMT","SRT","SST","STAT","SVEST","SVET","SWAT","SYOT","TAHT","TASST","TAST","TBIST","TBIT","TBMT","TFT","TJT","TKT","TLT","TMT","TOST","TOT","TRST","TRT","TSAT","TSB","TVT","ULAST","ULAT","URAST","URAT","UTC","UYHST","UYST","UYT","UZST","UZT","VET","VLAST","VLAT","VOLST","VOLT","VOST","VUST","VUT","WAKT","WARST","WART","WAST","WAT","WEMT","WEST","WESZ","WET","WEZ","WFT","WGST","WGT","WIB","WIT","WITA","WMT","WSDT","YAKST","YAKT","YDDT","YDT","YEKST","YEKT","YERST","YERT","YPT","YST","YWT"]
  minutes = ["","00","10","15","20","30","40","45","50"]
  @urls.concat generate_examples(timezones,minutes)

  @urls << "http://mytime.io"
  erb :sitemap, layout: false
end

def generate_examples(tz_array, minutes_array)
  hours=(1..12)
  hours24=(13..24)
  examples = []
  hours.each do |h|
    h = h.to_s
    minutes_array.each do |m|
      tz_array.each do |tz|
        ["am", "pm"].each do |apm|
          time_string = (m != "") ? "#{h}:#{m}" : "#{h}"
          examples << "#{time_string}#{apm}/#{tz}"
        end
      end
    end
  end
  return examples
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
  supported_timezones = ["GMT", "UTC", "UT", "PST", "PDT",  "CST", "CDT", "MST", "MDT"]
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

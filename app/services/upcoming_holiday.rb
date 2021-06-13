class UpcomingHoliday
  def upcoming_holidays
     response = Faraday.get("https://date.nager.at/Api/v2/NextPublicHolidays/US")
     parsed = JSON.parse(response.body, symbolize_names: true)

     holidays = parsed[0..2]
     holidays.map do |holiday|
       holiday
     end
  end
end

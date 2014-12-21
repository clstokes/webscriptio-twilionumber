-- get available numbers in an area code
local getNumbers = function ( twilioSid, twilioToken, areaCode )

  local response = http.request {
    url = string.format('https://api.twilio.com/2010-04-01/Accounts/%s/AvailablePhoneNumbers/US/Local.json', twilioSid),
    auth = { twilioSid, twilioToken },
    params = {
      AreaCode=areaCode,
      ExcludeAllAddressRequired=false,
      ExcludeLocalAddressRequired=false,
      ExcludeForeignAddressRequired=false
    }
  }

  local json = json.parse( response.content )
  return json

end

-- buy an available number in an area code
local buyNumber = function ( twilioSid, twilioToken, areaCode )

  local response = http.request {
    method = 'POST',
    url = string.format('https://api.twilio.com/2010-04-01/Accounts/%s/IncomingPhoneNumbers.json', twilioSid),
    auth = { twilioSid, twilioToken },
    data = {
      AreaCode=areaCode
    }
  }

  local json = json.parse( response.content )
  return json

end

return {
  getNumbers = getNumbers,
  buyNumber = buyNumber
}

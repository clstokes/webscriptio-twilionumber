-- find available numbers in an area code
function findNumbers( twilioSid, twilioToken, areaCode )

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
function buyNumber( twilioSid, twilioToken, areaCode )

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

-- buys a number if it's available
function findAndBuyNumber( twilioSid, twilioToken, areaCode )

  local numbers = findNumbers( twilioSid, twilioToken, areaCode )
  local count = table.getn( numbers.available_phone_numbers )

  if count > 0 then
    local boughtNumber = buyNumber( twilioSid, twilioToken, areaCode )
    return boughtNumber
  end

  return nil

end

return {
  findNumbers = findNumbers,
  buyNumber = buyNumber,
  findAndBuyNumber = findAndBuyNumber
}

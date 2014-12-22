-- buy an available number in an area code
function buyNumber(twilioSid, twilioToken, areaCode)

  local response = http.request {
    method = 'POST',
    url = string.format('https://api.twilio.com/2010-04-01/Accounts/%s/IncomingPhoneNumbers.json', twilioSid),
    auth = { twilioSid, twilioToken },
    data = { AreaCode = areaCode }
  }

  if response.statuscode == 201 then
    return json.parse(response.content)
  else
    return nil
  end

end

return {
  buyNumber = buyNumber
}

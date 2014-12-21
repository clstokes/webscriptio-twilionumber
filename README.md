# webscriptio-twilionumber

A Webscript module (https://www.webscript.io/) to find and buy available phone numbers from Twilio (https://www.twilio.com/).

# Usage

This module exposes two functions: `getNumbers` and `buyNumber`. Both functions take the same input parameters: your twilio account sid, twilio auth token, and an area code.

## Find Available Numbers by Area Code
```
local twilio = require( 'clstokes/webscriptio-twilionumber/main' )

local response = twilio.getNumbers( 'YOUR_TWILIO_ACCOUNT_SID', 'YOUR_TWILIO_AUTH_TOKEN', 206 )

return response.available_numbers
```

## Buy an Available Number by Area Code
```
local twilio = require( 'clstokes/webscriptio-twilionumber/main' )

local response = twilio.buyNumber( 'YOUR_TWILIO_ACCOUNT_SID', 'YOUR_TWILIO_AUTH_TOKEN', 206 )

return response.friendly_name
```

# Example

The webscript below requires an `AreaCode` query parameter and does the following:

1. If a number *was* found previously (based on the `alreadyFound` storage variable), the script exits with a simple message that a number was already found.
1. If a number was *not* found previously, the script queries the Twilio API for available numbers within `AreaCode`.
1. If an available number is *not* found, the script exits with a simple mesage that no numbers are available.
1. If an available number *is* found, the script buys an available number within `AreaCode`, sets `alreadyFound` to `true`, then alerts the Webscript account owner with an SMS message.

## Webscript 

```lua
if storage.alreadyFound then
  return 'Already found a number. Stopping...'
end

local areaCode = request.query.AreaCode

if areaCode == nil then
  return 'AreaCode is required as a query parameter.'
end

local twilioSid = 'YOUR_TWILIO_ACCOUNT_SID'
local twilioToken = 'YOUR_TWILIO_AUTH_TOKEN'

local twilio = require( 'clstokes/webscriptio-twilionumber/main' )

local numbers = twilio.getNumbers( twilioSid, twilioToken, areaCode )

local count = table.getn( numbers.available_phone_numbers )

if count > 0 then
  local boughtNumber = twilio.buyNumber( twilioSid, twilioToken, areaCode )

  local txt = 'Just bought '..boughtNumber.friendly_name..'. Go twilio!'
  storage.alreadyFound = true
  alert.sms( txt )
  return txt
end

local txt = '*No* phone numbers are available in the '..areaCode..' area code.'
return txt
```

# webscriptio-twilionumber

A Webscript module (https://www.webscript.io/) to find and buy an available phone number from Twilio (https://www.twilio.com/).

# Usage

This module exposes one function, `buyNumber`, that takes your twilio account sid, twilio auth token, and an area code as method arguments.

## Buy an Available Number by Area Code
```
local twilio = require( 'clstokes/webscriptio-twilionumber/main' )

local response = twilio.buyNumber( 'YOUR_TWILIO_ACCOUNT_SID', 'YOUR_TWILIO_AUTH_TOKEN', 206 )

return response.friendly_name
```

# Usage on Webscript.io

Webscript supports scheduling scripts as cron jobs. Create a new script from the code below and setup a cron job within Webscript.io to have the script check for available numbers and buy one once it's available.

The URL format for the script below must be in the form *&lt;subdomain>.webscript.io/&lt;path>?AreaCode=&lt;area_code>*.

# Example

The script below requires an `AreaCode` query parameter and does the following:

1. If a number *was* found previously (based on the `alreadyFound` storage variable), the script exits with a simple message that a number was already found.
1. If a number was *not* found previously, the script queries the Twilio API for available numbers within `AreaCode`.
1. If an available number is *not* found, the script exits with a simple mesage that no numbers are available.
1. If an available number *is* found, the script buys an available number within `AreaCode`, sets `alreadyFound` to `true`, then alerts the Webscript account owner with an SMS message.

## Code

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

local twilio = require('clstokes/webscriptio-twilionumber/main')

local boughtNumber = twilio.buyNumber(twilioSid, twilioToken, areaCode)

if boughtNumber ~= nil then
  storage.alreadyFound = true
  local txt = 'Just bought '..boughtNumber.friendly_name..'. Go twilio!'
  alert.sms(txt)
  return txt
end

return '*No* phone numbers are available in the '..areaCode..' area code.'
```

print('Setting up WIFI...')
wifi.setmode(wifi.STATION)
wifi.sta.config('Tenda_FE4948', '')
wifi.sta.connect()

tmr.alarm(1, 1000, tmr.ALARM_AUTO, function()
	if wifi.sta.getip() == nil then
		print('Waiting for IP ...')
	else
		print('IP is ' .. wifi.sta.getip())
	tmr.stop(1)
	end
end)

-- Serving static files
dofile('httpServer.lua')
httpServer:listen(80)

-- Custom API
-- Get text/html
httpServer:use('/welcome', function(req, res)
	res:send('Hello ' .. req.query.name) -- /welcome?name=doge
end)

-- Get file
httpServer:use('/doge', function(req, res)
	res:sendFile('doge.jpg')
end)

-- Get json
httpServer:use('/json', function(req, res)
	res:type('application/json')
	res:send('{"doge": "smile"}')
end)

-- Redirect
httpServer:use('/redirect', function(req, res)
	res:redirect('doge.jpg')
end)

gpio.mode(8,gpio.OUTPUT)

httpServer:use('/pinmode', function(req, res)
	if req.query.pin == "on" then
		gpio.write(8,gpio.HIGH)
		print("Light On")
		res:type('application/json')
		res:send('{"msg": "success"}')
	else
		gpio.write(8,gpio.LOW)
		print("Light Off")
		res:type('application/json')
		res:send('{"msg": "success"}')
	end	
	
end)

rPin = 7
gPin = 6
bPin = 5	
rDuty = 1000
gDuty = 1000
bDuty = 1000 

pwm.setup(rPin, 100, rDuty) 
pwm.setup(gPin, 100, gDuty) 
pwm.setup(bPin, 100, bDuty) 
pwm.start(rPin)
pwm.start(gPin)
pwm.start(bPin)

httpServer:use('/color', function(req, res)
	colorR = req.query.cR
	colorG = req.query.cG
	colorB = req.query.cB
	
    pwm.setduty(rPin, 1023 - colorR)
	pwm.setduty(gPin, 1023 - colorG)
	pwm.setduty(bPin, 1023 - colorB)

    print("Set Success")
    res:type('application/json')
    res:send('{"msg": "success"}')	
end)
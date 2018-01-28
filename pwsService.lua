local module = {}

module.name = 'Main'

mqttService = nil
wundpwsService = nil
bme280Service = nil

local workTimer = tmr.create()
local moduleConfig = nil


local function echo (text)
    print('['..module.name..'] '..text)
end

local function printData(weather)
    if(weather == nil or weather.T == nil) then
        echo ('No data!')
        return
    end 
    echo('Weather data: '
        .. ' T=' .. weather.T/100
        .. ' QFE='.. weather.P/1000
        .. ' QNH='.. weather.QNH/1000
        .. ' hum='.. weather.H/1000
        .. ' dew_point='.. weather.D/100)
end


local function work()  
   local weatherData = bme280Service.readData()
   if(weatherData ~= nil and weatherData.T ~=nil) then 
      printData(weatherData)
      wundpwsService.send(weatherData)
      if(mqttService.connected) then 
        mqttService.publish('temp',weatherData.T/100)
        mqttService.publish('qfe',weatherData.P/1000)
        mqttService.publish('qnh',weatherData.QNH/1000)
        mqttService.publish('hum',weatherData.H/1000)
        mqttService.publish('dew_point',weatherData.D/100)
      end
   end
end

function module.init(cnf)
    moduleConfig = cnf
    workTimer:register(moduleConfig.updateInterval,tmr.ALARM_AUTO,work)
end 

function module.netUp()
    if(mqttService == nil) then 
        mqttService = require('mqttService')
        mqttService.init(config.mqtt)
    end
    if(wundpwsService == nil) then 
        wundpwsService = require('wundpwsService')
        wundpwsService.init(config.wundpws)
    end
    if(bme280Service == nil) then 
        bme280Service = require('bme280Service')
        bme280Service.init(config.bme280)
    end
    mqttService.connect()
    workTimer:start()
end 
function module.netDown()
    if(mqttService ~= nil) then 
        mqttService.disconnect()
    end    
    workTimer:stop()
end



function mqtt_sendData()
    if (mqtt_connected and T ~= nil) then 
       mq:publish(mqtt_config.topic .. '/temp',T/100,1,0)
       mq:publish(mqtt_config.topic .. '/qfe',P/1000,1,0)
       mq:publish(mqtt_config.topic .. '/qnh',QNH/1000,1,0)
       mq:publish(mqtt_config.topic .. '/hum',H/1000,1,0)
       mq:publish(mqtt_config.topic .. '/dew_point',D/100,1,0) 
       print('[MQTT] Send payloads!') 
   end
end

return module

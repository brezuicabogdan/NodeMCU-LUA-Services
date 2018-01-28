local module = {}

module.name = 'WiFi'
module.onConnect = nil 
module.onDisconnect = nil
module.connected = false

local moduleConfig = nil

local function echo (text)
    print('['..module.name..'] '..text)
end

function module.init(cnf)
    moduleConfig = cnf
    wifi.setmode (wifi.STATION)
    wifi.sta.config(cnf) 

    wifi.eventmon.unregister(wifi.eventmon.STA_GOT_IP)
    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
        module.connected = true
        echo ("Connected to ".. cnf.ssid .." IP: "..T.IP)
        if(module.onConnect ~= nil) then
            module.onConnect() 
        end
    end)

    wifi.eventmon.unregister(wifi.eventmon.STA_DISCONNECTED)
    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
        if(module.connected == true) then
            module.connected = false
            echo("Disconnected from: "..T.SSID)
            if(onDisconnect ~= nil) then
                onDisconnect()
            end
        end
    end)
end

function module.connect()
    echo('Connecting to ' .. moduleConfig.ssid)
    wifi.sta.autoconnect (1)
end

function module.disconnect()
    echo('Disconnecting from ' .. cnf.ssid)
    wifi.sta.autoconnect(0)
    wifi.sta.disconnect()
end

return module

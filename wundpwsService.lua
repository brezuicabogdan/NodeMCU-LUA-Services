local module = {}

module.name = 'WundPWS'

local moduleConfig = nil

local function echo (text)
    print('['..module.name..'] '..text)
end
local function c2f(tc)
    return tc * 1.8 + 32
end

function module.init(cnf)
    moduleConfig = cnf
end 

function module.send(data)
    if(data == nil or data.T == nil) then 
        echo('Invalid data! Cannot send')
        return
    end
    local url = moduleConfig.url .. '?action=updateraw'
        .. '&ID='..moduleConfig.ID
        .. '&PASSWORD='..moduleConfig.KEY
        .. '&dateutc=now'
        .. '&humidity=' .. data.H/1000
        .. '&tempf='.. c2f(data.T/100)
        .. '&dewptf='.. c2f(data.D/100)
        .. '&baromin='..data.P/33863.886666667
    http.get(url,nil,function(code, data)
        if (code < 0) then
            echo("HTTP request failed")
        elseif (code == 200 and string.match(data, 'success')) then 
            echo("Data sent!")
        else   
            echo("Error sending data: " .. code .. ': '..data)
        end
    end)
end

return module

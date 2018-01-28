local module = {}

module.name = 'Mqtt'

module.connected = false
module.onReceive = nil
local moduleConfig = nil
local mq = nil
local user_disconnect = false

local function echo (text)
    print('['..module.name..'] '..text)
end
local function handle_message (conn, topic, data) 
    echo ("Message received! Topic "..topic .. " data " .. data )
    if(module.onReceive ~= nil) then
        module.onReceive(topic,data)
    end
end

function module.init(cnf)
    moduleConfig = cnf
    mq = mqtt.Client(cnf.nodeId,60,cnf.user, cnf.pwd)
    mq:on("message", handle_message)
    mq:on('offline',function(client)
        if (module.connected) then 
            echo('Disconnected from broker!')
            if(user_disconnect == false) then 
                echo('Will attempt reconnect in 10 sec.')
                tmr.create():alarm(10 * 1000, tmr.ALARM_SINGLE, module.connect)
            else 
                module_disconnect = false   
            end
            module.connected = false
        end
    end)
    mq:lwt(moduleConfig.nodeTopic,'offline',moduleConfig.defaultQos)
end 

function module.connect()
    mq:connect(moduleConfig.host, moduleConfig.port, moduleConfig.secure, 0, function(con) 
        echo('Connected to broker on '.. moduleConfig.host ..'!')
        module.connected = true
        mq:publish(moduleConfig.nodeTopic,'online',moduleConfig.defaultQos,0)
        for i=0,9 do
            if(moduleConfig.subscribeTopics[i] ~= nil) then 
                mq:subscribe(moduleConfig.subscribeTopics[i],0, function(conn) echo("Successfully subscribed to " .. moduleConfig.subscribeTopics[i]) end)
            end
        end
    end,
    function(client,reason)
        echo('Cannot connect to broker on '.. moduleConfig.host .. ':' .. moduleConfig.port ..'. Reason ' .. reason)
        tmr.create():alarm(10 * 1000, tmr.ALARM_SINGLE, module.connect)
        module.connected = false
    end
    )
end
function module.disconnect()
    user_disconnect = true
    mq:close()
end

function module.publish(topic,message,qos, retain)
    if(module.connected == false) then
        echo('Not connected to broker! Cannot publish yet!')
        return
    end
    if (qos == nil) then 
        qos = moduleConfig.defaultQos
    end
    if (retain == nil) then 
        retain = 0
    end
    echo('Sending data to '..topic)
    return mq:publish(moduleConfig.topic .. '/'..topic,message,qos,retain,function (client) echo('Data sent!') end)
end

return module

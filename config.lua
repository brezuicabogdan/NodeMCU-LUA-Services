local module = {}

module.nodeId = 'my-node-id'

module.wifi = {
    ssid = "SSID",
    pwd = 'wifi_password',
    auto = true
}
module.mqtt = {
    host = '192.168.1.1',
    port = 1883,
    user = 'username',
    pwd  = 'password',
    secure = 0,
    nodeId = module.nodeId,
    topic = 'topic/to/post/data/to',
    nodeTopic = 'nodes/'..module.nodeId,
    subscribeTopics = {
        'nodes/'..module.nodeId..'/command'
    },
    defaultQos = 1
}

module.wundpws = {
    url = 'http://weatherstation.wunderground.com/weatherstation/updateweatherstation.php',
    ID = 'STATION_ID',
    KEY = 'STATION_KEY',
}

module.bme280 = {
    altitude = 286,
}

module.general = {
    updateInterval = 30000,
}

return module

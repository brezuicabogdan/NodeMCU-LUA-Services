config = require('config')
print('Node ID is: ' .. config.nodeId)

wifiService = require('wifiService')
mainService = require('mainService')
wifiService.init(config.wifi) 
mainService.init(config.general) 

wifiService.onConnect = function () 
                            mainService.netUp()
                        end
wifiService.onDisconnect = function () 
                            mainService.netDown()   
                         end
wifiService.connect() 

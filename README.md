# NodeMCU-LUA-Services

A collection of NodeMCU LUA scripts providing service wrappers for different operations. 

Th reasons for making these scripts public is that when I first started with NodeMCU and LUA I found little resources forparticular things and I had to experiment with different approaces and code found on the web. Hopefully these scripts will help the newcommers to LUA and NodeMCU kickstart their learning.

### How to use
Because these scripts were born from my own necessity, they are customised to the particular needs of those projecst and may change in the future. Please use the conde in these scripts and not the scripts as a whole as future updatesmay not include backwards compatibility for all functions. 

Although these scripts can work toghether they are not intended to - use only what you need for your project. Each script is intended to be standalone.

### Instalation
Well this is not the purpose of this repository. There areplenty of resources online and also more than one method to get this code on to your NodeMCU. I personally like and use ESPlorer (https://esp8266.ru/esplorer/)

# Scripts

| File(s) | Script Description |
| ------- | ------------------ |
| init.lua | Initialization script with delayed boot and abort boot functionality |
| startup.lua | A startup file that connects to wifi and executes code when connections is up or goes down. |
| config.lua | Example of centralised configuration file |
| wifiService.lua | This service connects to the wifi network specified and provides callbacks for 'connected' and 'disconnected' events |
| mqttService.lua | The mqtt service is a wrapper for the mqtt module that handles connecting to a broker, publishing, lwt, node status and subscripbing to topics, providing callback for received messages |
| bme280Service.lua | This is a wrapper for communicating with the BME280 environmental sensor over I2C and extracting Temp, Relative Humidity, Athmosferic Pressure (both QFE and QNH)  and Dew Point as a table |
| wundpwsService.lua | A service to post the date received from teh bme280 service Wunderground.com using the Personal Weather Station Upload protocl (http://wiki.wunderground.com/index.php/PWS_-_Upload_Protocol). |
| pwsService.lua | Example of how I am using the above scripts to create a simple Personal Weather Station that uploads the data to Wunderground directly and send it to my home automation system at the same time. You can rename this as mainService.lua and use the above scripts as they are |


Detailed scripts descriptions - TO BE ADDED

### FInal Notes

Please use this scripts as a learning resource and do not rely on this code to do work out of the box. Do not lear to code - code to learn! 
If you have questions please PM me and I will do my best to help you in a timely manner!

Have fun conding!


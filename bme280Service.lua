local module = {}

local moduleConfig = nil

module.name = 'BME280'
module.data = nil

function module.init(cnf)
    moduleConfig = cnf
    i2c.setup(0, 3, 4, i2c.SLOW)
    bme280.setup()
end

local function echo (text)
    print('['..module.name..'] '..text)
end

function module.readData()
    local T, P, H, QNH = bme280.read(moduleConfig.altitude)
    if (T ~= nil) then
        local D = bme280.dewpoint(H, T)    
        module.data = {
            T = T,
            P = P,
            H = H,
            QNH = QNH,
            D = D
        }
    else
        module.data = nil
    end
    return module.data
end

return module

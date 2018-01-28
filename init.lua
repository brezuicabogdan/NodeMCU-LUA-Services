local InitScriptVersion = "1.0-2018-01-17"
local FileToExecute = "startup.lua"
local BootTimeout = 200
local AbortTimeout = 3000

-- initialize abort boolean flag
local abortFlag = false

function firmwareInfo()
  if (1/3) > 0 then
    print('FLOAT firmware version')
  else
    print('INTEGER firmware version')
  end
end

function init()
  print('Boot script version '..InitScriptVersion)
  print('Press ENTER to abort startup')

  -- if <CR> is pressed, call abort
  uart.on('data', '\r', abort, 0)

  -- start timer to execute startup function in 3 seconds
  tmr.alarm(0, AbortTimeout, 0, startup)
end

function abort()
  -- user requested abort
  abortFlag = true
end

function startup()
  -- turns off uart scanning
  uart.on('data')

  if abortFlag == true then
    print('#### startup aborted ####')
    return
  end

  -- otherwise, start up
  if file.exists(FileToExecute) then
    print('Booting ...')
    dofile(FileToExecute)
  else
    print('Startup script '..FileToExecute..' not found. Boot Aborted!!!')
    return
  end
end

firmwareInfo()
tmr.alarm(0, BootTimeout, 0, init)

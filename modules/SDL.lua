require('os')

local SDL = { }

SDL.exitOnCrash = true
SDL.autoRun = false

SDL.STOPPED = 0
SDL.RUNNING = 1
SDL.CRASH = -1

function SDL:StartSDL(pathToSDL, ExitOnCrash)
  if ExitOnCrash ~= nil then
    self.exitOnCrash = ExitOnCrash
  end
  local status = self:CheckStatusSDL()
  if status == self.STOPPED then
    local result = os.execute ('./StartSDL ' .. pathToSDL)
    if result then
      return true
    else
      local msg = "SDL had already started  not from ATF" 
      print(console.setattr(msg, "cyan", 1))
      return nil, msg
    end
  else
    local msg = "SDL had already started from ATF"
    print(console.setattr(msg, "cyan", 1))
    return nil, msg
  end
end

function SDL:StopSDL()
  self.autoStarted = false
  local status = self:CheckStatusSDL()
  if status == self.RUNNING then
    local result = os.execute ('./StopSDL')
    if result then 
      return true
    end
  else
    local msg = "SDL had already stopped"
    print(console.setattr(msg, "cyan", 1))
    return nil, msg
  end
end

function SDL:CheckStatusSDL()
  local result1 = os.execute ('test -e sdl.pid')
  if result1 then 
    local result2 = os.execute ('test -e /proc/$(cat sdl.pid)')
    if not result2 then
      return self.CRASH
    else
      return self.RUNNING
    end
  else
    return self.STOPPED
  end
end

function SDL:DeleteFile()
  os.execute ('rm -f sdl.pid')
end

return SDL

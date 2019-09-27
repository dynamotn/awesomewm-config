-- Wallpaper library
local wallpaper_lib = require("gears.wallpaper")
-- Custom shell library
local shell = require("dynamo.shell")

-- { Set wallpaper
-- Set random wallpaper to screen from list files
-- @param awesome.screen s Screen that is needed to set wallpaper
-- @param table list_files List of wallpaper files
local function set_wallpaper(s, list_files)
  if next(list_files) ~= nil then
    wallpaper_lib.maximized(list_files[math.random(1, #list_files)], s, true)
  end
  collectgarbage("collect")
end

-- Automatically change wallpaper in seconds
-- @param awesome.screen s Screen that is needed to auto change wallpaper
-- @param boolean is_recursion Flag when this function call itself
local function auto_change_wallpaper(s, is_recursion)
  wallpaper.timer:stop()
  if not is_recursion then
    wallpaper.timer:connect_signal("timeout", function()
      auto_change_wallpaper(s, true)
    end)
  end
  set_wallpaper(s, wallpaper.files)
  wallpaper.timer:start()
end
-- }

-- { Linux distribution detection
-- Check is specify distribution
-- @param string Distribution detection name
-- @return string Result of check command
local function is_linux_distribution(distribution_name)
  return shell.run_command_one_line("cat /etc/os-release | grep '" .. distribution_name .. "'") ~= ""
end

-- Get Linux distribution name
-- @return string Name of distribution
local function linux_distribution()
  if is_linux_distribution("Ubuntu") then
    return "ubuntu"
  elseif is_linux_distribution("Arch Linux") then
    return "archlinux"
  elseif is_linux_distribution("Gentoo") then
    return "gentoo"
  else
    -- FIXME: Add other distribution if needed
    return "linux"
  end
end
-- }

-- { Redshift
local redshift_state

-- Dim screen
local function redshift_dim()
  shell.run_command("redshift -o", true, function() redshift_state = 1 end)
end

-- Undim screen
local function redshift_undim()
  shell.run_command("redshift -x", true, function() redshift_state = 0 end)
end

-- Toggle redshift state
local function redshift_toggle()
  if redshift_state == 1 then
    redshift_undim()
  else
    redshift_dim()
  end
end

-- Initial screen to normal
local function redshift_init()
  redshift_state = 0
  redshift_undim()
end
-- }

return {
  auto_change_wallpaper = auto_change_wallpaper,
  linux_distribution = linux_distribution,
  redshift_toggle = redshift_toggle,
  redshift_init = redshift_init,
}

require 'mp'

local function set_clipboard(text)
    mp.commandv("run", "/home/chaise/.config/mpv/scripts/xclip.sh", text);
end

local function copyTime()
    local path = mp.get_property("path")
    set_clipboard(path)
    mp.osd_message(string.format("Copied to Clipboard: %s", path))
end

mp.add_key_binding("Ctrl+y", "copyTime", copyTime)

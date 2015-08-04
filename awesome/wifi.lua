wifiwidget = nil

-- TODO: find better way to check wifi
local bash_wifi_check="awk 'NR==3 {print \$3 \"%\"}' /proc/net/wireless | sed 's/\\\.//g'"

function wifiWidgetInit()
    local wifi=execute_command(bash_wifi_check) 
    if wifi ~= "" then
        -- initialize widget
        wifiwidget=widget({type = "textbox", name = "wifiwidget", align = "right" })
        -- set wifi text
        wifiInfo()
        -- setup timer
        awful.hooks.timer.register(5, function() wifiInfo() end)
    end
end

function wifiInfo()
 spacer = " "
 local wifiStrength = execute_command(bash_wifi_check)
 local label = "<b>WiFi</b> "
 wifiwidget.text = label..spacer..wifiStrength..spacer
end

-- run once
wifiWidgetInit()


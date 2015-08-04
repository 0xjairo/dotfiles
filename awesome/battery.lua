battery_remaining_s = ""

batterywidget = widget({ type = "textbox", name = "batterywidget"})
function read_acpi()
    local fd=io.popen("acpi -b", "r") --list present batteries
    -- if no acpi, return nil
    if not fd then
        return nil
    end

    -- read acpi info
    return fd:read()
end

function battery_status ()
    local line = read_acpi()
    if not line then
        return nil
    end

    local output={} --output buffer
    local label="<b>BAT</b> "
    while line do --there might be several batteries.
        local battery_num = string.match(line, "Battery (%d+)")
        local battery_load = string.match(line, " (%d+)%%")
        local time_rem = string.match(line, "(%d+\:%d+)\:%d+")
        battery_remaining_s = time_rem

        local color
        if string.find(line, "Discharging") then --discharging: always red
            if tonumber(battery_load)>85 then --almost charged
                color="<span>" -- green
            elseif tonumber(battery_load) > 25 then 
                color="<span>" -- yellow
            else
                color="<span color=\"#CC3333\">" -- red
            end
        else --charging
            color="<span>"
        end
        if battery_num and battery_load and time_rem then
            table.insert(output,color..label..battery_load.."% </span>")
        elseif battery_num and battery_load then --remaining time unavailable
            table.insert(output,color..label..battery_load.."%</span>")
        end --even more data unavailable: we might be getting an unexpected output format, so let's just skip this line.
        line=nil
    end
    return table.concat(output," ") --FIXME: better separation for several batteries. maybe a pipe?
end

function battery_widget_udpate(widget, tooltip)
    local bat = battery_status()
    if bat and widget then
        widget.text = " " .. battery_status() .. " "
        tooltip:set_text(" " .. battery_remaining_s .. " ")
    else
        widget=nil
        tooltip=nil
    end
end

-- setup timer to call periodically
my_battmon_timer=timer({timeout=30})
my_battmon_timer:add_signal("timeout", function()
    --mytextbox.text = " " .. os.date() .. " "
    battery_widget_udpate(batterywidget, battery_remaining_t)
    battery_remaining_t:set_text(" " .. battery_remaining_s .. " ")
end)

-- call once if battery is presetn
if read_acpi() then
    -- button to update when clicked
    batterywidget.buttons(batterywidget, { 
        button({ }, 1, function() battery_widget_udpate(batterywidget, battery_remaining_t) end )
    })

    -- tooltip
    battery_remaining_t = awful.tooltip({ objects = { batterywidget }, })
    battery_widget_udpate(batterywidget, battery_remaining_t)
    -- start timer
    my_battmon_timer:start()
end


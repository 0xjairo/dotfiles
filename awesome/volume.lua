-- Volume Widget
volume_widget = widget({ type = "textbox", name = "tb_volume", align = "right" })

current_volume = 50
volume_delta = 5
function volume_set(widget, volume)
    local fd = io.popen("pactl list short sinks | sed -n '/RUNNING/{s/[[:space:]].*//p}'")
    local sink_id = fd:read("*all")
    print("Sink_id: " .. sink_id .. "\n")
    if string.len(sink_id) > 0 then
        sink_id = tonumber(sink_id)
        io.popen("pactl set-sink-volume " .. sink_id .. " -- " .. volume .. "%")
    end
    volume_update(widget)
end

function volume_inc(widget)
    current_volume = current_volume + volume_delta
    if current_volume > 100 then
        current_volume = 100
    end
    volume_set(widget, current_volume)
end

function volume_dec(widget)
    current_volume = current_volume - volume_delta
    if current_volume < 0 then
        current_volume = 0
    end
    volume_set(widget, current_volume)
end

function volume_update(widget)

    -- starting color
    local sr, sg, sb = 0x3f, 0x3f, 0x3f
    -- ending color
    local er, eg, eb = 0xdc, 0xdc, 0xcc

    local ir = current_volume * (er - sr) + sr
    local ig = current_volume * (eg - sg) + sg
    local ib = current_volume * (eb - sb) + sb
    local label = "<b>VOL</b> "
    local vol100 = string.format(label.."%3d", current_volume) .. "%"
    interpol_color = string.format("%.2x%.2x%.2x", ir, ig, ib)
    volume = "<span>".. vol100 .. " </span>"
    widget.text = volume
end

volume_set(volume_widget, current_volume)

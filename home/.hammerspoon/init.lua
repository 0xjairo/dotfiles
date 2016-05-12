-- Store the state (placement and size) of a window
-- before it is resized with one of the shortcuts below.
-- This allows you to "restore" them with cmd-alt-ctrl+Down
local window_states = {}

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
    hs.reload()
end)

function saveState(win)
    local winId = win:id()
    -- Look for the id in the window_states table
    -- If it's already there, the state has been
    -- saved, and ignore
    for idx, winState in pairs(window_states) do
        if winState["id"] == winId then return end
    end

    local win_state = {id=winId, frame=win:frame() }
    table.insert(window_states, win_state)
end

function popState(win)
    --- Return window state if it is saved
    local winId = win:id()
    local winState = nil
    local stateIndex = nil
    for idx, w in pairs(window_states) do
        if w["id"] == winId then
            winState = w
            stateIndex = idx
            break
        end
    end

    -- if not found, return nil
    if stateIndex == nil then
        return nil
    end

    -- erase from table if found
    window_states[stateIndex] = nil
    -- return
    return winState
end

function getWinFrameScreen()
    -- helper function to get commonly
    -- used window state
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    return win, f, screen
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", function()
    local win, f, screen = getWinFrameScreen()

    winState = popState(win)
    if winState == nil then return end

    -- restore window
    win:setFrame(winState.frame)
end)

-- Maximize
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
    local win, f, screen = getWinFrameScreen()
    local max = screen:frame()

    -- save state
    saveState(win)

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end)


hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
    local win, f, screen = getWinFrameScreen()
    local max = screen:frame()

    -- save state
    saveState(win)

    f.x = max.x
    f.y = max.y
    f.w = max.w/2
    f.h = max.h
    win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
    local win, f, screen = getWinFrameScreen()
    local max = screen:frame()

    -- save state
    saveState(win)

    f.x = max.x + (max.w/2)
    f.y = max.y
    f.w = max.w/2
    f.h = max.h
    win:setFrame(f)
end)

hs.alert.show("Config loaded")

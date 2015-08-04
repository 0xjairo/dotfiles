-- https://awesome.naquadah.org/wiki/Email_notification_with_mutt_integration
------------------------------------------------------------------------------
-- mailbar
------------------------------------------------------------------------------

-- table that holds all mailbar-related objects
mailbar = { }


-- mailbar configuration
mailbar['conf'] = {
  maildir = os.getenv("HOME") .. "/.mail",
  accounts = { "work" },
  visible_by_default = true,
  check_interval = 60,
  notification_timeout = 30
}


-- prefills totalmail table
mailbar['totalmail'] = { }
for _, account in ipairs(mailbar['conf']['accounts']) do
  mailbar['totalmail'][account] = { new = 0, seen = 0 }
end


-- adds a button with text to a list
function add_button(list, text, func_press, func_release)
  local button = widget({ type = "textbox" })
  button.text = text
  button:buttons( awful.button({ }, 1, func_press or nil, func_release or nil) )
  return awful.util.table.join(list, { button })
end


-- notifies of new mail using naughty
function notify_newmail(account, new, seen)
  naughty.notify({
    text = new .. "/" .. seen,
    title = "New messages in [" .. account .. "]",
    position = "top_left",
    timeout = mailbar['conf']['notification_timeout'],
    --fg="#ffggcc",
    --bg="#bbggcc",
    ontop = true })
end


-- finds new mail in account and mailbox
function new_in_mailbox(account, mailbox)
  return tonumber(execute_command("find \"" ..
                         mailbar['conf']['maildir'] .. "/" .. account .. "/" .. mailbox ..
                         "\" -type f -wholename '*/new/*' | wc -l"))
end


-- finds new but seen mail in account and mailbox
function seen_in_mailbox(account, mailbox)
  return tonumber(execute_command("find \"" ..
                         mailbar['conf']['maildir'] .. "/" .. account .. "/" .. mailbox ..
                         "\" -type f -regex '.*/cur/.*2,[^S]*$' | wc -l"))
end


-- spawns a terminal with mutt in the mailbox listing for an account
function fspawn_account(account)
  return function ()
           awful.util.spawn(terminal .. " -e \"mutt -y\"")
         end
end


-- spawns a terminal with mutt in an account's mailbox
function fspawn_mailbox(account, mailbox)
  return function (button)
           awful.util.spawn(terminal .. 
                            " -e \"mutt -f " ..
                            mailbar['conf']['maildir'] .. "/" ..
                            account ..
                            "/" .. mailbox .. "\"")
           button.bg = "#666666"
         end
end


-- builds buttons for an account
function build_mailbuttons(account)
  local mailbuttons = {}
  local new = new_in_mailbox(account, "")
  local seen = seen_in_mailbox(account, "")

  -- notifies if new mail has arrived
  if new > mailbar['totalmail'][account]['new']
     or seen > mailbar['totalmail'][account]['seen']
  then
    notify_newmail(account, new, seen)
  end
  mailbar['totalmail'][account] = { new = new, seen = seen }
  
  -- builds buttons for the account if there is any new mail
  if (new + seen) ~= 0 then
    local fh = io.popen("ls -1 " .. mailbar['conf']['maildir'] .. "/" .. account)
    mailbuttons = add_button(mailbuttons, ":::")
    mailbuttons = add_button(mailbuttons,
                             "   [" .. account .. "] (" .. new ..
                             "/" .. seen .. ")   ",
                             fspawn_account(account))
    for mailbox in fh:lines() do
      seen = seen_in_mailbox(account, mailbox)
      new = new_in_mailbox(account, mailbox)
      if new + seen ~= 0 then
        mailbuttons = add_button(mailbuttons, ":::")
        mailbuttons = add_button(mailbuttons,
                                 "   " .. mailbox .. " (" .. new .. "/" .. seen .. ")   ",
                                 fspawn_mailbox(account, mailbox))
      end
    end
    io.close(fh)
  end

  return mailbuttons
end


-- updates the mailbar with new info
function update_mailbar(accounts, mailbar)
  local buttons = { }
  for i, account in ipairs(accounts) do
    buttons = awful.util.table.join(buttons, build_mailbuttons(account))
  end
  mailbar.widgets = awful.util.table.join(buttons,
                                       { layout = awful.widget.layout.horizontal.leftright } )

  -- hides bar if there is no mail
  if #buttons == 0 then
    mailbar.visible = false
  end
end


-- creates the mailbar
mailbar['wibox'] = awful.wibox({ position = "bottom", screen = 1 })
mailbar['wibox'].visible = mailbar['conf']['visible_by_default']
mailbar['wibox'].ontop = true


-- sets up a timer to update the bar
mailbar['timer'] = timer({ timeout = mailbar['conf']['check_interval'] })
update_mailbar(mailbar['conf']['accounts'], mailbar['wibox'])
mailbar['timer']:add_signal("timeout",
                     function() update_mailbar(mailbar['conf']['accounts'], mailbar['wibox']) end)
mailbar['timer']:start()
--
--
-- key bindings
globalkeys = awful.util.table.join(globalkeys,
    awful.key({ }, "F12", 
        function () 
            mailbar['wibox'].visible = not mailbar['wibox'].visible 
            update_mailbar(mailbar['conf']['accounts'], mailbar['wibox'])
        end))


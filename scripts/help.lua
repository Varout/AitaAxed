aa = aa or {}
aa.help = aa.help or {}

-- '' = {alias = '', settings_update = false, about = ''},
local help_commands = {
  ['help']   = {command = 'help',   alias = 'h', settings_update = false, about = 'Show all available commands'},
  ['clear']  = {command = 'clear',  alias = 'c', settings_update = false, about = 'Clears the banner on the screnn in case it gets stuck'},
  ['reload'] = {command = 'reload', alias = 'r', settings_update = false, about = 'Reloads the AitaAxed add-on. Same as lua r AitaAxed'},
  ['unload'] = {command = 'unload', alias = 'u', settings_update = false, about = 'Unloads the AitaAxed add-on. Same as lua u AitaAxed'},
  ['test']   = {command = 'test',   alias = nil, settings_update = false, about = 'Shows a test text on screen so you can positoin it easier'},
  -- ['save']   = {command = 'save',   alias = nil, settings_update = true,  about = 'Saves the settings you have set up for a specific <job>, where <job> is the 3 letter abbreviation of the job. e.g. "aa save whm"'},
}

local commands_with_update = {}
local help_commands_by_alias = {}
for key, data in pairs(help_commands) do
  if data.alias then
    help_commands_by_alias[data.alias] = key
  end
end


--  Get help text for a specific command or alias
aa.help.get_help_for = function(command)
  local data = aa.help.get_data_for_command_or_alias(command)

  -- If still not found, return nil or error message
  if not data then
    return "No help available for '" .. command .. "'."
  end

  return aa.help.form_help_text(data)
end


--  Show all available commands with the help text and alias
aa.help.show_available_commands = function()
  local help_text = '\n\n'
  for key, data in pairs(help_commands) do
    help_text = help_text .. aa.help.form_help_text(data) .. '\n\n'
  end
  return help_text
end


--  Construct help text for a piece of data and format depending on if it has an alias or not
aa.help.form_help_text = function(data)
    local help_text = ''
    if data.alias then
      help_text = string.format("%s (%s): %s", data.command, data.alias, data.about)
    else
      help_text = string.format("%s: %s", data.command, data.about)
    end
    return help_text
end


--  Returns true if the command or alias has an update function associated with it
aa.help.contains_update_function = function(command)
  local data = aa.help.get_data_for_command_or_alias(command)
  if data then
    return data.settings_update
  else
    return false
  end
end


--  Get the data for a command or alias
aa.help.get_data_for_command_or_alias = function(command)
  command = command:lower()
  local data = help_commands[command]

  -- If not found, try alias
  if not data then
      local realKey = help_commands_by_alias[command]
      if realKey then
          data = help_commands[realKey]
      end
  end

  return data
end
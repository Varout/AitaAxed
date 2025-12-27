--[[

Copyright © 2025, Varrout of Phoenix
GitHub: https://github.com/Varout/AitaAxed
React: Copyright © 2016, Sammeh of Quetzalcoatl
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
  * Neither the name of AitaAxed nor the
    names of its contributors may be used to endorse or promote products
    derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Varrout BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Information on Development for Windower can be found here: https://github.com/Windower/Lua/wiki

]]

_addon.name = 'AitaAxed'
_addon.author = 'Varout'
_addon.thanks = 'Carbonite, The Shed, Artimus'
_addon.version = '0.5 beta'
_addon.commands = {'AitaAxed', 'aa'}

-- 0.5 (Planned): Ability to update settings from in-game
--                Set up job-specific settings

-- 0.5 Actual
--  Ability to send Elemental Weakness to GearSwap
--  Ability to add custom text boxes for abilities (See: ability_notification_stanard in objects.lua)
--  When using a custom position (not centred), the text will cling to the side of the screen

require('actions')
require('chat')
require('logger')
require('pack')
require('sets')
require('strings')
require('tables')
local config = require('config')
local files = require('files')
local res = require('resources')
local texts = require('texts')

--  AitaAxed Included Scripts
require('scripts/core')  -- Developed by: https://github.com/Kaiconure/
require('scripts/help')
require('scripts/objects')

local ui_info_box
local ui_info_shown = false
local ui_display_start = nil

local player_job = windower.ffxi.get_player().main_job

local settings = config.load(aa.objects.get_settings_defaults(player_job))
local ui_config = aa.objects.get_ui_config(settings, player_job)
local base_x_pos = tonumber(ui_config.pos.x)

local element_names = aa.objects.get_colours()
local element_colour_map = aa.objects.get_element_colour_map()

local standard_ability_map = aa.objects.get_standard_ability_map()

local ability_weaknesses_aita = aa.objects.get_ability_weaknesses_aita()
local ability_weaknesses_gartell = aa.objects.get_ability_weaknesses_gartell()
local aita_map = aa.objects.get_aita_map()
local gartell_map = aa.objects.get_gartell_map()


function apply_text_colour(text_to_display, colour_to_use)
  if settings.font.use_colours then
    local rbg_colour_code = element_colour_map[colour_to_use]
    return '\\cs' .. rbg_colour_code .. text_to_display .. '\\cr'
  else
    return text_to_display
  end
end


function format_text_aita(ability_name)
  local element_str_nuke = ability_weaknesses_aita[ability_name]['element']
  local element_str_sc   = ability_weaknesses_aita[ability_name]['skillchain']

  local display_text = ''
  if settings.show_ability_name then
    display_text = display_text .. ability_name .. ' | '
  end

  display_text = display_text .. apply_text_colour(element_str_nuke, element_str_nuke) .. '/' .. element_str_sc

  return display_text
end


function format_text_gartell(ability_name)
  local element_str = ability_weaknesses_gartell[ability_name]
  local display_text = 'Hands: ' .. apply_text_colour(element_str, element_str)

  return display_text
end


function format_text_standard(actor_name, ability_en)
  local element_str = standard_ability_map[actor_name][ability_en]
  local display_text = apply_text_colour(ability_en, element_str)

  return display_text
end


function display_ui(text_to_display)
  local x_pos = base_x_pos
  local y_pos = ui_config.pos.y
  local padding = ui_config.padding * 2

  local windower_settings = windower.get_windower_settings()

  local use_auto_center = settings.auto_centre
  if settings[player_job] and settings[player_job].auto_centre ~= nil then
    use_auto_center = settings[player_job].auto_centre
  end

  ui_info_box = texts.new(ui_config)
  ui_info_box:text(text_to_display)

  local display_text_length = ux.core.MeasureTextElement(ui_info_box).w + padding

  if use_auto_center then
    x_pos = (windower_settings.ui_x_res - display_text_length) / 2.0

    -- ui_info_box:pos(
    --   (windower_settings.ui_x_res - display_text_length) / 2.0,
    --   y_pos
    -- )
  else

    local x_pos_end = x_pos + display_text_length
    if (x_pos_end > windower_settings.ui_x_res) then
      x_pos = windower_settings.ui_x_res - display_text_length
    end

    -- ui_info_box:pos(
    --   x_pos,
    --   y_pos
    -- )
  end

  ui_info_box:pos(x_pos, y_pos)
  ui_info_box:show()
  ui_display_start = os.clock()
  ui_info_shown = true
end


function show_test_text()
  local colour = aa.objects.get_random_colour()

  if ui_info_box then
    ui_info_box:hide()
    ui_info_shown = false
  end

  local test_text = 'Hello ' .. apply_text_colour('World', colour)
  display_ui(test_text)
end


--[[
  If GearSwap is available, imports it to be able to send a command
  directly to a list called SortieWeakness, which would have a list
  of elements that are a weakness for the specific NM
]]
function send_element_weakness_to_gearswap(element_weakness)
  --  If update_gearswap is set and true, import GearSwap and send the command
  if element_weakness ~= nil and element_weakness ~= '' and settings.update_gearswap then
    windower.send_command(
      'gs c set SortieWeakness ' .. element_weakness
    )
  end
end


--[[
  The equivalent to main(), just don't make it call itself
  It's not supposed to be recursive
]]
function aita_axed(actor_name, ability_en)
  if (aita_map[actor_name]    and ability_weaknesses_aita[ability_en]) or
     (gartell_map[actor_name] and ability_weaknesses_gartell[ability_en]) or
     (standard_ability_map[actor_name] and standard_ability_map[actor_name][ability_en]) then

    -- If the UI is up, hide it
    if ui_info_box then
      ui_info_box:hide()
      ui_info_shown = false
    end

    -- Get the text to display and weakness element
    local text_to_display = ''
    local element_weakness = ''

    if standard_ability_map[actor_name] and standard_ability_map[actor_name][ability_en] then
      text_to_display = format_text_standard(actor_name, ability_en)

    elseif aita_map[actor_name] then
      text_to_display = format_text_aita(ability_en)
      element_weakness = ability_weaknesses_aita[ability_en]['element']

      send_element_weakness_to_gearswap(element_weakness)
    elseif gartell_map[actor_name] then
      text_to_display = format_text_gartell(ability_en)
      element_weakness = ability_weaknesses_gartell[ability_en]

      send_element_weakness_to_gearswap(element_weakness)
    end

    display_ui(text_to_display)
  end
end


--[[
  Windower Registered Events
  - action: for the main trigger
  - prerender: for the timer
  - addon command: for custom commands
]]
windower.register_event('action', function (act)
  -- info here: http://dev.windower.net/doku.php?id=lua:api:events:action
  local actor = windower.ffxi.get_mob_by_id(act.actor_id)
  local self = windower.ffxi.get_player()
  local category = act.category
  local param = act.param
  local targets = act.targets
  local primarytarget = windower.ffxi.get_mob_by_id(targets[1].id)

  -- React to incidents where you're the primary target or any action by an NPC
  if actor and actor.is_npc and actor.name ~= self.name and category == 7 then
    ability = res.monster_abilities[targets[1].actions[1].param] -- .en
    if ability and ability.en then
      aita_axed(actor.name, ability.en)
    end
  end
end)


windower.register_event('prerender', function()
  --  Handle time out of UI
  if settings.duration ~= 0 and ui_info_shown and ui_display_start then
    if os.clock() - ui_display_start > settings.duration then
      ui_info_box:hide()
      ui_info_shown = false
      ui_display_start = nil
    end
  end
end)


--  Handle in-game console commands via AitaAxed or aa
windower.register_event('addon command', function (...)
    local splitup = {...}
    if not splitup[1] then return end -- handles //aa

    for i, v in pairs(splitup) do splitup[i] = windower.from_shift_jis(windower.convert_auto_trans(v)) end

    local cmd = table.remove(splitup,1):lower()
    local cmd_args = {select(2, ...)}

    if cmd == 'help' or cmd == 'h' then
      --  HELP
      local help_with = cmd_args[1]
      if help_with then
        --  Specific function
        print(aa.help.get_help_for(help_with))
      else
        --  Everything
        print(aa.help.show_available_commands())
      end
    elseif aa.help.contains_update_function(cmd) then
      --  Functions with updates
      print(cmd)
    elseif cmd == 'reload' or cmd == 'r' then
      --  Reload AitaAxed
      windower.send_command('lua r aitaaxed')
    elseif cmd == 'unload' or cmd == 'u' then
      --  Unload AitaAxed
      windower.send_command('lua u aitaaxed')
    elseif cmd == 'clear' or cmd == 'c' then
      --  Clear dialogue box
      print("Clearing dialogue box")
      if ui_info_box then
        ui_info_box:hide()
      end
    elseif cmd == 'test' then
      --  Show test text for positioning
      show_test_text()
    -- elseif cmd == 'save' then
    --   if ui_info_box then
    --     if cmd_args[1] and aa.objects.accepted_job_str(cmd_args[1]) then
    --       print('save for ' .. cmd_args[1])
    --       --  Save job-specific
    --     else
    --       print('save global')
    --       config.save(settings)
    --       --  Save global
    --     end
    --   end
    elseif cmd == 'config' then
      local pos_x, pos_y = ui_info_box:pos()
      print(pos_x)
      print(pos_y)
    end
end)


-- function update_settings(settings, name, job)

-- end

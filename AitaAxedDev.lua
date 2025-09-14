--[[

Copyright © 2025, Varrout of Phoenix
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

]]

_addon.name = 'AitaAxedDev'
_addon.author = 'Varrout'
_addon.version = '0.2'  --  Based off of React 1.6.0.0 by Sammeh of Quetzalcoatl
_addon.commands = {'AitaAxedDev', 'aad'}
-- _addon.commands = {'AitaAxed', 'aa'}

-- 0.1 Initial setup: Removed superfluous React functionality: addaction, listaction, removeaction
--                    Removed categories from register_event('action') deicions: 4 (Finish casting spell), 8 (Start casting spell)
-- 0.2 First Iteration: Added ux/core for auto-centering the banner (A bit finnicky at times)
--                      Added support for Leshonn and Gartell hand state
--                      Added display_duration flag for when the banner disappears
-- 0.3 Second Iteraion (Planned): Ability to update settings from in-game
--                                Ability to show all available commands in-game

require('actions')
require('chat')
require('core')  -- Developed by: https://github.com/Kaiconure/
require('logger')
require('pack')
require('sets')
require('strings')
require('tables')
config = require('config')
files = require('files')
res = require('resources')
texts = require('texts')

local defaults = {
  auto_centre = true,
  x_pos = 700,
  y_pos = 110,
  font_size = 50,
  padding = 25,
  --  75-100 Gives a nice transparency level for the background. Higher is darker
  --  75 is similar transparency to the default for EquipViewer
  bg_opacity = 75,
  show_ability_name = true,
  display_duration = 5
}

local settings = config.load(defaults)

local ui_config = {
  pos = {
    x = settings.x_pos,
    y = settings.y_pos
  },
  padding = settings.padding,
  text = {
    font = 'Consolas',    --  Mono-spaced font looks much nicer
    size = settings.font_size,
    stroke = {
      width = 2,
      alpha = 255
    },
    Fonts = {
      'Consolas',
      'Lucida Console',
      -- 'sans-serif'
    },
  },
  bg = {
    --  75-100 Gives a nice transparency level for the background. Higher is darker
    --  75 is similar transparency to the default for EquipViewer
    alpha = settings.bg_opacity,
  },
  flags = {}
}

local ui_info_box
local ui_info_shown = false
local ui_display_start = nil

-- local language = 'english'
-- local area_name = nil
-- local is_sortie_area

local STONE = 'Stone'
local WATER = 'Water'
local AERO = 'Aero'
local WIND = 'Wind'
local FIRE = 'Fire'
local BLIZZARD = 'Blizzard'
local THUNDER = 'Thunder'
local LIGHT = 'Light'
local DARK = 'Dark'

--  Degei & Aita
local ability_weaknesses_aita = {
  ['Icy Grasp']       = {['element'] = FIRE,    ['skillchain'] = LIGHT},
  ['Flaming Kick']    = {['element'] = WATER,   ['skillchain'] = DARK},
  ['Flashflood']      = {['element'] = THUNDER, ['skillchain'] = LIGHT},
  ['Fulminous Smash'] = {['element'] = STONE,   ['skillchain'] = DARK},
  ['Eroding Flesh']   = {['element'] = AERO,    ['skillchain'] = LIGHT},

  --  Testing
  ['Toxic Spit']    = {['element'] = FIRE,    ['skillchain'] = LIGHT},
  ['Cyclotail']     = {['element'] = WATER,   ['skillchain'] = DARK},
  ['Geist Wall']    = {['element'] = THUNDER, ['skillchain'] = LIGHT},
  ['Numbing Noise'] = {['element'] = STONE,   ['skillchain'] = DARK},
  ['Nimble Snap']   = {['element'] = AERO,    ['skillchain'] = LIGHT},
}

--  Leshonn & Gartell
local ability_weaknesses_gartell = {
  --  Thunder-based
  ['Zap']                  = THUNDER,
  ['Concussive Shock']     = THUNDER,
  ['Undulating Shockwave'] = WIND, --  Changes to Wind hands after this move
  --  Wind-based
  ['Chokehold']      = WIND,
  ['Tearing Gust']   = WIND,
  ['Shrieking Gale'] = THUNDER, -- Changes to Thunder hands after this move

  --  Testing
  ['Toxic Spit']    = FIRE,
  ['Cyclotail']     = WATER,
  ['Geist Wall']    = THUNDER,
  ['Numbing Noise'] = STONE,
  ['Nimble Snap']   = WIND,
}

local aita_map = {
  ['Degei']    = ability_weaknesses_aita,
  ['Aita']     = ability_weaknesses_aita,
  ['Apex Eft'] = ability_weaknesses_aita,
}

local gartell_map = {
  ['Leshonn']  = ability_weaknesses_gartell,
  ['Gartell']  = ability_weaknesses_gartell,
}

local text_colour_map = {
  [STONE]    = '(255,255,  0)',
  [WATER]    = '(  0,  0,255)',
  [AERO]     = '(  0,255,128)',
  [WIND]     = '(  0,255,128)',
  [FIRE]     = '(255,  0,  0)',
  [BLIZZARD] = '(  0,255,255)',
  [THUNDER]  = '(255, 85,230)',
  [LIGHT]    = '(255,255,255)',
  [DARK]     = '(255,255,255)',
}


-- function refresh_ffxi_info()
--     local info = windower.ffxi.get_info()
--     for i,v in pairs(info) do
--         if i == 'zone' and res.zones[v] then
--             area_name = res.zones[v][language]
--         end
--     end
-- end


function apply_text_colour(text_to_display, colour_to_use)
  local rbg_colour_code = text_colour_map[colour_to_use]
  return '\\cs' .. rbg_colour_code .. text_to_display .. '\\cr'
end


function format_text_aita(ability_name)
  local element_str_nuke = ability_weaknesses_aita[ability_name]['element']
  local element_str_sc = ability_weaknesses_aita[ability_name]['skillchain']

  local text_raw = ''
  local display_text = ''

  if settings.show_ability_name then
    text_raw = text_raw .. ability_name .. ' | '
    display_text = display_text .. ability_name .. ' | '
  end

  text_raw = text_raw .. element_str_nuke .. '/' .. element_str_sc
  display_text = display_text .. apply_text_colour(element_str_nuke, element_str_nuke) .. '/' .. apply_text_colour(element_str_sc, element_str_sc)

  return text_raw, display_text
end


function format_text_gartell(ability_name)
  local element_str = ability_weaknesses_gartell[ability_name]

  local text_raw = 'Hands: ' .. element_str
  local display_text = 'Hands: ' .. apply_text_colour(element_str, element_str)

  return text_raw, display_text
end


function display_ui(raw_text, text_to_display)
  local windower_settings = windower.get_windower_settings()

  ui_info_box = texts.new(ui_config)

  if settings.auto_centre then
    ui_info_box:text(raw_text)
    local display_text_length = ux.core.MeasureTextElement(ui_info_box).w

    ui_info_box:pos(
      (windower_settings.ui_x_res - display_text_length) / 2.0,
      settings.y_pos
    )
  end

  ui_info_box:text(text_to_display)
  ui_info_box:show()
  ui_display_start = os.clock()
  ui_info_shown = true
end


function reaction(actor, ability)
  windower.add_to_chat(111, actor.name)
  if aita_map[actor.name] or gartell_map[actor.name] then
    if ui_info_box then
      ui_info_box:hide()
      ui_info_shown = false
    end

    local text_to_display = ''
    if aita_map[actor.name] then
      raw_text, text_to_display = format_text_aita(ability.en)
    elseif gartell_map[actor.name] then
      raw_text, text_to_display = format_text_gartell(ability.en)
    end

    -- windower.add_to_chat(123, actor.name .. ' | ' .. ability.en)
    -- local text_to_display = format_display_text(actor.name, ability.en)
    display_ui(raw_text, text_to_display)
  end
end


windower.register_event('action',function (act)
  -- info here: http://dev.windower.net/doku.php?id=lua:api:events:action
  local actor = windower.ffxi.get_mob_by_id(act.actor_id)
  local self = windower.ffxi.get_player()
  local category = act.category
  local param = act.param
  local targets = act.targets
  local primarytarget = windower.ffxi.get_mob_by_id(targets[1].id)
  -- React to incidents where you're the primary target or any action by an NPC
  if actor and (actor.is_npc or primarytarget.name == self.name) and actor.name ~= self.name then
    if category == 7 then -- Begin JA http://dev.windower.net/doku.php?id=lua:api:events:category_07
      if targets[1].actions[1].param ~= 0 and res.monster_abilities[targets[1].actions[1].param] then
        ability = res.monster_abilities[targets[1].actions[1].param] -- .en
        reaction(actor, ability)
      end
    end
  end
end)


windower.register_event('prerender', function()
  --  Handle time out of UI
  if ui_info_shown and ui_display_start then
    if os.clock() - ui_display_start > settings.display_duration then
      ui_info_box:hide()
      ui_info_shown = false
      ui_display_start = nil
    end
  end
end)


--  Handle in-game console commands via AitaAxed or aa
windower.register_event('addon command', function (...)
    -- windower.debug('addon command')
    local splitup = {...}
    if not splitup[1] then return end -- handles //aa

    for i, v in pairs(splitup) do splitup[i] = windower.from_shift_jis(windower.convert_auto_trans(v)) end

    local cmd = table.remove(splitup,1):lower()

    if cmd == 'r' then
      windower.send_command('lua r aitaaxeddev')
      -- windower.send_command('lua r aitaaxed')
    end
end)


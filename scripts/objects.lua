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

aa = aa or {}
aa.objects = aa.objects or {}

local STONE = 'Stone'
local WATER = 'Water'
local AERO = 'Aero'
local WIND = 'Wind'
local FIRE = 'Fire'
local BLIZZARD = 'Blizzard'
local THUNDER = 'Thunder'
local LIGHT = 'Light'
local DARK = 'Dark'

local defaults = {
  duration = nil,
  show_ability_name = nil,
  background = {
    auto_centre = nil,
    opacity = nil,
    padding = nil,
  },
  font = {
    size = nil,
    use_colours = nil,
  },
  pos = {
    x = nil,
    y = nil,
  },
}

local ui_config = {
  bg = {
    alpha = 75,  -- Settings.xml
  },
  flags = {},
  padding = 25,  -- Settings.xml
  pos = {
    x = 800, -- Settings.xml
    y = 100  -- Settings.xml
  },
  text = {
    font = 'Consolas',    --  Mono-spaced font looks much nicer
    Fonts = {
      'Consolas',
      'Lucida Console',
    },
    size = 50,  -- Settings.xml
    stroke = {
      width = 2,
      alpha = 255
    },
  },
}

--  Degei & Aita
local ability_weaknesses_aita = {
  ['Icy Grasp']       = {['element'] = FIRE,    ['skillchain'] = LIGHT},
  ['Flaming Kick']    = {['element'] = WATER,   ['skillchain'] = DARK},
  ['Flashflood']      = {['element'] = THUNDER, ['skillchain'] = LIGHT},
  ['Fulminous Smash'] = {['element'] = STONE,   ['skillchain'] = DARK},
  ['Eroding Flesh']   = {['element'] = AERO,    ['skillchain'] = LIGHT},
}

--  Leshonn & Gartell
local ability_weaknesses_gartell = {
  ['Undulating Shockwave'] = WIND,    -- Changes to Wind hands after this move
  ['Shrieking Gale']       = THUNDER, -- Changes to Thunder hands after this move
}

local aita_map = {
  ['Degei']    = ability_weaknesses_aita,
  ['Aita']     = ability_weaknesses_aita,
}

local gartell_map = {
  ['Leshonn']  = ability_weaknesses_gartell,
  ['Gartell']  = ability_weaknesses_gartell,
}


local element_colour_map = {
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


aa.objects.get_element_colour_map = function()
  return element_colour_map
end


aa.objects.get_settings_defaults = function()
  return defaults
end


aa.objects.get_ui_config = function(settings)
  --  Background opacity override
  if settings.background.opacity ~= nil then
    ui_config.bg.alpha = settings.background.opacity
  end

  --  Padding override
  if settings.background.padding ~= nil then
    ui_config.padding = settings.padding
  end

  --  X Position override
  if settings.pos.x then
    ui_config.pos.x = settings.pos.x
  end

  --  Y position override
  if settings.pos.y then
    ui_config.pos.y = settings.pos.y
  end

  --  Size override
  if settings.font.size then
    ui_config.size = settings.font.size
  end

  return ui_config
end


aa.objects.get_ability_weaknesses_aita = function()
  return ability_weaknesses_aita
end


aa.objects.get_ability_weaknesses_gartell = function()
  return ability_weaknesses_gartell
end


aa.objects.get_aita_map = function()
  return aita_map
end


aa.objects.get_gartell_map = function()
  return gartell_map
end
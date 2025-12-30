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
local FIRE = 'Fire'
local BLIZZARD = 'Blizzard'
local THUNDER = 'Thunder'
local LIGHT = 'Light'
local DARK = 'Dark'

local colours = {
  STONE,
  WATER,
  AERO,
  FIRE,
  BLIZZARD,
  THUNDER,
  LIGHT,
}

local settings_structure = {
  auto_centre = nil,
  display_in_chat = nil,
  duration = nil,
  show_ability_name = nil,
  background = {
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
  update_gearswap = false,
}

local defaults = {
  global = settings_structure,
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

--  Aminon
local ability_weaknesses_aminon = {
  ['Frozen Blood']        = {['element'] = FIRE,      ['skillchain'] = LIGHT},
  ['Demonfire']           = {['element'] = WATER,     ['skillchain'] = DARK},
  ['Torrential Pain']     = {['element'] = THUNDER,   ['skillchain'] = LIGHT},
  ['Ceaseless Surge']     = {['element'] = STONE,     ['skillchain'] = DARK},
  ['Ensepulcher']         = {['element'] = AERO,      ['skillchain'] = LIGHT},
  ['Blast of Reticence']  = {['element'] = BLIZZARD,  ['skillchain'] = DARK},
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
  ['Undulating Shockwave'] = AERO,    -- Changes to Wind hands after this move
  ['Shrieking Gale']       = THUNDER, -- Changes to Thunder hands after this move
}

--  Standard Outputs for "enemy_name: abiity_name"
--  Here the element is used to define the text colour
local ability_notification_standard = {
  ['Esurient Botulus'] = {['Slimy Proposal'] = AERO,},

  --  Example and testing fodder: Mr. Apex Eft
  ['Apex Eft'] = {
    ['Geist Wall']    = AERO,
    ['Nimble Snap']   = THUNDER,
    ['Numbing Noise'] = AERO,
    ['Toxic Spit']    = THUNDER,
    ['Cyclotail']     = AERO,},
}

--  double_weakness_map
local double_weakness_map = {
-- local aita_aminon_map = {
  ['Degei']    = ability_weaknesses_aita,
  ['Aita']     = ability_weaknesses_aita,
  ['Aminon']   = ability_weaknesses_aminon,
}

local gartell_map = {
  ['Leshonn']  = ability_weaknesses_gartell,
  ['Gartell']  = ability_weaknesses_gartell,
}

local element_colour_map = {
  [STONE]    = '(255,255,  0)',   --  Yellow
  [WATER]    = '(  0,  0,255)',   --  Blue
  [AERO]     = '(  0,255,128)',   --  Green
  [FIRE]     = '(255,  0,  0)',   --  Red
  [BLIZZARD] = '(  0,255,255)',   --  Lighter blue
  [THUNDER]  = '(255, 85,230)',   --  Purple/magenta
  [LIGHT]    = '(255,255,255)',   --  White
  [DARK]     = '(255,255,255)',   --  White
}

local job_strings = S{
  'war', 'mnk', 'whm', 'blm', 'rdm', 'thf', 'pld', 'drk', 'bst', 'brd', 'rng',
  'sam', 'nin', 'drg', 'smn', 'blu', 'cor', 'pup', 'dnc', 'sch', 'geo', 'run'
}


aa.objects.get_element_colour_map = function()
  return element_colour_map
end


aa.objects.get_settings_defaults = function(player_job)
  defaults[player_job] = {
    auto_centre = nil,
    pos = {
      x = nil,
      y = nil,
    },
  }
  return defaults
end


aa.objects.get_ui_config = function(settings, player_job)
  --  Padding override
  if settings.padding ~= nil then
    ui_config.padding = settings.padding
  end

    --  Background opacity override
  if settings.background then
    if settings.background.opacity ~= nil then
      ui_config.bg.alpha = settings.background.opacity
    end

  end

  --  X & Y Position overrides
  if settings[player_job].pos then
    if settings[player_job].pos.x then
      ui_config.pos.x = settings[player_job].pos.x
    end

    if settings[player_job].pos.y then
      ui_config.pos.y = settings[player_job].pos.y
    end
  elseif settings.pos then
    if settings.pos.x then
      ui_config.pos.x = settings.pos.x
    end

    if settings.pos.y then
      ui_config.pos.y = settings.pos.y
    end
  end

  --  Size override
  if settings.font then
    if settings.font.size then
      ui_config.text.size = settings.font.size
    end
  end

  return ui_config
end


aa.objects.get_standard_ability_map = function()
  return ability_notification_standard
end


aa.objects.get_double_weakness_map = function()
  return double_weakness_map
end


aa.objects.get_gartell_map = function()
  return gartell_map
end


aa.objects.get_colours = function()
  return colours
end


aa.objects.get_random_colour = function()
  local num_of_colours = #colours
  local random_index = math.random(1, num_of_colours)

  return colours[random_index]
end


aa.objects.accepted_job_str = function(player_job)
  return job_strings:contains(player_job:lower())
end

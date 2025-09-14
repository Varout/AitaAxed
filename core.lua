--[[

Copyright © 2025, Kaiconure
GitHub: https://github.com/Kaiconure/
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
  * Neither the name of ux/core nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Kaiconure BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

]]

local POINTS_TO_PIXELS = 1.333

ux = ux or {}
ux.core = ux.core or {}

ux.core.MeasureTextElement = function(text_element)
    if not text_element then
        return { w = 0, h = 0 }
    end

    return ux.core.MeasureText(text_element:text(), text_element:size(), text_element:font())
end

ux.core.MeasureText = function(text, point_size, font)
    --  Remove colour formatting from text
    local clean_text = text:gsub("//cr", ""):gsub("//cs%(%s*%d+%s*,%s*%d+%s*,%s*%d+%s*%)", "") -- remove //cr, then remove //cs(r,g,b)

    -- Note: Font is not used for now, since we only use fixed-width fonts.
    -- Maybe the Windower devs will fix the extents feature at some point...

    return {
        w = #clean_text * (point_size * POINTS_TO_PIXELS) * 0.55, -- 0.55 is an approximation of average character width relative to point size.
        h = point_size * POINTS_TO_PIXELS * 1.33            -- 1.33 is an approximation of line height relative to point size. This takes into account hanging characters like 'g' and 'y'.
    }
end
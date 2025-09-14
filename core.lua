-- Developed by: https://github.com/Kaiconure/
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
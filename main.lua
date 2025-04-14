local bolt = require("bolt")
bolt.checkversion(1, 0)

local redpixel = bolt.createsurfacefromrgba(1, 1, "\xD0\x10\x10\xFF")
local blackpixel = bolt.createsurfacefromrgba(1, 1, "\x00\x00\x00\xFF")
local eggcenter = bolt.point(0, 65, 0)

local function drawbox (worldpoint, viewmatrix, projmatrix, boxradius, boxthickness)
    local px, py, depth = worldpoint:transform(viewmatrix):transform(projmatrix):aspixels()
    if depth < 0.0 or depth > 1.0 then return end
    local left = px - boxradius
    local top = py - boxradius
    local right = px + boxradius
    local bottom = py + boxradius
    local leftinner = left + boxthickness
    local topinner = top + boxthickness
    local width = right - left
    local height = bottom - top
    local edgew = leftinner - left
    local edgeh = topinner - top
    redpixel:drawtoscreen(0, 0, 1, 1, left, top, width, edgeh) -- top
    redpixel:drawtoscreen(0, 0, 1, 1, left, top, edgew, height) -- left
    redpixel:drawtoscreen(0, 0, 1, 1, right - edgew, top, edgew, height) -- right
    redpixel:drawtoscreen(0, 0, 1, 1, left, bottom - edgeh, width, edgeh) -- bottom
    blackpixel:drawtoscreen(0, 0, 1, 1, left, top, width, 1) -- top
    blackpixel:drawtoscreen(0, 0, 1, 1, left, top, 1, height) -- left
    blackpixel:drawtoscreen(0, 0, 1, 1, right - 1, top, 1, height) -- right
    blackpixel:drawtoscreen(0, 0, 1, 1, left, bottom - 1, width, 1) -- bottom
    blackpixel:drawtoscreen(0, 0, 1, 1, left + edgew, top + edgeh, width - (edgew * 2), 1) -- top
    blackpixel:drawtoscreen(0, 0, 1, 1, left + edgew, top + edgeh, 1, height - (edgeh * 2)) -- left
    blackpixel:drawtoscreen(0, 0, 1, 1, right - (edgew + 1), top + edgeh, 1, height - (edgeh * 2)) -- right
    blackpixel:drawtoscreen(0, 0, 1, 1, left + edgew, bottom - (edgeh + 1), width - (edgew * 2), 1) -- bottom
end

bolt.onrender3d(function (event)
    if event:vertexcount() ~= 768 then return end
    local x, y, z = event:vertexpoint(1):get()
    if x ~= 0 or y ~= 138 or z ~= 1 then return end
    drawbox(eggcenter:transform(event:modelmatrix()), event:viewmatrix(), event:projectionmatrix(), 35, 15)
end)

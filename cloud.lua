-- cloud.lua
-- Draws a cloud using the Love2D graphics api

local cloud = {}

-- Constants
local TWO_PI = 2*math.pi
local DEFAULT_RADIUS = 100
local DEFAULT_COLOR = {r = 255, g = 255, b = 255, a = 0.15}
local DEFAULT_CIRCLE_COUNT = 25

-- The radius of circles used are this times the entire clouds radius
local CIRCLE_RADIUS_RATIO = 0.6

-- Linear radial gradient functions
function cloud.radialGradient(radius, r, g, b, a)
  local data = love.image.newImageData(radius * 2, radius * 2)

  data:mapPixel(function(x, y)
      local dist = cloud.distance(radius, radius, x, y)
      return r, g, b, (dist <= radius and cloud.scale(dist, 0, radius, 255, 0) * a or 0)
  end)

  return love.graphics.newImage(data)
end

function cloud.scale(x, min1, max1, min2, max2)
  return min2 + ((x - min1) / (max1 - min1)) * (max2 - min2)
end

function cloud.distance(x1, y1, x2, y2)
  return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function cloud.getCloud(radius, color, circleCount)
  -- Default values
  local radius = radius or DEFAULT_RADIUS
  local color = color or DEFAULT_COLOR
  local circleCount = circleCount or DEFAULT_CIRCLE_COUNT

  -- Seed math.random
  math.randomseed(os.time())

  -- Calculate radius of circles using the ratio
  local circleRadius = radius * CIRCLE_RADIUS_RATIO

  -- Generate canvas
  local cloudCanvas = love.graphics.newCanvas(radius * 2, radius * 2)
  love.graphics.setCanvas(cloudCanvas)
  love.graphics.setBlendMode("alpha")

  -- Generate circle
  circleImage = cloud.radialGradient(circleRadius, color.r, color.g, color.b, color.a)
  love.graphics.setColor(color.r, color.g, color.b)

  -- Draw circles within cloud area
  for i = 1,circleCount do
    local angle = math.random() * TWO_PI
    local x = radius - circleRadius + math.random() * (radius - circleRadius) * math.cos(angle)
    local y = radius - circleRadius + math.random() * (radius - circleRadius) * math.sin(angle)

    love.graphics.draw(circleImage, x, y)
  end

  -- Reset canvas
  love.graphics.setCanvas()

  -- Return cloud image.
  local cloudImageData = cloudCanvas:newImageData()
  return love.graphics.newImage(cloudImageData)
end

return cloud

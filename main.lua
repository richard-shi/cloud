function love.load()
  c = require("cloud")
  cloud = c.getCloud(100, nil, nil)
end

function love.update(dt)
end

function love.draw()
  love.graphics.draw(cloud, 0, 0)
end



Ground = Class{}

local GROUND_SCROLL_SPEED = 60
local groundImage = love.graphics.newImage('ground.png')
local groundScroll = 0

function Ground:init()
    self.x = -groundScroll
    self.y = VIRTUAL_HEIGHT-16

    self.width = groundImage:getWidth()
    self.height = groundImage:getHeight()
end

function Ground:update(dt)
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
            % VIRTUAL_WIDTH
end

function Ground:render()

    love.graphics.draw(groundImage, self.x , self.y)
end
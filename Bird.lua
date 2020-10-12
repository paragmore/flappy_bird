Bird = Class {}

GRAVITY = 20

count = 0

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 -( self.width / 2)
    self.y = VIRTUAL_HEIGHT /2 -( self.height / 2)

    self.dy = 0
end

function Bird:collides(pipe)

    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + pipe.width then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + pipe.height then
            return true
        end
    end 

    if self.y < 1 then
        return true
    end
    return false
end
    

function Bird:update(dt)

    self.dy = self.dy + GRAVITY*dt

    if love.keyboard.wasPressed('space') then
        self.dy = -5
        sounds['jump']:play()
    end

    self.y = self.y + self.dy
end

function Bird:score(pipe)
    if self.x > pipe.x + pipe.width then
        count = count + 1
        return  count   
    end
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y )
end
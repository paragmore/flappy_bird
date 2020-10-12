--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24
random_spawn = math.random(2,3)

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)

    self.timer = self.timer + dt

    if self.timer > random_spawn then
        
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        table.insert(self.pipePairs, PipePair(y))

        self.timer = 0

        random_spawn = math.random(2,3)
    end

    for k, pair in pairs(self.pipePairs) do
        
        if not pair.scored then
            if self.bird.x > pair.x + PIPE_WIDTH then
                self.score = self.score +1
                sounds['score']:play()
                pair.scored = true
            end
        end
        pair:update(dt)
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    self.bird:update(dt)
    
    
    
    for k , pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()
                gStateMachine:change('score',{score = self.score})
            end
        end
    end

    if self.bird:collides(ground) then
        sounds['explosion']:play()
        sounds['hurt']:play()
        gStateMachine:change('score', {score = self.score})
    end
end
    


function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('High Score: ' .. tostring(HIGH_SCORE), 0, 150, VIRTUAL_WIDTH, 'left')

    self.bird:render()
end
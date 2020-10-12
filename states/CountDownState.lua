CountDownState = Class{__includes = BaseState}

local countDown = 0
local count = 3 

function CountDownState:update(dt)

    countDown = countDown + dt

    if countDown > 0.75 then
        countDown = countDown % 0.75
        count = count - 1
        if count == 0 then
            count = 3
            gStateMachine:change('play')
        end
    end
    
end

function CountDownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(count), 0, 120, VIRTUAL_WIDTH, 'center')
end 

push = require 'push'

Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'
require 'Ground'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/ScoreState'
require 'states/CountDownState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


local background = love.graphics.newImage('background.png')
local backgroundScroll = 0



local BACKGROUND_SCROLL_SPEED = 30


local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()

ground = Ground()

local pipePairs = {}



local lastY = -PIPE_HEIGHT + math.random(80) + 20



local scrolling = true  

local points = 0 


function love.load()
    love.graphics.setDefaultFilter('nearest' , 'nearest' )

    love.window.setTitle('Flappy Bird')

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('font.ttf', 56)
    love.graphics.setFont(flappyFont)

    math.randomseed(os.time())

    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),

        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }

    -- kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()
    

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync= true,
        fullscreen = false,
        resizable = true   
    })

    gStateMachine = StateMachine{
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countDown'] = function() return CountDownState() end 
    }
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w,h)
end

function love.keypressed(key)
    
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
         % BACKGROUND_LOOPING_POINT

    ground:update(dt)

    
    gStateMachine:update(dt)
        

    love.keyboard.keysPressed = {}

end

function love.draw()
    push:start()
    
    love.graphics.draw(background, -backgroundScroll, 0)
    
    for k, pair in pairs(pipePairs) do
        pair:render()
    end

    gStateMachine:render()

    ground:render()
    
    push:finish()
end
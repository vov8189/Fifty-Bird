PlayState = Class{__includes = BaseState}

PIPE_SPEED = 70
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

pause = love.graphics.newImage('pause.png')
gold = love.graphics.newImage('gold.png')
silver = love.graphics.newImage('silver.png')
bronze = love.graphics.newImage('bronze.png')

function PlayState:init()
  self.bird = Bird()
  self.spawnTime = 0
  self.lastY = -PIPE_HEIGHT + math.random(80) + 20
  self.pipePairs = {}
  self.score = 0
  self.pause = false
end

function PlayState:update(dt)
  if love.keyboard.wasPressed('p') then

    if self.pause then
      self.pause = false
      scrolling = true
    else
      self.pause = true
      scrolling = false
    end
    sounds['pause']:play()
  end

  if not self.pause then
    self.spawnTime = self.spawnTime + dt
    local rand = math.random(1, 25)
    if self.spawnTime > rand then
    local y = math.max(-PIPE_HEIGHT + 10,
      math.min(self.lastY + math.random(-40, 40), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))

      table.insert(self.pipePairs, PipePair(y))
      self.spawnTime = 0
      self.lastY = y
    end

    self.bird:update(dt)

    for k,pair in pairs(self.pipePairs) do
      -- body...
      pair:update(dt)

      for l, pipe in pairs(pair.pipes) do
        -- body...
        if self.bird:collides(pipe) then
          sounds['explosion']:play()
          sounds['hurt']:play()
          gStateMachine:change('score', { score = self.score})
        end
      end

      if not pair.scored then
        if pair.x + PIPE_WIDTH < self.bird.x then
          self.score = self.score + 1
          pair.scored = true
          sounds['score']:play()
        end
      end
    end

    for k,pair in pairs(self.pipePairs) do
      -- body...
      if pair.remove then
        table.remove(self.pipePairs, k)
      end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
      sounds['explosion']:play()
      sounds['hurt']:play()
      gStateMachine:change('score', { score = self.score})
    end
  end
end

function PlayState:render()
  for k,pair in pairs(self.pipePairs) do
    pair:render()
  end

  love.graphics.setFont(flappyFont)
  love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
  if self.score < 2 then
    love.graphics.draw(bronze, 130, 4)
  end
  if self.score > 1 and self.score < 3 then
    love.graphics.draw(silver, 130, 4)
  end
  if self.score > 2 then
    love.graphics.draw(gold, 130, 4)
  end
  self.bird:render()

  if self.pause then
    love.graphics.draw(pause, VIRTUAL_WIDTH / 2 - (pause:getWidth() / 2), VIRTUAL_HEIGHT / 2 - (pause:getHeight() / 2))
  end

end

function PlayState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end

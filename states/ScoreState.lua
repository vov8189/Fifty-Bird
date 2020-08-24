ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
  self.score = params.score
end

function ScoreState:update(dt)
 if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
   gStateMachine:change('countdown')
 end
end

function ScoreState:render()
  -- simply render the score to the middle of the screen
  love.graphics.setFont(flappyFont)
  love.graphics.printf('You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(mediumFont)
  love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

  if self.score < 2 then
    love.graphics.draw(bronze, VIRTUAL_WIDTH / 2 - (bronze:getWidth() / 2), 120)
  end
  if self.score > 1 and self.score < 3 then
    love.graphics.draw(silver, VIRTUAL_WIDTH / 2 - (bronze:getWidth() / 2), 120)
  end
  if self.score > 2 then
    love.graphics.draw(gold, VIRTUAL_WIDTH / 2 - (bronze:getWidth() / 2), 120)
  end

  love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end

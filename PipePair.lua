require 'Pipe'
PipePair = Class{}

function PipePair:init(y)
  self.y = y
  self.x = VIRTUAL_WIDTH + 32
  self.gap_height = math.random(90, 120)
  self.pipes = {
    ['upper'] = Pipe('top', self.y),
    ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + self.gap_height)
  }

  self.remove = false
  self.scored = false
end

function PipePair:update(dt)
  if self.x > -PIPE_WIDTH then
    self.x = self.x - PIPE_SPEED * dt
    self.pipes['lower'].x = self.x
    self.pipes['upper'].x = self.x
  else
    self.remove = true
  end
end

function PipePair:render()
  for key,pipe in pairs(self.pipes) do
    pipe:render()
  end
end

require "Elements/elementBase"

--[[ needs "width" "height" in pixels
     "x" and "y" are centered
 ]]--


ElementRectangle = ElementBase:new();

-- remember this subclass for the editor
ElementBase.elementClasses.ElementRectangle = ElementRectangle;


function ElementRectangle:draw()
  self:setDrawColor();
  love.graphics.rectangle("fill", self.x - self.width/2, self.y -self.height/2, self.width, self.height);
  
  if (self.text) then
    love.graphics.setColor(0,255,255);
    love.graphics.printf(self.text, self.x -self.width/2, self.y, self.width, "center");
  end

end

function ElementRectangle:pointIsInside(x,y)
  self:setDefaults();

  if (x ~= x) then return false end
  if (y ~= y) then return false end
    

  local xMin = self.x - self.width / 2
  local xMax = self.x + self.width / 2
  local yMin = self.y - self.height / 2
  local yMax = self.y + self.height / 2

  if (x < xMin) then return false end
  if (x > xMax) then return false end
  if (y < yMin) then return false end
  if (y > yMax) then return false end
  
  return true;
end

function ElementRectangle:setDefaults()
  if not self.width then self.width = 30 end
  if not self.height then self.height = 60 end
  if not self.color then self.color = {r = 0, g = 0, b = 255} end
  self.class = "ElementRectangle"

end


function ElementRectangle:modifyBoid(i, boidData, addIfPossible)
  self:setDefaults()

  local boidX = boidData.positions[i][1]
  local boidY = boidData.positions[i][2]

  if self:pointIsInside(boidX, boidY) then 


    local xMin = self.x - self.width / 2
    local xMax = self.x + self.width / 2
    local yMin = self.y - self.height / 2
    local yMax = self.y + self.height / 2

    local xMinDelta = math.abs(xMin - boidX)
    local yMinDelta = math.abs(yMin - boidY)
    local xMaxDelta = math.abs(xMax - boidX)
    local yMaxDelta = math.abs(yMax - boidY)

    local boidVX = boidData.velocities[i][1]
    local boidVY = boidData.velocities[i][2]

    if xMinDelta < yMinDelta and xMinDelta < xMaxDelta and xMinDelta < yMaxDelta then
      boidX = xMin
      boidVX = -boidVX
    elseif yMinDelta < xMinDelta and yMinDelta < xMaxDelta and yMinDelta < yMaxDelta then
      boidY = yMin
      boidVY = -boidVY
    elseif xMaxDelta < yMinDelta and xMaxDelta < xMinDelta and xMaxDelta < yMaxDelta then
      boidX = xMax
      boidVX = -boidVX
    else
      --yMaxDelta
      boidY = yMax
      boidVY = -boidVY
    end

    boidData.positions[i][1] = boidX
    boidData.positions[i][2] = boidY

    boidData.velocities[i][1] = boidVX
    boidData.velocities[i][2] = boidVY
    
    self.boidsUpdatedThisFrame = self.boidsUpdatedThisFrame + 1
  end
end



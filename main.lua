-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

local physics=require ("physics")
physics.start()
physics.setGravity( 0, 9.8 * 2)
physics.start()


-- Display a background image
local background = display.newImage("images/background.png");
background.anchorX=0;
background.anchorY=0;

local totalFruits = {}
local fruitTimer

local minVelocityY = 850
local maxVelocityY = 1100

local minVelocityX = -200
local maxVelocityX = 200

local minAngularVelocity = 100
local maxAngularVelocity = 200

local timeInterval = 1000

local function startGame()

	local fruits={}
	watermelon="images/watermelon.png"	
	strawberry="images/strawberry.png"
	bomb="images/bomb.png"
	table.insert(totalFruits,watermelon)
	table.insert(totalFruits,strawberry)
	table.insert(totalFruits,bomb)

	local fruitProp = totalFruits[math.random(1, #totalFruits)]
	local fruit = display.newImage(fruitProp)
	fruit.x=display.contentWidth/2
	fruit.y=display.contentHeight/2+fruit.height*2
	

	physics.addBody(fruit,"dynamic",{density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 2, maskBits = 1}})
	-- Apply linear velocity
	local yVelocity = getRandomValue(minVelocityY, maxVelocityY) * -1 -- Need to multiply by -1 so the fruit shoots up
	local xVelocity = getRandomValue(minVelocityX, maxVelocityX)
	fruit:setLinearVelocity(xVelocity,  yVelocity)

	--the speed and direction the fruit rotates
	local minAngularVelocity = getRandomValue(minAngularVelocity, maxAngularVelocity)
	local direction = (math.random() < .5) and -1 or 1
	minAngularVelocity = minAngularVelocity * direction
	fruit.angularVelocity = minAngularVelocity

end

	---------------------------------------------------------------------------
	-- 1pixel rect that will be the colliding object for slashing --
	---------------------------------------------------------------------------
	local touchrect = display.newRect(-1, -1, 1, 1)
	physics.addBody( touchrect, {isSensor = true} )
	touchrect.isBullet = true
	touchrect:setFillColor(0, 0, 0, 0)

	local touchEnd = 0

	---------------------------------------------------------------------------
	-- border edges so the rect can collide and reset when out of screen --
	---------------------------------------------------------------------------

	--The top edge
	local borderTop = display.newRect( 0, -50, display.contentWidth, 10 )
	physics.addBody( borderTop, "static", borderBody )
	borderTop.name = "edge"
	borderTop:setFillColor(255, 0, 0, 250)

	--The bottom edge
	local borderBottom = display.newRect( 0, display.contentHeight+50, display.contentWidth, 10 )
	physics.addBody( borderBottom, "static",borderBody )
	borderBottom.name = "edge"
	borderBottom:setFillColor(0, 255, 0, 250)

	--The left edge
	local borderLeft = display.newRect( -50, 0, 10, display.contentHeight )
	physics.addBody( borderLeft, "static", borderBody )
	borderLeft.name = "edge"
	borderLeft:setFillColor(0, 0, 255, 250)

	--The right edge
	local borderRight = display.newRect( display.contentWidth+50, 0, 10, display.contentHeight )
	physics.addBody( borderRight, "static", borderBody )
	borderRight.name = "edge"
	borderRight:setFillColor(255, 0, 255, 250)


local function moveRect()

	touchrect.x = -100
	touchrect.y = -100

	physics.setGravity( 0, 0 )

	fruit.x=display.contentWidth/2
	fruit.y=display.contentHeight/2+fruit.height*2

	transition.to(fruit, {time = 200, alpha = 1})

end

---------------------------------------------------------------------------
-- function and values for drawing slashing line --
---------------------------------------------------------------------------

local maxPoints = 5
local lineThickness = 7
local endPoints = {}

local function movePoint(event)

	touchrect.x = event.x
	touchrect.y = event.y

	        -- Insert a new point into the front of the array
        table.insert(endPoints, 1, {x = event.x, y = event.y, line= nil}) 
 
        -- Remove any excessed points
        if(#endPoints > maxPoints) then 
                table.remove(endPoints)
        end
 
        for i,v in ipairs(endPoints) do
                local line = display.newLine(v.x, v.y, event.x, event.y)
      		  line.width = lineThickness
                transition.to(line, { alpha = 0, width = 0, onComplete = function(event) line:removeSelf() end})                
        end
 
	if event.phase == "ended" then
		touchEnd = 1
		while(#endPoints > 0) do
			table.remove(endPoints)
		end

	elseif event.phase == "began" then
		touchEnd = 0
	end

end
Runtime:addEventListener("touch", movePoint)

fruitTimer = timer.performWithDelay(timeInterval, startGame,0)

-- Return a random value between 'min' and 'max'
function getRandomValue(min, max)
	return min + math.abs(((max - min) * math.random()))
end



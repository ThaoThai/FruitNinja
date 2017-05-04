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

fruitTimer = timer.performWithDelay(timeInterval, startGame,0)

-- Return a random value between 'min' and 'max'
function getRandomValue(min, max)
	return min + math.abs(((max - min) * math.random()))
end



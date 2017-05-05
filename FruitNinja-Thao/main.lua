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
local background = display.newImageRect("images/background.png",1024, 1024);
background.anchorX=0;
background.anchorY=0;

local totalFruits = {}

local veggieTimer

local minGushVelocityX = -350
local maxGushVelocityX = 350
local minGushVelocityY = -350
local maxGushVelocityY = 350

local minVelocityY = 850
local maxVelocityY = 1100

local minVelocityX = -200
local maxVelocityX = 200

local minAngularVelocity = 100
local maxAngularVelocity = 200

local timeInterval = 1000

local gushProp = {density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 4, maskBits = 8} } 

local function blackscreen(bomb)
    local group =display.newGroup()
    gameOver=true
    local x, y = bomb:localToContent(0,0)
    display.remove(background)
    local back = display.newRect( 0,0, display.contentWidth, display.contentHeight )
	back:setFillColor(0,0,0, 255 * .1)
    group:insert(back)
    local explode = display.newImageRect("images/explode.png",520,470)
    group:insert(explode)
    explode.x = display.contentWidth/2
    explode.y = display.contentHeight/3 + 50
    
    local replayButton = display.newImage("images/replayButton.png")
	group:insert(replayButton)
	replayButton.x = display.contentWidth / 2
	replayButton.y = explode.y + explode.height / 2 + replayButton.height / 2
	
end

local function spawnBomb()
    local bomb = display.newImageRect("images/bomb.png",130,130)
    local explode = display.newImageRect("images/explode.png",130,130)
    bomb:toFront();
    bomb.x=display.contentWidth/2
	bomb.y=display.contentHeight/0.8+bomb.height*0.5
    explode.x=display.contentWidth/2
	explode.y=display.contentHeight/0.8+explode.height*0.5
    local xbombVelocity=getRandomValue(minVelocityX, maxVelocityX)
    local ybombVelocity= getRandomValue(minVelocityY, maxVelocityY) * -1
    physics.addBody(bomb,"dynamic",{density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 2, maskBits = 1}})
    physics.addBody(explode,"dynamic",{density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 2, maskBits = 1}})
    bomb:setLinearVelocity(xbombVelocity, ybombVelocity)
    explode:setLinearVelocity(xbombVelocity, ybombVelocity)
    explode.isVisible=false;
    function gameover(event)
        local swipeLength = math.abs(event.x - event.xStart) 
        print(event.phase, swipeLength)
        local t = event.target
        local phase = event.phase
        if phase == "began" then
            return true
        elseif "moved" == phase then
            if swipeLength > 10 then
                blackscreen(bomb)
                display.remove(bomb)
            else
                print("Shorter than 5")
            end
        elseif "ended" == phase or "cancelled" == phase then
            if event.xStart > event.x and swipeLength > 50 then 

            elseif event.xStart < event.x and swipeLength > 50 then 

            end 
        end
    end
    bomb:addEventListener("touch",gameover)
end
local delay =math.random(2000, 5000)

timer.performWithDelay( delay, spawnBomb, 0)

--local function showImage(image,x,y)
--    local image = display.newImageRect(image,120,120)
--    image.x = x
--    image.y = y
--    local fadeTransition = transition.to( image, { time=1000, alpha=0.0,
--    onComplete=function( object )
--       display.remove(image)
--    end
--})
--end
--
--local function changeImage(veggiewhole) 
--    local x, y = veggiewhole:localToContent(0,0)
--    timer.performWithDelay( 0, showImage("images/poof-1.png",x,y), 0)
--    timer.performWithDelay( 4000, showImage("images/poof-2.png",x,y), 0)
----    timer.performWithDelay( 20000, showImage("images/poof-3.png",x,y), 0)
--end 
    

local function startGame()
    local leftWall = display.newRect (0, 0, 1, display.contentHeight);
    leftWall.anchorX=0.0;
    leftWall.anchorY=0.0;
    local rightWall = display.newRect (display.contentWidth, 0, 1, display.contentHeight);
    rightWall.anchorX=1.0;
    rightWall.anchorY=0.0;
    local topWall = display.newRect (0, 0, display.contentWidth, 1)   
    topWall.anchorX=0.0;
    topWall.anchorY=1.0;

    -- Add physics to the walls. They will not move so they will be "static"
    physics.addBody (leftWall, "static",  { bounce = 0.1 } );
    physics.addBody (rightWall, "static", { bounce = 0.1 } );
    physics.addBody (topWall, "static", { bounce = 0.1} );
    

    local tomato = {}
	tomato.whole = "images/tomato.png"
	tomato.cut = "images/cut-tomato-01.png"
    local pepper ={}
    pepper.whole = "images/pepper.png"
	pepper.cut="images/cut-pepper-01.png"
    local poof=display.newImageRect("images/poof.png",120,120)
	table.insert(totalFruits,tomato)
	table.insert(totalFruits,pepper)

	local veggieProp = totalFruits[math.random(1, #totalFruits)]
	local veggiewhole = display.newImageRect(veggieProp.whole,120,120)
    local veggiecut = display.newImageRect(veggieProp.cut,220,165)
	veggiewhole.x=display.contentWidth/2
	veggiewhole.y=display.contentHeight/0.8+veggiewhole.height*0.5
    veggiecut.x=display.contentWidth/2
	veggiecut.y=display.contentHeight/0.8+veggiecut.height*0.5

--    bomb.x=display.contentWidth/2
--	bomb.y=display.contentHeight/0.8+poof.height*0.5
    
	physics.addBody(veggiewhole,"dynamic",{density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 2, maskBits = 1}})
    physics.addBody(veggiecut,"dynamic",{density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 2, maskBits = 1}})
--    physics.addBody(bomb,"dynamic",{density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 2, maskBits = 1}})
    poof.isVisible=false;
    veggiecut.isVisible=false;
	-- Apply linear velocity
	local yVelocity = getRandomValue(minVelocityY, maxVelocityY) * -1 -- Need to multiply by -1 so the veggie shoots up
    local ybombVelocity= getRandomValue(minVelocityY, maxVelocityY) * -1
	local xVelocity = getRandomValue(minVelocityX, maxVelocityX)
    local xbombVelocity=getRandomValue(minVelocityX, maxVelocityX)
	veggiewhole:setLinearVelocity(xVelocity,  yVelocity)
    veggiecut:setLinearVelocity(xVelocity,  yVelocity)
	local minAngularVelocity = getRandomValue(minAngularVelocity, maxAngularVelocity)
	local direction = (math.random() < .5) and -1 or 1
	minAngularVelocity = minAngularVelocity * direction

        
    
    function startDrag(event)
        local swipeLength = math.abs(event.x - event.xStart) 
        print(event.phase, swipeLength)
        local t = event.target
        local phase = event.phase
        if phase == "began" then
            return true
        elseif "moved" == phase then
            if swipeLength > 10 then
                veggiecut.isVisible=true
                veggiewhole.isVisible=false
                local splash = display.newImageRect("images/splash.png",140,140)
                local xAbsPos, yAbsPos = veggiewhole:localToContent(0,0)
                veggiewhole:toFront()
                veggiecut:toFront()
                createGush(veggiewhole)

                splash.x = xAbsPos
                splash.y = yAbsPos
                splash.apha=0.5
                local fadeTransition = transition.to( splash, { time=3000, alpha=0.0,
                    onComplete=function( object )
                       display.remove(splash)
            end
})
            else
                print("Shorter than 5")
            end
        elseif "ended" == phase or "cancelled" == phase then
            if event.xStart > event.x and swipeLength > 50 then 

            elseif event.xStart < event.x and swipeLength > 50 then 

            end 
        end
    end
    
veggiewhole:addEventListener("touch",startDrag)

local numOfGushParticles =10
local minGushRadius =5
local maxGushRadius=50
function createGush(veggiewhole)

	local i
	for  i = 0, numOfGushParticles do
		local gush = display.newCircle( veggiewhole.x, veggiewhole.y, math.random(minGushRadius, maxGushRadius) )
		gush:setFillColor(255, 0, 0, 255)
		
		gushProp.radius = gush.width / 2
		physics.addBody(gush, "dynamic", gushProp)

		local xVelocity = math.random(minGushVelocityX, maxGushVelocityX)
		local yVelocity = math.random(minGushVelocityY, maxGushVelocityY)

		gush:setLinearVelocity(xVelocity, yVelocity)
		gush:toFront()
		transition.to(gush, {time = gushFadeTime, delay = gushFadeDelay, width = 0, height = 0, alpha = 0, onComplete = function(event) gush:removeSelf() end})		
	end

end
end 

veggieTimer = timer.performWithDelay(timeInterval, startGame,0)
 
-- Return a random value between 'min' and 'max'
function getRandomValue(min, max)
	return min + math.abs(((max - min) * math.random()))
end


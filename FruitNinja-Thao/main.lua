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


-- Display a background image
local background = display.newImageRect("images/background.png",1024, 1024);


background.anchorX=0;
background.anchorY=0;

halfW = display.contentWidth * 0.5
halfH = display.contentHeight * 0.5


local totalFruits = {}
local score =0
local lastScore=0
local keeping_score = true
local PointName = display.newText("POINT:  ", halfW+145,140)
local scoreText = display.newText(score, halfW+200,140)
local highScore = display.newText("HIGH SCORE:      ", halfW+350,140)
local highScoreText = display.newText(lastScore, halfW+430,140)

local Gamegroup;


local veggieTimer
local bombTimer

local delay =math.random(2000, 5000)

local minGushVelocityX = -550
local maxGushVelocityX = 550
local minGushVelocityY = -550
local maxGushVelocityY = 550

local minVelocityY = 850
local maxVelocityY = 1100

local minVelocityX = -200
local maxVelocityX = 200

local minAngularVelocity = 100
local maxAngularVelocity = 200

local timeInterval = 1000
local explosion = audio.loadSound("explosion.wav")
local chopped1 = audio.loadSound("chopped1.wav")
local music = audio.loadStream("music.mp3");

local gushProp = {density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 4, maskBits = 8} } 




local function blackscreen(bomb,Gamegroup)
    local group = display.newGroup()
    Gamegroup:removeSelf()
    Gamegroup = nil
    display.remove(bomb)
    gameOver=true
    local x, y = bomb:localToContent(0,0)
    background.isVisible=false
    local back = display.newRect( 0,0, 2048, 2048 )
    back:setFillColor(0,0,0, 255 * .1)
    group:insert(back)
    local explode = display.newImageRect("images/explode.png",500,320)
    audio.play(explosion)
    group:insert(explode)
    local yourscoreText = display.newText("YOUR SCORE IS:  ", halfW, explode.y + explode.height / 2 + 340)
    local yourscore = display.newText(score, halfW+150, explode.y + explode.height / 2 +340)
    group:insert(yourscoreText)
    group:insert(yourscore)
    explode.x = display.contentWidth/2
    explode.y = display.contentHeight/3 + 50
    local replayButton = display.newImageRect("images/replayButton.png",150,50)
    group:insert(replayButton)
    replayButton.x = display.contentWidth / 2
    replayButton.y = explode.y + explode.height / 2 + replayButton.height / 2 + 120  
    function replayButton:tap (event)                        
        group:removeSelf()
        background.isVisible=true        
        -- local scoreText = display.newText(score, halfW+300,170)
        -- restartStopScore()
        startGame()
        veggieTimer = timer.performWithDelay(timeInterval, startGame,0)
        bombTimer = timer.performWithDelay( delay, spawnBomb, 0)
        score=0
        scoreText.text=score
        print("tap tap")
    end
    if lastScore<score then
    lastScore=score 
    highScoreText.text=lastScore
    else
    lastScore=lastScore
    highScoreText.text=lastScore
    end      
    replayButton:addEventListener("tap",replayButton)


end

function spawnBomb()
    local bomb = display.newImageRect("images/bomb.png",130,130)
    local explode = display.newImageRect("images/explode.png",130,130)
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
                timer.cancel(veggieTimer)
                timer.cancel(bombTimer)
                blackscreen(bomb,Gamegroup)
            else        
                print("Shorter than 5")
            end
        elseif "ended" == phase then        
        end
    end
    bomb:addEventListener("touch",gameover)
end

-- bombTimer = timer.performWithDelay( delay, spawnBomb, 0)



function startGame()    
    audio.play(music, {loops =- 1});
    Gamegroup = display.newGroup()
    local leftWall = display.newRect (0, 0, 1, display.contentHeight);
    leftWall.anchorX=0.0;
    leftWall.anchorY=0.0;
    local rightWall = display.newRect (display.contentWidth, 0, 1, display.contentHeight);
    rightWall.anchorX=1.0;
    rightWall.anchorY=0.0;
    local ceiling = display.newRect (0, 0, display.contentWidth, 1);
    ceiling.anchorX=0.0;
    ceiling.anchorY=0.0;
    -- Add physics to the walls. They will not move so they will be "static"
    physics.addBody (leftWall, "static",  { bounce = 0.1 } );
    physics.addBody (rightWall, "static", { bounce = 0.1 } );
    physics.addBody (ceiling, "static",   { bounce = 0.1 } );
    
    local tomato = {}
    tomato.whole = "images/tomato.png"
    tomato.cut = "images/cut-tomato.png"
    local pepper ={}
    pepper.whole = "images/gpepper.png"
    pepper.cut="images/cut-gpepper.png"
    
    local red ={}
    red.whole = "images/rpepper.png"
    red.cut="images/cut-rpepper.png"
    
    
    table.insert(totalFruits,tomato)
    table.insert(totalFruits,pepper)
    table.insert(totalFruits,red)
    local veggieProp = totalFruits[math.random(1, #totalFruits)]
    local veggiewhole
    local veggiecut
    if (veggieProp == cucumber) then
        veggiewhole = display.newImageRect(veggieProp.whole,180,80)
        veggiecut = display.newImageRect(veggieProp.cut,180,80)   
        
    else 
        veggiewhole = display.newImageRect(veggieProp.whole,120,120)
        veggiecut = display.newImageRect(veggieProp.cut,120,120)
    end 
    veggiewhole.x=display.contentWidth/2
    veggiewhole.y=display.contentHeight/0.8+veggiewhole.height*0.5
    veggiecut.x=display.contentWidth/2
    veggiecut.y=display.contentHeight/0.8+veggiecut.height*0.5


    
    physics.addBody(veggiewhole,"dynamic",{density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 2, maskBits = 1}})
    physics.addBody(veggiecut,"dynamic",{density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 2, maskBits = 1}})

    veggiecut.isVisible=false;
    Gamegroup:insert(veggiewhole)
    Gamegroup:insert(veggiecut)

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
    

    ---------------------------------------------------------------------------
    -- 1pixel rect that will be the colliding object for slashing --
    ---------------------------------------------------------------------------
    local touchrect = display.newRect(-1, -1, 1, 1)
    physics.addBody( touchrect, {isSensor = true} )
    touchrect.isBullet = true
    touchrect:setFillColor(0, 0, 0, 0)

    local touchEnd = 0
    
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
              line.strokeWidth = lineThickness
                transition.to(line, { alpha = 0, strokeWidth = 0, onComplete = function(event) line:removeSelf() line=nil end})                
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
    
    
    function startDrag(event)
        local swipeLength = event.x - event.xStart
        local vegVelX, vegVelY = veggiewhole:getLinearVelocity()
        print(event.phase, swipeLength)
        local t = event.target
        local phase = event.phase
        local velocity = math.sqrt(math.pow(vegVelX, 2) + math.pow(vegVelY, 2))
        local xDirection = swipeLength < 0 and -1 or 1
        if phase == "began" then            
            return true
        else if "moved" == phase then
            if math.abs(swipeLength) > 10 then
                veggiecut.isVisible=true
                local velocityX = math.cos( (math.pi /  180)) * velocity * xDirection
                local velocityY = math.sin((math.pi /  180)) * velocity
                veggiecut:setLinearVelocity(velocityX, velocityY)
                audio.play(chopped1)
                if keeping_score then
                    score = score + 1                                
                    scoreText.text =score
                end
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
                return true 

            end 
        end
    end
    
veggiewhole:addEventListener("touch",startDrag)

local numGush =10
local minRadius =15
local maxRadius=60
    
function createGush(veggiewhole)

    local i
    for  i = 0, numGush do
        local gush = display.newCircle( veggiewhole.x, veggiewhole.y, math.random(minRadius, maxRadius) )
        gush:setFillColor(255, 0, 0, 255)
        gushProp.radius = gush.width / 2
        physics.addBody(gush, "dynamic", gushProp)
        
        local xVelocity = math.random(minGushVelocityX, maxGushVelocityX)
        local yVelocity = math.random(minGushVelocityY, maxGushVelocityY)

        gush:setLinearVelocity(xVelocity, yVelocity)
        gush:toFront()
        transition.to(gush, {time = gushFadeTime, delay = gushFadeDelay, width = 0, height = 0, alpha = 0, onComplete = function(event) gush:removeSelf() gush=nil end})        
            
    end

end
end 
local group = display.newGroup()
    
    -- Dim the background with a transperent square
    local back = display.newRect( 0,0, display.contentWidth*2, display.contentHeight*2 )
    back:setFillColor(0.3, 0.5, 0, 0.5)
    group:insert(back)
    
    local titleLogo = display.newText("Fruit Ninja",0,0,native.systemFont,80)
    titleLogo.x = display.contentWidth * 0.5
    titleLogo.y = 225
    titleLogo:setFillColor( 255, 255, 255)
    local startButton = display.newImageRect("images/playButton.png",250,108)
    startButton.x = display.contentWidth / 2
    startButton.y = display.contentHeight / 2
    group:insert(startButton)

    function startButton:tap (event)                        
        group:removeSelf()
        titleLogo:removeSelf() 
        -- titleLogo = nil     
        -- print("tap tap")
        veggieTimer = timer.performWithDelay(timeInterval, startGame,0)
        bombTimer = timer.performWithDelay( delay, spawnBomb, 0)
    end
     startButton:addEventListener("tap",startButton) 


function restartStopScore()
    keeping_score = true
    score=0
        end

 function restartContinueScore()
    keeping_score = true
end
-- Return a random value between 'min' and 'max'
function getRandomValue(min, max)
    return min + math.abs(((max - min) * math.random()))
end


-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local centerX = display.contentCenterX
local centerY = display.contentCenterY


function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- create a grey rectangle as the backdrop
	local background = display.newImageRect( "img/cenario_fundo.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	--background.rotation = 18
	background.x, background.y,background.z = 0,0
	
	
	local borderLeft = display.newRect( 0, centerY, 2,screenH )
	borderLeft:setFillColor( 0,0,0,0)
	physics.addBody(borderLeft,"static" )
	borderLeft.myName = "borderLeft"
	
	local borderTop = display.newRect( centerX, 0, screenW,2)
	borderTop:setFillColor( 0,0,0,0 )
	physics.addBody(borderTop,"static" )
	
	local borderBottom = display.newRect( centerX,screenH,screenW,2)
	borderBottom:setFillColor( 0,0,0,0 )
	physics.addBody(borderBottom,"static" )

	
	-- make a crate (off-screen), position it, and rotate slightly
	--local crate = display.newImageRect( "crate.png", 90, 90 )
	--crate.x, crate.y = 160, -100
	--crate.rotation = 15
	
	-- add physics to the crate
	--physics.addBody( crate, { density=1.0, friction=0.3, bounce=0.3 } )
	
	
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert(borderLeft)
	sceneGroup:insert(borderTop)
	sceneGroup:insert(borderBottom)
	
	function gerar()
		
		local y = math.random(0,screenH)
		
		local mosquito = display.newImageRect("img/mosquitodengue.jpg", 70, 50)
		mosquito.x = screenW
		mosquito.y = y
		physics.addBody(mosquito, "static")
		mosquito.myName = "mosquito"
		sceneGroup:insert(mosquito)
		transition.moveTo( mosquito,{time=3000, x = borderLeft.x, y= borderLeft.y} )

		
		timer.performWithDelay(2000,gerar,2) 
	end
	
	gerar()
end


 --Movimentos dos player
 
local screen_tap = function( event )
		player:setLinearVelocity( 0, 0)
		if event.x < centerX then
			player.x = player.x - 80

			
		else
			player.x = player.x + 80
		end
		
	end

Runtime:addEventListener( 'tap', screen_tap )


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.level1
	
	package.loaded[physics] = nil
	physics = nil
end

function onGroundCollision(event)
	if ( event.phase == "began" ) then 
		if (event.object1.myName == "mosquito" and event.object2.myName=="borderLeft") then			
	    	local lose = display.newText("Game Over", centerX , centerY,  native.systemFont, 16)
			lose:setFillColor( 1, 0, 0 )
			sceneGroup:insert(lose);
		end
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
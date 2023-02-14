function love.load()
	snake= {}
	snakeParts = {
		{x = 3, y = 1},
		{x = 2, y = 1},
		{x = 1, y = 1}
	}

	apple = love.audio.newSource("apple.mp3", "static")
	start = love.audio.newSource("start.mp3", "static")
	music = love.audio.newSource("music.mp3", "stream")
	loser = love.audio.newSource("lose.mp3", "static")


	cellSize = 20
	gridX = 40
	gridY = 30
	love.window.setMode(gridX * cellSize, gridY * cellSize)
	timer = 0
	directionQueue = {"right"} 
	food = {}
	food.x = love.math.random(gridX) 
	food.y = love.math.random(gridY) 
	food.w = 17
	food.sprite = love.graphics.newImage("apple.png")
	lose = false
	font = love.graphics.newFont(40)
	score = 0
	counter = 0

end

function love.update(dt)
	music:play()
	counter = counter + 1
	if counter == 1 then
		start:play()
	end
	timer = timer + dt
	nextX = snakeParts[1].x
	nextY = snakeParts[1].y
	if directionQueue[1] == "right"  then
		nextX = nextX + 1
		if nextX > gridX then
			nextX = 1
		end
	elseif directionQueue[1] == "left" then
		nextX = nextX - 1
		if nextX < 0 then
			nextX = gridX 
		end
	elseif directionQueue[1] == "up" then 
		nextY = nextY - 1
		if nextY < 0 then 
			nextY = gridY
		end
	elseif directionQueue[1] =="down" then
		nextY = nextY + 1
		if nextY > gridY then
			nextY = 1
		end
	end
	if timer >= 0.06 then
		timer = 0
		death()
		if #directionQueue > 1 then
            table.remove(directionQueue, 1)
        end
		table.insert(snakeParts, 1,{
			x = nextX, y = nextY
		})
		table.remove(snakeParts)

	end
	if CheckCollision((snakeParts[1].x - 1)*cellSize,(snakeParts[1].y - 1)*cellSize,cellSize-1,cellSize-1, (food.x - 1)*cellSize,(food.y -1)*cellSize ,food.w,food.w)  then
		food.x = love.math.random(gridX)
		food.y = love.math.random(gridY)
		apple:play()
		score = score + 1
		if directionQueue[1] == 'right' then
			table.insert(snakeParts, 1,{
				x = snakeParts[1].x + 1, y = snakeParts[1].y 
			})
		end

		if directionQueue[1] == 'left' then
			table.insert(snakeParts, 1,{
				x = snakeParts[1].x - 1, y = snakeParts[1].y 
			})
		end

		if directionQueue[1] == 'up' then
			table.insert(snakeParts, 1,{
				x = snakeParts[1].x , y = snakeParts[1].y -1
			})
		end

		if directionQueue[1] == 'down' then
			table.insert(snakeParts, 1,{
				x = snakeParts[1].x , y = snakeParts[1].y + 1
			})
		end
	end

end




function love.draw()
	ehh = death()
	if ehh or lose then
		loser:play()
		love.graphics.setColor(.28, .28, .28)
		love.graphics.rectangle("fill",0 ,0 ,cellSize*gridX, cellSize*gridY)
		lose = true
		love.graphics.setColor(1,0,1)
		love.graphics.setFont(font)
		love.graphics.print("WOw you've lost, Should we be suprised ? \n\n\n\n\n nah you are just SHIT!", 10, 100)
		restart()
	else
	love.graphics.setColor(1/255, 0, 41/255)
	love.graphics.rectangle("fill" ,0, 0, cellSize*gridX, cellSize*gridY)
	for partsId, parts in ipairs(snakeParts) do 
		love.graphics.setColor(57/255, 1, 20/255)
		-- The damn snake
		love.graphics.rectangle("fill", (parts.x - 1) * cellSize, (parts.y - 1) * cellSize, cellSize - 1, cellSize -1)

	end
	love.graphics.setFont(font)
	love.graphics.print(score, 10, 10)
	love.graphics.setColor(1, 0, 0)
	-- The damn food
	love.graphics.draw(food.sprite, (food.x - 1) * cellSize - 3, (food.y - 1) * cellSize - 3, 0, 1.6, 1.6)
	-- YOU LOST YOU ARE SHIT SCREEN
	end
end

function love.keypressed(key)
    if key == 'right' and directionQueue[#directionQueue] ~= 'left' then
        table.insert(directionQueue, 'right')
    elseif key == 'left' and directionQueue[#directionQueue] ~= 'right' then
        table.insert(directionQueue, 'left')
    elseif key == 'down' and directionQueue[#directionQueue] ~= 'up' then
        table.insert(directionQueue, 'down')
    elseif key == 'up' and directionQueue[#directionQueue] ~= 'down' then
        table.insert(directionQueue, 'up')
    end
end
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
function death()
	for id, value in ipairs(snakeParts) do
		if snakeParts[1].x == snakeParts[id].x and id ~= 1 and snakeParts[1].y == snakeParts[id].y and id ~= 1 then
			return true
		end
	end
	return false
end
function restart()
	if love.keyboard.isDown('space') then
		lose = false
		ehh = false
		for k in pairs (snakeParts) do
   			 snakeParts[k] = nil
		end
		snakeParts = {
		{x = 3, y = 1},
		{x = 2, y = 1},
		{x = 1, y = 1}
		}
		score = 0 
		directionQueue = {"right"} 
		counter = 0
	end
	
end
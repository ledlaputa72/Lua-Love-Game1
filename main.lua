-- 초기화 로드 
function love.load()
    -- 캐릭터 애니메이션 라이브러리 애니메이션의 동작 소스를 나눠서 불러온다. 
    anim8 = require 'libraries/anim8'
    -- 캐릭터 픽셀을 확대할때 블러되지 않게 해주는 옵션
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Lua로 된 맵을 불러오기 위한 라이브러리 
    sti = require 'libraries/sti'
    -- 제작된 맵 소스를 불러온다. 
    gameMap = sti('maps/testMap.lua')

    player = {}
    player.x = 400
    player.y = 200
    player.speed = 5

    -- player.sprite = love.graphics.newImage('sprites/logo.png')

    -- 스프라이트 시트로 구성된 캐릭터 애니메이션을 불러와 그리드에 맞춰 나눠 각 동작으로 구분한다. 
    player.spriteSheet = love.graphics.newImage('sprites/player-sheet.png')
    player.grid = anim8.newGrid( 12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    -- 방향별 애니메이션 제작 
    player.animations = {}
    player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.2 )
    player.animations.left = anim8.newAnimation( player.grid('1-4', 2), 0.2 )
    player.animations.right = anim8.newAnimation( player.grid('1-4', 3), 0.2 )
    player.animations.up = anim8.newAnimation( player.grid('1-4', 4), 0.2 )

    player.anim = player.animations.left 
    
    background = love.graphics.newImage('sprites/background.png')
end


-- 업데이트 항목 
function love.update(dt) -- dt = delta time
    -- 동작하지 않을때 비교연산
    local isMoving = false

    -- 키보드 조작에 따른 애니메이션 
    if love.keyboard.isDown("right") then        
        player.x = player.x + player.speed
        player.anim = player.animations.right
        -- 동작에 대한 비교 연산 
        isMoving = true
    end

    if love.keyboard.isDown("left") then        
        player.x = player.x - player.speed
        player.anim = player.animations.left 
        isMoving = true
    end

    if love.keyboard.isDown("down") then        
        player.y = player.y + player.speed
        player.anim = player.animations.down 
        isMoving = true
    end

    if love.keyboard.isDown("up") then        
        player.y = player.y - player.speed
        player.anim = player.animations.up 
        isMoving = true
    end

    -- 동작하지 않으면 중간 프레임을 보여준다. 
    if isMoving == false then
        player.anim:gotoFrame(2)
    end    

    -- 애니메이션을 Delta time별로 애니메이션 돌림
    player.anim:update(dt)

end

-- 그리기 
function love.draw()
    -- 순서가 위에서부터 그려나간다. 
    -- love.graphics.circle("fill", player.x, player.y, 100)
    -- love.graphics.draw(background, 0, 0)

    -- 맵을 불러온다 
    gameMap:draw()

    -- love.graphics.draw(player.sprite, player.x, player.y)
    -- 캐릭터를 불러와 각 애니메이션 프레임별로 그려준다. 
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6)
end

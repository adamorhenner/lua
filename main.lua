-- Load some default values for our rectangle.
function love.load()
    love.window.setMode(320, 480, {resizable = false})
    love.window.setTitle("14bis VS Meteoro")

    backgroud = love.graphics.newImage("imagens/background.png")

    x, y, w, h = 20, 20, 60, 20
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
    if love.keyboard.isDown('w') then
        y = y -10
    end
    if love.keyboard.isDown('s') then
        y = y + 10
    end
    if love.keyboard.isDown('a') then
        x = x - 10
    end
    if love.keyboard.isDown('d') then
        x = x + 10
    end
end

-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(backgroud, 0,0)

    love.graphics.rectangle("fill", x, y, w, h)
end
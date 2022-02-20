-- Load some default values for our rectangle.
function love.load()
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
    love.graphics.setColor(0, 0.4, 0.4)
    love.graphics.rectangle("fill", x, y, w, h)
end
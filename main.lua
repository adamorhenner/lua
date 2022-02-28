
LARGURA_TELA = 320
ALTURA_TELA = 480


aviao_14bis = {
    src = "imagens/14bis.png",
    largura = 64,
    altura = 64,
    x = LARGURA_TELA/2 -64/2,
    y = ALTURA_TELA - 64/2
}

meteoros = {}
function criaMeteoro()
    meteoro = {
        x = math.random(LARGURA_TELA),
        y = 0
    }
    table.insert(meteoros, meteoro)
end



function moveMeteoros()
    for k,meteoro in pairs(meteoros) do
        meteoro.y = meteoro.y + 1
    end
end

function move14bis ()
    if love.keyboard.isDown('w') then
        aviao_14bis.y = aviao_14bis.y - 5
    end
    if love.keyboard.isDown('s') then
        aviao_14bis.y = aviao_14bis.y + 5
    end
    if love.keyboard.isDown('a') then
        aviao_14bis.x = aviao_14bis.x - 5
    end
    if love.keyboard.isDown('d') then
        aviao_14bis.x = aviao_14bis.x + 5
    end
end


-- Load some default values for our rectangle.
function love.load()
    love.window.setMode(LARGURA_TELA, ALTURA_TELA, {resizable = false})
    love.window.setTitle("14bis VS Meteoro")

    backgroud = love.graphics.newImage("imagens/background.png")
    aviao_14bis.imagem = love.graphics.newImage(aviao_14bis.src)
    meteoro_img = love.graphics.newImage("imagens/meteoro.png")
    

end

-- Increase the size of the rectangle every frame.
function love.update ()
    if love.keyboard.isDown('w','a','s','d') then
        move14bis()
    end

    criaMeteoro()
    moveMeteoros()

end

-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(backgroud, 0,0)
    love.graphics.draw(aviao_14bis.imagem, aviao_14bis.x, aviao_14bis.y)

    for k,meteoro in pairs(meteoros) do
        love.graphics.draw(meteoro_img, meteoro.x, meteoro.y)
    end
end
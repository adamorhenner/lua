
LARGURA_TELA = 320
ALTURA_TELA = 480
MAX_METEOROS = 12
METEOROS_ATINGIDOS = 0
NUMERO_METEOROS_OBJETIVO = 100


aviao_14bis = {
    src = "imagens/14bis.png",
    largura = 55,
    altura = 63,
    x = LARGURA_TELA/2 -64/2,
    y = ALTURA_TELA - 64/2,
    tiros = {}
}

function daTiro()
    disparo:play()

    local tiro = {
        x =aviao_14bis.x + aviao_14bis.largura/2,
        y = aviao_14bis.y,
        largura = 16,
        altura = 16
    }
    table.insert(aviao_14bis.tiros, tiro)
end

function moveTiro()
    for i= #aviao_14bis.tiros,1,-1 do
        if aviao_14bis.tiros[i].y > 0 then
            aviao_14bis.tiros[i].y = aviao_14bis.tiros[i].y - 7
        else
            table.remove(aviao_14bis.tiros, i)
        end
    end
end



function destroiAviao()
    destruicao:play()

    aviao_14bis.src = "imagens/explosao_nave.png"
    aviao_14bis.imagem = love.graphics.newImage(aviao_14bis.src)
    aviao_14bis.largura = 67
    aviao_14bis.altura = 77
end

function reconstroiAviao()
    aviao_14bis.src = "imagens/14bis.png"
    aviao_14bis.imagem = love.graphics.newImage(aviao_14bis.src)
    aviao_14bis.largura = 55
    aviao_14bis.altura = 63
end

function temColisao(X1, Y1, L1, A1, X2, Y2, L2, A2)
    return X2 < X1 + L1 and
           X1 < X2 + L2 and
           Y1 < Y2 + A2 and
           Y2 < Y1 + A1 
end

meteoros = {}
function criaMeteoro()
    if abreTela then
        meteoro = {
            x = math.random(LARGURA_TELA),
            y = -70,
            largura = 50,
            altura = 44,
            peso = math.random(3),
            deslocamento_horizontal = math.random(-1,1)
        }
        table.insert(meteoros, meteoro)
    end
end

function removeMeteoros()
    for i = #meteoros, 1, -1 do
        if meteoros[i].y > ALTURA_TELA then
         table.remove(meteoros, i)
        end
    end
end

function moveMeteoros()
    for k,meteoro in pairs(meteoros) do
        meteoro.y = meteoro.y + meteoro.peso
        meteoro.x = meteoro.x + meteoro.deslocamento_horizontal
    end
end

function move14bis ()
    if love.keyboard.isDown('w') then
        if aviao_14bis.y > ( -60 + aviao_14bis.imagem:getHeight() / 2) then
            aviao_14bis.y = aviao_14bis.y - 5
        end
    end
    if love.keyboard.isDown('s') then
        if aviao_14bis.y < (ALTURA_TELA - aviao_14bis.imagem:getHeight() / 2) then
            aviao_14bis.y = aviao_14bis.y + 5
        end
    end
    if love.keyboard.isDown('a') then
        if aviao_14bis.x > ( -60 + aviao_14bis.imagem:getWidth() / 2) then
            aviao_14bis.x = aviao_14bis.x - 5
        end
    end
    if love.keyboard.isDown('d') then
        if aviao_14bis.x < (LARGURA_TELA - aviao_14bis.imagem:getWidth() / 2) then
            aviao_14bis.x = aviao_14bis.x + 5
        end
    end
end

function trocaMusicaDeFundo()
    musica_ambiente:stop()
    game_over:play()

end

function checaColisaoComAviao()
    for k, meteoro in pairs(meteoros) do
        if temColisao(meteoro.x, meteoro.y, meteoro.largura, meteoro.altura, 
                    aviao_14bis.x, aviao_14bis.y, aviao_14bis.largura, aviao_14bis.altura) then
            trocaMusicaDeFundo()
            destroiAviao()
            --FIM_JOGO = true
            estaVivo = false
            abreTela = false
        end
    end
end

function checaColisaoComTiros()
    for i = #aviao_14bis.tiros, 1, -1 do
        for j = #meteoros, 1, -1 do
            if temColisao(aviao_14bis.tiros[i].x, aviao_14bis.tiros[i].y,aviao_14bis.tiros[i].largura, aviao_14bis.tiros[i].altura,
                        meteoros[j].x, meteoros[j].y, meteoros[j].largura, meteoros[j].altura) then
                 
                METEOROS_ATINGIDOS = METEOROS_ATINGIDOS + 1
                table.remove(aviao_14bis.tiros, i)
                table.remove(meteoros,j)
                break
            end
        end
    end
end

function checaColisoes()
    checaColisaoComAviao()
    checaColisaoComTiros()
end

function checaObjetivoConcluido()
    if METEOROS_ATINGIDOS >= NUMERO_METEOROS_OBJETIVO then
        musica_ambiente:stop()
        VENCEDOR = true
        vencedor_som:play() 
    end
end

function love.load()
    love.window.setMode(LARGURA_TELA, ALTURA_TELA, {resizable = false})
    love.window.setTitle("14bis VS Meteoro")

    math.randomseed(os.time())

    --Background
    backgroud = love.graphics.newImage("imagens/Background2.png")
    backgroudDois = love.graphics.newImage("imagens/Background2.png")

    planoDeFundo = {
        x =0,
        y =0,
        y2 = 0 - backgroud:getHeight(),
        vel = 5
    }
    --Background

    -- imagens
    gameover_img = love.graphics.newImage("imagens/gameover2.png")
    vencedor_img = love.graphics.newImage("imagens/vencedor2.png")

    aviao_14bis.imagem = love.graphics.newImage(aviao_14bis.src)
    meteoro_img = love.graphics.newImage("imagens/meteoro.png")
    tiro_img = love.graphics.newImage("imagens/tiro2.png")
    --imagens

    -- sons
    musica_ambiente = love.audio.newSource("audios/ambiente.wav", "static")
    musica_ambiente:setLooping(true)
    musica_ambiente:play()

    destruicao = love.audio.newSource("audios/destruicao.wav", "static")
    game_over = love.audio.newSource("audios/game_over.wav", "static")
    vencedor_som = love.audio.newSource("audios/winner.wav", "static")
    disparo = love.audio.newSource("audios/disparo.wav", "static")
    --sons

    estaVivo = false

    --Tela titulo
    abreTela = false
    telaTitulo = love.graphics.newImage("imagens/background.png")
    inOutx = 0
    inOuty = 0
    --Tela titulo

end

-- Increase the size of the rectangle every frame.
function love.update ()
    ---fimdejofgo
    --if estaVivo and not VENCEDOR and not love.keyboard.isDown('r') then
        if love.keyboard.isDown('w','a','s','d') then
            move14bis()
        end


        removeMeteoros()
        if #meteoros < MAX_METEOROS then
            criaMeteoro()
        end
        moveMeteoros()
        moveTiro()
        checaColisoes()
        checaObjetivoConcluido()
        planoDeFundoScrolliing()
        iniciaJogo()
        reset()

        --if not estaVivo and love.keyboard.isDown('r') then
            --aviao_14bis.tiros = {}
            

            --aviao_14bis.x = LARGURA_TELA/2
            --aviao_14bis.y = ALTURA_TELA/2

            --METEOROS_ATINGIDOS = 0

            --estaVivo = true
            --FIM_JOGO = false
        --end
    end
--end

function love.keypressed(tecla)
    if tecla == "escape" then
        love.event.quit()
    elseif tecla == "space" then
        if estaVivo then
            daTiro()
        end
    end
end




-- Draw a coloured rectangle.
function love.draw()
    -- background
    love.graphics.draw(backgroud, planoDeFundo.x, planoDeFundo.y)
    love.graphics.draw(backgroudDois, planoDeFundo.x, planoDeFundo.y2)
    -- background
    

    love.graphics.print("Meteoros restantes "..NUMERO_METEOROS_OBJETIVO-METEOROS_ATINGIDOS, 0,0)


    for k,meteoro in pairs(meteoros) do
        love.graphics.draw(meteoro_img, meteoro.x, meteoro.y)
    end

    for k, tiro in ipairs(aviao_14bis.tiros) do
        love.graphics.draw(tiro_img, tiro.x, tiro.y)
    end


    if VENCEDOR then
        love.graphics.draw(vencedor_img, LARGURA_TELA/2 - vencedor_img:getWidth()/2, ALTURA_TELA/2 - vencedor_img:getHeight()/2)
    end

    -- Game over e reset
    if estaVivo then
        love.graphics.draw(aviao_14bis.imagem, aviao_14bis.x, aviao_14bis.y)

    else
        love.graphics.draw(gameover_img, LARGURA_TELA/2 - gameover_img:getWidth()/2, ALTURA_TELA/2 - gameover_img:getHeight()/2)
        love.graphics.draw(telaTitulo, inOutx, inOuty)
        --love.graphics.print("Aperte 'r' para reiniciar.", LARGURA_TELA/3 - 20, ALTURA_TELA/2 +55)
    end
    -- Game over e resetww

end


function planoDeFundoScrolliing()
    planoDeFundo.y = planoDeFundo.y + planoDeFundo.vel
    planoDeFundo.y2 = planoDeFundo.y2 + planoDeFundo.vel

    if planoDeFundo.y > ALTURA_TELA then
        planoDeFundo.y = planoDeFundo.y2 - backgroudDois:getHeight()
    end
    if planoDeFundo.y2 > ALTURA_TELA then
        planoDeFundo.y2 = planoDeFundo.y - backgroud:getHeight()
    end
    
end

function iniciaJogo()
    if abreTela then
        inOutx = inOutx + 600
        if inOutx> 481 then
            inOuty = -701
            inOutx = 0
            estaVivo = true
        end
    elseif not abreTela then
        inOuty = inOuty + 600
        if inOuty > 0 then
            inOuty = 0
        end
    end
end

function reset()
    if not estaVivo and love.keyboard.isDown('r') then
        abreTela = true
        estaVivo = true
        reconstroiAviao()

    end    
end
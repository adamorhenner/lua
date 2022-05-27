LARGURA_TELA = 320
ALTURA_TELA = 480
MAX_METEOROS = 12
METEOROS_ATINGIDOS = 0
NUMERO_METEOROS_OBJETIVO = 20
tela_game_over = false
velocidade_tiro = 3
parametro_aumento = 25
contador = 1

nave = {
    src = "imagens/nave2.png",
    largura = 55,
    altura = 63,
    x = LARGURA_TELA/2 -64/2,
    y = ALTURA_TELA - 64/2,
    tiros = {}
}

function daTiro()
    disparo:play()

    local tiro = {
        x =nave.x + nave.largura/2,
        y = nave.y,
        largura = 16,
        altura = 16
    }
    table.insert(nave.tiros, tiro)
end

function moveTiro()
    for i= #nave.tiros,1,-1 do
        if nave.tiros[i].y > 0 then
            nave.tiros[i].y = nave.tiros[i].y - velocidade_tiro
        else
            table.remove(nave.tiros, i)
        end
    end
end

function destroiAviao()
    destruicao:play()

    nave.src = "imagens/explosao_nave.png"
    nave.imagem = love.graphics.newImage(nave.src)
    nave.largura = 67
    nave.altura = 77
end

function reconstroiAviao()
    nave.src = "imagens/nave2.png"
    nave.imagem = love.graphics.newImage(nave.src)
    nave.largura = 55
    nave.altura = 63
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

function moveNave ()
    if love.keyboard.isDown('w') then
        if nave.y > ( -60 + nave.imagem:getHeight() / 2) then
            nave.y = nave.y - 5
        end
    end
    if love.keyboard.isDown('s') then
        if nave.y < (ALTURA_TELA - nave.imagem:getHeight() / 2) then
            nave.y = nave.y + 5
        end
    end
    if love.keyboard.isDown('a') then
        if nave.x > ( -60 + nave.imagem:getWidth() / 2) then
            nave.x = nave.x - 5
        end
    end
    if love.keyboard.isDown('d') then
        if nave.x < (LARGURA_TELA - nave.imagem:getWidth() / 2) then
            nave.x = nave.x + 5
        end
    end
end

function trocaMusicaDeFundo()
    musica_ambiente:stop()
    game_over:play()

end

function checaColisaoComNave()
    for k, meteoro in pairs(meteoros) do
        if temColisao(meteoro.x, meteoro.y, meteoro.largura, meteoro.altura, 
        nave.x, nave.y, nave.largura, nave.altura) then
            trocaMusicaDeFundo()
            destroiAviao()
            --FIM_JOGO = true
            tela_game_over = true
            --estaVivo = false
            --abreTela = false
        end
    end
end

function checaColisaoComTiros()
    for i = #nave.tiros, 1, -1 do
        for j = #meteoros, 1, -1 do
            if temColisao(nave.tiros[i].x, nave.tiros[i].y,nave.tiros[i].largura, nave.tiros[i].altura,
                        meteoros[j].x, meteoros[j].y, meteoros[j].largura, meteoros[j].altura) then
                 
                METEOROS_ATINGIDOS = METEOROS_ATINGIDOS + 1
                table.remove(nave.tiros, i)
                table.remove(meteoros,j)
                break
            end
        end
    end
end

function checaColisoes()
    checaColisaoComNave()
    checaColisaoComTiros()
end

function checaObjetivoConcluido()

    if METEOROS_ATINGIDOS >= NUMERO_METEOROS_OBJETIVO then
        NUMERO_METEOROS_OBJETIVO = NUMERO_METEOROS_OBJETIVO + 20
        MAX_METEOROS = MAX_METEOROS + 1
        parametro_aumento = parametro_aumento + 10
    end
    if MAX_METEOROS > parametro_aumento then
        velocidade_tiro = velocidade_tiro + contador
    end
end

function love.load()
    love.window.setMode(LARGURA_TELA, ALTURA_TELA, {resizable = false})
    love.window.setTitle("Pei pei")

    math.randomseed(os.time())

    --Background
    backgroud = love.graphics.newImage("imagens/fundo.png")
    backgroudDois = love.graphics.newImage("imagens/fundo.png")

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

    nave.imagem = love.graphics.newImage(nave.src)
    meteoro_img = love.graphics.newImage("imagens/meteoro.png")
    tiro_img = love.graphics.newImage("imagens/tiro2.png")
    --imagens

    -- sons
    musica_ambiente = love.audio.newSource("audios/Space.mp3", "static")
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
    telaTitulo = love.graphics.newImage("imagens/backgroundMenu.png")
    inOutx = 0
    inOuty = 0
    --Tela titulo

end

function love.update ()
    if love.keyboard.isDown('w','a','s','d') then
        moveNave()
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
end

function love.keypressed(tecla)
    if tecla == "escape" then
        love.event.quit()
    elseif tecla == "space" then
        if estaVivo then
            daTiro()
        end
    end
end

function love.draw()
    -- background
    love.graphics.draw(backgroud, planoDeFundo.x, planoDeFundo.y)
    love.graphics.draw(backgroudDois, planoDeFundo.x, planoDeFundo.y2)
    -- background
    

    love.graphics.print("PONTUAÇÃO: "..METEOROS_ATINGIDOS, 0,0)


    for k,meteoro in pairs(meteoros) do
        love.graphics.draw(meteoro_img, meteoro.x, meteoro.y)
    end

    for k, tiro in ipairs(nave.tiros) do
        love.graphics.draw(tiro_img, tiro.x, tiro.y)
    end


    if VENCEDOR then
        love.graphics.draw(vencedor_img, LARGURA_TELA/2 - vencedor_img:getWidth()/2, ALTURA_TELA/2 - vencedor_img:getHeight()/2)
    end

    -- Game over e reset
    if estaVivo then
        love.graphics.draw(nave.imagem, nave.x, nave.y)

    else
        love.graphics.draw(gameover_img, LARGURA_TELA/2 - gameover_img:getWidth()/2, ALTURA_TELA/2 - gameover_img:getHeight()/2)
        love.graphics.draw(telaTitulo, inOutx, inOuty)
        love.graphics.setFont(love.graphics.newFont(18))
    end

    if tela_game_over then
        meteoros ={}
        love.graphics.draw(gameover_img, LARGURA_TELA/2 - gameover_img:getWidth()/2, ALTURA_TELA/2 - gameover_img:getHeight()/2)
        love.graphics.print("Aperte 'p' para reiniciar.", LARGURA_TELA/3 - 50, ALTURA_TELA/2 +55 )
        planoDeFundo.vel = 0
    end
    
    if love.keyboard.isDown('p') then
        estaVivo = false
        abreTela = false
        tela_game_over = false
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
        METEOROS_ATINGIDOS = 0
        musica_ambiente:play()
        meteoros = {}
        nave.x = LARGURA_TELA/2 -64/2
        nave.y = ALTURA_TELA - 64/2
        planoDeFundo.vel = 5
        parametro_aumento = 25
        contador = 1
    end    
end


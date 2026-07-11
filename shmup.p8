pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--main
sprites = {
     nave = 2;
     nave_l = 1;
     nave_r = 3;
     player_ferido = 6;
     
     hp = 4;
     hp_vazio = 5;

     bala = 9;
     bala_inimigo_apagada = 9;
     bala_inimigo_acesa = 10;
}

     var = {
          fps = 30;
          
          speed = 2;
          bala_speed = 4;
          
          animation_inimigo_por_frame = 0.1;
          delay_tiro = 0.1;
          delay_inv = 3;
          delay_spawn = 2;
          delay_input_travado = 5;
          
          esquerda = -1;
          direita = 1;
          

          explosion = {
               speed = 2;
               vida_media = 20;
               variancia_vida = 10;

          };

          shockwaves = {
               propagation = 40;
               speed = 3;
          };

          transition_waves = 5;
          quantia_waves = 5;
     }
   
     trava_tiro = 0;
     trava_input = 0;
          
     quantia_inimigos = 0;
     spawn_inimigos = 0;

     --Objetos
     player = {};
     estrelas = {};
     balas={};
     inimigos={};
     balas_inimigos = {};
     particulas={};
     shockwaves={};
     
     
     tempo = 0;
     trava_wave = 0;

function _init()
     player = {
          x = 64;
          y = 100;
          sprite=sprites.nave;
          hp = 1;
          hp_max = 4;
          timer_invencivel = 0;
          hitbox = {
               left = 0;
               right = 0;
               top = 0;
               bottom = 0;
          }
     }


     modo = "wave";
     wave = 1;
     trava_wave = var.fps * var.transition_waves;

     if #estrelas == 0 then  
          criar_estrelas();
     end
     
end


function _update()
     if (modo == "jogo") then
          update_jogo();
     elseif (modo == "start") then
          update_inicio();
     elseif (modo == 'morto') then
          update_morto();
     elseif (modo == 'wave') then
          update_wave();
     end
     
end


function _draw()
     if (modo ==  "jogo") then
          draw_jogo();
     elseif (modo =="start") then
          draw_inicio();
     elseif (modo == "morto") then
          draw_morto();
     elseif (modo == "wave") then
          draw_wave();
     end
end



-->8
--desenhos extras (jogo)
function draw_estrelas()
     for i=1, #estrelas do
          pset(estrelas[i].x,estrelas[i].y,7);
     end
end

function desenhar_vida()
     for i=1, player.hp_max do
          if i > player.hp then
               spr(sprites.hp_vazio,i*9-8,1);
          else
               spr(sprites.hp,i*9-8,1);
          end
     end
end

function draw_particulas() 
     for part in all(particulas) do
          circfill(part.x, part.y, part.raio, part.cor);
     end
end

function draw_shockwaves()
     for sw in all(shockwaves) do
          circ(sw.x,sw.y,sw.raio,7);
     end
end
-->8
--fun. auxiliares (jogo)

function atirar()
     if trava_tiro <= 0 and btn(5) and modo =='jogo' then
          local bala = {
               x = player.x,
               y = player.y,
               hitbox = {
                    left = 0;
                    right = 0;
                    top = 0;
                    bottom = 0;
               }
          }
          sfx(1);
          add(balas,bala);
          trava_tiro = var.delay_tiro * var.fps;
     elseif trava_tiro > 0 then 
          trava_tiro -= 1;
     end
end

function mover_bala() 
     for bala in all(balas) do
          if bala.y > 0 then
               bala.y -= var.bala_speed;
               atualizar_hitbox(bala,hitbox_bala);
          else 
               del(balas,bala);
          end  
     end

     for bul in all(balas_inimigos) do 
          if bul.x < 128 and bul.x > 0 and bul.y > 0 and bul.y < 128 then 
               bul.x +=bul.sx;
               bul.y += bul.sy;
               atualizar_hitbox(bul,hitbox_bala_inimiga)
          else 
               del(balas_inimigos,bul);
          end
     end   
end

function mover_estrelas() 
     for i=1, #estrelas do
          local estrela = estrelas[i];
          estrela.y += estrela.speed;
          if estrela.y > 127 then
               estrela.x = flr(rnd(128));
               estrela.y = 0;
          end
     end
end

function criar_estrelas()
    for i = 1, 100 do
        local estrela = {                      -- nova tabela a cada iteraれせれこo
            x = flr(rnd(128)),
            y = flr(rnd(128)),
            speed = ceil(rnd(4))
        }
        add(estrelas, estrela)
    end
end

function mover_particula(paleta)
     cor = 0;

     for part in all(particulas) do
          if part.idade >= part.vida_maxima  then
               del(particulas,part);
          end
          cor = ceil(((part.idade / part.vida_maxima) * #part.paleta));
          part.x += part.speed_x;
          part.y += part.speed_y;
          part.cor = part.paleta[cor];
          part.idade +=1;
     end
end

function mover_shockwave()
     for sw in all(shockwaves) do
          sw.raio += var.shockwaves.speed;
          if sw.raio >= var.shockwaves.propagation then
               del(shockwaves,sw);
          end
     end
end
-->8
--jogo
function draw_jogo()
     cls(0);
     desenhar_vida();
     draw_estrelas();

     if not(modo=='morto') then   
          draw_player();
     end

     draw_inimgo();
     draw_particulas();
     draw_shockwaves();
     draw_balas();

     print(#balas_inimigos);
end

function update_jogo()

     mover_inimigos();
     
     mover_estrelas();
     mover_particula();
     mover_shockwave();
     mover_bala();
     
     atirar();
     
     mover_player();
     validar_morte_player();

     tempo+=1;
end

function validar_morte_player()
     for inimigo in all(inimigos) do
          if colidir(player,inimigo) then
               if player.timer_invencivel <= 0 then
                    player.hp -= 1;
                    player.timer_invencivel =var.fps * var.delay_inv;
                    sfx(2);
               end
          end
     end

     for bul in all(balas_inimigos) do
          if colidir(player,bul) then
               if player.timer_invencivel <= 0 then
                    player.hp -= 1;
                    player.timer_invencivel =var.fps * var.delay_inv;
                    del(balas_inimigos,bul)
                    sfx(2);
               end
          end
     end

     if player.timer_invencivel > 0 then
          player.timer_invencivel-=1;
     end

     if (player.hp == 0) and modo=='jogo' then
          modo = "morto";
          trava_input = var.delay_input_travado * var.fps;
          criar_explosion(player, paleta_explosion_player);
     end
end

function mover_player()
     player.sprite = sprites.nave;	

     if not(modo == 'morto' or modo == 'start') then
          if btn(➡️) and player.x < 120 then
               player.x = player.x + var.speed;
               player.sprite = sprites.nave_r;
          elseif btn(⬅️) and player.x > 0 then
               player.x = player.x - var.speed;
               player.sprite = sprites.nave_l;
          end
          
          if btn(⬆️) and player.y > 0 then
               player.y = player.y - var.speed;
          elseif btn(⬇️) and player.y < 120 then
               player.y = player.y + var.speed;
          end
     end

     atualizar_hitbox(player, hitbox_player);
end



function draw_player()
     if player.timer_invencivel > 0 then
          if sin(tempo/10) < 0.5 then
               spr(player.sprite,player.x,player.y);
          end
     else 
          spr(player.sprite,player.x,player.y);
     end
     
end

function draw_balas()
     if #balas > 0 then  
          for bala in all(balas) do
               spr(sprites.bala, bala.x, bala.y);
          end
     end

     if #balas_inimigos > 0 then
          for bul in all(balas_inimigos) do
               spr(bul.sprite_atual,bul.x, bul.y);
          end
     end
end

-->8
--tela inicial
function draw_inicio()
     cls(1);
     print("shoot'em up",50,20);
     print("Aperte um dos botoes \nde ataque para iniciar",15,60);
end

function update_inicio()
     if (btn(4) or btn(5)) and trava_input <= 0 then
          _init();
     end

     if trava_input > 0 then
          trava_input-=1;
     end
end
-->8
--Game over
function draw_morto()
     draw_jogo();
     if trava_input < 60 then
          print("game over",50,80,4); 
     end

     if trava_input <= 0 then
          print('aperte ❎  ou 🅾️',30,100,4);
     end
end

function update_morto()
     if trava_input > 0 then
          trava_input-=1;
     end
     update_jogo();
     inimigos = {};
     if (btn(4) or btn(5)) and trava_input <= 0 then
          modo = "start";
          trava_input = 0.5 * var.fps;
     end
end

-->8
--Inimigos
function criar_inimgo(id)
     if var.delay_spawn > 0 then
          var.delay_spawn -= 1;
     end
          inimigo_criado = {
               x = rnd(110) + 10;--
               y = -8;--
               sprite_atual = 0;--
               timer_animation = 0;--
               timer_acao = 0;
               hitbox = {
                    left = 0;
                    right = 0;
                    top = 0;
                    bottom = 0;
               };
               --Partes aqui vêm de dados
               id = id;
               hp = dados_inimigos[id].hp;
               sprite_inicial = dados_inimigos[id].sprite_inicial;
               sprite_final = dados_inimigos[id].sprite_final;
               hitbox_dados = dados_inimigos[id].hitbox; 
               --speed_x = dados_inimigos[id].speed_x;
               speed_y = dados_inimigos[id].speed_y;
               largura = dados_inimigos[id].largura;
               altura = dados_inimigos[id].altura;
               tipo = dados_inimigos[id].tipo;
               delay_acao = dados_inimigos[id].delay_acao;
               delay_animacao = dados_inimigos[id].delay_animacao;
          }

     add(inimigos,inimigo_criado);
end

function mover_inimigos()
     for inimigo in all(inimigos) do
          animar_inimigo(inimigo);
          inimigo.y += inimigo.speed_y;
          atualizar_hitbox(inimigo,hitbox_inimigo);

          
          for bala in all(balas) do
               if colidir(bala, inimigo) then
                    inimigo.hp -=1;
                    del(balas,bala);
                    sfx(3);
               end
          end
          if inimigo.timer_acao == 0 then   
               --sfx(1);
               realizar_acao(inimigo);
               inimigo.timer_acao = inimigo.delay_acao;
          else 
               inimigo.timer_acao-=1;
          end
          apagar_inimigo(inimigo);
     end
end

function realizar_acao(inim)
     if inim.tipo == "atirador" then
          sfx(1)
          inimigo_atira(inim);
     end
end

function inimigo_atira(inim)
    sfx(1)
    local balas_geradas = 0;
    local velocidade = 2; -- velocidade das balas (ajuste conforme necessário)
    
     for dados in all(projeteis_inimigos) do
          if dados.id == inim.id then
               balas_geradas = dados.qtd;
          end
     end

    for i = 1, balas_geradas do
        local ang = i/balas_geradas; 
        local bala_inimigo = {
            x = inim.x,
            y = inim.y,
            sx = cos(ang) * velocidade,  -- componente x da velocidade
            sy = sin(ang) * velocidade,  -- componente y da velocidade
            sprite_atual = sprites.bala,
            hitbox = {
               left = 0;
               right = 0;
               top = 0;
               right = 0;
            }
        }
        inim.timer_animation = inim.delay_acao - 1*var.fps;
        add(balas_inimigos, bala_inimigo)
    end
end

function apagar_inimigo(inim) --No momento, vai sれは recolocar no topo
     if inim.y > 128 or inim.hp == 0 then

          
          if inim.hp == 0 then
               criar_explosion(inim, paleta_explosion_inim);
               quantia_inimigos -=1;
               del(inimigos,inim);
          else
               inim.x = rnd(flr(100))+10;
               inim.y = -16;
          end

          
          validar_fim_wave();

          -- if not (modo == 'morto' or modo=='wave') then
          --      criar_inimgo();
          -- end

     end
end

function validar_fim_wave()
     if quantia_inimigos == 0 then
          trava_wave = var.transition_waves * var.fps;
           modo = 'wave';
           wave+=1;
     end
end

function criar_explosion(objeto, paleta)  
     for i=1,30 do
          local part={
               x = objeto.x + 4;
               y = objeto.y + 4;
               speed_x = rnd(var.explosion.speed * 2) - var.explosion.speed;
               speed_y = rnd(var.explosion.speed * 2) - var.explosion.speed;
               idade = rnd(2);
               vida_maxima = ceil(rnd(var.explosion.variancia_vida)) + var.explosion.vida_media;
               raio = ceil(rnd(4));
               cor = 0;
               paleta = paleta;
          }
          add(particulas,part);
          criar_shockwave(part.x, part.y);
     end

end

function criar_shockwave(x,y)
     local sw = {
          x = x;
          y = y;
          raio = 1;
     }
     add(shockwaves,sw);
end



function animar_inimigo(inim)
               if inim.timer_animation <= 0 then --Checa se estれく na hora de trocar o sprite

               if inim.sprite_atual == inim.sprite_final or inim.sprite_atual == 0 then --retorna pro inicio da animaれせれこo
                    inim.sprite_atual = inim.sprite_inicial;
                    inim.timer_animation = inim.delay_animacao;   

               else --passa para o prれはximo
                    inim.sprite_atual +=1;
                    inim.timer_animation = inim.delay_animacao;   
               end
          else 
               inim.timer_animation -=1;
          end
end

function draw_inimgo()
     for inimigo in all(inimigos) do
          spr(inimigo.sprite_atual,inimigo.x,inimigo.y,inimigo.largura,inimigo.altura);
     end
end
-->8
--Colision e Hitboxes
function colidir(a, b)
    -- Verifica se os retれけngulos Nれ⬇️O estれこo separados em nenhum eixo
    local colidiu = (
     (a.hitbox.right > b.hitbox.left) and 
     (a.hitbox.left < b.hitbox.right) and
     (a.hitbox.bottom > b.hitbox.top) and
     (a.hitbox.top < b.hitbox.bottom)
     )
    return colidiu
end

-- function colidir(ponto, circulo)
 
--     -- distれけncia ao quadrado (evita sqrt se possれとvel)
--     local dx = circulo.x - ponto.x
--     local dy = circulo.y - ponto.y
--     local dist2 = dx*dx + dy*dy

--     return dist2 < circulo.raio*circulo.raio
-- end


function atualizar_hitbox(persona, dados)
     persona.hitbox = {
               left = persona.x + dados.left;
               right = persona.x + dados.right;
               top = persona.y + dados.top;
               bottom = persona.y + dados.bottom;
          }
end

-->8
--hitboxes e inimigos (Constantes imutáveis)

hitbox_player = { --Sempre vai do 0 ao 7, pois comeれせa no pixel 1,1
     left = 1; --Serれく o pixel inicial
     right = 6; -- A posiれせれこo da paralela
     top = 0;
     bottom = 7;
}

hitbox_inimigo = { --do 0 ao 7
     left = 0; --Serれく o pixel inicial
     right = 7; -- A posiれせれこo da paralela
     top = 0;
     bottom = 5;
}

hitbox_bala = {
     left = 1; --Serれく o pixel inicial
     right = 4; -- A posiれせれこo da paralela
     top = 0;
     bottom = 6;  
}

 hitbox_bala_inimiga = {
     left = 1;
     right = 6;
     top = 1;
     bottom = 6;
}

--[tipos: ataque, voar, atirar]

dados_inimigos = {
     {
          id = 1;
          hp = 3;
          sprite_inicial = 28;
          sprite_final = 31;
          speed_x = 0;
          speed_y = 1;
          largura = 1;
          altura = 1;
          tipo = "idle";
          delay_acao = 5 * var.fps;
          delay_animacao = 0.1 * var.fps;
          hitbox = {
               left = 0; --Serれく o pixel inicial
               right = 7; -- A posiれせれこo da paralela
               top = 0;
               bottom = 5;
          }
     },
     {
          id = 2;
          hp = 5;
          sprite_inicial = 24;
          sprite_final = 27;
          speed_x = 0;
          speed_y = 0.5;
          largura = 1;
          altura = 1;
          tipo="atirador";
          delay_acao = 2 * var.fps;
          delay_animacao = 0.3 * var.fps;
          hitbox = {
               left = 0; --Serれく o pixel inicial
               right = 7; -- A posiれせれこo da paralela
               top = 0;
               bottom = 5;
          }
     },
     {
          id = 3;
          hp = 1;
          sprite_inicial = 20;
          sprite_final = 23;
          speed_x = 0;
          speed_y = 2;
          largura = 1;
          altura = 1;
          tipo = "ariete";
          delay_acao = 0 * var.fps;
          delay_animacao = 0.1 * var.fps;
          hitbox = {
               left = 0; --Serれく o pixel inicial
               right = 7; -- A posiれせれこo da paralela
               top = 0;
               bottom = 5;
          }
     },
}

     projeteis_inimigos = {
          {id = 2, qtd = 10},
     }
-->8
--waves

function draw_wave()
     draw_jogo();
     if wave <= var.quantia_waves  then
          print('wave '..wave,50,64,11);
     end
end

function update_wave()
     id_inimigos_hordas = {
          {1,2,3,1,2},
          {1,1,1,1,1,1},
          {3,3,3,3,3,3,3},
          {2,1,1,1,2,3},
          {3,3,3,2,1},
     }
     if wave <= var.quantia_waves  then 
          horda_atual = id_inimigos_hordas[wave];
          update_jogo();
          quantia_inimigos = #id_inimigos_hordas[wave];
     else
          modo='start';
     end


     if trava_wave > 0  then
          trava_wave-=1;
     else
          for id in all(horda_atual) do
               criar_inimgo(id);
          end
          modo='jogo';
     end
end
-->8
--Paletas
paleta_explosion_inim = {8,9,10,5};
paleta_explosion_player = {7,12,1,6}


__gfx__
00000000000820000008800000028000777777776666066600000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000008200000088000000280007ccc8cc70010011600000000000000000099000000022000000880000000000000000000000000000000000000000000
0070070000288200002882000002820078888a8762002400000000000000000009a7900000288200008ee8000000000000000000000000000000000000000000
0007700002c88200008cc80000288c007cccaaa761100046000000000000000009aa9000028ee82008e77e800000000000000000000000000000000000000000
0007700028ce882008e7ce800028ec8078888a87622200260000000000000000099a9000028ee82008e77e800000000000000000000000000000000000000000
0070070028668820886666880288668277cc8c776600011600000000000000000099000000288200008ee8000000000000000000000000000000000000000000
0000000028888e20e888888e02e88882077c87700601066000000000000000000009000000022000000880000000000000000000000000000000000000000000
00000000028882000288882000288820007777000066060000000000000000000000000000000000000000000000000000000000000000000000000000000000
03300330033003300330033003300330000cc000000cc000000cc000000cc0000055550000566500005665000062260009000090090000900900009009000090
3bb33bb33bb33bb33bb33bb33bb33bb300cccc0000cccc0000cccc0000cccc00056666500566665006622660062882609a9009a99a9009a99a9009a99a9009a9
3bbbbbb33bbbbbb33bbbbbb33bbbbbb308688680086868600686866008686680566666655662266556288265628ee8269aa99aa99aa99aa99aa99aa99aa99aa9
3b67c6b33b67c6b33b67c6b33b67c6b3866886688688688668868866686886685666666566288266628ee82628e77e829a0aa0a99a0aa0a99a0aa0a99a0aa0a9
037cc730037cc730037cc730037cc730886886888886668888666888886686885666666566288266628ee82628e77e829a0aa0a99a0aa0a99a0aa0a99a0aa0a9
0036630000366300303663030036630028888882288888852888888528888882566666655662266556288265628ee82609aaaa9009aaaa9009aaaa9009aaaa90
03033030030330303303303303033030025225200525552002555250025525500566665005666650066226600628826090999909009999000999999099999999
03000030300000030000000030000003000000000000000000000000000000000055550000566500005665000062260009900990999009999900009990000009
__sfx__
000705023d050326502d1502d1502f1502c05028050220501d0501605010050090500305001050000500105000050000500105005050040500305003050020500005000000000000000000000000000000000000
00010000395503755033550315502f5502d5502a5502855026550225501f5501d5501a5501755013550115500e5500d5500000000000000000000000000000000000000000000000000000000000000000000000
0002000032750367503a7503e7503a45039450364503445031450346502f6502965025650226501e6501b6501965016650146501265011650106500f6500d6500b6500a650086500765007650000000000000000
00010000393503535032350303502e3502b3502635023350213501c3501a35017350133500e3500a3500030000300003000030000300003000030000300003000030000300003000030000300003000030000300

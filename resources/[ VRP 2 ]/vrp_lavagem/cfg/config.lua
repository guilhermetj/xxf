------------------------------------------------------
cfg = {}
-------------------------------------------------------------------------------------------------------------------------------------
---------CONFIGURAÇÕES
-------------------------------------------------------------------------------------------------------------------------------------
cfg.lavagem = { --Coordenadas dos pontos de Hack
	{94.91,-1294.02,29.27},  -- 1 CORDENADA
	{-61.11,984.19,234.59},-- 2 CORDENADA    
}

cfg.lavagemcoord = { 
	{94.91,-1294.02,29.27},-- 1 CORDENADA
	{-61.11,984.19,234.59},-- 2 CORDENADA
}
cfg.heading = 0.0

cfg.marker = { --Markers dos pontos de Hack
	idmarker = 27,
	x1 = 1.501,
	y1 = 1.5001,
	z1 = 5.2001,
	r = 255,
	g = 0,
	b = 0,
	a = -15,
	pula = 0,
	gira = 1  
}

--cfg.blip = {
  --id = 521, -- ID DO BLIP
  --cor = 1, --COR DO BLIP
  --escala = 0.8, --ESCALA DO BLIP(0.0 até 1.0)
  --nome = "Lavagem de Dinheiro" --NOME DO BLIP
--}

cfg.permissao = "Lavagem" --PERMISSÃO PARA USAR A PLATAFORMA

cfg.lavagemporcento = 0.93

return cfg
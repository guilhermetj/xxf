Config_client = {}

Config_client = {
    price = 100,
    textoConfirm = true, -- Coloque true caso queira um texto 3d
    texto = "~b~[Loja de roupas]\n~w~Pressione ~g~[E]~w~ para acessar a loja", -- Texto 3d q aparecerá
    blipConfirm = true, -- Coloque true caso queira um blip 3d
    blip = 27, -- Blip q vai ser addd
    invisivel = false, -- Deixe true caso um player não veja o outro ao entrar na loja (vai pesar mais o script)
    url = "http://127.0.0.1/roupas/", -- Url das suas imagens do xampp
    markerConfirmation = false, -- Coloque false caso não queira que a loja e roupas defina seus markers
    markerId = 73, -- Numero do marker
    markerColor = 4, -- Cor do marker
    markerName = "Loja de roupas", -- Nome no marker
    lojaderoupa = {
        -- LOJA DE ROUPA 01
        { name = "Loja de Roupas", id = 73, color = 13, x = 70.87, y = -1399.49, z = 29.39},
        { name = "Loja de Roupas", x = 72.41, y = -1399.49, z = 29.39 },
        { name = "Loja de Roupas", x = 73.85, y = -1399.49, z = 29.39 },
        { name = "Loja de Roupas", x = 75.37, y = -1399.49, z = 29.39},
        { name = "Loja de Roupas", x = 100.48, y = 3615.57, z = 40.92},
        { name = "Loja de Roupas", x = 105.2, y = -1303.34, z = 28.8},
        { name = "Loja de Roupas", x = 103.76, y = -1301.1, z = 28.77},
        { name = "Loja de Roupas", x = 956.97, y = -965.2, z = 39.77},
        { name = "Loja de Roupas", x = 755.45, y = -543.9, z = 28.65},
        { name = "Loja de Roupas", x = -1093.52, y = -832.63, z = 14.29},
        { name = "Loja de Roupas", x = 3038.83, y = -4687.78, z = 6.08},
        { name = "Loja de Roupas", x = 8.68, y = 528.46, z = 170.64},
        { name = "Loja de Roupas", x = -1105.15, y = -1700.59, z = 4.38},
        { name = "Loja de Roupas", x = -1182.04, y = 297.54, z = 73.65},
        { name = "Loja de Roupas", x = 393.43, y = 278.62, z = 95.0},
        { name = "Loja de Roupas", x = 85.81, y = 293.36, z = 110.21},
        { name = "Loja de Roupas", x = -442.94, y = -311.36, z = 34.92},
        { name = "Loja de Roupas", x = 1707.77, y = 1038.25, z = 160.03},
        { name = "Loja de Roupas", x = -634.61, y = 226.31, z = 81.89},
        { name = "Loja de Roupas", x = 1311.23, y = -211.46, z = 129.24},
        { name = "Loja de Roupas", x = -944.29, y = 473.88, z = 74.93},
        -- LOJA DE ROUPA PRA�A
        { name = "Loja de Roupas", x = 2765.04, y = -1539.47, z = 1.24, provador = {x = 2765.04, y = -1539.47, z = 1.24, heading = 244.75}},
        { name = "Loja de Roupas", x = 2775.92, y = -1544.64, z = 1.3, provador = {x = 2775.92, y = -1544.64, z = 1.3, heading = 288.46}},

        -- LOJA DE ROUPA 02
        { name = "Loja de Roupas", id = 73, color = 13, x = 430.1, y = -799.67, z = 29.52, provador = {x = 430.1, y = -799.67, z = 29.52, heading = 177.1}},
        { name = "Loja de Roupas", x = 428.62, y = -799.67, z = 29.52, provador = {x = 428.62, y = -799.67, z = 29.52, heading = 173.11}},
        { name = "Loja de Roupas", x = 427.06, y = -799.67, z = 29.52, provador = {x = 427.06, y = -799.67, z = 29.52, heading = 192.52}},
        { name = "Loja de Roupas", x = 425.62, y = -799.67, z = 29.52, provador = {x = 425.62, y = -799.67, z = 29.52, heading = 181.76}},
    
        -- LOJA DE ROUPA 03
        { name = "Loja de Roupas", id = 73, color = 13, x = 128.63, y = -220.14, z = 54.56, provador = {x = 128.63, y = -220.14, z = 54.56, heading = 115.46}},
        { name = "Loja de Roupas", x = 129.23, y = -218.53, z = 54.56, provador = {x = 129.23, y = -218.53, z = 54.56, heading = 107.44}},
        { name = "Loja de Roupas", x = 129.94, y = -216.27, z = 54.56, provador = {x = 129.94, y = -216.27, z = 54.56, heading = 128.95}},
        { name = "Loja de Roupas", x = 130.7, y = -214.05, z = 54.56, provador = {x = 130.7, y = -214.05, z = 54.56, heading = 95.77}},
    
        -- LOJA DE ROUPA 04
        { name = "Loja de Roupas", id = 73, color = 13, x = -165.9, y = -310.94, z = 39.74, provador = {x = -165.9, y = -310.94, z = 39.74, heading = 248.85}},
        { name = "Loja de Roupas", x = -165.6, y = -309.52, z = 39.74, provador = {x = -165.6, y = -309.52, z = 39.74, heading = 251.32}},
        { name = "Loja de Roupas", x = -165.09, y = -308.15, z = 39.74, provador = {x = -165.09, y = -308.15, z = 39.74, heading = 213.57}},
        { name = "Loja de Roupas", x = -164.74, y = -306.74, z = 39.74, provador = {x = -164.74, y = -306.74, z = 39.74, heading = 286.29}},
    
        -- LOJA DE ROUPA 05
        { name = "Loja de Roupas", id = 73, color = 13, x = -830.4, y = -1072.88, z = 11.33, provador = {x = -830.4, y = -1072.88, z = 11.33, heading = 292.33}},
        { name = "Loja de Roupas", x = -829.63, y = -1074.25, z = 11.33, provador = {x = -829.63, y = -1074.25, z = 11.33, heading = 311.26}},
        { name = "Loja de Roupas", x = -828.85, y = -1075.51, z = 11.33, provador = {x = -828.85, y = -1075.51, z = 11.33, heading = 304.74}},
        { name = "Loja de Roupas", x = -828.07, y = -1076.79, z = 11.33, provador = {x = -828.07, y = -1076.79, z = 11.33, heading = 312.29}},
    
        -- LOJA DE ROUPA 06
        { name = "Loja de Roupas", id = 73, color = 13, x = -714.24, y = -145.74, z = 37.42, provador = {x = -714.24, y = -145.74, z = 37.42, heading = 141.83}},
        { name = "Loja de Roupas", x = -713.1, y = -147.37, z = 37.42, provador = {x = -713.1, y = -147.37, z = 37.42, heading = 130.49}},
        { name = "Loja de Roupas", x = -712.46, y = -148.6, z = 37.42, provador = {x = -712.46, y = -148.6, z = 37.42, heading = 80.07}},
        { name = "Loja de Roupas", x = -711.74, y = -149.56, z = 37.42, provador = {x = -711.74, y = -149.56, z = 37.42, heading = 178.12}},
    
        -- LOJA DE ROUPA 07
        { name = "Loja de Roupas", id = 73, color = 13, x = -1198.0, y = -769.28, z = 17.32, provador = {x = -1198.0, y = -769.28, z = 17.32, heading = 222.52}}, 
        { name = "Loja de Roupas", x = -1199.6, y = -770.57, z = 17.32, provador = {x = -1199.6, y = -770.57, z = 17.32, heading = 217.49}}, 
        { name = "Loja de Roupas", x = -1201.26, y = -771.96, z = 17.32, provador = {x = -1201.26, y = -771.96, z = 17.32, heading = 179.08}}, 
        { name = "Loja de Roupas", x = -1202.65, y = -773.12, z = 17.32, provador = {x = -1202.65, y = -773.12, z = 17.32, heading = 214.11}}, 
    
        -- LOJA DE ROUPA 08 
        { name = "Loja de Roupas", id = 73, color = 13, x = -1448.24, y = -235.21, z = 49.82, provador = {x = -1448.24, y = -235.21, z = 49.82, heading = 95.97}},
        { name = "Loja de Roupas", x = -1446.95, y = -233.58, z = 49.82, provador = {x = -1446.95, y = -233.58, z = 49.82, heading = 10.74}},
        { name = "Loja de Roupas", x = -1445.87, y = -232.37, z = 49.82, provador = {x = -1445.87, y = -232.37, z = 49.82, heading = 56.05}},
        { name = "Loja de Roupas", x = -1444.85, y = -231.29, z = 49.82, provador = {x = -1444.85, y = -231.29, z = 49.82, heading = 50.59}},
    
        -- LOJA DE ROUPA 09
        { name = "Loja de Roupas", id = 73, color = 13, x = -3167.29, y = 1047.19, z = 20.87, provador = {x = -3167.29, y = 1047.19, z = 20.87, heading = 84.66}},
        { name = "Loja de Roupas", x = -3166.22, y = 1049.4, z = 20.87, provador = {x = -3166.22, y = 1049.4, z = 20.87, heading = 95.4}},
        { name = "Loja de Roupas", x = -3165.14, y = 1051.79, z = 20.87, provador = {x = -3165.14, y = 1051.79, z = 20.87, heading = 74.04}},
        { name = "Loja de Roupas", x = -3164.5, y = 1053.44, z = 20.87, provador = {x = -3164.5, y = 1053.44, z = 20.87, heading = 66.15}},
    
        -- LOJA DE ROUPA 10
        { name = "Loja de Roupas", id = 73, color = 13, x = -1109.44, y = 2709.55, z = 19.11, provador = {x = -1109.44, y = 2709.55, z = 19.11, heading = 311.52}},
        { name = "Loja de Roupas", x = -1108.37, y = 2708.43, z = 19.11, provador = {x = -1108.37, y = 2708.43, z = 19.11, heading = 314.75}},
        { name = "Loja de Roupas", x = -1107.43, y = 2707.32, z = 19.11, provador = {x = -1107.43, y = 2707.32, z = 19.11, heading = 307.39}},
        { name = "Loja de Roupas", x = -1106.33, y = 2706.17, z = 19.11, provador = {x = -1106.33, y = 2706.17, z = 19.11, heading = 325.3}},
    
        -- LOJA DE ROUPA 11
        { name = "Loja de Roupas", id = 73, color = 13, x = 612.87, y = 2758.49, z = 42.09, provador = {x = 612.87, y = 2758.49, z = 42.09, heading = 292.48}},
        { name = "Loja de Roupas", x = 613.12, y = 2756.56, z = 42.09, provador = {x = 613.12, y = 2756.56, z = 42.09, heading = 283.19}},
        { name = "Loja de Roupas", x = 613.13, y = 2753.29, z = 42.09, provador = {x = 613.13, y = 2753.29, z = 42.09, heading = 264.95}},
        { name = "Loja de Roupas", x = 613.26, y = 2751.39, z = 42.09, provador = {x = 613.26, y = 2751.39, z = 42.09, heading = 280.25}},
        
        -- LOJA DE ROUPA 12
        { name = "Loja de Roupas", id = 73, color = 13, x = 1190.08, y = 2714.76, z = 38.23, provador = {x = 1190.08, y = 2714.76, z = 38.23, heading = 267.87}},
        { name = "Loja de Roupas", x = 1190.18, y = 2713.24, z = 38.23, provador = {x = 1190.18, y = 2713.24, z = 38.23, heading = 276.04}},
        { name = "Loja de Roupas", x = 1190.09, y =  2711.73, z = 38.23, provador = {x = 1190.09, y =  2711.73, z = 38.23, heading = 280.45}},
        { name = "Loja de Roupas", x = 1190.07, y = 2710.23, z = 38.23, provador = {x = 1190.07, y = 2710.23, z = 38.23, heading = 283.45}},
    
        -- LOJA DE ROUPA 13
        { name = "Loja de Roupas", id = 73, color = 13, x = 1697.49, y = 4829.94, z = 42.07, provador = {x = 1697.49, y = 4829.94, z = 42.07, heading = 179.54}},
        { name = "Loja de Roupas", x = 1695.95, y = 4829.75, z = 42.07, provador = {x = 1695.95, y = 4829.75, z = 42.07, heading = 201.35}},
        { name = "Loja de Roupas", x = 1694.54, y = 4829.57, z = 42.07, provador = {x = 1694.54, y = 4829.57, z = 42.07, heading = 186.38}},
        { name = "Loja de Roupas", x = 1693.04, y = 4829.35, z = 42.07, provador = {x = 1693.04, y = 4829.35, z = 42.07, heading = 190.91}},
    
         -- LOJA DE ROUPA 14
         { name = "Loja de Roupas", id = 73, color = 13, x = 12.7, y = 6513.6, z = 31.878, provador = {x = 12.7, y = 6513.6, z = 31.878, heading = 134.57}},    
         { name = "Loja de Roupas", x = 11.7, y = 6514.76, z = 31.878, provador = {x = 11.7, y = 6514.76, z = 31.878, heading = 134.28}},    
         { name = "Loja de Roupas", x = 10.74, y = 6515.8, z = 31.878, provador = {x = 10.74, y = 6515.8, z = 31.878, heading = 138.6}},    
         { name = "Loja de Roupas", x = 9.66, y = 6516.88, z = 31.878, provador = {x = 9.66, y = 6516.88, z = 31.878, heading = 150.98}},  
         { name = "", x = 314.9, y = -601.63, z = 43.3, provador = {x = 314.9, y = -601.63, z = 43.3, heading = 62.81}},  
        
         --favelas x = 

         { name = "Loja de Roupas", x = -1539.32, y = 141.63, z = 60.45, provador = {x = -1539.32, y = 141.63, z = 60.45, heading = 337.98}},
         { name = "Loja de Roupas", x = -1522.25, y = 133.52, z = 60.44, provador = {x = -1522.25, y = 133.52, z = 60.44, heading = 337.98}},
         --casa samantha
         { name = "Loja de Roupas", x = -651.77, y = 872.54, z = 205.68, provador = {x = -651.77, y = 872.54, z = 205.68, heading = 337.98}},
         -- casa hypee
         { name = "Loja de Roupas", x = -3004.44, y = 756.78, z = 10.75, provador = {x = -3004.44, y = 756.78, z = 10.75, heading = 233.98}},
         -- casa erika
         { name = "Loja de Roupas", x = -2584.43, y = 1885.64, z = 140.87, provador = {x = -2584.43, y = 1885.64, z = 140.87, heading = 337.98}},
         -- LSCUSTOM
         { name = "Loja de Roupas", x = -341.41, y = -161.96, z = 44.59, provador = {x = -341.41, y = -161.96, z = 44.59, heading = 267,12 }},
         { name = "Loja de Roupas", x = 1272.17, y = -140.03, z = 94.81, provador = {x = 1272.17, y = -140.03, z = 94.81, heading = 267,12 }},
         { name = "Loja de Roupas", x = 1711.59, y = 1085.57, z = 136.58, provador = {x = 1711.59, y = 1085.57, z = 136.58, heading = 267,12 }},
         { name = "Loja de Roupas", x = 964.68, y = 17.66, z = 75.75, provador = {x = 964.68, y = 17.66, z = 75.75, heading = 267,12 }},
         { name = "Loja de Roupas", x = -552.33, y = 278.36, z = 82.18, provador = {x = -552.33, y = 278.36, z = 82.18, heading = 267,12 }},
         { name = "Loja de Roupas", x = -1887.23, y = 2070.11, z = 145.58, provador = {x = -1887.23, y = 2070.11, z = 145.58, heading = 267,12 }},
         { name = "Loja de Roupas", x = -2675.03, y = 1303.97, z = 152.02, provador = {x = -2675.03, y = 1303.97, z = 152.02, heading = 267,12 }},
         { name = "Loja de Roupas", x = 1103.69, y = 196.18, z = -49.44, provador = {x = 1103.69, y = 196.18, z = -49.44, heading = 267,12 }},
         { name = "Loja de Roupas", x = 975.21, y = 64.89, z = 116.17, provador = {x = 975.21, y = 64.89, z = 116.17, heading = 267,12 }},
         { name = "Loja de Roupas", x = 902.54, y = -2115.0, z = 30.78, provador = {x = 902.54, y = -2115.0, z = 30.78, heading = 267,12 }},
         { name = "Loja de Roupas", x = 5013.77, y = -5752.04, z = 28.85, provador = {x = 5013.77, y = -5752.04, z = 28.85, heading = 267,12 }},
    }  
    
}




local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP") 

dPN = {}
Tunnel.bindInterface("dpn_criacao",dPN)
Proxy.addInterface("dpn_criacao",dPN)
dPNserver = Tunnel.getInterface("dpn_criacao")

local naentrada = false
Camera = {}
local doStatus = -1
local freezedOnTop = true
local tiraomapa = true

Camera.entity       = nil
Camera.position     = vector3(0.0, 0.0, 0.0)
Camera.currentView  = 'corpo'
Camera.active       = false
Camera.radius       = 1.25
Camera.angleX       = 30.0
Camera.angleY       = 0.0
Camera.mouseX       = 0
Camera.mouseY       = 0

Camera.radiusMin    = 1.0
Camera.radiusMax    = 2.25
Camera.angleYMin    = -30.0
Camera.angleYMax    = 80.0

local parts = {  
    mascara = 1, 
    mao = 3,
    calca = 4,
    mochila = 5,
    sapato = 6,
    gravata = 7,
    camisa = 8,
	colete = 9,
    jaqueta = 11,
    bone = "p0",
    oculos = "p1",
    brinco = "p2",
    relogio = "p6",
    bracelete = "p7"
}

local carroCompras = {
    mascara = false,
    mao = false,
    calca = false,
    mochila = false,
    sapato = false,
    gravata = false,
    camisa = false,
	colete = false,
    jaqueta = false,
    bone = false,
    oculos = false,
    brinco = false,
    relogio = false,
    bracelete = false
}

local old_custom = {}

local valor = 0
local precoTotal = 0

local in_loja = false
local atLoja = false

local currentCharacterMode = { fathersID = 0, mothersID = 0, skinColor = 0, shapeMix = 0.0, eyesColor = 0, eyebrowsHeight = 0,
eyebrowsWidth = 0, noseWidth = 0, noseHeight = 0, noseLength = 0, noseBridge = 0, noseTip = 0, noseShift = 0, cheekboneHeight = 0,
cheekboneWidth = 0, cheeksWidth = 0, lips = 0, jawWidth = 0, jawHeight = 0, chinLength = 0, chinPosition = 0, chinWidth = 0, 
chinShape = 0, neckWidth = 0, hairModel = 4, firstHairColor = 0, secondHairColor = 0, eyebrowsModel = 0, eyebrowsColor = 1, 
beardModel = -1, beardColor = 0, chestModel = -1, chestColor = 0, blushModel = -1, blushColor = 0, lipstickModel = -1, lipstickColor = 0, 
blemishesModel = -1, ageingModel = -1, complexionModel = -1, sundamageModel = -1, frecklesModel = -1, makeupModel = -1 }

RegisterNUICallback("updateParents",function(data,cb)
    local valor = data.value
    if data.key == "fathersID" then
        currentCharacterMode.fathersID = tonumber(valor)
    elseif data.key == "mothersID" then
        currentCharacterMode.mothersID = tonumber(valor) 
    end
    SetPedHeadBlendData(PlayerPedId(), currentCharacterMode.fathersID, currentCharacterMode.mothersID, 0, currentCharacterMode.skinColor,0, 0, moreValue(currentCharacterMode.shapeMix),0,0,false)
end)



RegisterNUICallback("updateInputs",function(data,cb)
    local valor = tonumber(data.valor)
    local tipo = tostring(data.tipo) 
    local ped = PlayerPedId()
    if tipo == "shapeMix" then
        currentCharacterMode.shapeMix = valor

    elseif tipo == "eyebrowsModel" then
    currentCharacterMode.eyebrowsModel = tonumber(valor)

    elseif tipo == "eyebrowsWidth" then
    currentCharacterMode.eyebrowsWidth = valor

    elseif tipo == "noseWidth" then
    currentCharacterMode.noseWidth = valor

    elseif tipo == "noseLength" then
    currentCharacterMode.noseLength = valor

    elseif tipo == "noseHeight" then
    currentCharacterMode.noseHeight = valor

elseif tipo == "eyebrowsHeight" then
    currentCharacterMode.eyebrowsHeight = valor

elseif tipo == "noseBridge" then
    currentCharacterMode.noseBridge = valor

elseif tipo == "noseTip" then
    currentCharacterMode.noseTip = valor

elseif tipo == "chinLength" then
    currentCharacterMode.chinLength = valor

elseif tipo == "chinWidth" then
    currentCharacterMode.chinWidth = valor

elseif tipo == "chinShape" then
    currentCharacterMode.chinShape = valor

elseif tipo == "chinPosition" then
    currentCharacterMode.chinPosition = valor

elseif tipo == "lips" then
    currentCharacterMode.lips = valor

elseif tipo == "cheekboneHeight" then
    currentCharacterMode.cheekboneHeight = valor

elseif tipo == "jawWidth" then
    currentCharacterMode.jawWidth = valor

elseif tipo == "cheekboneWidth" then
    currentCharacterMode.cheekboneWidth = valor

elseif tipo == "jawHeight" then
    currentCharacterMode.jawHeight = valor

elseif tipo == "neckWidth" then
    currentCharacterMode.neckWidth = valor

elseif tipo == "lipstickModel" then
    currentCharacterMode.lipstickModel = valor

elseif tipo == "ageingModel" then
    currentCharacterMode.ageingModel = valor

elseif tipo == "beardModel" then
    currentCharacterMode.beardModel = valor

elseif tipo == "blushModel" then
    currentCharacterMode.blushModel = valor

elseif tipo == "makeupModel" then
    currentCharacterMode.makeupModel = valor

elseif tipo == "chestModel" then
    currentCharacterMode.chestModel = valor

elseif tipo == "sundamageModel" then
    currentCharacterMode.sundamageModel = valor

elseif tipo == "blemishesModel" then
    currentCharacterMode.blemishesModel = valor

elseif tipo == "complexionModel" then
    currentCharacterMode.complexionModel = valor

elseif tipo == "frecklesModel" then
    currentCharacterMode.frecklesModel = valor
    
    end
    updateInput(tipo)
end)

function updateInput(tipo)
    local ped = PlayerPedId()
    if tipo ~= "preset" then
        if tipo == "shapeMix" then
            SetPedHeadBlendData(ped,currentCharacterMode.fathersID, currentCharacterMode.mothersID, 0, currentCharacterMode.skinColor,0, 0, moreValue(currentCharacterMode.shapeMix),0,0,false)
        elseif tipo == "eyebrowsModel" then
            SetPedHeadOverlay(ped,2,currentCharacterMode.eyebrowsModel,0.99)
            SetPedHeadOverlayColor(ped,2,1,currentCharacterMode.eyebrowsColor,currentCharacterMode.eyebrowsColor)
        elseif tipo == "eyebrowsHeight" then
            SetPedFaceFeature(ped,6,currentCharacterMode.eyebrowsHeight)
        elseif tipo == "eyebrowsWidth" then
            SetPedFaceFeature(ped,7,currentCharacterMode.eyebrowsWidth)
        elseif tipo == "noseWidth" then
            SetPedFaceFeature(ped,0,currentCharacterMode.noseWidth)
        elseif tipo == "noseHeight" then
            SetPedFaceFeature(ped,1,currentCharacterMode.noseHeight)
        elseif tipo == "noseLength" then
            SetPedFaceFeature(ped,2,currentCharacterMode.noseLength)
        elseif tipo == "noseBridge" then
            SetPedFaceFeature(ped,3,currentCharacterMode.noseBridge)
        elseif tipo == "noseTip" then
            SetPedFaceFeature(ped,4,currentCharacterMode.noseTip)
        elseif tipo == "chinLength" then
            SetPedFaceFeature(ped,15,currentCharacterMode.chinLength)
        elseif tipo == "chinWidth" then
            SetPedFaceFeature(ped,17,currentCharacterMode.chinWidth)
        elseif tipo == "chinShape" then
            SetPedFaceFeature(ped,18,currentCharacterMode.chinShape)
        elseif tipo == "chinPosition" then
            SetPedFaceFeature(ped,16,currentCharacterMode.chinPosition)
        elseif tipo == "lips" then
            SetPedFaceFeature(ped,12,currentCharacterMode.lips)
        elseif tipo == "cheekboneHeight" then
            SetPedFaceFeature(ped,8,currentCharacterMode.cheekboneHeight)
        elseif tipo == "cheekboneWidth" then
            SetPedFaceFeature(ped,9,currentCharacterMode.cheekboneWidth)
        elseif tipo == "jawWidth" then
            SetPedFaceFeature(ped,13,currentCharacterMode.jawWidth)
        elseif tipo == "jawHeight" then
            SetPedFaceFeature(ped,14,currentCharacterMode.jawHeight)
        elseif tipo == "neckWidth" then
            SetPedFaceFeature(ped,19,currentCharacterMode.neckWidth)
        elseif tipo == "beardModel" then
            SetPedHeadOverlay(ped,1,currentCharacterMode.beardModel,0.99)
            SetPedHeadOverlayColor(ped,1,1,currentCharacterMode.beardColor,currentCharacterMode.beardColor)
        elseif tipo == "lipstickModel" then
            SetPedHeadOverlay(ped,8,currentCharacterMode.lipstickModel,0.99)
            SetPedHeadOverlayColor(ped,8,2,currentCharacterMode.lipstickColor,currentCharacterMode.lipstickColor)
        elseif tipo == "makeupModel" then
            SetPedHeadOverlay(ped,4,currentCharacterMode.makeupModel,0.99)
            SetPedHeadOverlayColor(ped,4,0,0,0)
        elseif tipo == "blushModel" then
            SetPedHeadOverlay(ped,5,currentCharacterMode.blushModel,0.99)
            SetPedHeadOverlayColor(ped,5,2,currentCharacterMode.blushColor,currentCharacterMode.blushColor)
        elseif tipo == "chestModel" then
            SetPedHeadOverlay(ped,10,currentCharacterMode.chestModel,0.99)
            SetPedHeadOverlayColor(ped,10,1,currentCharacterMode.chestColor,currentCharacterMode.chestColor)
        elseif tipo == "sundamageModel" then
            SetPedHeadOverlay(ped,7,currentCharacterMode.sundamageModel,0.99)
            SetPedHeadOverlayColor(ped,7,0,0,0)
        elseif tipo == "ageingModel" then
            SetPedHeadOverlay(ped,3,currentCharacterMode.ageingModel,0.99)
            SetPedHeadOverlayColor(ped,3,0,0,0)
        elseif tipo == "blemishesModel" then
            SetPedHeadOverlay(ped,0,currentCharacterMode.blemishesModel,0.99)
            SetPedHeadOverlayColor(ped,0,0,0,0)
        elseif tipo == "frecklesModel" then
            SetPedHeadOverlay(ped,9,currentCharacterMode.frecklesModel,0.99)
            SetPedHeadOverlayColor(ped,9,0,0,0)
        elseif tipo == "complexionModel" then
            SetPedHeadOverlay(ped,6,currentCharacterMode.complexionModel,0.99)
            SetPedHeadOverlayColor(ped,6,0,0,0)
        end
        
    else
        SetPedHeadOverlay(ped,2,currentCharacterMode.eyebrowsModel,0.99)
        SetPedHeadOverlayColor(ped,2,1,currentCharacterMode.eyebrowsColor,currentCharacterMode.eyebrowsColor)
        SetPedFaceFeature(ped,6,currentCharacterMode.eyebrowsHeight)
        SetPedFaceFeature(ped,7,currentCharacterMode.eyebrowsWidth)
        SetPedFaceFeature(ped,0,currentCharacterMode.noseWidth)
        SetPedFaceFeature(ped,1,currentCharacterMode.noseHeight)
        SetPedFaceFeature(ped,2,currentCharacterMode.noseLength)
        SetPedFaceFeature(ped,3,currentCharacterMode.noseBridge)
        SetPedFaceFeature(ped,4,currentCharacterMode.noseTip)
        SetPedFaceFeature(ped,15,currentCharacterMode.chinLength)
        SetPedFaceFeature(ped,17,currentCharacterMode.chinWidth)
        SetPedFaceFeature(ped,18,currentCharacterMode.chinShape)
        SetPedFaceFeature(ped,16,currentCharacterMode.chinPosition)
        SetPedFaceFeature(ped,12,currentCharacterMode.lips)
        SetPedFaceFeature(ped,8,currentCharacterMode.cheekboneHeight)
        SetPedFaceFeature(ped,9,currentCharacterMode.cheekboneWidth)
        SetPedFaceFeature(ped,13,currentCharacterMode.jawWidth)
        SetPedFaceFeature(ped,14,currentCharacterMode.jawHeight)
        SetPedFaceFeature(ped,19,currentCharacterMode.neckWidth)
        SetPedHeadOverlay(ped,1,currentCharacterMode.beardModel,0.99)
        SetPedHeadOverlayColor(ped,1,1,currentCharacterMode.beardColor,currentCharacterMode.beardColor)
        SetPedHeadOverlay(ped,8,currentCharacterMode.lipstickModel,0.99)
        SetPedHeadOverlayColor(ped,8,2,currentCharacterMode.lipstickColor,currentCharacterMode.lipstickColor)
        SetPedHeadOverlay(ped,4,currentCharacterMode.makeupModel,0.99)
        SetPedHeadOverlayColor(ped,4,0,0,0)
        SetPedHeadOverlay(ped,5,currentCharacterMode.blushModel,0.99)
        SetPedHeadOverlayColor(ped,5,2,currentCharacterMode.blushColor,currentCharacterMode.blushColor)
        SetPedHeadOverlay(ped,10,currentCharacterMode.chestModel,0.99)
        SetPedHeadOverlayColor(ped,10,1,currentCharacterMode.chestColor,currentCharacterMode.chestColor)
        SetPedHeadOverlay(ped,7,currentCharacterMode.sundamageModel,0.99)
        SetPedHeadOverlayColor(ped,7,0,0,0)
        SetPedHeadOverlay(ped,3,currentCharacterMode.ageingModel,0.99)
        SetPedHeadOverlayColor(ped,3,0,0,0)
        SetPedHeadOverlay(ped,0,currentCharacterMode.blemishesModel,0.99)
        SetPedHeadOverlayColor(ped,0,0,0,0)
        SetPedHeadOverlay(ped,9,currentCharacterMode.frecklesModel,0.99)
        SetPedHeadOverlayColor(ped,9,0,0,0)
        SetPedHeadOverlay(ped,6,currentCharacterMode.complexionModel,0.99)
        SetPedHeadOverlayColor(ped,6,0,0,0)
        SetPedComponentVariation(ped,2,currentCharacterMode.hairModel,0,0)
        SetPedHairColor(ped,currentCharacterMode.firstHairColor,currentCharacterMode.secondHairColor)
    end
end



RegisterNUICallback('setPreset',function(data,cb)
if data.genero == "male" then
    if data.preset == 1 then
        currentCharacterMode.skinColor = Config_client['preset']['male']['1']['cordapele']
        currentCharacterMode.eyesColor = Config_client['preset']['male']['1']['cordoolhos']
        currentCharacterMode.eyebrowsColor = Config_client['preset']['male']['1']['cordasobrancelha']
        currentCharacterMode.firstHairColor =  Config_client['preset']['male']['1']['corprimariadocabelo']
        currentCharacterMode.secondHairColor = Config_client['preset']['male']['1']['corsecundariadocabelo']
        currentCharacterMode.beardColor = Config_client['preset']['male']['1']['cordabarba']
        currentCharacterMode.lipstickColor =  Config_client['preset']['male']['1']['cordobatom']
        currentCharacterMode.blushColor = Config_client['preset']['male']['1']['cordoblush']
        currentCharacterMode.chestColor =  Config_client['preset']['male']['1']['cordopelonopeito']
        currentCharacterMode.fathersID = Config_client['preset']['male']['1']['caradopai']
        currentCharacterMode.mothersID = Config_client['preset']['male']['1']['caradamãe']
        currentCharacterMode.shapeMix = Config_client['preset']['male']['1']['misturadosrostos']
        currentCharacterMode.eyebrowsModel = Config_client['preset']['male']['1']['modelodesobrancelha']
        currentCharacterMode.eyebrowsHeight = Config_client['preset']['male']['1']['larguradatesta']
        currentCharacterMode.eyebrowsWidth = Config_client['preset']['male']['1']['larguradasobrancelha']
        currentCharacterMode.noseWidth = Config_client['preset']['male']['1']['larguradonariz']
        currentCharacterMode.noseLength = Config_client['preset']['male']['1']['comprimentodonariz']
        currentCharacterMode.noseHeight = Config_client['preset']['male']['1']['alturadonariz']
        currentCharacterMode.noseBridge = Config_client['preset']['male']['1']['deslocamentodonariz']
        currentCharacterMode.noseTip = Config_client['preset']['male']['1']['pontadonariz']
        currentCharacterMode.chinLength = Config_client['preset']['male']['1']['comprimentodoqueixo']
        currentCharacterMode.chinWidth = Config_client['preset']['male']['1']['larguradoqueixo']
        currentCharacterMode.chinShape = Config_client['preset']['male']['1']['alturadoqueixo']
        currentCharacterMode.chinPosition = Config_client['preset']['male']['1']['posicaodoqueixo']
        currentCharacterMode.lips = Config_client['preset']['male']['1']['larguradolabios']
        currentCharacterMode.cheekboneHeight = Config_client['preset']['male']['1']['alturadabochecha']
        currentCharacterMode.jawWidth = Config_client['preset']['male']['1']['larguradamandibula']
        currentCharacterMode.cheekboneWidth = Config_client['preset']['male']['1']['largurabochecha']
        currentCharacterMode.jawHeight = Config_client['preset']['male']['1']['alturadamandibula']
        currentCharacterMode.neckWidth = Config_client['preset']['male']['1']['larguradopescoço']
        currentCharacterMode.lipstickModel = Config_client['preset']['male']['1']['modelobatom']
        currentCharacterMode.beardModel = Config_client['preset']['male']['1']['modelobarba']
        currentCharacterMode.blushModel = Config_client['preset']['male']['1']['modeloblush']
        currentCharacterMode.makeupModel = Config_client['preset']['male']['1']['maquiagem']
        currentCharacterMode.chestModel = Config_client['preset']['male']['1']['modelopelonopeito']
        currentCharacterMode.sundamageModel = Config_client['preset']['male']['1']['danosolares']
        currentCharacterMode.blemishesModel = Config_client['preset']['male']['1']['manchas']
        currentCharacterMode.complexionModel = Config_client['preset']['male']['1']['sardas']
        currentCharacterMode.frecklesModel = Config_client['preset']['male']['1']['rugas']
        currentCharacterMode.hairModel = Config_client['preset']['male']['1']['modelocabelo']  
        SetPedHeadBlendData(PlayerPedId(), currentCharacterMode.fathersID, currentCharacterMode.mothersID, 0, currentCharacterMode.skinColor,0, 0, moreValue(currentCharacterMode.shapeMix),0,0,false)
        updateInput("preset")
        updateColors("preset")
    elseif data.preset == 2 then
        currentCharacterMode.skinColor = Config_client['preset']['male']['2']['cordapele']
        currentCharacterMode.eyesColor = Config_client['preset']['male']['2']['cordoolhos']
        currentCharacterMode.eyebrowsColor = Config_client['preset']['male']['2']['cordasobrancelha']
        currentCharacterMode.firstHairColor =  Config_client['preset']['male']['2']['corprimariadocabelo']
        currentCharacterMode.secondHairColor = Config_client['preset']['male']['2']['corsecundariadocabelo']
        currentCharacterMode.beardColor = Config_client['preset']['male']['2']['cordabarba']
        currentCharacterMode.lipstickColor =  Config_client['preset']['male']['2']['cordobatom']
        currentCharacterMode.blushColor = Config_client['preset']['male']['2']['cordoblush']
        currentCharacterMode.chestColor =  Config_client['preset']['male']['2']['cordopelonopeito']
        currentCharacterMode.fathersID = Config_client['preset']['male']['2']['caradopai']
        currentCharacterMode.mothersID = Config_client['preset']['male']['2']['caradamãe']
        currentCharacterMode.shapeMix = Config_client['preset']['male']['2']['misturadosrostos']
        currentCharacterMode.eyebrowsModel = Config_client['preset']['male']['2']['modelodesobrancelha']
        currentCharacterMode.eyebrowsHeight = Config_client['preset']['male']['2']['larguradatesta']
        currentCharacterMode.eyebrowsWidth = Config_client['preset']['male']['2']['larguradasobrancelha']
        currentCharacterMode.noseWidth = Config_client['preset']['male']['2']['larguradonariz']
        currentCharacterMode.noseLength = Config_client['preset']['male']['2']['comprimentodonariz']
        currentCharacterMode.noseHeight = Config_client['preset']['male']['2']['alturadonariz']
        currentCharacterMode.noseBridge = Config_client['preset']['male']['2']['deslocamentodonariz']
        currentCharacterMode.noseTip = Config_client['preset']['male']['2']['pontadonariz']
        currentCharacterMode.chinLength = Config_client['preset']['male']['2']['comprimentodoqueixo']
        currentCharacterMode.chinWidth = Config_client['preset']['male']['2']['larguradoqueixo']
        currentCharacterMode.chinShape = Config_client['preset']['male']['2']['alturadoqueixo']
        currentCharacterMode.chinPosition = Config_client['preset']['male']['2']['posicaodoqueixo']
        currentCharacterMode.lips = Config_client['preset']['male']['2']['larguradolabios']
        currentCharacterMode.cheekboneHeight = Config_client['preset']['male']['2']['alturadabochecha']
        currentCharacterMode.jawWidth = Config_client['preset']['male']['2']['larguradamandibula']
        currentCharacterMode.cheekboneWidth = Config_client['preset']['male']['2']['largurabochecha']
        currentCharacterMode.jawHeight = Config_client['preset']['male']['2']['alturadamandibula']
        currentCharacterMode.neckWidth = Config_client['preset']['male']['2']['larguradopescoço']
        currentCharacterMode.lipstickModel = Config_client['preset']['male']['2']['modelobatom']
        currentCharacterMode.beardModel = Config_client['preset']['male']['2']['modelobarba']
        currentCharacterMode.blushModel = Config_client['preset']['male']['2']['modeloblush']
        currentCharacterMode.makeupModel = Config_client['preset']['male']['2']['maquiagem']
        currentCharacterMode.chestModel = Config_client['preset']['male']['2']['modelopelonopeito']
        currentCharacterMode.sundamageModel = Config_client['preset']['male']['2']['danosolares']
        currentCharacterMode.blemishesModel = Config_client['preset']['male']['2']['manchas']
        currentCharacterMode.complexionModel = Config_client['preset']['male']['2']['sardas']
        currentCharacterMode.frecklesModel = Config_client['preset']['male']['2']['rugas']
        currentCharacterMode.hairModel = Config_client['preset']['male']['2']['modelocabelo']  
        SetPedHeadBlendData(PlayerPedId(), currentCharacterMode.fathersID, currentCharacterMode.mothersID, 0, currentCharacterMode.skinColor,0, 0, moreValue(currentCharacterMode.shapeMix),0,0,false)
        updateInput('preset')
        updateColors("preset")
    elseif data.preset == 3 then
        currentCharacterMode.skinColor = Config_client['preset']['male']['3']['cordapele']
        currentCharacterMode.eyesColor = Config_client['preset']['male']['3']['cordoolhos']
        currentCharacterMode.eyebrowsColor = Config_client['preset']['male']['3']['cordasobrancelha']
        currentCharacterMode.firstHairColor =  Config_client['preset']['male']['3']['corprimariadocabelo']
        currentCharacterMode.secondHairColor = Config_client['preset']['male']['3']['corsecundariadocabelo']
        currentCharacterMode.beardColor = Config_client['preset']['male']['3']['cordabarba']
        currentCharacterMode.lipstickColor =  Config_client['preset']['male']['3']['cordobatom']
        currentCharacterMode.blushColor = Config_client['preset']['male']['3']['cordoblush']
        currentCharacterMode.chestColor =  Config_client['preset']['male']['3']['cordopelonopeito']
        currentCharacterMode.fathersID = Config_client['preset']['male']['3']['caradopai']
        currentCharacterMode.mothersID = Config_client['preset']['male']['3']['caradamãe']
        currentCharacterMode.shapeMix = Config_client['preset']['male']['3']['misturadosrostos']
        currentCharacterMode.eyebrowsModel = Config_client['preset']['male']['3']['modelodesobrancelha']
        currentCharacterMode.eyebrowsHeight = Config_client['preset']['male']['3']['larguradatesta']
        currentCharacterMode.eyebrowsWidth = Config_client['preset']['male']['3']['larguradasobrancelha']
        currentCharacterMode.noseWidth = Config_client['preset']['male']['3']['larguradonariz']
        currentCharacterMode.noseLength = Config_client['preset']['male']['3']['comprimentodonariz']
        currentCharacterMode.noseHeight = Config_client['preset']['male']['3']['alturadonariz']
        currentCharacterMode.noseBridge = Config_client['preset']['male']['3']['deslocamentodonariz']
        currentCharacterMode.noseTip = Config_client['preset']['male']['3']['pontadonariz']
        currentCharacterMode.chinLength = Config_client['preset']['male']['3']['comprimentodoqueixo']
        currentCharacterMode.chinWidth = Config_client['preset']['male']['3']['larguradoqueixo']
        currentCharacterMode.chinShape = Config_client['preset']['male']['3']['alturadoqueixo']
        currentCharacterMode.chinPosition = Config_client['preset']['male']['3']['posicaodoqueixo']
        currentCharacterMode.lips = Config_client['preset']['male']['3']['larguradolabios']
        currentCharacterMode.cheekboneHeight = Config_client['preset']['male']['3']['alturadabochecha']
        currentCharacterMode.jawWidth = Config_client['preset']['male']['3']['larguradamandibula']
        currentCharacterMode.cheekboneWidth = Config_client['preset']['male']['3']['largurabochecha']
        currentCharacterMode.jawHeight = Config_client['preset']['male']['3']['alturadamandibula']
        currentCharacterMode.neckWidth = Config_client['preset']['male']['3']['larguradopescoço']
        currentCharacterMode.lipstickModel = Config_client['preset']['male']['3']['modelobatom']
        currentCharacterMode.beardModel = Config_client['preset']['male']['3']['modelobarba']
        currentCharacterMode.blushModel = Config_client['preset']['male']['3']['modeloblush']
        currentCharacterMode.makeupModel = Config_client['preset']['male']['3']['maquiagem']
        currentCharacterMode.chestModel = Config_client['preset']['male']['3']['modelopelonopeito']
        currentCharacterMode.sundamageModel = Config_client['preset']['male']['3']['danosolares']
        currentCharacterMode.blemishesModel = Config_client['preset']['male']['3']['manchas']
        currentCharacterMode.complexionModel = Config_client['preset']['male']['3']['sardas']
        currentCharacterMode.frecklesModel = Config_client['preset']['male']['3']['rugas']
        currentCharacterMode.hairModel = Config_client['preset']['male']['3']['modelocabelo']  
        SetPedHeadBlendData(PlayerPedId(), currentCharacterMode.fathersID, currentCharacterMode.mothersID, 0, currentCharacterMode.skinColor,0, 0, moreValue(currentCharacterMode.shapeMix),0,0,false)
        updateInput("preset")
        updateColors("preset")
    elseif data.preset == 4 then

        currentCharacterMode.skinColor = Config_client['preset']['male']['4']['cordapele']
        currentCharacterMode.eyesColor = Config_client['preset']['male']['4']['cordoolhos']
        currentCharacterMode.eyebrowsColor = Config_client['preset']['male']['4']['cordasobrancelha']
        currentCharacterMode.firstHairColor =  Config_client['preset']['male']['4']['corprimariadocabelo']
        currentCharacterMode.secondHairColor = Config_client['preset']['male']['4']['corsecundariadocabelo']
        currentCharacterMode.beardColor = Config_client['preset']['male']['4']['cordabarba']
        currentCharacterMode.lipstickColor =  Config_client['preset']['male']['4']['cordobatom']
        currentCharacterMode.blushColor = Config_client['preset']['male']['4']['cordoblush']
        currentCharacterMode.chestColor =  Config_client['preset']['male']['4']['cordopelonopeito']
        currentCharacterMode.fathersID = Config_client['preset']['male']['4']['caradopai']
        currentCharacterMode.mothersID = Config_client['preset']['male']['4']['caradamãe']
        currentCharacterMode.shapeMix = Config_client['preset']['male']['4']['misturadosrostos']
        currentCharacterMode.eyebrowsModel = Config_client['preset']['male']['4']['modelodesobrancelha']
        currentCharacterMode.eyebrowsHeight = Config_client['preset']['male']['4']['larguradatesta']
        currentCharacterMode.eyebrowsWidth = Config_client['preset']['male']['4']['larguradasobrancelha']
        currentCharacterMode.noseWidth = Config_client['preset']['male']['4']['larguradonariz']
        currentCharacterMode.noseLength = Config_client['preset']['male']['4']['comprimentodonariz']
        currentCharacterMode.noseHeight = Config_client['preset']['male']['4']['alturadonariz']
        currentCharacterMode.noseBridge = Config_client['preset']['male']['4']['deslocamentodonariz']
        currentCharacterMode.noseTip = Config_client['preset']['male']['4']['pontadonariz']
        currentCharacterMode.chinLength = Config_client['preset']['male']['4']['comprimentodoqueixo']
        currentCharacterMode.chinWidth = Config_client['preset']['male']['4']['larguradoqueixo']
        currentCharacterMode.chinShape = Config_client['preset']['male']['4']['alturadoqueixo']
        currentCharacterMode.chinPosition = Config_client['preset']['male']['4']['posicaodoqueixo']
        currentCharacterMode.lips = Config_client['preset']['male']['4']['larguradolabios']
        currentCharacterMode.cheekboneHeight = Config_client['preset']['male']['4']['alturadabochecha']
        currentCharacterMode.jawWidth = Config_client['preset']['male']['4']['larguradamandibula']
        currentCharacterMode.cheekboneWidth = Config_client['preset']['male']['4']['largurabochecha']
        currentCharacterMode.jawHeight = Config_client['preset']['male']['4']['alturadamandibula']
        currentCharacterMode.neckWidth = Config_client['preset']['male']['4']['larguradopescoço']
        currentCharacterMode.lipstickModel = Config_client['preset']['male']['4']['modelobatom']
        currentCharacterMode.beardModel = Config_client['preset']['male']['4']['modelobarba']
        currentCharacterMode.blushModel = Config_client['preset']['male']['4']['modeloblush']
        currentCharacterMode.makeupModel = Config_client['preset']['male']['4']['maquiagem']
        currentCharacterMode.chestModel = Config_client['preset']['male']['4']['modelopelonopeito']
        currentCharacterMode.sundamageModel = Config_client['preset']['male']['4']['danosolares']
        currentCharacterMode.blemishesModel = Config_client['preset']['male']['4']['manchas']
        currentCharacterMode.complexionModel = Config_client['preset']['male']['4']['sardas']
        currentCharacterMode.frecklesModel = Config_client['preset']['male']['4']['rugas']
        currentCharacterMode.hairModel = Config_client['preset']['male']['4']['modelocabelo']  
        SetPedHeadBlendData(PlayerPedId(), currentCharacterMode.fathersID, currentCharacterMode.mothersID, 0, currentCharacterMode.skinColor,0, 0, moreValue(currentCharacterMode.shapeMix),0,0,false)
        updateInput("preset")
        updateColors("preset")
    end
elseif data.genero == "female" then
    if data.preset == 1 then

        currentCharacterMode.skinColor = Config_client['preset']['female']['1']['cordapele']
        currentCharacterMode.eyesColor = Config_client['preset']['female']['1']['cordoolhos']
        currentCharacterMode.eyebrowsColor = Config_client['preset']['female']['1']['cordasobrancelha']
        currentCharacterMode.firstHairColor =  Config_client['preset']['female']['1']['corprimariadocabelo']
        currentCharacterMode.secondHairColor = Config_client['preset']['female']['1']['corsecundariadocabelo']
        currentCharacterMode.beardColor = Config_client['preset']['female']['1']['cordabarba']
        currentCharacterMode.lipstickColor =  Config_client['preset']['female']['1']['cordobatom']
        currentCharacterMode.blushColor = Config_client['preset']['female']['1']['cordoblush']
        currentCharacterMode.chestColor =  Config_client['preset']['female']['1']['cordopelonopeito']
        currentCharacterMode.fathersID = Config_client['preset']['female']['1']['caradopai']
        currentCharacterMode.mothersID = Config_client['preset']['female']['1']['caradamãe']
        currentCharacterMode.shapeMix = Config_client['preset']['female']['1']['misturadosrostos']
        currentCharacterMode.eyebrowsModel = Config_client['preset']['female']['1']['modelodesobrancelha']
        currentCharacterMode.eyebrowsHeight = Config_client['preset']['female']['1']['larguradatesta']
        currentCharacterMode.eyebrowsWidth = Config_client['preset']['female']['1']['larguradasobrancelha']
        currentCharacterMode.noseWidth = Config_client['preset']['female']['1']['larguradonariz']
        currentCharacterMode.noseLength = Config_client['preset']['female']['1']['comprimentodonariz']
        currentCharacterMode.noseHeight = Config_client['preset']['female']['1']['alturadonariz']
        currentCharacterMode.noseBridge = Config_client['preset']['female']['1']['deslocamentodonariz']
        currentCharacterMode.noseTip = Config_client['preset']['female']['1']['pontadonariz']
        currentCharacterMode.chinLength = Config_client['preset']['female']['1']['comprimentodoqueixo']
        currentCharacterMode.chinWidth = Config_client['preset']['female']['1']['larguradoqueixo']
        currentCharacterMode.chinShape = Config_client['preset']['female']['1']['alturadoqueixo']
        currentCharacterMode.chinPosition = Config_client['preset']['female']['1']['posicaodoqueixo']
        currentCharacterMode.lips = Config_client['preset']['female']['1']['larguradolabios']
        currentCharacterMode.cheekboneHeight = Config_client['preset']['female']['1']['alturadabochecha']
        currentCharacterMode.jawWidth = Config_client['preset']['female']['1']['larguradamandibula']
        currentCharacterMode.cheekboneWidth = Config_client['preset']['female']['1']['largurabochecha']
        currentCharacterMode.jawHeight = Config_client['preset']['female']['1']['alturadamandibula']
        currentCharacterMode.neckWidth = Config_client['preset']['female']['1']['larguradopescoço']
        currentCharacterMode.lipstickModel = Config_client['preset']['female']['1']['modelobatom']
        currentCharacterMode.beardModel = Config_client['preset']['female']['1']['modelobarba']
        currentCharacterMode.blushModel = Config_client['preset']['female']['1']['modeloblush']
        currentCharacterMode.makeupModel = Config_client['preset']['female']['1']['maquiagem']
        currentCharacterMode.chestModel = Config_client['preset']['female']['1']['modelopelonopeito']
        currentCharacterMode.sundamageModel = Config_client['preset']['female']['1']['danosolares']
        currentCharacterMode.blemishesModel = Config_client['preset']['female']['1']['manchas']
        currentCharacterMode.complexionModel = Config_client['preset']['female']['1']['sardas']
        currentCharacterMode.frecklesModel = Config_client['preset']['female']['1']['rugas']
        currentCharacterMode.hairModel = Config_client['preset']['female']['1']['modelocabelo']  
        SetPedHeadBlendData(PlayerPedId(), currentCharacterMode.fathersID, currentCharacterMode.mothersID, 0, currentCharacterMode.skinColor,0, 0, moreValue(currentCharacterMode.shapeMix),0,0,false)
        updateInput("preset")
        updateColors("preset")
    elseif data.preset == 2 then

        currentCharacterMode.skinColor = Config_client['preset']['female']['2']['cordapele']
        currentCharacterMode.eyesColor = Config_client['preset']['female']['2']['cordoolhos']
        currentCharacterMode.eyebrowsColor = Config_client['preset']['female']['2']['cordasobrancelha']
        currentCharacterMode.firstHairColor =  Config_client['preset']['female']['2']['corprimariadocabelo']
        currentCharacterMode.secondHairColor = Config_client['preset']['female']['2']['corsecundariadocabelo']
        currentCharacterMode.beardColor = Config_client['preset']['female']['2']['cordabarba']
        currentCharacterMode.lipstickColor =  Config_client['preset']['female']['2']['cordobatom']
        currentCharacterMode.blushColor = Config_client['preset']['female']['2']['cordoblush']
        currentCharacterMode.chestColor =  Config_client['preset']['female']['2']['cordopelonopeito']
        currentCharacterMode.fathersID = Config_client['preset']['female']['2']['caradopai']
        currentCharacterMode.mothersID = Config_client['preset']['female']['2']['caradamãe']
        currentCharacterMode.shapeMix = Config_client['preset']['female']['2']['misturadosrostos']
        currentCharacterMode.eyebrowsModel = Config_client['preset']['female']['2']['modelodesobrancelha']
        currentCharacterMode.eyebrowsHeight = Config_client['preset']['female']['2']['larguradatesta']
        currentCharacterMode.eyebrowsWidth = Config_client['preset']['female']['2']['larguradasobrancelha']
        currentCharacterMode.noseWidth = Config_client['preset']['female']['2']['larguradonariz']
        currentCharacterMode.noseLength = Config_client['preset']['female']['2']['comprimentodonariz']
        currentCharacterMode.noseHeight = Config_client['preset']['female']['2']['alturadonariz']
        currentCharacterMode.noseBridge = Config_client['preset']['female']['2']['deslocamentodonariz']
        currentCharacterMode.noseTip = Config_client['preset']['female']['2']['pontadonariz']
        currentCharacterMode.chinLength = Config_client['preset']['female']['2']['comprimentodoqueixo']
        currentCharacterMode.chinWidth = Config_client['preset']['female']['2']['larguradoqueixo']
        currentCharacterMode.chinShape = Config_client['preset']['female']['2']['alturadoqueixo']
        currentCharacterMode.chinPosition = Config_client['preset']['female']['2']['posicaodoqueixo']
        currentCharacterMode.lips = Config_client['preset']['female']['2']['larguradolabios']
        currentCharacterMode.cheekboneHeight = Config_client['preset']['female']['2']['alturadabochecha']
        currentCharacterMode.jawWidth = Config_client['preset']['female']['2']['larguradamandibula']
        currentCharacterMode.cheekboneWidth = Config_client['preset']['female']['2']['largurabochecha']
        currentCharacterMode.jawHeight = Config_client['preset']['female']['2']['alturadamandibula']
        currentCharacterMode.neckWidth = Config_client['preset']['female']['2']['larguradopescoço']
        currentCharacterMode.lipstickModel = Config_client['preset']['female']['2']['modelobatom']
        currentCharacterMode.beardModel = Config_client['preset']['female']['2']['modelobarba']
        currentCharacterMode.blushModel = Config_client['preset']['female']['2']['modeloblush']
        currentCharacterMode.makeupModel = Config_client['preset']['female']['2']['maquiagem']
        currentCharacterMode.chestModel = Config_client['preset']['female']['2']['modelopelonopeito']
        currentCharacterMode.sundamageModel = Config_client['preset']['female']['2']['danosolares']
        currentCharacterMode.blemishesModel = Config_client['preset']['female']['2']['manchas']
        currentCharacterMode.complexionModel = Config_client['preset']['female']['2']['sardas']
        currentCharacterMode.frecklesModel = Config_client['preset']['female']['2']['rugas']
        currentCharacterMode.hairModel = Config_client['preset']['female']['2']['modelocabelo']  


        SetPedHeadBlendData(PlayerPedId(), currentCharacterMode.fathersID, currentCharacterMode.mothersID, 0, currentCharacterMode.skinColor,0, 0, moreValue(currentCharacterMode.shapeMix),0,0,false)
        updateInput("preset")
        updateColors("preset")
    elseif data.preset == 3 then


        currentCharacterMode.skinColor = Config_client['preset']['female']['3']['cordapele']
        currentCharacterMode.eyesColor = Config_client['preset']['female']['3']['cordoolhos']
        currentCharacterMode.eyebrowsColor = Config_client['preset']['female']['3']['cordasobrancelha']
        currentCharacterMode.firstHairColor =  Config_client['preset']['female']['3']['corprimariadocabelo']
        currentCharacterMode.secondHairColor = Config_client['preset']['female']['3']['corsecundariadocabelo']
        currentCharacterMode.beardColor = Config_client['preset']['female']['3']['cordabarba']
        currentCharacterMode.lipstickColor =  Config_client['preset']['female']['3']['cordobatom']
        currentCharacterMode.blushColor = Config_client['preset']['female']['3']['cordoblush']
        currentCharacterMode.chestColor =  Config_client['preset']['female']['3']['cordopelonopeito']
        currentCharacterMode.fathersID = Config_client['preset']['female']['3']['caradopai']
        currentCharacterMode.mothersID = Config_client['preset']['female']['3']['caradamãe']
        currentCharacterMode.shapeMix = Config_client['preset']['female']['3']['misturadosrostos']
        currentCharacterMode.eyebrowsModel = Config_client['preset']['female']['3']['modelodesobrancelha']
        currentCharacterMode.eyebrowsHeight = Config_client['preset']['female']['3']['larguradatesta']
        currentCharacterMode.eyebrowsWidth = Config_client['preset']['female']['3']['larguradasobrancelha']
        currentCharacterMode.noseWidth = Config_client['preset']['female']['3']['larguradonariz']
        currentCharacterMode.noseLength = Config_client['preset']['female']['3']['comprimentodonariz']
        currentCharacterMode.noseHeight = Config_client['preset']['female']['3']['alturadonariz']
        currentCharacterMode.noseBridge = Config_client['preset']['female']['3']['deslocamentodonariz']
        currentCharacterMode.noseTip = Config_client['preset']['female']['3']['pontadonariz']
        currentCharacterMode.chinLength = Config_client['preset']['female']['3']['comprimentodoqueixo']
        currentCharacterMode.chinWidth = Config_client['preset']['female']['3']['larguradoqueixo']
        currentCharacterMode.chinShape = Config_client['preset']['female']['3']['alturadoqueixo']
        currentCharacterMode.chinPosition = Config_client['preset']['female']['3']['posicaodoqueixo']
        currentCharacterMode.lips = Config_client['preset']['female']['3']['larguradolabios']
        currentCharacterMode.cheekboneHeight = Config_client['preset']['female']['3']['alturadabochecha']
        currentCharacterMode.jawWidth = Config_client['preset']['female']['3']['larguradamandibula']
        currentCharacterMode.cheekboneWidth = Config_client['preset']['female']['3']['largurabochecha']
        currentCharacterMode.jawHeight = Config_client['preset']['female']['3']['alturadamandibula']
        currentCharacterMode.neckWidth = Config_client['preset']['female']['3']['larguradopescoço']
        currentCharacterMode.lipstickModel = Config_client['preset']['female']['3']['modelobatom']
        currentCharacterMode.beardModel = Config_client['preset']['female']['3']['modelobarba']
        currentCharacterMode.blushModel = Config_client['preset']['female']['3']['modeloblush']
        currentCharacterMode.makeupModel = Config_client['preset']['female']['3']['maquiagem']
        currentCharacterMode.chestModel = Config_client['preset']['female']['3']['modelopelonopeito']
        currentCharacterMode.sundamageModel = Config_client['preset']['female']['3']['danosolares']
        currentCharacterMode.blemishesModel = Config_client['preset']['female']['3']['manchas']
        currentCharacterMode.complexionModel = Config_client['preset']['female']['3']['sardas']
        currentCharacterMode.frecklesModel = Config_client['preset']['female']['3']['rugas']
        currentCharacterMode.hairModel = Config_client['preset']['female']['3']['modelocabelo']  

        SetPedHeadBlendData(PlayerPedId(), currentCharacterMode.fathersID, currentCharacterMode.mothersID, 0, currentCharacterMode.skinColor,0, 0, moreValue(currentCharacterMode.shapeMix),0,0,false)
        updateInput("preset")
        updateColors("preset")
    elseif data.preset == 4 then
        currentCharacterMode.skinColor = Config_client['preset']['female']['4']['cordapele']
        currentCharacterMode.eyesColor = Config_client['preset']['female']['4']['cordoolhos']
        currentCharacterMode.eyebrowsColor = Config_client['preset']['female']['4']['cordasobrancelha']
        currentCharacterMode.firstHairColor =  Config_client['preset']['female']['4']['corprimariadocabelo']
        currentCharacterMode.secondHairColor = Config_client['preset']['female']['4']['corsecundariadocabelo']
        currentCharacterMode.beardColor = Config_client['preset']['female']['4']['cordabarba']
        currentCharacterMode.lipstickColor =  Config_client['preset']['female']['4']['cordobatom']
        currentCharacterMode.blushColor = Config_client['preset']['female']['4']['cordoblush']
        currentCharacterMode.chestColor =  Config_client['preset']['female']['4']['cordopelonopeito']
        currentCharacterMode.fathersID = Config_client['preset']['female']['4']['caradopai']
        currentCharacterMode.mothersID = Config_client['preset']['female']['4']['caradamãe']
        currentCharacterMode.shapeMix = Config_client['preset']['female']['4']['misturadosrostos']
        currentCharacterMode.eyebrowsModel = Config_client['preset']['female']['4']['modelodesobrancelha']
        currentCharacterMode.eyebrowsHeight = Config_client['preset']['female']['4']['larguradatesta']
        currentCharacterMode.eyebrowsWidth = Config_client['preset']['female']['4']['larguradasobrancelha']
        currentCharacterMode.noseWidth = Config_client['preset']['female']['4']['larguradonariz']
        currentCharacterMode.noseLength = Config_client['preset']['female']['4']['comprimentodonariz']
        currentCharacterMode.noseHeight = Config_client['preset']['female']['4']['alturadonariz']
        currentCharacterMode.noseBridge = Config_client['preset']['female']['4']['deslocamentodonariz']
        currentCharacterMode.noseTip = Config_client['preset']['female']['4']['pontadonariz']
        currentCharacterMode.chinLength = Config_client['preset']['female']['4']['comprimentodoqueixo']
        currentCharacterMode.chinWidth = Config_client['preset']['female']['4']['larguradoqueixo']
        currentCharacterMode.chinShape = Config_client['preset']['female']['4']['alturadoqueixo']
        currentCharacterMode.chinPosition = Config_client['preset']['female']['4']['posicaodoqueixo']
        currentCharacterMode.lips = Config_client['preset']['female']['4']['larguradolabios']
        currentCharacterMode.cheekboneHeight = Config_client['preset']['female']['4']['alturadabochecha']
        currentCharacterMode.jawWidth = Config_client['preset']['female']['4']['larguradamandibula']
        currentCharacterMode.cheekboneWidth = Config_client['preset']['female']['4']['largurabochecha']
        currentCharacterMode.jawHeight = Config_client['preset']['female']['4']['alturadamandibula']
        currentCharacterMode.neckWidth = Config_client['preset']['female']['4']['larguradopescoço']
        currentCharacterMode.lipstickModel = Config_client['preset']['female']['4']['modelobatom']
        currentCharacterMode.beardModel = Config_client['preset']['female']['4']['modelobarba']
        currentCharacterMode.blushModel = Config_client['preset']['female']['4']['modeloblush']
        currentCharacterMode.makeupModel = Config_client['preset']['female']['4']['maquiagem']
        currentCharacterMode.chestModel = Config_client['preset']['female']['4']['modelopelonopeito']
        currentCharacterMode.sundamageModel = Config_client['preset']['female']['4']['danosolares']
        currentCharacterMode.blemishesModel = Config_client['preset']['female']['4']['manchas']
        currentCharacterMode.complexionModel = Config_client['preset']['female']['4']['sardas']
        currentCharacterMode.frecklesModel = Config_client['preset']['female']['4']['rugas']
        currentCharacterMode.hairModel = Config_client['preset']['female']['4']['modelocabelo']  

        SetPedHeadBlendData(PlayerPedId(), currentCharacterMode.fathersID, currentCharacterMode.mothersID, 0, currentCharacterMode.skinColor,0, 0, moreValue(currentCharacterMode.shapeMix),0,0,false)
        updateInput("preset")
        updateColors("preset")
        end
    end
    updateColors("preset")
end)


RegisterNUICallback("updateColor",function(data,cb)
    local valor = tonumber(data.valor) 
    local tipo = tostring(data.tipo) 
    local ped = PlayerPedId()
    if tipo == "skinColor" then
    currentCharacterMode.skinColor = valor
    elseif tipo == "eyesColor" then
    currentCharacterMode.eyesColor = valor
    elseif tipo == "eyebrowsColor" then
    currentCharacterMode.eyebrowsColor = valor
    elseif tipo == "firstHairColor" then
    currentCharacterMode.firstHairColor = valor
    elseif tipo == "secondHairColor" then
    currentCharacterMode.secondHairColor = valor
    elseif tipo == "beardColor" then
    currentCharacterMode.beardColor = valor
    elseif tipo == "lipstickColor" then
    currentCharacterMode.lipstickColor = valor
    elseif tipo == "blushColor" then
    currentCharacterMode.blushColor = valor
    elseif tipo == "chestColor" then
    currentCharacterMode.chestColor = valor
    end
    updateColors(tipo)
end)

function updateColors(tipo)
    local ped = PlayerPedId()
    if tipo ~= "preset" then
        if tipo == "skinColor" then
            SetPedHeadBlendData(ped,currentCharacterMode.fathersID,currentCharacterMode.mothersID,0,currentCharacterMode.skinColor,0,0,moreValue(currentCharacterMode.shapeMix),0,0,false)
        elseif tipo == "eyesColor" then
            SetPedEyeColor(ped,currentCharacterMode.eyesColor)
        elseif tipo == "eyebrowsColor" then
            SetPedHeadOverlayColor(ped,2,1,currentCharacterMode.eyebrowsColor,currentCharacterMode.eyebrowsColor)
        elseif tipo == "firstHairColor" then
            SetPedHairColor(ped,currentCharacterMode.firstHairColor,currentCharacterMode.secondHairColor)
        elseif tipo == "secondHairColor" then
            SetPedHairColor(ped,currentCharacterMode.firstHairColor,currentCharacterMode.secondHairColor)
        elseif tipo == "beardColor" then
            SetPedHeadOverlayColor(ped,1,1,currentCharacterMode.beardColor,currentCharacterMode.beardColor)
        elseif tipo == "lipstickColor" then
            SetPedHeadOverlayColor(ped,8,2,currentCharacterMode.lipstickColor,currentCharacterMode.lipstickColor)
        elseif tipo == "blushColor" then
            SetPedHeadOverlayColor(ped,5,2,currentCharacterMode.blushColor,currentCharacterMode.blushColor)
        elseif tipo == "chestColor" then
            SetPedHeadOverlayColor(ped,10,1,currentCharacterMode.chestColor,currentCharacterMode.chestColor)
        end
    else
        SetPedHeadBlendData(ped,currentCharacterMode.fathersID,currentCharacterMode.mothersID,0,currentCharacterMode.skinColor,0,0,moreValue(currentCharacterMode.shapeMix),0,0,false)
        SetPedEyeColor(ped,currentCharacterMode.eyesColor)
        SetPedHeadOverlayColor(ped,2,1,currentCharacterMode.eyebrowsColor,currentCharacterMode.eyebrowsColor)
        SetPedHairColor(ped,currentCharacterMode.firstHairColor,currentCharacterMode.secondHairColor)
        SetPedHairColor(ped,currentCharacterMode.firstHairColor,currentCharacterMode.secondHairColor)
        SetPedHeadOverlayColor(ped,1,1,currentCharacterMode.beardColor,currentCharacterMode.beardColor)
        SetPedHeadOverlayColor(ped,8,2,currentCharacterMode.lipstickColor,currentCharacterMode.lipstickColor)
        SetPedHeadOverlayColor(ped,5,2,currentCharacterMode.blushColor,currentCharacterMode.blushColor)
        SetPedHeadOverlayColor(ped,10,1,currentCharacterMode.chestColor,currentCharacterMode.chestColor)
    end

end

RegisterNUICallback("terminarCriacao",function(data,cb)
    if currentCharacterMode then
        TriggerServerEvent('dope:session:off')
        dPNserver.finalizarPersonagem(currentCharacterMode)
        SetNuiFocus(false,false)
        DoScreenFadeOut(1000)
        Wait(1000)
        if Config_client['cutscene'] == true then
            cutScencene()
        elseif Config_client['cutscene'] == false then
            DoScreenFadeIn(1000)
            StartPlayerSwitch(PlayerPedId(), PlayerPedId(), 195, 1)
            SetEntityCoords(PlayerPedId(), Config_client['spawloc']['x'], Config_client['spawloc']['y'],Config_client['spawloc']['z'])
            Wait(700)
            DisplayRadar(true)
            SetEntityHeading(PlayerPedId(),Config_client['headingTerminar'])        
            Wait(500)
            DoScreenFadeOut(1000)
        else
            cutScencene()
        end
    end
end)

function cutScencene()

    destroyCamera()
    RequestCutscene('mp_intro_concat', 8) -- Usually 8.
    local plyrId = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    while not (HasCutsceneLoaded()) do
        Wait(0)
    end
    local PedPosition = GetEntityCoords(PlayerPedId(), false)
    local model = "mp_m_freemode_01"
    if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then
        model = "mp_m_freemode_01"
    elseif  GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then 
        model = "mp_f_freemode_01"
    end
    npc = CreatePed(4, GetHashKey(model), PedPosition.x+1, PedPosition.y, PedPosition.z, GetEntityHeading(PlayerPedId()), false,true)
    ClonePedToTarget(PlayerPedId(), npc)
    RegisterEntityForCutscene(npc, 'MP_Female_Character', 0, 0, 64)
    RegisterEntityForCutscene(npc, 'MP_Male_Character', 0, 0, 64)
    SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_1", 0, 1)---PARTIE POUR DELETE LES AUTRE PEDS
    SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_2", 0, 1)---PARTIE POUR DELETE LES AUTRE PEDS
    SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_3", 0, 1)---PARTIE POUR DELETE LES AUTRE PEDS
    SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_4", 0, 1)---PARTIE POUR DELETE LES AUTRE PEDS
    SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_5", 0, 1)---PARTIE POUR DELETE LES AUTRE PEDS
    SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_6", 0, 1)---PARTIE POUR DELETE LES AUTRE PEDS
    SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_7", 0, 1)---PARTIE POUR DELETE LES AUTRE PEDS
    RegisterEntityForCutscene(0, 'MP_Plane_Passenger_1', 3, GetHashKey('mp_f_freemode_01'), 0)---PARTIE POUR DELETE LES PEDS
    RegisterEntityForCutscene(0, 'MP_Plane_Passenger_2', 3, GetHashKey('mp_f_freemode_01'), 0)---PARTIE POUR DELETE LES PEDS
    RegisterEntityForCutscene(0, 'MP_Plane_Passenger_3', 3, GetHashKey('mp_f_freemode_01'), 0)---PARTIE POUR DELETE LES PEDS
    RegisterEntityForCutscene(0, 'MP_Plane_Passenger_4', 3, GetHashKey('mp_f_freemode_01'), 0)---PARTIE POUR DELETE LES PEDS
    RegisterEntityForCutscene(0, 'MP_Plane_Passenger_5', 3, GetHashKey('mp_f_freemode_01'), 0)---PARTIE POUR DELETE LES PEDS
    RegisterEntityForCutscene(0, 'MP_Plane_Passenger_6', 3, GetHashKey('mp_f_freemode_01'), 0)---PARTIE POUR DELETE LES PEDS
    RegisterEntityForCutscene(0, 'MP_Plane_Passenger_7', 3, GetHashKey('mp_f_freemode_01'), 0)---PARTIE POUR DELETE LES PEDS
    RegisterEntityForCutscene(0, 'MP_Plane_Passenger_1', 3, GetHashKey('mp_m_freemode_01'), 0)---PARTIE POUR DELETE LES PEDS
   RegisterEntityForCutscene(0, 'MP_Plane_Passenger_2', 3, GetHashKey('mp_m_freemode_01'), 0)---PARTIE POUR DELETE LES PEDS
    RegisterEntityForCutscene(0, 'MP_Plane_Passenger_3', 3, GetHashKey('mp_m_freemode_01'), 0)---PARTIE POUR DELETE LES PEDS
    RegisterEntityForCutscene(0, 'MP_Plane_Passenger_4', 3, GetHashKey('mp_m_freemode_01'), 0)---PARTIE POUR DELETE LES PEDS
    RegisterEntityForCutscene(0, 'MP_Plane_Passenger_5', 3, GetHashKey('mp_m_freemode_01'), 0)---PARTIE POUR DELETE LES PEDS
    RegisterEntityForCutscene(0, 'MP_Plane_Passenger_6', 3, GetHashKey('mp_m_freemode_01'), 0)---PARTIE POUR DELETE LES PEDS
    RegisterEntityForCutscene(0, 'MP_Plane_Passenger_7', 3, GetHashKey('mp_m_freemode_01'), 0)---PARTIE POUR DELETE LES PEDS
    NewLoadSceneStartSphere(-1212.79, -1673.52, 7, 1000, 0) 
    SetWeatherTypeNow("EXTRASUNNY") 
    SetEntityCoords(PlayerPedId(),-1161.5616455078,-1665.9948730469,4.3903365135193)
    SetEntityHealth(PlayerPedId(),400)
    TriggerServerEvent("resetBleeding2")
    StartCutscene()
    Citizen.CreateThread(function()
        while IsCutsceneActive() do
          SetPlayerControl(PlayerId(), true, false)
          Wait(1)
        end
    end)
    Wait(500)
    DoScreenFadeIn(1000)
    Wait(28000)
    DoScreenFadeOut(1000)
    Wait(1000)
    StopCutsceneImmediately()
    RemoveCutscene()
    SetEntityCoords(PlayerPedId(), Config_client['spawloc']['x'], Config_client['spawloc']['y'],Config_client['spawloc']['z'])
    DeleteEntity(npc)
    Wait(700)
    DoScreenFadeIn(1000)
    DisplayRadar(true)
    SetEntityHeading(PlayerPedId(),Config_client['headingTerminar'])
    dPNserver.giveItem()
    TriggerEvent("status:celular",false)
    TriggerServerEvent("resetBleeding2")
    TriggerServerEvent('dpn:criacao:end')
    --dPNserver.giveItensCharacterFinish()
    -- finishCreateContinuou()
end





RegisterNUICallback("updateHair",function(data,cb)
    local cabelo = data.cabelo
    local ped = PlayerPedId()
    currentCharacterMode.hairModel = cabelo
    SetPedComponentVariation(ped,2,currentCharacterMode.hairModel,0,0)
	SetPedHairColor(ped,currentCharacterMode.firstHairColor,currentCharacterMode.secondHairColor)
end)


RegisterNUICallback('personClose',function(data)
    -- if dPNserver.checkPermission() then
        TransitionFromBlurred(1000)
        SetNuiFocus(false,false)
        SendNUIMessage({action = "clostPerson"})
    -- end
end)


RegisterNUICallback("resetPerson",function(data,cb)
    if data then
        dPNserver.resetPerson(data.id)
        SendNUIMessage({action = "clostPerson"})
    end
end)


function dPN.createNewPerson()
    voltarcamerazinha()
    naentrada = true
    DisplayRadar(false)
    TriggerServerEvent('dpn:criacao:start')
    TriggerServerEvent('dope:session:on')
end


RegisterNetEvent('iniciarTelaCriacao')
AddEventHandler('iniciarTelaCriacao',function()
    voltarcamerazinha()
    naentrada = true
    DisplayRadar(false)
    TriggerServerEvent('dpn:criacao:start')
    TriggerServerEvent('dope:session:on')
end)


function voltarcamerazinha()
    local ped = PlayerPedId()
    if naentrada == false then
        naentrada = true
        destroyCamera()
        DoScreenFadeOut(1000)
        Wait(1000)
        SetEntityCoords(PlayerPedId(),Config_client['createPerson']['x'], Config_client['createPerson']['y'],Config_client['createPerson']['z'])
        Wait(500)
        DoScreenFadeIn(1000)        
        FreezePedCameraRotation(ped, true)
        SetNuiFocus(true,true)
        TransitionToBlurred(1000)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",Config_client['camInicioal']['x'],Config_client['camInicioal']['y'],Config_client['camInicioal']['z'],Config_client['camInicioal']['h'],Config_client['camInicioal']['h4'],Config_client['camInicioal']['h2'],Config_client['camInicioal']['h3'],false,Config_client['camInicioal']['h5'])
        SetCamActive(cam,true)
        RenderScriptCams(true,false,1,true,true)
        SendNUIMessage({action = "primeiroLogin",})
    end
end


RegisterNUICallback("voltarCriacao",function(data)
    voltarcamerazinha()
end)

function cameracomeefeito()
    if naentrada == true then
        naentrada = false
        local coords = {x = Config_client['createPerson']['x'],y = Config_client['createPerson']['y'],z= Config_client['createPerson']['z']}
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",Config_client['camInicioal']['x'],Config_client['camInicioal']['y'],Config_client['camInicioal']['z'],Config_client['camInicioal']['h'],Config_client['camInicioal']['h4'],Config_client['camInicioal']['h2'],Config_client['camInicioal']['h3'],false,Config_client['camInicioal']['h5'])
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
        Citizen.Wait(500)
        cam3 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x,coords.y,coords.z+200.0, Config_client['camRotate']['1'],Config_client['camRotate']['3'],Config_client['camRotate']['3'], Config_client['camRotate']['4'], false, Config_client['camRotate']['5'])
        PointCamAtCoord(cam3, coords.x,coords.y,coords.z+200)
        SetCamActiveWithInterp(cam3, cam, 3900, true, true)
        Citizen.Wait(3900)
        cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x,coords.y,coords.z+200.0, Config_client['camInicioal']['1'],Config_client['camRotate']['3'],Config_client['camRotate']['3'], Config_client['camRotate']['4'], false, Config_client['camRotate']['5'])
        PointCamAtCoord(cam2, coords.x,coords.y,coords.z+2)
        SetCamActiveWithInterp(cam2, cam3, 3700, true, true)
        RenderScriptCams(false, true, 500, true, true)
        SetEntityCoords(PlayerPedId(),Config_client['createPerson']['x'], Config_client['createPerson']['y'],Config_client['createPerson']['z']-0.2)
        DestroyAllCams(true)
        DisplayHud(false)
        DisplayRadar(false)	
        SetEntityVisible(PlayerPedId(), true)
    end
end 

function destroyCamera()
    Deactivate()
	DestroyAllCams(true)
	Citizen.Wait(500)
	DisplayHud(true)
	DisplayRadar(true)	
end

RegisterNUICallback("updateFirstInformation",function(data,cb)
    if data then
        local generoped
        if data.genero == "male" then
            generoped = "mp_m_freemode_01"
            setPedModel("mp_m_freemode_01")
        elseif data.genero == "female" then
            generoped = "mp_f_freemode_01"
            setPedModel("mp_f_freemode_01")
        end
        
        TransitionFromBlurred(1000)
        SetPedHeadBlendData(PlayerPedId(), currentCharacterMode.fathersID, currentCharacterMode.mothersID, 0, currentCharacterMode.skinColor,0, 0, moreValue(currentCharacterMode.shapeMix),0,0,false)
        SetEntityHeading(PlayerPedId(),Config_client['heading'])
        refreshInformations(-2)
        naentrada = true
        cameracomeefeito()
        dPNserver.updateFirstInformation(data.nome,data.sobrenome,data.idade, generoped)
        SetStreamedTextureDictAsNoLongerNeeded('mparrow')
        SetStreamedTextureDictAsNoLongerNeeded('mpleaderboard')
        SetStreamedTextureDictAsNoLongerNeeded('pause_menu_pages_char_mom_dad')
        SetStreamedTextureDictAsNoLongerNeeded('char_creator_portraits')
        RequestStreamedTextureDict('pause_menu_pages_char_mom_dad')
        RequestStreamedTextureDict('char_creator_portraits')
        while not HasStreamedTextureDictLoaded('pause_menu_pages_char_mom_dad') or not HasStreamedTextureDictLoaded('char_creator_portraits') do
            Wait(100)
        end
        SendNUIMessage({
            action = "passou",
            lipstick = GetColorData(GetLipstickColors(), false),
            blusher = GetColorData(GetBlusherColors(), false)
        })
        Wait(500)
        Activate(500)
    end
end)

function RGBToHexCode(r, g, b)
    local cor = string.format("#%02X%02X%02X", r, g, b)
    return cor
end

function GetBlusherColors()
    local result = {}
    local i = 0

    for i = 0, 22 do
        table.insert(result, i)
    end
    table.insert(result, 25)
    table.insert(result, 26)
    table.insert(result, 51)
    table.insert(result, 60)

    return result
end

function GetColorData(indexes, isHair)
    local result = {}
    local GetRgbColor = nil

    if isHair then
        GetRgbColor = function(index)
            return GetPedHairRgbColor(index)
        end
    else
        GetRgbColor = function(index)
            return GetPedMakeupRgbColor(index)
        end
    end

    for i, index in ipairs(indexes) do
        local r, g, b = GetRgbColor(index)
        local hex = RGBToHexCode(r, g, b)
        table.insert(result, { index = index, hex = hex })
    end

    return result
end

function GetLipstickColors()
    local result = {}
    local i = 0

    for i = 0, 31 do
        table.insert(result, i)
    end
    table.insert(result, 48)
    table.insert(result, 49)
    table.insert(result, 55)
    table.insert(result, 56)
    table.insert(result, 62)
    table.insert(result, 63)

    return result
end

function moreValue(n)
	n = n + 0.00000
	return n
end

RegisterNUICallback("udpateInputCam",function(data,cb)
    if data.tipo == "rotacao" then
        SetEntityHeading(PlayerPedId(),moreValue(data.valor))
    elseif data.tipo == "zoom" then
        if parseInt(data.valor) == 0 then
            Camera.currentView  = 'head'
            Activate(500)
        elseif parseInt(data.valor) == 1 then
            Camera.currentView  = 'body'
            Activate(500)
        elseif parseInt(data.valor) == 2 then
            Camera.currentView  = 'legs'
            Activate(500)
        elseif parseInt(data.valor) == 3 then
            Camera.currentView  = 'corpo'
            Activate(500)
        end
    end
end)



function SetViewcamera(view)
    local boneIndex = -1
    if view == 'head' then
        boneIndex = tonumber("31086")
        Camera.radiusMin    = Config_client['cmeraInpit']['head3']
        Camera.radiusMax    = Config_client['cmeraInpit']['body3']
        Camera.angleYMin    = Config_client['cmeraInpit']['head1']
        Camera.angleYMax    = Config_client['cmeraInpit']['head2']
        Camera.radius = Camera.radiusMin
        Camera.angleY = Camera.angleYMin
        Camera.angleX = GetEntityHeading(PlayerPedId()) + 90.0

        Camera.position = CalculatePosition(false)
        SetCamCoord(Camera.entity, Camera.position.x, Camera.position.y, Camera.position.z)

        targetPos = GetPedBoneCoords(PlayerPedId(), boneIndex,  Config_client['cmeraInpit']['corpo5'],  Config_client['cmeraInpit']['corpo5'],  Config_client['cmeraInpit']['corpo5'])
        PointCamAtCoord(Camera.entity, targetPos.x+0.6, targetPos.y, targetPos.z)

        Camera.currentView = view
    elseif view == 'body' then
        boneIndex = tonumber("11816")
        Camera.radiusMin    = tonumber("1.0")
        Camera.radiusMax    = tonumber("2.0")
        Camera.angleYMin    = tonumber("0.0")
        Camera.angleYMax    = tonumber("35.0")
        Camera.radius = Camera.radiusMin
        Camera.angleY = Camera.angleYMin
        Camera.angleX = GetEntityHeading(PlayerPedId()) + 90.0

        Camera.position = CalculatePosition(false)
        SetCamCoord(Camera.entity, Camera.position.x, Camera.position.y, Camera.position.z)

        targetPos = GetPedBoneCoords(PlayerPedId(), boneIndex, 0.0, 0.0, 0.0)
        PointCamAtCoord(Camera.entity, targetPos.x+0.6, targetPos.y, targetPos.z)

        Camera.currentView = view
    elseif view == 'legs' then 
        boneIndex = tonumber("35502")
        Camera.radiusMin    = Config_client['cmeraInpit']['corpo1']
        Camera.radiusMax    = Config_client['cmeraInpit']['corpo2']
        Camera.angleYMin    = Config_client['cmeraInpit']['corpo3']
        Camera.angleYMax    = Config_client['cmeraInpit']['corpo4']
        Camera.radius = Camera.radiusMin
        Camera.angleY = Camera.angleYMin
        Camera.angleX = GetEntityHeading(PlayerPedId()) + tonumber("90.0")

        Camera.position = CalculatePosition(false)
        SetCamCoord(Camera.entity, Camera.position.x, Camera.position.y, Camera.position.z)

        targetPos = GetPedBoneCoords(PlayerPedId(), boneIndex, Config_client['cmeraInpit']['corpo5'], Config_client['cmeraInpit']['corpo5'], Config_client['cmeraInpit']['corpo5'])
        PointCamAtCoord(Camera.entity, targetPos.x+1.2, targetPos.y, targetPos.z)

        Camera.currentView = view
    elseif view == "corpo" then
        boneIndex = tonumber("35502")
        Camera.radiusMin    = tonumber("1.1")
        Camera.radiusMax    = tonumber("1.25")
        Camera.angleYMin    = tonumber("-30.0")
        Camera.angleYMax    = tonumber("20.0")
        Camera.radius = Camera.radiusMin
        Camera.angleY = Camera.angleYMin
        Camera.angleX = GetEntityHeading(PlayerPedId()) + tonumber("90.0")

        Camera.position = GetOffsetFromEntityInWorldCoords(PlayerPedId(), tonumber("0.0"), tonumber("2.0"), tonumber("0.0"))

        targetPos = GetEntityCoords(PlayerPedId())
        SetCamCoord(Camera.entity, Camera.position.x, Camera.position.y, Camera.position.z+0.75)
        PointCamAtCoord(Camera.entity, targetPos.x, targetPos.y-0.5, targetPos.z+0.25)

    end

end

function CalculatePosition(adjustedAngle)
    if adjustedAngle then
        Camera.angleX = Camera.angleX - Camera.mouseX * 0.1
        Camera.angleY = Camera.angleY + Camera.mouseY * 0.1
    end

    if Camera.angleY > Camera.angleYMax then
        Camera.angleY = Camera.angleYMax
    elseif Camera.angleY < Camera.angleYMin then
        Camera.angleY = Camera.angleYMin
    end

    local radiusMax = CalculateMaxRadius()
    
    local offsetX = ((Cos(Camera.angleX) * Cos(Camera.angleY)) + (Cos(Camera.angleY) * Cos(Camera.angleX))) / 2 * radiusMax
    local offsetY = ((Sin(Camera.angleX) * Cos(Camera.angleY)) + (Cos(Camera.angleY) * Sin(Camera.angleX))) / 2 * radiusMax
    local offsetZ = ((Sin(Camera.angleY))) * radiusMax

    local pedCoords = GetEntityCoords(PlayerPedId())

    return vector3(pedCoords.x + offsetX, pedCoords.y + offsetY, pedCoords.z + offsetZ)
end

function CalculateMaxRadius()
    if Camera.radius < Camera.radiusMin then
        Camera.radius = Camera.radiusMin
    elseif Camera.radius > Camera.radiusMax then
        Camera.radius = Camera.radiusMax
    end

    local result = Camera.radius

    local playerPed = PlayerPedId()
    local pedCoords = GetEntityCoords(playerPed)

    local behindX = pedCoords.x + ((Cos(Camera.angleX) * Cos(Camera.angleY)) + (Cos(Camera.angleY) * Cos(Camera.angleX))) / 2 * (Camera.radius + 0.5)
    local behindY = pedCoords.x + ((Sin(Camera.angleX) * Cos(Camera.angleY)) + (Cos(Camera.angleY) * Sin(Camera.angleX))) / 2 * (Camera.radius + 0.5)
    local behindZ = ((Sin(Camera.angleY))) * (Camera.radius + 0.5)

    local testRay = StartShapeTestRay(pedCoords.x, pedCoords.y, pedCoords.z + 0.5, behindX, behindY, behindZ, -1, playerPed, 0)
    local _, hit, hitCoords = GetShapeTestResult(testRay)
    local hitDist = Vdist(pedCoords.x, pedCoords.y, pedCoords.z + 0.5, hitCoords)

    if hit and hitDist < Camera.radius + 0.5 then
        result = hitDist
    end

    return result
end

function Activate(delay)
  
    SetEntityHeading(PlayerPedId(),125.63)
    
    if not DoesCamExist(Camera.entity) then
        Camera.entity = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end

    local playerPed = PlayerPedId()
    FreezePedCameraRotation(playerPed, true)

    PlayIdleAnimation()

    SetViewcamera(Camera.currentView)

    SetCamActive(Camera.entity, true)
    RenderScriptCams(true, true, 500, true, true)

    Camera.active = true
end

function Deactivate()
    local playerPed = PlayerPedId()
    SetCamActive(Camera.entity, false)
    RenderScriptCams(false, true, 500, true, true)
    FreezePedCameraRotation(playerPed, false)
    Camera.active = false
end

function PlayIdleAnimation()


    local animDict = 'anim@heists@heist_corona@team_idles@female_a'

    while not HasAnimDictLoaded(animDict) do
        RequestAnimDict(animDict)
        Wait(100)
    end

    local playerPed = PlayerPedId()
    ClearPedTasksImmediately(playerPed)
    TaskPlayAnim(playerPed, animDict, 'idle', 1.0, 1.0, -1, 1, 1, 0, 0, 0)
end

function setPedModel(model)
	local mhash = GetHashKey(model)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end
	if HasModelLoaded(mhash) then
		SetPlayerModel(PlayerId(),mhash)

		SetModelAsNoLongerNeeded(mhash)
	end
end

function refreshInformations()
    local ped = PlayerPedId()
	SetPedDefaultComponentVariation(PlayerPedId())
	ClearAllPedProps(PlayerPedId())
	if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then
		SetPedComponentVariation(PlayerPedId(),1,-1,0,2)
		SetPedComponentVariation(PlayerPedId(),5,-1,0,2)
		SetPedComponentVariation(PlayerPedId(),7,-1,0,2)
		SetPedComponentVariation(PlayerPedId(),3,15,0,2)
		SetPedComponentVariation(PlayerPedId(),4,61,0,2)
		SetPedComponentVariation(PlayerPedId(),8,15,0,2)
		SetPedComponentVariation(PlayerPedId(),6,16,0,2)
		SetPedComponentVariation(PlayerPedId(),11,104,0,2)
		SetPedComponentVariation(PlayerPedId(),9,-1,0,2)
		SetPedComponentVariation(PlayerPedId(),10,-1,0,2)
		SetPedPropIndex(PlayerPedId(),2,-1,0,2)
		SetPedPropIndex(PlayerPedId(),6,-1,0,2)
		SetPedPropIndex(PlayerPedId(),7,-1,0,2)
        SetPedComponentVariation(PlayerPedId(),1,0,0,2)
        SetPedComponentVariation(PlayerPedId(),3,15,0,2)
        SetPedComponentVariation(PlayerPedId(),4,1,0,2)
        SetPedComponentVariation(PlayerPedId(),6,0,0,2)
        SetPedComponentVariation(PlayerPedId(),7,0,0,2)
        SetPedComponentVariation(PlayerPedId(),8,1,0,2)
        SetPedComponentVariation(PlayerPedId(),9,0,0,2)
        SetPedComponentVariation(PlayerPedId(),10,0,0,2)
        SetPedComponentVariation(PlayerPedId(),11,1,0,2)
        SetPedComponentVariation(PlayerPedId(),0,0,0,2)
        SetPedHeadBlendData(PlayerPedId(), currentCharacterMode.fathersID, currentCharacterMode.mothersID, 0, currentCharacterMode.skinColor,0, 0, moreValue(currentCharacterMode.shapeMix),0,0,false)
        SetPedHeadOverlay(ped,2,currentCharacterMode.eyebrowsModel,0.99)
        SetPedHeadOverlayColor(ped,2,1,currentCharacterMode.eyebrowsColor,currentCharacterMode.eyebrowsColor)
        SetPedFaceFeature(ped,6,currentCharacterMode.eyebrowsHeight)
        SetPedFaceFeature(ped,7,currentCharacterMode.eyebrowsWidth)
        SetPedFaceFeature(ped,0,currentCharacterMode.noseWidth)
        SetPedFaceFeature(ped,1,currentCharacterMode.noseHeight)
        SetPedFaceFeature(ped,2,currentCharacterMode.noseLength)
        SetPedFaceFeature(ped,3,currentCharacterMode.noseBridge)
        SetPedFaceFeature(ped,4,currentCharacterMode.noseTip)
        SetPedFaceFeature(ped,15,currentCharacterMode.chinLength)
        SetPedFaceFeature(ped,17,currentCharacterMode.chinWidth)
        SetPedFaceFeature(ped,18,currentCharacterMode.chinShape)
        SetPedFaceFeature(ped,16,currentCharacterMode.chinPosition)
        SetPedFaceFeature(ped,12,currentCharacterMode.lips)
        SetPedFaceFeature(ped,8,currentCharacterMode.cheekboneHeight)
        SetPedFaceFeature(ped,9,currentCharacterMode.cheekboneWidth)
        SetPedFaceFeature(ped,13,currentCharacterMode.jawWidth)
        SetPedFaceFeature(ped,14,currentCharacterMode.jawHeight)
        SetPedFaceFeature(ped,19,currentCharacterMode.neckWidth)
        SetPedHeadOverlay(ped,1,currentCharacterMode.beardModel,0.99)
        SetPedHeadOverlayColor(ped,1,1,currentCharacterMode.beardColor,currentCharacterMode.beardColor)
        SetPedHeadOverlay(ped,8,currentCharacterMode.lipstickModel,0.99)
        SetPedHeadOverlayColor(ped,8,2,currentCharacterMode.lipstickColor,currentCharacterMode.lipstickColor)
        SetPedHeadOverlay(ped,4,currentCharacterMode.makeupModel,0.99)
        SetPedHeadOverlayColor(ped,4,0,0,0)
        SetPedHeadOverlay(ped,5,currentCharacterMode.blushModel,0.99)
        SetPedHeadOverlayColor(ped,5,2,currentCharacterMode.blushColor,currentCharacterMode.blushColor)
        SetPedHeadOverlay(ped,10,currentCharacterMode.chestModel,0.99)
        SetPedHeadOverlayColor(ped,10,1,currentCharacterMode.chestColor,currentCharacterMode.chestColor)
        SetPedHeadOverlay(ped,7,currentCharacterMode.sundamageModel,0.99)
        SetPedHeadOverlayColor(ped,7,0,0,0)
        SetPedHeadOverlay(ped,3,currentCharacterMode.ageingModel,0.99)
        SetPedHeadOverlayColor(ped,3,0,0,0)
        SetPedHeadOverlay(ped,0,currentCharacterMode.blemishesModel,0.99)
        SetPedHeadOverlayColor(ped,0,0,0,0)
        SetPedHeadOverlay(ped,9,currentCharacterMode.frecklesModel,0.99)
        SetPedHeadOverlayColor(ped,9,0,0,0)
        SetPedHeadOverlay(ped,6,currentCharacterMode.complexionModel,0.99)
        SetPedHeadOverlayColor(ped,6,0,0,0)
        SetPedComponentVariation(ped,2,currentCharacterMode.hairModel,0,0)
        SetPedHairColor(ped,currentCharacterMode.firstHairColor,currentCharacterMode.secondHairColor)
	else
		SetPedComponentVariation(PlayerPedId(),1,-1,0,2)
		SetPedComponentVariation(PlayerPedId(),5,-1,0,2)
		SetPedComponentVariation(PlayerPedId(),7,-1,0,2)
		SetPedComponentVariation(PlayerPedId(),3,15,0,2)
		SetPedComponentVariation(PlayerPedId(),4,15,0,2)
		SetPedComponentVariation(PlayerPedId(),8,7,0,2)
		SetPedComponentVariation(PlayerPedId(),6,5,0,2)
		SetPedComponentVariation(PlayerPedId(),11,5,0,2)
		SetPedComponentVariation(PlayerPedId(),9,-1,0,2)
		SetPedComponentVariation(PlayerPedId(),10,-1,0,2)
		SetPedPropIndex(PlayerPedId(),2,-1,0,2)
		SetPedPropIndex(PlayerPedId(),6,-1,0,2)
		SetPedPropIndex(PlayerPedId(),7,-1,0,2)
        SetPedComponentVariation(PlayerPedId(),1,0,0,2)
        SetPedComponentVariation(PlayerPedId(),3,15,0,2)
        SetPedComponentVariation(PlayerPedId(),4,1,0,2)
        SetPedComponentVariation(PlayerPedId(),6,0,0,2)
        SetPedComponentVariation(PlayerPedId(),7,0,0,2)
        SetPedComponentVariation(PlayerPedId(),8,1,0,2)
        SetPedComponentVariation(PlayerPedId(),9,0,0,2)
        SetPedComponentVariation(PlayerPedId(),10,0,0,2)
        SetPedComponentVariation(PlayerPedId(),11,1,0,2)
        SetPedComponentVariation(PlayerPedId(),0,0,0,2)
        SetPedHeadBlendData(PlayerPedId(), currentCharacterMode.fathersID, currentCharacterMode.mothersID, 0, currentCharacterMode.skinColor,0, 0, moreValue(currentCharacterMode.shapeMix),0,0,false)
        SetPedHeadOverlay(ped,2,currentCharacterMode.eyebrowsModel,0.99)
        SetPedHeadOverlayColor(ped,2,1,currentCharacterMode.eyebrowsColor,currentCharacterMode.eyebrowsColor)
        SetPedFaceFeature(ped,6,currentCharacterMode.eyebrowsHeight)
        SetPedFaceFeature(ped,7,currentCharacterMode.eyebrowsWidth)
        SetPedFaceFeature(ped,0,currentCharacterMode.noseWidth)
        SetPedFaceFeature(ped,1,currentCharacterMode.noseHeight)
        SetPedFaceFeature(ped,2,currentCharacterMode.noseLength)
        SetPedFaceFeature(ped,3,currentCharacterMode.noseBridge)
        SetPedFaceFeature(ped,4,currentCharacterMode.noseTip)
        SetPedFaceFeature(ped,15,currentCharacterMode.chinLength)
        SetPedFaceFeature(ped,17,currentCharacterMode.chinWidth)
        SetPedFaceFeature(ped,18,currentCharacterMode.chinShape)
        SetPedFaceFeature(ped,16,currentCharacterMode.chinPosition)
        SetPedFaceFeature(ped,12,currentCharacterMode.lips)
        SetPedFaceFeature(ped,8,currentCharacterMode.cheekboneHeight)
        SetPedFaceFeature(ped,9,currentCharacterMode.cheekboneWidth)
        SetPedFaceFeature(ped,13,currentCharacterMode.jawWidth)
        SetPedFaceFeature(ped,14,currentCharacterMode.jawHeight)
        SetPedFaceFeature(ped,19,currentCharacterMode.neckWidth)
        SetPedHeadOverlay(ped,1,currentCharacterMode.beardModel,0.99)
        SetPedHeadOverlayColor(ped,1,1,currentCharacterMode.beardColor,currentCharacterMode.beardColor)
        SetPedHeadOverlay(ped,8,currentCharacterMode.lipstickModel,0.99)
        SetPedHeadOverlayColor(ped,8,2,currentCharacterMode.lipstickColor,currentCharacterMode.lipstickColor)
        SetPedHeadOverlay(ped,4,currentCharacterMode.makeupModel,0.99)
        SetPedHeadOverlayColor(ped,4,0,0,0)
        SetPedHeadOverlay(ped,5,currentCharacterMode.blushModel,0.99)
        SetPedHeadOverlayColor(ped,5,2,currentCharacterMode.blushColor,currentCharacterMode.blushColor)
        SetPedHeadOverlay(ped,10,currentCharacterMode.chestModel,0.99)
        SetPedHeadOverlayColor(ped,10,1,currentCharacterMode.chestColor,currentCharacterMode.chestColor)
        SetPedHeadOverlay(ped,7,currentCharacterMode.sundamageModel,0.99)
        SetPedHeadOverlayColor(ped,7,0,0,0)
        SetPedHeadOverlay(ped,3,currentCharacterMode.ageingModel,0.99)
        SetPedHeadOverlayColor(ped,3,0,0,0)
        SetPedHeadOverlay(ped,0,currentCharacterMode.blemishesModel,0.99)
        SetPedHeadOverlayColor(ped,0,0,0,0)
        SetPedHeadOverlay(ped,9,currentCharacterMode.frecklesModel,0.99)
        SetPedHeadOverlayColor(ped,9,0,0,0)
        SetPedHeadOverlay(ped,6,currentCharacterMode.complexionModel,0.99)
        SetPedHeadOverlayColor(ped,6,0,0,0)
        SetPedComponentVariation(ped,2,currentCharacterMode.hairModel,0,0)
        SetPedHairColor(ped,currentCharacterMode.firstHairColor,currentCharacterMode.secondHairColor)
    end
    SetEntityVisible(PlayerPedId(), true)
    SetEntityHealth(PlayerPedId(),400)
end


RegisterNUICallback("changeCustom", function(data, cb)
    changeClothe(data.type, data.id)
end)

function changeClothe(type, id)
    dados = type
    tipo = tonumber(parseInt(id))
	cor = 0
    setRoupa(dados, tipo, cor)
end

function setRoupa(dados, tipo, cor)
    local ped = PlayerPedId()

	if type(dados) == "number" then
		SetPedComponentVariation(ped, dados, tipo, cor, 1)
    elseif type(dados) == "string" then
        SetPedPropIndex(ped, parse_part(dados), tipo, cor, 1)
        dados = "p" .. (parse_part(dados))
	end
	  
  	custom = vRP.getCustomization()
  	custom.modelhash = nil

	aux = old_custom[dados]
	v = custom[dados]

end

function parse_part(key)
    if type(key) == "string" and string.sub(key, 1, 1) == "p" then
        return tonumber(string.sub(key, 2))
    else
        return false, tonumber(key)
    end
end

RegisterNUICallback("trocarClasse", function(data, cb)
    dataPart = parts[data.part]
    local ped = PlayerPedId()
    if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
        SendNUIMessage({ 
            changeCategory = true, 
            sexo = "Male", prefix = "M", 
            drawa = vRP.getDrawables(dataPart), 
            category = dataPart,
            url = Config_client['url']
        })
    elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then 
        SendNUIMessage({ 
            changeCategory = true, 
            sexo = "Female", prefix = "F", 
            drawa = vRP.getDrawables(dataPart), 
            category = dataPart,
            url = Config_client['url']
        })
    end
end)

RegisterNUICallback("changeColor", function(data, cb)
    if type(dados) == "number" then
        max = GetNumberOfPedTextureVariations(PlayerPedId(), dados, tipo)
    elseif type(dados) == "string" then
        max = GetNumberOfPedPropTextureVariations(PlayerPedId(), parse_part(dados), tipo)
    end

    if data.action == "menos" then
        if cor > 0 then cor = cor - 1 else cor = max end
    elseif data.action == "mais" then
        if cor < max then cor = cor + 1 else cor = 0 end
    end
    if dados and tipo then setRoupa(dados, tipo, cor) end
end)

RegisterNUICallback("updateRotate", function(data, cb)
    if data then
        SetEntityHeading(PlayerPedId(), moreValue(data.valor))
    end
end)

function moreValue(n)
	n = n + 0.00000
	return n
end

RegisterNUICallback("payament", function(data, cb)
    carroCompras = {
        mascara = false,
        mao = false,
        calca = false,
        mochila = false,
        sapato = false,
        gravata = false,
        camisa = false,
		colete = false,
        jaqueta = false,
        bone = false,
        oculos = false,
        brinco = false,
        relogio = false,
        bracelete = false
    }
end)

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while freezedOnTop do
		if doStatus == 2 then
			TriggerCamController(doStatus)
			TriggerCamController(-2)
			freezedOnTop = false
		end
		Citizen.Wait(1)
	end
end)


RegisterNetEvent('ToogleBackCharacter')
AddEventHandler('ToogleBackCharacter',function()
	doStatus = 2
end)

function dPN.cameraStartar(firstspawn)
    if firstspawn then
		TriggerCamController(-1)
		EndFade()
		doStatus = 2
		TriggerCamController(doStatus)
    else
        TriggerCamController(-1)
		TriggerEvent("vrp:ToogleLoginMenu")
	end
end
RegisterNetEvent("dpn:normalSpawn")
AddEventHandler("dpn:normalSpawn",function(firstspawn)
	if not firstspawn then
		TriggerCamController(-1)
		EndFade()
		doStatus = 2
		TriggerCamController(doStatus)
	else
		freezedOnTop = true
		doStatus = 2				
		TriggerEvent("vrp_login:Spawn",firstspawn)		
	end
end)
function TriggerCamController(statusSent)
	if not DoesCamExist(cam) then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
	end

	if statusSent == -1 then
		local pos = GetEntityCoords(PlayerPedId())
		SetCamCoord(cam,vector3(pos.x,pos.y,moreValue(1000)))
		SetCamRot(cam,-moreValue(90),moreValue(0),moreValue(0),2)
		SetCamActive(cam,true)
		StopCamPointing(cam)
		RenderScriptCams(true,true,0,0,0,0)
	elseif statusSent == 2 then
		local pos = GetEntityCoords(PlayerPedId())
		SetCamCoord(cam,vector3(pos.x,pos.y,moreValue(1000)))
		altura = 1000
		while altura > 50 do
			if altura <= 300 then
				altura = altura - 6
			elseif altura >= 301 and altura <= 700 then
				altura = altura - 4
			else
				altura = altura - 2
			end
			setCamHeight(altura)
			Citizen.Wait(10)
		end
	elseif statusSent == -2 then
		SetCamActive(cam,false)
		StopCamPointing(cam)
		RenderScriptCams(0,0,0,0,0,0)
		SetFocusEntity(PlayerPedId())
	elseif statusSent == 1 then
		SetCamCoord(cam,vector3(402.6,-997.2,-98.3))
		SetCamRot(cam,moreValue(0),moreValue(0),moreValue(358),15)
		SetCamActive(cam,true)
		RenderScriptCams(true,true,20000000000000000000000000,0,0,0)
	end
end

function setCamHeight(height)
	local pos = GetEntityCoords(PlayerPedId())
	SetCamCoord(cam,vector3(pos.x,pos.y,moreValue(height)))
end

function EndFade()
	ShutdownLoadingScreen()
	DoScreenFadeIn(500)
	while IsScreenFadingIn() do
		Citizen.Wait(1)
	end
end

RegisterCommand(Config_client['command'],function()
    -- if dPNserver.checkPermission() then
        TransitionToBlurred(1000)
        SetNuiFocus(true,true)
        SendNUIMessage({action = "resetPerson",})
    -- end
end)
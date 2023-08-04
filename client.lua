

Config = {

    MenuPosition = 'top-left',
    ActiverCommande = true, 
    CommandeName = 'MenuEditor', 
    ActiverKeybind = true,  -- Si activer commande = false, ne fonctionnera pas
    KeyOpenMenu = 'F7'
}

-- Le menu peut s'ouvrir avec le trigger :
-- Coté client : TriggerEvent('Kotonier:RockstarEditorOpen')
-- Coté Server : TriggerClientEvent('Kotonier:RockstarEditorOpen', source)


if Config.ActiverCommande == true then
    RegisterCommand(Config.CommandeName, function()
        RockstarMenu()
    end, false)
end

if Config.ActiverKeybind == true then
    RegisterKeyMapping(Config.CommandeName, 'Menu Rockstar Editor', 'keyboard', Config.KeyOpenMenu)
end

RegisterNetEvent("Kotonier:RockstarEditorOpen")
AddEventHandler("Kotonier:RockstarEditorOpen", function()
    RockstarMenu()
end)


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    local OpenMenu = lib.getOpenMenu()
    lib.hideMenu(OpenMenu)
end)



RockstarMenu = function()
    local Buttons = {
        {
            icon = 'fa-solid fa-play',
            close = false,
            label = "Démarrer Enregistrement",
            args = {start = true},
        },
        {
            icon = 'fa-solid fa-stop',
            close = false,
            label = "Stopper et Enregistrement",
            args = {stopsave = true}, 
        },
        {
            icon = 'fa-solid fa-hand',
            close = false,
            label = "Stop et supprimer",
            args = {stopdelete = true},
        },
        {
            icon = 'fa-solid fa-right-from-bracket',
            close = false,
            label = "Ouvrir Rockstar Editor",
            description = "Ferme FiveM",
            args = {OpenREditor = true}
        },

    }

    lib.registerMenu({
        id = 'menu_rockstareditor',
        title = "Rockstar Editor",
        position = Config.MenuPosition,
        options = Buttons
    }, function(selected, scrollIndex, args)
        if args.start then
            start()
        elseif args.stopsave then
            stoprec()
        elseif args.stopdelete then
            stopanddelete()
        elseif args.OpenREditor then
            NetworkSessionLeaveSinglePlayer()
            ActivateRockstarEditor()
        end
    end)
    lib.showMenu('menu_rockstareditor')
end


function start()
    StartRecording(1)
end

function stoprec()
    StopRecordingAndSaveClip()
end
function stopanddelete()
    StopRecordingAndDiscardClip()
end
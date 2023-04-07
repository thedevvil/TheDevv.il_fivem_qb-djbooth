-- Variables

local QBCore = exports['qb-core']:GetCoreObject()
local currentZone = nil
local PlayerData = {}

-- Handlers

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then return end
	PlayerData = QBCore.Functions.GetPlayerData()
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

-- Static Header

local musicHeader = {
    {
        header = 'Müzik Aç!',
        params = {
            event = 'qb-djbooth:client:playMusic'
        }
    }
}

-- Main Menu

function createMusicMenu()
    musicMenu = {
        {
            isHeader = true,
            header = '💿 | DJ Mahmut'
        },
        {
            header = '🎶 | Şarkı Çal',
            txt = 'Youtube URL',
            params = {
                event = 'qb-djbooth:client:musicMenu',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = '⏸️ | Müziği Durdur',
            txt = 'Çalan müziği durdur',
            params = {
                isServer = true,
                event = 'qb-djbooth:server:pauseMusic',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = '▶️ | Devam Ettir',
            txt = 'Duraklatışmış müziği devam ettir',
            params = {
                isServer = true,
                event = 'qb-djbooth:server:resumeMusic',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = '🔈 | Ses Seviyesi',
            txt = 'Duraklatılmış müziği devam ettir',
            params = {
                event = 'qb-djbooth:client:changeVolume',
                args = {
                    zoneName = currentZone
                }
            }
        },
        {
            header = '❌ | Müziği Sonlandır',
            txt = 'Müziği sonlandır ve yeni şarkı seç',
            params = {
                isServer = true,
                event = 'qb-djbooth:server:stopMusic',
                args = {
                    zoneName = currentZone
                }
            }
        }
    }
end

-- DJ Booths

local vanilla = BoxZone:Create(Config.Locations['vanilla'].coords, 1, 1, {
    name="vanilla",
    heading=0,
})

vanilla:onPlayerInOut(function(isPointInside)
    if isPointInside and PlayerData.job.name == Config.Locations['vanilla'].job then
        currentZone = 'vanilla'
        exports['qb-menu']:showHeader(musicHeader)
    else
        currentZone = nil
        exports['qb-menu']:closeMenu()
    end
end)


local taxi = BoxZone:Create(Config.Locations['taxi'].coords, 1, 1, {
    name="taxi",
    heading=0,
})

taxi:onPlayerInOut(function(isPointInside)
    if isPointInside and PlayerData.job.name == Config.Locations['taxi'].job then
        currentZone = 'taxi'
        exports['qb-menu']:showHeader(musicHeader)
    else
        currentZone = nil
        exports['qb-menu']:closeMenu()
    end
end)

-- Events

RegisterNetEvent('qb-djbooth:client:playMusic', function()
    createMusicMenu()
    exports['qb-menu']:openMenu(musicMenu)
end)

RegisterNetEvent('qb-djbooth:client:musicMenu', function()
    local dialog = exports['qb-input']:ShowInput({
        header = 'Şarkı Seçimi',
        submitText = "Çal",
        inputs = {
            {
                type = 'text',
                isRequired = true,
                name = 'song',
                text = 'YouTube URL'
            }
        }
    })
    if dialog then
        if not dialog.song then return end
        TriggerServerEvent('qb-djbooth:server:playMusic', dialog.song, currentZone)
    end
end)

RegisterNetEvent('qb-djbooth:client:changeVolume', function()
    local dialog = exports['qb-input']:ShowInput({
        header = 'Müzik Sesi',
        submitText = "Çal",
        inputs = {
            {
                type = 'text', -- number doesn't accept decimals??
                isRequired = true,
                name = 'volume',
                text = 'Min: 0.01 - Max: 1'
            }
        }
    })
    if dialog then
        if not dialog.volume then return end
        TriggerServerEvent('qb-djbooth:server:changeVolume', dialog.volume, currentZone)
    end
end)
Config = {}

Config.DefaultVolume = 0.1 -- Accepted values are 0.01 - 1

Config.Locations = {
    ['vanilla'] = {
        ['job'] = 'vanilla', -- Required job to use booth
        ['radius'] = 30, -- The radius of the sound from the booth
        ['coords'] = vector3(120.52, -1281.5, 29.48), -- Where the booth is located
        ['playing'] = false
    },
    ['taxi'] = {
        ['job'] = 'taxi', -- Required job to use booth
        ['radius'] = 25, -- The radius of the sound from the booth
        ['coords'] = vector3(365.56, -349.69, 46.61), -- Where the booth is located
        ['playing'] = false
    },
}

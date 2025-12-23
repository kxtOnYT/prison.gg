local uiLoader = loadstring(game:HttpGet('https://raw.githubusercontent.com/topitbopit/dollarware/main/library.lua'))
local ui = uiLoader({
    rounding = false,
    theme = 'watermelon',
    smoothDragging = false
})

ui.autoDisableToggles = true

local window = ui.newWindow({
    text = 'prison.gg | private',
    resize = true,
    size = Vector2.new(550, 376),
    position = nil
})


local RunService = game:GetService("RunService")
local speedEnabled = false
local chosenSpeed = 16


-- SPINBOT VARIABLES
local spinEnabled = false
local spinSpeed = 20

local function getRoot(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function applySpin()
    local char = game.Players.LocalPlayer.Character
    local root = getRoot(char)
    if not root then return end

    for _, v in pairs(root:GetChildren()) do
        if v.Name == "Spinning" then
            v:Destroy()
        end
    end

    if spinEnabled then
        local Spin = Instance.new("BodyAngularVelocity")
        Spin.Name = "Spinning"
        Spin.Parent = root
        Spin.MaxTorque = Vector3.new(0, math.huge, 0)
        Spin.AngularVelocity = Vector3.new(0, spinSpeed, 0)
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if spinEnabled then
        applySpin()
    end
end)

local menu = window:addMenu({ text = 'main' })

do
    local section = menu:addSection({
        text = 'guns',
        side = 'auto',
        showMinButton = true
    })

    section:addLabel({ text = 'do not spam or you will get kicked' })
    section:addLabel({ text = 'only use if you are near the gun' })

    section:addButton({ text = 'tp mp5 (guard room)', style = 'large' }, function()
        ui.notify({ title = 'MP5', message = 'Teleported to MP5 (Guard Room)', duration = 3 })
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(813, 101, 2229)
    end)

    section:addButton({ text = 'tp shotgun (guard room)', style = 'large' }, function()
        ui.notify({ title = 'Shotgun', message = 'Teleported to Shotgun (Guard Room)', duration = 3 })
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(821, 101, 2229)
    end)
	
	section:addButton({
    text = 'load camlock',
    style = 'large'
}, function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/mangotherealest/1237kqtg46371gky5671klghy53671hkly51672khly5617yklf4671y2kf6741y2oi6745oyg1673lkhy567123yg56173/refs/heads/main/best%20universal%20camlock"))()
    end)
end):setTooltip('Loads the universal camlock script')


    section:addButton({ text = 'escape', style = 'large' }, function()
        ui.notify({ title = 'Escape', message = 'Escaping prison!', duration = 3 })
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(390, 79, 1986)
        task.wait(1)
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end)

    local section = menu:addSection({
        text = 'player',
        side = 'right',
        showMinButton = false
    })

    section:addSlider({
    text = 'Walkspeed',
    min = 1,
    max = 150,
    step = 1,
    val = 16
}, function(v)
    chosenSpeed = v
    if not speedEnabled then
        local hum = game.Players.LocalPlayer.Character and
                    game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = v
        end
    end
end)
section:addToggle({
    text = 'Speed Lock'
}, function(v)
    speedEnabled = v
end)


RunService.RenderStepped:Connect(function()
    if not speedEnabled then return end

    local char = game.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.WalkSpeed ~= chosenSpeed then
        hum.WalkSpeed = chosenSpeed
    end
end)

    section:addSlider({ text = 'JumpPower', min = 1, max = 150, step = 0.5, val = 5.5 }, function(v)
        game.Players.LocalPlayer.Character.Humanoid.JumpHeight = v
    end)

    section:addButton({ text = 'reset', style = 'large' }, function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end)


 -- SPINBOT TOGGLE
    section:addToggle({
        text = "Spinbot"
    }, function(v)
        spinEnabled = v
        applySpin()
    end)

    -- SPIN SPEED SLIDER
    section:addSlider({
        text = "Spin Speed",
        min = 1,
        max = 100,
        step = 1,
        val = 20
    }, function(v)
        spinSpeed = v
        if spinEnabled then
            applySpin()
        end
    end)


end


local espMenu = window:addMenu({ text = 'esp' })
local espSection = espMenu:addSection({
    text = 'player esp',
    side = 'auto',
    showMinButton = true
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local ESP = {
    Enabled = false,
    Names = false,
    Boxes = false,
    Chams = false,
    Distance = false,
    TeamCheck = false,
    Color = Color3.fromRGB(255, 0, 0)
}

local ESPObjects = {}

local function createESP(player)
    if player == Players.LocalPlayer then return end
    if ESPObjects[player] then return end

    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Visible = false

    local name = Drawing.new("Text")
    name.Size = 13
    name.Center = true
    name.Outline = true
    name.Visible = false

    local distance = Drawing.new("Text")
    distance.Size = 13
    distance.Center = true
    distance.Outline = true
    distance.Visible = false

    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Enabled = false
    highlight.Parent = game:GetService("CoreGui")

    ESPObjects[player] = {
        Box = box,
        Name = name,
        Distance = distance,
        Highlight = highlight
    }
end

local function removeESP(player)
    local esp = ESPObjects[player]
    if not esp then return end
    for _, obj in pairs(esp) do
        if typeof(obj) == "Instance" then obj:Destroy() else obj:Remove() end
    end
    ESPObjects[player] = nil
end

for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    for player, esp in pairs(ESPObjects) do
        if not ESP.Enabled then
            esp.Box.Visible = false
            esp.Name.Visible = false
            esp.Distance.Visible = false
            esp.Highlight.Enabled = false
            continue
        end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then continue end
        if ESP.TeamCheck and player.Team == Players.LocalPlayer.Team then continue end

        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then continue end

        local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
        local scale = math.clamp(220 / dist, 0.7, 2)
        local size = Vector2.new(28, 42) * scale

        esp.Box.Size = size
        esp.Box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
        esp.Box.Color = ESP.Color
        esp.Box.Visible = ESP.Boxes

        esp.Name.Text = player.Name
        esp.Name.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 6)
        esp.Name.Color = ESP.Color
        esp.Name.Visible = ESP.Names

        esp.Distance.Text = math.floor(dist) .. " studs"
        esp.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y / 2)
        esp.Distance.Color = ESP.Color
        esp.Distance.Visible = ESP.Distance

        esp.Highlight.Adornee = char
        esp.Highlight.FillColor = ESP.Color
        esp.Highlight.OutlineColor = ESP.Color
        esp.Highlight.Enabled = ESP.Chams
    end
end)

espSection:addToggle({ text = 'Enable ESP' }, function(v) ESP.Enabled = v end)
espSection:addToggle({ text = 'Names' }, function(v) ESP.Names = v end)
espSection:addToggle({ text = 'Boxes' }, function(v) ESP.Boxes = v end)
espSection:addToggle({ text = 'Distance' }, function(v) ESP.Distance = v end)
espSection:addToggle({ text = 'Chams' }, function(v) ESP.Chams = v end)
espSection:addToggle({ text = 'Team Check' }, function(v) ESP.TeamCheck = v end)


espSection:addColorPicker({
    text = 'ESP Color',
    color = ESP.Color
}, function(newColor)
    ESP.Color = newColor
end)

local serverMenu = window:addMenu({
    text = 'server'
})


local serverSection = serverMenu:addSection({
    text = 'server actions',
    side = 'auto',
    showMinButton = true
})

serverSection:addButton({
    text = 'Rejoin',
    style = 'large'
}, function()
    local Players = game:GetService("Players")
    local TeleportService = game:GetService("TeleportService")
    TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
end)

serverSection:addButton({
    text = 'Server Hop',
    style = 'large'
}, function()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")

    local placeId = game.PlaceId
    local currentJobId = game.JobId
    local cursor = ""
    local servers = {}

    repeat
        local url = "https://games.roblox.com/v1/games/" .. placeId ..
            "/servers/Public?sortOrder=Asc&limit=100" ..
            (cursor ~= "" and "&cursor=" .. cursor or "")

        local response = HttpService:JSONDecode(game:HttpGet(url))

        for _, server in ipairs(response.data) do
            if server.id ~= currentJobId and server.playing < server.maxPlayers then
                table.insert(servers, server.id)
            end
        end

        cursor = response.nextPageCursor
    until #servers > 0 or not cursor

    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(
            placeId,
            servers[math.random(#servers)],
            Players.LocalPlayer
        )
    end
end)


local infoSection = serverMenu:addSection({
    text = 'server info',
    side = 'right',
    showMinButton = true
})

local Players = game:GetService("Players")

local playerCountLabel = infoSection:addLabel({
    text = 'Players: loading...'
})

local serverAgeLabel = infoSection:addLabel({
    text = 'Server Age: loading...'
})

infoSection:addLabel({ text = 'Game ID: ' .. game.PlaceId })
infoSection:addLabel({ text = 'Job ID:' })
infoSection:addLabel({ text = game.JobId })

task.spawn(function()
    while task.wait(1) do
        playerCountLabel:setText(
            'Players: ' .. #Players:GetPlayers() .. '/' .. Players.MaxPlayers
        )

        local age = math.floor(workspace.DistributedGameTime)
        serverAgeLabel:setText(
            string.format('Server Age: %02dm %02ds', math.floor(age / 60), age % 60)
        )
    end
end)

infoSection:addButton({
    text = 'Copy Job ID',
    style = 'small'
}, function()
    if setclipboard then
        setclipboard(game.JobId)
    end
end)

local joinJobId = ""

infoSection:addTextbox({
    text = 'Join Job ID',
    placeholder = 'paste job id here'
}, function(v)
    joinJobId = v
end)

infoSection:addButton({
    text = 'Join Server',
    style = 'large'
}, function()
    if joinJobId ~= "" then
        game:GetService("TeleportService"):TeleportToPlaceInstance(
            game.PlaceId,
            joinJobId,
            game:GetService("Players").LocalPlayer
        )
    end
end)

local playersMenu = window:addMenu({ text = "players" })

local playersListSection = playersMenu:addSection({
    text = "All Players",
    side = "left",
    showMinButton = true
})

local playerInfoSection = playersMenu:addSection({
    text = "Player Info",
    side = "right",
    showMinButton = true
})

local selectedPlayer = nil

-- Live info labels
local nameLabel = playerInfoSection:addLabel({ text = "Name: N/A" })
local userIdLabel = playerInfoSection:addLabel({ text = "UserId: N/A" })
local teamLabel = playerInfoSection:addLabel({ text = "Team: N/A" })
local healthLabel = playerInfoSection:addLabel({ text = "Health: N/A" })
local positionLabel = playerInfoSection:addLabel({ text = "Position: N/A" })

-- Teleport button
local tpButton = playerInfoSection:addButton({
    text = "Teleport to Player",
    style = "large"
}, function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
            selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end)

-- Update live info for selected player
local function updateInfo()
    if not selectedPlayer or not selectedPlayer.Character then
        nameLabel:setText("Name: N/A")
        userIdLabel:setText("UserId: N/A")
        teamLabel:setText("Team: N/A")
        healthLabel:setText("Health: N/A")
        positionLabel:setText("Position: N/A")
        return
    end

    local char = selectedPlayer.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    nameLabel:setText("Name: " .. selectedPlayer.Name)
    userIdLabel:setText("UserId: " .. selectedPlayer.UserId)
    teamLabel:setText("Team: " .. (selectedPlayer.Team and selectedPlayer.Team.Name or "None"))
    healthLabel:setText("Health: " .. (hum and math.floor(hum.Health) or "N/A"))
    positionLabel:setText("Position: " .. (hrp and tostring(hrp.Position) or "N/A"))
end

-- Player list buttons
local listButtons = {}

local function refreshPlayerList()
    for _, btn in ipairs(listButtons) do
        if btn.removeFromParent then
            btn:removeFromParent()
        end
    end
    listButtons = {}

    for _, player in ipairs(Players:GetPlayers()) do
        local btn = playersListSection:addButton({
            text = player.Name,
            style = "small"
        }, function()
            selectedPlayer = player
            updateInfo()
        end)
        table.insert(listButtons, btn)
    end
end

refreshPlayerList()

Players.PlayerAdded:Connect(function()
    refreshPlayerList()
end)

Players.PlayerRemoving:Connect(function(player)
    if selectedPlayer == player then
        selectedPlayer = nil
        updateInfo()
    end
    refreshPlayerList()
end)

-- Live update health/position every frame
game:GetService("RunService").RenderStepped:Connect(function()
    updateInfo()
end)


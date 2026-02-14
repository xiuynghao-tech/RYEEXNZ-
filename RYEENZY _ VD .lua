-- VIOLENCE DISTRICT - ULTIMATE CHEAT (OBSIDIAN UI EDITION)
-- Menggunakan UI Library Obsidian (modifikasi Linoria)
-- Fitur Lengkap: ESP, Auto Parry, Auto Kill, No Cooldown, Teleport, dll

-- ============================================
-- LOAD OBSIDIAN UI LIBRARY
-- ============================================
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

-- Setup Window
local Window = Library:CreateWindow({
    Title = "RYEENZY | VD",
    Footer = "PREMIUM SCRIP BY RYEENZY",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
    Resizable = true,
})

-- ============================================
-- VARIABEL GLOBAL
-- ============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- Database settings
getgenv().VD = {
    ESP = {
        Enabled = false,
        Survivors = true,
        Killer = true,
        Generators = true,
        Hooks = true,
        Chests = true,
        Tracers = true,
        Names = true,
        Health = true,
        Distance = true,
        Boxes = false,
    },
    Colors = {
        Survivor = Color3.new(0, 1, 0),
        Killer = Color3.new(1, 0, 0),
        Hook = Color3.new(1, 0.5, 0),
        Generator = Color3.new(0, 1, 1),
        Chest = Color3.new(1, 1, 0),
        Tracer = Color3.new(1, 1, 1),
    },
    Survivor = {
        AutoParry = false,
        AutoGenerator = false,
        AutoHeal = false,
        NoSkillCheck = false,
        AutoChest = false,
    },
    Killer = {
        AutoKill = false,
        NoCooldown = false,
        AntiStun = false,
        BiggerHitbox = false,
        FastReload = false,
    },
    Movement = {
        Walkspeed = 16,
        JumpPower = 50,
        NoClip = false,
        Fly = false,
        Teleport = false,
        SpeedBoost = false,
    },
    Visuals = {
        Fullbright = false,
        NoFog = false,
    },
}

-- ============================================
-- FUNGSI DETEKSI OBJEK
-- ============================================

local function GetKiller()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            for _, obj in pairs(plr.Character:GetChildren()) do
                if obj:IsA("Tool") then
                    return plr
                end
            end
        end
    end
    return nil
end

local function GetGenerators()
    local gens = {}
    local keywords = {"generator", "gen", "repair", "power", "gens", "generat"}
    for _, obj in pairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        for _, kw in pairs(keywords) do
            if name:find(kw) then
                if obj:IsA("BasePart") or obj:IsA("Model") then
                    table.insert(gens, obj)
                end
                break
            end
        end
    end
    return gens
end

local function GetHooks()
    local hooks = {}
    local keywords = {"hook", "kait", "hanger", "meat", "hang", "hook_"}
    for _, obj in pairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        for _, kw in pairs(keywords) do
            if name:find(kw) then
                if obj:IsA("BasePart") then
                    table.insert(hooks, obj)
                end
                break
            end
        end
    end
    return hooks
end

local function GetChests()
    local chests = {}
    local keywords = {"chest", "loot", "crate", "box", "peti"}
    for _, obj in pairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        for _, kw in pairs(keywords) do
            if name:find(kw) then
                if obj:IsA("BasePart") then
                    table.insert(chests, obj)
                end
                break
            end
        end
    end
    return chests
end

-- ============================================
-- FUNGSI ESP
-- ============================================

local function CreatePlayerESP(plr, isKiller)
    if not plr or not plr.Character then return end
    
    local char = plr.Character
    local color = isKiller and getgenv().VD.Colors.Killer or getgenv().VD.Colors.Survivor
    local head = char:FindFirstChild("Head")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if not head or not root then return end
    
    -- HIGHLIGHT
    local highlight = Instance.new("Highlight")
    highlight.Name = "VD_ESP"
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
    
    -- HEALTH BAR
    if getgenv().VD.ESP.Health then
        local healthBar = Instance.new("BillboardGui")
        healthBar.Name = "VD_HealthBar"
        healthBar.Size = UDim2.new(0, 50, 0, 5)
        healthBar.StudsOffset = Vector3.new(0, 3, 0)
        healthBar.AlwaysOnTop = true
        healthBar.Parent = head
        
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        bg.BorderSizePixel = 0
        bg.Parent = healthBar
        
        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Size = UDim2.new(1, 0, 1, 0)
        fill.BackgroundColor3 = isKiller and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
        fill.BorderSizePixel = 0
        fill.Parent = bg
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                fill.Size = UDim2.new(hum.Health / hum.MaxHealth, 0, 1, 0)
            end)
        end
    end
    
    -- NAME TAG + DISTANCE
    if getgenv().VD.ESP.Names then
        local nameTag = Instance.new("BillboardGui")
        nameTag.Name = "VD_NameTag"
        nameTag.Size = UDim2.new(0, 150, 0, 40)
        nameTag.StudsOffset = Vector3.new(0, 3.5, 0)
        nameTag.AlwaysOnTop = true
        nameTag.Parent = head
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = plr.Name
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Parent = nameTag
        
        if getgenv().VD.ESP.Distance then
            local distLabel = Instance.new("TextLabel")
            distLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distLabel.BackgroundTransparency = 1
            distLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            distLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            distLabel.TextScaled = true
            distLabel.Font = Enum.Font.Gotham
            distLabel.Parent = nameTag
            
            coroutine.wrap(function()
                while nameTag and nameTag.Parent do
                    task.wait(0.2)
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local myRoot = LocalPlayer.Character.HumanoidRootPart
                        local dist = math.floor((myRoot.Position - root.Position).magnitude)
                        distLabel.Text = dist .. "m"
                    end
                end
            end)()
        end
    end
end

-- TRACERS
local tracers = {}
RunService.RenderStepped:Connect(function()
    if not getgenv().VD.ESP.Enabled or not getgenv().VD.ESP.Tracers then
        for _, tracer in pairs(tracers) do
            if tracer then tracer.Visible = false end
        end
        return
    end
    
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local killer = GetKiller()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for i, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local isKiller = (plr == killer)
                
                if (isKiller and getgenv().VD.ESP.Killer) or (not isKiller and getgenv().VD.ESP.Survivors) then
                    if not tracers[i] then
                        tracers[i] = Drawing.new("Line")
                        tracers[i].Thickness = 2
                        tracers[i].Transparency = 0.7
                    end
                    
                    local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                    if onScreen then
                        tracers[i].From = screenCenter
                        tracers[i].To = Vector2.new(screenPos.X, screenPos.Y)
                        tracers[i].Color = isKiller and getgenv().VD.Colors.Killer or getgenv().VD.Colors.Survivor
                        tracers[i].Visible = true
                    else
                        tracers[i].Visible = false
                    end
                elseif tracers[i] then
                    tracers[i].Visible = false
                end
            end
        end
    end
end)

-- ESP Generator
local function CreateGeneratorESP(gen)
    if not gen or not gen:IsA("BasePart") then return end
    gen.BrickColor = BrickColor.new("Cyan")
    gen.Material = Enum.Material.Neon
    gen.Transparency = 0.3
end

-- ESP Hook
local function CreateHookESP(hook)
    if not hook or not hook:IsA("BasePart") then return end
    hook.BrickColor = BrickColor.new("Bright orange")
    hook.Material = Enum.Material.Neon
    hook.Transparency = 0.2
end

-- ESP Chest
local function CreateChestESP(chest)
    if not chest or not chest:IsA("BasePart") then return end
    chest.BrickColor = BrickColor.new("Bright yellow")
    chest.Material = Enum.Material.Neon
    chest.Transparency = 0.2
end

local function RemoveAllESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            local highlight = plr.Character:FindFirstChildOfClass("Highlight")
            if highlight and highlight.Name == "VD_ESP" then highlight:Destroy() end
            local healthBar = plr.Character:FindFirstChild("VD_HealthBar", true)
            if healthBar then healthBar:Destroy() end
            local nameTag = plr.Character:FindFirstChild("VD_NameTag", true)
            if nameTag then nameTag:Destroy() end
        end
    end
    
    for _, gen in pairs(GetGenerators()) do
        if gen:IsA("BasePart") then gen.Material = Enum.Material.Plastic gen.Transparency = 0 end
    end
    
    for _, hook in pairs(GetHooks()) do
        if hook:IsA("BasePart") then hook.Material = Enum.Material.Plastic hook.Transparency = 0 end
    end
    
    for _, chest in pairs(GetChests()) do
        if chest:IsA("BasePart") then chest.Material = Enum.Material.Plastic chest.Transparency = 0 end
    end
end

-- ============================================
-- FUNGSI AUTO FEATURES
-- ============================================

local function DoAutoParry()
    if not getgenv().VD.Survivor.AutoParry then return end
    local killer = GetKiller()
    if not killer or not killer.Character then return end
    
    local killerRoot = killer.Character:FindFirstChild("HumanoidRootPart")
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if killerRoot and myRoot and (killerRoot.Position - myRoot.Position).magnitude < 15 then
        for _, obj in pairs(LocalPlayer.Character:GetDescendants()) do
            if obj:IsA("RemoteEvent") and obj.Name:lower():find("parry") then
                pcall(function() obj:FireServer() end)
            end
        end
    end
end

local function DoAutoGenerator()
    if not getgenv().VD.Survivor.AutoGenerator then return end
    local gens = GetGenerators()
    if #gens == 0 then return end
    
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local closestGen = nil
    local closestDist = math.huge
    
    for _, gen in pairs(gens) do
        local genPos = gen:IsA("BasePart") and gen.Position
        if genPos then
            local dist = (myRoot.Position - genPos).magnitude
            if dist < closestDist then
                closestDist = dist
                closestGen = gen
            end
        end
    end
    
    if closestGen then
        if closestDist > 5 then
            myRoot.CFrame = CFrame.new(closestGen.Position) + Vector3.new(0, 3, 0)
        else
            if closestGen:IsA("BasePart") then
                firetouchinterest(myRoot, closestGen, 0)
                firetouchinterest(myRoot, closestGen, 1)
            end
        end
    end
end

local function DoAutoKill()
    if not getgenv().VD.Killer.AutoKill then return end
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local closestSurvivor = nil
    local closestDist = math.huge
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (myRoot.Position - root.Position).magnitude
                if dist < closestDist then
                    closestDist = dist
                    closestSurvivor = plr
                end
            end
        end
    end
    
    if closestSurvivor and closestDist < 20 then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                tool:Activate()
            end
        end
        myRoot.CFrame = CFrame.lookAt(myRoot.Position, closestSurvivor.Character.HumanoidRootPart.Position)
    end
end

-- ============================================
-- MEMBUAT TABS
-- ============================================
local Tabs = {
    ESP = Window:AddTab("ESP", "eye"),
    Survivor = Window:AddTab("Survivor", "user"),
    Killer = Window:AddTab("Killer", "swords"),
    Movement = Window:AddTab("Movement", "zap"),
    Visuals = Window:AddTab("Visuals", "sparkles"),
    Colors = Window:AddTab("Colors", "palette"),
    Settings = Window:AddTab("Settings", "settings"),
}

-- ============================================
-- ESP TAB
-- ============================================
local ESPGroup = Tabs.ESP:AddLeftGroupbox("ESP Settings")

ESPGroup:AddToggle("ESPEnabled", {
    Text = "Enable ESP",
    Tooltip = "Aktifkan semua fitur ESP",
    Default = false,
    Callback = function(v)
        getgenv().VD.ESP.Enabled = v
        if not v then RemoveAllESP() end
        Library:Notify(v and "ESP Activated" or "ESP Deactivated")
    end
})

ESPGroup:AddDivider()

ESPGroup:AddToggle("ShowSurvivors", {
    Text = "Show Survivors",
    Default = true,
    Callback = function(v) getgenv().VD.ESP.Survivors = v end
})

ESPGroup:AddToggle("ShowKiller", {
    Text = "Show Killer",
    Default = true,
    Callback = function(v) getgenv().VD.ESP.Killer = v end
})

ESPGroup:AddToggle("ShowGenerators", {
    Text = "Show Generators",
    Default = true,
    Callback = function(v) getgenv().VD.ESP.Generators = v end
})

ESPGroup:AddToggle("ShowHooks", {
    Text = "Show Hooks",
    Default = true,
    Callback = function(v) getgenv().VD.ESP.Hooks = v end
})

ESPGroup:AddToggle("ShowChests", {
    Text = "Show Chests",
    Default = true,
    Callback = function(v) getgenv().VD.ESP.Chests = v end
})

ESPGroup:AddDivider()

ESPGroup:AddToggle("ShowTracers", {
    Text = "Show Tracers",
    Default = true,
    Callback = function(v) getgenv().VD.ESP.Tracers = v end
})

ESPGroup:AddToggle("ShowNames", {
    Text = "Show Names",
    Default = true,
    Callback = function(v) getgenv().VD.ESP.Names = v end
})

ESPGroup:AddToggle("ShowDistance", {
    Text = "Show Distance",
    Default = true,
    Callback = function(v) getgenv().VD.ESP.Distance = v end
})

ESPGroup:AddToggle("ShowHealth", {
    Text = "Show Health Bars",
    Default = true,
    Callback = function(v) getgenv().VD.ESP.Health = v end
})

-- ============================================
-- COLORS TAB (dengan ColorPicker)
-- ============================================
local ColorsGroup = Tabs.Colors:AddLeftGroupbox("ESP Colors")

ColorsGroup:AddToggle("SurvivorColorToggle", {
    Text = "Custom Survivor Color",
    Default = true,
})  :AddColorPicker("SurvivorColor", {
    Default = Color3.new(0, 1, 0),
    Title = "Survivor Color",
    Callback = function(v) getgenv().VD.Colors.Survivor = v end
})

ColorsGroup:AddToggle("KillerColorToggle", {
    Text = "Custom Killer Color",
    Default = true,
})  :AddColorPicker("KillerColor", {
    Default = Color3.new(1, 0, 0),
    Title = "Killer Color",
    Callback = function(v) getgenv().VD.Colors.Killer = v end
})

ColorsGroup:AddToggle("HookColorToggle", {
    Text = "Custom Hook Color",
    Default = true,
})  :AddColorPicker("HookColor", {
    Default = Color3.new(1, 0.5, 0),
    Title = "Hook Color",
    Callback = function(v) getgenv().VD.Colors.Hook = v end
})

ColorsGroup:AddToggle("GeneratorColorToggle", {
    Text = "Custom Generator Color",
    Default = true,
})  :AddColorPicker("GeneratorColor", {
    Default = Color3.new(0, 1, 1),
    Title = "Generator Color",
    Callback = function(v) getgenv().VD.Colors.Generator = v end
})

ColorsGroup:AddToggle("ChestColorToggle", {
    Text = "Custom Chest Color",
    Default = true,
})  :AddColorPicker("ChestColor", {
    Default = Color3.new(1, 1, 0),
    Title = "Chest Color",
    Callback = function(v) getgenv().VD.Colors.Chest = v end
})

-- ============================================
-- SURVIVOR TAB
-- ============================================
local SurvivorGroup = Tabs.Survivor:AddLeftGroupbox("Survivor Features")

SurvivorGroup:AddToggle("AutoParry", {
    Text = "Auto Parry",
    Tooltip = "Otomatis memblokir serangan killer",
    Default = false,
    Callback = function(v) getgenv().VD.Survivor.AutoParry = v end
})

SurvivorGroup:AddToggle("AutoGenerator", {
    Text = "Auto Generator",
    Tooltip = "Otomatis memperbaiki generator",
    Default = false,
    Callback = function(v) getgenv().VD.Survivor.AutoGenerator = v end
})

SurvivorGroup:AddToggle("AutoChest", {
    Text = "Auto Chest",
    Tooltip = "Otomatis membuka chest",
    Default = false,
    Callback = function(v) getgenv().VD.Survivor.AutoChest = v end
})

SurvivorGroup:AddToggle("NoSkillCheck", {
    Text = "No Skill Check",
    Tooltip = "Menghilangkan skill check",
    Default = false,
    Callback = function(v) getgenv().VD.Survivor.NoSkillCheck = v end
})

-- ============================================
-- KILLER TAB
-- ============================================
local KillerGroup = Tabs.Killer:AddLeftGroupbox("Killer Features")

KillerGroup:AddToggle("AutoKill", {
    Text = "Auto Kill",
    Tooltip = "Otomatis membunuh survivor terdekat",
    Default = false,
    Risky = true,
    Callback = function(v) getgenv().VD.Killer.AutoKill = v end
})

KillerGroup:AddToggle("NoCooldown", {
    Text = "No Cooldown",
    Tooltip = "Menghilangkan cooldown ability",
    Default = false,
    Callback = function(v) getgenv().VD.Killer.NoCooldown = v end
})

KillerGroup:AddToggle("AntiStun", {
    Text = "Anti Stun",
    Tooltip = "Mencegah efek stun",
    Default = false,
    Callback = function(v) getgenv().VD.Killer.AntiStun = v end
})

-- ============================================
-- MOVEMENT TAB
-- ============================================
local MovementGroup = Tabs.Movement:AddLeftGroupbox("Movement")

MovementGroup:AddSlider("Walkspeed", {
    Text = "Walk Speed",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Suffix = "studs/s",
    Callback = function(v)
        getgenv().VD.Movement.Walkspeed = v
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end
    end
})

MovementGroup:AddSlider("JumpPower", {
    Text = "Jump Power",
    Default = 50,
    Min = 50,
    Max = 200,
    Rounding = 0,
    Callback = function(v)
        getgenv().VD.Movement.JumpPower = v
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = v end
        end
    end
})

MovementGroup:AddToggle("NoClip", {
    Text = "NoClip",
    Tooltip = "Tembus dinding",
    Default = false,
    Callback = function(v) getgenv().VD.Movement.NoClip = v end
})

MovementGroup:AddToggle("Fly", {
    Text = "Fly Mode",
    Tooltip = "Mode terbang",
    Default = false,
    Callback = function(v) getgenv().VD.Movement.Fly = v end
})

MovementGroup:AddToggle("Teleport", {
    Text = "Teleport Mode",
    Tooltip = "Klik kiri untuk teleport",
    Default = false,
    Callback = function(v) getgenv().VD.Movement.Teleport = v end
})

-- ============================================
-- VISUALS TAB
-- ============================================
local VisualsGroup = Tabs.Visuals:AddLeftGroupbox("Visuals")

VisualsGroup:AddToggle("Fullbright", {
    Text = "Fullbright",
    Tooltip = "Terangi seluruh map",
    Default = false,
    Callback = function(v)
        getgenv().VD.Visuals.Fullbright = v
        if v then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 2
            Lighting.ClockTime = 12
        else
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.Brightness = 1
        end
    end
})

VisualsGroup:AddToggle("NoFog", {
    Text = "No Fog",
    Tooltip = "Hilangkan fog",
    Default = false,
    Callback = function(v)
        getgenv().VD.Visuals.NoFog = v
        Lighting.FogEnd = v and 100000 or 1000
    end
})

-- ============================================
-- SETTINGS TAB (Theme & Save)
-- ============================================
local SettingsGroup = Tabs.Settings:AddLeftGroupbox("Menu Settings")

SettingsGroup:AddKeybind("MenuKeybind", {
    Text = "Toggle Menu",
    Default = "RightShift",
    Callback = function() Library:SetOpen(not Library.Open) end
})

SettingsGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(v) Library.ShowCustomCursor = v end
})

-- Theme Manager
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:ApplyToTab(Tabs.Settings)

-- ============================================
-- INFO LABEL
-- ============================================
local InfoGroup = Tabs.Survivor:AddRightGroupbox("Information")
InfoGroup:AddLabel("Player: " .. LocalPlayer.Name, false, "PlayerLabel")
InfoGroup:AddLabel("Game: Violence District", false, "GameLabel")
InfoGroup:AddLabel("Fitur Lengkap 2025", false, "FiturLabel")

-- ============================================
-- MAIN LOOP ESP
-- ============================================
coroutine.wrap(function()
    while task.wait(0.3) do
        if getgenv().VD.ESP.Enabled then
            local killer = GetKiller()
            
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local isKiller = (plr == killer)
                    if (isKiller and getgenv().VD.ESP.Killer) or (not isKiller and getgenv().VD.ESP.Survivors) then
                        if not plr.Character:FindFirstChildOfClass("Highlight") then
                            CreatePlayerESP(plr, isKiller)
                        end
                    end
                end
            end
            
            if getgenv().VD.ESP.Generators then
                for _, gen in pairs(GetGenerators()) do
                    if gen:IsA("BasePart") then CreateGeneratorESP(gen) end
                end
            end
            
            if getgenv().VD.ESP.Hooks then
                for _, hook in pairs(GetHooks()) do
                    if hook:IsA("BasePart") then CreateHookESP(hook) end
                end
            end
            
            if getgenv().VD.ESP.Chests then
                for _, chest in pairs(GetChests()) do
                    if chest:IsA("BasePart") then CreateChestESP(chest) end
                end
            end
        else
            RemoveAllESP()
        end
    end
end)()

-- ============================================
-- FEATURE LOOPS
-- ============================================
RunService.Heartbeat:Connect(DoAutoParry)
coroutine.wrap(function() while task.wait(0.5) do DoAutoGenerator() end end)()
coroutine.wrap(function() while task.wait(0.3) do DoAutoKill() end end)()

-- No Cooldown
RunService.Heartbeat:Connect(function()
    if getgenv().VD.Killer.NoCooldown and LocalPlayer.Character then
        for _, obj in pairs(LocalPlayer.Character:GetDescendants()) do
            if obj:IsA("NumberValue") and obj.Name:lower():find("cooldown") then
                obj.Value = 0
            end
        end
    end
end)

-- Walkspeed maintain
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if hum.WalkSpeed ~= getgenv().VD.Movement.Walkspeed then
                hum.WalkSpeed = getgenv().VD.Movement.Walkspeed
            end
            if hum.JumpPower ~= getgenv().VD.Movement.JumpPower then
                hum.JumpPower = getgenv().VD.Movement.JumpPower
            end
        end
    end
end)

-- NoClip
RunService.Stepped:Connect(function()
    if getgenv().VD.Movement.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly Mode
RunService.Heartbeat:Connect(function()
    if getgenv().VD.Movement.Fly and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and root then
            hum.PlatformStand = true
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + Camera.CFrame.LookVector * 50
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - Camera.CFrame.LookVector * 50
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - Camera.CFrame.RightVector * 50
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + Camera.CFrame.RightVector * 50
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 50, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDir = moveDir - Vector3.new(0, 50, 0)
            end
            root.Velocity = moveDir
        end
    elseif getgenv().VD.Movement.Fly == false and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end)

-- Teleport
Mouse.Button1Down:Connect(function()
    if getgenv().VD.Movement.Teleport and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(Mouse.Hit.p)
            Library:Notify("Teleported!")
        end
    end
end)

-- ============================================
-- SAVE CONFIG & NOTIFICATION
-- ============================================
SaveManager:LoadAutoloadConfig()

Library:Notify("✅ VIOLENCE DISTRICT - OBSIDIAN UI")
Library:Notify("🔹 Tekan RightShift untuk buka menu")
Library:Notify("🔹 " .. #Players:GetPlayers() .. " players in server")

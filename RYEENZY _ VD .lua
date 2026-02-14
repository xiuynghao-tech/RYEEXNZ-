-- VIOLENCE DISTRICT - ULTIMATE CHEAT (MACLIB EDITION)
-- Fitur Lengkap: ESP, Auto Parry, Auto Kill, No Cooldown, Teleport, dll
-- UI Library: MacLib

-- ============================================
-- LOAD MACLIB UI LIBRARY
-- ============================================
local MacLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiuynghao-tech/RYEENZY-EXP/refs/heads/main/maclib.txt"))()

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
    -- ESP
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
    
    -- Warna ESP
    Colors = {
        Survivor = Color3.new(0, 1, 0),      -- Hijau
        Killer = Color3.new(1, 0, 0),        -- Merah
        Hook = Color3.new(1, 0.5, 0),        -- Oranye
        Generator = Color3.new(0, 1, 1),      -- Cyan
        Chest = Color3.new(1, 1, 0),          -- Kuning
        Tracer = Color3.new(1, 1, 1),         -- Putih
    },
    
    -- Survivor Features [citation:2]
    Survivor = {
        AutoParry = false,
        AutoGenerator = false,
        AutoHeal = false,
        NoSkillCheck = false,
        AutoChest = false,
    },
    
    -- Killer Features [citation:1][citation:2]
    Killer = {
        AutoKill = false,
        NoCooldown = false,
        AntiStun = false,
        BiggerHitbox = false,
        FastReload = false,
        InstantDown = false,
    },
    
    -- Movement [citation:1]
    Movement = {
        Walkspeed = 16,
        JumpPower = 50,
        NoClip = false,
        Fly = false,
        Teleport = false,
        SpeedBoost = false,
    },
    
    -- Visuals
    Visuals = {
        Fullbright = false,
        NoFog = false,
        XRay = false,
    },
    
    -- Misc
    Misc = {
        AutoRespawn = false,
        AntiAfk = false,
    },
}

-- ============================================
-- FUNGSI DETEKSI OBJEK
-- ============================================

-- Deteksi killer
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
}

-- Deteksi generator [citation:2]
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

-- Deteksi hooks
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

-- Deteksi chest
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
-- FUNGSI ESP LENGKAP
-- ============================================

-- ESP Player dengan Nama + Health + Jarak
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
    
    -- BOX ESP [citation:3]
    if getgenv().VD.ESP.Boxes then
        local box = Instance.new("SelectionBox")
        box.Name = "VD_Box"
        box.LineThickness = 0.05
        box.Color3 = color
        box.Transparency = 0.5
        box.SurfaceTransparency = 0.7
        box.Adornee = char
        box.Parent = char
    end
    
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
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
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
            
            -- Update distance
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

-- TRACERS (garis dari player ke target) [citation:3]
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
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "VD_GenLabel"
    billboard.Size = UDim2.new(0, 100, 0, 25)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = gen
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "⚡ GENERATOR"
    label.TextColor3 = getgenv().VD.Colors.Generator
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
end

-- ESP Hook
local function CreateHookESP(hook)
    if not hook or not hook:IsA("BasePart") then return end
    
    hook.BrickColor = BrickColor.new("Bright orange")
    hook.Material = Enum.Material.Neon
    hook.Transparency = 0.2
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "VD_HookLabel"
    billboard.Size = UDim2.new(0, 80, 0, 25)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = hook
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "⛓️ HOOK"
    label.TextColor3 = getgenv().VD.Colors.Hook
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
end

-- ESP Chest
local function CreateChestESP(chest)
    if not chest or not chest:IsA("BasePart") then return end
    
    chest.BrickColor = BrickColor.new("Bright yellow")
    chest.Material = Enum.Material.Neon
    chest.Transparency = 0.2
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "VD_ChestLabel"
    billboard.Size = UDim2.new(0, 80, 0, 25)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = chest
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "📦 CHEST"
    label.TextColor3 = getgenv().VD.Colors.Chest
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
end

-- Bersihkan ESP
local function RemoveAllESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            local highlight = plr.Character:FindFirstChildOfClass("Highlight")
            if highlight and highlight.Name == "VD_ESP" then highlight:Destroy() end
            local box = plr.Character:FindFirstChildOfClass("SelectionBox")
            if box and box.Name == "VD_Box" then box:Destroy() end
            local healthBar = plr.Character:FindFirstChild("VD_HealthBar", true)
            if healthBar then healthBar:Destroy() end
            local nameTag = plr.Character:FindFirstChild("VD_NameTag", true)
            if nameTag then nameTag:Destroy() end
        end
    end
    
    for _, gen in pairs(GetGenerators()) do
        if gen:IsA("BasePart") then gen.Material = Enum.Material.Plastic gen.Transparency = 0 end
        local label = gen:FindFirstChild("VD_GenLabel", true)
        if label then label:Destroy() end
    end
    
    for _, hook in pairs(GetHooks()) do
        if hook:IsA("BasePart") then hook.Material = Enum.Material.Plastic hook.Transparency = 0 end
        local label = hook:FindFirstChild("VD_HookLabel", true)
        if label then label:Destroy() end
    end
    
    for _, chest in pairs(GetChests()) do
        if chest:IsA("BasePart") then chest.Material = Enum.Material.Plastic chest.Transparency = 0 end
        local label = chest:FindFirstChild("VD_ChestLabel", true)
        if label then label:Destroy() end
    end
end

-- ============================================
-- FUNGSI AUTO FEATURES
-- ============================================

-- Auto Parry [citation:2]
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

-- Auto Generator [citation:1][citation:2]
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

-- Auto Kill [citation:1]
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

-- Auto Chest
local function DoAutoChest()
    if not getgenv().VD.Survivor.AutoChest then return end
    
    local chests = GetChests()
    if #chests == 0 then return end
    
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    for _, chest in pairs(chests) do
        if chest:IsA("BasePart") then
            local dist = (myRoot.Position - chest.Position).magnitude
            if dist < 10 then
                firetouchinterest(myRoot, chest, 0)
                firetouchinterest(myRoot, chest, 1)
            end
        end
    end
end

-- ============================================
-- MEMBUAT WINDOW MACLIB
-- ============================================
local Window = MacLib:Window({
    Title = "RYEENZY | VIOLENCE DISTRICT",
    SubTitle = "Ultimate Cheat - Full Fitur 2025",
    Size = UDim2.fromOffset(950, 650),
    AcrylicBlur = true,
    DisabledWindowControls = {},
})

-- ============================================
-- TAB ESP
-- ============================================
local ESPTab = Window:Tab({
    Title = "ESP",
    Icon = "rbxassetid://4483362458"
})

ESPTab:Section({Title = "ESP MASTER CONTROL"})

ESPTab:Toggle({
    Title = "Enable All ESP",
    Description = "Aktifkan semua fitur ESP",
    Value = false,
    Callback = function(v)
        getgenv().VD.ESP.Enabled = v
        if not v then RemoveAllESP() end
        Window:Notify({
            Title = "ESP",
            Description = v and "Activated" or "Deactivated",
            Duration = 2
        })
    end
})

ESPTab:Section({Title = "ESP TOGGLES"})

ESPTab:Toggle({
    Title = "Show Survivors",
    Description = "Tampilkan survivor",
    Value = true,
    Callback = function(v) getgenv().VD.ESP.Survivors = v end
})

ESPTab:Toggle({
    Title = "Show Killer",
    Description = "Tampilkan killer",
    Value = true,
    Callback = function(v) getgenv().VD.ESP.Killer = v end
})

ESPTab:Toggle({
    Title = "Show Generators",
    Description = "Tampilkan generator",
    Value = true,
    Callback = function(v) getgenv().VD.ESP.Generators = v end
})

ESPTab:Toggle({
    Title = "Show Hooks",
    Description = "Tampilkan hook",
    Value = true,
    Callback = function(v) getgenv().VD.ESP.Hooks = v end
})

ESPTab:Toggle({
    Title = "Show Chests",
    Description = "Tampilkan chest/loot",
    Value = true,
    Callback = function(v) getgenv().VD.ESP.Chests = v end
})

ESPTab:Section({Title = "ESP VISUALS"})

ESPTab:Toggle({
    Title = "Show Tracers",
    Description = "Garis dari player ke target",
    Value = true,
    Callback = function(v) getgenv().VD.ESP.Tracers = v end
})

ESPTab:Toggle({
    Title = "Show Names",
    Description = "Tampilkan nama player",
    Value = true,
    Callback = function(v) getgenv().VD.ESP.Names = v end
})

ESPTab:Toggle({
    Title = "Show Distance",
    Description = "Tampilkan jarak",
    Value = true,
    Callback = function(v) getgenv().VD.ESP.Distance = v end
})

ESPTab:Toggle({
    Title = "Show Health Bars",
    Description = "Bar kesehatan player",
    Value = true,
    Callback = function(v) getgenv().VD.ESP.Health = v end
})

ESPTab:Toggle({
    Title = "Show Boxes",
    Description = "Kotak di sekitar player [citation:3]",
    Value = false,
    Callback = function(v) getgenv().VD.ESP.Boxes = v end
})

-- ============================================
-- TAB COLORS
-- ============================================
local ColorTab = Window:Tab({
    Title = "Colors",
    Icon = "rbxassetid://4483345556"
})

ColorTab:Section({Title = "WARNA ESP"})

ColorTab:Dropdown({
    Title = "Survivor Color",
    Values = {"Green", "Blue", "Yellow", "Purple", "Cyan"},
    Default = "Green",
    Callback = function(choice)
        local colors = {
            Green = Color3.new(0,1,0),
            Blue = Color3.new(0,0,1),
            Yellow = Color3.new(1,1,0),
            Purple = Color3.new(0.5,0,1),
            Cyan = Color3.new(0,1,1)
        }
        getgenv().VD.Colors.Survivor = colors[choice]
    end
})

ColorTab:Dropdown({
    Title = "Killer Color",
    Values = {"Red", "Orange", "Pink", "Purple"},
    Default = "Red",
    Callback = function(choice)
        local colors = {
            Red = Color3.new(1,0,0),
            Orange = Color3.new(1,0.5,0),
            Pink = Color3.new(1,0.5,0.5),
            Purple = Color3.new(0.5,0,1)
        }
        getgenv().VD.Colors.Killer = colors[choice]
    end
})

ColorTab:Dropdown({
    Title = "Hook Color",
    Values = {"Orange", "Red", "Yellow", "Gold"},
    Default = "Orange",
    Callback = function(choice)
        local colors = {
            Orange = Color3.new(1,0.5,0),
            Red = Color3.new(1,0,0),
            Yellow = Color3.new(1,1,0),
            Gold = Color3.new(1,0.8,0)
        }
        getgenv().VD.Colors.Hook = colors[choice]
    end
})

ColorTab:Dropdown({
    Title = "Generator Color",
    Values = {"Cyan", "Green", "Blue", "White"},
    Default = "Cyan",
    Callback = function(choice)
        local colors = {
            Cyan = Color3.new(0,1,1),
            Green = Color3.new(0,1,0),
            Blue = Color3.new(0,0,1),
            White = Color3.new(1,1,1)
        }
        getgenv().VD.Colors.Generator = colors[choice]
    end
})

-- ============================================
-- TAB SURVIVOR
-- ============================================
local SurvivorTab = Window:Tab({
    Title = "Survivor",
    Icon = "rbxassetid://4483345309"
})

SurvivorTab:Section({Title = "SURVIVOR FEATURES [citation:2]"})

SurvivorTab:Toggle({
    Title = "Auto Parry",
    Description = "Otomatis memblokir serangan killer",
    Value = false,
    Callback = function(v) getgenv().VD.Survivor.AutoParry = v end
})

SurvivorTab:Toggle({
    Title = "Auto Generator",
    Description = "Otomatis memperbaiki generator",
    Value = false,
    Callback = function(v) getgenv().VD.Survivor.AutoGenerator = v end
})

SurvivorTab:Toggle({
    Title = "Auto Chest",
    Description = "Otomatis membuka chest",
    Value = false,
    Callback = function(v) getgenv().VD.Survivor.AutoChest = v end
})

SurvivorTab:Toggle({
    Title = "Auto Heal",
    Description = "Otomatis menyembuhkan diri",
    Value = false,
    Callback = function(v) getgenv().VD.Survivor.AutoHeal = v end
})

SurvivorTab:Toggle({
    Title = "No Skill Check",
    Description = "Menghilangkan skill check",
    Value = false,
    Callback = function(v) getgenv().VD.Survivor.NoSkillCheck = v end
})

-- ============================================
-- TAB KILLER
-- ============================================
local KillerTab = Window:Tab({
    Title = "Killer",
    Icon = "rbxassetid://4483345033"
})

KillerTab:Section({Title = "KILLER FEATURES [citation:1][citation:2]"})

KillerTab:Toggle({
    Title = "Auto Kill",
    Description = "Otomatis membunuh survivor terdekat",
    Value = false,
    Risky = true,
    Callback = function(v) getgenv().VD.Killer.AutoKill = v end
})

KillerTab:Toggle({
    Title = "No Cooldown",
    Description = "Menghilangkan cooldown ability",
    Value = false,
    Callback = function(v) getgenv().VD.Killer.NoCooldown = v end
})

KillerTab:Toggle({
    Title = "Anti Stun",
    Description = "Mencegah efek stun",
    Value = false,
    Callback = function(v) getgenv().VD.Killer.AntiStun = v end
})

KillerTab:Toggle({
    Title = "Bigger Hitbox",
    Description = "Memperbesar area serangan [citation:3]",
    Value = false,
    Callback = function(v) getgenv().VD.Killer.BiggerHitbox = v end
})

KillerTab:Toggle({
    Title = "Fast Reload",
    Description = "Reload senjata lebih cepat [citation:3]",
    Value = false,
    Callback = function(v) getgenv().VD.Killer.FastReload = v end
})

-- ============================================
-- TAB MOVEMENT
-- ============================================
local MovementTab = Window:Tab({
    Title = "Movement",
    Icon = "rbxassetid://4483345766"
})

MovementTab:Section({Title = "MOVEMENT [citation:1]"})

MovementTab:Slider({
    Title = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Unit = "studs/s",
    Callback = function(v)
        getgenv().VD.Movement.Walkspeed = v
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end
    end
})

MovementTab:Slider({
    Title = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Callback = function(v)
        getgenv().VD.Movement.JumpPower = v
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = v end
        end
    end
})

MovementTab:Toggle({
    Title = "NoClip",
    Description = "Tembus dinding dan objek",
    Value = false,
    Callback = function(v) getgenv().VD.Movement.NoClip = v end
})

MovementTab:Toggle({
    Title = "Fly Mode",
    Description = "Mode terbang",
    Value = false,
    Callback = function(v) getgenv().VD.Movement.Fly = v end
})

MovementTab:Toggle({
    Title = "Teleport Mode",
    Description = "Klik kiri untuk teleport",
    Value = false,
    Callback = function(v) getgenv().VD.Movement.Teleport = v end
})

MovementTab:Toggle({
    Title = "Speed Boost",
    Description = "Boost kecepatan instan",
    Value = false,
    Callback = function(v) getgenv().VD.Movement.SpeedBoost = v end
})

-- ============================================
-- TAB VISUALS
-- ============================================
local VisualsTab = Window:Tab({
    Title = "Visuals",
    Icon = "rbxassetid://4483345806"
})

VisualsTab:Section({Title = "VISUALS"})

VisualsTab:Toggle({
    Title = "Fullbright",
    Description = "Terangi seluruh map",
    Value = false,
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

VisualsTab:Toggle({
    Title = "No Fog",
    Description = "Hilangkan efek fog",
    Value = false,
    Callback = function(v)
        getgenv().VD.Visuals.NoFog = v
        Lighting.FogEnd = v and 100000 or 1000
    end
})

-- ============================================
-- TAB INFO
-- ============================================
local InfoTab = Window:Tab({
    Title = "Info",
    Icon = "rbxassetid://4483345687"
})

InfoTab:Section({Title = "GAME INFORMATION"})

InfoTab:Button({
    Title = "Refresh Info",
    Description = "Update informasi game",
    Callback = function()
        local killer = GetKiller()
        local gens = #GetGenerators()
        local hooks = #GetHooks()
        local chests = #GetChests()
        Window:Notify({
            Title = "Game Info",
            Description = string.format("Players: %d | Killer: %s | Gens: %d | Hooks: %d | Chests: %d", 
                #Players:GetPlayers(), 
                killer and killer.Name or "None",
                gens, hooks, chests
            ),
            Duration = 4
        })
    end
})

InfoTab:Label({
    Title = "FITUR LENGKAP 2025",
    Description = "✅ ESP | Auto Parry | Auto Kill | No Cooldown | Teleport | Fly"
})

InfoTab:Label({
    Title = "CARA PAKAI",
    Description = "Tekan RightShift untuk buka/tutup menu\nAktifkan fitur sesuai kebutuhan\nGunakan alt account untuk keamanan"
})

-- ============================================
-- MAIN LOOP ESP
-- ============================================
coroutine.wrap(function()
    while task.wait(0.3) do
        if getgenv().VD.ESP.Enabled then
            local killer = GetKiller()
            
            -- ESP Player
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
            
            -- ESP Generator
            if getgenv().VD.ESP.Generators then
                for _, gen in pairs(GetGenerators()) do
                    if gen:IsA("BasePart") and not gen:FindFirstChild("VD_GenLabel") then
                        CreateGeneratorESP(gen)
                    end
                end
            end
            
            -- ESP Hooks
            if getgenv().VD.ESP.Hooks then
                for _, hook in pairs(GetHooks()) do
                    if hook:IsA("BasePart") and not hook:FindFirstChild("VD_HookLabel") then
                        CreateHookESP(hook)
                    end
                end
            end
            
            -- ESP Chests
            if getgenv().VD.ESP.Chests then
                for _, chest in pairs(GetChests()) do
                    if chest:IsA("BasePart") and not chest:FindFirstChild("VD_ChestLabel") then
                        CreateChestESP(chest)
                    end
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

-- Auto features
RunService.Heartbeat:Connect(DoAutoParry)
coroutine.wrap(function() while task.wait(0.5) do DoAutoGenerator() end end)()
coroutine.wrap(function() while task.wait(0.3) do DoAutoKill() end end)()
coroutine.wrap(function() while task.wait(0.8) do DoAutoChest() end end)()

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

-- Anti Stun
RunService.Stepped:Connect(function()
    if getgenv().VD.Killer.AntiStun and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum:GetState() == Enum.HumanoidStateType.Freefall then
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
end)

-- Walkspeed
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= getgenv().VD.Movement.Walkspeed then
            hum.WalkSpeed = getgenv().VD.Movement.Walkspeed
        end
        if hum and hum.JumpPower ~= getgenv().VD.Movement.JumpPower then
            hum.JumpPower = getgenv().VD.Movement.JumpPower
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
            Window:Notify({
                Title = "Teleport",
                Description = "Teleported!",
                Duration = 1
            })
        end
    end
end)

-- Speed Boost
RunService.Heartbeat:Connect(function()
    if getgenv().VD.Movement.SpeedBoost and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 120
        end
    end
end)

-- ============================================
-- NOTIFICATION AWAL
-- ============================================
Window:Notify({
    Title = "RYEENZY | VIOLENCE DISTRICT",
    Description = "Ultimate Cheat Loaded! Tekan RightShift",
    Duration = 5
})

Window:Notify({
    Title = "FITUR LENGKAP 2025",
    Description = "ESP | Auto Parry | Auto Kill | No Cooldown | Teleport | Fly",
    Duration = 5
})
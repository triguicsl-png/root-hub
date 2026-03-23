-- Root Hub: Complete Combined Edition
-- 99 Nights + Brainrots + Violence District + Hook Simulator
-- by Slikke2 • fully merged & fixed

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local PlaceId = game.PlaceId

local is99Nights        = (PlaceId == 79546208627805)
local isBrainrots       = (PlaceId == 119987266683883)
local isViolenceDistrict = (PlaceId == 93978595733734)
local isHookSim         = (PlaceId == 70390793715007)

if not (is99Nights or isBrainrots or isViolenceDistrict or isHookSim) then
    warn("Root Hub: Unsupported game. Some features disabled.")
end

local Window = Rayfield:CreateWindow({
    Name = is99Nights        and "🌲 99 Nights in the Forest"
        or isBrainrots       and "🦖 Survive LAVA for Brainrots!"
        or isViolenceDistrict and "🔪 Violence District"
        or isHookSim         and "🎣 Hook Simulator"
        or "🌿 Root Hub",
    LoadingTitle = "Root Hub",
    LoadingSubtitle = "by Slikke2",
    Theme = "Default",
    ToggleUIKeybind = "K",
    KeySystem = isBrainrots,
    KeySettings = isBrainrots and {
        Title = "Easy Key",
        Subtitle = "Key System",
        Note = "Key is: Root",
        SaveKey = true,
        Key = {"Root"}
    } or nil
})

-------------------------------------------------------------------
-- SHARED GLOBALS
-------------------------------------------------------------------
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local UserInput   = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local InfJumpEnabled = false

UserInput.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-------------------------------------------------------------------
-- HOOK SIMULATOR
-------------------------------------------------------------------
if isHookSim then

    _G.AutoHook = false

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TEvent = require(ReplicatedStorage.Shared.Core.TEvent)  -- adjust path if needed

    local function GetClosestTargets()
        local Targets = {}
        for _, Player in pairs(Players:GetPlayers()) do
            if Player == LocalPlayer or (Player.Team == LocalPlayer.Team) or (Player.Team and Player.Team.Name == "Lobby") then
                continue
            end
            local Char = Player.Character
            if Char and not Char:FindFirstChildWhichIsA("ForceField") then
                local Hum = Char:FindFirstChildOfClass("Humanoid")
                local Head = Char:FindFirstChild("Head")
                if Head and Hum and Hum.Health > 0 then
                    table.insert(Targets, {Head = Head, IsBot = false})
                end
            end
        end

        for _, Bot in pairs(workspace:GetChildren()) do
            if Bot:GetAttribute("IsBot") and not Bot:FindFirstChildWhichIsA("ForceField") then
                local Hum = Bot:FindFirstChildOfClass("Humanoid")
                local Head = Bot:FindFirstChild("Head")
                if Head and Hum and Hum.Health > 0 then
                    table.insert(Targets, {Head = Head, IsBot = true})
                end
            end
        end

        return Targets
    end

    local HookTab = Window:CreateTab("🎣 Combat")

    HookTab:CreateSection("Hook Exploit")

    HookTab:CreateToggle({
        Name = "Auto Hook Kill (All Targets)",
        CurrentValue = false,
        Flag = "AutoHook",
        Callback = function(Value)
            _G.AutoHook = Value
            if Value then
                Rayfield:Notify({
                    Title = "WARNING",
                    Content = "Auto Hook active.\nNo kills/coins in Lobby!\nUse only in matches.",
                    Duration = 7
                })
            end
        end,
    })

    HookTab:CreateParagraph({
        Title = "Notice",
        Content = "Fires remotes directly — bypasses checks.\nRisk of detection."
    })

    task.spawn(function()
        while true do
            task.wait()
            if not _G.AutoHook then continue end

            pcall(function()
                local Targets = GetClosestTargets()
                if #Targets == 0 then return end

                for _, Target in pairs(Targets) do
                    local TargetPlayer = Target.IsBot and Target.Head.Parent or Players:GetPlayerFromCharacter(Target.Head.Parent)

                    TEvent.FireRemote("HookFire", {
                        hookId = 67,
                        startPosition = nil,
                        direction = (Target.Head.Position - LocalPlayer.Character.Head.Position).Unit,
                        distance = 9e9,
                        hookFlyTime = 0,
                        hookBackSpeed = 9e9,
                        fireTime = 0
                    })

                    TEvent.FireRemote("HookHit", {
                        hookId = 67,
                        targetPlayer = TargetPlayer,
                        targetPartName = Target.Head.Name,
                        hookBackSpeed = 9e9
                    })

                    TEvent.FireRemote("HookRelease", {
                        hookId = 67,
                        targetPlayer = TargetPlayer,
                        reason = "Root Hubbed"
                    })
                end
            end)
        end
    end)

end

-------------------------------------------------------------------
-- 99 NIGHTS IN THE FOREST
-------------------------------------------------------------------
if is99Nights then

    local NoClip        = false
    local KillAura      = false
    local AutoFarmLogs  = false
    local AutoElf       = false
    local SelectedItem  = "Coal"
    local SelectedDest  = "My Character"

    local MainTab = Window:CreateTab("🏃 Movement")
    MainTab:CreateSection("Speed & Jump")

    MainTab:CreateSlider({
        Name = "Walk Speed",
        Range = {16, 500},
        Increment = 5,
        Suffix = " studs/s",
        CurrentValue = 16,
        Callback = function(v)
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end,
    })

    MainTab:CreateSlider({
        Name = "Jump Power",
        Range = {50, 700},
        Increment = 10,
        Suffix = " power",
        CurrentValue = 50,
        Callback = function(v)
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = v
            end
        end,
    })

    MainTab:CreateToggle({
        Name = "Infinite Jump",
        CurrentValue = false,
        Callback = function(v) InfJumpEnabled = v end,
    })

    MainTab:CreateToggle({
        Name = "Noclip",
        CurrentValue = false,
        Callback = function(v) NoClip = v end,
    })

    RunService.Stepped:Connect(function()
        if NoClip and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    local CombatTab = Window:CreateTab("⚔️ Combat")
    CombatTab:CreateToggle({
        Name = "Kill Aura",
        CurrentValue = false,
        Callback = function(v) KillAura = v end,
    })

    task.spawn(function()
        while true do
            task.wait(0.3)
            if not KillAura then continue end

            local chars = workspace:FindFirstChild("Characters")
            if chars then
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, npc in ipairs(chars:GetChildren()) do
                        local hum = npc:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            local dist = (root.Position - npc:GetPivot().Position).Magnitude
                            if dist < 35 then hum.Health = 0 end
                        end
                    end
                end
            end
        end
    end)

    local ItemsTab = Window:CreateTab("📦 Items")
    ItemsTab:CreateDropdown({
        Name = "Select Item",
        Options = {"Coal", "Log", "Oil Barrel", "Sheet Metal", "Broken Fan", "Fuel Canister", "Bolt", "Broken Microwave", "Tyre", "Old Radio", "Chair"},
        CurrentOption = "Coal",
        Callback = function(v) SelectedItem = v end,
    })

    ItemsTab:CreateDropdown({
        Name = "Destination",
        Options = {"My Character", "CraftingBench", "MainFire"},
        CurrentOption = "My Character",
        Callback = function(v) SelectedDest = v end,
    })

    ItemsTab:CreateButton({
        Name = "Bring All Selected Items",
        Callback = function()
            local targetCF = SelectedDest == "My Character" and LocalPlayer.Character:GetPivot() or workspace:FindFirstChild(SelectedDest, true):GetPivot()
            if targetCF then
                local items = workspace:FindFirstChild("Items")
                if items then
                    for _, item in ipairs(items:GetChildren()) do
                        if item.Name == SelectedItem then
                            item:PivotTo(targetCF * CFrame.new(0, 4, 0))
                        end
                    end
                end
            end
        end,
    })

    local AutoTab = Window:CreateTab("⚙️ Auto")
    AutoTab:CreateToggle({
        Name = "Auto Farm Logs",
        CurrentValue = false,
        Callback = function(v) AutoFarmLogs = v end,
    })

    AutoTab:CreateToggle({
        Name = "Auto Rescue Elves",
        CurrentValue = false,
        Callback = function(v) AutoElf = v end,
    })

    task.spawn(function()
        while true do
            task.wait(0.4)
            if AutoElf then
                local christmas = workspace:FindFirstChild("Christmas")
                if christmas then
                    for _, p in ipairs(christmas:GetDescendants()) do
                        if p:IsA("ProximityPrompt") then fireproximityprompt(p) end
                    end
                end
            end
            if AutoFarmLogs then
                local items = workspace:FindFirstChild("Items")
                if items then
                    for _, log in ipairs(items:GetChildren()) do
                        if log.Name == "Log" then
                            LocalPlayer.Character:PivotTo(log:GetPivot())
                            task.wait(0.6)
                        end
                    end
                end
            end
        end
    end)

end

-------------------------------------------------------------------
-- SURVIVE LAVA FOR BRAINROTS
-------------------------------------------------------------------
if isBrainrots then

    local InstaInteract = false
    local AutoCollectEnabled = false

    local MainTab = Window:CreateTab("🏠 Main")

    MainTab:CreateSection("Movement")

    MainTab:CreateToggle({
        Name = "Infinite Jump",
        CurrentValue = false,
        Callback = function(v) InfJumpEnabled = v end,
    })

    MainTab:CreateSlider({
        Name = "Walk Speed",
        Range = {16, 350},
        Increment = 2,
        Suffix = " studs/s",
        CurrentValue = 16,
        Callback = function(v)
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end,
    })

    MainTab:CreateSection("Utilities")

    MainTab:CreateToggle({
        Name = "Insta Interact",
        CurrentValue = false,
        Callback = function(v)
            InstaInteract = v
            if v then
                for _, obj in workspace:GetDescendants() do
                    if obj:IsA("ProximityPrompt") then obj.HoldDuration = 0 end
                end
            end
        end,
    })

    MainTab:CreateButton({
        Name = "VIP Bypass (Delete VIP Doors)",
        Callback = function()
            local gf = workspace:FindFirstChild("GameFolder")
            local vip = gf and gf:FindFirstChild("VIPDoors")
            if vip then vip:Destroy() Rayfield:Notify({Title="Success", Content="VIP Doors removed"}) end
        end,
    })

    MainTab:CreateButton({
        Name = "Delete Lavas & Heights",
        Callback = function()
            local gf = workspace:FindFirstChild("GameFolder")
            if gf then
                pcall(function() gf.Lavas:Destroy() end)
                pcall(function() gf.Heights:Destroy() end)
                Rayfield:Notify({Title="Success", Content="Lava removed"})
            end
        end,
    })

    local TpTab = Window:CreateTab("🚀 Teleports")

    TpTab:CreateButton({
        Name = "Teleport to My Plot",
        Callback = function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local gf = workspace:FindFirstChild("GameFolder")
            local plots = gf and gf:FindFirstChild("Plots")
            if plots then
                for _, plot in ipairs(plots:GetChildren()) do
                    if plot:IsA("Model") then
                        local base = plot.PrimaryPart or plot:FindFirstChild("BasePrimary") or plot:FindFirstChildWhichIsA("BasePart")
                        if base then
                            hrp.CFrame = base.CFrame + Vector3.new(0, 6, 0)
                            return Rayfield:Notify({Title="Success", Content="To plot"})
                        end
                    end
                end
            end
        end,
    })

    TpTab:CreateButton({
        Name = "Teleport to Safe Zone",
        Callback = function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(0, 100, 0) + Vector3.new(0, 5, 0) end
        end,
    })

    TpTab:CreateButton({
        Name = "Teleport to Best Brainrot",
        Callback = function()
            local order = {"Godly", "Celestial", "Secret", "Mythic", "Legendary", "Epic", "Rare", "Common"}
            local gf = workspace:FindFirstChild("GameFolder")
            local brainrots = gf and gf:FindFirstChild("Brainrots")
            if not brainrots then return end

            for _, rarity in ipairs(order) do
                local f = brainrots:FindFirstChild(rarity)
                if f and #f:GetChildren() > 0 then
                    local t = f:GetChildren()[1]
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = t:GetPivot() + Vector3.new(0, 6, 0)
                        return Rayfield:Notify({Title="Success", Content="To " .. rarity})
                    end
                end
            end
        end,
    })

    local CollectTab = Window:CreateTab("💎 Collect")

    CollectTab:CreateToggle({
        Name = "Auto Collect Godly & Celestial",
        CurrentValue = false,
        Callback = function(v) AutoCollectEnabled = v end,
    })

    workspace.DescendantAdded:Connect(function(obj)
        if InstaInteract and obj:IsA("ProximityPrompt") then obj.HoldDuration = 0 end

        if AutoCollectEnabled and obj:IsA("Model") and obj.Parent then
            local pname = obj.Parent.Name
            if pname == "Godly" or pname == "Celestial" then
                task.spawn(function()
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    local old = hrp.CFrame
                    hrp.CFrame = obj:GetPivot() + Vector3.new(0, 5, 0)
                    task.wait(0.3)
                    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then fireproximityprompt(prompt) end
                    task.wait(0.5)
                    hrp.CFrame = old
                end)
            end
        end
    end)

end

-------------------------------------------------------------------
-- VIOLENCE DISTRICT
-------------------------------------------------------------------
if isViolenceDistrict then

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local localPlayer = Players.LocalPlayer

    local VDConfig = {
        ESPEnabled    = true,
        NoclipEnabled = false,
        SpeedEnabled  = false,
        CustomSpeed   = 50,
        Players = {
            ["Killer"]   = {Color = Color3.fromRGB(255, 93, 108)},
            ["Survivor"] = {Color = Color3.fromRGB(64, 224, 255)}
        },
        Objects = {
            {Name = "Generator",   Color = Color3.fromRGB(210, 87, 255)},
            {Name = "Gate",        Color = Color3.fromRGB(255, 255, 255)},
            {Name = "Pallet",      Color = Color3.fromRGB(74, 255, 181)},
            {Name = "Window",      Color = Color3.fromRGB(74, 255, 181)},
            {Name = "Hook",        Color = Color3.fromRGB(132, 255, 169)}
        }
    }

    local function ApplyVDHighlight(obj, color)
        if not obj or obj == localPlayer.Character or obj:FindFirstChild("RootESP") then return end
        local h = Instance.new("Highlight")
        h.Name = "RootESP"
        h.Adornee = obj
        h.FillColor = color
        h.OutlineColor = Color3.new(1, 1, 1)
        h.FillTransparency = 0.7
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Enabled = VDConfig.ESPEnabled
        h.Parent = obj
    end

    local function GetVDRole(p)
        return (p.Team and p.Team.Name:lower():find("killer")) and "Killer" or "Survivor"
    end

    -- Movement Tab
    local VDMain = Window:CreateTab("🏃 Movement")
    VDMain:CreateSection("Speed & Physics")

    VDMain:CreateToggle({
        Name = "Speed Boost (B to toggle)",
        CurrentValue = false,
        Callback = function(v)
            VDConfig.SpeedEnabled = v
            if not v then
                pcall(function() localPlayer.Character.Humanoid.WalkSpeed = 16 end)
            end
            Rayfield:Notify({Title = "Speed", Content = v and "Speed ON." or "Speed OFF."})
        end,
    })

    VDMain:CreateSlider({
        Name = "Custom Speed",
        Range = {16, 300},
        Increment = 5,
        Suffix = " studs/s",
        CurrentValue = 50,
        Callback = function(v)
            VDConfig.CustomSpeed = v
        end,
    })

    VDMain:CreateToggle({
        Name = "Noclip (N to toggle)",
        CurrentValue = false,
        Callback = function(v)
            VDConfig.NoclipEnabled = v
            if not v then
                pcall(function()
                    for _, part in pairs(localPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end)
            end
            Rayfield:Notify({Title = "Noclip", Content = v and "Noclip ON." or "Noclip OFF."})
        end,
    })

    -- ESP Tab
    local VDEsp = Window:CreateTab("👁️ ESP")
    VDEsp:CreateSection("Player & Object ESP")

    VDEsp:CreateToggle({
        Name = "ESP Enabled (V to toggle)",
        CurrentValue = true,
        Callback = function(v)
            VDConfig.ESPEnabled = v
            for _, obj in ipairs(workspace:GetDescendants()) do
                local h = obj:FindFirstChild("RootESP")
                if h then h.Enabled = VDConfig.ESPEnabled end
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character then
                    local h = p.Character:FindFirstChild("RootESP")
                    if h then h.Enabled = VDConfig.ESPEnabled end
                end
            end
            Rayfield:Notify({Title = "ESP", Content = v and "ESP Enabled." or "ESP Disabled."})
        end,
    })

    VDEsp:CreateButton({
        Name = "Refresh ESP",
        Callback = function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                local h = obj:FindFirstChild("RootESP")
                if h then h:Destroy() end
            end
            for _, obj in ipairs(workspace:GetDescendants()) do
                for _, data in ipairs(VDConfig.Objects) do
                    if obj.Name == data.Name then ApplyVDHighlight(obj, data.Color) end
                end
            end
            Rayfield:Notify({Title = "ESP", Content = "ESP refreshed."})
        end,
    })

    -- Keybinds (V / N / B)
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.V then
            VDConfig.ESPEnabled = not VDConfig.ESPEnabled
            for _, obj in ipairs(workspace:GetDescendants()) do
                local h = obj:FindFirstChild("RootESP")
                if h then h.Enabled = VDConfig.ESPEnabled end
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character then
                    local h = p.Character:FindFirstChild("RootESP")
                    if h then h.Enabled = VDConfig.ESPEnabled end
                end
            end
            Rayfield:Notify({Title = "ESP", Content = VDConfig.ESPEnabled and "ESP On (V)" or "ESP Off (V)"})
        elseif input.KeyCode == Enum.KeyCode.N then
            VDConfig.NoclipEnabled = not VDConfig.NoclipEnabled
            if not VDConfig.NoclipEnabled then
                pcall(function()
                    for _, part in pairs(localPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end)
            end
            Rayfield:Notify({Title = "Noclip", Content = VDConfig.NoclipEnabled and "Noclip ON (N)" or "Noclip OFF (N)"})
        elseif input.KeyCode == Enum.KeyCode.B then
            VDConfig.SpeedEnabled = not VDConfig.SpeedEnabled
            if not VDConfig.SpeedEnabled then
                pcall(function() localPlayer.Character.Humanoid.WalkSpeed = 16 end)
            end
            Rayfield:Notify({Title = "Speed", Content = VDConfig.SpeedEnabled and "Speed ON (B)" or "Speed OFF (B)"})
        end
    end)

    -- Movement loop
    RunService.Stepped:Connect(function()
        local char = localPlayer.Character
        if not char then return end
        if VDConfig.NoclipEnabled then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and VDConfig.SpeedEnabled then
            hum.WalkSpeed = VDConfig.CustomSpeed
        end
    end)

    -- Object ESP loop
    task.spawn(function()
        while true do
            for _, obj in ipairs(workspace:GetDescendants()) do
                for _, data in ipairs(VDConfig.Objects) do
                    if obj.Name == data.Name then ApplyVDHighlight(obj, data.Color) end
                end
            end
            task.wait(5)
        end
    end)

    -- Player ESP setup
    local function SetupVDPlayer(p)
        if p == localPlayer then return end
        p.CharacterAdded:Connect(function(char)
            task.wait(1)
            ApplyVDHighlight(char, VDConfig.Players[GetVDRole(p)].Color)
        end)
        if p.Character then
            ApplyVDHighlight(p.Character, VDConfig.Players[GetVDRole(p)].Color)
        end
    end

    Players.PlayerAdded:Connect(SetupVDPlayer)
    for _, p in ipairs(Players:GetPlayers()) do SetupVDPlayer(p) end

    Rayfield:Notify({Title = "🔪 Root Hub | Violence District", Content = "V: ESP | N: Noclip | B: Speed", Duration = 5})

end

-------------------------------------------------------------------
-- SHARED MISC
-------------------------------------------------------------------
local Misc = Window:CreateTab("🛠 Misc")

Misc:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end,
})

Misc:CreateLabel("Root Hub Combined • Use alt account")
Misc:CreateLabel("Risk of ban always exists")

-- Root Hub: Combined Edition
-- 99 Nights in the Forest + Survive LAVA for Brainrots + Survival Mini
-- by Slikke2

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local PlaceId = game.PlaceId
local is99Nights     = (PlaceId == 79546208627805)
local isBrainrots    = (PlaceId == 119987266683883)
local isSurvivalMini = (PlaceId == 93978595733734) -- ← Replace with Survival Mini PlaceId

if not is99Nights and not isBrainrots and not isSurvivalMini then
    warn("Root Hub: Unrecognized game. Some features may not work.")
end

local Window = Rayfield:CreateWindow({
    Name = is99Nights and "🌲 Root Hub | 99 Nights in the Forest"
        or isBrainrots and "🦖 Root Hub | Survive LAVA for Brainrots!"
        or isSurvivalMini and "🪓 Root Hub | Survival Mini"
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
-- SHARED VARIABLES
-------------------------------------------------------------------
local InfJumpEnabled = false
local jumpConnection = nil

-------------------------------------------------------------------
-- ========== 99 NIGHTS ONLY ==========
-------------------------------------------------------------------
if is99Nights then

    local NoClip = false
    local KillAuraEnabled = false
    local AutoFarmLogs = false
    local AutoElf = false
    local SelectedItem = "Coal"
    local SelectedDest = "My Character"

    -- 🏃 MOVEMENT
    local Main = Window:CreateTab("🏃 Movement", 4483362458)
    Main:CreateSection("Speed & Jump")

    Main:CreateSlider({
        Name = "Walk Speed",
        Range = {16, 500},
        Increment = 5,
        Suffix = " studs/s",
        CurrentValue = 16,
        Callback = function(v)
            pcall(function()
                local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = v end
            end)
        end,
    })

    Main:CreateSlider({
        Name = "Jump Power",
        Range = {50, 700},
        Increment = 10,
        Suffix = " power",
        CurrentValue = 50,
        Callback = function(v)
            pcall(function()
                local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.UseJumpPower = true
                    hum.JumpPower = v
                end
            end)
        end,
    })

    Main:CreateToggle({
        Name = "Infinite Jump",
        CurrentValue = false,
        Callback = function(v)
            InfJumpEnabled = v
            if v then
                jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                    local char = game.Players.LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                end)
            else
                if jumpConnection then jumpConnection:Disconnect() jumpConnection = nil end
            end
        end,
    })

    Main:CreateToggle({
        Name = "Noclip",
        CurrentValue = false,
        Callback = function(v)
            NoClip = v
            if not v then
                pcall(function()
                    for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end)
            end
        end,
    })

    -- ⚔️ COMBAT
    local Combat = Window:CreateTab("⚔️ Combat", 4483362458)
    Combat:CreateSection("Kill Aura")

    Combat:CreateToggle({
        Name = "Kill Aura (Deer/Monsters/NPCs)",
        CurrentValue = false,
        Callback = function(v) KillAuraEnabled = v end,
    })

    -- 📦 ITEMS & DELIVERY
    local Items = Window:CreateTab("📦 Items", 4483362458)
    Items:CreateSection("Item Delivery")

    Items:CreateDropdown({
        Name = "Target Item",
        Options = {"Coal", "Log", "Oil Barrel", "Sheet Metal", "Broken Fan", "Fuel Canister", "Bolt", "Broken Microwave", "Tyre", "Old Radio", "Chair"},
        CurrentOption = {"Coal"},
        Callback = function(v) SelectedItem = (type(v) == "table" and v[1] or v) end,
    })

    Items:CreateDropdown({
        Name = "Destination",
        Options = {"My Character", "CraftingBench", "MainFire"},
        CurrentOption = {"My Character"},
        Callback = function(v) SelectedDest = (type(v) == "table" and v[1] or v) end,
    })

    Items:CreateButton({
        Name = "Bring ALL to Destination",
        Callback = function()
            local targetCF = nil
            if SelectedDest == "My Character" then
                targetCF = game.Players.LocalPlayer.Character:GetPivot()
            else
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name == SelectedDest then targetCF = v:GetPivot() break end
                end
            end
            if targetCF then
                local wItems = workspace:FindFirstChild("Items")
                if wItems then
                    for _, item in pairs(wItems:GetChildren()) do
                        if item.Name == SelectedItem then
                            item:PivotTo(targetCF * CFrame.new(0, 4, 0))
                        end
                    end
                end
            end
        end,
    })

    -- ⚙️ AUTOMATION
    local Auto = Window:CreateTab("⚙️ Auto", 4483362458)
    Auto:CreateSection("Farming")

    Auto:CreateToggle({
        Name = "Auto Farm Logs (TP Farm)",
        CurrentValue = false,
        Callback = function(v) AutoFarmLogs = v end,
    })

    Auto:CreateToggle({
        Name = "Auto Rescue Elves",
        CurrentValue = false,
        Callback = function(v) AutoElf = v end,
    })

    -- 🌎 WORLD & ESP
    local World = Window:CreateTab("🌎 World", 4483362458)
    World:CreateSection("Visuals")

    World:CreateButton({
        Name = "Full Bright",
        Callback = function()
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").FogEnd = 100000
            Rayfield:Notify({Title = "Done", Content = "Full Bright enabled."})
        end,
    })

    World:CreateButton({
        Name = "Highlight Everything (ESP)",
        Callback = function()
            local wItems = workspace:FindFirstChild("Items")
            if wItems then
                for _, v in pairs(wItems:GetChildren()) do
                    local h = Instance.new("Highlight", v)
                    h.FillColor = Color3.fromRGB(0, 255, 0)
                end
            end
            local wChars = workspace:FindFirstChild("Characters")
            if wChars then
                for _, v in pairs(wChars:GetChildren()) do
                    local h = Instance.new("Highlight", v)
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                end
            end
            Rayfield:Notify({Title = "ESP", Content = "Highlights applied."})
        end,
    })

    World:CreateSection("World Edits")

    World:CreateButton({
        Name = "Clear All Trees",
        Callback = function()
            if workspace:FindFirstChild("Foliage") then
                workspace.Foliage:Destroy()
                Rayfield:Notify({Title = "Done", Content = "Foliage cleared."})
            else
                Rayfield:Notify({Title = "Error", Content = "Foliage not found."})
            end
        end,
    })

    -- LOOPS (99 Nights)
    game:GetService("RunService").Stepped:Connect(function()
        if NoClip then
            pcall(function()
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        end
    end)

    task.spawn(function()
        while task.wait(0.5) do
            if KillAuraEnabled then
                local wChars = workspace:FindFirstChild("Characters")
                if wChars then
                    for _, m in pairs(wChars:GetChildren()) do
                        local hum = m:FindFirstChild("NPC") or m:FindFirstChildOfClass("Humanoid")
                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local dist = (char.HumanoidRootPart.Position - m:GetPivot().Position).Magnitude
                            if hum and hum.Health > 0 and dist < 30 then
                                hum.Health = 0
                            end
                        end
                    end
                end
            end

            if AutoElf then
                local c = workspace:FindFirstChild("Christmas")
                if c then
                    for _, e in pairs(c:GetDescendants()) do
                        if e:IsA("ProximityPrompt") then
                            pcall(function() fireproximityprompt(e) end)
                        end
                    end
                end
            end

            if AutoFarmLogs then
                local wItems = workspace:FindFirstChild("Items")
                if wItems then
                    for _, item in pairs(wItems:GetChildren()) do
                        if item.Name == "Log" then
                            pcall(function()
                                game.Players.LocalPlayer.Character:PivotTo(item:GetPivot())
                            end)
                            task.wait(0.6)
                        end
                    end
                end
            end
        end
    end)

end

-------------------------------------------------------------------
-- ========== BRAINROTS ONLY ==========
-------------------------------------------------------------------
if isBrainrots then

    local InstaInteract = false
    local AutoCollectEnabled = false
    local AutoReturnOnPickup = false
    local SpawnPoint = nil
    local IsCollecting = false

    -- 🏠 MAIN
    local Main = Window:CreateTab("🏠 Main", 4483362458)
    Main:CreateSection("Movement")

    Main:CreateToggle({
        Name = "Infinite Jump",
        CurrentValue = false,
        Flag = "InfJump",
        Callback = function(v)
            InfJumpEnabled = v
            if v then
                jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                    local char = game.Players.LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                end)
            else
                if jumpConnection then jumpConnection:Disconnect() jumpConnection = nil end
            end
        end,
    })

    Main:CreateSlider({
        Name = "Walk Speed",
        Range = {16, 350},
        Increment = 2,
        Suffix = " studs/s",
        CurrentValue = 16,
        Callback = function(v)
            pcall(function()
                local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = v end
            end)
        end,
    })

    Main:CreateSlider({
        Name = "Jump Power",
        Range = {50, 500},
        Increment = 5,
        Suffix = " power",
        CurrentValue = 50,
        Callback = function(v)
            pcall(function()
                local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.UseJumpPower = true
                    hum.JumpPower = v
                end
            end)
        end,
    })

    Main:CreateSection("Quick Utilities")

    Main:CreateToggle({
        Name = "Insta Interact (E)",
        CurrentValue = false,
        Callback = function(v)
            InstaInteract = v
            if v then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then obj.HoldDuration = 0 end
                end
            end
        end,
    })

    Main:CreateButton({
        Name = "VIP Bypass (Delete VIP Doors)",
        Callback = function()
            local gf = workspace:FindFirstChild("GameFolder")
            local vip = gf and gf:FindFirstChild("VIPDoors")
            if vip then
                vip:Destroy()
                Rayfield:Notify({Title = "Done", Content = "VIP Doors removed."})
            else
                Rayfield:Notify({Title = "Error", Content = "VIP Doors not found."})
            end
        end,
    })

    Main:CreateButton({
        Name = "Delete Lavas & Heights",
        Callback = function()
            local gf = workspace:FindFirstChild("GameFolder")
            if gf then
                local removed = {}
                pcall(function()
                    local l = gf:FindFirstChild("Lavas")
                    if l then l:Destroy() table.insert(removed, "Lavas") end
                end)
                pcall(function()
                    local h = gf:FindFirstChild("Heights")
                    if h then h:Destroy() table.insert(removed, "Heights") end
                end)
                if #removed > 0 then
                    Rayfield:Notify({Title = "Done", Content = table.concat(removed, " & ") .. " removed."})
                else
                    Rayfield:Notify({Title = "Error", Content = "Nothing found to remove."})
                end
            else
                Rayfield:Notify({Title = "Error", Content = "GameFolder not found."})
            end
        end,
    })

    -- 🚀 TELEPORTS
    local Teleports = Window:CreateTab("🚀 Teleports", 4483362458)
    Teleports:CreateSection("World TPs")

    Teleports:CreateButton({
        Name = "Teleport to My Plot",
        Callback = function()
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local gf = workspace:FindFirstChild("GameFolder")
            local plots = gf and gf:FindFirstChild("Plots")
            if hrp and plots then
                for _, plot in ipairs(plots:GetChildren()) do
                    local base = plot.PrimaryPart or plot:FindFirstChild("BasePrimary") or plot:FindFirstChildWhichIsA("BasePart")
                    if base then
                        hrp.CFrame = base.CFrame + Vector3.new(0, 6, 0)
                        Rayfield:Notify({Title = "Teleported", Content = "Plot found!"})
                        return
                    end
                end
                Rayfield:Notify({Title = "Error", Content = "No plot found."})
            else
                Rayfield:Notify({Title = "Error", Content = "Plots folder not found."})
            end
        end,
    })

    Teleports:CreateButton({
        Name = "Teleport to Safe Zone",
        Callback = function()
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(0, 105, 0)
                Rayfield:Notify({Title = "Teleported", Content = "Safe Zone reached."})
            end
        end,
    })

    Teleports:CreateSection("Brainrot TPs")

    Teleports:CreateButton({
        Name = "Teleport to Best Brainrot",
        Callback = function()
            local rarityOrder = {"Godly", "Celestial", "Secret", "Mythic", "Legendary", "Epic", "Rare", "Common"}
            local gf = workspace:FindFirstChild("GameFolder")
            local brainrots = gf and gf:FindFirstChild("Brainrots")
            if not brainrots then
                Rayfield:Notify({Title = "Error", Content = "Brainrots folder not found."})
                return
            end
            for _, rarity in ipairs(rarityOrder) do
                local folder = brainrots:FindFirstChild(rarity)
                if folder and #folder:GetChildren() > 0 then
                    local target = folder:GetChildren()[1]
                    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and target then
                        pcall(function() hrp.CFrame = target:GetPivot() + Vector3.new(0, 6, 0) end)
                        Rayfield:Notify({Title = "Found!", Content = "TP'd to " .. rarity .. " Brainrot."})
                        return
                    end
                end
            end
            Rayfield:Notify({Title = "None Found", Content = "No Brainrots in workspace."})
        end,
    })

    -- 💎 AUTOMATION
    local Automation = Window:CreateTab("💎 Automation", 4483362458)
    Automation:CreateSection("Auto-Return System")

    Automation:CreateToggle({
        Name = "Auto Return to Base",
        CurrentValue = false,
        Callback = function(v)
            AutoReturnOnPickup = v
            if v and not SpawnPoint then
                SpawnPoint = game.Players.LocalPlayer.Character:GetPivot()
                Rayfield:Notify({Title = "Base Set", Content = "Return point saved!"})
            end
        end,
    })

    Automation:CreateButton({
        Name = "Update Base Location",
        Callback = function()
            SpawnPoint = game.Players.LocalPlayer.Character:GetPivot()
            Rayfield:Notify({Title = "Updated", Content = "Base updated to current spot."})
        end,
    })

    Automation:CreateSection("Collection Settings")

    Automation:CreateToggle({
        Name = "Auto Collect Celestial & Godly",
        CurrentValue = false,
        Callback = function(v) AutoCollectEnabled = v end,
    })

    local function HandlePickup(obj)
        if IsCollecting or not AutoCollectEnabled then return end
        local char = game.Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
        if hrp and prompt then
            IsCollecting = true
            local oldPos = hrp.CFrame
            pcall(function() hrp.CFrame = obj:GetPivot() + Vector3.new(0, 5, 0) end)
            task.wait(0.3)
            pcall(function() fireproximityprompt(prompt) end)
            task.wait(0.2)
            if AutoReturnOnPickup and SpawnPoint then
                pcall(function() hrp.CFrame = SpawnPoint end)
            else
                pcall(function() hrp.CFrame = oldPos end)
            end
            task.wait(0.5)
            IsCollecting = false
        end
    end

    workspace.DescendantAdded:Connect(function(v)
        if InstaInteract and v:IsA("ProximityPrompt") then
            pcall(function() v.HoldDuration = 0 end)
        end
        if AutoCollectEnabled and v:IsA("Model") and v.Parent then
            if v.Parent.Name == "Godly" or v.Parent.Name == "Celestial" then
                HandlePickup(v)
            end
        end
    end)

end
-------------------------------------------------------------------
-- ========== SURVIVAL MINI ONLY ==========
-------------------------------------------------------------------
if isSurvivalMini then

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local localPlayer = Players.LocalPlayer

    local SMConfig = {
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
            {Name = "Palletwrong", Color = Color3.fromRGB(74, 255, 181)},
            {Name = "Window",      Color = Color3.fromRGB(74, 255, 181)},
            {Name = "Hook",        Color = Color3.fromRGB(132, 255, 169)}
        }
    }

    local function ApplySMHighlight(obj, color)
        if not obj or obj == localPlayer.Character or obj:FindFirstChild("RootESP") then return end
        local h = Instance.new("Highlight")
        h.Name = "RootESP"
        h.Adornee = obj
        h.FillColor = color
        h.OutlineColor = Color3.new(1, 1, 1)
        h.FillTransparency = 0.7
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Enabled = SMConfig.ESPEnabled
        h.Parent = obj
    end

    local function GetSMRole(p)
        return (p.Team and p.Team.Name:lower():find("killer")) and "Killer" or "Survivor"
    end

    -- 🏃 MOVEMENT TAB
    local SMMain = Window:CreateTab("🏃 Movement", 4483362458)
    SMMain:CreateSection("Speed & Physics")

    SMMain:CreateToggle({
        Name = "Speed Boost (B to toggle)",
        CurrentValue = false,
        Callback = function(v)
            SMConfig.SpeedEnabled = v
            if not v then
                pcall(function() localPlayer.Character.Humanoid.WalkSpeed = 16 end)
            end
            Rayfield:Notify({Title = "Speed", Content = v and "Speed ON." or "Speed OFF."})
        end,
    })

    SMMain:CreateSlider({
        Name = "Custom Speed",
        Range = {16, 300},
        Increment = 5,
        Suffix = " studs/s",
        CurrentValue = 50,
        Callback = function(v)
            SMConfig.CustomSpeed = v
        end,
    })

    SMMain:CreateToggle({
        Name = "Noclip (N to toggle)",
        CurrentValue = false,
        Callback = function(v)
            SMConfig.NoclipEnabled = v
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

    -- 👁️ ESP TAB
    local SMEsp = Window:CreateTab("👁️ ESP", 4483362458)
    SMEsp:CreateSection("Player & Object ESP")

    SMEsp:CreateToggle({
        Name = "ESP Enabled (V to toggle)",
        CurrentValue = true,
        Callback = function(v)
            SMConfig.ESPEnabled = v
            for _, obj in ipairs(workspace:GetDescendants()) do
                local h = obj:FindFirstChild("RootESP")
                if h then h.Enabled = SMConfig.ESPEnabled end
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character then
                    local h = p.Character:FindFirstChild("RootESP")
                    if h then h.Enabled = SMConfig.ESPEnabled end
                end
            end
            Rayfield:Notify({Title = "ESP", Content = v and "ESP Enabled." or "ESP Disabled."})
        end,
    })

    SMEsp:CreateButton({
        Name = "Refresh ESP",
        Callback = function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                local h = obj:FindFirstChild("RootESP")
                if h then h:Destroy() end
            end
            for _, obj in ipairs(workspace:GetDescendants()) do
                for _, data in ipairs(SMConfig.Objects) do
                    if obj.Name == data.Name then ApplySMHighlight(obj, data.Color) end
                end
            end
            Rayfield:Notify({Title = "ESP", Content = "ESP refreshed."})
        end,
    })

    -- ⚡ SKILL CHECK TAB
    local SMSc = Window:CreateTab("⚡ Skill Check", 4483362458)
    SMSc:CreateSection("Auto Skill Check")
    SMSc:CreateParagraph({
        Title = "Auto Skill Check",
        Content = "Automatically presses Space at the correct moment. Reloads on map change."
    })

    -- Keybinds (V / N / B)
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.V then
            SMConfig.ESPEnabled = not SMConfig.ESPEnabled
            for _, obj in ipairs(workspace:GetDescendants()) do
                local h = obj:FindFirstChild("RootESP")
                if h then h.Enabled = SMConfig.ESPEnabled end
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character then
                    local h = p.Character:FindFirstChild("RootESP")
                    if h then h.Enabled = SMConfig.ESPEnabled end
                end
            end
            Rayfield:Notify({Title = "ESP", Content = SMConfig.ESPEnabled and "ESP On (V)" or "ESP Off (V)"})
        elseif input.KeyCode == Enum.KeyCode.N then
            SMConfig.NoclipEnabled = not SMConfig.NoclipEnabled
            if not SMConfig.NoclipEnabled then
                pcall(function()
                    for _, part in pairs(localPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end)
            end
            Rayfield:Notify({Title = "Noclip", Content = SMConfig.NoclipEnabled and "Noclip ON (N)" or "Noclip OFF (N)"})
        elseif input.KeyCode == Enum.KeyCode.B then
            SMConfig.SpeedEnabled = not SMConfig.SpeedEnabled
            if not SMConfig.SpeedEnabled then
                pcall(function() localPlayer.Character.Humanoid.WalkSpeed = 16 end)
            end
            Rayfield:Notify({Title = "Speed", Content = SMConfig.SpeedEnabled and "Speed ON (B)" or "Speed OFF (B)"})
        end
    end)

    -- Forced movement loop
    RunService.Stepped:Connect(function()
        local char = localPlayer.Character
        if not char then return end
        if SMConfig.NoclipEnabled then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and SMConfig.SpeedEnabled then
            hum.WalkSpeed = SMConfig.CustomSpeed
        end
    end)

    -- Object ESP loop
    task.spawn(function()
        while true do
            for _, obj in ipairs(workspace:GetDescendants()) do
                for _, data in ipairs(SMConfig.Objects) do
                    if obj.Name == data.Name then ApplySMHighlight(obj, data.Color) end
                end
            end
            task.wait(5)
        end
    end)

    -- Player ESP setup
    local function SetupSMPlayer(p)
        if p == localPlayer then return end
        p.CharacterAdded:Connect(function(char)
            task.wait(1)
            ApplySMHighlight(char, SMConfig.Players[GetSMRole(p)].Color)
        end)
        if p.Character then
            ApplySMHighlight(p.Character, SMConfig.Players[GetSMRole(p)].Color)
        end
    end

    Players.PlayerAdded:Connect(SetupSMPlayer)
    for _, p in ipairs(Players:GetPlayers()) do SetupSMPlayer(p) end

    -- Auto Skill Check
    local function ConnectSMSkillCheck()
        local PlayerGui = localPlayer:WaitForChild("PlayerGui")
        local CheckGui = PlayerGui:WaitForChild("SkillCheckPromptGui", 10)
        if not CheckGui then return end
        local Check = CheckGui:WaitForChild("Check")
        local Line = Check:WaitForChild("Line")
        local Goal = Check:WaitForChild("Goal")
        local HeartbeatConn = nil
        Check:GetPropertyChangedSignal("Visible"):Connect(function()
            if Check.Visible then
                if HeartbeatConn then HeartbeatConn:Disconnect() end
                HeartbeatConn = RunService.Heartbeat:Connect(function()
                    if not Check.Visible then
                        if HeartbeatConn then HeartbeatConn:Disconnect() HeartbeatConn = nil end
                        return
                    end
                    local lr = Line.Rotation % 360
                    local gr = Goal.Rotation % 360
                    local gs = (gr + 104) % 360
                    local ge = (gr + 114) % 360
                    if (gs > ge and (lr >= gs or lr <= ge)) or (lr >= gs and lr <= ge) then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                        if HeartbeatConn then HeartbeatConn:Disconnect() HeartbeatConn = nil end
                    end
                end)
            elseif HeartbeatConn then
                HeartbeatConn:Disconnect()
                HeartbeatConn = nil
            end
        end)
    end

    localPlayer.CharacterAdded:Connect(function()
        task.wait(2)
        ConnectSMSkillCheck()
    end)
    task.spawn(ConnectSMSkillCheck)

    Rayfield:Notify({Title = "🪓 Root Hub | Survival Mini", Content = "V: ESP | N: Noclip | B: Speed", Duration = 5})

end
-------------------------------------------------------------------
-- 🛠 MISC (shared)
-------------------------------------------------------------------
local Misc = Window:CreateTab("🛠 Misc", 4483362458)

Misc:CreateSection("Server")

Misc:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end)
    end,
})

Misc:CreateButton({
    Name = "Join Discord Server",
    Callback = function() end,
})

Misc:CreateLabel("Root Hub Combined Edition by Slikke2")

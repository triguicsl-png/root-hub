-- Root Hub - Clean UI + Jump Power + Auto-Return
-- VIP Bypass | Brainrot TPs | All Features Included

local PlaceId = game.PlaceId

if PlaceId == 119987266683883 or PlaceId == 12912731475 then
    
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    
    local isBrainrots = (PlaceId == 119987266683883)
    
    local Window = Rayfield:CreateWindow({
        Name = isBrainrots and "🦖 Survive LAVA for Brainrots!" or "🌴 Mansion Tycoon",
        LoadingTitle = "Root Hub",
        LoadingSubtitle = "by Slikke2 • Full Version",
        Theme = "Default",
        ToggleUIKeybind = "K",
        KeySystem = isBrainrots,
        KeySettings = {
            Title = "Easy Key",
            Subtitle = "Key System",
            Note = "Key is: root",
            SaveKey = true,
            Key = {"root"}
        }
    })
    
    -- States
    local InfJumpEnabled = false
    local AutoCollectEnabled = false
    local AutoReturnOnPickup = false
    local SpawnPoint = nil
    local jumpConnection = nil

    -------------------------------------------------------------------
    -- MAIN TAB (Movement & Utilities)
    -------------------------------------------------------------------
    local Main = Window:CreateTab("🏠 Main", 4483362458)
    
    Main:CreateSection("Movement")
    
    Main:CreateToggle({
        Name = "Infinite Jump",
        CurrentValue = false,
        Flag = "InfJump",
        Callback = function(Value)
            InfJumpEnabled = Value
            if Value then
                jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                    if InfJumpEnabled then
                        local char = game.Players.LocalPlayer.Character
                        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                end)
            else
                if jumpConnection then
                    jumpConnection:Disconnect()
                    jumpConnection = nil
                end
            end
        end,
    })
    
    Main:CreateSlider({
        Name = "Walk Speed",
        Range = {16, 350},
        Increment = 2,
        Suffix = " studs/s",
        CurrentValue = 16,
        Callback = function(Value)
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Value end
        end,
    })

    Main:CreateSlider({
        Name = "Jump Power",
        Range = {50, 500},
        Increment = 5,
        Suffix = " power",
        CurrentValue = 50,
        Callback = function(Value)
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then 
                hum.UseJumpPower = true
                hum.JumpPower = Value 
            end
        end,
    })
    
    Main:CreateSection("Quick Utilities")
    
    Main:CreateToggle({
        Name = "Insta Interact (E)",
        CurrentValue = false,
        Callback = function(Value)
            if Value then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
                end
                Rayfield:Notify({Title="Activated", Content="All prompts set to instant"})
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
                Rayfield:Notify({Title = "VIP Bypass", Content = "VIP Doors removed"})
            else
                Rayfield:Notify({Title = "Info", Content = "No VIPDoors found"})
            end
        end,
    })
    
    Main:CreateButton({
        Name = "Delete Lavas & Heights",
        Callback = function()
            local gf = workspace:FindFirstChild("GameFolder")
            if gf then
                pcall(function() gf:FindFirstChild("Lavas"):Destroy() end)
                pcall(function() gf:FindFirstChild("Heights"):Destroy() end)
                Rayfield:Notify({Title = "Success", Content = "Lava & Heights removed"})
            end
        end,
    })
    
    -------------------------------------------------------------------
    -- TELEPORTS TAB
    -------------------------------------------------------------------
    local Teleports = Window:CreateTab("🚀 Teleports", 4483362458)
    
    Teleports:CreateSection("Auto Return System")

    Teleports:CreateToggle({
        Name = "Auto Return on Pickup",
        CurrentValue = false,
        Callback = function(Value) 
            AutoReturnOnPickup = Value 
            if Value and not SpawnPoint then
                SpawnPoint = game.Players.LocalPlayer.Character:GetPivot()
                Rayfield:Notify({Title = "Base Set", Content = "Current spot is now Return Point."})
            end
        end,
    })

    Teleports:CreateButton({
        Name = "Set Current Pos as Base",
        Callback = function()
            SpawnPoint = game.Players.LocalPlayer.Character:GetPivot()
            Rayfield:Notify({Title = "Success", Content = "New Base Saved!"})
        end,
    })

    Teleports:CreateSection("Useful Locations")
    
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
                        return
                    end
                end
            end
        end,
    })

    Teleports:CreateButton({
        Name = "Teleport to Best Brainrot",
        Callback = function()
            local rarityOrder = {"Godly", "Celestial", "Secret", "Mythic", "Legendary", "Epic", "Rare", "Common"}
            local brainrots = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("Brainrots")
            if not brainrots then return end
            for _, rarity in ipairs(rarityOrder) do
                local folder = brainrots:FindFirstChild(rarity)
                if folder and #folder:GetChildren() > 0 then
                    local target = folder:GetChildren()[1]
                    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and target then
                        hrp.CFrame = target:GetPivot() + Vector3.new(0, 6, 0)
                        return
                    end
                end
            end
        end,
    })

    -------------------------------------------------------------------
    -- COLLECT TAB
    -------------------------------------------------------------------
    local Collect = Window:CreateTab("💎 Collect", 4483362458)
    
    Collect:CreateToggle({
        Name = "Auto Collect Celestial & Godly",
        CurrentValue = false,
        Callback = function(v) AutoCollectEnabled = v end,
    })

    -------------------------------------------------------------------
    -- PICKUP DETECTOR (For Auto Return)
    -------------------------------------------------------------------
    local function doReturn()
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and SpawnPoint then
            hrp.CFrame = SpawnPoint
            Rayfield:Notify({Title = "Secured", Content = "Teleported to Base"})
        end
    end

    game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function()
        if AutoReturnOnPickup then task.wait(0.2); doReturn() end
    end)

    -- Auto-collect background logic
    workspace.DescendantAdded:Connect(function(v)
        if AutoCollectEnabled and v:IsA("Model") and (v.Parent.Name == "Godly" or v.Parent.Name == "Celestial") then
            task.wait(0.2)
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = v:GetPivot() + Vector3.new(0, 6, 0)
                task.wait(0.3)
                local prompt = v:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then fireproximityprompt(prompt) end
            end
        end
    end)
    
    -------------------------------------------------------------------
    -- MISC TAB
    -------------------------------------------------------------------
    local Misc = Window:CreateTab("🛠 Misc", 4483362458)
    
    Misc:CreateButton({
        Name = "Rejoin / Server Hop",
        Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end,
    })
    
    Misc:CreateLabel("Root Hub by Slikke2")
end

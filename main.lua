-- Root Hub - Supports Survive LAVA for Brainrots! + Mansion Tycoon
-- EVERYTHING INCLUDED: Movement, VIP Bypass, Lava Delete, Auto-Collect, Auto-Return, All TPs, Tycoon Auto

local PlaceId = game.PlaceId

if PlaceId == 119987266683883
    
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    
    local isBrainrots = (PlaceId == 119987266683883)
    
    local Window = Rayfield:CreateWindow({
        Name = isBrainrots and "🦖 Survive LAVA for Brainrots!",
        LoadingTitle = "Root Hub",
        LoadingSubtitle = "by Slikke2",
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
    
    -- Variables / Global States
    local InfJumpEnabled = false
    local jumpConnection = nil
    local InstaInteract = false
    local AutoCollectEnabled = false
    local AutoReturnOnPickup = false
    local SpawnPoint = nil
    local IsCollecting = false
    local AutoCollectTycoon = false
    local CollectSpeed = 0.5
    
    -------------------------------------------------------------------
    -- MAIN TAB (Movement & Basic Utilities)
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
                    local char = game.Players.LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                end)
            elseif jumpConnection then
                jumpConnection:Disconnect()
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
            InstaInteract = Value
            if Value then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
                end
            end
        end,
    })
    
    Main:CreateButton({
        Name = "VIP Bypass (Delete VIP Doors)",
        Callback = function()
            local gf = workspace:FindFirstChild("GameFolder")
            local vip = gf and gf:FindFirstChild("VIPDoors")
            if vip then vip:Destroy() end
        end,
    })
    
    Main:CreateButton({
        Name = "Delete Lavas & Heights",
        Callback = function()
            local gf = workspace:FindFirstChild("GameFolder")
            if gf then
                pcall(function() gf:FindFirstChild("Lavas"):Destroy() end)
                pcall(function() gf:FindFirstChild("Heights"):Destroy() end)
            end
        end,
    })

    -------------------------------------------------------------------
    -- TELEPORTS TAB
    -------------------------------------------------------------------
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
                        Rayfield:Notify({Title="Teleported", Content="Plot Found!"})
                        return
                    end
                end
            end
        end,
    })

    Teleports:CreateButton({
        Name = "Teleport to Safe Zone",
        Callback = function()
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(0, 100, 0) + Vector3.new(0, 5, 0)
            end
        end,
    })

    Teleports:CreateSection("Brainrot TPs")

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
                        Rayfield:Notify({Title="Found!", Content="TP'd to "..rarity})
                        return
                    end
                end
            end
        end,
    })

    -------------------------------------------------------------------
    -- AUTOMATION TAB (Collect & Return)
    -------------------------------------------------------------------
    if isBrainrots then
        local Automation = Window:CreateTab("💎 Automation", 4483362458)
        
        Automation:CreateSection("Auto-Return System")
        
        Automation:CreateToggle({
            Name = "Auto Return to Base",
            CurrentValue = false,
            Callback = function(Value) 
                AutoReturnOnPickup = Value 
                if Value and not SpawnPoint then
                    SpawnPoint = game.Players.LocalPlayer.Character:GetPivot()
                    Rayfield:Notify({Title = "Base Set", Content = "Your return point is saved!"})
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

        -- Logic: TP -> Pick -> Back
        local function HandlePickup(obj)
            if IsCollecting or not AutoCollectEnabled then return end
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
            
            if hrp and prompt then
                IsCollecting = true
                local oldPos = hrp.CFrame
                hrp.CFrame = obj:GetPivot() + Vector3.new(0, 5, 0)
                task.wait(0.3)
                fireproximityprompt(prompt)
                task.wait(0.2)
                if AutoReturnOnPickup and SpawnPoint then
                    hrp.CFrame = SpawnPoint
                else
                    hrp.CFrame = oldPos
                end
                task.wait(0.5)
                IsCollecting = false
            end
        end

        workspace.DescendantAdded:Connect(function(v)
            if InstaInteract and v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
            if AutoCollectEnabled and v:IsA("Model") and v.Parent and (v.Parent.Name == "Godly" or v.Parent.Name == "Celestial") then
                HandlePickup(v)
            end
        end)
    end

    -------------------------------------------------------------------
    -- TYCOON TAB (Mansion Tycoon)
    -------------------------------------------------------------------
    if PlaceId == 12912731475 then
        local TycoonTab = Window:CreateTab("🌴 Tycoon", 4483362458)
        
        local function GetMyPlot()
            local playerName = game.Players.LocalPlayer.Name
            local tycconsFolder = workspace:FindFirstChild("Tyccons")
            if not tycconsFolder then return nil end
            for _, plot in pairs(tycconsFolder:GetChildren()) do
                if plot:IsA("Model") and (plot.Name == playerName or string.find(plot.Name:lower(), playerName:lower()) or plot:FindFirstChild(playerName)) then
                    return plot
                end
            end
            return nil
        end
        
        TycoonTab:CreateToggle({
            Name = "Auto Collect Money",
            CurrentValue = false,
            Callback = function(Value)
                AutoCollectTycoon = Value
                if Value then
                    task.spawn(function()
                        while AutoCollectTycoon do
                            local myPlot = GetMyPlot()
                            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if myPlot and hrp then
                                for _, obj in pairs(myPlot:GetDescendants()) do
                                    if obj:IsA("BasePart") and (obj.Name == "Touch" or obj.Name == "Collector") then
                                        local oldCF = hrp.CFrame
                                        hrp.CFrame = obj.CFrame + Vector3.new(0, 2, 0)
                                        task.wait(0.1)
                                        hrp.CFrame = oldCF
                                        task.wait(0.05)
                                    end
                                end
                            end
                            task.wait(CollectSpeed)
                        end
                    end)
                end
            end,
        })
        
        TycoonTab:CreateSlider({
            Name = "Collection Speed",
            Range = {0.1, 5},
            Increment = 0.1,
            CurrentValue = 0.5,
            Callback = function(Value) CollectSpeed = Value end,
        })
    end
    
    -------------------------------------------------------------------
    -- MISC
    -------------------------------------------------------------------
    local Misc = Window:CreateTab("🛠 Misc", 4483362458)
    Misc:CreateButton({
        Name = "Server Hop / Rejoin",
        Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end,
    })
    
    Misc:CreateLabel("Root Hub by Slikke2")
end

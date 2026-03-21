if game.PlaceId == 119987266683883 or game.PlaceId == 12912731475 then
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    
    local Window = Rayfield:CreateWindow({
        Name = "🦖 Survive LAVA for Brainrots!",
        LoadingTitle = "Root Hub",
        LoadingSubtitle = "by Slikke2",
        Theme = "Default",
        ToggleUIKeybind = "K",
        KeySystem = true, 
        KeySettings = {
            Title = "Easy Key",
            Subtitle = "Key System",
            Note = "Key is: root",
            SaveKey = true,
            Key = {"root"}
        }
    })

    local Tab = Window:CreateTab("🏠 Home", 4483362458)

    -------------------------------------------------------------------
    -- GAME 1: Survive LAVA for Brainrots!
    -------------------------------------------------------------------
    if game.PlaceId == 119987266683883 then
        -- States
        local InfJumpEnabled = false
        local InstaInteract = false
        local AutoCollectEnabled = false

        -- FIXED Infinite Jump Logic
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if InfJumpEnabled then
                local char = game.Players.LocalPlayer.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)

        Tab:CreateSection("Movement")

        Tab:CreateToggle({
            Name = "Infinite Jump",
            CurrentValue = false,
            Flag = "InfJump",
            Callback = function(Value) InfJumpEnabled = Value end,
        })

        Tab:CreateSlider({
            Name = "Walk Speed",
            Range = {16, 300},
            Increment = 1,
            CurrentValue = 16,
            Callback = function(Value)
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
                end
            end,
        })

        Tab:CreateSection("Exploits & Bypasses")

        -- VIP BYPASS (Deletes Doors)
        Tab:CreateButton({
            Name = "Bypass VIP Doors",
            Callback = function()
                local folder = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("VIPDoors")
                if folder then 
                    folder:Destroy()
                    Rayfield:Notify({Title = "Success", Content = "VIP Doors Removed!"})
                end
            end,
        })

        -- INSTA INTERACT
        Tab:CreateToggle({
            Name = "Insta Interact (E)",
            CurrentValue = false,
            Flag = "Insta",
            Callback = function(Value)
                InstaInteract = Value
                if InstaInteract then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
                    end
                end
            end,
        })

        Tab:CreateButton({
            Name = "Delete Lavas & Heights",
            Callback = function()
                if workspace:FindFirstChild("GameFolder") then
                    if workspace.GameFolder:FindFirstChild("Lavas") then workspace.GameFolder.Lavas:Destroy() end
                    if workspace.GameFolder:FindFirstChild("Heights") then workspace.GameFolder.Heights:Destroy() end
                end
            end,
        })

        Tab:CreateSection("Brainrot Collection")

        -- TELEPORT TO BEST BRAINROT
        Tab:CreateButton({
            Name = "Teleport to Best Brainrot",
            Callback = function()
                local rarityOrder = {"Godly", "Celestial", "Secret", "Mythic", "Legendary", "Epic", "Rare", "Common"}
                local folder = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("Brainrots")
                if not folder then return end

                for _, rarity in ipairs(rarityOrder) do
                    local rFolder = folder:FindFirstChild(rarity)
                    if rFolder and #rFolder:GetChildren() > 0 then
                        local target = rFolder:GetChildren()[1]
                        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and target then
                            hrp.CFrame = target:GetPivot() + Vector3.new(0, 5, 0)
                            return
                        end
                    end
                end
            end,
        })

        Tab:CreateToggle({
            Name = "Auto Collect Celestial & Godly",
            CurrentValue = false,
            Flag = "AutoCollect",
            Callback = function(Value) AutoCollectEnabled = Value end,
        })

        -- Auto-Collect Listener
        workspace.DescendantAdded:Connect(function(v)
            if InstaInteract and v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
            
            if AutoCollectEnabled and v:IsA("Model") and (v.Parent.Name == "Godly" or v.Parent.Name == "Celestial") then
                task.wait(0.2)
                local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local oldPos = hrp.CFrame
                    hrp.CFrame = v:GetPivot() + Vector3.new(0, 5, 0)
                    task.wait(0.3)
                    local prompt = v:FindFirstChildOfClass("ProximityPrompt", true)
                    if prompt then fireproximityprompt(prompt) end
                    task.wait(0.5)
                    hrp.CFrame = oldPos
                end
            end
        end)

    -------------------------------------------------------------------
    -- GAME 2: Tycoon
    -------------------------------------------------------------------
    elseif game.PlaceId == 12912731475 then
       -- TYCOON SECTION (PlaceId: 12912731475)
local AutoCollectTycoon = false
local CollectSpeed = 0.5 -- Adjust this (lower = faster)

-- Function to find YOUR tycoon plot
local function GetMyTycoon()
    local player = game.Players.LocalPlayer
    local tycoons = workspace:FindFirstChild("Tycoons")
    if not tycoons then return nil end

    for _, plot in pairs(tycoons:GetChildren()) do
        -- Most tycoons have an 'Owner' StringValue or ObjectValue
        local owner = plot:FindFirstChild("Owner")
        if owner and (owner.Value == player.Name or owner.Value == player) then
            return plot
        end
    end
    return nil
end

Tab:CreateSection("Tycoon Automation")

Tab:CreateToggle({
    Name = "Auto Collect Money",
    CurrentValue = false,
    Flag = "AutoCollectTycoon",
    Callback = function(Value)
        AutoCollectTycoon = Value
        
        if AutoCollectTycoon then
            task.spawn(function()
                while AutoCollectTycoon do
                    local myPlot = GetMyTycoon()
                    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    
                    if myPlot and hrp then
                        -- Look for the 'Collectors' folder inside your plot
                        -- Using ':FindFirstChild(name, true)' searches all sub-folders too
                        local collectors = myPlot:FindFirstChild("Collectors", true)
                        
                        if collectors then
                            for _, col in pairs(collectors:GetChildren()) do
                                local touchPart = col:FindFirstChild("Touch") or col:FindFirstChild("Pad")
                                
                                if touchPart then
                                    -- Save current position to 'jitter' back and forth (simulates a real touch)
                                    local oldCF = hrp.CFrame
                                    hrp.CFrame = touchPart.CFrame + Vector3.new(0, 2, 0)
                                    task.wait(0.1)
                                    hrp.CFrame = oldCF
                                end
                            end
                        end
                    end
                    task.wait(CollectSpeed)
                end
            end)
        end
    end,
})

Tab:CreateSlider({
    Name = "Collection Delay",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 0.5,
    Callback = function(Value)
        CollectSpeed = Value
    end,
});
    end
end

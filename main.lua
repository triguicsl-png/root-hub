-- Root Hub - Survive LAVA for Brainrots!
-- by Slikke2

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local PlaceId = game.PlaceId
local isBrainrots = (PlaceId == 119987266683883)

local Window = Rayfield:CreateWindow({
    Name = isBrainrots and "🦖Root Hub | Survive LAVA for Brainrots!",
    LoadingTitle = "Root Hub",
    LoadingSubtitle = "by Slikke2",
    Theme = "Default",
    ToggleUIKeybind = "K",
    KeySystem = isBrainrots,
    KeySettings = {
        Title = "Easy Key",
        Subtitle = "Key System",
        Note = "Key is: Root",
        SaveKey = true,
        Key = {"Root"}
    }
})

-- Variables
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
-- 🏠 MAIN (Movement & Utilities)
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
        pcall(function()
            local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Value end
        end)
    end,
})

Main:CreateSlider({
    Name = "Jump Power",
    Range = {50, 500},
    Increment = 5,
    Suffix = " power",
    CurrentValue = 50,
    Callback = function(Value)
        pcall(function()
            local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = Value
            end
        end)
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

-------------------------------------------------------------------
-- 🚀 TELEPORTS
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

-------------------------------------------------------------------
-- 💎 AUTOMATION (Brainrots only)
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
-- 🛠 MISC
-------------------------------------------------------------------
local Misc = Window:CreateTab("🛠 Misc", 4483362458)

Misc:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end)
    end,
})

Misc:CreateLabel("Root Hub by Slikke2")

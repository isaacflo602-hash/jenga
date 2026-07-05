--hi
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "[FIXED] Blocks n' Props",
    LoadingTitle = "Neo Interface Engine",
    LoadingSubtitle = "by Neo",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

local Tab = Window:CreateTab("Game", nil)

local function getHRP()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function verifyTowersTeam()
    local myTeam = player.Team
    if myTeam and myTeam.Name == "Towers" then
        return true
    end
    Rayfield:Notify({
        Title = "Action Blocked",
        Content = "Must be on Towers team",
        Duration = 4,
    })
    return false
end

Tab:CreateButton({
    Name = "Instant Win",
    Callback = function()
        if not verifyTowersTeam() then return end
        
        local root = getHRP()
        local map = game.Workspace:FindFirstChild("Map")
        local classic = map and map:FindFirstChild("Classic")
        local obj = classic and classic:FindFirstChild("Button")
        
        if root and obj and obj:IsA("BasePart") then
            root.CFrame = obj.CFrame * CFrame.new(0, 3, 0)
            Rayfield:Notify({
                Title = "Success",
                Content = "Warped to button objective.",
                Duration = 4,
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Target element not found.",
                Duration = 4,
            })
        end
    end,
})

Tab:CreateButton({
    Name = "Delete Tower",
    Callback = function()
        local map = game.Workspace:FindFirstChild("Map")
        local classic = map and map:FindFirstChild("Classic")
        local targetTower = classic and classic:FindFirstChild("Tower")
        
        if targetTower then
            targetTower:Destroy()
            Rayfield:Notify({
                Title = "Success",
                Content = "Tower model successfully expunged.",
                Duration = 4,
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Tower target location missing or already deleted.",
                Duration = 4,
            })
        end
    end,
})

Tab:CreateButton({
    Name = "Teleport to the Destroyer",
    Callback = function()
        if not verifyTowersTeam() then return end

        local root = getHRP()
        local map = game.Workspace:FindFirstChild("Map")
        local classic = map and map:FindFirstChild("Classic")
        local shooter = classic and classic:FindFirstChild("Shooter")
        local panel = shooter and shooter:FindFirstChild("ControlPannel")
        local speed = panel and panel:FindFirstChild("Speed")
        local targetAdd = speed and speed:FindFirstChild("Add")

        if root and targetAdd and targetAdd:IsA("BasePart") then
            root.CFrame = targetAdd.CFrame * CFrame.new(0, 3, 0)
            Rayfield:Notify({
                Title = "Success",
                Content = "Warped to Control Panel Speed Add.",
                Duration = 4,
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Target Shooter Add asset missing.",
                Duration = 4,
            })
        end
    end,
})

Tab:CreateInput({
    Name = "WalkSpeed Modification",
    PlaceholderText = "16",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local val = tonumber(Text)
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and val then
            hum.WalkSpeed = val
            Rayfield:Notify({
                Title = "Calibrated",
                Content = "WalkSpeed calibrated to: " .. val,
                Duration = 4,
            })
        end
    end,
})

Tab:CreateInput({
    Name = "JumpPower Modification",
    PlaceholderText = "50",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local val = tonumber(Text)
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and val then
            hum.UseJumpPower = true
            hum.JumpPower = val
            Rayfield:Notify({
                Title = "Calibrated",
                Content = "JumpPower calibrated to: " .. val,
                Duration = 4,
            })
        end
    end,
})


--[[
    NEO-PANEL REBOOT
    Architecture: Flat UI Grid + Dual-Channel Native Input
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ─── Configuration & Theme ───
local THEME = {
    MainBg       = Color3.fromRGB(24, 24, 37),
    HeaderBg     = Color3.fromRGB(17, 17, 27),
    CardBg       = Color3.fromRGB(30, 30, 46),
    Accent       = Color3.fromRGB(137, 180, 250),
    AccentHover  = Color3.fromRGB(166, 227, 161),
    Text         = Color3.fromRGB(205, 214, 244),
    TextMuted    = Color3.fromRGB(166, 173, 186),
    Green        = Color3.fromRGB(166, 227, 161),
    Red          = Color3.fromRGB(243, 139, 168),
    OffState     = Color3.fromRGB(69, 71, 90),
}

-- ─── UI Creation ───
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeoPanel_Core"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui

-- Base Window
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 460, 0, 320)
MainWindow.Position = UDim2.new(0.5, -230, 0.5, -160)
MainWindow.BackgroundColor3 = THEME.MainBg
MainWindow.BorderSizePixel = 0
MainWindow.Active = true
MainWindow.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainWindow

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = THEME.CardBg
MainStroke.Thickness = 1.5
MainStroke.Parent = MainWindow

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = THEME.HeaderBg
Header.BorderSizePixel = 0
Header.Parent = MainWindow

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

-- Sharp edge correction for header bottom
local HeaderPatch = Instance.new("Frame")
HeaderPatch.Size = UDim2.new(1, 0, 0, 10)
HeaderPatch.Position = UDim2.new(0, 0, 1, -10)
HeaderPatch.BackgroundColor3 = THEME.HeaderBg
HeaderPatch.BorderSizePixel = 0
HeaderPatch.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✦ NEO INTERFACE"
Title.TextColor3 = THEME.Text
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 28, 0, 24)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -12)
CloseBtn.BackgroundColor3 = THEME.Red
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = THEME.HeaderBg
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- ─── Grid Page Engine ───
local PageContainer = Instance.new("Frame")
PageContainer.Name = "PageContainer"
PageContainer.Size = UDim2.new(1, -28, 1, -110)
PageContainer.Position = UDim2.new(0, 14, 0, 54)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainWindow

-- Page 1: Cheats Layout
local Page_Cheats = Instance.new("Frame")
Page_Cheats.Name = "Page_Cheats"
Page_Cheats.Size = UDim2.new(1, 0, 1, 0)
Page_Cheats.BackgroundTransparency = 1
Page_Cheats.Visible = true
Page_Cheats.Parent = PageContainer

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.CellSize = UDim2.new(0.5, -6, 0, 64)
UIGridLayout.CellPadding = UDim2.new(0, 12, 0, 12)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.Parent = Page_Cheats

-- Page 2: Credits Layout
local Page_Credits = Instance.new("Frame")
Page_Credits.Name = "Page_Credits"
Page_Credits.Size = UDim2.new(1, 0, 1, 0)
Page_Credits.BackgroundTransparency = 1
Page_Credits.Visible = false
Page_Credits.Parent = PageContainer

local CreditsLabel = Instance.new("TextLabel")
CreditsLabel.Size = UDim2.new(1, 0, 1, 0)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Text = "System Framework: Rebuilt Edition\nTarget Platform: Mobile / PC Crossplay\nStatus: Fully Operational"
CreditsLabel.TextColor3 = THEME.TextMuted
CreditsLabel.TextSize = 13
CreditsLabel.Font = Enum.Font.GothamMedium
CreditsLabel.LineHeight = 1.4
CreditsLabel.Parent = Page_Credits

-- ─── Bottom Navigation Dock ───
local BottomDock = Instance.new("Frame")
BottomDock.Name = "BottomDock"
BottomDock.Size = UDim2.new(1, -28, 0, 40)
BottomDock.Position = UDim2.new(0, 14, 1, -54)
BottomDock.BackgroundColor3 = THEME.HeaderBg
BottomDock.BorderSizePixel = 0
BottomDock.Parent = MainWindow

local DockCorner = Instance.new("UICorner")
DockCorner.CornerRadius = UDim.new(0, 8)
DockCorner.Parent = BottomDock

local Tab1Btn = Instance.new("TextButton")
Tab1Btn.Size = UDim2.new(0.5, -4, 1, -8)
Tab1Btn.Position = UDim2.new(0, 4, 0, 4)
Tab1Btn.BackgroundColor3 = THEME.Accent
Tab1Btn.Text = "Modules"
Tab1Btn.TextColor3 = THEME.MainBg
Tab1Btn.Font = Enum.Font.GothamBold
Tab1Btn.TextSize = 12
Tab1Btn.BorderSizePixel = 0
Tab1Btn.AutoButtonColor = false
Tab1Btn.Parent = BottomDock
local t1c = Instance.new("UICorner") t1c.CornerRadius = UDim.new(0, 6) t1c.Parent = Tab1Btn

local Tab2Btn = Instance.new("TextButton")
Tab2Btn.Size = UDim2.new(0.5, -4, 1, -8)
Tab2Btn.Position = UDim2.new(0.5, 0, 0, 4)
Tab2Btn.BackgroundTransparency = 1
Tab2Btn.Text = "Information"
Tab2Btn.TextColor3 = THEME.TextMuted
Tab2Btn.Font = Enum.Font.GothamBold
Tab2Btn.TextSize = 12
Tab2Btn.BorderSizePixel = 0
Tab2Btn.AutoButtonColor = false
Tab2Btn.Parent = BottomDock
local t2c = Instance.new("UICorner") t2c.CornerRadius = UDim.new(0, 6) t2c.Parent = Tab2Btn

-- ─── Functional Feature Button Factories ───
local function buildFeatureButton(titleText, subText, LayoutOrder)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = THEME.CardBg
    card.BorderSizePixel = 0
    card.LayoutOrder = LayoutOrder
    card.Parent = Page_Cheats
    local cc = Instance.new("UICorner") cc.CornerRadius = UDim.new(0, 8) cc.Parent = card
    
    local mainLabel = Instance.new("TextLabel")
    mainLabel.Size = UDim2.new(1, -16, 0, 22)
    mainLabel.Position = UDim2.new(0, 12, 0, 10)
    mainLabel.BackgroundTransparency = 1
    mainLabel.Text = titleText
    mainLabel.TextColor3 = THEME.Text
    mainLabel.TextSize = 13
    mainLabel.Font = Enum.Font.GothamBold
    mainLabel.TextXAlignment = Enum.TextXAlignment.Left
    mainLabel.Parent = card

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -16, 0, 18)
    descLabel.Position = UDim2.new(0, 12, 0, 30)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = subText
    descLabel.TextColor3 = THEME.TextMuted
    descLabel.TextSize = 10
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = card

    local interceptor = Instance.new("TextButton")
    interceptor.Size = UDim2.new(1, 0, 1, 0)
    interceptor.BackgroundTransparency = 1
    interceptor.Text = ""
    interceptor.ZIndex = 5
    interceptor.Parent = card

    return card, interceptor
end

local TeleportCard, TeleportTrigger = buildFeatureButton("Instant Teleport", "Warp directly to objective", 1)
local KillBrickCard, KillBrickTrigger = buildFeatureButton("Deactivate Danger", "Bypass level kill checks", 2)

-- Status Bar Footer
local StatusBar = Instance.new("TextLabel")
StatusBar.Size = UDim2.new(1, -28, 0, 20)
StatusBar.Position = UDim2.new(0, 14, 1, -24)
StatusBar.BackgroundTransparency = 1
StatusBar.Text = "System Status: Nominal"
StatusBar.TextColor3 = THEME.TextMuted
StatusBar.TextSize = 11
StatusBar.Font = Enum.Font.GothamMedium
StatusBar.TextXAlignment = Enum.TextXAlignment.Left
StatusBar.Parent = MainWindow

-- ─── Cross Platform Smart Input Engine ───
local function registerUniversalTap(buttonInstance, actionCallback)
    buttonInstance.MouseButton1Click:Connect(actionCallback)
    buttonInstance.TouchTap:Connect(actionCallback)
end

local function pushStatus(message, isAlert)
    StatusBar.Text = message
    StatusBar.TextColor3 = isAlert and THEME.Red or THEME.Green
    task.delay(4, function()
        if StatusBar.Text == message then
            StatusBar.Text = "System Status: Nominal"
            StatusBar.TextColor3 = THEME.TextMuted
        end
    end)
end

-- Tab Swap Logic
registerUniversalTap(Tab1Btn, function()
    Page_Cheats.Visible = true
    Page_Credits.Visible = false
    Tab1Btn.BackgroundTransparency = 0
    Tab1Btn.TextColor3 = THEME.MainBg
    Tab2Btn.BackgroundTransparency = 1
    Tab2Btn.TextColor3 = THEME.TextMuted
end)

registerUniversalTap(Tab2Btn, function()
    Page_Cheats.Visible = false
    Page_Credits.Visible = true
    Tab1Btn.BackgroundTransparency = 1
    Tab1Btn.TextColor3 = THEME.TextMuted
    Tab2Btn.BackgroundTransparency = 0
    Tab2Btn.TextColor3 = THEME.MainBg
end)

-- Window Closure Execution
registerUniversalTap(CloseBtn, function()
    ScreenGui:Destroy()
end)

-- ─── Feature Logic Systems ───

-- 1. Teleport Sequence
registerUniversalTap(TeleportTrigger, function()
    local myTeam = player.Team
    if not (myTeam and myTeam.Name == "Towers") then
        pushStatus("Action Blocked: Must be on team Towers", true)
        return
    end

    local char = player.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    
    -- Safe multi-layered environment scan
    local map = workspace:FindFirstChild("Map")
    local classic = map and map:FindFirstChild("Classic")
    local objective = classic and classic:FindFirstChild("Button")

    if rootPart and objective and objective:IsA("BasePart") then
        rootPart.CFrame = objective.CFrame * CFrame.new(0, 3, 0)
        pushStatus("Teleport completed successfully.", false)
        
        TweenService:Create(TeleportCard, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {
            BackgroundColor3 = THEME.AccentHover
        }):Play()
    else
        pushStatus("Failed: Target game elements missing from environment.", true)
    end
end)

-- 2. Clean-Room Killbrick Disabler Logic
local systemActiveState = false
local storedPartCollision = nil

registerUniversalTap(KillBrickTrigger, function()
    systemActiveState = not systemActiveState
    
    local map = workspace:FindFirstChild("Map")
    local classic = map and map:FindFirstChild("Classic")
    local brick = classic and classic:FindFirstChild("KillBrick")

    if brick then
        local codeRunner = brick:FindFirstChild("Code")
        local structuralTouch = brick:FindFirstChild("TouchInterest")

        if systemActiveState then
            -- Safely cut connection dependencies
            if codeRunner and codeRunner:IsA("Script") then codeRunner.Disabled = true end
            if structuralTouch then structuralTouch.Parent = nil end
            
            if brick:IsA("BasePart") then
                storedPartCollision = brick.CanCollide
                brick.CanCollide = true
            end
            
            KillBrickCard.BackgroundColor3 = THEME.Accent
            pushStatus("Level security matrices offline.", false)
        else
            -- Restore environment to factory state
            if codeRunner and codeRunner:IsA("Script") then codeRunner.Disabled = false end
            
            if brick:IsA("BasePart") and storedPartCollision ~= nil then
                brick.CanCollide = storedPartCollision
                storedPartCollision = nil
            end
            
            KillBrickCard.BackgroundColor3 = THEME.CardBg
            pushStatus("Level security matrices restored.", false)
        end
    else
        pushStatus("Error: Core security asset untraceable.", true)
        systemActiveState = not systemActiveState -- roll back state
    end
end)

-- ─── Drag Management Engine ───
local moving = false
local offsetPos = Vector3.new()
local initialPos = UDim2.new()

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        moving = true
        offsetPos = input.Position
        initialPos = MainWindow.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if moving and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local currentDiff = input.Position - offsetPos
        MainWindow.Position = UDim2.new(
            initialPos.X.Scale, initialPos.X.Offset + currentDiff.X,
            initialPos.Y.Scale, initialPos.Y.Offset + currentDiff.Y
        )
    end
end)

local function ceaseMovement() moving = false end
Header.InputEnded:Connect(ceaseMovement)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        ceaseMovement()
    end
end)

```

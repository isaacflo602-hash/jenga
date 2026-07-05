--[[
    NEO-PANEL REBOOT: ADVANCED EDITION
    Architecture: Scrollable Grid + Dual-Channel Native Input
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
MainWindow.Size = UDim2.new(0, 460, 0, 360)
MainWindow.Position = UDim2.new(0.5, -230, 0.5, -180)
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

-- ─── Scrolling Content Panel Engine ───
local PageScroll = Instance.new("ScrollingFrame")
PageScroll.Name = "PageScroll"
PageScroll.Size = UDim2.new(1, -28, 1, -110)
PageScroll.Position = UDim2.new(0, 14, 0, 54)
PageScroll.BackgroundTransparency = 1
PageScroll.BorderSizePixel = 0
PageScroll.ScrollBarThickness = 4
PageScroll.ScrollBarImageColor3 = THEME.CardBg
PageScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PageScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PageScroll.Active = false
PageScroll.Parent = MainWindow

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = PageScroll

-- Section Label
local SecHeader = Instance.new("TextLabel")
SecHeader.Size = UDim2.new(1, 0, 0, 20)
SecHeader.BackgroundTransparency = 1
SecHeader.Text = "Execution Matrix"
SecHeader.TextColor3 = THEME.TextMuted
SecHeader.TextSize = 12
SecHeader.Font = Enum.Font.GothamBold
SecHeader.TextXAlignment = Enum.TextXAlignment.Left
SecHeader.LayoutOrder = 1
SecHeader.Parent = PageScroll

-- ─── Feature UI Component Builders ───
local function buildFeatureButton(titleText, subText, LayoutOrder)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 54)
    card.BackgroundColor3 = THEME.CardBg
    card.BorderSizePixel = 0
    card.LayoutOrder = LayoutOrder
    card.Parent = PageScroll
    local cc = Instance.new("UICorner") cc.CornerRadius = UDim.new(0, 8) cc.Parent = card
    
    local mainLabel = Instance.new("TextLabel")
    mainLabel.Size = UDim2.new(1, -16, 0, 22)
    mainLabel.Position = UDim2.new(0, 12, 0, 8)
    mainLabel.BackgroundTransparency = 1
    mainLabel.Text = titleText
    mainLabel.TextColor3 = THEME.Text
    mainLabel.TextSize = 13
    mainLabel.Font = Enum.Font.GothamBold
    mainLabel.TextXAlignment = Enum.TextXAlignment.Left
    mainLabel.Parent = card

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -16, 0, 18)
    descLabel.Position = UDim2.new(0, 12, 0, 28)
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

local function buildValueInput(titleText, defaultPlaceholder, LayoutOrder)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 46)
    card.BackgroundColor3 = THEME.CardBg
    card.BorderSizePixel = 0
    card.LayoutOrder = LayoutOrder
    card.Parent = PageScroll
    local cc = Instance.new("UICorner") cc.CornerRadius = UDim.new(0, 8) cc.Parent = card

    local mainLabel = Instance.new("TextLabel")
    mainLabel.Size = UDim2.new(0.5, 0, 1, 0)
    mainLabel.Position = UDim2.new(0, 12, 0, 0)
    mainLabel.BackgroundTransparency = 1
    mainLabel.Text = titleText
    mainLabel.TextColor3 = THEME.Text
    mainLabel.TextSize = 13
    mainLabel.Font = Enum.Font.GothamBold
    mainLabel.TextXAlignment = Enum.TextXAlignment.Left
    mainLabel.Parent = card

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 100, 0, 30)
    box.Position = UDim2.new(1, -112, 0.5, -15)
    box.BackgroundColor3 = THEME.HeaderBg
    box.BorderSizePixel = 0
    box.Text = ""
    box.PlaceholderText = defaultPlaceholder
    box.TextColor3 = THEME.Accent
    box.PlaceholderColor3 = THEME.TextMuted
    box.Font = Enum.Font.GothamBold
    box.TextSize = 12
    box.Parent = card
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 6) bc.Parent = box

    return box
end

local function buildToggleRow(titleText, subText, LayoutOrder)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 54)
    card.BackgroundColor3 = THEME.CardBg
    card.BorderSizePixel = 0
    card.LayoutOrder = LayoutOrder
    card.Parent = PageScroll
    local cc = Instance.new("UICorner") cc.CornerRadius = UDim.new(0, 8) cc.Parent = card
    
    local mainLabel = Instance.new("TextLabel")
    mainLabel.Size = UDim2.new(1, -70, 0, 22)
    mainLabel.Position = UDim2.new(0, 12, 0, 8)
    mainLabel.BackgroundTransparency = 1
    mainLabel.Text = titleText
    mainLabel.TextColor3 = THEME.Text
    mainLabel.TextSize = 13
    mainLabel.Font = Enum.Font.GothamBold
    mainLabel.TextXAlignment = Enum.TextXAlignment.Left
    mainLabel.Parent = card

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -70, 0, 18)
    descLabel.Position = UDim2.new(0, 12, 0, 28)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = subText
    descLabel.TextColor3 = THEME.TextMuted
    descLabel.TextSize = 10
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = card

    local toggleBox = Instance.new("Frame")
    toggleBox.Size = UDim2.new(0, 44, 0, 24)
    toggleBox.Position = UDim2.new(1, -56, 0.5, -12)
    toggleBox.BackgroundColor3 = THEME.OffState
    toggleBox.BorderSizePixel = 0
    toggleBox.Parent = card
    local tbc = Instance.new("UICorner") tbc.CornerRadius = UDim.new(0, 12) tbc.Parent = toggleBox

    local toggleDot = Instance.new("Frame")
    toggleDot.Size = UDim2.new(0, 16, 0, 16)
    toggleDot.Position = UDim2.new(0, 4, 0.5, -8)
    toggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleDot.BorderSizePixel = 0
    toggleDot.Parent = toggleBox
    local tdc = Instance.new("UICorner") tdc.CornerRadius = UDim.new(0, 8) tdc.Parent = toggleDot

    local interceptor = Instance.new("TextButton")
    interceptor.Size = UDim2.new(1, 0, 1, 0)
    interceptor.BackgroundTransparency = 1
    interceptor.Text = ""
    interceptor.ZIndex = 5
    interceptor.Parent = card

    return toggleBox, toggleDot, interceptor
end

-- Generate Requested Modules
local _, TeleportWinTrigger       = buildFeatureButton("Instant Teleport", "Warp directly to objective button", 2)
local _, DeleteTowerTrigger       = buildFeatureButton("Delete Tower", "Completely destroy the main tower model", 3)
local _, TeleportDestroyerTrigger = buildFeatureButton("Teleport the Destroyer", "Warp straight to the Shooter Panel Add", 4)

local SpeedInput = buildValueInput("WalkSpeed Modification", "16", 5)
local JumpInput  = buildValueInput("JumpPower Modification", "50", 6)

local InfToggleBox, InfToggleDot, InfJumpTrigger = buildToggleRow("Infinite Jump", "Toggle seamless multi-air jumps", 7)

-- Status Bar Footer
local StatusBar = Instance.new("TextLabel")
StatusBar.Size = UDim2.new(1, -28, 0, 20)
StatusBar.Position = UDim2.new(0, 14, 1, -54)
StatusBar.BackgroundTransparency = 1
StatusBar.Text = "System Status: Ready"
StatusBar.TextColor3 = THEME.TextMuted
StatusBar.TextSize = 11
StatusBar.Font = Enum.Font.GothamMedium
StatusBar.TextXAlignment = Enum.TextXAlignment.Left
StatusBar.Parent = MainWindow

-- Bottom Attribution Frame
local Attribution = Instance.new("TextLabel")
Attribution.Size = UDim2.new(1, -28, 0, 20)
Attribution.Position = UDim2.new(0, 14, 1, -26)
Attribution.BackgroundTransparency = 1
Attribution.Text = "Crossplay Framework • Mobile Input Channel Enabled"
Attribution.TextColor3 = THEME.OffState
Attribution.TextSize = 10
Attribution.Font = Enum.Font.GothamMedium
Attribution.TextXAlignment = Enum.TextXAlignment.Left
Attribution.Parent = MainWindow

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
            StatusBar.Text = "System Status: Ready"
            StatusBar.TextColor3 = THEME.TextMuted
        end
    end)
end

-- Close Button
registerUniversalTap(CloseBtn, function()
    ScreenGui:Destroy()
end)

-- ─── Feature Executions ───

-- Helper function to fetch safe character reference
local function getHRP()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Helper validation function to confirm player belongs to Towers team
local function verifyTowersTeam()
    local myTeam = player.Team
    if myTeam and myTeam.Name == "Towers" then
        return true
    end
    pushStatus("Action Blocked: Must be on Towers team", true)
    return false
end

-- 1. Original Objective Teleport
registerUniversalTap(TeleportWinTrigger, function()
    if not verifyTowersTeam() then return end
    
    local root = getHRP()
    local obj = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Classic") and workspace.Map.Classic:FindFirstChild("Button")
    if root and obj and obj:IsA("BasePart") then
        root.CFrame = obj.CFrame * CFrame.new(0, 3, 0)
        pushStatus("Warped to button objective.", false)
    else
        pushStatus("Target element not found.", true)
    end
end)

-- 2. Delete Tower
registerUniversalTap(DeleteTowerTrigger, function()
    local targetTower = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Classic") and workspace.Map.Classic:FindFirstChild("Tower")
    if targetTower then
        targetTower:Destroy()
        pushStatus("Tower model successfully expunged.", false)
    else
        pushStatus("Tower target location missing or already deleted.", true)
    end
end)

-- 3. Teleport to Shooter Control Panel Add
registerUniversalTap(TeleportDestroyerTrigger, function()
    if not verifyTowersTeam() then return end

    local root = getHRP()
    local map = workspace:FindFirstChild("Map")
    local classic = map and map:FindFirstChild("Classic")
    local shooter = classic and classic:FindFirstChild("Shooter")
    local panel = shooter and shooter:FindFirstChild("ControlPannel")
    local speed = panel and panel:FindFirstChild("Speed")
    local targetAdd = speed and speed:FindFirstChild("Add")

    if root and targetAdd and targetAdd:IsA("BasePart") then
        root.CFrame = targetAdd.CFrame * CFrame.new(0, 3, 0)
        pushStatus("Warped to Control Panel Speed Add.", false)
    else
        pushStatus("Target Shooter Add asset missing.", true)
    end
end)

-- 4 & 5. Speed & Jump Attribute Textbox Focus Engine
SpeedInput.FocusLost:Connect(function(enterPressed)
    local val = tonumber(SpeedInput.Text)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and val then
        hum.WalkSpeed = val
        pushStatus("WalkSpeed calibrated to: " .. val, false)
    end
end)

JumpInput.FocusLost:Connect(function(enterPressed)
    local val = tonumber(JumpInput.Text)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and val then
        hum.UseJumpPower = true
        hum.JumpPower = val
        pushStatus("JumpPower calibrated to: " .. val, false)
    end
end)

-- 6. Infinite Jump Toggle Element Architecture
local infJumpActive = false
local jumpConnection = nil

registerUniversalTap(InfJumpTrigger, function()
    if not infJumpActive then
        infJumpActive = true
        pushStatus("Infinite jump enabled.", false)
        
        TweenService:Create(InfToggleBox, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = THEME.Accent}):Play()
        TweenService:Create(InfToggleDot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 0.5, -8)}):Play()
        
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        infJumpActive = false
        pushStatus("Infinite jump deactivated.", false)
        
        TweenService:Create(InfToggleBox, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = THEME.OffState}):Play()
        TweenService:Create(InfToggleDot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 4, 0.5, -8)}):Play()
        
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
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

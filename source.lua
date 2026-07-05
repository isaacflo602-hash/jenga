--[[
    Rebuilt UI Panel 
    Optimized Flat Input Architecture for Mobile & PC
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ─── Color Palette ───
local COLORS = {
    BG          = Color3.fromRGB(18, 18, 32),
    TITLE_BAR   = Color3.fromRGB(12, 12, 24),
    TAB_BAR     = Color3.fromRGB(25, 25, 48),
    TAB_ACTIVE  = Color3.fromRGB(88, 101, 242),
    ACCENT      = Color3.fromRGB(88, 101, 242),
    ACCENT_HOVER= Color3.fromRGB(110, 120, 255),
    TEXT        = Color3.fromRGB(240, 240, 255),
    TEXT_DIM    = Color3.fromRGB(160, 160, 190),
    EXIT        = Color3.fromRGB(239, 68, 68),
    MINIMIZE    = Color3.fromRGB(250, 204, 21),
    FULLSCREEN  = Color3.fromRGB(34, 197, 94),
    GREEN       = Color3.fromRGB(34, 197, 94),
    RED         = Color3.fromRGB(239, 68, 68),
    GRAY        = Color3.fromRGB(107, 114, 128),
    TOGGLE_OFF  = Color3.fromRGB(55, 55, 85),
    TOGGLE_ON   = Color3.fromRGB(88, 101, 242),
}

-- ─── Core UI Setup ───
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui

local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(0, 520, 0, 420)
Shadow.Position = UDim2.new(0.5, -260, 0.5, -210)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.6
Shadow.BorderSizePixel = 0
Shadow.Parent = ScreenGui
local sc = Instance.new("UICorner") sc.CornerRadius = UDim.new(0, 16) sc.Parent = Shadow

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = COLORS.BG
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
local mc = Instance.new("UICorner") mc.CornerRadius = UDim.new(0, 12) mc.Parent = MainFrame
local ms = Instance.new("UIStroke") ms.Color = Color3.fromRGB(60, 60, 100) ms.Thickness = 1 ms.Parent = MainFrame

-- ─── Header Elements ───
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = COLORS.TITLE_BAR
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
local tc = Instance.new("UICorner") tc.CornerRadius = UDim.new(0, 12) tc.Parent = TitleBar

local TitleBarCover = Instance.new("Frame")
TitleBarCover.Size = UDim2.new(1, 0, 0, 14)
TitleBarCover.Position = UDim2.new(0, 0, 1, -14)
TitleBarCover.BackgroundColor3 = COLORS.TITLE_BAR
TitleBarCover.BorderSizePixel = 0
TitleBarCover.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚙  Main Panel"
TitleLabel.TextColor3 = COLORS.TEXT
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Window Controls Helper
local function createHeaderBtn(name, text, color, xOffset)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 36, 0, 24)
    btn.Position = UDim2.new(1, xOffset, 0.5, -12)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = TitleBar
    local cc = Instance.new("UICorner") cc.CornerRadius = UDim.new(0, 6) cc.Parent = btn
    return btn
end

local ExitBtn      = createHeaderBtn("ExitBtn",      "✕",  COLORS.EXIT,      -44)
local FullscreenBtn = createHeaderBtn("FullscreenBtn", "⛶",  COLORS.FULLSCREEN, -88)
local MinimizeBtn   = createHeaderBtn("MinimizeBtn",   "—",  COLORS.MINIMIZE,   -132)

-- ─── Navigation/Tab Setup ───
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, 0, 0, 42)
TabBar.Position = UDim2.new(0, 0, 0, 42)
TabBar.BackgroundColor3 = COLORS.TAB_BAR
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabLabel = Instance.new("TextLabel")
TabLabel.Size = UDim2.new(0, 150, 1, 0)
TabLabel.Position = UDim2.new(0, 16, 0, 0)
TabLabel.BackgroundTransparency = 1
TabLabel.Text = "main"
TabLabel.TextColor3 = COLORS.TEXT
TabLabel.TextSize = 14
TabLabel.Font = Enum.Font.GothamSemibold
TabLabel.TextXAlignment = Enum.TextXAlignment.Left
TabLabel.Parent = TabBar

local TabIndicator = Instance.new("Frame")
TabIndicator.Size = UDim2.new(0, 60, 0, 3)
TabIndicator.Position = UDim2.new(0, 16, 1, -3)
TabIndicator.BackgroundColor3 = COLORS.ACCENT
TabIndicator.BorderSizePixel = 0
TabIndicator.Parent = TabBar

-- ─── Dynamic Content Frame ───
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -32, 1, -110)
ContentFrame.Position = UDim2.new(0, 16, 0, 95)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.Parent = ContentFrame

-- Section Label
local SecHeader = Instance.new("TextLabel")
SecHeader.Size = UDim2.new(1, 0, 0, 20)
SecHeader.BackgroundTransparency = 1
SecHeader.Text = "Quick Actions"
SecHeader.TextColor3 = COLORS.TEXT_DIM
SecHeader.TextSize = 12
SecHeader.Font = Enum.Font.GothamBold
SecHeader.TextXAlignment = Enum.TextXAlignment.Left
SecHeader.LayoutOrder = 1
SecHeader.Parent = ContentFrame

-- ─── Card Builder Function ───
local function createContainerCard(title, desc, order)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 56)
    card.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.Parent = ContentFrame
    local cardCorner = Instance.new("UICorner") cardCorner.CornerRadius = UDim.new(0, 10) cardCorner.Parent = card

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -120, 0, 22)
    lbl.Position = UDim2.new(0, 16, 0, 8)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = COLORS.TEXT
    lbl.TextSize = 15
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = card

    local dsc = Instance.new("TextLabel")
    dsc.Size = UDim2.new(1, -120, 0, 18)
    dsc.Position = UDim2.new(0, 16, 0, 30)
    dsc.BackgroundTransparency = 1
    dsc.Text = desc
    dsc.TextColor3 = COLORS.TEXT_DIM
    dsc.TextSize = 11
    dsc.Font = Enum.Font.Gotham
    dsc.TextXAlignment = Enum.TextXAlignment.Left
    dsc.Parent = card

    local targetBtn = Instance.new("TextButton")
    targetBtn.Size = UDim2.new(0, 90, 0, 36)
    targetBtn.Position = UDim2.new(1, -106, 0.5, -18)
    targetBtn.BorderSizePixel = 0
    targetBtn.AutoButtonColor = false
    targetBtn.Font = Enum.Font.GothamBold
    targetBtn.TextSize = 13
    targetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    targetBtn.Parent = card
    local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(0, 8) btnCorner.Parent = targetBtn

    return targetBtn
end

local InstantWinBtn = createContainerCard("Instant Win", "Teleport to the win button", 2)
InstantWinBtn.BackgroundColor3 = COLORS.ACCENT
InstantWinBtn.Text = "Go"

local KillToggle = createContainerCard("Disable Kill Brick", "Remove kill brick code & touch", 3)
KillToggle.BackgroundColor3 = COLORS.TOGGLE_OFF
KillToggle.Text = "Disabled"

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 24)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = COLORS.TEXT_DIM
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.LayoutOrder = 4
StatusLabel.Parent = ContentFrame

-- ─── Bulletproof Global Universal Logic Engine ───
local function bindCrossPlatformTap(guiObject, callback)
    -- Fire via Engine Click Event
    guiObject.MouseButton1Click:Connect(callback)
    -- Fire via Dedicated Mobile Touch Event
    guiObject.TouchTap:Connect(callback)
end

local function showStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color
    task.delay(3, function()
        if StatusLabel.Text == text then
            StatusLabel.Text = ""
        end
    end)
end

-- Teleport Sequence
bindCrossPlatformTap(InstantWinBtn, function()
    local team = player.Team
    if team and team.Name == "Towers" then
        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        local mapFolder = workspace:FindFirstChild("Map")
        local classicFolder = mapFolder and mapFolder:FindFirstChild("Classic")
        local targetButton = classicFolder and classicFolder:FindFirstChild("Button")

        if hrp and targetButton then
            hrp.CFrame = targetButton.CFrame + Vector3.new(0, 3, 0)
            showStatus("Teleported!", COLORS.GREEN)
        else
            showStatus("Error: Map elements missing", COLORS.RED)
        end
    else
        showStatus("Error: Wrong team requirement", COLORS.RED)
    end
end)

-- Kill Brick Modification Sequence
local killBrickToggleOn = false
local savedCanCollide = nil

local function executeToggle()
    killBrickToggleOn = not killBrickToggleOn
    local mapFolder = workspace:FindFirstChild("Map")
    local classicFolder = mapFolder and mapFolder:FindFirstChild("Classic")
    local killBrick = classicFolder and classicFolder:FindFirstChild("KillBrick")

    if killBrickToggleOn then
        if killBrick then
            local code = killBrick:FindFirstChild("Code")
            if code and code:IsA("Script") then code.Disabled = true end

            local touchInterest = killBrick:FindFirstChild("TouchInterest")
            if touchInterest then touchInterest.Parent = nil end

            if killBrick:IsA("BasePart") then
                savedCanCollide = killBrick.CanCollide
                killBrick.CanCollide = true
            end
        end
        KillToggle.Text = "Enabled"
        KillToggle.BackgroundColor3 = COLORS.TOGGLE_ON
    else
        if killBrick then
            local code = killBrick:FindFirstChild("Code")
            if code and code:IsA("Script") then code.Disabled = false end

            if killBrick:IsA("BasePart") and savedCanCollide ~= nil then
                killBrick.CanCollide = savedCanCollide
                savedCanCollide = nil
            end
        end
        KillToggle.Text = "Disabled"
        KillToggle.BackgroundColor3 = COLORS.TOGGLE_OFF
    end
end

bindCrossPlatformTap(KillToggle, executeToggle)

-- ─── System Controls & Frame Adjustments ───
local windowDragging = false
local dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        windowDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if windowDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        MainFrame.Position = newPos
        Shadow.Position = newPos + UDim2.new(0, -10, 0, -10)
    end
end)

local function clearDrag() windowDragging = false end
TitleBar.InputEnded:Connect(clearDrag)
game:GetService("UserInputService").InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then clearDrag() end
end)

-- Window Operations
bindCrossPlatformTap(ExitBtn, function() ScreenGui:Destroy() end)

local minimized = false
bindCrossPlatformTap(MinimizeBtn, function()
    minimized = not minimized
    ContentFrame.Visible = not minimized
    TabBar.Visible = not minimized
    MainFrame.Size = minimized and UDim2.new(0, 500, 0, 42) or UDim2.new(0, 500, 0, 400)
    Shadow.Size = minimized and UDim2.new(0, 520, 0, 62) or UDim2.new(0, 520, 0, 420)
end)

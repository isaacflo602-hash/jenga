--[[
    Main Panel
    Features: Instant Win button, Minimize/Fullscreen/Exit with confirmation
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
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

-- ─── Helper Functions ───
local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function addStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function addPadding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, top)
    p.PaddingBottom = UDim.new(0, bottom)
    p.PaddingLeft = UDim.new(0, left)
    p.PaddingRight = UDim.new(0, right)
    p.Parent = parent
    return p
end

-- ─── Create ScreenGui ───
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui

-- ─── Shadow Frame ───
local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(0, 520, 0, 420)
Shadow.Position = UDim2.new(0.5, -260, 0.5, -210)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.6
Shadow.BorderSizePixel = 0
Shadow.Parent = ScreenGui
addCorner(Shadow, 16)

-- ─── Main Frame ───
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = COLORS.BG
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
addCorner(MainFrame, 12)
addStroke(MainFrame, Color3.fromRGB(60, 60, 100), 1)

-- ─── Title Bar ───
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = COLORS.TITLE_BAR
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
addCorner(TitleBar, 12)

-- Cover bottom corners of title bar
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

-- ─── Window Control Buttons ───
local function createWindowBtn(name, text, color, xPos)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 36, 0, 24)
    btn.Position = UDim2.new(1, xPos, 0.5, -12)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = TitleBar
    addCorner(btn, 6)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(
            math.min(255, select(1, color.R*255)*1.2),
            math.min(255, select(2, color.G*255)*1.2),
            math.min(255, select(3, color.B*255)*1.2)
        )}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
    end)
    return btn
end

local ExitBtn      = createWindowBtn("ExitBtn",      "✕",  COLORS.EXIT,      -44)
local FullscreenBtn = createWindowBtn("FullscreenBtn", "⛶",  COLORS.FULLSCREEN, -88)
local MinimizeBtn   = createWindowBtn("MinimizeBtn",   "—",  COLORS.MINIMIZE,   -132)

-- ─── Tab Bar (Horizontal Sliding) ───
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, 0, 0, 42)
TabBar.Position = UDim2.new(0, 0, 0, 42)
TabBar.BackgroundColor3 = COLORS.TAB_BAR
TabBar.BorderSizePixel = 0
TabBar.ClipsDescendants = true
TabBar.Parent = MainFrame

-- Left arrow button
local LeftArrow = Instance.new("TextButton")
LeftArrow.Name = "LeftArrow"
LeftArrow.Size = UDim2.new(0, 28, 1, 0)
LeftArrow.Position = UDim2.new(0, 0, 0, 0)
LeftArrow.BackgroundColor3 = Color3.fromRGB(20, 20, 42)
LeftArrow.Text = "‹"
LeftArrow.TextColor3 = COLORS.TEXT
LeftArrow.TextSize = 18
LeftArrow.Font = Enum.Font.GothamBold
LeftArrow.BorderSizePixel = 0
LeftArrow.AutoButtonColor = false
LeftArrow.ZIndex = 5
LeftArrow.Parent = TabBar
addCorner(LeftArrow, 0)

-- Right arrow button
local RightArrow = Instance.new("TextButton")
RightArrow.Name = "RightArrow"
RightArrow.Size = UDim2.new(0, 28, 1, 0)
RightArrow.Position = UDim2.new(1, -28, 0, 0)
RightArrow.BackgroundColor3 = Color3.fromRGB(20, 20, 42)
RightArrow.Text = "›"
RightArrow.TextColor3 = COLORS.TEXT
RightArrow.TextSize = 18
RightArrow.Font = Enum.Font.GothamBold
RightArrow.BorderSizePixel = 0
RightArrow.AutoButtonColor = false
RightArrow.ZIndex = 5
RightArrow.Parent = TabBar
addCorner(RightArrow, 0)

-- Active tab indicator
local TabIndicator = Instance.new("Frame")
TabIndicator.Name = "TabIndicator"
TabIndicator.Size = UDim2.new(0, 150, 0, 3)
TabIndicator.Position = UDim2.new(0, 34, 1, -3)
TabIndicator.BackgroundColor3 = COLORS.ACCENT
TabIndicator.BorderSizePixel = 0
TabIndicator.ZIndex = 6
TabIndicator.Parent = TabBar
addCorner(TabIndicator, 2)

-- ScrollingFrame for horizontal sliding tabs
local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Name = "TabScroll"
TabScroll.Size = UDim2.new(1, -56, 1, 0)
TabScroll.Position = UDim2.new(0, 28, 0, 0)
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.ScrollBarThickness = 0
TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
TabScroll.ElasticBehavior = Enum.ElasticBehavior.Always
TabScroll.ZIndex = 3
TabScroll.Parent = TabBar

local TabList = Instance.new("UIListLayout")
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 6)
TabList.Parent = TabScroll
addPadding(TabScroll, 6, 6, 6, 6)

local tabNames = {"main"}
local tabButtons = {}

for i, name in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "Tab"
    tabBtn.Size = UDim2.new(0, 150, 1, -12)
    tabBtn.BackgroundColor3 = (i == 1) and COLORS.TAB_ACTIVE or COLORS.TAB_BAR
    tabBtn.Text = name
    tabBtn.TextColor3 = COLORS.TEXT
    tabBtn.TextSize = 13
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.BorderSizePixel = 0
    tabBtn.AutoButtonColor = false
    tabBtn.LayoutOrder = i
    tabBtn.ZIndex = 4
    tabBtn.Parent = TabScroll
    addCorner(tabBtn, 8)
    tabButtons[i] = tabBtn
end

-- ─── Content Area ───
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -24, 1, -100)
ContentFrame.Position = UDim2.new(0, 12, 0, 90)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

-- ═══════════════════════════════════════════════════════════
-- TAB: MAIN (Instant Win)
-- ═══════════════════════════════════════════════════════════
local MainTab = Instance.new("ScrollingFrame")
MainTab.Name = "MainTab"
MainTab.Size = UDim2.new(1, 0, 1, 0)
MainTab.BackgroundTransparency = 1
MainTab.BorderSizePixel = 0
MainTab.ScrollBarThickness = 4
MainTab.ScrollBarImageColor3 = COLORS.ACCENT
MainTab.CanvasSize = UDim2.new(0, 0, 0, 0)
MainTab.AutomaticCanvasSize = Enum.AutomaticSize.Y
MainTab.Visible = true
MainTab.Selectable = false -- Prevents swallowing focus over elements inside
MainTab.Parent = ContentFrame

local MainLayout = Instance.new("UIListLayout")
MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
MainLayout.Padding = UDim.new(0, 10)
MainLayout.Parent = MainTab
addPadding(MainTab, 4, 4, 0, 0)

-- Section header
local SectionLabel = Instance.new("TextLabel")
SectionLabel.Size = UDim2.new(1, 0, 0, 20)
SectionLabel.BackgroundTransparency = 1
SectionLabel.Text = "Quick Actions"
SectionLabel.TextColor3 = COLORS.TEXT_DIM
SectionLabel.TextSize = 12
SectionLabel.Font = Enum.Font.GothamBold
SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
SectionLabel.LayoutOrder = 1
SectionLabel.Parent = MainTab

-- Action card
local ActionCard = Instance.new("Frame")
ActionCard.Name = "ActionCard"
ActionCard.Size = UDim2.new(1, 0, 0, 52)
ActionCard.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
ActionCard.BorderSizePixel = 0
ActionCard.LayoutOrder = 2
ActionCard.Parent = MainTab
addCorner(ActionCard, 10)
addPadding(ActionCard, 8, 8, 14, 14)

-- Card label
local CardLabel = Instance.new("TextLabel")
CardLabel.Size = UDim2.new(1, -110, 1, 0)
CardLabel.BackgroundTransparency = 1
CardLabel.Text = "Instant Win"
CardLabel.TextColor3 = COLORS.TEXT
CardLabel.TextSize = 15
CardLabel.Font = Enum.Font.GothamSemibold
CardLabel.TextXAlignment = Enum.TextXAlignment.Left
CardLabel.Parent = ActionCard

-- Card description (smaller text under the label)
local CardDesc = Instance.new("TextLabel")
CardDesc.Size = UDim2.new(1, -110, 0, 16)
CardDesc.Position = UDim2.new(0, 0, 1, -16)
CardDesc.BackgroundTransparency = 1
CardDesc.Text = "Teleport to the win button"
CardDesc.TextColor3 = COLORS.TEXT_DIM
CardDesc.TextSize = 11
CardDesc.Font = Enum.Font.Gotham
CardDesc.TextXAlignment = Enum.TextXAlignment.Left
CardDesc.Parent = ActionCard

-- Instant Win Button (right side of card)
local InstantWinBtn = Instance.new("TextButton")
InstantWinBtn.Name = "InstantWinBtn"
InstantWinBtn.Size = UDim2.new(0, 90, 0, 34)
InstantWinBtn.Position = UDim2.new(1, -90, 0.5, -17)
InstantWinBtn.BackgroundColor3 = COLORS.ACCENT
InstantWinBtn.Text = "Go"
InstantWinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InstantWinBtn.TextSize = 14
InstantWinBtn.Font = Enum.Font.GothamBold
InstantWinBtn.BorderSizePixel = 0
InstantWinBtn.AutoButtonColor = false
InstantWinBtn.Active = true
InstantWinBtn.Parent = ActionCard
addCorner(InstantWinBtn, 8)

-- Toggle card
local ToggleCard = Instance.new("Frame")
ToggleCard.Name = "ToggleCard"
ToggleCard.Size = UDim2.new(1, 0, 0, 52)
ToggleCard.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
ToggleCard.BorderSizePixel = 0
ToggleCard.LayoutOrder = 3
ToggleCard.Parent = MainTab
addCorner(ToggleCard, 10)
addPadding(ToggleCard, 8, 8, 14, 14)

-- Toggle card label
local ToggleCardLabel = Instance.new("TextLabel")
ToggleCardLabel.Size = UDim2.new(1, -70, 1, 0)
ToggleCardLabel.BackgroundTransparency = 1
ToggleCardLabel.Text = "Disable Kill Brick"
ToggleCardLabel.TextColor3 = COLORS.TEXT
ToggleCardLabel.TextSize = 15
ToggleCardLabel.Font = Enum.Font.GothamSemibold
ToggleCardLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleCardLabel.Parent = ToggleCard

-- Toggle card description
local ToggleCardDesc = Instance.new("TextLabel")
ToggleCardDesc.Size = UDim2.new(1, -70, 0, 16)
ToggleCardDesc.Position = UDim2.new(0, 0, 1, -16)
ToggleCardDesc.BackgroundTransparency = 1
ToggleCardDesc.Text = "Remove kill brick code & touch"
ToggleCardDesc.TextColor3 = COLORS.TEXT_DIM
ToggleCardDesc.TextSize = 11
ToggleCardDesc.Font = Enum.Font.Gotham
ToggleCardDesc.TextXAlignment = Enum.TextXAlignment.Left
ToggleCardDesc.Parent = ToggleCard

-- Toggle button
local KillToggle = Instance.new("TextButton")
KillToggle.Name = "KillToggle"
KillToggle.Size = UDim2.new(0, 90, 0, 34)
KillToggle.Position = UDim2.new(1, -90, 0.5, -17)
KillToggle.BackgroundColor3 = COLORS.TOGGLE_OFF
KillToggle.Text = "Disabled"
KillToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
KillToggle.TextSize = 13
KillToggle.Font = Enum.Font.GothamBold
KillToggle.BorderSizePixel = 0
KillToggle.AutoButtonColor = false
KillToggle.Active = true -- Key property optimization for mobile interaction
KillToggle.Parent = ToggleCard
addCorner(KillToggle, 8)

-- Status label for error/success messages
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 24)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = COLORS.TEXT_DIM
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.LayoutOrder = 4
StatusLabel.Parent = MainTab

-- Hover effects for Instant Win button
InstantWinBtn.MouseEnter:Connect(function()
    TweenService:Create(InstantWinBtn, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.ACCENT_HOVER}):Play()
end)
InstantWinBtn.MouseLeave:Connect(function()
    TweenService:Create(InstantWinBtn, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.ACCENT}):Play()
end)

-- ═══════════════════════════════════════════════════════════
-- INTERACTION LOGIC
-- ═══════════════════════════════════════════════════════════

-- ─── Tab Switching ───
local tabs = {MainTab}
local activeTabIndex = 1

local function slideToTab(index)
    activeTabIndex = index
    local btn = tabButtons[index]
    if not btn then return end

    for j, tab in ipairs(tabs) do
        tab.Visible = (j == index)
        tabButtons[j].BackgroundColor3 = (j == index) and COLORS.TAB_ACTIVE or COLORS.TAB_BAR
    end

    local indicatorX = btn.AbsolutePosition.X - TabBar.AbsolutePosition.X + (btn.AbsoluteSize.X - TabIndicator.AbsoluteSize.X) / 2
    TweenService:Create(TabIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, indicatorX, 1, -3)
    }):Play()

    local tabCenterX = btn.AbsolutePosition.X - TabScroll.AbsolutePosition.X + btn.AbsoluteSize.X / 2
    local targetScroll = math.clamp(tabCenterX - TabScroll.AbsoluteSize.X / 2, 0, math.max(0, TabScroll.CanvasSize.X.Offset - TabScroll.AbsoluteSize.X))
    TweenService:Create(TabScroll, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        CanvasPosition = Vector2.new(targetScroll, 0)
    }):Play()
end

for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        slideToTab(i)
    end)
end

LeftArrow.MouseButton1Click:Connect(function()
    local newIndex = math.max(1, activeTabIndex - 1)
    slideToTab(newIndex)
end)

RightArrow.MouseButton1Click:Connect(function()
    local newIndex = math.min(#tabNames, activeTabIndex + 1)
    slideToTab(newIndex)
end)

-- Update indicator position after render
local function updateIndicator()
    local btn = tabButtons[activeTabIndex]
    if btn and btn.AbsoluteSize.X > 0 then
        local indicatorX = btn.AbsolutePosition.X - TabBar.AbsolutePosition.X + (btn.AbsoluteSize.X - TabIndicator.AbsoluteSize.X) / 2
        TabIndicator.Position = UDim2.new(0, indicatorX, 1, -3)
    end
end

task.defer(function()
    task.wait(0.1)
    updateIndicator()
end)

-- ─── Instant Win Button Logic ───
local function showStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color
    task.delay(3, function()
        if StatusLabel.Text == text then
            StatusLabel.Text = ""
        end
    end)
end

InstantWinBtn.Activated:Connect(function()
    local team = player.Team
    if team and team.Name == "Towers" then
        local character = player.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local mapFolder = workspace:FindFirstChild("Map")
            local classicFolder = mapFolder and mapFolder:FindFirstChild("Classic")
            local targetButton = classicFolder and classicFolder:FindFirstChild("Button")
            if hrp and targetButton then
                hrp.CFrame = targetButton.CFrame + Vector3.new(0, 3, 0)
                showStatus("Teleported!", COLORS.GREEN)
            else
                showStatus("error", COLORS.RED)
            end
        else
            showStatus("error", COLORS.RED)
        end
    else
        showStatus("error", COLORS.RED)
    end
end)

-- ─── Kill Brick Toggle Logic ───
local killBrickToggleOn = false
local savedCanCollide = nil
local lastToggleTime = 0

local function toggleKillBrick()
    local now = tick()
    if now - lastToggleTime < 0.3 then return end
    lastToggleTime = now

    killBrickToggleOn = not killBrickToggleOn

    local mapFolder = workspace:FindFirstChild("Map")
    local classicFolder = mapFolder and mapFolder:FindFirstChild("Classic")
    local killBrick = classicFolder and classicFolder:FindFirstChild("KillBrick")

    if killBrickToggleOn then
        if killBrick then
            -- Disable the Code script
            local code = killBrick:FindFirstChild("Code")
            if code and code:IsA("Script") then
                code.Disabled = true
            end

            -- Remove TouchInterest
            local touchInterest = killBrick:FindFirstChild("TouchInterest")
            if touchInterest then
                touchInterest.Parent = nil
            end

            -- Make KillBrick collidable (solid block)
            if killBrick:IsA("BasePart") then
                savedCanCollide = killBrick.CanCollide
                killBrick.CanCollide = true
            end
        end

        -- Update button visual
        KillToggle.Text = "Enabled"
        TweenService:Create(KillToggle, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.TOGGLE_ON}):Play()
    else
        if killBrick then
            -- Re-enable the Code script
            local code = killBrick:FindFirstChild("Code")
            if code and code:IsA("Script") then
                code.Disabled = false
            end

            -- Restore CanCollide
            if killBrick:IsA("BasePart") and savedCanCollide ~= nil then
                killBrick.CanCollide = savedCanCollide
                savedCanCollide = nil
            end
        end

        -- Update button visual
        KillToggle.Text = "Disabled"
        TweenService:Create(KillToggle, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.TOGGLE_OFF}):Play()
    end
end

-- Fire logic uniformly across all devices (Desktop click & Mobile touch tap)
KillToggle.Activated:Connect(toggleKillBrick)


-- ─── Window State ───
local isMinimized = false
local isFullscreen = false
local normalSize = MainFrame.Size
local normalPos = MainFrame.Position

local function syncShadow()
    Shadow.Size = MainFrame.Size + UDim2.new(0, 20, 0, 20)
    Shadow.Position = MainFrame.Position + UDim2.new(0, -10, 0, -10)
end

-- ─── Minimize ───
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        if not isFullscreen then
            normalSize = MainFrame.Size
            normalPos = MainFrame.Position
        end
        ContentFrame.Visible = false
        TabBar.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 300, 0, 42)
        }):Play()
        TweenService:Create(Shadow, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 310, 0, 52)
        }):Play()
    else
        ContentFrame.Visible = true
        TabBar.Visible = true
        if isFullscreen then
            local fs = UDim2.new(0.9, 0, 0.85, 0)
            local fp = UDim2.new(0.05, 0, 0.075, 0)
            TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                Size = fs, Position = fp,
            }):Play()
            TweenService:Create(Shadow, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                Size = fs + UDim2.new(0, 20, 0, 20),
                Position = fp + UDim2.new(0, -10, 0, -10),
            }):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                Size = normalSize, Position = normalPos,
            }):Play()
            TweenService:Create(Shadow, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                Size = normalSize + UDim2.new(0, 20, 0, 20),
                Position = normalPos + UDim2.new(0, -10, 0, -10),
            }):Play()
        end
    end
end)

-- ─── Fullscreen ───
FullscreenBtn.MouseButton1Click:Connect(function()
    isFullscreen = not isFullscreen
    if isFullscreen then
        if not isMinimized then
            normalSize = MainFrame.Size
            normalPos = MainFrame.Position
        end
        local fs = UDim2.new(0.9, 0, 0.85, 0)
        local fp = UDim2.new(0.05, 0, 0.075, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = fs, Position = fp,
        }):Play()
        TweenService:Create(Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = fs + UDim2.new(0, 20, 0, 20),
            Position = fp + UDim2.new(0, -10, 0, -10),
        }):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = normalSize, Position = normalPos,
        }):Play()
        TweenService:Create(Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = normalSize + UDim2.new(0, 20, 0, 20),
            Position = normalPos + UDim2.new(0, -10, 0, -10),
        }):Play()
    end
end)

-- ─── Exit Confirmation Dialog ───
local ConfirmOverlay = Instance.new("Frame")
ConfirmOverlay.Name = "ConfirmOverlay"
ConfirmOverlay.Size = UDim2.new(1, 0, 1, 0)
ConfirmOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ConfirmOverlay.BackgroundTransparency = 0.5
ConfirmOverlay.BorderSizePixel = 0
ConfirmOverlay.ZIndex = 50
ConfirmOverlay.Visible = false
ConfirmOverlay.Parent = ScreenGui

local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Name = "ConfirmFrame"
ConfirmFrame.Size = UDim2.new(0, 300, 0, 160)
ConfirmFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
ConfirmFrame.BackgroundColor3 = COLORS.BG
ConfirmFrame.BorderSizePixel = 0
ConfirmFrame.ZIndex = 51
ConfirmFrame.Parent = ConfirmOverlay
addCorner(ConfirmFrame, 12)
addStroke(ConfirmFrame, Color3.fromRGB(60, 60, 100), 1)

local ConfirmLabel = Instance.new("TextLabel")
ConfirmLabel.Size = UDim2.new(1, -24, 0, 60)
ConfirmLabel.Position = UDim2.new(0, 12, 0, 16)
ConfirmLabel.BackgroundTransparency = 1
ConfirmLabel.Text = "Are you sure you want\nto unload this script?"
ConfirmLabel.TextColor3 = COLORS.TEXT
ConfirmLabel.TextSize = 15
ConfirmLabel.Font = Enum.Font.GothamSemibold
ConfirmLabel.ZIndex = 52
ConfirmLabel.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Name = "YesBtn"
YesBtn.Size = UDim2.new(0, 120, 0, 38)
YesBtn.Position = UDim2.new(0, 20, 1, -54)
YesBtn.BackgroundColor3 = COLORS.RED
YesBtn.Text = "Yes"
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.TextSize = 14
YesBtn.Font = Enum.Font.GothamBold
YesBtn.BorderSizePixel = 0
YesBtn.AutoButtonColor = false
YesBtn.ZIndex = 52
YesBtn.Parent = ConfirmFrame
addCorner(YesBtn, 8)

local NoBtn = Instance.new("TextButton")
NoBtn.Name = "NoBtn"
NoBtn.Size = UDim2.new(0, 120, 0, 38)
NoBtn.Position = UDim2.new(1, -140, 1, -54)
NoBtn.BackgroundColor3 = COLORS.GRAY
NoBtn.Text = "No"
NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoBtn.TextSize = 14
NoBtn.Font = Enum.Font.GothamBold
NoBtn.BorderSizePixel = 0
NoBtn.AutoButtonColor = false
NoBtn.ZIndex = 52
NoBtn.Parent = ConfirmFrame
addCorner(NoBtn, 8)

YesBtn.MouseEnter:Connect(function()
    TweenService:Create(YesBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
end)
YesBtn.MouseLeave:Connect(function()
    TweenService:Create(YesBtn, TweenInfo.new(0.12), {BackgroundColor3 = COLORS.RED}):Play()
end)
NoBtn.MouseEnter:Connect(function()
    TweenService:Create(NoBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(130, 130, 150)}):Play()
end)
NoBtn.MouseLeave:Connect(function()
    TweenService:Create(NoBtn, TweenInfo.new(0.12), {BackgroundColor3 = COLORS.GRAY}):Play()
end)

YesBtn.MouseButton1Click:Connect(function()
    ConfirmOverlay.Visible = false
    TweenService:Create(MainFrame, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = MainFrame.Position + UDim2.new(0, 250, 0, 200),
    }):Play()
    TweenService:Create(Shadow, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 0, 0, 0),
    }):Play()
    task.wait(0.25)
    ScreenGui:Destroy()
end)

NoBtn.MouseButton1Click:Connect(function()
    ConfirmOverlay.Visible = false
end)

ExitBtn.MouseButton1Click:Connect(function()
    ConfirmOverlay.Visible = true
end)

-- ─── Window Dragging ───
local windowDragging = false
local dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        windowDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        windowDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    local isMove = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch

    if windowDragging and isMove then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        syncShadow()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        windowDragging = false
    end
end)

-- Keep shadow in sync
MainFrame.Changed:Connect(function(prop)
    if prop == "Size" or prop == "Position" then
        syncShadow()
    end
end)

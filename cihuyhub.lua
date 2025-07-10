-- Script to create an optimized "Cihuy Hub" GUI with a modern design and loading screen
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Wait until PlayerGui is ready (crucial for UI LocalScripts)
repeat task.wait() until LocalPlayer.PlayerGui

-- UI Configuration Variables
local MAIN_BG_COLOR = Color3.fromRGB(35, 35, 45) -- Dark bluish-gray for modern look
local ACCENT_COLOR = Color3.fromRGB(50, 100, 200) -- Modern blue accent
local OUTLINE_COLOR = Color3.fromRGB(25, 25, 35) -- Slightly darker outline
local BORDER_RADIUS = 12 -- Corner radius for modern rounded edges
local TEXT_COLOR = Color3.fromRGB(230, 230, 230) -- Light gray for text

local LOADING_SCREEN_DURATION = 2.5 -- Duration of the loading screen in seconds (slightly faster)
local UI_SCALE_FACTOR = 0.7 -- Adjust this for overall UI size on screen (e.g., 0.7 for slightly smaller)

--- Create the Main ScreenGui ---
local cihuyHubGui = Instance.new("ScreenGui")
cihuyHubGui.Name = "CihuyHub_V2" -- Renamed for versioning
cihuyHubGui.Parent = LocalPlayer.PlayerGui

-- Apply overall UI scaling for responsiveness across devices
local uiScale = Instance.new("UIScale")
uiScale.Scale = UI_SCALE_FACTOR
uiScale.Parent = cihuyHubGui

--- Create the Main Container Frame ---
-- This frame will hold both the sidebar and the main content area
local containerFrame = Instance.new("Frame")
containerFrame.Name = "MainContainer"
containerFrame.Size = UDim2.new(0.7, 0, 0.8, 0) -- Slightly smaller overall UI
containerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
containerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
containerFrame.BackgroundColor3 = MAIN_BG_COLOR
containerFrame.BorderSizePixel = 0 -- We'll use UIStroke for borders
containerFrame.Parent = cihuyHubGui

-- Add rounded corners to the main container
local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, BORDER_RADIUS)
containerCorner.Parent = containerFrame

-- Add a subtle inner stroke for a cleaner look
local containerStroke = Instance.new("UIStroke")
containerStroke.Color = OUTLINE_COLOR
containerStroke.Transparency = 0.5 -- Slightly transparent
containerStroke.Thickness = 2
containerStroke.Parent = containerFrame

-- Maintain aspect ratio for the main container
local aspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
aspectRatioConstraint.AspectRatio = containerFrame.AbsoluteSize.X / containerFrame.AbsoluteSize.Y
aspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
aspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
aspectRatioConstraint.Parent = containerFrame

--- Create the Sidebar (Invisible Bar for Tabs) ---
local sidebarFrame = Instance.new("Frame")
sidebarFrame.Name = "Sidebar"
sidebarFrame.Size = UDim2.new(0.25, 0, 1, 0) -- 25% width of container, full height
sidebarFrame.Position = UDim2.new(0, 0, 0, 0) -- Positioned at the left edge of the container
sidebarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40) -- Slightly darker for distinction
sidebarFrame.BorderSizePixel = 0
sidebarFrame.Parent = containerFrame

-- Add rounded corners to the sidebar (only left side if desired, or all)
local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, BORDER_RADIUS)
sidebarCorner.Parent = sidebarFrame

-- Add a separator line between sidebar and main content (visual improvement)
local separatorLine = Instance.new("Frame")
separatorLine.Name = "SeparatorLine"
separatorLine.Size = UDim2.new(0, 2, 1, 0) -- 2 pixels wide, full height
separatorLine.Position = UDim2.new(1, -2, 0, 0) -- Positioned at the right edge of the sidebar
separatorLine.BackgroundColor3 = OUTLINE_COLOR
separatorLine.Parent = sidebarFrame

--- Create the Main Content Area ---
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentArea"
contentFrame.Size = UDim2.new(0.75, 0, 1, 0) -- Remaining 75% width of container, full height
contentFrame.Position = UDim2.new(0.25, 0, 0, 0) -- Positioned right after the sidebar
contentFrame.BackgroundColor3 = MAIN_BG_COLOR -- Same as container for seamless look
contentFrame.BorderSizePixel = 0
contentFrame.Parent = containerFrame

-- Example element in the main content area
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0.5, 0, 0.15, 0)
titleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = ACCENT_COLOR -- Using accent color for title
titleLabel.TextScaled = false -- Don't scale, use specific font size for modern look
titleLabel.TextSize = 32 -- Smaller, fixed text size
titleLabel.Text = "Cihuy Hub Dashboard"
titleLabel.Font = Enum.Font.RobotoMono
titleLabel.Parent = contentFrame

local descriptionLabel = Instance.new("TextLabel")
descriptionLabel.Name = "DescriptionLabel"
descriptionLabel.Size = UDim2.new(0.8, 0, 0.4, 0)
descriptionLabel.Position = UDim2.new(0.5, 0, 0.6, 0)
descriptionLabel.AnchorPoint = Vector2.new(0.5, 0.5)
descriptionLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
descriptionLabel.BackgroundTransparency = 1
descriptionLabel.TextColor3 = TEXT_COLOR
descriptionLabel.TextScaled = false
descriptionLabel.TextSize = 20 -- Smaller text size
descriptionLabel.TextWrap = true -- Allow text to wrap
descriptionLabel.TextXAlignment = Enum.TextXAlignment.Center
descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
descriptionLabel.Text = "Welcome to your experimental Cihuy Hub! This is a modern and advanced UI for your scientific testing and learning."
descriptionLabel.Font = Enum.Font.SourceSans
descriptionLabel.Parent = contentFrame

--- Create and Animate Loading Screen ---
local loadingScreen = Instance.new("Frame")
loadingScreen.Name = "LoadingScreen"
-- Size and position exactly like the main container for a smooth transition
loadingScreen.Size = containerFrame.Size
loadingScreen.Position = containerFrame.Position
loadingScreen.AnchorPoint = containerFrame.AnchorPoint
loadingScreen.BackgroundColor3 = Color3.fromRGB(20, 20, 25) -- Slightly darker than main BG
loadingScreen.Parent = cihuyHubGui

-- Add rounded corners to the loading screen for consistency
local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, BORDER_RADIUS)
loadingCorner.Parent = loadingScreen

-- Loading text (smaller, modern font)
local loadingText = Instance.new("TextLabel")
loadingText.Name = "LoadingText"
loadingText.Size = UDim2.new(0.8, 0, 0.2, 0)
loadingText.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingText.AnchorPoint = Vector2.new(0.5, 0.5)
loadingText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingText.BackgroundTransparency = 1
loadingText.TextColor3 = TEXT_COLOR
loadingText.TextScaled = false
loadingText.TextSize = 24 -- Smaller fixed text size
loadingText.Text = "Initializing Cihuy Hub..."
loadingText.Font = Enum.Font.RobotoMono -- Modern font
loadingText.Parent = loadingScreen

-- Function to hide the loading screen with a fade-out effect
local function hideLoadingScreen()
    local tweenInfo = TweenInfo.new(
        1.2, -- Duration slightly longer for smoother fade
        Enum.EasingStyle.Quint, -- Smoother easing style
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )

    -- Tween loading screen and text transparency
    local loadingScreenGoal = {BackgroundTransparency = 1}
    local loadingTextGoal = {TextTransparency = 1}

    local loadingScreenTween = TweenService:Create(loadingScreen, tweenInfo, loadingScreenGoal)
    local loadingTextTween = TweenService:Create(loadingText, tweenInfo, loadingTextGoal)

    loadingScreenTween:Play()
    loadingTextTween:Play()

    -- Connect to the Completed event to destroy the loading screen after animation
    loadingScreenTween.Completed:Connect(function()
        loadingScreen:Destroy()
    end)
end

-- Wait for the specified duration, then hide the loading screen
task.wait(LOADING_SCREEN_DURATION)
hideLoadingScreen()

-- Initially hide the main content until loading is complete
-- (This might be redundant if loading screen covers it, but good practice)
containerFrame.Visible = true -- Ensure the main UI is visible after loading

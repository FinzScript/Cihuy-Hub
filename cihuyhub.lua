-- Script to create "Cihuy Hub" GUI with a Loading Screen
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Wait until PlayerGui is ready (important for UI LocalScript)
repeat task.wait() until LocalPlayer.PlayerGui

-- Variables for the main ScreenGui
local screenGuiName = "Cihuy Hub"
local mainBackgroundColor = Color3.fromRGB(40, 40, 40) -- Dark gray
local outlineColor = Color3.fromRGB(0, 0, 100) -- Dark blue
local outlineThickness = 3 -- Outline thickness

-- Variables for the loading screen
local loadingScreenDuration = 3 -- Duration of the loading screen in seconds

--- Create the ScreenGui ---
local cihuyHubGui = Instance.new("ScreenGui")
cihuyHubGui.Name = screenGuiName
cihuyHubGui.Parent = LocalPlayer.PlayerGui

-- Ensure UI scales consistently across devices
-- UIScale will scale all elements within this ScreenGui
local uiScale = Instance.new("UIScale")
uiScale.Scale = 0.8 -- Adjust this value as needed, 0.8 is usually a good starting size
uiScale.Parent = cihuyHubGui

--- Create the Main Background Frame ---
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainBackground"
mainFrame.Size = UDim2.new(0.6, 0, 0.7, 0) -- Size: 60% width, 70% height of screen
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center of the screen
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- Set anchor point to the center for true centering
mainFrame.BackgroundColor3 = mainBackgroundColor
mainFrame.BorderSizePixel = outlineThickness -- Add outline thickness
mainFrame.BorderColor3 = outlineColor -- Outline color
mainFrame.Parent = cihuyHubGui

-- Add a UIAspectRatioConstraint to keep the Frame proportional on various screen sizes
local aspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
aspectRatioConstraint.AspectRatio = mainFrame.AbsoluteSize.X / mainFrame.AbsoluteSize.Y -- Set ratio based on initial frame size
aspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize -- Adjust to fit within max size
aspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width -- Prioritize width
aspectRatioConstraint.Parent = mainFrame

--- Create the Loading Screen ---
local loadingScreen = Instance.new("Frame")
loadingScreen.Name = "LoadingScreen"
loadingScreen.Size = UDim2.new(1, 0, 1, 0) -- Cover the entire ScreenGui
loadingScreen.Position = UDim2.new(0, 0, 0, 0)
loadingScreen.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Dark color for loading
loadingScreen.Parent = cihuyHubGui -- Important: LoadingScreen parented to ScreenGui to cover everything

-- Text for the loading screen
local loadingText = Instance.new("TextLabel")
loadingText.Name = "LoadingText"
loadingText.Size = UDim2.new(0.8, 0, 0.2, 0)
loadingText.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingText.AnchorPoint = Vector2.new(0.5, 0.5)
loadingText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingText.BackgroundTransparency = 1 -- Transparent so only text is visible
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.TextScaled = true
loadingText.Text = "Loading Cihuy Hub..."
loadingText.Font = Enum.Font.SourceSansBold
loadingText.Parent = loadingScreen

--- Loading Screen Animation ---

-- Function to hide the loading screen
local function hideLoadingScreen()
    local tweenInfo = TweenInfo.new(
        1, -- Tween duration (1 second)
        Enum.EasingStyle.Quad, -- Easing style
        Enum.EasingDirection.Out, -- Easing direction
        0, -- Number of repeats
        false, -- Reverse on repeat
        0 -- Initial delay
    )

    -- Properties to tween (transparency of loading screen)
    local goal = {BackgroundTransparency = 1}
    local tween = TweenService:Create(loadingScreen, tweenInfo, goal)

    -- Also tween the loading text transparency
    local textGoal = {TextTransparency = 1}
    local textTween = TweenService:Create(loadingText, tweenInfo, textGoal)

    tween:Play()
    textTween:Play()

    -- Wait for the tween to complete, then destroy the loading screen
    tween.Completed:Connect(function()
        loadingScreen:Destroy() -- Destroy the loading screen after animation completes
    end)
end

-- Wait for a few seconds, then call the function to hide the loading screen
task.wait(loadingScreenDuration)
hideLoadingScreen()

-- You can add other UI elements inside mainFrame here
-- For example, buttons, labels, etc.
local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Name = "WelcomeLabel"
welcomeLabel.Size = UDim2.new(0.8, 0, 0.2, 0) -- 80% width of main frame, 20% height of main frame
welcomeLabel.Position = UDim2.new(0.5, 0, 0.2, 0)
welcomeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
welcomeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- Bright yellow color
welcomeLabel.TextScaled = true
welcomeLabel.Text = "Welcome to Cihuy Hub!"
welcomeLabel.Font = Enum.Font.FredokaOne
welcomeLabel.Parent = mainFrame -- Important: This is parented to mainFrame, not ScreenGui

-- Ensure mainFrame is visible after the loading screen is gone
-- This ensures mainFrame isn't initially obscured if the loading screen is on top
mainFrame.Visible = true

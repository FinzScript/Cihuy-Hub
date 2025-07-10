-- Script for the optimized "Cihuy Hub" GUI with drag, close, and minimize/maximize functionality
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

print("Cihuy Hub Script: Starting initialization.")

-- Wait until PlayerGui is ready (crucial for UI LocalScripts)
repeat task.wait() until LocalPlayer.PlayerGui
print("Cihuy Hub Script: PlayerGui is ready. Proceeding with GUI creation.")

-- UI Configuration Variables - Define these clearly for easy modification
local MAIN_BG_COLOR = Color3.fromRGB(35, 35, 45) -- Dark bluish-gray for modern look
local ACCENT_COLOR = Color3.fromRGB(50, 100, 200) -- Modern blue accent
local OUTLINE_COLOR = Color3.fromRGB(25, 25, 35) -- Slightly darker outline
local BORDER_RADIUS = 12 -- Corner radius for modern rounded edges
local TEXT_COLOR = Color3.fromRGB(230, 230, 230) -- Light gray for text
local HEADER_COLOR = Color3.fromRGB(45, 45, 55) -- Slightly lighter header for distinction

local LOADING_SCREEN_DURATION = 2.5 -- Duration of the loading screen in seconds
local UI_SCALE_FACTOR = 0.7 -- Adjust this for overall UI size on screen

-- Minimize Icon specific variables
local MINIMIZE_ICON_SIZE = UDim2.new(0, 50, 0, 50) -- Fixed size for the small icon
local MINIMIZE_ICON_COLOR = ACCENT_COLOR -- Use accent color for the icon
local MINIMIZE_TEXT = "CH" -- Text on the minimized icon

print("Cihuy Hub Script: Global variables and services initialized.")--- Create the Main ScreenGui ---
local cihuyHubGui = Instance.new("ScreenGui")
cihuyHubGui.Name = "CihuyHub_Main" -- Giving a clear name
cihuyHubGui.Parent = LocalPlayer.PlayerGui
print("Cihuy Hub Script: ScreenGui 'CihuyHub_Main' created and parented to PlayerGui.")

-- Apply overall UI scaling for responsiveness across devices
local uiScale = Instance.new("UIScale")
uiScale.Scale = UI_SCALE_FACTOR
uiScale.Parent = cihuyHubGui
print("Cihuy Hub Script: UIScale applied for responsive design.")

--- Create the Main Container Frame ---
-- This frame will hold both the sidebar and the main content area
local containerFrame = Instance.new("Frame")
containerFrame.Name = "MainContainer"
containerFrame.Size = UDim2.new(0.7, 0, 0.8, 0) -- Slightly smaller overall UI
containerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
containerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
containerFrame.BackgroundColor3 = MAIN_BG_COLOR
containerFrame.BorderSizePixel = 0 -- We'll use UIStroke for borders
containerFrame.Parent = cihuyHubGui -- <<-- INI ADALAH PERBAIKAN KRUSIAL!
print("Cihuy Hub Script: MainContainer created and parented CORRECTLY to cihuyHubGui.")

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
aspectRatioConstraint.AspectRatio = containerFrame.AbsoluteSize.X / containerFrame.AbsoluteSize.Y -- Calculate ratio based on initial size
aspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
aspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
aspectRatioConstraint.Parent = containerFrame
print("Cihuy Hub Script: MainContainer styling (corners, stroke, aspect ratio) applied.")

--- Create the Header Bar (for dragging and close button) ---
local headerBar = Instance.new("Frame")
headerBar.Name = "HeaderBar"
headerBar.Size = UDim2.new(1, 0, 0, 40) -- Full width of container, 40 pixels height
headerBar.Position = UDim2.new(0, 0, 0, 0)
headerBar.BackgroundColor3 = HEADER_COLOR
headerBar.BorderSizePixel = 0
headerBar.Parent = containerFrame
print("Cihuy Hub Script: HeaderBar created and parented to MainContainer.")

-- Add rounded corners to the top of the header bar (only top-left/top-right)
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, BORDER_RADIUS)
headerCorner.Parent = headerBar

-- Title text for the header bar
local headerTitle = Instance.new("TextLabel")
headerTitle.Name = "Title"
headerTitle.Size = UDim2.new(0.8, 0, 1, 0)
headerTitle.Position = UDim2.new(0.05, 0, 0, 0) -- Slightly indented
headerTitle.AnchorPoint = Vector2.new(0, 0)
headerTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.TextColor3 = TEXT_COLOR
headerTitle.TextScaled = false
headerTitle.TextSize = 20
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Text = "Cihuy Hub"
headerTitle.Font = Enum.Font.RobotoMono
headerTitle.Parent = headerBar
print("Cihuy Hub Script: Header Title created.")

--- Create Close Button (X) ---
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30) -- Fixed size
closeButton.Position = UDim2.new(1, -35, 0.5, 0) -- Right side of header, centered vertically
closeButton.AnchorPoint = Vector2.new(1, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Red color
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = false
closeButton.TextSize = 20
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = headerBar

-- Add rounded corners to the close button
local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(0, 6)
closeButtonCorner.Parent = closeButton
print("Cihuy Hub Script: Close Button created.")

--- Create Minimized Icon ---
local minimizedIcon = Instance.new("TextButton")
minimizedIcon.Name = "MinimizedCihuyHub"
minimizedIcon.Size = MINIMIZE_ICON_SIZE
minimizedIcon.Position = UDim2.new(0.1, 0, 0.1, 0) -- Initial position when minimized
minimizedIcon.AnchorPoint = Vector2.new(0.5, 0.5)
minimizedIcon.BackgroundColor3 = MINIMIZE_ICON_COLOR
minimizedIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizedIcon.TextScaled = true
minimizedIcon.Text = MINIMIZE_TEXT
minimizedIcon.Font = Enum.Font.SourceSansBold
minimizedIcon.Visible = false -- Initially hidden
minimizedIcon.Parent = cihuyHubGui -- Parented to ScreenGui, not containerFrame, so it's always on top
print("Cihuy Hub Script: Minimized Icon created.")

-- Add rounded corners to the minimized icon
local minimizedIconCorner = Instance.new("UICorner")
minimizedIconCorner.CornerRadius = UDim.new(0.5, 0) -- Make it circular
minimizedIconCorner.Parent = minimizedIcon

--- Create the Sidebar (Invisible Bar for Tabs) ---
local sidebarFrame = Instance.new("Frame")
sidebarFrame.Name = "Sidebar"
sidebarFrame.Size = UDim2.new(0.25, 0, 1, -40) -- 25% width of container, full height minus header
sidebarFrame.Position = UDim2.new(0, 0, 0, 40) -- Positioned below the header
sidebarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
sidebarFrame.BorderSizePixel = 0
sidebarFrame.Parent = containerFrame
print("Cihuy Hub Script: Sidebar created and parented to MainContainer.")

-- Add rounded corners to the sidebar
local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, BORDER_RADIUS)
sidebarCorner.Parent = sidebarFrame

-- Add a separator line between sidebar and main content (visual improvement)
local separatorLine = Instance.new("Frame")
separatorLine.Name = "SeparatorLine"
separatorLine.Size = UDim2.new(0, 2, 1, 0)
separatorLine.Position = UDim2.new(1, -2, 0, 0)
separatorLine.BackgroundColor3 = OUTLINE_COLOR
separatorLine.Parent = sidebarFrame
print("Cihuy Hub Script: Sidebar styling applied (corners, separator).")

--- Create the Main Content Area ---
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentArea"
contentFrame.Size = UDim2.new(0.75, 0, 1, -40) -- Remaining width, full height minus header
contentFrame.Position = UDim2.new(0.25, 0, 0, 40) -- Positioned right after sidebar, below header
contentFrame.BackgroundColor3 = MAIN_BG_COLOR
contentFrame.BorderSizePixel = 0
contentFrame.Parent = containerFrame
print("Cihuy Hub Script: ContentArea created and parented to MainContainer.")

-- Example elements in the main content area
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0.5, 0, 0.15, 0)
titleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = ACCENT_COLOR
titleLabel.TextScaled = false
titleLabel.TextSize = 32
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
descriptionLabel.TextSize = 20
descriptionLabel.TextWrap = true
descriptionLabel.TextXAlignment = Enum.TextXAlignment.Center
descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
descriptionLabel.Text = "Welcome to your experimental Cihuy Hub! This is a modern and advanced UI for your scientific testing and learning."
descriptionLabel.Font = Enum.Font.SourceSans
descriptionLabel.Parent = contentFrame
print("Cihuy Hub Script: Example content added to ContentArea.")

--- Create and Animate Loading Screen ---
local loadingScreen = Instance.new("Frame")
loadingScreen.Name = "LoadingScreen"
-- Size and position exactly like the main container for a smooth transition
loadingScreen.Size = containerFrame.Size
loadingScreen.Position = containerFrame.Position
loadingScreen.AnchorPoint = containerFrame.AnchorPoint
loadingScreen.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
loadingScreen.Parent = cihuyHubGui -- Parented to the main ScreenGui
print("Cihuy Hub Script: LoadingScreen created and parented.")

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
loadingText.TextSize = 24
loadingText.Text = "Initializing Cihuy Hub..."
loadingText.Font = Enum.Font.RobotoMono
loadingText.Parent = loadingScreen
print("Cihuy Hub Script: LoadingText created.")

-- Function to hide the loading screen with a fade-out effect
local function hideLoadingScreen()
    print("Cihuy Hub Script: Hiding loading screen.")
    local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    local loadingScreenGoal = {BackgroundTransparency = 1}
    local loadingTextGoal = {TextTransparency = 1}

    local loadingScreenTween = TweenService:Create(loadingScreen, tweenInfo, loadingScreenGoal)
    local loadingTextTween = TweenService:Create(loadingText, tweenInfo, loadingTextGoal)

    loadingScreenTween:Play()
    loadingTextTween:Play()

    loadingScreenTween.Completed:Connect(function()
        loadingScreen:Destroy()
        print("Cihuy Hub Script: LoadingScreen destroyed.")
    end)
end

-- Wait for the specified duration, then hide the loading screen
task.wait(LOADING_SCREEN_DURATION)
hideLoadingScreen()

-- Initially ensure the main UI is visible after loading completes
containerFrame.Visible = true
print("Cihuy Hub Script: Main GUI (containerFrame) set to visible after loading.")

--- GUI Drag Functionality ---
local isDragging = false
local dragStartPos = Vector2.new(0, 0)
local initialGuiPos = UDim2.new(0, 0, 0, 0)
local currentDragConnectionChanged = nil
local currentDragConnectionEnded = nil

local function startDrag(inputObject, guiToDrag)
    -- Prevent starting a new drag if one is already active
    if isDragging then return end 

    isDragging = true
    dragStartPos = inputObject.Position
    initialGuiPos = guiToDrag.Position

    -- Disconnect any previous connections before creating new ones (for robustness)
    if currentDragConnectionChanged then currentDragConnectionChanged:Disconnect() end
    if currentDragConnectionEnded then currentDragConnectionEnded:Disconnect() end

    currentDragConnectionChanged = UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartPos
            local newX = initialGuiPos.X.Scale + delta.X / cihuyHubGui.AbsoluteSize.X
            local newY = initialGuiPos.Y.Scale + delta.Y / cihuyHubGui.AbsoluteSize.Y
            guiToDrag.Position = UDim2.new(newX, 0, newY, 0)
        end
    end)

    currentDragConnectionEnded = UserInputService.InputEnded:Connect(function(input)
        -- Ensure this ends the *current* drag operation only
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            isDragging = false
            if currentDragConnectionChanged then currentDragConnectionChanged:Disconnect() end
            if currentDragConnectionEnded then currentDragConnectionEnded:Disconnect() end
            currentDragConnectionChanged = nil
            currentDragConnectionEnded = nil
            print("Cihuy Hub Script: Drag operation ended.")
        end
    end)
    print("Cihuy Hub Script: Dragging started for " .. guiToDrag.Name)
end

headerBar.InputBegan:Connect(function(inputObject)
    if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
        startDrag(inputObject, containerFrame)
    end
end)

minimizedIcon.InputBegan:Connect(function(inputObject)
    if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
        startDrag(inputObject, minimizedIcon)
    end
end)

--- Close/Minimize and Maximize Functionality ---

local function minimizeGui()
    print("Cihuy Hub Script: minimizeGui called.")
    local currentPos = containerFrame.Position -- Save current position for re-opening
    
    local tweenInfoFadeOut = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    -- Tween the main container's transparency
    local containerTween = TweenService:Create(containerFrame, tweenInfoFadeOut, {BackgroundTransparency = 1, BorderTransparency = 1})
    containerTween:Play()

    -- Tween and hide all child elements
    for _, child in ipairs(containerFrame:GetDescendants()) do
        if child:IsA("GuiObject") then -- Check if it's a GUI object
            local properties = {}
            if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") then
                properties.BackgroundTransparency = 1
                properties.ImageTransparency = 1
            end
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                properties.TextTransparency = 1
            end
            
            if next(properties) then -- Only create tween if there are properties to tween
                TweenService:Create(child, tweenInfoFadeOut, properties):Play()
            end
            
            -- Set visible to false after tween finishes to truly hide them
            task.delay(tweenInfoFadeOut.Time + 0.05, function() -- Add a small delay after tween time
                child.Visible = false
                -- Handle UIStroke visibility/transparency if it exists
                if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") then -- Check all types that might have UIStroke
                    local stroke = child:FindFirstChildOfClass("UIStroke")
                    if stroke then stroke.Transparency = 1 end
                end
            end)
        end
    end

    -- After containerFrame's tween completes, set its visibility to false
    containerTween.Completed:Connect(function() -- Connect to the container's tween completion
        containerFrame.Visible = false
        print("Cihuy Hub Script: Main GUI hidden. Showing minimized icon.")
        -- Show the minimized icon at the last known position of the GUI
        minimizedIcon.Position = currentPos -- Position the icon where the main GUI was
        minimizedIcon.Visible = true
        
        -- Fade in the minimized icon
        local tweenInfoFadeIn = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goalFadeIn = {BackgroundTransparency = 0, TextTransparency = 0}
        TweenService:Create(minimizedIcon, tweenInfoFadeIn, goalFadeIn):Play()
    end)
end

local function maximizeGui()
    print("Cihuy Hub Script: maximizeGui called.")
    local currentIconPos = minimizedIcon.Position -- Save current icon position
    
    -- Fade out the minimized icon
    local tweenInfoFadeOut = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local iconTween = TweenService:Create(minimizedIcon, tweenInfoFadeOut, {BackgroundTransparency = 1, TextTransparency = 1})
    iconTween:Play()
    
    iconTween.Completed:Connect(function() -- Connect to the icon's tween completion
        minimizedIcon.Visible = false -- Hide after fade
        print("Cihuy Hub Script: Minimized icon hidden. Showing main GUI.")
        -- Show the container frame at the icon's last known position
        containerFrame.Position = currentIconPos -- Position the main GUI where the icon was
        containerFrame.Visible = true -- Make visible before tweening in

        local tweenInfoFadeIn = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        -- Tween in the container frame itself
        TweenService:Create(containerFrame, tweenInfoFadeIn, {BackgroundTransparency = 0, BorderTransparency = 0}):Play()

        -- Show and tween all child elements
        for _, child in ipairs(containerFrame:GetDescendants()) do
            if child:IsA("GuiObject") then -- Check if it's a GUI object
                child.Visible = true -- Make visible before tweening in
                local properties = {}
                if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") then
                    properties.BackgroundTransparency = 0
                    properties.ImageTransparency = 0
                end
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    properties.TextTransparency = 0
                end

                if next(properties) then -- Only create tween if there are properties to tween
                    TweenService:Create(child, tweenInfoFadeIn, properties):Play()
                end
                -- Handle UIStroke visibility/transparency if it exists
                if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") then -- Check all types that might have UIStroke
                    local stroke = child:FindFirstChildOfClass("UIStroke")
                    if stroke then stroke.Transparency = 0 end
                end
            end
        end
    end)
end

closeButton.MouseButton1Click:Connect(minimizeGui)
minimizedIcon.MouseButton1Click:Connect(maximizeGui)

print("Cihuy Hub Script: All functions connected. Initialization complete. Ready for interaction.")

-- Script for the optimized "Cihuy Hub" GUI with drag, close, and minimize/maximize functionality
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

print("Cihuy Hub Script: Starting initialization.")

-- Wait until PlayerGui is ready (crucial for UI LocalScripts)
repeat task.wait() until LocalPlayer.PlayerGui
print("Cihuy Hub Script: PlayerGui is ready. Proceeding with GUI creation.")

-- UI Configuration Variables - Define these clearly for easy modification
local MAIN_BG_COLOR = Color3.fromRGB(35, 35, 45) -- Dark bluish-gray for modern look
local ACCENT_COLOR = Color3.fromRGB(50, 100, 200) -- Modern blue accent
local OUTLINE_COLOR = Color3.fromRGB(25, 25, 35) -- Slightly darker outline
local BORDER_RADIUS = 12 -- Corner radius for modern rounded edges
local TEXT_COLOR = Color3.fromRGB(230, 230, 230) -- Light gray for text
local HEADER_COLOR = Color3.fromRGB(45, 45, 55) -- Slightly lighter header for distinction

local LOADING_SCREEN_DURATION = 2.5 -- Duration of the loading screen in seconds
local UI_SCALE_FACTOR = 0.7 -- Adjust this for overall UI size on screen

-- Minimize Icon specific variables
local MINIMIZE_ICON_SIZE = UDim2.new(0, 50, 0, 50) -- Fixed size for the small icon
local MINIMIZE_ICON_COLOR = ACCENT_COLOR -- Use accent color for the icon
local MINIMIZE_TEXT = "CH" -- Text on the minimized icon

print("Cihuy Hub Script: Global variables and services initialized.")

--- Create the Main ScreenGui ---
local cihuyHubGui = Instance.new("ScreenGui")
cihuyHubGui.Name = "CihuyHub_Main" -- Giving a clear name
cihuyHubGui.Parent = LocalPlayer.PlayerGui
print("Cihuy Hub Script: ScreenGui 'CihuyHub_Main' created and parented to PlayerGui.")

-- Apply overall UI scaling for responsiveness across devices
local uiScale = Instance.new("UIScale")
uiScale.Scale = UI_SCALE_FACTOR
uiScale.Parent = cihuyHubGui
print("Cihuy Hub Script: UIScale applied for responsive design.")

--- Create the Main Container Frame ---
-- This frame will hold both the sidebar and the main content area
local containerFrame = Instance.new("Frame")
containerFrame.Name = "MainContainer"
containerFrame.Size = UDim2.new(0.7, 0, 0.8, 0) -- Slightly smaller overall UI
containerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
containerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
containerFrame.BackgroundColor3 = MAIN_BG_COLOR
containerFrame.BorderSizePixel = 0 -- We'll use UIStroke for borders
containerFrame.Parent = cihuyHubGui -- <<-- INI ADALAH PERBAIKAN KRUSIAL!
print("Cihuy Hub Script: MainContainer created and parented CORRECTLY to cihuyHubGui.")

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
aspectRatioConstraint.AspectRatio = containerFrame.AbsoluteSize.X / containerFrame.AbsoluteSize.Y -- Calculate ratio based on initial size
aspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
aspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
aspectRatioConstraint.Parent = containerFrame
print("Cihuy Hub Script: MainContainer styling (corners, stroke, aspect ratio) applied.")

--- Create the Header Bar (for dragging and close button) ---
local headerBar = Instance.new("Frame")
headerBar.Name = "HeaderBar"
headerBar.Size = UDim2.new(1, 0, 0, 40) -- Full width of container, 40 pixels height
headerBar.Position = UDim2.new(0, 0, 0, 0)
headerBar.BackgroundColor3 = HEADER_COLOR
headerBar.BorderSizePixel = 0
headerBar.Parent = containerFrame
print("Cihuy Hub Script: HeaderBar created and parented to MainContainer.")

-- Add rounded corners to the top of the header bar (only top-left/top-right)
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, BORDER_RADIUS)
headerCorner.Parent = headerBar

-- Title text for the header bar
local headerTitle = Instance.new("TextLabel")
headerTitle.Name = "Title"
headerTitle.Size = UDim2.new(0.8, 0, 1, 0)
headerTitle.Position = UDim2.new(0.05, 0, 0, 0) -- Slightly indented
headerTitle.AnchorPoint = Vector2.new(0, 0)
headerTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.TextColor3 = TEXT_COLOR
headerTitle.TextScaled = false
headerTitle.TextSize = 20
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Text = "Cihuy Hub"
headerTitle.Font = Enum.Font.RobotoMono
headerTitle.Parent = headerBar
print("Cihuy Hub Script: Header Title created.")

--- Create Close Button (X) ---
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30) -- Fixed size
closeButton.Position = UDim2.new(1, -35, 0.5, 0) -- Right side of header, centered vertically
closeButton.AnchorPoint = Vector2.new(1, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Red color
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = false
closeButton.TextSize = 20
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = headerBar

-- Add rounded corners to the close button
local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(0, 6)
closeButtonCorner.Parent = closeButton
print("Cihuy Hub Script: Close Button created.")

--- Create Minimized Icon ---
local minimizedIcon = Instance.new("TextButton")
minimizedIcon.Name = "MinimizedCihuyHub"
minimizedIcon.Size = MINIMIZE_ICON_SIZE
minimizedIcon.Position = UDim2.new(0.1, 0, 0.1, 0) -- Initial position when minimized
minimizedIcon.AnchorPoint = Vector2.new(0.5, 0.5)
minimizedIcon.BackgroundColor3 = MINIMIZE_ICON_COLOR
minimizedIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizedIcon.TextScaled = true
minimizedIcon.Text = MINIMIZE_TEXT
minimizedIcon.Font = Enum.Font.SourceSansBold
minimizedIcon.Visible = false -- Initially hidden
minimizedIcon.Parent = cihuyHubGui -- Parented to ScreenGui, not containerFrame, so it's always on top
print("Cihuy Hub Script: Minimized Icon created.")

-- Add rounded corners to the minimized icon
local minimizedIconCorner = Instance.new("UICorner")
minimizedIconCorner.CornerRadius = UDim.new(0.5, 0) -- Make it circular
minimizedIconCorner.Parent = minimizedIcon

--- Create the Sidebar (Invisible Bar for Tabs) ---
local sidebarFrame = Instance.new("Frame")
sidebarFrame.Name = "Sidebar"
sidebarFrame.Size = UDim2.new(0.25, 0, 1, -40) -- 25% width of container, full height minus header
sidebarFrame.Position = UDim2.new(0, 0, 0, 40) -- Positioned below the header
sidebarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
sidebarFrame.BorderSizePixel = 0
sidebarFrame.Parent = containerFrame
print("Cihuy Hub Script: Sidebar created and parented to MainContainer.")

-- Add rounded corners to the sidebar
local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, BORDER_RADIUS)
sidebarCorner.Parent = sidebarFrame

-- Add a separator line between sidebar and main content (visual improvement)
local separatorLine = Instance.new("Frame")
separatorLine.Name = "SeparatorLine"
separatorLine.Size = UDim2.new(0, 2, 1, 0)
separatorLine.Position = UDim2.new(1, -2, 0, 0)
separatorLine.BackgroundColor3 = OUTLINE_COLOR
separatorLine.Parent = sidebarFrame
print("Cihuy Hub Script: Sidebar styling applied (corners, separator).")

--- Create the Main Content Area ---
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentArea"
contentFrame.Size = UDim2.new(0.75, 0, 1, -40) -- Remaining width, full height minus header
contentFrame.Position = UDim2.new(0.25, 0, 0, 40) -- Positioned right after sidebar, below header
contentFrame.BackgroundColor3 = MAIN_BG_COLOR
contentFrame.BorderSizePixel = 0
contentFrame.Parent = containerFrame
print("Cihuy Hub Script: ContentArea created and parented to MainContainer.")

-- Example elements in the main content area
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0.5, 0, 0.15, 0)
titleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = ACCENT_COLOR
titleLabel.TextScaled = false
titleLabel.TextSize = 32
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
descriptionLabel.TextSize = 20
descriptionLabel.TextWrap = true
descriptionLabel.TextXAlignment = Enum.TextXAlignment.Center
descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
descriptionLabel.Text = "Welcome to your experimental Cihuy Hub! This is a modern and advanced UI for your scientific testing and learning."
descriptionLabel.Font = Enum.Font.SourceSans
descriptionLabel.Parent = contentFrame
print("Cihuy Hub Script: Example content added to ContentArea.")

--- Create and Animate Loading Screen ---
local loadingScreen = Instance.new("Frame")
loadingScreen.Name = "LoadingScreen"
-- Size and position exactly like the main container for a smooth transition
loadingScreen.Size = containerFrame.Size
loadingScreen.Position = containerFrame.Position
loadingScreen.AnchorPoint = containerFrame.AnchorPoint
loadingScreen.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
loadingScreen.Parent = cihuyHubGui -- Parented to the main ScreenGui
print("Cihuy Hub Script: LoadingScreen created and parented.")

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
loadingText.TextSize = 24
loadingText.Text = "Initializing Cihuy Hub..."
loadingText.Font = Enum.Font.RobotoMono
loadingText.Parent = loadingScreen
print("Cihuy Hub Script: LoadingText created.")

-- Function to hide the loading screen with a fade-out effect
local function hideLoadingScreen()
    print("Cihuy Hub Script: Hiding loading screen.")
    local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    local loadingScreenGoal = {BackgroundTransparency = 1}
    local loadingTextGoal = {TextTransparency = 1}

    local loadingScreenTween = TweenService:Create(loadingScreen, tweenInfo, loadingScreenGoal)
    local loadingTextTween = TweenService:Create(loadingText, tweenInfo, loadingTextGoal)

    loadingScreenTween:Play()
    loadingTextTween:Play()

    loadingScreenTween.Completed:Connect(function()
        loadingScreen:Destroy()
        print("Cihuy Hub Script: LoadingScreen destroyed.")
    end)
end

-- Wait for the specified duration, then hide the loading screen
task.wait(LOADING_SCREEN_DURATION)
hideLoadingScreen()

-- Initially ensure the main UI is visible after loading completes
containerFrame.Visible = true
print("Cihuy Hub Script: Main GUI (containerFrame) set to visible after loading.")

--- GUI Drag Functionality ---
local isDragging = false
local dragStartPos = Vector2.new(0, 0)
local initialGuiPos = UDim2.new(0, 0, 0, 0)
local currentDragConnectionChanged = nil
local currentDragConnectionEnded = nil

local function startDrag(inputObject, guiToDrag)
    -- Prevent starting a new drag if one is already active
    if isDragging then return end 

    isDragging = true
    dragStartPos = inputObject.Position
    initialGuiPos = guiToDrag.Position

    -- Disconnect any previous connections before creating new ones (for robustness)
    if currentDragConnectionChanged then currentDragConnectionChanged:Disconnect() end
    if currentDragConnectionEnded then currentDragConnectionEnded:Disconnect() end

    currentDragConnectionChanged = UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartPos
            local newX = initialGuiPos.X.Scale + delta.X / cihuyHubGui.AbsoluteSize.X
            local newY = initialGuiPos.Y.Scale + delta.Y / cihuyHubGui.AbsoluteSize.Y
            guiToDrag.Position = UDim2.new(newX, 0, newY, 0)
        end
    end)

    currentDragConnectionEnded = UserInputService.InputEnded:Connect(function(input)
        -- Ensure this ends the *current* drag operation only
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            isDragging = false
            if currentDragConnectionChanged then currentDragConnectionChanged:Disconnect() end
            if currentDragConnectionEnded then currentDragConnectionEnded:Disconnect() end
            currentDragConnectionChanged = nil
            currentDragConnectionEnded = nil
            print("Cihuy Hub Script: Drag operation ended.")
        end
    end)
    print("Cihuy Hub Script: Dragging started for " .. guiToDrag.Name)
end

headerBar.InputBegan:Connect(function(inputObject)
    if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
        startDrag(inputObject, containerFrame)
    end
end)

minimizedIcon.InputBegan:Connect(function(inputObject)
    if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
        startDrag(inputObject, minimizedIcon)
    end
end)

--- Close/Minimize and Maximize Functionality ---

local function minimizeGui()
    print("Cihuy Hub Script: minimizeGui called.")
    local currentPos = containerFrame.Position -- Save current position for re-opening
    
    local tweenInfoFadeOut = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    -- Tween the main container's transparency
    local containerTween = TweenService:Create(containerFrame, tweenInfoFadeOut, {BackgroundTransparency = 1, BorderTransparency = 1})
    containerTween:Play()

    -- Tween and hide all child elements
    for _, child in ipairs(containerFrame:GetDescendants()) do
        if child:IsA("GuiObject") then -- Check if it's a GUI object
            local properties = {}
            if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") then
                properties.BackgroundTransparency = 1
                properties.ImageTransparency = 1
            end
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                properties.TextTransparency = 1
            end
            
            if next(properties) then -- Only create tween if there are properties to tween
                TweenService:Create(child, tweenInfoFadeOut, properties):Play()
            end
            
            -- Set visible to false after tween finishes to truly hide them
            task.delay(tweenInfoFadeOut.Time + 0.05, function() -- Add a small delay after tween time
                child.Visible = false
                -- Handle UIStroke visibility/transparency if it exists
                if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") then -- Check all types that might have UIStroke
                    local stroke = child:FindFirstChildOfClass("UIStroke")
                    if stroke then stroke.Transparency = 1 end
                end
            end)
        end
    end

    -- After containerFrame's tween completes, set its visibility to false
    containerTween.Completed:Connect(function() -- Connect to the container's tween completion
        containerFrame.Visible = false
        print("Cihuy Hub Script: Main GUI hidden. Showing minimized icon.")
        -- Show the minimized icon at the last known position of the GUI
        minimizedIcon.Position = currentPos -- Position the icon where the main GUI was
        minimizedIcon.Visible = true
        
        -- Fade in the minimized icon
        local tweenInfoFadeIn = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goalFadeIn = {BackgroundTransparency = 0, TextTransparency = 0}
        TweenService:Create(minimizedIcon, tweenInfoFadeIn, goalFadeIn):Play()
    end)
end

local function maximizeGui()
    print("Cihuy Hub Script: maximizeGui called.")
    local currentIconPos = minimizedIcon.Position -- Save current icon position
    
    -- Fade out the minimized icon
    local tweenInfoFadeOut = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local iconTween = TweenService:Create(minimizedIcon, tweenInfoFadeOut, {BackgroundTransparency = 1, TextTransparency = 1})
    iconTween:Play()
    
    iconTween.Completed:Connect(function() -- Connect to the icon's tween completion
        minimizedIcon.Visible = false -- Hide after fade
        print("Cihuy Hub Script: Minimized icon hidden. Showing main GUI.")
        -- Show the container frame at the icon's last known position
        containerFrame.Position = currentIconPos -- Position the main GUI where the icon was
        containerFrame.Visible = true -- Make visible before tweening in

        local tweenInfoFadeIn = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        -- Tween in the container frame itself
        TweenService:Create(containerFrame, tweenInfoFadeIn, {BackgroundTransparency = 0, BorderTransparency = 0}):Play()

        -- Show and tween all child elements
        for _, child in ipairs(containerFrame:GetDescendants()) do
            if child:IsA("GuiObject") then -- Check if it's a GUI object
                child.Visible = true -- Make visible before tweening in
                local properties = {}
                if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") then
                    properties.BackgroundTransparency = 0
                    properties.ImageTransparency = 0
                end
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    properties.TextTransparency = 0
                end

                if next(properties) then -- Only create tween if there are properties to tween
                    TweenService:Create(child, tweenInfoFadeIn, properties):Play()
                end
                -- Handle UIStroke visibility/transparency if it exists
                if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") then -- Check all types that might have UIStroke
                    local stroke = child:FindFirstChildOfClass("UIStroke")
                    if stroke then stroke.Transparency = 0 end
                end
          

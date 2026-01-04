\--// HttpSpy Enhanced v2.1 - Multi-Output Support
assert(syn or http, "Unsupported exploit (should support syn.request or http.request)")

local function R()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = ""
    for i = 1, math.random(12, 20) do
        local j = math.random(1, #chars)
        result = result .. chars:sub(j, j)
    end
    return result
end

local config = ({...})[1] or {
    AutoDecode = true,
    Highlighting = true,
    SaveLogs = true,
    ShowResponse = true,
    BlockedURLs = {},
    API = true
}

local version = "v2.1 Enhanced"
local logFile = string.format("%d-%s-log.txt", game.PlaceId, os.date("%d_%m_%y"))
local guiNames = {
    ScreenGui = R(),
    MainFrame = R(),
    SelectFrame = R(),
    TitleBar = R(),
    LogsFrame = R(),
    MinimizedIcon = R()
}

local outputMode = nil -- "ui" hoặc "console"
local isEnabled = true
local requestCount = 0

if config.SaveLogs then
    pcall(function()
        writefile(logFile, string.format("Http Logs from %s\n\n", os.date("%d/%m/%y")))
    end)
end

local serializer
pcall(function()
    serializer = loadstring(game:HttpGet("https://raw.githubusercontent.com/NotDSF/leopard/main/rbx/leopard-syn.lua"))()
    serializer.UpdateConfig({highlighting = config.Highlighting})
end)

if not serializer then
    warn("Failed to load Serializer")
    serializer = {
        Serialize = function(data) return tostring(data) end,
        FormatArguments = function(...) return table.concat({...}, ", ") end
    }
end

local function createSelectionUI()
    local sg = Instance.new("ScreenGui")
    sg.Name = guiNames.ScreenGui
    sg.DisplayOrder = 9999
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.Parent = game:GetService("CoreGui")
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.BorderSizePixel = 0
    overlay.Parent = sg
    
    local selectFrame = Instance.new("Frame")
    selectFrame.Name = guiNames.SelectFrame
    selectFrame.Size = UDim2.new(0, 400, 0, 280)
    selectFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
    selectFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    selectFrame.BorderColor3 = Color3.fromRGB(60, 60, 70)
    selectFrame.BorderSizePixel = 2
    selectFrame.Parent = sg
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = selectFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 50)
    title.Position = UDim2.new(0, 20, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "HttpSpy - Select Output Mode"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = selectFrame
    
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -40, 0, 40)
    desc.Position = UDim2.new(0, 20, 0, 70)
    desc.BackgroundTransparency = 1
    desc.Text = "Choose where to display HTTP request logs:"
    desc.TextColor3 = Color3.fromRGB(180, 180, 190)
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 14
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextWrapped = true
    desc.Parent = selectFrame
    
    local function createButton(text, desc, pos, color, mode)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -40, 0, 60)
        btn.Position = pos
        btn.BackgroundColor3 = color
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = selectFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        local btnTitle = Instance.new("TextLabel")
        btnTitle.Size = UDim2.new(1, -20, 0, 25)
        btnTitle.Position = UDim2.new(0, 10, 0, 8)
        btnTitle.BackgroundTransparency = 1
        btnTitle.Text = text
        btnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnTitle.Font = Enum.Font.GothamBold
        btnTitle.TextSize = 15
        btnTitle.TextXAlignment = Enum.TextXAlignment.Left
        btnTitle.Parent = btn
        
        local btnDesc = Instance.new("TextLabel")
        btnDesc.Size = UDim2.new(1, -20, 0, 20)
        btnDesc.Position = UDim2.new(0, 10, 0, 33)
        btnDesc.BackgroundTransparency = 1
        btnDesc.Text = desc
        btnDesc.TextColor3 = Color3.fromRGB(200, 200, 210)
        btnDesc.Font = Enum.Font.Gotham
        btnDesc.TextSize = 12
        btnDesc.TextXAlignment = Enum.TextXAlignment.Left
        btnDesc.Parent = btn
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(
                math.min(color.R * 255 + 20, 255),
                math.min(color.G * 255 + 20, 255),
                math.min(color.B * 255 + 20, 255)
            )
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = color
        end)
        
        btn.MouseButton1Click:Connect(function()
            outputMode = mode
            sg:Destroy()
        end)
    end
    
    createButton(
        "Custom UI",
        "Display in custom interface (recommended)",
        UDim2.new(0, 20, 0, 120),
        Color3.fromRGB(50, 120, 200),
        "ui"
    )
    
    createButton(
        "Console Output",
        "Log to developer console (F9)",
        UDim2.new(0, 20, 0, 190),
        Color3.fromRGB(100, 60, 180),
        "console"
    )
end

local function logToConsole(text, isResponse)
    local prefix = isResponse and "[RESPONSE]" or "[REQUEST]"
    local color = isResponse and "@@GREEN@@" or "@@CYAN@@"
    
    if rconsoleprint then
        rconsoleprint(color)
        rconsoleprint(string.format("%s %s\n%s\n\n", prefix, os.date("%H:%M:%S"), text))
        rconsoleprint("@@WHITE@@")
    else
        print(string.format("%s %s\n%s", prefix, os.date("%H:%M:%S"), text))
    end
end

local function createMainUI()
    local sg = Instance.new("ScreenGui")
    sg.Name = guiNames.ScreenGui
    sg.DisplayOrder = 999
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.Parent = game:GetService("CoreGui")
    
    local isMobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled
    local frameWidth = isMobile and 350 or 420
    local frameHeight = isMobile and 450 or 500
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = guiNames.MainFrame
    mainFrame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
    mainFrame.Position = UDim2.new(0.5, -frameWidth/2, 0.5, -frameHeight/2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderColor3 = Color3.fromRGB(60, 60, 70)
    mainFrame.BorderSizePixel = 2
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = sg
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = guiNames.TitleBar
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 15)
    titleFix.Position = UDim2.new(0, 0, 1, -15)
    titleFix.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -180, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "HttpSpy " .. version
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = isMobile and 14 or 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- Buttons Container
    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(0, 180, 1, 0)
    btnContainer.Position = UDim2.new(1, -185, 0, 0)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = titleBar
    
    local function createTitleButton(text, pos, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, isMobile and 38 : 40, 0, isMobile and 26 : 28)
        btn.Position = pos
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = isMobile and 11 : 12
        btn.BackgroundColor3 = color
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = btnContainer
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        local hoverColor = Color3.fromRGB(
            math.min(color.R * 255 + 20, 255),
            math.min(color.G * 255 + 20, 255),
            math.min(color.B * 255 + 20, 255)
        )
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = hoverColor
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = color
        end)
        
        btn.MouseButton1Click:Connect(callback)
        
        return btn
    end
    
    local toggleBtn = createTitleButton(
        "ON",
        UDim2.new(0, 0, 0.5, -14),
        Color3.fromRGB(40, 140, 60),
        function()
            isEnabled = not isEnabled
            toggleBtn.Text = isEnabled and "ON" or "OFF"
            toggleBtn.BackgroundColor3 = isEnabled and Color3.fromRGB(40, 140, 60) or Color3.fromRGB(140, 40, 40)
        end
    )
    
    createTitleButton(
        "[-]",
        UDim2.new(0, isMobile and 43 : 45, 0.5, -14),
        Color3.fromRGB(60, 60, 70),
        function()
            mainFrame.Visible = false
            local minimized = Instance.new("TextButton")
            minimized.Name = guiNames.MinimizedIcon
            minimized.Size = UDim2.new(0, 50, 0, 50)
            minimized.Position = UDim2.new(0.5, -25, 0, 15)
            minimized.Text = "HTTP"
            minimized.Font = Enum.Font.GothamBold
            minimized.TextSize = 14
            minimized.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            minimized.TextColor3 = Color3.fromRGB(255, 255, 255)
            minimized.BorderSizePixel = 2
            minimized.BorderColor3 = Color3.fromRGB(60, 60, 70)
            minimized.AutoButtonColor = false
            minimized.ZIndex = 1000
            minimized.Parent = sg
            
            local minCorner = Instance.new("UICorner")
            minCorner.CornerRadius = UDim.new(0, 10)
            minCorner.Parent = minimized
            
            minimized.MouseButton1Click:Connect(function()
                mainFrame.Visible = true
                minimized:Destroy()
            end)
        end
    )
    
    createTitleButton(
        "[+]",
        UDim2.new(0, isMobile and 86 : 90, 0.5, -14),
        Color3.fromRGB(60, 60, 70),
        function()
            if mainFrame.Size == UDim2.new(0, frameWidth, 0, frameHeight) then
                mainFrame.Size = UDim2.new(0.95, 0, 0.95, 0)
                mainFrame.Position = UDim2.new(0.025, 0, 0.025, 0)
            else
                mainFrame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
                mainFrame.Position = UDim2.new(0.5, -frameWidth/2, 0.5, -frameHeight/2)
            end
        end
    )
    
    createTitleButton(
        "X",
        UDim2.new(0, isMobile and 129 : 135, 0.5, -14),
        Color3.fromRGB(180, 50, 50),
        function()
            sg:Destroy()
        end
    )
    
    -- Logs Frame
    local logsFrame = Instance.new("ScrollingFrame")
    logsFrame.Name = guiNames.LogsFrame
    logsFrame.Size = UDim2.new(1, -20, 1, -120)
    logsFrame.Position = UDim2.new(0, 10, 0, 55)
    logsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    logsFrame.BorderSizePixel = 0
    logsFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
    logsFrame.ScrollBarThickness = 6
    logsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    logsFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    logsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    logsFrame.Parent = mainFrame
    
    local logsCorner = Instance.new("UICorner")
    logsCorner.CornerRadius = UDim.new(0, 8)
    logsCorner.Parent = logsFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = logsFrame
    
    local logsPadding = Instance.new("UIPadding")
    logsPadding.PaddingLeft = UDim.new(0, 8)
    logsPadding.PaddingRight = UDim.new(0, 8)
    logsPadding.PaddingTop = UDim.new(0, 8)
    logsPadding.PaddingBottom = UDim.new(0, 8)
    logsPadding.Parent = logsFrame
    
    -- Bottom Bar
    local bottomBar = Instance.new("Frame")
    bottomBar.Size = UDim2.new(1, -20, 0, 55)
    bottomBar.Position = UDim2.new(0, 10, 1, -65)
    bottomBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    bottomBar.BorderSizePixel = 0
    bottomBar.Parent = mainFrame
    
    local bottomCorner = Instance.new("UICorner")
    bottomCorner.CornerRadius = UDim.new(0, 8)
    bottomCorner.Parent = bottomBar
    
    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(0, isMobile and 75 : 85, 0, 35)
    clearBtn.Position = UDim2.new(0, 10, 0.5, -17.5)
    clearBtn.Text = "Clear"
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.TextSize = isMobile and 12 : 13
    clearBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearBtn.BorderSizePixel = 0
    clearBtn.AutoButtonColor = false
    clearBtn.Parent = bottomBar
    
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 6)
    clearCorner.Parent = clearBtn
    
    clearBtn.MouseButton1Click:Connect(function()
        for _, child in ipairs(logsFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        requestCount = 0
    end)
    
    local countLabel = Instance.new("TextLabel")
    countLabel.Size = UDim2.new(0, 150, 1, 0)
    countLabel.Position = UDim2.new(1, -160, 0, 0)
    countLabel.Text = "Requests: 0"
    countLabel.Font = Enum.Font.GothamBold
    countLabel.TextSize = isMobile and 12 : 13
    countLabel.BackgroundTransparency = 1
    countLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    countLabel.TextXAlignment = Enum.TextXAlignment.Right
    countLabel.Parent = bottomBar
    
    local function addLog(text, isResponse)
        local cleanText = text:gsub("\027%[[%d;]+m", "")
        
        task.spawn(function()
            pcall(function()
                requestCount = requestCount + 1
                countLabel.Text = "Requests: " .. requestCount
                
                local logFrame = Instance.new("Frame")
                logFrame.Name = R()
                logFrame.Size = UDim2.new(1, -10, 0, 0)
                logFrame.BackgroundColor3 = isResponse and Color3.fromRGB(25, 40, 25) or Color3.fromRGB(35, 25, 40)
                logFrame.BorderSizePixel = 0
                logFrame.AutomaticSize = Enum.AutomaticSize.Y
                logFrame.LayoutOrder = requestCount
                logFrame.Parent = logsFrame
                
                local logCorner = Instance.new("UICorner")
                logCorner.CornerRadius = UDim.new(0, 6)
                logCorner.Parent = logFrame
                
                local logPadding = Instance.new("UIPadding")
                logPadding.PaddingLeft = UDim.new(0, 10)
                logPadding.PaddingRight = UDim.new(0, 10)
                logPadding.PaddingTop = UDim.new(0, 8)
                logPadding.PaddingBottom = UDim.new(0, 8)
                logPadding.Parent = logFrame
                
                local header = Instance.new("Frame")
                header.Size = UDim2.new(1, 0, 0, 20)
                header.BackgroundTransparency = 1
                header.Parent = logFrame
                
                local typeLabel = Instance.new("TextLabel")
                typeLabel.Size = UDim2.new(0, 100, 1, 0)
                typeLabel.BackgroundTransparency = 1
                typeLabel.Text = isResponse and "Response" or "Request"
                typeLabel.TextColor3 = isResponse and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 150, 100)
                typeLabel.Font = Enum.Font.GothamBold
                typeLabel.TextSize = isMobile and 11 : 12
                typeLabel.TextXAlignment = Enum.TextXAlignment.Left
                typeLabel.Parent = header
                
                local timeLabel = Instance.new("TextLabel")
                timeLabel.Size = UDim2.new(0, 80, 1, 0)
                timeLabel.Position = UDim2.new(0, 105, 0, 0)
                timeLabel.BackgroundTransparency = 1
                timeLabel.Text = os.date("%H:%M:%S")
                timeLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
                timeLabel.Font = Enum.Font.Gotham
                timeLabel.TextSize = isMobile and 10 : 11
                timeLabel.TextXAlignment = Enum.TextXAlignment.Left
                timeLabel.Parent = header
                
                local copyBtn = Instance.new("TextButton")
                copyBtn.Size = UDim2.new(0, isMobile and 50 : 55, 0, 20)
                copyBtn.Position = UDim2.new(1, -(isMobile and 50 : 55), 0, 0)
                copyBtn.Text = "Copy"
                copyBtn.Font = Enum.Font.GothamBold
                copyBtn.TextSize = isMobile and 10 : 11
                copyBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
                copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                copyBtn.BorderSizePixel = 0
                copyBtn.AutoButtonColor = false
                copyBtn.Parent = header
                
                local copyCorner = Instance.new("UICorner")
                copyCorner.CornerRadius = UDim.new(0, 4)
                copyCorner.Parent = copyBtn
                
                copyBtn.MouseButton1Click:Connect(function()
                    setclipboard(cleanText)
                    copyBtn.Text = "Copied"
                    task.wait(1.5)
                    copyBtn.Text = "Copy"
                end)
                
                local content = Instance.new("TextLabel")
                content.Name = "ContentLabel"
                content.Size = UDim2.new(1, 0, 0, 0)
                content.Position = UDim2.new(0, 0, 0, 25)
                content.Text = cleanText
                content.TextColor3 = Color3.fromRGB(240, 240, 245)
                content.BackgroundTransparency = 1
                content.TextXAlignment = Enum.TextXAlignment.Left
                content.TextYAlignment = Enum.TextYAlignment.Top
                content.TextWrapped = true
                content.Font = Enum.Font.Code
                content.TextSize = isMobile and 11 : 12
                content.AutomaticSize = Enum.AutomaticSize.Y
                content.Parent = logFrame
                
                task.wait()
                logsFrame.CanvasPosition = Vector2.new(0, logsFrame.AbsoluteCanvasSize.Y)
            end)
        end)
    end
    
    return addLog
end

-- Main Logic
createSelectionUI()

repeat task.wait() until outputMode

local addLog
if outputMode == "ui" then
    addLog = createMainUI()
end

local function logRequest(text, isResponse)
    if config.SaveLogs then
        pcall(function()
            appendfile(logFile, text:gsub("\027%[[%d;]+m", ""))
        end)
    end
    
    if outputMode == "console" then
        logToConsole(text, isResponse)
    elseif outputMode == "ui" and addLog then
        addLog(text, isResponse)
    end
end

-- Hook Functions
local origRequest = (syn or http).request
local reqType = syn and "syn" or "http"

local hookedRequest = function(options)
    if type(options) ~= "table" or not isEnabled then
        return origRequest(options)
    end
    
    local url = options.Url
    if not url or config.BlockedURLs[url] then
        return origRequest(options)
    end
    
    logRequest(string.format("%s.request(%s)\n\n", reqType, serializer.Serialize(options)), false)
    
    if not config.ShowResponse then
        return origRequest(options)
    end
    
    local success, response = pcall(origRequest, options)
    
    if success then
        local respData = {}
        for k, v in pairs(response) do
            respData[k] = v
        end
        
        if respData.Headers and respData.Headers["Content-Type"] and 
           respData.Headers["Content-Type"]:match("application/json") and config.AutoDecode then
            local decSuccess, decoded = pcall(game.HttpService.JSONDecode, game.HttpService, respData.Body)
            if decSuccess then
                respData.Body = decoded
            end
        end
        
        logRequest(string.format("Response: %s\n\n", serializer.Serialize(respData)), true)
    end
    
    return response
end

hookfunction(origRequest, hookedRequest)

-- Initial message
task.spawn(function()
    local initMsg = string.format(
        "HttpSpy %s - Enhanced Edition\nOutput Mode: %s\nLogs: %s\n\n",
        version,
        outputMode == "ui" and "Custom UI" or "Console",
        config.SaveLogs and logFile or "Disabled"
    )
    logRequest(initMsg, false)
end)

print("HttpSpy Enhanced loaded - Output mode: " .. outputMode)

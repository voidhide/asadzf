-- Scoot UI library used by zzzzartefact/new lib.lua.
-- Keep this file synchronized with the source hosted as dad.lua.
if Library then
    Library:Unload()
end

local Library do
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new
    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local Vector2New = Vector2.new

    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower
    local StringLen = string.len

    local InstanceNew = Instance.new

    local RectNew = Rect.new

    Library = {
        Theme =  { },

        MenuKeybind = tostring(Enum.KeyCode.RightShift), 
        Flags = { },

        Tween = {
            Time = 0.2,
            Style = Enum.EasingStyle.Quad,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,

        Folders = {
            Directory = "scoot",
            Configs = "scoot/Configs",
            Assets = "scoot/Assets",
        },

        Images = {
            ["Saturation"] = {"Saturation.png", "https://github.com/sametexe001/images/blob/main/saturation.png?raw=true" },
            ["Value"] = { "Value.png", "https://github.com/sametexe001/images/blob/main/value.png?raw=true" },
            ["Hue"] = { "Hue.png", "https://github.com/sametexe001/images/blob/main/horizontalhue.png?raw=true" },
            ["Checkers"] = { "Checkers.png", "https://github.com/sametexe001/images/blob/main/checkers.png?raw=true" },
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        CopiedColor = nil,

        OpenFrames = { },

        CurrentPage = nil,

        SearchItems = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        Font = nil,
        KeyList = nil,

        Colorpickers = { },
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    local function IsTyping(GameProcessed)
        if GameProcessed then
            return true
        end

        return UserInputService:GetFocusedTextBox() ~= nil
    end

    local function FormatKey(Key)
        if Key == nil or Key == false then
            return "None", "None"
        end

        if typeof(Key) == "EnumItem" then
            local Name = Key.Name
            if Name == "Unknown" or Name == "Backspace" then
                return "None", "None"
            end

            return tostring(Key), Keys[Name] or Name
        end

        if type(Key) == "string" then
            if Key == "" or Key == "None" or Key == "nil" then
                return "None", "None"
            end

            local Name = StringGSub(StringGSub(StringGSub(Key, "Enum.", ""), "KeyCode.", ""), "UserInputType.", "")
            if Name == "Unknown" or Name == "Backspace" or Name == "None" or Name == "" then
                return "None", "None"
            end

            local Stored = Key
            if not StringFind(Key, "Enum") then
                local AsKey = Enum.KeyCode[Name]
                local AsInput = Enum.UserInputType[Name]
                if AsKey then
                    Stored = tostring(AsKey)
                elseif AsInput then
                    Stored = tostring(AsInput)
                else
                    Stored = "Enum.KeyCode." .. Name
                end
            end

            return Stored, Keys[Name] or Name
        end

        return "None", "None"
    end

    local SpecialCharacters = {
        "[",
        "]",
        "(",
        ")",
        "{",
        "}",
        "!",
        "@",
        "#",
        "$",
        "%",
        "^",
        "&",
        "*",
        "+",
        "="
    }

    local Themes = {
        ["Preset"] = {
            ["Background"] = FromRGB(14, 17, 15),
            ["Border"] = FromRGB(12, 12, 12),
            ["Inline"] = FromRGB(20, 24, 21),
            ["Hovered Element"] = FromRGB(37, 42, 45),
            ["Page Background"] = FromRGB(25, 30, 26),
            ["Outline"] = FromRGB(42, 49, 45),
            ["Element"] = FromRGB(30, 36, 31),
            ["Gradient"] = FromRGB(208, 208, 208),
            ["Text"] = FromRGB(235, 235, 235),
            ["Text Stroke"] = FromRGB(0, 0, 0),
            ["Placeholder Text"] = FromRGB(185, 185, 185),
            ["Accent"] = FromRGB(202, 243, 255)
        }
    }

    Library.Theme = TableClone(Themes["Preset"])

    -- Folders
    for Index, Value in Library.Folders do 
        if not isfolder(Value) then
            makefolder(Value)
        end
    end

    -- Images
    for Index, Value in Library.Images do 
        local ImageData = Value

        local ImageName = ImageData[1]
        local ImageLink = ImageData[2]
        
        if not isfile(Library.Folders.Assets .. "/" .. ImageName) then
            writefile(Library.Folders.Assets .. "/" .. ImageName, game:HttpGet(ImageLink))
        end
    end

    -- Tweening
    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.GetProperty = function(self, Item)
            Item = Item or self.Item 

            if Item:IsA("Frame") then
                return { "BackgroundTransparency" }
            elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif Item:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif Item:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("UIStroke") then 
                return { "Transparency" }
            end
        end

        Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
            local Item = Item or self.Item 

            local OldTransparency = Item[Property]
            Item[Property] = Visibility and 1 or OldTransparency

            local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
                [Property] = Visibility and OldTransparency or 1
            }, true)

            Library:Connect(NewTween.Tween.Completed, function()
                if not Visibility then 
                    task.wait()
                    Item[Property] = OldTransparency
                end
            end)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    -- Instances
    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.FadeItem = function(self, Visibility, Speed)
            local Item = self.Instance

            if Visibility == true then 
                Item.Visible = true
            end

            local Descendants = Item:GetDescendants()
            TableInsert(Descendants, Item)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then 
                    continue
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, not Visibility, Speed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, not Visibility, Speed)
                end
            end
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:AddToTheme(self, Properties)
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            if Library.Ready ~= true then
                for Property, Value in Goal do
                    pcall(function()
                        self.Instance[Property] = Value
                    end)
                end

                return {
                    Tween = {
                        Completed = {
                            Connect = function(_, Callback)
                                task.defer(Callback)
                                return { Disconnect = function() end }
                            end,
                        },
                    },
                }
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Dragging = false 
            local DragStart
            local StartPosition 

            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                self:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)})
            end

            local InputChanged

            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true

                    DragStart = Input.Position
                    StartPosition = Gui.Position

                    if InputChanged then 
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Set(Input)
                    end
                end
            end)

            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Resizing = false 
            local Start = UDim2New()
            local Delta = UDim2New()
            local ResizeMax = Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

            local ResizeButton = Instances:Create("ImageButton", {
				Parent = Gui,
                Image = "rbxassetid://",
				AnchorPoint = Vector2New(1, 1),
				BorderColor3 = FromRGB(0, 0, 0),
				Size = UDim2New(0, 6, 0, 6),
				Position = UDim2New(1, -4, 1, -4),
                Name = "\0",
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
                ZIndex = 5,
				AutoButtonColor = false,
                Visible = true,
			})  ResizeButton:AddToTheme({ImageColor3 = "Accent"})

            local InputChanged

            ResizeButton:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then

                    Resizing = true

                    Start = Gui.Size - UDim2New(0, Input.Position.X, 0, Input.Position.Y)

                    if InputChanged then 
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Resizing = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Resizing then
                        ResizeMax = Maximum or Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

                        Delta = Start + UDim2New(0, Input.Position.X, 0, Input.Position.Y)
                        Delta = UDim2New(0, math.clamp(Delta.X.Offset, Minimum.X, ResizeMax.X), 0, math.clamp(Delta.Y.Offset, Minimum.Y, ResizeMax.Y))

                        Tween:Create(Gui, TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = Delta}, true)
                    end
                end
            end)

            return Resizing
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end

        Instances.Border = function(self, Type)
            if not self.Instance then 
                return
            end

            local Color = Type == "Border" and Library.Theme.Border or Type == "Outline" and Library.Theme.Outline
        
            local UIStroke = Instances:Create("UIStroke", {
                Parent = self.Instance,
                Color = Color,
                Thickness = 1,
                LineJoinMode = Enum.LineJoinMode.Miter
            })  UIStroke:AddToTheme({Color = Type})

            return UIStroke
        end

        Instances.TextBorder = function(self)
            if not self.Instance then 
                return
            end

            local UIStroke = Instances:Create("UIStroke", {
                Parent = self.Instance,
                Color = Library.Theme["Text Stroke"],
                Thickness = 1,
                Transparency = 0.6,
                LineJoinMode = Enum.LineJoinMode.Miter
            })  UIStroke:AddToTheme({Color = "Text Stroke"})

            return UIStroke
        end

        Instances.Tooltip = function(self, Data)
            if not self.Instance then 
                return
            end

            if Data.Text == nil then 
                return
            end

            if type(Data.Text) ~= "string" then 
                return
            end

            local Gui = self.Instance

            local MouseLocation = UserInputService:GetMouseLocation()
            local RenderStepped

            local Items = { } do
                Items["Tooltip"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    Size = UDim2New(0, 0, 0, 25),
                    Position = UDim2New(0, Gui.AbsolutePosition.X, 0, Gui.AbsolutePosition.Y),
                    BorderColor3 = FromRGB(12, 12, 12),
                    BorderSizePixel = 2,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundTransparency = 1,
                    BackgroundColor3 = FromRGB(14, 17, 15)
                })  Items["Tooltip"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

                Items["UIStroke"] = Instances:Create("UIStroke", {
                    Parent = Items["Tooltip"].Instance,
                    Color = FromRGB(0, 0, 0),
                    Thickness = 1,
                    Transparency = 1,
                    LineJoinMode = Enum.LineJoinMode.Miter
                })  Items["UIStroke"]:AddToTheme({Color = "Outline"})

                Instances:Create("UIPadding", {
                    Parent = Items["Tooltip"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 5),
                    PaddingBottom = UDimNew(0, 6),
                    PaddingRight = UDimNew(0, 5),
                    PaddingLeft = UDimNew(0, 5)
                })

                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Tooltip"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(202, 243, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Text,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Title"]:AddToTheme({TextColor3 = "Accent"})

                Items["UIStroke2"] = Items["Title"]:TextBorder()
                Items["UIStroke2"].Instance.Transparency = 1

                Items["Description"] = Instances:Create("TextLabel", {
                    Parent = Items["Tooltip"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Description,
                    Position = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Description"]:AddToTheme({TextColor3 = "Text"})

                Items["UIStroke3"] = Items["Description"]:TextBorder()
                Items["UIStroke3"].Instance.Transparency = 1
            end

            Library:Connect(Gui.MouseEnter, function()
                Items["Tooltip"].Instance.Position = UDim2New(0, MouseLocation.X + 8, 0, MouseLocation.Y - 32)
                Items["Tooltip"]:Tween(nil, {BackgroundTransparency = 0})
                Items["Title"]:Tween(nil, {TextTransparency = 0})
                Items["Description"]:Tween(nil, {TextTransparency = 0})
                Items["UIStroke"]:Tween(nil, {Transparency = 0})
                Items["UIStroke2"]:Tween(nil, {Transparency = 0})
                Items["UIStroke3"]:Tween(nil, {Transparency = 0})

                RenderStepped = RunService.RenderStepped:Connect(function()
                    MouseLocation = UserInputService:GetMouseLocation()
                    Items["Tooltip"]:Tween(nil, {Position = UDim2New(0, MouseLocation.X + 8, 0, MouseLocation.Y - 35)})
                end)
            end)

            Library:Connect(Gui.MouseLeave, function()
                Items["Tooltip"]:Tween(nil, {BackgroundTransparency = 1})
                Items["Title"]:Tween(nil, {TextTransparency = 1})
                Items["Description"]:Tween(nil, {TextTransparency = 1})
                Items["UIStroke"]:Tween(nil, {Transparency = 1})
                Items["UIStroke2"]:Tween(nil, {Transparency = 1})
                Items["UIStroke3"]:Tween(nil, {Transparency = 1})

                if RenderStepped then 
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end)
        end
    end

    -- Custom font
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end

            if not isfile(Library.Folders.Assets .. "/" .. Name .. ".ttf") then 
                writefile(Library.Folders.Assets .. "/" .. Name .. ".ttf", game:HttpGet(Data.Url))
            end

            local FontData = {
                name = Name,
                faces = { {
                    name = "Regular",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".ttf")
                } }
            }

            writefile(Library.Folders.Assets .. "/" .. Name .. ".json", HttpService:JSONEncode(FontData))
            return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
        end

        function CustomFont:Get(Name)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end
        end

        CustomFont:New("Monaco", 400, "Regular", {
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Monaco.ttf"
        })

        Library.Font = CustomFont:Get("Monaco")
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 2,
        Enabled = false,
        ResetOnSpawn = false
    })

    do
        local pendingBump = {}
        local bumpScheduled = false
        local function applyBump(list)
            local seenAuto = {}
            local seenScroll = {}
            for item in pairs(list) do
                local node = item
                while node do
                    if node:IsA("GuiObject") and node.AutomaticSize ~= Enum.AutomaticSize.None and not seenAuto[node] then
                        seenAuto[node] = true
                        local oldAuto = node.AutomaticSize
                        node.AutomaticSize = Enum.AutomaticSize.None
                        node.AutomaticSize = oldAuto
                    end
                    if node:IsA("ScrollingFrame") and not seenScroll[node] then
                        seenScroll[node] = true
                        local pos = node.CanvasPosition
                        local oldCanvas = node.AutomaticCanvasSize
                        node.AutomaticCanvasSize = Enum.AutomaticSize.None
                        node.AutomaticCanvasSize = oldCanvas
                        node.CanvasSize = UDim2New(0, 0, 0, 0)
                        node.CanvasPosition = Vector2New(pos.X, pos.Y + 1)
                        node.CanvasPosition = pos
                        break
                    end
                    node = node.Parent
                end
            end
        end
        Library.BumpLayout = function(self, inst)
            if typeof(inst) == "Instance" then
                pendingBump[inst] = true
            end
            if bumpScheduled then
                return
            end
            bumpScheduled = true
            task.spawn(function()
                RunService.RenderStepped:Wait()
                task.wait(0.05)
                bumpScheduled = false
                local snapshot = pendingBump
                pendingBump = {}
                applyBump(snapshot)
                RunService.Heartbeat:Once(function()
                    applyBump(snapshot)
                end)
            end)
        end
    end

    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Enabled = false,
        ResetOnSpawn = false
    })

    Library.NotifHolder = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        Size = UDim2New(0, 0, 1, 0),
        BorderColor3 = FromRGB(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })

    Instances:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDimNew(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    Instances:Create("UIPadding", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        PaddingTop = UDimNew(0, 12),
        PaddingBottom = UDimNew(0, 12),
        PaddingRight = UDimNew(0, 12),
        PaddingLeft = UDimNew(0, 12)
    })

    Library.Unload = function(self)
        for Index, Value in self.Connections do 
            Value.Connection:Disconnect()
        end

        for Index, Value in self.Threads do 
            coroutine.close(Value)
        end

        if self.Holder then 
            self.Holder:Clean()
        end

        Library = nil 
        getgenv().Library = nil

        UserInputService.MouseIconEnabled = true
    end

    Library.GetImage = function(self, Image)
        local ImageData = self.Images[Image]

        if not ImageData then 
            return
        end

        return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
    end

    Library.PreloadSpinFrames = function(self, Count)
        local Images = self._SpinImages
        if type(Images) ~= "table" then
            Images = {}
            self._SpinImages = Images
        end

        local Folder = self.Folders.Assets .. "/spin"
        pcall(function()
            if not isfolder(Folder) then
                makefolder(Folder)
            end
        end)

        local Expected = 40
        if type(self.SpinFrames) == "table" and #self.SpinFrames > 0 then
            Expected = #self.SpinFrames
        elseif isfile then
            local Found = 0
            while isfile(Folder .. "/" .. tostring(Found + 1) .. ".png") do
                Found += 1
                if Found >= 128 then
                    break
                end
            end
            if Found > 0 then
                Expected = Found
            end
        end

        local Target = Expected
        if type(Count) == "number" then
            Target = math.min(Expected, Count)
        end

        local function DecodeB64(Data)
            if crypt then
                if crypt.base64 and crypt.base64.decode then
                    local Ok, Result = pcall(crypt.base64.decode, Data)
                    if Ok and Result then
                        return Result
                    end
                end

                if crypt.base64decode then
                    local Ok, Result = pcall(crypt.base64decode, Data)
                    if Ok and Result then
                        return Result
                    end
                end
            end

            local Abc = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
            local Map = {}
            for Index = 1, 64 do
                Map[Abc:byte(Index)] = Index - 1
            end

            local Out = table.create(math.floor(#Data / 4))
            local Offset = 0
            for Index = 1, #Data, 4 do
                local A = Map[Data:byte(Index)] or 0
                local B = Map[Data:byte(Index + 1)] or 0
                local C = Map[Data:byte(Index + 2)] or 0
                local D = Map[Data:byte(Index + 3)] or 0
                local N = A * 262144 + B * 4096 + C * 64 + D
                Offset += 1
                Out[Offset] = string.char(math.floor(N / 65536) % 256, math.floor(N / 256) % 256, N % 256)
            end

            local Result = TableConcat(Out)
            local Pad = 0
            if Data:sub(-1, -1) == "=" then
                Pad += 1
            end
            if Data:sub(-2, -2) == "=" then
                Pad += 1
            end
            if Pad > 0 then
                Result = Result:sub(1, #Result - Pad)
            end

            return Result
        end

        local Yield = Count == nil
        for Index = #Images + 1, Target do
            local Path = Folder .. "/" .. tostring(Index) .. ".png"
            local OkAsset, Asset = pcall(function()
                if not (isfile and isfile(Path)) then
                    local Blob = self.SpinFrames and self.SpinFrames[Index]
                    if type(Blob) ~= "string" then
                        return nil
                    end
                    writefile(Path, DecodeB64(Blob))
                end
                return getcustomasset(Path)
            end)

            if OkAsset and Asset and Asset ~= "" then
                Images[Index] = Asset
            else
                break
            end

            if Yield and Index % 8 == 0 then
                task.wait()
            end
        end

        return Images
    end

    Library.AttachSpinningLogo = function(self, LogoItem)
        if not LogoItem or not LogoItem.Instance then
            return
        end

        local Inst = LogoItem.Instance

        local function PinLogo()
            local Accent = self.Theme and self.Theme.Accent
            if Accent then
                Inst.ImageColor3 = Accent
            end
            Inst.ImageTransparency = 0
            Inst.Rotation = 0
        end

        local function SetImage(Asset)
            if type(Asset) ~= "string" or Asset == "" or Inst.Image == Asset then
                PinLogo()
                return
            end
            Inst.Image = Asset
            PinLogo()
        end

        PinLogo()

        local Cached = self._SpinImages
        if type(Cached) == "table" and Cached[1] then
            SetImage(Cached[1])
        end

        if self._SpinAnim then
            return
        end

        task.spawn(function()
            RunService.RenderStepped:Wait()
            task.wait(0.8)
            local Images = self:PreloadSpinFrames()
            PinLogo()
            if type(Images) ~= "table" or #Images < 2 then
                return
            end

            pcall(function()
                local Warm = Instance.new("Folder")
                Warm.Name = "FridaySpinWarm"
                Warm.Parent = (self.UnusedHolder and self.UnusedHolder.Instance) or Inst

                local Labels = table.create(#Images)
                for Index = 1, #Images do
                    local Img = Instance.new("ImageLabel")
                    Img.BackgroundTransparency = 1
                    Img.ImageTransparency = 1
                    Img.Size = UDim2.fromOffset(2, 2)
                    Img.Image = Images[Index]
                    Img.ImageColor3 = Inst.ImageColor3
                    Img.Parent = Warm
                    Labels[Index] = Img
                end

                pcall(function()
                    game:GetService("ContentProvider"):PreloadAsync(Labels)
                end)

                local T0 = os.clock()
                while os.clock() - T0 < 1.25 do
                    local Ready = true
                    for Index = 1, #Labels do
                        if Labels[Index].IsLoaded == false then
                            Ready = false
                            break
                        end
                    end
                    if Ready then
                        break
                    end
                    task.wait()
                end

                Warm:Destroy()
            end)

            PinLogo()
            SetImage(Images[1])

            if self._SpinAnim then
                return
            end

            self._SpinAnim = true
            local LastIndex = 1
            local Origin = os.clock()
            Library:Connect(RunService.RenderStepped, function()
                if not Inst.Parent then
                    return
                end
                if Library.WindowOpenState ~= true then
                    Inst.Visible = false
                    Inst.ImageTransparency = 1
                    return
                end
                Inst.Visible = true
                PinLogo()

                local Count = #Images
                local Index = (MathFloor((os.clock() - Origin) * 20) % Count) + 1
                if Index ~= LastIndex then
                    LastIndex = Index
                    Inst.Image = Images[Index]
                end
            end)
        end)
    end

    Library.Round = function(self, Number, Float)
        Number = tonumber(Number)
        if not Number or Number ~= Number then
            return 0
        end

        Float = tonumber(Float)
        if not Float or Float ~= Float or Float == 0 then
            Float = 1
        end

        local Result = MathFloor(Number * (1 / Float)) / (1 / Float)
        if Result ~= Result then
            return Number
        end

        return Result
    end

    Library.SliderStep = function(self, Decimals)
        local d = tonumber(Decimals)
        if not d or d ~= d or d <= 0 then
            return 1
        end
        if d < 1 then
            return d
        end
        return 10 ^ (-MathFloor(d + 1e-9))
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)
        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        if self.Ready == false then
            return true
        end

        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        self.UnnamedConnections += 1
        Name = Name or StringFormat("Connection%s", self.UnnamedConnections)

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = Event:Connect(Callback)
        }

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    do
        local ContentProvider = game:GetService("ContentProvider")
        local ThumbType = Enum.ThumbnailType.HeadShot
        local ThumbSize = Enum.ThumbnailSize.Size420x420
        local cache = {}
        local pending = {}
        local queued = {}
        local waiters = {}
        local warmLabels = {}
        local queue = {}
        local inflight = 0
        local MAX_INFLIGHT = 8

        local function notifyWaiters(uid, content)
            local list = waiters[uid]
            waiters[uid] = nil
            if not list then
                return
            end
            for Index = 1, #list do
                pcall(list[Index], content)
            end
        end

        local function warmImage(uid, content)
            local img = warmLabels[uid]
            if img then
                img.Image = content
                return
            end
            img = Instance.new("ImageLabel")
            img.Name = "ThumbCache"
            img.BackgroundTransparency = 1
            img.ImageTransparency = 1
            img.Size = UDim2.fromOffset(4, 4)
            img.Image = content
            img.Parent = Library.UnusedHolder and Library.UnusedHolder.Instance
            warmLabels[uid] = img
            pcall(function()
                ContentProvider:PreloadAsync({ img })
            end)
        end

        local function pumpQueue()
            while inflight < MAX_INFLIGHT and #queue > 0 do
                local uid = table.remove(queue, 1)
                queued[uid] = nil
                if cache[uid] then
                    notifyWaiters(uid, cache[uid])
                elseif not pending[uid] then
                    pending[uid] = true
                    inflight += 1
                    task.spawn(function()
                        local ok, content = pcall(Players.GetUserThumbnailAsync, Players, uid, ThumbType, ThumbSize)
                        pending[uid] = nil
                        inflight -= 1
                        if ok and type(content) == "string" and content ~= "" then
                            cache[uid] = content
                            pcall(warmImage, uid, content)
                            notifyWaiters(uid, content)
                        end
                        pumpQueue()
                    end)
                end
            end
        end

        Library.GetCachedThumbnail = function(self, userId)
            return cache[tonumber(userId)]
        end

        Library.RequestThumbnail = function(self, userId, callback)
            local uid = tonumber(userId)
            if not uid then
                return nil
            end
            local hit = cache[uid]
            if hit then
                if callback then
                    pcall(callback, hit)
                end
                return hit
            end
            if callback then
                waiters[uid] = waiters[uid] or {}
                TableInsert(waiters[uid], callback)
            end
            if not pending[uid] and not queued[uid] then
                queued[uid] = true
                TableInsert(queue, 1, uid)
                pumpQueue()
            else
                pumpQueue()
            end
            return nil
        end

        Library.WarmAllThumbnails = function(self)
            for _, plr in ipairs(Players:GetPlayers()) do
                Library:RequestThumbnail(plr.UserId)
            end
        end

        getgenv().__FridayThumbCache = cache
        getgenv().__FridayGetThumb = function(uid)
            return cache[tonumber(uid)]
        end
        getgenv().__FridayRequestThumb = function(uid, cb)
            return Library:RequestThumbnail(uid, cb)
        end

        Library:Connect(Players.PlayerAdded, function(plr)
            Library:RequestThumbnail(plr.UserId)
        end)

        task.defer(function()
            Library:WarmAllThumbnails()
        end)
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Library.EscapePattern = function(self, String)
        local ShouldEscape = false 

        for Index, Value in SpecialCharacters do 
            if StringFind(String, Value) then 
                ShouldEscape = true
                break
            end
        end

        if ShouldEscape then
            return StringGSub(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
        end

        return String
    end

    Library.NextFlag = function(self)
        self.UnnamedFlags += 1
        return StringFormat("flag_number_%s", self.UnnamedFlags)
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                Item[Property] = self.Theme[Value]
            else
                Item[Property] = Value()
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

	Library.ToRich = function(self, Text, Color)
		return `<font color="rgb({MathFloor(Color.R * 255)}, {MathFloor(Color.G * 255)}, {MathFloor(Color.B * 255)})">{Text}</font>`
	end

    Library.GetConfig = function(self)
        local Config = { } 

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.Color, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then 
            delfile(Library.Folders.Configs .. "/" .. Config)
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local CurrentList = { }
        local List = { }

        local ConfigFolderName = StringGSub(Library.Folders.Configs, Library.Folders.Directory .. "/", "")

        for Index, Value in listfiles(Library.Folders.Configs) do
            local FileName = StringGSub(Value, Library.Folders.Directory .. "\\" .. ConfigFolderName .. "\\", "")
            List[Index] = FileName
        end

        local IsNew = #List ~= CurrentList

        if not IsNew then
            for Index = 1, #List do
                if List[Index] ~= CurrentList[Index] then
                    IsNew = true
                    break
                end
            end
        else
            CurrentList = List
            Element:Refresh(CurrentList)
        end
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.IsMouseOverFrame = function(self, Frame, XOffset, YOffset)
        Frame = Frame and (Frame.Instance or Frame)
        if not Frame then
            return false
        end

        XOffset = XOffset or 0 
        YOffset = YOffset or 0

        local Pos = Frame.AbsolutePosition
        local Size = Frame.AbsoluteSize
        if Size.X <= 0 or Size.Y <= 0 then
            return false
        end

        local function inside(x, y)
            x = x + XOffset
            y = y + YOffset
            return x >= Pos.X and x <= Pos.X + Size.X and y >= Pos.Y and y <= Pos.Y + Size.Y
        end

        return inside(Mouse.X, Mouse.Y)
    end

    Library.IsGuiActuallyVisible = function(self, Gui)
        Gui = Gui and (Gui.Instance or Gui)
        if not Gui or not Gui:IsA("GuiObject") then
            return false
        end

        local Current = Gui
        while Current and Current:IsA("GuiObject") do
            if Current.Visible ~= true then
                return false
            end
            Current = Current.Parent
        end

        return Library.WindowOpenState == true
    end

    Library.CloseOpenFrames = function(self)
        local Open = {}
        for _, Value in self.OpenFrames do
            Open[#Open + 1] = Value
        end
        for _, Value in Open do
            if Value and type(Value.SetOpen) == "function" then
                Value:SetOpen(false)
            end
        end
    end

    Library.Lerp = function(self, Start, Finish, Time)
        return Start + (Finish - Start) * Time
    end

    -- Components
    local Components = { } do
        Components.Window = function(self, Data)
            local Items = { } do
                Items["Window"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    AnchorPoint = Data.AnchorPoint,
                    Position = Data.Position,
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = Data.Size,
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(14, 17, 15)
                })  Items["Window"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

                if Data.Draggable then 
                    Items["Window"]:MakeDraggable()
                end

                if Data.Resizeable then 
                    Items["Window"]:MakeResizeable(Vector2New(Data.Size.X.Offset, Data.Size.Y.Offset), Vector2New(9999, 9999))
                end

                Items["UIStroke"] = Items["Window"]:Border("Outline")
            end

            return Items
        end

        Components.AutosizingLabel = function(self, Data)
            local Label = { } 

            local Items = { } do
                Items["Label"] = Instances:Create("TextLabel", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Text,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Label"]:AddToTheme({TextColor3 = "Text"})

                Items["UIStroke"] = Items["Label"]:TextBorder()
            end

            function Label:SetProperty(Property, Value)
                Items["Label"].Instance[Property] = Value
            end

            return Label, Items
        end

        Components.WindowPage = function(self, Data)
            local Page = {
                Active = false,
                SubPages = { },
                Items = { },
                Window = Data.Window,
                ColumnsData = { }
            }

            local Items = { } do
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 0.6000000238418579,
                    Size = UDim2New(1, 0, 0, 25),
                    BorderSizePixel = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(25, 30, 26)
                })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})

                Items["ButtonBorder"] = Instances:Create("UIStroke", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    Color = FromRGB(61, 60, 65),
                    Transparency = 0.6,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })  Items["ButtonBorder"]:AddToTheme({Color = "Outline"})

                Items["Liner"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(25, 30, 26)
                })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["TextStroke"] = Items["Text"]:TextBorder()

                Items["Glow"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 20, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(25, 30, 26)
                })  Items["Glow"]:AddToTheme({BackgroundColor3 = "Accent"})

                Items["GlowGradient"] = Instances:Create("UIGradient", {
                    Parent = Items["Glow"].Instance,
                    Name = "\0",
                    Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.193, 0.8687499761581421), NumSequenceKeypoint(0.504, 0.96875), NumSequenceKeypoint(1, 1)}
                })

                Items["Page"] = Instances:Create("Frame", {
                    Parent = Data.ContentHolder.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Visible = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                if Data.SubPages then
                    Items["SubPages"] = Instances:Create("Frame", {
                        Parent = Items["Page"].Instance,
                        Name = "\0",
                        Size = UDim2New(0, 0, 0, 35),
                        BorderColor3 = FromRGB(42, 49, 45),
                        BorderSizePixel = 2,
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundColor3 = FromRGB(20, 24, 21)
                    })  Items["SubPages"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Outline"})

                    Items["SubPages"]:Border("Border")

                    Instances:Create("UIPadding", {
                        Parent = Items["SubPages"].Instance,
                        Name = "\0",
                        PaddingRight = UDimNew(0, 7),
                        PaddingLeft = UDimNew(0, 7)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = Items["SubPages"].Instance,
                        Name = "\0",
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        FillDirection = Enum.FillDirection.Horizontal,
                        Padding = UDimNew(0, 12),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    Items["Columns"] = Instances:Create("Frame", {
                        Parent = Items["Page"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 0, 0, 51),
                        BorderColor3 = FromRGB(42, 49, 45),
                        Size = UDim2New(1, 0, 1, -51),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                else
                    Instances:Create("UIListLayout", {
                        Parent = Items["Page"].Instance,
                        Name = "\0",
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = UDimNew(0, 14),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    for Index = 1, Data.Columns do 
                        local NewColumn = Instances:Create("ScrollingFrame", {
                            Parent = Items["Page"].Instance,
                            Name = "\0",
                            ScrollBarImageColor3 = FromRGB(0, 0, 0),
                            Active = true,
                            AutomaticCanvasSize = Enum.AutomaticSize.Y,
                            ScrollBarThickness = 0,
                            BackgroundTransparency = 1,
                            Size = UDim2New(1, 0, 1, 0),
                            BackgroundColor3 = FromRGB(255, 255, 255),
                            BorderColor3 = FromRGB(0, 0, 0),
                            BorderSizePixel = 0,
                            CanvasSize = UDim2New(0, 0, 0, 0)
                        })

                        Instances:Create("UIPadding", {
                            Parent = NewColumn.Instance,
                            Name = "\0",
                            PaddingTop = UDimNew(0, 2),
                            PaddingBottom = UDimNew(0, 2),
                            PaddingRight = UDimNew(0, 2),
                            PaddingLeft = UDimNew(0, 2)
                        })

                        Instances:Create("UIListLayout", {
                            Parent = NewColumn.Instance,
                            Name = "\0",
                            Padding = UDimNew(0, 14),
                            SortOrder = Enum.SortOrder.LayoutOrder
                        })

                        Page.ColumnsData[Index] = NewColumn
                    end
                end

                Page.Items = Items
            end

            local Debounce = false

            function Page:Turn(Bool)
                Page.Active = Bool
                Items["Page"].Instance.Visible = Bool

                if Page.Active then
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 0})
                    Items["ButtonBorder"]:Tween(nil, {Transparency = 0})
                    Items["Glow"]:Tween(nil, {BackgroundTransparency = 0})
                    Items["Liner"]:Tween(nil, {BackgroundTransparency = 0})
                    Items["Text"]:Tween(nil, {Position = UDim2New(0, 13, 0.5, 0)})

                    Library.CurrentPage = Page
                else
                    Library:CloseOpenFrames()
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 0.6})
                    Items["ButtonBorder"]:Tween(nil, {Transparency = 0.6})
                    Items["Glow"]:Tween(nil, {BackgroundTransparency = 1})
                    Items["Liner"]:Tween(nil, {BackgroundTransparency = 1})
                    Items["Text"]:Tween(nil, {Position = UDim2New(0, 8, 0.5, 0)})
                end
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Data.Window.Pages do 
                    if Value == Page and Page.Active then
                        return
                    end

                    Value:Turn(Value == Page)
                end
            end)

            Items["Inactive"]:OnHover(function()
                Items["Inactive"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
                Items["Inactive"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
            end)

            Items["Inactive"]:OnHoverLeave(function()
                Items["Inactive"]:ChangeItemTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})
                Items["Inactive"]:Tween(nil, {BackgroundColor3 = Library.Theme["Page Background"]})
            end)

            if #Data.Window.Pages == 0 then 
                Page:Turn(true)
            end

            TableInsert(Data.Window.Pages, Page)
            return Page, Items 
        end

        Components.WindowSubPage = function(self, Data)
            local SubPage = {
                Active = false,
                ColumnsData = { }
            }

            local Items = { } do
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Data.Page.Items["SubPages"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 20),
                    BorderSizePixel = 2,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(25, 30, 26)
                })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})

                Items["ButtonBorder"] = Instances:Create("UIStroke", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    Color = FromRGB(61, 60, 65),
                    Transparency = 1,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })  Items["ButtonBorder"]:AddToTheme({Color = "Outline"})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Name,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, -5, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["TextStroke"] = Items["Text"]:TextBorder()

                Instances:Create("UIPadding", {
                    Parent = Items["Text"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 2),
                    PaddingLeft = UDimNew(0, 18),
                    PaddingRight = UDimNew(0, 12)
                })

                Items["Glow"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, -18, 0, -2),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 20, 1, 2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(202, 243, 255)
                })  Items["Glow"]:AddToTheme({BackgroundColor3 = "Accent"})

                Instances:Create("UIGradient", {
                    Parent = Items["Glow"].Instance,
                    Name = "\0",
                    Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.193, 0.8687499761581421), NumSequenceKeypoint(0.504, 0.96875), NumSequenceKeypoint(1, 1)}
                })

                Items["Liner"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, -18, 0, -2),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 1, 1, 2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(202, 243, 255)
                })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})

                Items["Page"] = Instances:Create("Frame", {
                    Parent = Data.Page.Items["Columns"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, -2, 0, -2),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 2, 1, 0),
                    BorderSizePixel = 0,
                    Visible = false,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 14),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                for Index = 1, Data.Columns do 
                    local NewColumn = Instances:Create("ScrollingFrame", {
                        Parent = Items["Page"].Instance,
                        Name = "\0",
                        ScrollBarImageColor3 = FromRGB(0, 0, 0),
                        Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        ScrollBarThickness = 0,
                        BackgroundTransparency = 1,
                        Size = UDim2New(1, 0, 1, 0),
                        BackgroundColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        CanvasSize = UDim2New(0, 0, 0, 0)
                    })

                    Instances:Create("UIPadding", {
                        Parent = NewColumn.Instance,
                        Name = "\0",
                        PaddingTop = UDimNew(0, 2),
                        PaddingBottom = UDimNew(0, 2),
                        PaddingRight = UDimNew(0, 2),
                        PaddingLeft = UDimNew(0, 2)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = NewColumn.Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 14),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    SubPage.ColumnsData[Index] = NewColumn
                end
            end

            Library.SearchItems[SubPage] = { }

            function SubPage:Turn(Bool)
                SubPage.Active = Bool
                Items["Page"].Instance.Visible = Bool

                if SubPage.Active then
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 0})
                    Items["ButtonBorder"]:Tween(nil, {Transparency = 0})
                    Items["Liner"]:Tween(nil, {BackgroundTransparency = 0})
                    Items["Glow"]:Tween(nil, {BackgroundTransparency = 0})
                    Items["Text"]:Tween(nil, {Position = UDim2New(0.5, 0, 0.5, 0)})

                    Library.CurrentPage = SubPage
                else
                    Library:CloseOpenFrames()
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 1})
                    Items["ButtonBorder"]:Tween(nil, {Transparency = 1})
                    Items["Liner"]:Tween(nil, {BackgroundTransparency = 1})
                    Items["Glow"]:Tween(nil, {BackgroundTransparency = 1})
                    Items["Text"]:Tween(nil, {Position = UDim2New(0.5, -5, 0.5, 0)})
                end
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Data.Page.SubPages do 
                    if Value == SubPage and SubPage.Active then
                        return
                    end

                    Value:Turn(Value == SubPage)
                end
            end)

            if #Data.Page.SubPages == 0 then 
                SubPage:Turn(true)
            end

            TableInsert(Data.Page.SubPages, SubPage)
            return SubPage
        end

        Components.Toggle = function(self, Data)
            local Toggle = {
                Value = false,
                Flag = Data.Flag
            }
            
            local Items = { } do
                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 12),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Indicator"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = UDim2New(0, 12, 0, 12),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(30, 36, 31)
                })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

                Instances:Create("UIStroke", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Instances:Create("UIGradient", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Rotation = -165,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(208, 208, 208))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme.Gradient)}
                end})

                Items["Check"] = Instances:Create("ImageLabel", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(0, 0, 0),
                    ScaleType = Enum.ScaleType.Fit,
                    ImageTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "rbxassetid://108016671469439",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(1, 2, 1, 2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 22, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["Text"]:TextBorder()

                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, Items["Text"].Instance.TextBounds.X + 30, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                if Data.Tooltip then
                    Items["TooltipThing"] = Instances:Create("TextLabel", {
                        Parent = Items["SubElements"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(235, 235, 235),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "(?)",
                        Size = UDim2New(0, 0, 0, 15),
                        AnchorPoint = Vector2New(0, 0.5),
                        Position = UDim2New(0, 22, 0.5, 0),
                        BackgroundTransparency = 1,
                        TextTransparency = 0.4,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.X,
                        TextSize = 12,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  Items["TooltipThing"]:AddToTheme({TextColor3 = "Text"})

                    Items["TooltipThing"]:TextBorder()

                    Items["TooltipThing"]:Tooltip({
                        Text = Data.Tooltip.Name or Data.Tooltip.Title,
                        Description = Data.Tooltip.Description
                    })
                end
            end
            
            function Toggle:Get()
                return Toggle.Value 
            end

            function Toggle:SetText(Text)
                Text = tostring(Text)
                Items["Text"].Instance.Text = Text
            end

            function Toggle:Set(Value)
                Toggle.Value = Value 
                Library.Flags[Toggle.Flag] = Value 

                local Instant = Library.Ready ~= true
                if Toggle.Value then
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent", BorderColor3 = "Border"})
                    if Instant then
                        Items["Indicator"].Instance.BackgroundColor3 = Library.Theme.Accent
                        Items["Check"].Instance.ImageTransparency = 0
                        Items["Check"].Instance.Size = UDim2New(1, 2, 1, 2)
                    else
                        Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                        Items["Check"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {ImageTransparency = 0, Size = UDim2New(1, 2, 1, 2)})
                    end
                else
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
                    if Instant then
                        Items["Indicator"].Instance.BackgroundColor3 = Library.Theme.Element
                        Items["Check"].Instance.ImageTransparency = 1
                        Items["Check"].Instance.Size = UDim2New(0, 0, 0, 0)
                    else
                        Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                        Items["Check"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {ImageTransparency = 1, Size = UDim2New(0, 0, 0, 0)})
                    end
                end

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Toggle.Value)
                end
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool
                Library:BumpLayout(Items["Toggle"].Instance)
            end

            local PageSearchData = Library.SearchItems[Data.Page]

            if PageSearchData then
                local SearchData = {
                    Element = Items["Toggle"],
                    Name = Data.Name,
                }

                TableInsert(PageSearchData, SearchData)
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Items["Toggle"]:OnHover(function()
                if Toggle.Value then 
                    return 
                end

                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
            end)

            Items["Toggle"]:OnHoverLeave(function()
                if Toggle.Value then 
                    return 
                end

                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
            end)

            Toggle:Set(Data.Default)

            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return Toggle, Items
        end

        Components.Button = function(self, Data)
            local Button = { }

            local Items = { } do
                Items["Button"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Button:Add(Name, Callback)
                local NewButton = { }

                local SubItems = { } do
                    SubItems["NewButton"] = Instances:Create("TextButton", {
                        Parent = Items["Button"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(0, 0, 0),
                        BorderColor3 = FromRGB(12, 12, 12),
                        Text = "",
                        AutoButtonColor = false,
                        Size = UDim2New(1, 0, 0, 20),
                        BorderSizePixel = 2,
                        TextSize = 14,
                        BackgroundColor3 = FromRGB(30, 36, 31)
                    })  SubItems["NewButton"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

                    Instances:Create("UIGradient", {
                        Parent = SubItems["NewButton"].Instance,
                        Name = "\0",
                        Rotation = -165,
                        Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(208, 208, 208))}
                    }):AddToTheme({Color = function()
                        return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme.Gradient)}
                    end})

                    Instances:Create("UIStroke", {
                        Parent = SubItems["NewButton"].Instance,
                        Name = "\0",
                        Color = FromRGB(42, 49, 45),
                        LineJoinMode = Enum.LineJoinMode.Miter,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }):AddToTheme({Color = "Outline"})

                    SubItems["Text"] = Instances:Create("TextLabel", {
                        Parent = SubItems["NewButton"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(235, 235, 235),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = Name,
                        BackgroundTransparency = 1,
                        Size = UDim2New(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        TextSize = 12,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  SubItems["Text"]:AddToTheme({TextColor3 = "Text"})

                    SubItems["Text"]:TextBorder()
                end

                function NewButton:Press()
                    SubItems["NewButton"]:ChangeItemTheme({BackgroundColor3 = "Accent", BorderColor3 = "Border"})
                    SubItems["NewButton"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})

                    Library:SafeCall(Callback)
                    task.wait(0.1)

                    SubItems["NewButton"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
                    SubItems["NewButton"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                end

                function NewButton:SetVisibility(Bool)
                    SubItems["NewButton"].Instance.Visible = Bool
                    Library:BumpLayout(SubItems["NewButton"].Instance)
                end

                local PageSearchData = Library.SearchItems[Data.Page]

                if PageSearchData then
                    local SearchData = {
                        Element = SubItems["NewButton"],
                        Name = Name,
                    }

                    TableInsert(PageSearchData, SearchData)
                end

                SubItems["NewButton"]:OnHover(function()
                    SubItems["NewButton"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
                    SubItems["NewButton"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                end)

                SubItems["NewButton"]:OnHoverLeave(function()
                    SubItems["NewButton"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
                    SubItems["NewButton"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                end)

                SubItems["NewButton"]:Connect("MouseButton1Down", function()
                    NewButton:Press()
                end)

                return NewButton 
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
                Library:BumpLayout(Items["Button"].Instance)
            end

            return Button, Items
        end

        Components.Slider = function(self, Data)
            Data = Data or { }
            Data.Decimals = Library:SliderStep(Data.Decimals)

            local Slider = {
                Value = 0,
                Flag = Data.Flag,
                Sliding = false
            }

            local Items = { } do
                Items["Slider"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 28),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["Text"]:TextBorder()

                Items["RealSlider"] = Instances:Create("TextButton", {
                    Parent = Items["Slider"].Instance,
                    AutoButtonColor = false,
                    Text = "",
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = UDim2New(1, 0, 0, 10),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(30, 36, 31)
                })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

                Instances:Create("UIGradient", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    Rotation = -165,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(208, 208, 208))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme.Gradient)}
                end})

                Instances:Create("UIStroke", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    Active = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0.5, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(202, 243, 255)
                })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})

                Instances:Create("UIGradient", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    Rotation = -165,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(208, 208, 208))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme.Gradient)}
                end})

                Items["Dragger"] = Instances:Create("Frame", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    Active = false,
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, 0, 0.5, 0),
                    BorderColor3 = FromRGB(42, 49, 45),
                    Size = UDim2New(0, 3, 1, 3),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(14, 17, 15)
                })  Items["Dragger"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = Items["Dragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "50%",
                    AnchorPoint = Vector2New(1, 0),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Value"]:AddToTheme({TextColor3 = "Text"})

                Items["Value"]:TextBorder()
            end

            function Slider:Get()
                return Slider.Value
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
                Library:BumpLayout(Items["Slider"].Instance)
            end

            function Slider:Set(Value)
                Value = tonumber(Value)
                if not Value or Value ~= Value then
                    Value = tonumber(Data.Default) or tonumber(Data.Min) or 0
                end

                local Min = tonumber(Data.Min) or 0
                local Max = tonumber(Data.Max) or 100
                if Max == Min then
                    Slider.Value = Min
                else
                    Slider.Value = Library:Round(MathClamp(Value, Min, Max), Data.Decimals)
                end

                if not Slider.Value or Slider.Value ~= Slider.Value then
                    Slider.Value = Min
                end

                Library.Flags[Slider.Flag] = Slider.Value

                local Scale = 0
                if Max ~= Min then
                    Scale = (Slider.Value - Min) / (Max - Min)
                    if Scale ~= Scale then
                        Scale = 0
                    end
                    Scale = MathClamp(Scale, 0, 1)
                end

                Items["Accent"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New(Scale, 0, 1, 0)})
                Items["Value"].Instance.Text = StringFormat("%s%s", tostring(Slider.Value), Data.Suffix or "")

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Slider.Value)
                end
            end

            local function pointerX(Input)
                if Input and Input.Position then
                    return Input.Position.X
                end
                return Mouse.X
            end

            local function applyFromX(X)
                local Inst = Items["RealSlider"].Instance
                local Width = Inst.AbsoluteSize.X
                if not Width or Width < 1 then
                    return
                end

                local SizeX = (X - Inst.AbsolutePosition.X) / Width
                if SizeX ~= SizeX then
                    return
                end

                Slider:Set(((Data.Max - Data.Min) * MathClamp(SizeX, 0, 1)) + Data.Min)
            end

            local function beginSlide(Input)
                Slider.Sliding = true
                applyFromX(pointerX(Input))
            end

            Items["RealSlider"]:Connect("MouseButton1Down", function()
                beginSlide()
            end)

            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    beginSlide(Input)
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Library.WindowOpenState ~= true then
                    return
                end

                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                if not Library:IsGuiActuallyVisible(Items["RealSlider"]) then
                    return
                end

                if not Library:IsMouseOverFrame(Items["RealSlider"]) then
                    return
                end

                beginSlide(Input)
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = false
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        applyFromX(pointerX(Input))
                    end
                end
            end)

            Items["Slider"]:OnHover(function()
                Items["RealSlider"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
                Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
            end)

            Items["Slider"]:OnHoverLeave(function()
                Items["RealSlider"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
                Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
            end)

            Slider:Set(tonumber(Data.Default) or tonumber(Data.Min) or 0)

            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return Slider, Items
        end

        Components.Label = function(self, Data)
            local Label = { }

            local Items = { } do
                Items["Label"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["Text"]:TextBorder()

                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, Items["Text"].Instance.TextBounds.X + 8, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Label:SetText(Text)
                Text = tostring(Text)

                Items["Text"].Instance.Text = Text
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
                Library:BumpLayout(Items["Label"].Instance)
            end

            return Label, Items 
        end

        Components.Dropdown = function(self, Data)
            local Dropdown = {
                Flag = Data.Flag, 
                Value = { },
                Options = { },
                IsOpen = false
            }

            local Items = { } do
                Items["Dropdown"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["Text"]:TextBorder()

                Items["RealDropdown"] = Instances:Create("TextButton", {
                    Parent = Items["Dropdown"].Instance,
                    AutoButtonColor = false,
                    Text = "",
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(30, 36, 31)
                })  Items["RealDropdown"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

                Instances:Create("UIGradient", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    Rotation = -165,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(208, 208, 208))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme.Gradient)}
                end})

                Instances:Create("UIStroke", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "--",
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(1, -25, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2New(0, 8, 0.5, 0),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Value"]:AddToTheme({TextColor3 = "Text"})

                Items["Value"]:TextBorder()

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(202, 243, 255),
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://113229176886493",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -2, 0.5, 0),
                    Size = UDim2New(0, 20, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Icon"]:AddToTheme({ImageColor3 = "Accent"})

                Items["OptionHolder"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BorderColor3 = FromRGB(12, 12, 12),
                    BorderSizePixel = 2,
                    Position = UDim2New(0, 0, 1, 8),
                    Size = UDim2New(1, 0, 0, 25),
                    ZIndex = 5,
                    ClipsDescendants = true,
                    BackgroundColor3 = FromRGB(20, 24, 21)
                })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border"})

                Instances:Create("UIStroke", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Instances:Create("UIPadding", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 5),
                    PaddingBottom = UDimNew(0, 5),
                    PaddingRight = UDimNew(0, 5),
                    PaddingLeft = UDimNew(0, 8)
                })

                Items["List"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    ScrollBarImageColor3 = FromRGB(202, 243, 255),
                    MidImage = "rbxassetid://136419474381965",
                    BorderColor3 = FromRGB(0, 0, 0),
                    ScrollBarThickness = 2,
                    Size = UDim2New(1, 0, 1, 0),
                    TopImage = "rbxassetid://136419474381965",
                    BottomImage = "rbxassetid://136419474381965",
                    BackgroundTransparency = 1,
                    ZIndex = 5,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["List"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

                Instances:Create("UIListLayout", {
                    Parent = Items["List"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 3),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Dropdown:Get()
                return Dropdown.Value
            end

            local RenderStepped
            local closeLock = false

            function Dropdown:SetOpen(Bool)
                if Bool ~= true and closeLock then
                    return
                end

                if Bool == true and not Library:IsGuiActuallyVisible(Items["RealDropdown"]) then
                    return
                end

                Dropdown.IsOpen = Bool == true

                if Dropdown.IsOpen then
                    closeLock = true
                    task.defer(function()
                        task.wait()
                        closeLock = false
                    end)
                    Items["OptionHolder"].Instance.Visible = true
                    Items["OptionHolder"].Instance.Parent = Library.Holder.Instance
                    Items["Icon"]:Tween(nil, {Rotation = -90})

                    if not RenderStepped then
                        RenderStepped = RunService.RenderStepped:Connect(function()
                            if not Library:IsGuiActuallyVisible(Items["RealDropdown"]) then
                                Dropdown:SetOpen(false)
                                return
                            end
                            local Count = 0
                            for _ in pairs(Dropdown.Options) do
                                Count += 1
                            end
                            local MaxVisible = 8
                            local VisibleCount = Count
                            if VisibleCount < 1 then
                                VisibleCount = 1
                            elseif VisibleCount > MaxVisible then
                                VisibleCount = MaxVisible
                            end
                            local Height = VisibleCount * 18 + 10
                            local Anchor = Items["RealDropdown"].Instance
                            local WindowFrame = Library.MainWindow
                            local MinX, MinY = 0, 0
                            local MaxX, MaxY = Library.Holder.Instance.AbsoluteSize.X, Library.Holder.Instance.AbsoluteSize.Y
                            if WindowFrame then
                                MinX, MinY = WindowFrame.AbsolutePosition.X, WindowFrame.AbsolutePosition.Y
                                MaxX = MinX + WindowFrame.AbsoluteSize.X
                                MaxY = MinY + WindowFrame.AbsoluteSize.Y
                            end
                            local Width = math.min(Anchor.AbsoluteSize.X, math.max(MaxX - MinX - 8, 1))
                            local X = math.clamp(Anchor.AbsolutePosition.X, MinX + 4, MaxX - Width - 4)
                            local BelowY = Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + 5
                            local AboveY = Anchor.AbsolutePosition.Y - Height - 5
                            local Y = BelowY
                            if Y + Height > MaxY - 4 then
                                Y = AboveY
                            end
                            Y = math.clamp(Y, MinY + 4, math.max(MinY + 4, MaxY - Height - 4))
                            Items["OptionHolder"].Instance.Position = UDim2New(0, X, 0, Y)
                            Items["OptionHolder"].Instance.Size = UDim2New(0, Width, 0, Height)
                            if Items["List"] and Items["List"].Instance then
                                local CanScroll = Count > MaxVisible
                                Items["List"].Instance.ScrollBarThickness = CanScroll and 2 or 0
                                Items["List"].Instance.ScrollingEnabled = CanScroll
                            end
                        end)
                    end

                    for Index, Value in Library.OpenFrames do
                        if Value ~= Dropdown then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown
                else
                    if Library.OpenFrames[Dropdown] then
                        Library.OpenFrames[Dropdown] = nil
                    end

                    if RenderStepped then
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end

                    Items["Icon"]:Tween(nil, {Rotation = 0})
                    Items["OptionHolder"].Instance.Visible = false
                    Items["OptionHolder"].Instance.Parent = Library.UnusedHolder.Instance
                end
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
                Library:BumpLayout(Items["Dropdown"].Instance)
            end

            function Dropdown:Set(Option)
                if Data.Multi then 
                    if type(Option) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Option do
                        local OptionData = Dropdown.Options[Value]
                        
                        if not OptionData then
                            continue
                        end

                        OptionData.Selected = true 
                        OptionData:Toggle("Active")
                    end

                    Items["Value"].Instance.Text = TableConcat(Option, ", ")
                else
                    if not Dropdown.Options[Option] then
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false 
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true 
                            Value:Toggle("Active")
                        end
                    end

                    Items["Value"].Instance.Text = Option
                end

                if Data.Callback then   
                    Library:SafeCall(Data.Callback, Dropdown.Value)
                end
            end

            function Dropdown:Add(Option)
                local OptionButton = Instances:Create("TextButton", {
                    Parent = (Items["List"] and Items["List"].Instance) or Items["OptionHolder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Option,
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2New(1, 0, 0, 15),
                    ZIndex = 5,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  OptionButton:AddToTheme({TextColor3 = "Text"})

                local OptionData = {
                    Button = OptionButton,
                    Name = Option,
                    Selected = false
                }

                function OptionData:Toggle(Status)
                    if Status == "Active" then 
                        OptionData.Button:ChangeItemTheme({TextColor3 = "Accent"})
                        OptionData.Button:Tween(nil, {TextColor3 = Library.Theme.Accent})
                    else
                        OptionData.Button:ChangeItemTheme({TextColor3 = "Text"}) 
                        OptionData.Button:Tween(nil, {TextColor3 = Library.Theme.Text})
                    end
                end

                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected

                    if Data.Multi then 
                        local Index = TableFind(Dropdown.Value, OptionData.Name)

                        if Index then 
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:Toggle(Index and "Inactive" or "Active")

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.Selected then 
                            Dropdown.Value = OptionData.Name
                            Library.Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.Selected = true
                            OptionData:Toggle("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.Selected = false 
                                    Value:Toggle("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil

                            OptionData.Selected = false
                            OptionData:Toggle("Inactive")

                            Items["Value"].Instance.Text = "--"
                        end
                    end

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Dropdown.Value)
                    end
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if not Dropdown.Options[Option] then
                    return
                end

                Dropdown.Options[Option].Button:Clean()
                Dropdown.Options[Option] = nil
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Items["Dropdown"]:OnHover(function()
                Items["RealDropdown"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
            end)

            Items["Dropdown"]:OnHoverLeave(function()
                Items["RealDropdown"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Dropdown.IsOpen or closeLock then
                        return 
                    end

                    if Library:IsMouseOverFrame(Items["OptionHolder"]) or Library:IsMouseOverFrame(Items["RealDropdown"]) then 
                        return
                    end

                    Dropdown:SetOpen(false)
                end
            end)

            for Index, Value in Data.Items do 
                Dropdown:Add(Value)
            end

            if Data.Default then 
                Dropdown:Set(Data.Default)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return Dropdown, Items 
        end

        Components.ColorpickerTab = function(self, Data)
            if not Data.Pages then 
                return
            end

            local NewTab = { 
                Name = Data.Name,
                Active = false
            }

            local Items = { } do
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Data.PageHolder.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = NewTab.Name,
                    AutoButtonColor = false,
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(20, 24, 21)
                })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Inline"})

                Items["Inactive"]:TextBorder()

                Items["PageContent"] = Instances:Create("Frame", {
                    Parent = Data.ContentHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
            end

            function NewTab:Turn(Bool)
                NewTab.Active = Bool 

                if NewTab.Active then
                    Items["PageContent"].Instance.Visible = true 
                    Items["PageContent"].Instance.Parent = Data.ContentHolder.Instance 

                    Items["Inactive"]:ChangeItemTheme({BackgroundColor3 = "Background"})
                    Items["Inactive"]:Tween(nil, {BackgroundColor3 = Library.Theme.Background})
                else
                    Items["PageContent"].Instance.Visible = false
                    Items["PageContent"].Instance.Parent = Library.UnusedHolder.Instance 

                    Items["Inactive"]:ChangeItemTheme({BackgroundColor3 = "Inline"})
                    Items["Inactive"]:Tween(nil, {BackgroundColor3 = Library.Theme.Inline})
                end
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Data.Stack do 
                    Value:Turn(Value == NewTab)
                end
            end)

            if #Data.Stack == 0 then 
                NewTab:Turn(true)
            end

            TableInsert(Data.Stack, NewTab)
            return NewTab, Items 
        end

        Components.CreateSubPaletteItems = function(self, Items)
            Items["ColorpickerWindow"].Instance.Size = UDim2New(0, 171, 0, 168)

            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(42, 49, 45),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 8, 0, 8),
                Size = UDim2New(1, -41, 1, -41),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(157, 175, 255)
            })  Items["Palette"]:AddToTheme({BorderColor3 = "Outline"})

            Instances:Create("UIStroke", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Color = FromRGB(12, 12, 12),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Saturation"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Saturation"),
                Active = false,
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Value"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 2, 1, 0),
                Image = Library:GetImage("Value"),
                Active = false,
                BackgroundTransparency = 1,
                Position = UDim2New(0, -1, 0, 0),
                ZIndex = 3,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Active = false,
                Position = UDim2New(0, 8, 0, 8),
                ZIndex = 5,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 2, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0",
                Color = FromRGB(12, 12, 12),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Hue"] = Instances:Create("Frame", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                Active = true,
                BorderColor3 = FromRGB(42, 49, 45),
                AnchorPoint = Vector2New(1, 0),
                Position = UDim2New(1, -8, 0, 8),
                Size = UDim2New(0, 15, 1, -16),
                Selectable = true,
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Hue"]:AddToTheme({BorderColor3 = "Outline"})

            Instances:Create("UIStroke", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                Color = FromRGB(12, 12, 12),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["HueInline"] = Instances:Create("TextButton", {
                Parent = Items["Hue"].Instance,
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIGradient", {
                Parent = Items["HueInline"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
            })

            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0",
                Color = FromRGB(12, 12, 12),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Alpha"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(42, 49, 45),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 8, 1, -8),
                Size = UDim2New(1, -41, 0, 15),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(157, 175, 255)
            })  Items["Alpha"]:AddToTheme({BorderColor3 = "Outline"})

            Instances:Create("UIStroke", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                Color = FromRGB(12, 12, 12),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["Checkers"] = Instances:Create("ImageLabel", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                ScaleType = Enum.ScaleType.Tile,
                BorderColor3 = FromRGB(0, 0, 0),
                TileSize = UDim2New(0, 6, 0, 6),
                Image = Library:GetImage("Checkers"),
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  

            Instances:Create("UIGradient", {
                Parent = Items["Checkers"].Instance,
                Name = "\0",
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(0.37, 0.5), NumSequenceKeypoint(1, 0)}
            })

            Items["AlphaDragger"] = Instances:Create("Frame", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                ZIndex = 5,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 1, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIStroke", {
                Parent = Items["AlphaDragger"].Instance,
                Name = "\0",
                Color = FromRGB(12, 12, 12),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
        end

        Components.Colorpicker = function(self, Data) -- poetry warning (╯°□°)╯
            local Colorpicker = {
                IsOpen = false,

                Hue = 0,
                Saturation = 0,
                Value = 0,
                Alpha = 0,

                Color = FromRGB(255, 255, 255),
                HexValue = "#ffffff",

                Pages = Data.Pages and { } or nil,
                Flag = Data.Flag,
            }

            local UpdateSync

            local Items = { } do
                Items["ColorpickerButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2New(0, -123, 0, 0),
                    Size = UDim2New(0, 15, 0, 15),
                    BorderSizePixel = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(157, 175, 255)
                })  Items["ColorpickerButton"]:AddToTheme({BorderColor3 = "Border"})

                Instances:Create("UIStroke", {
                    Parent = Items["ColorpickerButton"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Items["ColorpickerButtonInline"] = Instances:Create("Frame", {
                    Parent = Items["ColorpickerButton"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(157, 175, 255)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["ColorpickerButtonInline"].Instance,
                    Name = "\0",
                    Rotation = -165,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(208, 208, 208))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme.Gradient)}
                end})

                Items["ColorpickerWindow"] = Instances:Create("TextButton", {
                    Parent = Library.UnusedHolder.Instance,
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    Position = UDim2New(0, 12, 0, 12),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = UDim2New(0, 266, 0, 258),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(14, 17, 15)
                })  Items["ColorpickerWindow"]:AddToTheme({BorderColor3 = "Border", BackgroundColor3 = "Background"})

                Instances:Create("UIStroke", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                if Data.Pages then 
                    Items["Pages"] = Instances:Create("Frame", {
                        Parent = Items["ColorpickerWindow"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(1, 0, 0, 20),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = Items["Pages"].Instance,
                        Name = "\0",
                        FillDirection = Enum.FillDirection.Horizontal,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill
                    })

                    Items["Content"] = Instances:Create("Frame", {
                        Parent = Items["ColorpickerWindow"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 0, 0, 25),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(1, 0, 1, -25),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                else
                    Components:CreateSubPaletteItems(Items)
                end
            end

            local ColorTab, ColorTabItems = Components:ColorpickerTab({
                ContentHolder = Items["Content"],
                Pages = Colorpicker.Pages,
                PageHolder = Items["Pages"],
                Stack = Colorpicker.Pages,
                Name = "Color"
            })

            local AnimationsTab, AnimationsTabItems = Components:ColorpickerTab({
                ContentHolder = Items["Content"],
                Pages = Colorpicker.Pages,
                PageHolder = Items["Pages"],
                Stack = Colorpicker.Pages,
                Name = "Animations"
            })

            local OtherTab, OtherTabItems = Components:ColorpickerTab({
                ContentHolder = Items["Content"],
                Pages = Colorpicker.Pages,
                PageHolder = Items["Pages"],
                Stack = Colorpicker.Pages,
                Name = "Other"
            })

            local OldColor = Colorpicker.Color
            local OldAlpha = Colorpicker.Alpha
            local CurrentAnimation

            local AnimationsDropdown, AnimationsDropdownItems
            local KeyframeOneLabel, KeyframeOneLabelItems
            local KeyframeTwoLabel, KeyframeTwoLabelItems

            local KeyframeOneColorpicker, KeyframeOneColorpickerItems
            local KeyframeTwoColorpicker, KeyframeTwoColorpickerItems

            local AnimationSpeedSlider, AnimationSpeedSliderItems

            if ColorTab then
                Items["Palette"] = Instances:Create("TextButton", {
                    Parent = ColorTabItems["PageContent"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(42, 49, 45),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2New(0, 8, 0, 8),
                    Size = UDim2New(1, -46, 1, -46),
                    BorderSizePixel = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(157, 175, 255)
                })  Items["Palette"]:AddToTheme({BorderColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["Saturation"] = Instances:Create("ImageLabel", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = Library:GetImage("Saturation"),
                    Active = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Value"] = Instances:Create("ImageLabel", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 2, 1, 0),
                    Image = Library:GetImage("Value"),
                    Active = false,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, -1, 0, 0),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["PaletteDragger"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    Active = false,
                    Position = UDim2New(0, 8, 0, 8),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 2, 0, 2),
                    BorderSizePixel = 0,
                    ZIndex = 5,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["PaletteDragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["Hue"] = Instances:Create("Frame", {
                    Parent = ColorTabItems["PageContent"].Instance,
                    Name = "\0",
                    Active = true,
                    BorderColor3 = FromRGB(42, 49, 45),
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, -8, 0, 8),
                    Size = UDim2New(0, 20, 1, -16),
                    Selectable = true,
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Hue"]:AddToTheme({BorderColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["HueInline"] = Instances:Create("TextButton", {
                    Parent = Items["Hue"].Instance,
                    AutoButtonColor = false,
                    Text = "",
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["HueInline"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
                })

                Items["HueDragger"] = Instances:Create("Frame", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["HueDragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["Alpha"] = Instances:Create("TextButton", {
                    Parent = ColorTabItems["PageContent"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(42, 49, 45),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 8, 1, -8),
                    Size = UDim2New(1, -46, 0, 20),
                    BorderSizePixel = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(157, 175, 255)
                })  Items["Alpha"]:AddToTheme({BorderColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = Items["Alpha"].Instance,   
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Items["Checkers"] = Instances:Create("ImageLabel", {
                    Parent = Items["Alpha"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Tile,
                    BorderColor3 = FromRGB(0, 0, 0),
                    TileSize = UDim2New(0, 6, 0, 6),
                    Image = Library:GetImage("Checkers"),
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  

                Instances:Create("UIGradient", {
                    Parent = Items["Checkers"].Instance,
                    Name = "\0",
                    Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(0.37, 0.5), NumSequenceKeypoint(1, 0)}
                })

                Items["AlphaDragger"] = Instances:Create("Frame", {
                    Parent = Items["Alpha"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 1, 1, 0),
                    ZIndex = 5,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["AlphaDragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
            end

            if AnimationsTab then
                AnimationsDropdown, AnimationsDropdownItems = Components:Dropdown({
                    Parent = AnimationsTabItems["PageContent"],
                    Name = "Animations",
                    Items = {"Rainbow", "Fade", "Fade alpha", "Linear"},
                    Default = nil,
                    Flag = Colorpicker.Flag.."Animation",
                    Multi = false,
                    Debounce = Colorpicker,
                    Callback = function(Value)
                        CurrentAnimation = Value
                        if Value == "Rainbow" then 
                            if KeyframeOneLabel and KeyframeTwoLabel and AnimationSpeedSlider then
                                KeyframeOneLabel:SetVisibility(false)
                                KeyframeTwoLabel:SetVisibility(false)

                                AnimationSpeedSliderItems["Slider"].Instance.Position = UDim2New(0, 8, 0, 45)
                            end

                            OldColor = Colorpicker.Color

                            Library:Thread(function()
                                while task.wait() do 
                                    local RainbowHue = MathAbs(MathSin(tick() * (AnimationSpeedSlider.Value / 25)))
                                    local Color = FromHSV(RainbowHue, 1, 1)

                                    Colorpicker:Set(Color, Colorpicker.Alpha)
                                    UpdateSync(true)

                                    if CurrentAnimation ~= "Rainbow" then
                                        Colorpicker:Set(OldColor, Colorpicker.Alpha)
                                        break
                                    end
                                end
                            end)
                        elseif Value == "Fade" then 
                            if KeyframeOneLabel and KeyframeTwoLabel and AnimationSpeedSlider then
                                KeyframeOneLabel:SetVisibility(true)
                                KeyframeTwoLabel:SetVisibility(false)

                                AnimationSpeedSliderItems["Slider"].Instance.Position = UDim2New(0, 8, 0, 65)

                                OldColor = Colorpicker.Color
                                
                                Library:Thread(function()
                                    while task.wait() do 
                                        local Speed = MathAbs(MathSin(tick() * (AnimationSpeedSlider.Value / 25)))
                                        Colorpicker:Set(KeyframeOneColorpicker.Color:Lerp(FromRGB(0, 0, 0), Speed), Colorpicker.Alpha)
                                        UpdateSync(true)

                                        if CurrentAnimation ~= "Fade" then
                                            Colorpicker:Set(OldColor, Colorpicker.Alpha)
                                            break
                                        end
                                    end
                                end)
                            end
                        elseif Value == "Fade alpha" then
                            if KeyframeOneLabel and KeyframeTwoLabel then
                                KeyframeOneLabel:SetVisibility(false)
                                KeyframeTwoLabel:SetVisibility(false)

                                AnimationSpeedSliderItems["Slider"].Instance.Position = UDim2New(0, 8, 0, 45)

                                OldColor = Colorpicker.Alpha
                                
                                Library:Thread(function()
                                    while task.wait() do 
                                        local AlphaValue = MathAbs(MathSin(tick() * (AnimationSpeedSlider.Value / 25)))
                                        Colorpicker:Set(Colorpicker.Color, AlphaValue)
                                        UpdateSync(true)

                                        if CurrentAnimation ~= "Fade alpha" then
                                            Colorpicker:Set(Colorpicker.Color, OldAlpha)
                                            break
                                        end
                                    end
                                end)
                            end
                        elseif Value == "Linear" then
                            if KeyframeOneLabel and KeyframeTwoLabel then
                                KeyframeOneLabel:SetVisibility(true)
                                KeyframeTwoLabel:SetVisibility(true)

                                AnimationSpeedSliderItems["Slider"].Instance.Position = UDim2New(0, 8, 0, 85)

                                OldColor = Colorpicker.Color
                                
                                Library:Thread(function()
                                    while task.wait() do 
                                        local Speed = MathAbs(MathSin(tick() * (AnimationSpeedSlider.Value / 25)))
                                        Colorpicker:Set(KeyframeOneColorpicker.Color:Lerp(KeyframeTwoColorpicker.Color, Speed), Colorpicker.Alpha)
                                        UpdateSync(true)

                                        if CurrentAnimation ~= "Linear" then
                                            Colorpicker:Set(OldColor, Colorpicker.Alpha)
                                            break
                                        end
                                    end
                                end)
                            end
                        end
                    end
                })

                AnimationsDropdownItems["Dropdown"].Instance.Position = UDim2New(0, 8, 0, 0)
                AnimationsDropdownItems["Dropdown"].Instance.Size = UDim2New(1, -16, 0, 40)

                KeyframeOneLabel, KeyframeOneLabelItems = Components:Label({
                    Parent = AnimationsTabItems["PageContent"],
                    Name = "Keyframe 1",
                })

                KeyframeOneLabelItems["Label"].Instance.Position = UDim2New(0, 8, 0, 45)
                KeyframeOneLabelItems["Label"].Instance.Size = UDim2New(1, -16, 0, 20)

                KeyframeTwoLabel, KeyframeTwoLabelItems = Components:Label({
                    Parent = AnimationsTabItems["PageContent"],
                    Name = "Keyframe 2",
                })

                KeyframeTwoLabelItems["Label"].Instance.Position = UDim2New(0, 8, 0, 65)
                KeyframeTwoLabelItems["Label"].Instance.Size = UDim2New(1, -16, 0, 20)

                KeyframeOneColorpicker, KeyframeOneColorpickerItems = Components:Colorpicker({
                    Parent = KeyframeOneLabelItems["SubElements"],
                    Alpha = 0,
                    Pages = false,
                    Default = Color3.fromRGB(255, 255, 255),
                    Flag = Colorpicker.Flag.."Animation".."Keyframe1",
                    Debounce = Colorpicker,
                })

                KeyframeTwoColorpicker, KeyframeTwoColorpickerItems = Components:Colorpicker({
                    Parent = KeyframeTwoLabelItems["SubElements"],
                    Alpha = 0,
                    Pages = false,
                    Default = Color3.fromRGB(0, 0, 0),
                    Debounce = Colorpicker,
                    Flag = Colorpicker.Flag.."Animation".."Keyframe2",
                })

                AnimationSpeedSlider, AnimationSpeedSliderItems = Components:Slider({
                    Parent = AnimationsTabItems["PageContent"],
                    Name = "Speed",
                    Flag = Colorpicker.Flag .. "AnimationSpeed",
                    Min = 0,
                    Max = 100,
                    Decimals = 0.1,
                    Default = 20,
                    Suffix = "%",
                })

                AnimationSpeedSliderItems["Slider"].Instance.Position = UDim2New(0, 8, 0, 85)
                AnimationSpeedSliderItems["Slider"].Instance.Size = UDim2New(1, -16, 0, 28)
            end

            local IsSyncToggled

            if OtherTab then
                Items["CurrentColor"] = Instances:Create("Frame", {
                    Parent = OtherTabItems["PageContent"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 8, 0, 8),
                    BorderColor3 = FromRGB(42, 49, 45),
                    Size = UDim2New(1, -16, 0, 50),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(157, 175, 255)
                })  Items["CurrentColor"]:AddToTheme({BorderColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = Items["CurrentColor"].Instance,
                    Name = "\0",
                    Color = FromRGB(12, 12, 12),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})

                Instances:Create("UIGradient", {
                    Parent = Items["CurrentColor"].Instance,
                    Name = "\0",
                    Rotation = 82,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(154, 154, 154))}
                })

                Items["RGBColor"] = Instances:Create("TextLabel", {
                    Parent = OtherTabItems["PageContent"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "RGB:",
                    Size = UDim2New(1, -16, 0, 15),
                    Position = UDim2New(0, 8, 0, 65),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    RichText = true,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["HEXColor"] = Instances:Create("TextLabel", {
                    Parent = OtherTabItems["PageContent"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "HEX:",
                    Size = UDim2New(1, -16, 0, 15),
                    Position = UDim2New(0, 8, 0, 85),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    RichText = true,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["HSVColor"] = Instances:Create("TextLabel", {
                    Parent = OtherTabItems["PageContent"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "HSV:",
                    Size = UDim2New(1, -16, 0, 15),
                    Position = UDim2New(0, 8, 0, 105),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    RichText = true,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                local CopyNPasteButton, CopyNPasteButtonItems = Components:Button({
                    Parent = OtherTabItems["PageContent"],
                })

                CopyNPasteButtonItems["Button"].Instance.Position = UDim2New(0, 8, 0, 145)
                CopyNPasteButtonItems["Button"].Instance.Size = UDim2New(1, -16, 0, 20)

                CopyNPasteButton:Add("Copy", function()
                    Library.CopiedColor = Colorpicker.Color
                end)

                CopyNPasteButton:Add("Paste", function()
                    if Library.CopiedColor then
                        Colorpicker:Set(Library.CopiedColor)
                    end
                end)

                local Stash = { }

                IsSyncToggled = false

                local SyncColorpickersToggle, SyncColorpickerToggleItems = Components:Toggle({
                    Parent = OtherTabItems["PageContent"],
                    Flag = "SyncColorpickers"..Colorpicker.Flag,
                    Name = "Sync colorpickers",
                    Default = false,
                    Callback = function(Value)
                        IsSyncToggled = Value
                        if Value then 
                            for Index, Value in Library.Colorpickers do 
                                Stash[Value] = Value.Color
                                Value:Set(Colorpicker.Color)
                            end
                        else
                            for Index, Value in Library.Colorpickers do 
                                if Stash[Value] then
                                    Value:Set(Stash[Value])
                                end
                            end
                        end
                    end
                })

                SyncColorpickerToggleItems["Toggle"].Instance.Position = UDim2New(0, 8, 0, 125)
                SyncColorpickerToggleItems["Toggle"].Instance.Size = UDim2New(1, -16, 0, 12)
            end

            local RenderStepped
            local closeLock = false

            function Colorpicker:SetOpen(Bool)
                if Bool ~= true and closeLock then
                    return
                end

                if Bool == true and not Library:IsGuiActuallyVisible(Items["ColorpickerButton"]) then
                    return
                end

                Colorpicker.IsOpen = Bool == true

                if Colorpicker.IsOpen then
                    closeLock = true
                    task.defer(function()
                        task.wait()
                        closeLock = false
                    end)
                    Items["ColorpickerWindow"].Instance.Visible = true
                    Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance

                    if not RenderStepped then
                        RenderStepped = RunService.RenderStepped:Connect(function()
                            if not Library:IsGuiActuallyVisible(Items["ColorpickerButton"]) then
                                Colorpicker:SetOpen(false)
                                return
                            end
                            local Popup = Items["ColorpickerWindow"].Instance
                            local Anchor = Items["ColorpickerButton"].Instance
                            local Bounds = Library.MainWindow
                            local MinX, MinY = Bounds.AbsolutePosition.X, Bounds.AbsolutePosition.Y
                            local MaxX = MinX + Bounds.AbsoluteSize.X
                            local MaxY = MinY + Bounds.AbsoluteSize.Y
                            local X = math.clamp(Anchor.AbsolutePosition.X, MinX + 4, math.max(MinX + 4, MaxX - Popup.AbsoluteSize.X - 4))
                            local Y = Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + 5
                            if Y + Popup.AbsoluteSize.Y > MaxY - 4 then
                                Y = Anchor.AbsolutePosition.Y - Popup.AbsoluteSize.Y - 5
                            end
                            Y = math.clamp(Y, MinY + 4, math.max(MinY + 4, MaxY - Popup.AbsoluteSize.Y - 4))
                            Popup.Position = UDim2New(0, X, 0, Y)
                        end)
                    end

                    if not Data.Debounce then
                        for Index, Value in Library.OpenFrames do
                            if Value ~= Colorpicker and Value ~= AnimationsDropdownItems then
                                Value:SetOpen(false)
                            end
                        end

                        Library.OpenFrames[Colorpicker] = Colorpicker
                    end
                else
                    if not Data.Debounce then
                        if Library.OpenFrames[Colorpicker] then
                            Library.OpenFrames[Colorpicker] = nil
                        end
                    end

                    if RenderStepped then
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end

                    Items["ColorpickerWindow"].Instance.Visible = false
                    Items["ColorpickerWindow"].Instance.Parent = Library.UnusedHolder.Instance
                end
            end

            UpdateSync = function(Bool)
                if IsSyncToggled and Bool then 
                    for Index, Value in Library.Colorpickers do 
                        if Value ~= Colorpicker and not StringFind(Value.Flag, "Theme") then
                            Value:Set(Colorpicker.Color)
                        end
                    end
                end
            end

            function Colorpicker:Update(IsFromAlpha, UpdateSyncc)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = FromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()

                Library.Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = Colorpicker.HexValue
                }

                Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
                Items["ColorpickerButtonInline"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})

                UpdateSync(UpdateSyncc)

                if OtherTab then
                    Items["CurrentColor"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})

                    local Red = MathFloor(Colorpicker.Color.R * 255)
                    local Green = MathFloor(Colorpicker.Color.G * 255)
                    local Blue = MathFloor(Colorpicker.Color.B * 255)
                    local RedGreenBlue = tostring(Red) .. ", " .. tostring(Green) .. ", " .. tostring(Blue)

                    local FloorHue, FloorSat, FloorVal = Library:Round(Hue, 0.01), Library:Round(Saturation, 0.01), Library:Round(Value, 0.01)

                    Items["RGBColor"].Instance.Text = "RGB: " .. Library:ToRich(RedGreenBlue, Colorpicker.Color)
                    Items["HSVColor"].Instance.Text = `HSV: %{Library:ToRich(FloorHue, Colorpicker.Color)}, %{Library:ToRich(FloorSat, Colorpicker.Color)}, %{Library:ToRich(FloorVal, Colorpicker.Color)}`
                    Items["HEXColor"].Instance.Text = "HEX: " .. "#" .. Library:ToRich(Colorpicker.HexValue, Colorpicker.Color)
                end

                Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})

                if not IsFromAlpha then 
                    Items["Alpha"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
                end

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            function Colorpicker:Set(Color, Alpha)
                if type(Color) == "table" then
                    Color = FromRGB(Color[1], Color[2], Color[3])
                    Alpha = Color[4]
                elseif type(Color) == "string" then
                    Color = FromHex(Color)
                end 

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0  

                local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.99)
                local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.99)

                local AlphaPositionX = MathClamp(Colorpicker.Alpha, 0, 0.995)
                    
                local HuePositionY = MathClamp(Colorpicker.Hue, 0, 0.995)

                Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)})
                Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, HuePositionY, 0)})
                Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(AlphaPositionX, 0, 0, 0)})
                Colorpicker:Update(true, true)
            end

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)

            local SlidingPalette = false
            local PaletteChanged
            
            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end

                local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY

                local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.99)
                local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.99)

                Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
                Colorpicker:Update(false, true)
            end
            
            local SlidingHue = false
            local HueChanged

            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end
                
                local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Hue = ValueY

                local SlideY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.995)

                Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, SlideY, 0)})
                Colorpicker:Update(false, true)
            end

            local SlidingAlpha = false 
            local AlphaChanged

            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then
                    return
                end

                local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)

                Colorpicker.Alpha = ValueX

                local SlideX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.995)

                Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0, 0)})
                Colorpicker:Update(true, true)
            end

            Items["Palette"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingPalette = true 

                    Colorpicker:SlidePalette(Input)

                    if PaletteChanged then
                        return
                    end

                    PaletteChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingPalette = false

                            PaletteChanged:Disconnect()
                            PaletteChanged = nil
                        end
                    end)
                end
            end)

            Items["HueInline"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingHue = true 

                    Colorpicker:SlideHue(Input)

                    if HueChanged then
                        return
                    end

                    HueChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingHue = false

                            HueChanged:Disconnect()
                            HueChanged = nil
                        end
                    end)
                end
            end)

            Items["Alpha"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingAlpha = true 

                    Colorpicker:SlideAlpha(Input)

                    if AlphaChanged then
                        return
                    end

                    AlphaChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingAlpha = false

                            AlphaChanged:Disconnect()
                            AlphaChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement then
                    if SlidingPalette then 
                        Colorpicker:SlidePalette(Input)
                    end

                    if SlidingHue then
                        Colorpicker:SlideHue(Input)
                    end

                    if SlidingAlpha then
                        Colorpicker:SlideAlpha(Input)
                    end
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Colorpicker.IsOpen or closeLock then
                        return
                    end

                    if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) or Library:IsMouseOverFrame(Items["ColorpickerButton"]) then
                        return
                    end

                    if KeyframeOneLabel and KeyframeTwoLabel then
                        if Library:IsMouseOverFrame(KeyframeOneColorpickerItems["ColorpickerWindow"]) then
                            return
                        end

                        if Library:IsMouseOverFrame(KeyframeTwoColorpickerItems["ColorpickerWindow"]) then
                            return
                        end
                    end

                    Colorpicker:SetOpen(false)
                end
            end)

            if Data.Default then
                Colorpicker:Set(Data.Default, Data.Alpha)
                OldColor = Colorpicker.Color
            end

            Library.Colorpickers[Colorpicker] = Colorpicker

            Library.SetFlags[Colorpicker.Flag] = function(Value, Alpha)
                Colorpicker:Set(Value, Alpha)
            end

            return Colorpicker, Items
        end

        Components.Keybind = function(self, Data)
            local Keybind = { 
                IsOpen = false,

                Key = "",
                Value = "",

                Flag = Data.Flag,

                Mode = "",

                Toggled = false,

                Picking = false
            }

            local KeylistItem

            if Library.KeyList and Data.List ~= false then
                KeylistItem = Library.KeyList:Add("", "", "")
            end

            local Items = { } do
                Items["KeyButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    TextTransparency = 0.4000000059604645,
                    Text = "None",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 18, 1, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["KeyButton"]:AddToTheme({TextColor3 = "Text"})
                
                Items["KeyButton"]:TextBorder()
                
                Items["KeybindWindow"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Position = UDim2New(0.007692307699471712, 0, 0.35323384404182434, 0),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = UDim2New(0, 70, 0, 90),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(14, 17, 15)
                })  Items["KeybindWindow"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Toggle",
                    AutoButtonColor = false,
                    Position = UDim2New(0, 8, 0, 8),
                    Size = UDim2New(1, -16, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(202, 243, 255)
                })  Items["Toggle"]:AddToTheme({BackgroundColor3 = "Accent", TextColor3 = "Text"})

                Items["Toggle"]:TextBorder()

                Instances:Create("UIStroke", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Items["Hold"] = Instances:Create("TextButton", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Hold",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0, 38),
                    Size = UDim2New(1, -16, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(202, 243, 255)
                })  Items["Hold"]:AddToTheme({BackgroundColor3 = "Accent", TextColor3 = "Text"})

                Items["Hold"]:TextBorder()

                Items["Always"] = Instances:Create("TextButton", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Always",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0, 68),
                    Size = UDim2New(1, -16, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(202, 243, 255)
                })  Items["Always"]:AddToTheme({BackgroundColor3 = "Accent", TextColor3 = "Text"})  

                Items["Always"]:TextBorder()
            end

            local Modes = {
                ["Toggle"] = Items["Toggle"],
                ["Hold"] = Items["Hold"],
                ["Always"] = Items["Always"]
            }

            local Update = function()
                if KeylistItem then
                    KeylistItem:SetText(Keybind.Value, Data.Name, Keybind.Mode)
                    KeylistItem:SetStatus(Keybind.Toggled)
                end
            end

            function Keybind:Get()
                return Keybind.Key, Keybind.Mode, Keybind.Toggled
            end

            function Keybind:Set(Key)
                if TableFind({"Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode(Keybind.Mode)

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                    Keybind.Picking = false
                    return
                end

                local RawKey = Key
                if type(Key) == "table" then
                    RawKey = Key.Key

                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode(Key.Mode)
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode("Toggle")
                    end
                end

                local Stored, Display = FormatKey(RawKey)
                Keybind.Key = Stored
                Keybind.Value = Display
                Items["KeyButton"].Instance.Text = Display ~= "" and Display or "None"

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
                Keybind.Picking = false
            end

            local RenderStepped
            local closeLock = false

            function Keybind:SetOpen(Bool)
                if Bool ~= true and closeLock then
                    return
                end

                if Bool == true and not Library:IsGuiActuallyVisible(Items["KeyButton"]) then
                    return
                end

                Keybind.IsOpen = Bool == true

                if Keybind.IsOpen then
                    closeLock = true
                    task.defer(function()
                        task.wait()
                        closeLock = false
                    end)
                    Items["KeybindWindow"].Instance.Visible = true
                    Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance

                    if not RenderStepped then
                        RenderStepped = RunService.RenderStepped:Connect(function()
                            if not Library:IsGuiActuallyVisible(Items["KeyButton"]) then
                                Keybind:SetOpen(false)
                                return
                            end
                            local Popup = Items["KeybindWindow"].Instance
                            local Anchor = Items["KeyButton"].Instance
                            local Bounds = Library.MainWindow
                            local MinX, MinY = Bounds.AbsolutePosition.X, Bounds.AbsolutePosition.Y
                            local MaxX = MinX + Bounds.AbsoluteSize.X
                            local MaxY = MinY + Bounds.AbsoluteSize.Y
                            local X = math.clamp(Anchor.AbsolutePosition.X, MinX + 4, math.max(MinX + 4, MaxX - Popup.AbsoluteSize.X - 4))
                            local Y = Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + 5
                            if Y + Popup.AbsoluteSize.Y > MaxY - 4 then
                                Y = Anchor.AbsolutePosition.Y - Popup.AbsoluteSize.Y - 5
                            end
                            Y = math.clamp(Y, MinY + 4, math.max(MinY + 4, MaxY - Popup.AbsoluteSize.Y - 4))
                            Popup.Position = UDim2New(0, X, 0, Y)
                        end)
                    end

                    for Index, Value in Library.OpenFrames do
                        if Value ~= Keybind then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind
                else
                    if Library.OpenFrames[Keybind] then
                        Library.OpenFrames[Keybind] = nil
                    end

                    if RenderStepped then
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end

                    Items["KeybindWindow"].Instance.Visible = false
                    Items["KeybindWindow"].Instance.Parent = Library.UnusedHolder.Instance
                end
            end

            function Keybind:SetMode(Mode)
                for Index, Value in Modes do 
                    if Index == Mode then
                        Value:Tween(nil, {BackgroundTransparency = 0})
                    else
                        Value:Tween(nil, {BackgroundTransparency = 1})
                    end
                end

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end

            function Keybind:Press(Bool)
                if Data.IgnorePress then
                    return
                end

                if Keybind.Mode == "Toggle" then 
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then 
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then 
                    Keybind.Toggled = true
                end

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end

            Items["KeyButton"]:Connect("MouseButton1Click", function()
                Keybind.Picking = true 

                Items["KeyButton"].Instance.Text = "."
                Library:Thread(function()
                    local Count = 1

                    while true do 
                        if not Keybind.Picking then 
                            break
                        end

                        if Count == 4 then
                            Count = 1
                        end

                        Items["KeyButton"].Instance.Text = Count == 1 and "." or Count == 2 and ".." or Count == 3 and "..."
                        Count += 1
                        task.wait(0.5)
                    end
                end)

                task.delay(0, function()
                    local InputBegan
                    InputBegan = UserInputService.InputBegan:Connect(function(Input)
                        if not Keybind.Picking then
                            if InputBegan then
                                InputBegan:Disconnect()
                                InputBegan = nil
                            end
                            return
                        end

                        local InputType = Input.UserInputType
                        if InputType == Enum.UserInputType.Keyboard then
                            local Code = Input.KeyCode
                            if Code == Enum.KeyCode.Unknown or Code == Enum.KeyCode.Print or Code == Enum.KeyCode.SysReq then
                                return
                            end

                            if Code == Enum.KeyCode.Escape then
                                Keybind.Picking = false
                                Items["KeyButton"].Instance.Text = (Keybind.Value ~= "" and Keybind.Value) or "None"
                                InputBegan:Disconnect()
                                InputBegan = nil
                                return
                            end

                            Keybind:Set(Code)
                        elseif InputType == Enum.UserInputType.MouseButton1 or InputType == Enum.UserInputType.MouseButton2 or InputType == Enum.UserInputType.MouseButton3 then
                            Keybind:Set(InputType)
                        else
                            return
                        end

                        InputBegan:Disconnect()
                        InputBegan = nil
                    end)
                end)
            end)

            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input, GameProcessed)
                if Keybind.Picking or Keybind.Value == "None" then
                    return
                end

                if IsTyping(GameProcessed) then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Toggle" then 
                        Keybind:Press()
                    elseif Keybind.Mode == "Hold" then 
                        Keybind:Press(true)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Toggle" then 
                        Keybind:Press()
                    elseif Keybind.Mode == "Hold" then 
                        Keybind:Press(true)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Keybind.IsOpen or closeLock then
                        return
                    end

                    if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
                        return
                    end

                    Keybind:SetOpen(false)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input, GameProcessed)
                if Keybind.Picking or Keybind.Value == "None" then
                    return
                end

                if IsTyping(GameProcessed) then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end
            end)

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Toggle"
                Keybind:SetMode("Toggle")
            end)

            Items["Hold"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Hold"
                Keybind:SetMode("Hold")
            end)

            Items["Always"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Always"
                Keybind:SetMode("Always")
            end)

            if Data.Default then
                Keybind:Set({Key = Data.Default, Mode = Data.Mode or "Toggle"})
            end

            Library.SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items 
        end

        Components.Textbox = function(self, Data)
            local Textbox = {
                Flag = Data.Flag,
                Value = ""
            }

            local Items = { } do
                Items["Textbox"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Data.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

                Items["Text"]:TextBorder()

                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(30, 36, 31)
                })  Items["Background"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

                Instances:Create("UIGradient", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Rotation = -165,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(208, 208, 208))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme.Gradient)}
                end})

                Instances:Create("UIStroke", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    PlaceholderColor3 = FromRGB(185, 185, 185),
                    PlaceholderText = Data.Placeholder,
                    TextSize = 12,
                    Size = UDim2New(1, 0, 1, 0),
                    ClipsDescendants = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    TextColor3 = FromRGB(235, 235, 235),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2New(0, 0, 0, 0),
                    ClearTextOnFocus = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Input"]:AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Placeholder Text"})

                Items["Input"]:TextBorder()

                Instances:Create("UIPadding", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8)
                })
            end

            function Textbox:Get()
                return Textbox.Value
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
                Library:BumpLayout(Items["Textbox"].Instance)
            end

            function Textbox:Set(Value)
                if Data.Numeric then
                    if (not tonumber(Value)) and StringLen(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Library.Flags[Textbox.Flag] = Value

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Value)
                end
            end
            
            if Data.Finished then 
                Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Items["Input"].Instance:GetPropertyChangedSignal("Text"):Connect(function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            if Data.Default then
                Textbox:Set(Data.Default)
            end

            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return Textbox, Items
        end

        Components.Searchbox = function(self, Data) -- just pasted the entire dropdown fucntion with different instances, i cant be asked to make a whole new functionality
            local Dropdown = {
                Flag = Data.Flag, 
                Value = { },
                Options = { },
                IsOpen = false
            }

            local Items = { } do
                Items["Listbox"] = Instances:Create("Frame", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 185),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Search"] = Instances:Create("Frame", {
                    Parent = Items["Listbox"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 0.4000000059604645,
                    Size = UDim2New(0, 0, 0, 20),
                    BorderColor3 = FromRGB(12, 12, 12),
                    BorderSizePixel = 2,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(14, 17, 15)
                })  Items["Search"]:AddToTheme({BorderColor3 = "Border", BackgroundColor3 = "Background"})

                Instances:Create("UIStroke", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Transparency = 0.4000000059604645,
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter
                }):AddToTheme({Color = "Outline"})

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = "rbxassetid://71197946135150",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Icon"]:AddToTheme({ImageColor3 = "Text"})

                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    Size = UDim2New(0, 0, 1, 0),
                    Position = UDim2New(0, 22, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    PlaceholderColor3 = FromRGB(185, 185, 185),
                    AutomaticSize = Enum.AutomaticSize.X,
                    PlaceholderText = "search..",
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Input"]:AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Placeholder Text"})

                Items["Input"]:TextBorder()

                Instances:Create("UIPadding", {
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 5),
                    PaddingLeft = UDimNew(0, 3)
                })

                Items["RealListbox"] = Instances:Create("Frame", {
                    Parent = Items["Listbox"].Instance,
                    Name = "\0",
                    ClipsDescendants = true,
                    BorderColor3 = FromRGB(12, 12, 12),
                    Size = UDim2New(1, 0, 1, -28),
                    SelectionGroup = true,
                    Position = UDim2New(0, 0, 0, 28),
                    Selectable = true,
                    Active = true,
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(30, 36, 31)
                })  Items["RealListbox"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

                Instances:Create("UIStroke", {
                    Parent = Items["RealListbox"].Instance,
                    Name = "\0",
                    Color = FromRGB(42, 49, 45),
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Outline"})

                Instances:Create("UIGradient", {
                    Parent = Items["RealListbox"].Instance,
                    Name = "\0",
                    Rotation = -165,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(208, 208, 208))}
                }):AddToTheme({Color = function()
                    return RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, Library.Theme.Gradient)}
                end})

                Items["List"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["RealListbox"].Instance,
                    Name = "\0",
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    ScrollBarImageColor3 = FromRGB(202, 243, 255),
                    MidImage = "rbxassetid://136419474381965",
                    BorderColor3 = FromRGB(0, 0, 0),
                    ScrollBarThickness = 2,
                    Size = UDim2New(1, -12, 1, -10),
                    Position = UDim2New(0, 3, 0, 5),
                    TopImage = "rbxassetid://136419474381965",
                    CanvasPosition = Vector2New(0, 57),
                    BottomImage = "rbxassetid://136419474381965",
                    BackgroundTransparency = 1,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["List"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

                Instances:Create("UIListLayout", {
                    Parent = Items["List"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["List"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 5),
                })
            end

            function Dropdown:Get()
                return Dropdown.Value
            end

            function Dropdown:SetVisibility(Bool)
                Items["Listbox"].Instance.Visible = Bool
                Library:BumpLayout(Items["Listbox"].Instance)
            end

            function Dropdown:Set(Option)
                if Data.Multi then 
                    if type(Option) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Option do
                        local OptionData = Dropdown.Options[Value]
                        
                        if not OptionData then
                            continue
                        end

                        OptionData.Selected = true 
                        OptionData:Toggle("Active")
                    end
                else
                    if not Dropdown.Options[Option] then
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false 
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true 
                            Value:Toggle("Active")
                        end
                    end
                end

                if Data.Callback then   
                    Library:SafeCall(Data.Callback, Dropdown.Value)
                end
            end

            function Dropdown:Add(Option)
                local OptionButton = Instances:Create("TextButton", {
                    Parent = Items["List"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(235, 235, 235),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Option,
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2New(1, 0, 0, 20),
                    ZIndex = 1,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  OptionButton:AddToTheme({TextColor3 = "Text"})

                OptionButton:TextBorder()

                local OptionData = {
                    Button = OptionButton,
                    Name = Option,
                    Selected = false
                }

                function OptionData:Toggle(Status)
                    if Status == "Active" then 
                        OptionData.Button:ChangeItemTheme({TextColor3 = "Accent"})
                        OptionData.Button:Tween(nil, {TextColor3 = Library.Theme.Accent})
                    else
                        OptionData.Button:ChangeItemTheme({TextColor3 = "Text"}) 
                        OptionData.Button:Tween(nil, {TextColor3 = Library.Theme.Text})
                    end
                end

                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected

                    if Data.Multi then 
                        local Index = TableFind(Dropdown.Value, OptionData.Name)

                        if Index then 
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:Toggle(Index and "Inactive" or "Active")

                        Library.Flags[Dropdown.Flag] = Dropdown.Value
                    else
                        if OptionData.Selected then 
                            Dropdown.Value = OptionData.Name
                            Library.Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.Selected = true
                            OptionData:Toggle("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.Selected = false 
                                    Value:Toggle("Inactive")
                                end
                            end
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil

                            OptionData.Selected = false
                            OptionData:Toggle("Inactive")
                        end
                    end

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Dropdown.Value)
                    end
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if not Dropdown.Options[Option] then
                    return
                end

                Dropdown.Options[Option].Button:Clean()
                Dropdown.Options[Option] = nil
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            Items["Listbox"]:OnHover(function()
                Items["Listbox"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
                Items["Listbox"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
            end)

            Items["Listbox"]:OnHoverLeave(function()
                Items["Listbox"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
                Items["Listbox"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
            end)

            local SearchStepped

            Items["Input"]:Connect("Focused", function()
                SearchStepped = RunService.RenderStepped:Connect(function()
                    for Index, Value in Dropdown.Options do
                        if Items["Input"].Instance.Text ~= "" then
                            if StringFind(StringLower(Value.Name), StringLower(Items["Input"].Instance.Text)) then
                                Value.Button.Instance.Visible = true
                            else
                                Value.Button.Instance.Visible = false
                            end
                        else
                            Value.Button.Instance.Visible = true
                        end
                    end
                end)
            end)

            Items["Input"]:Connect("FocusLost", function()
                if SearchStepped then
                    SearchStepped:Disconnect()
                    SearchStepped = nil
                end
            end)

            for Index, Value in Data.Items do 
                Dropdown:Add(Value)
            end

            if Data.Default then 
                Dropdown:Set(Data.Default)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return Dropdown, Items 
        end
    end

    -- Library components
    Library.Watermark = function(self, Name)
        local Watermark = { }

        local Items = { } do 
            Items["Watermark"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0.5, 1),
                Position = UDim2New(0.5, 0, 1, -12),
                BorderColor3 = FromRGB(12, 12, 12),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(14, 17, 15)
            })  Items["Watermark"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["Watermark"]:MakeDraggable()

            Instances:Create("UIStroke", {
                Parent = Items["Watermark"].Instance,
                Name = "\0",
                Color = FromRGB(42, 49, 45),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})

            Instances:Create("UIPadding", {
                Parent = Items["Watermark"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 5),
                PaddingBottom = UDimNew(0, 7),
                PaddingRight = UDimNew(0, 5),
                PaddingLeft = UDimNew(0, 5)
            })

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Watermark"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Name,
                Position = UDim2New(0, 0, 0, 2),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["Text"]:TextBorder()

            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["Watermark"].Instance,
                Name = "\0",
                Position = UDim2New(0, -5, 0, -5),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 10, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(202, 243, 255)
            })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})
        end

        function Watermark:SetVisibility(Bool)
            Watermark._WantVisible = Bool == true
            Items["Watermark"].Instance.Visible = Library.Ready ~= false and Bool == true
        end

        function Watermark:RefreshLayout()
            local Inst = Items["Watermark"].Instance
            if not Inst then
                return
            end
            Inst.AutomaticSize = Enum.AutomaticSize.XY
            Inst.Visible = Watermark._WantVisible ~= false and Library.Ready ~= false
        end

        Watermark._WantVisible = true
        Items["Watermark"].Instance.Visible = Library.Ready ~= false

        return Watermark
    end

    Library.KeybindList = function(self)
        local KeybindList = { }
        Library.KeyList = KeybindList

        local Items = { } do
            Items["KeybindList"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 12, 0.5, 55),
                BorderColor3 = FromRGB(12, 12, 12),
                Size = UDim2New(0, 116, 0, 32),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(14, 17, 15)
            })  Items["KeybindList"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["KeybindList"]:MakeDraggable()

            Instances:Create("UISizeConstraint", {
                Parent = Items["KeybindList"].Instance,
                MinSize = Vector2New(116, 32),
            })

            Instances:Create("UIStroke", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                Color = FromRGB(42, 49, 45),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})

            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Keybinds",
                Size = UDim2New(0, 0, 0, 20),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, -4),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

            Items["Title"]:TextBorder()

            Instances:Create("UIPadding", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 8),
                PaddingBottom = UDimNew(0, 8),
                PaddingRight = UDimNew(0, 8),
                PaddingLeft = UDimNew(0, 8)
            })

            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 15),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(202, 243, 255)
            })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 20),
                Size = UDim2New(0, 0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        function KeybindList:Add(Key, Name, Mode)
            local NewKey = Instances:Create("TextLabel", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "" ..Key .." - " ..Name .. " ("..Mode..")",
                BackgroundTransparency = 1,
                Size = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextTransparency = 1,
                Visible = false,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  NewKey:AddToTheme({TextColor3 = "Text"})

            NewKey:TextBorder()

            function NewKey:SetText(Key, Name, Mode)
                NewKey.Instance.Text = "" ..Key .." - " ..Name .. " ("..Mode..")"
            end

            function NewKey:SetStatus(Bool)
                if Bool then
                    NewKey.Instance.Visible = true
                    NewKey:Tween(nil, {TextTransparency = 0})
                else
                    NewKey:Tween(nil, {TextTransparency = 1}).Tween.Completed:Connect(function()
                        NewKey.Instance.Visible = false
                    end)
                end
            end

            return NewKey
        end

        function KeybindList:SetVisibility(Bool)
            KeybindList._WantVisible = Bool == true
            Items["KeybindList"].Instance.Visible = Library.Ready ~= false and Bool == true
        end

        function KeybindList:RefreshLayout()
            local Inst = Items["KeybindList"].Instance
            if not Inst then
                return
            end
            Inst.AutomaticSize = Enum.AutomaticSize.Y
            Inst.Size = UDim2New(0, 116, 0, 32)
            Inst.Visible = KeybindList._WantVisible ~= false and Library.Ready ~= false
        end

        KeybindList._WantVisible = true
        Items["KeybindList"].Instance.Visible = Library.Ready ~= false

        return KeybindList
    end

    Library.Notification = function(self, Title, Description, Duration)
        if type(Description) == "number" then
            Duration = Description
            Description = tostring(Title or "")
            Title = "Friday"
        elseif typeof(Description) == "Color3" then
            Description = tostring(Title or "")
            Title = "Friday"
            Duration = 3
        elseif typeof(Duration) == "Color3" then
            Duration = 3
        end
        Duration = tonumber(Duration) or 3
        local Items = { } do 
            Items["Notification"] = Instances:Create("Frame", {
                Parent = Library.NotifHolder.Instance,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 25),
                BorderColor3 = FromRGB(12, 12, 12),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(14, 17, 15)
            })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["UIStroke1"] = Instances:Create("UIStroke", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                Color = FromRGB(42, 49, 45),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  Items["UIStroke1"]:AddToTheme({Color = "Outline"})

            Instances:Create("UIPadding", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 5),
                PaddingBottom = UDimNew(0, 12),
                PaddingRight = UDimNew(0, 5),
                PaddingLeft = UDimNew(0, 5)
            })

            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Title,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

           Items["UIStroke2"] =  Items["Title"]:TextBorder()

            Items["Description"] = Instances:Create("TextLabel", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                TextTransparency = 0.4000000059604645,
                Text = Description,
                Position = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Description"]:AddToTheme({TextColor3 = "Text"})

            Items["UIStroke3"] = Items["Description"]:TextBorder()

            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 1, 8),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(202, 243, 255)
            })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})
        end

        local Size = Items["Notification"].Instance.AbsoluteSize

        for Index, Value in Items do 
            if Value.Instance:IsA("Frame") then
                Value.Instance.BackgroundTransparency = 1
            elseif Value.Instance:IsA("TextLabel") then 
                Value.Instance.TextTransparency = 1
            elseif Value.Instance:IsA("UIStroke") then
                Value.Instance.Transparency = 1
            end
        end 

        Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.Y

        Library:Thread(function()
            for Index, Value in Items do 
                if Value.Instance:IsA("Frame") then
                    Value:Tween(nil, {BackgroundTransparency = 0})
                elseif Value.Instance:IsA("TextLabel") and Index ~= "Description" then 
                    Value:Tween(nil, {TextTransparency = 0})
                elseif Value.Instance:IsA("TextLabel") and Index == "Description" then 
                    Value:Tween(nil, {TextTransparency = 0.4})
                elseif Value.Instance:IsA("UIStroke") then
                    Value:Tween(nil, {Transparency = 0})
                end
            end

            Items["Notification"]:Tween(nil, {Size = UDim2New(0, Size.X, 0, 0)})
            Items["Liner"]:Tween(TweenInfo.new(Duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New(0, 0, 0, 1)})
            
            task.delay(Duration + 0.1, function()
                for Index, Value in Items do 
                    if Value.Instance:IsA("Frame") then
                        Value:Tween(nil, {BackgroundTransparency = 1})
                    elseif Value.Instance:IsA("TextLabel") then 
                        Value:Tween(nil, {TextTransparency = 1})
                    elseif Value.Instance:IsA("UIStroke") then
                        Value:Tween(nil, {Transparency = 1})
                    end
                end

                Items["Notification"]:Tween(nil, {Size = UDim2New(0, 0, 0, 0)})
                task.wait(0.5)
                Items["Notification"]:Clean()
            end)
        end)
    end

    Library.Window = function(self, Data)
        Data = Data or { }

        local Window = { 
            Logo = (Data.Logo and Data.Logo ~= "" and Data.Logo) or (Data.logo and Data.logo ~= "" and Data.logo) or "99061651310213",
            FadeTime = Data.FadeTime or Data.fadetime or 0.4,
            Size = Data.Size or Data.size or UDim2New(0, 751, 0, 539),

            Pages = { },
            Items = { },

            IsOpen = false,
        }

        local Items = Components:Window({
            Parent = Library.Holder,
            Draggable = true,
            Resizeable = true,
            AnchorPoint = Vector2New(0, 0),
            Position = UDim2New(0, Camera.ViewportSize.X / 3.3, 0, Camera.ViewportSize.Y / 3.3),
            Size = Window.Size
        }) do
            Items["Side"] = Instances:Create("Frame", {
                Parent = Items["Window"].Instance,
                Name = "\0",
                Position = UDim2New(0, 12, 0, 12),
                BorderColor3 = FromRGB(42, 49, 45),
                Size = UDim2New(0, 200, 1, -24),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(20, 24, 21)
            })  Items["Side"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})
            
            Items["Side"]:Border("Border")

            Items["Window"].Instance.Visible = false

            local SpinFirst = Library._SpinImages and Library._SpinImages[1]
            Items["Logo"] = Instances:Create("ImageLabel", {
                Parent = Items["Side"].Instance,
                Name = "\0",
                ImageColor3 = Library.Theme.Accent,
                ScaleType = Enum.ScaleType.Fit,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0.5, 0),
                Image = SpinFirst or ("rbxassetid://" .. Window.Logo),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0, 12),
                Size = UDim2New(0, 75, 0, 75),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Logo"]:AddToTheme({ImageColor3 = "Accent"})
            Items["Logo"].Instance.ImageColor3 = Library.Theme.Accent
            Items["Logo"].Instance.ImageTransparency = 0
            Items["Logo"].Instance.Rotation = 0
            Items["Logo"].Instance.Visible = false

            Library:AttachSpinningLogo(Items["Logo"])

            Items["Search"] = Instances:Create("Frame", {
                Parent = Items["Side"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(12, 12, 12),
                AnchorPoint = Vector2New(0, 1),
                BackgroundTransparency = 0.4000000059604645,
                Position = UDim2New(0, 6, 1, -6),
                Size = UDim2New(0, 0, 0, 20),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(14, 17, 15)
            })  Items["Search"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["SearchStroke"] = Items["Search"]:Border("Outline")

            Items["Icon"] = Instances:Create("ImageLabel", {
                Parent = Items["Search"].Instance,
                Name = "\0",
                ScaleType = Enum.ScaleType.Fit,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 0.5),
                Image = "rbxassetid://71197946135150",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0.5, 0),
                Size = UDim2New(0, 16, 0, 16),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Input"] = Instances:Create("TextBox", {
                Parent = Items["Search"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                CursorPosition = -1,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                Size = UDim2New(0, 0, 1, 0),
                Position = UDim2New(0, 22, 0, 0),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                PlaceholderColor3 = FromRGB(185, 185, 185),
                AutomaticSize = Enum.AutomaticSize.X,
                PlaceholderText = "..",
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Input"]:AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Placeholder Text"})

            Items["Input"]:TextBorder()

            Instances:Create("UIPadding", {
                Parent = Items["Search"].Instance,
                Name = "\0",
                PaddingRight = UDimNew(0, 5),
                PaddingLeft = UDimNew(0, 3)
            })

            Items["Pages"] = Instances:Create("Frame", {
                Parent = Items["Side"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 100),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 1, -135),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIPadding", {
                Parent = Items["Pages"].Instance,
                Name = "\0",
                PaddingRight = UDimNew(0, 8),
                PaddingLeft = UDimNew(0, 8)
            })

            Instances:Create("UIListLayout", {
                Parent = Items["Pages"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Items["Avatar"] = Instances:Create("ImageLabel", {
                Parent = Items["Side"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 1),
                Image = "",
                BackgroundTransparency = 1,
                Position = UDim2New(1, -6, 1, -6),
                Size = UDim2New(0, 25, 0, 25),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Avatar"]:Border("Outline").Instance.LineJoinMode = Enum.LineJoinMode.Round

            Instances:Create("UICorner", {
                Parent = Items["Avatar"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })

            task.defer(function()
                Library:RequestThumbnail(LocalPlayer.UserId, function(Content)
                    if Items["Avatar"] and Items["Avatar"].Instance then
                        Items["Avatar"].Instance.Image = Content
                    end
                end)
            end)

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Window"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 226, 0, 12),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -238, 1, -24),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["MouseBackground"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                Active = false,
                BackgroundTransparency = 1,
                Visible = false,
                Position = UDim2New(0, 0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 16, 0, 16),
                BorderSizePixel = 0,
                ZIndex = 9999,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["MouseImage"] = Instances:Create("ImageLabel", {
                Parent = Items["MouseBackground"].Instance,
                Name = "\0",
                Active = false,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = "rbxassetid://76631660114196",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                ZIndex = 9999,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["MouseImage"]:AddToTheme({ImageColor3 = "Accent"})

            Instances:Create("UIGradient", {
                Parent = Items["MouseImage"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(99, 108, 117))}
            })

            Window.Items = Items
            Library.MainWindow = Items["Window"].Instance
        end

        local Debounce = false

        Items["Input"]:Connect("Focused", function()
            Items["Search"]:Tween(nil, {BackgroundTransparency = 0})
            Items["SearchStroke"]:Tween(nil, {Transparency = 0})
        end)

        Items["Input"]:Connect("FocusLost", function()
            Items["Search"]:Tween(nil, {BackgroundTransparency = 0.4})
            Items["SearchStroke"]:Tween(nil, {Transparency = 0.4})
        end)

        Items["Input"]:OnHover(function()
            Items["Search"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            Items["Search"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
        end)

        Items["Input"]:OnHoverLeave(function()
            Items["Search"]:ChangeItemTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            Items["Search"]:Tween(nil, {BackgroundColor3 = Library.Theme.Background})
        end)

        Library:Connect(RunService.RenderStepped, function()
            if Window.IsOpen ~= true then
                return
            end
            local MouseLocation = UserInputService:GetMouseLocation() 
            Items["MouseBackground"].Instance.Position = UDim2New(0, MouseLocation.X - 1, 0, MouseLocation.Y - 56)           
        end)

        local OldSizes = { }

        function Window:AddToOldSizes(Item, Size)
            if not OldSizes[Item] then
                OldSizes[Item] = Size
            end
        end

        function Window:GetOldSize(Item)
            if OldSizes[Item] then
                return OldSizes[Item]
            end
        end

        function Window:SetOpen(Bool, Instant)
            Window.IsOpen = Bool == true
            Library.WindowOpenState = Window.IsOpen
            _G.__FridayOmegaMenuOpen = function()
                return Window.IsOpen == true
            end

            local LogoInst = Items["Logo"] and Items["Logo"].Instance
            if LogoInst then
                if Window.IsOpen then
                    LogoInst.Visible = true
                    LogoInst.ImageTransparency = 0
                    LogoInst.Rotation = 0
                    if Library.Theme and Library.Theme.Accent then
                        LogoInst.ImageColor3 = Library.Theme.Accent
                    end
                else
                    LogoInst.Visible = false
                    LogoInst.ImageTransparency = 1
                end
            end

            Items["Window"].Instance.Visible = Window.IsOpen
            if Window.IsOpen then
                Items["MouseBackground"].Instance.Visible = true
                UserInputService.MouseIconEnabled = false
            else
                Library:CloseOpenFrames()
                Items["MouseBackground"].Instance.Visible = false
                UserInputService.MouseIconEnabled = true
            end
        end

        Library:Connect(UserInputService.InputBegan, function(Input, GameProcessed)
            if IsTyping(GameProcessed) then
                return
            end

            if Library.Ready == false then
                return
            end

            if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                Window:SetOpen(not Window.IsOpen)
            end
        end)

        local SearchStepped

        Items["Input"]:Connect("Focused", function()
            local PageSearchData = Library.SearchItems[Library.CurrentPage]

            if not PageSearchData then
                return 
            end

            SearchStepped = RunService.RenderStepped:Connect(function()
                for Index, Value in PageSearchData do 
                    local Name = Value.Name
                    local Element = Value.Element

                    if StringFind(StringLower(Name), StringLower(Items["Input"].Instance.Text)) then
                        if Items["Input"].Instance.Text ~= "" then 
                            Element.Instance.Visible  = true 
                            Element:Tween(TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Window:GetOldSize(Element)})
                        else
                            Element.Instance.Visible  = true 
                            Element:Tween(TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Window:GetOldSize(Element)})
                        end
                    else
                        Window:AddToOldSizes(Element, Element.Instance.Size)
                        Element:Tween(TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2New(Window:GetOldSize(Element).X.Scale, Window:GetOldSize(Element).X.Offset, 0, 0)})
                        task.wait(0.1)
                        Element.Instance.Visible = false
                    end
                end
            end)
        end)

        Items["Input"]:Connect("FocusLost", function()
            if SearchStepped then 
                SearchStepped:Disconnect()
                SearchStepped = nil
            end
        end)

        if Data.AutoOpen ~= false then
            Window:SetOpen(true)
        end
        return setmetatable(Window, self)
    end

    Library.Page = function(self, Data)
        Data = Data or { }

        local Page = {
            Window = self,

            Name = Data.Name or Data.name or "Page",
            Columns = Data.Columns or Data.columns or 2,
            SubPages = Data.SubPages or Data.subpages or false,
        }

        Library.SearchItems[Page] = { }

        local NewPage, Items = Components:WindowPage({
            Name = Page.Name,
            ContentHolder = Page.Window.Items["Content"],
            Stack = Page.Window.Pages,
            Parent = Page.Window.Items["Pages"],
            Columns = Page.Columns,
            SubPages = Page.SubPages,
            FadeTime = Page.Window.FadeTime,
            Window = Page.Window
        })

        return setmetatable(NewPage, Library.Pages)
    end

    Library.Pages.SubPage = function(self, Data)
        Data = Data or { }

        local SubPage = {
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "SubPage",
            Columns = Data.Columns or Data.columns or 2,
        }

        Library.SearchItems[SubPage] = { }

        local NewSubPage, Items = Components:WindowSubPage({
            Page = SubPage.Page,
            Name = SubPage.Name,
            Columns = SubPage.Columns,
            Window = SubPage.Page.Window
        })

        return setmetatable(NewSubPage, Library.Pages)
    end
    
    Library.Pages.Playerlist = function(self, Data)
        local Playerlist = {
            Window = self.Window,
            Page = self,

            CurrentPlayer = nil,

            Players = { },
            ActionCallbacks = { },
        }

        local Items = { } do 
            Playerlist.Page.Items.Page.Instance:FindFirstChildOfClass("UIListLayout"):Destroy()

            Items["Playerlist"] = Instances:Create("Frame", {
                Parent = Playerlist.Page.Items["Page"].Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 1),
                BorderColor3 = FromRGB(42, 49, 45),
                Size = UDim2New(1, 0, 0, 460),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(20, 24, 21)
            })  Items["Playerlist"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})

            Instances:Create("UIStroke",{
                Parent = Items["Playerlist"].Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Color = FromRGB(202, 243, 255),
                Thickness = 1
            }):AddToTheme({Color = "Border"})

            Items["RealPlayerlist"] = Instances:Create("Frame", {
                Parent = Items["Playerlist"].Instance,
                Name = "\0",
                Position = UDim2New(0, 8, 0, 8),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -16, 0, 365),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(14, 17, 15)
            })  Items["RealPlayerlist"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke",{
                Parent = Items["RealPlayerlist"].Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Color = FromRGB(202, 243, 255),
                Thickness = 1
            }):AddToTheme({Color = "Outline"})

            Items["PlayerHolder"] = Instances:Create("ScrollingFrame", {
                Parent = Items["RealPlayerlist"].Instance,
                Name = "\0",
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BorderSizePixel = 0,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = FromRGB(202, 243, 255),
                MidImage = "rbxassetid://86918736894927",
                BorderColor3 = FromRGB(0, 0, 0),
                ScrollBarThickness = 2,
                Size = UDim2New(1, -16, 1, -8),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 8, 0, 4),
                BottomImage = "rbxassetid://86918736894927",
                TopImage = "rbxassetid://86918736894927",
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["PlayerHolder"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

            Instances:Create("UIListLayout", {
                Parent = Items["PlayerHolder"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Instances:Create("UIPadding", {
                Parent = Items["PlayerHolder"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 2),
                PaddingBottom = UDimNew(0, 2),
                PaddingRight = UDimNew(0, 12),
                PaddingLeft = UDimNew(0, 2)
            })

            Items["PlayerAvatar"] = Instances:Create("ImageLabel", {
                Parent = Items["Playerlist"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                Image = "rbxassetid://98200387761744",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 8, 1, -10),
                Size = UDim2New(0, 65, 0, 65),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["PlayerUserID"] = Instances:Create("TextLabel", {
                Parent = Items["Playerlist"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "???",
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 80, 1, -60),
                BorderSizePixel = 0,
                ZIndex = 2,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["PlayerUserID"]:AddToTheme({TextColor3 = "Text"})

            Items["PlayerUserID"]:TextBorder()

            Items["PlayerAccountAge"] = Instances:Create("TextLabel", {
                Parent = Items["Playerlist"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "???",
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 80, 1, -40),
                BorderSizePixel = 0,
                ZIndex = 2,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["PlayerAccountAge"]:AddToTheme({TextColor3 = "Text"})

            Items["PlayerAccountAge"]:TextBorder()

            Items["PlayerUsername"] = Instances:Create("TextLabel", {
                Parent = Items["Playerlist"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "???",
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 80, 1, -78),
                BorderSizePixel = 0,
                ZIndex = 2,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["PlayerUsername"]:AddToTheme({TextColor3 = "Text"})

            Items["PlayerUsername"]:TextBorder()
        end

        local Dropdown, DropdownItems = Components:Dropdown({
            Parent = Items["Playerlist"],
            Name = "Status",
            Flag = "PlayerlistStatus",
            Items = { "Neutral", "Target", "Whitelist" },
            Default = "Neutral",
            Multi = false,
            Callback = function(Value)
                if Playerlist.Player then
                    if Playerlist.Player == LocalPlayer then
                        return
                    end

                    if Value == "Neutral" then
                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus:Tween(nil, {TextColor3 = Library.Theme["Text"]})
                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus.Instance.Text = "Neutral"
                    elseif Value == "Target" then
                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus:Tween(nil, {TextColor3 = FromRGB(235, 76, 48)})
                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus.Instance.Text = "Target"
                    elseif Value == "Whitelist" then
                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus:Tween(nil, {TextColor3 = FromRGB(134, 235, 56)})
                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus.Instance.Text = "Whitelist"
                    else
                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus:Tween(nil, {TextColor3 = Library.Theme["Text"]})
                        Playerlist.Players[Playerlist.Player.Name].PlayerStatus.Instance.Text = "Neutral"
                    end

                    local Bridge = rawget(_G, "__FridayOmegaPlayerStatusChanged")
                    if type(Bridge) == "function" then
                        Library:SafeCall(Bridge, Playerlist.Player, Value)
                    end
                end
            end
        })

        DropdownItems["Dropdown"].Instance.AnchorPoint = Vector2New(1, 1)
        DropdownItems["Dropdown"].Instance.Position = UDim2New(1, -8, 1, -25)
        DropdownItems["Dropdown"].Instance.Size = UDim2New(0, 200, 0, 40)

        function Playerlist:Add(Player)
            local PlayerItems = { }

            PlayerItems["NewPlayer"] = Instances:Create("TextButton", {
                Parent = Items["PlayerHolder"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 20),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            PlayerItems["Name"] = Instances:Create("TextLabel", {
                Parent = PlayerItems["NewPlayer"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = (Player.DisplayName and Player.DisplayName ~= "" and Player.DisplayName) or Player.Name,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(0.3499999940395355, 0, 0, 15),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  PlayerItems["Name"]:AddToTheme({TextColor3 = "Text"})

            local Team = Player.Team ~= nil and Player.Team.Name or "None"
            local TeamColor = Player.TeamColor ~= nil and BrickColor.new(tostring(Player.TeamColor)).Color or Color3.new(1, 1, 1)

            PlayerItems["Team"] = Instances:Create("TextLabel", {
                Parent = PlayerItems["NewPlayer"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = TeamColor,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Team,
                AnchorPoint = Vector2New(0.5, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0, 0),
                Size = UDim2New(0.3499999940395355, 0, 0, 15),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            PlayerItems["Status"] = Instances:Create("TextLabel", {
                Parent = PlayerItems["NewPlayer"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Neutral",
                Size = UDim2New(0.3499999940395355, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2New(0.6499999761581421, 0, 0, 0),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            PlayerItems["Liner"] = Instances:Create("Frame", {
                Parent = PlayerItems["NewPlayer"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, -1),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(42, 49, 45)
            })  PlayerItems["Liner"]:AddToTheme({BackgroundColor3 = "Outline"})

            if Player == LocalPlayer then
                PlayerItems["Status"].Instance.TextColor3 = Library.Theme.Accent
                PlayerItems["Status"].Instance.Text = "LocalPlayer"
                PlayerItems["Status"]:AddToTheme({TextColor3 = "Accent"})
            end

            local PlayerData = {
                Name = Player.Name,
                Selected = false,
                PlayerButton = PlayerItems["NewPlayer"],
                PlayerName = PlayerItems["Name"],
                PlayerTeam = PlayerItems["Team"],
                PlayerStatus = PlayerItems["Status"],
                Player = Player
            }

            function PlayerData:Toggle(Status)
                if Status == "Active" then
                    PlayerItems["Name"]:ChangeItemTheme({TextColor3 = "Accent"})
                    PlayerItems["Name"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
                else
                    PlayerItems["Name"]:ChangeItemTheme({TextColor3 = "Text"})
                    PlayerItems["Name"]:Tween(nil, {TextColor3 = Library.Theme.Text})
                end
            end

            function PlayerData:Set()
                PlayerData.Selected = not PlayerData.Selected

                if PlayerData.Selected then
                    Playerlist.Player = PlayerData.Player

                    for Index, Value in Playerlist.Players do 
                        Value.Selected = false
                        Value:Toggle("Inactive")
                    end

                    PlayerData:Toggle("Active")

                    Items["PlayerUsername"].Instance.Text = Playerlist.Player.DisplayName .. " (@" .. Playerlist.Player.Name .. ")"
                    Items["PlayerUserID"].Instance.Text = tostring(Playerlist.Player.UserId)
                    Items["PlayerAccountAge"].Instance.Text = tostring(Playerlist.Player.AccountAge) .. " days old"

                    local uid = Playerlist.Player.UserId
                    local cached = Library:GetCachedThumbnail(uid)
                    if cached then
                        Items["PlayerAvatar"].Instance.Image = cached
                    else
                        Items["PlayerAvatar"].Instance.Image = "rbxassetid://98200387761744"
                        Library:RequestThumbnail(uid, function(content)
                            if Playerlist.Player == PlayerData.Player and type(content) == "string" then
                                Items["PlayerAvatar"].Instance.Image = content
                            end
                        end)
                    end
                else
                    --print("this shit rigged")
                    Playerlist.Player = nil
                    PlayerData:Toggle("Inactive")
                    Items["PlayerAvatar"].Instance.Image = "rbxassetid://98200387761744"
                    Items["PlayerUsername"].Instance.Text = "None"
                    Items["PlayerUserID"].Instance.Text = "None"
                    Items["PlayerAccountAge"].Instance.Text = "None"
                end

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Playerlist.Player, PlayerData.PlayerStatus.Instance.Text, PlayerData.PlayerTeam.Instance.Text)
                end
            end

            PlayerItems["NewPlayer"]:Connect("MouseButton1Down", function()
                PlayerData:Set()
            end)

            Playerlist.Players[Player.Name] = PlayerData
            Library:RequestThumbnail(Player.UserId)
            return PlayerData
        end

        function Playerlist:Remove(Name)
            if Playerlist.Players[Name] then
                Playerlist.Players[Name].PlayerButton:Clean()
            end
                
            Playerlist.Players[Name] = nil
        end

        for Index, Value in Players:GetPlayers() do 
            Playerlist:Add(Value)
        end
        Library:WarmAllThumbnails()

        Library:Connect(Players.PlayerRemoving, function(Player)
            if Playerlist.Players[Player.Name] then 
                Playerlist:Remove(Player.Name)
            end
        end)

        Library:Connect(Players.PlayerAdded, function(Player)
            Playerlist:Add(Player)
        end)

        return Playerlist
    end

    Library.Pages.Section = function(self, Data)
        Data = Data or { }

        local Section = {
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "Section",
            Side = Data.Side or Data.side or 1,

            Items = { }
        }

        local Items = { } do
            Items["Section"] = Instances:Create("Frame", {
                Parent = Section.Page.ColumnsData[Section.Side].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 25),
                BorderColor3 = FromRGB(42, 49, 45),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 24, 21)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})

            Items["Section"]:Border("Border")

            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(202, 243, 255)
            })  Items["Liner"]:AddToTheme({BackgroundColor3  = "Accent"})

            Items["Glow"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 15),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(202, 243, 255)
            })  Items["Glow"]:AddToTheme({BackgroundColor3  = "Accent"})

            Instances:Create("UIGradient", {
                Parent = Items["Glow"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.193, 0.8687499761581421), NumSequenceKeypoint(0.504, 0.96875), NumSequenceKeypoint(1, 1)}
            })

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Section.Name,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 6, 0, 5),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["Text"]:TextBorder()

            Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                PaddingBottom = UDimNew(0, 8)
            })

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 10, 0, 26),
                Size = UDim2New(1, -20, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Section.Items = Items
        end

        return setmetatable(Section, Library.Sections)
    end
    
    Library.Sections.Toggle = function(self, Data)
        Data = Data or { }

        local Toggle = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Toggle",
            Tooltip = Data.ToolTip or Data.Tooltip or Data.tooltip or nil,
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or false,
            Callback = Data.Callback or Data.callback or function() end
        }

        local NewToggle, ToggleItems = Components:Toggle({
            Name = Toggle.Name,
            Parent = Toggle.Section.Items["Content"],
            Tooltip = Toggle.Tooltip,
            Flag = Toggle.Flag,
            Default = Toggle.Default,
            Page = Toggle.Page,
            Callback = Toggle.Callback
        })

        function NewToggle:Colorpicker(Data)
            local Colorpicker = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or 0,
            }

            local NewColorpicker, ColorpickerItems = Components:Colorpicker({
                Name = Colorpicker.Name,
                Parent = ToggleItems["SubElements"],
                Pages = true,
                Page = Colorpicker.Page,
                Flag = Colorpicker.Flag,
                Default = Colorpicker.Default,
                Alpha = Colorpicker.Alpha,
                Callback = Colorpicker.Callback,
            })

            return NewColorpicker
        end

        function NewToggle:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = self.Window,
                Page = self.Page,
                Section = self.Section,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
                Callback = Data.Callback or Data.callback or function() end,
                Mode = Data.Mode or Data.mode or "Toggle",
            }

            local NewKeybind, KeybindItems = Components:Keybind({
                Name = Toggle.Name,
                Parent = ToggleItems["SubElements"],
                Page = Keybind.Page,
                Flag = Keybind.Flag,
                Default = Keybind.Default,
                Mode = Keybind.Mode,
                List = Data.List,
                IgnorePress = Data.IgnorePress,
                Callback = Keybind.Callback
            })

            return NewKeybind
        end

        return NewToggle
    end

    Library.Sections.Button = function(self, Data)
        Data = type(Data) == "table" and Data or { }
        local Button = {
            Window = self.Window,
            Page = self.Page,
            Section = self
        }

        local NewButton, ButtonItems = Components:Button({
            Parent = Button.Section.Items["Content"],
            Page = Button.Page
        })
        NewButton.Items = ButtonItems
        if Data.Name then
            NewButton:Add(Data.Name, Data.Callback)
        end

        return NewButton
    end

    Library.Sections.Slider = function(self, Data)
        Data = Data or { }
        
        local Slider = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Slider",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Min = Data.Min or Data.min or 0,
            Decimals = Library:SliderStep(Data.Decimals or Data.decimals or 1),
            Suffix = Data.Suffix or Data.suffix or "",
            ToolTip = Data.ToolTip or Data.tooltip or nil,
            Max = Data.Max or Data.max or 100,
            Default = Data.Default or Data.Default or 0,
            Callback = Data.Callback or Data.callback or function() end,
        }

        local NewSlider, SliderItems = Components:Slider({
            Name = Slider.Name,
            Parent = Slider.Section.Items["Content"],
            Flag = Slider.Flag,
            Min = Slider.Min,
            Page = Slider.Page,
            Decimals = Slider.Decimals,
            Suffix = Slider.Suffix,
            Max = Slider.Max,
            Default = Slider.Default,
            Callback = Slider.Callback,
        })

        if Slider.ToolTip then
            SliderItems["Slider"]:Tooltip({
                Text = Slider.ToolTip.Name,
                Description = Slider.ToolTip.Description,
            })
        end

        local PageSearchData = Library.SearchItems[Slider.Page]

        if PageSearchData then
            local SearchData = {
                Element = SliderItems["Slider"],
                Name = Slider.Name,
            }

            TableInsert(PageSearchData, SearchData)
        end

        return NewSlider 
    end

    Library.Sections.Dropdown = function(self, Data)
        Data = Data or { }

        local Dropdown = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Dropdown",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Items = Data.Items or Data.items or { },
            Default = Data.Default or Data.default or nil,
            ToolTip = Data.ToolTip or Data.tooltip or nil,
            Multi = Data.Multi or Data.multi or false,
            Callback = Data.Callback or Data.callback or function() end            
        }

        local NewDropdown, DropdownItems = Components:Dropdown({
            Name = Dropdown.Name,
            Parent = Dropdown.Section.Items["Content"],
            Flag = Dropdown.Flag,
            Items = Dropdown.Items,
            Page = Dropdown.Page,
            Default = Dropdown.Default,
            Multi = Dropdown.Multi,
            Callback = Dropdown.Callback,
        })

        if Dropdown.ToolTip then
            DropdownItems["Dropdown"]:Tooltip({
                Text = Dropdown.ToolTip.Name,
                Description = Dropdown.ToolTip.Description,
            })
        end

        local PageSearchData = Library.SearchItems[Dropdown.Page]

        if PageSearchData then
            local SearchData = {
                Element = DropdownItems["Dropdown"],
                Name = Dropdown.Name,
            }

            TableInsert(PageSearchData, SearchData)
        end

        return NewDropdown 
    end

    Library.Sections.Label = function(self, Name, Tooltip)
        if type(Name) == "table" then
            Tooltip = Name.ToolTip or Name.Tooltip or Tooltip
            Name = Name.Name or "Label"
        end
        local Label = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Name or "Label"
        }

        local NewLabel, LabelItems = Components:Label({
            Name = Label.Name,
            Parent = Label.Section.Items["Content"],
            Page = Label.Page,
        })

        if Tooltip then
            LabelItems["Label"]:Tooltip({
                Text = Tooltip.Name,
                Description = Tooltip.Description,
            })
        end

        function NewLabel:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = self.Window,
                Page = self.Page,
                Section = self.Section,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or 0,
            }

            local NewColorpicker, ColorpickerItems = Components:Colorpicker({
                Name = Colorpicker.Name,
                Parent = LabelItems["SubElements"],
                Pages = true,
                Page = Colorpicker.Page,
                Flag = Colorpicker.Flag,
                Default = Colorpicker.Default,
                Alpha = Colorpicker.Alpha,
                Callback = Colorpicker.Callback,
            })

            return NewColorpicker
        end

        function NewLabel:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = self.Window,
                Page = self.Page,
                Section = self.Section,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
                Callback = Data.Callback or Data.callback or function() end,
                Mode = Data.Mode or Data.mode or "Toggle",
            }

            local NewKeybind, KeybindItems = Components:Keybind({
                Name = Label.Name,
                Parent = LabelItems["SubElements"],
                Page = Keybind.Page,
                Flag = Keybind.Flag,
                Default = Keybind.Default,
                Mode = Keybind.Mode,
                List = Data.List,
                IgnorePress = Data.IgnorePress,
                Callback = Keybind.Callback
            })

            return NewKeybind
        end

        local PageSearchData = Library.SearchItems[Label.Page]

        if PageSearchData then
            local SearchData = {
                Element = LabelItems["Label"],
                Name = Label.Name,
            }

            TableInsert(PageSearchData, SearchData)
        end

        return NewLabel
    end

    Library.Sections.Textbox = function(self, Data)
        Data = Data or { }

        local Textbox = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Textbox",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or "",
            Numeric = Data.Numeric or Data.numeric or false,
            Finished = Data.Finished or Data.finished or false,
            Placeholder = Data.Placeholder or Data.placeholder or "...",
            ToolTip = Data.ToolTip or Data.tooltip or nil,
            Callback = Data.Callback or Data.callback or function() end,
        }

        local NewTextbox, TextboxItems = Components:Textbox({
            Name = Textbox.Name,
            Placeholder = Textbox.Placeholder,
            Parent = Textbox.Section.Items["Content"],
            Flag = Textbox.Flag,
            Page = Textbox.Page,
            Default = Textbox.Default,
            Numeric = Textbox.Numeric,
            Finished = Textbox.Finished,
            Callback = Textbox.Callback,
        })

        if Textbox.ToolTip then
            TextboxItems["Textbox"]:Tooltip({
                Text = Textbox.ToolTip.Name,
                Description = Textbox.ToolTip.Description
            })
        end

        local PageSearchData = Library.SearchItems[Textbox.Page]

        if PageSearchData then
            local SearchData = {
                Element = TextboxItems["Textbox"],
                Name = Textbox.Name,
            }

            TableInsert(PageSearchData, SearchData)
        end

        return NewTextbox
    end

    Library.Sections.Searchbox = function(self, Data)
        Data = Data or { }

        local Searchbox = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Searchbox",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Items = Data.Items or Data.items or { },
            Default = Data.Default or Data.default or nil,
            Multi = Data.Multi or Data.multi or false,
            Callback = Data.Callback or Data.callback or function() end            
        }

        local NewSearchbox, SearchboxItems = Components:Searchbox({
            Parent = Searchbox.Section.Items["Content"],
            Flag = Searchbox.Flag,
            Items = Searchbox.Items,
            Page = Searchbox.Page,
            Default = Searchbox.Default,
            Multi = Searchbox.Multi,
            Callback = Searchbox.Callback,
        })

        local PageSearchData = Library.SearchItems[Searchbox.Page]

        if PageSearchData then
            local SearchData = {
                Element = SearchboxItems["Listbox"],
                Name = Searchbox.Name,
            }

            TableInsert(PageSearchData, SearchData)
        end

        return NewSearchbox 
    end

    Library.BlankElement = function(self, Data)
        local BlankElement = {
            Name = Data.Name or Data.name or "Blank",
            Size = Data.Size or Data.size or 18
        }

        local Items = { } do
            Items["BlankElement"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, BlankElement.Size),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Label"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = BlankElement.Name,
                Size = UDim2New(0, 0, 0, 15),
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 0, 0.5, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["Text"]:TextBorder()
        end

        return BlankElement, Items
    end

    Library.CreateSettingsPage = function(self, Window, Watermark, KeybindList)
        local SettingsPage = Window:Page({Name = "Settings", SubPages = true}) do 
            local ThemingSubPage = SettingsPage:SubPage({Name = "Theming", Columns = 2}) do 
                local ThemesSection = ThemingSubPage:Section({Name = "Themes", Side = 1}) do
                    for Index, Value in Library.Theme do 
                        ThemesSection:Label(Index):Colorpicker({
                            Name = Index,
                            Flag = Index.."Theme",
                            Default = Value,
                            Callback = function(Value)
                                Library.Theme[Index] = Value
                                Library:ChangeTheme(Index, Value)
                            end
                        })
                    end
                end
            end

            local ConfigsSubPage = SettingsPage:SubPage({Name = "Configs", Columns = 2}) do 
                local ConfigsSection = ConfigsSubPage:Section({Name = "Configs", Side = 1}) do
                    local ConfigName
                    local ConfigSelected

                    local ConfigsSearchbox = ConfigsSection:Searchbox({
                        Name = "SearchboxConfigs",
                        Flag = "ConfigsSearchobx",
                        Items = { },
                        Multi = false,
                        Callback = function(Value)
                            ConfigSelected = Value
                        end
                    })

                    ConfigsSection:Textbox({
                        Name = "Config name", 
                        Default = "", 
                        Flag = "ConfigName", 
                        Placeholder = "Enter text", 
                        Callback = function(Value)
                            ConfigName = Value
                        end
                    })

                    local CreateAndDeleteButton = ConfigsSection:Button()

                    CreateAndDeleteButton:Add("Create", function()
                        if ConfigName and ConfigName ~= "" then
                            if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                                writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                                Library:Notification("Success", "Created config "..ConfigName .. " succesfully", 5)
                                Library:RefreshConfigsList(ConfigsSearchbox)
                            else
                                Library:Notification("Error", "Config with the name "..ConfigName .. " already exists", 5)
                                return
                            end
                        end
                    end)

                    CreateAndDeleteButton:Add("Delete", function()
                        if ConfigSelected then
                            Library:DeleteConfig(ConfigSelected)
                            Library:Notification("Success", "Deleted config "..ConfigSelected .. " succesfully", 5)
                            Library:RefreshConfigsList(ConfigsSearchbox)
                        end
                    end)

                    local LoadAndSaveButton = ConfigsSection:Button()    

                    LoadAndSaveButton:Add("Load", function()
                        if ConfigSelected then
                            local Success, Result = Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected))

                            if Success then 
                                Library:Notification("Success", "Loaded config "..ConfigSelected .. " succesfully", 5)
                            else
                                Library:Notification("Error", "Failed to load config "..ConfigSelected .. " report this to the devs:\n"..Result, 5)
                            end
                        end
                    end)

                    LoadAndSaveButton:Add("Save", function()
                        if ConfigName and ConfigName ~= "" then
                            writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                            Library:Notification("Success", "Saved config "..ConfigName .. " succesfully", 5)
                            Library:RefreshConfigsList(ConfigsSearchbox)
                        end
                    end)

                    Library:RefreshConfigsList(ConfigsSearchbox)
                end
            end

            local SettingsSubPage = SettingsPage:SubPage({Name = "Settings", Columns = 2}) do 
                local SettingsSection = SettingsSubPage:Section({Name = "Settings", Side = 1}) do
                    SettingsSection:Toggle({
                        Name = "Watermark",
                        Flag = "Watermark",
                        Default = true,
                        Callback = function(Value)
                            Watermark:SetVisibility(Value)
                        end
                    })

                    SettingsSection:Toggle({
                        Name = "Keybind list",
                        Flag = "Keybind list",
                        Default = true,
                        Callback = function(Value)
                            KeybindList:SetVisibility(Value)
                        end
                    })

                    SettingsSection:Slider({
                        Name = "Fade time",
                        Flag = "FadeTime",
                        Default = Library.FadeSpeed,
                        Min = 0,
                        Max = 1,
                        Decimals = 0.01,
                        Callback = function(Value)
                            Library.FadeSpeed = Value
                        end
                    })

                    SettingsSection:Slider({
                        Name = "Tween time",
                        Flag = "TweenTime",
                        Default = Library.Tween.Time,
                        Min = 0,
                        Max = 1,
                        Decimals = 0.01,
                        Callback = function(Value)
                            Library.Tween.Time = Value
                        end
                    })

                    SettingsSection:Dropdown({
                        Name = "Tween style",
                        Flag = "Tween style",
                        Items = { "Linear", "Quad", "Quart", "Back", "Bounce", "Circular", "Cubic", "Elastic", "Exponential", "Sine", "Quint" },
                        Default = "Cubic",
                        Callback = function(Value)
                            Library.Tween.Style = Enum.EasingStyle[Value]
                        end
                    })

                    SettingsSection:Dropdown({
                        Name = "Tween direction",
                        Flag = "Tween direction",
                        Items = { "In", "Out", "InOut" },
                        Default = "Out",
                        Callback = function(Value)
                            Library.Tween.Direction = Enum.EasingDirection[Value]
                        end
                    })

                    SettingsSection:Button():Add("Unload", function()
                        Library:Unload()
                    end)

                    SettingsSection:Label("UI Keybind"):Keybind({
                        Name = "Menu keybind",
                        Flag = "UIKeybind",
                        Default = Enum.KeyCode.RightShift,
                        Mode = "Toggle",
                        List = false,
                        IgnorePress = true,
                        Callback = function()
                            Library.MenuKeybind = Library.Flags["UIKeybind"].Key
                        end
                    })
                end
            end
        end
        
        return SettingsPage
    end
end





























































--> SCRIPT

Library.SpinFrames = {
	"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",
}

getgenv().Library = Library
return Library

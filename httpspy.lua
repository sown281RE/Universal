--// This file was created by XHider https://discord.com/invite/E2N7w35zkt
assert(syn or http, "Unsupported exploit (should support syn.request or http.request)");
local function R()
	local R = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	local L = "";
	for Q = 1, math.random(12, 20), 1 do
		local J = math.random(1, #R);
		L = L .. R:sub(J, J);
	end;
	return L;
end;
local L = ({ ... })[1] or {
		AutoDecode = true,
		Highlighting = true,
		SaveLogs = true,
		CLICommands = true,
		ShowResponse = true,
		BlockedURLs = {},
		API = true,
		GuiEnabled = true,
	};
local Q = "v2.0 Anti-Detection";
local J = string.format("%d-%s-log.txt", game.PlaceId, os.date("%d_%m_%y"));
local c = {
		ScreenGui = R(),
		MainFrame = R(),
		TitleBar = R(),
		LogsFrame = R(),
		MinimizedIcon = R(),
	};
if L.SaveLogs then
	pcall(function()
		writefile(J, string.format("Http Logs from %s\n\n", os.date("%d/%m/%y")));
	end);
end;
local x;
pcall(function()
	x = (loadstring(game:HttpGet("https://raw.githubusercontent.com/NotDSF/leopard/main/rbx/leopard-syn.lua")))();
	x.UpdateConfig({ highlighting = L.Highlighting });
end);
if not x then
	warn("Failed to load Serializer - some features may not work properly");
	x = { Serialize = function(R)
				return tostring(R);
			end, FormatArguments = function(...)
				return table.concat({ ... }, ", ");
			end };
end;
local a = "Anti-Detection Build";
pcall(function()
	a = (game.HttpService:JSONDecode(game:HttpGet("https://api.github.com/repos/NotDSF/HttpSpy/commits?per_page=1&path=init.lua")))[1].commit.message;
end);
local V, p = pcall(function()
		local V = clonefunction;
		local p = V(string.format);
		local n = V(string.gsub);
		local h = V(string.match);
		local Y = V(appendfile);
		local X = V(type);
		local q = V(coroutine.running);
		local f = V(coroutine.wrap);
		local o = V(coroutine.resume);
		local N = V(coroutine.yield);
		local B = V(pcall);
		local W = V(pairs);
		local P = V(error);
		local I = V(getnamecallmethod);
		local k = L.BlockedURLs;
		local m = true;
		local g = (syn or http).request;
		local z = syn and "syn" or "http";
		local T = {};
		local i = {};
		local v = {
				HttpGet = not syn,
				HttpGetAsync = not syn,
				GetObjects = true,
				HttpPost = not syn,
				HttpPostAsync = not syn,
			};
		local E = Instance.new("BindableEvent");
		local S = Instance.new("ScreenGui");
		S.Name = c.ScreenGui;
		S.DisplayOrder = 999;
		S.ResetOnSpawn = false;
		S.IgnoreGuiInset = true;
		S.Parent = game:GetService("CoreGui");
		local w = Instance.new("Frame");
		w.Name = c.MainFrame;
		w.Size = UDim2.new(0, 650, 0, 450);
		w.Position = UDim2.new(.5, -325, .5, -225);
		w.BackgroundColor3 = Color3.fromRGB(20, 20, 25);
		w.BorderColor3 = Color3.fromRGB(55, 55, 65);
		w.BorderSizePixel = 2;
		w.ClipsDescendants = true;
		w.Parent = S;
		local C = Instance.new("UICorner");
		C.CornerRadius = UDim.new(0, 8);
		C.Parent = w;
		local H, D, Z, b = nil, nil, nil, false;
		w.InputBegan:Connect(function(R)
			if R.UserInputType == Enum.UserInputType.MouseButton1 then
				b = true;
				D = R.Position;
				Z = w.Position;
				R.Changed:Connect(function()
					if R.UserInputState == Enum.UserInputState.End then
						b = false;
					end;
				end);
			end;
		end);
		w.InputChanged:Connect(function(R)
			if R.UserInputType == Enum.UserInputType.MouseMovement then
				H = R;
			end;
		end);
		(game:GetService("UserInputService")).InputChanged:Connect(function(R)
			if R == H and b then
				local L = R.Position - D;
				w.Position = UDim2.new(Z.X.Scale, Z.X.Offset + L.X, Z.Y.Scale, Z.Y.Offset + L.Y);
			end;
		end);
		local r = Instance.new("Frame");
		r.Name = c.TitleBar;
		r.Size = UDim2.new(1, 0, 0, 35);
		r.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
		r.BorderSizePixel = 0;
		r.Parent = w;
		local A = Instance.new("UICorner");
		A.CornerRadius = UDim.new(0, 8);
		A.Parent = r;
		local U = Instance.new("Frame");
		U.Size = UDim2.new(1, 0, 0, 10);
		U.Position = UDim2.new(0, 0, 1, -10);
		U.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
		U.BorderSizePixel = 0;
		U.Parent = r;
		local G = Instance.new("TextLabel");
		G.Size = UDim2.new(1, -200, 1, 0);
		G.Position = UDim2.new(0, 15, 0, 0);
		G.BackgroundTransparency = 1;
		G.Text = "\240\159\148\141 HttpSpy " .. Q;
		G.TextColor3 = Color3.fromRGB(255, 255, 255);
		G.Font = Enum.Font.GothamBold;
		G.TextSize = 15;
		G.TextXAlignment = Enum.TextXAlignment.Left;
		G.Parent = r;
		local y = Instance.new("Frame");
		y.Size = UDim2.new(0, 210, 1, 0);
		y.Position = UDim2.new(1, -215, 0, 0);
		y.BackgroundTransparency = 1;
		y.Parent = r;
		local s = Instance.new("TextButton");
		s.Size = UDim2.new(0, 70, 0, 24);
		s.Position = UDim2.new(0, 0, .5, -12);
		s.Text = "\240\159\159\162 ON";
		s.Font = Enum.Font.GothamBold;
		s.TextSize = 12;
		s.BackgroundColor3 = Color3.fromRGB(40, 140, 60);
		s.TextColor3 = Color3.fromRGB(255, 255, 255);
		s.BorderSizePixel = 0;
		s.AutoButtonColor = false;
		s.Parent = y;
		local t = Instance.new("UICorner");
		t.CornerRadius = UDim.new(0, 6);
		t.Parent = s;
		local M = Instance.new("TextButton");
		M.Size = UDim2.new(0, 30, 0, 24);
		M.Position = UDim2.new(0, 75, .5, -12);
		M.Text = "\226\148\129";
		M.Font = Enum.Font.GothamBold;
		M.TextSize = 14;
		M.BackgroundColor3 = Color3.fromRGB(60, 60, 70);
		M.TextColor3 = Color3.fromRGB(255, 255, 255);
		M.BorderSizePixel = 0;
		M.AutoButtonColor = false;
		M.Parent = y;
		local d = Instance.new("UICorner");
		d.CornerRadius = UDim.new(0, 6);
		d.Parent = M;
		local K = Instance.new("TextButton");
		K.Size = UDim2.new(0, 30, 0, 24);
		K.Position = UDim2.new(0, 110, .5, -12);
		K.Text = "\226\150\161";
		K.Font = Enum.Font.GothamBold;
		K.TextSize = 14;
		K.BackgroundColor3 = Color3.fromRGB(60, 60, 70);
		K.TextColor3 = Color3.fromRGB(255, 255, 255);
		K.BorderSizePixel = 0;
		K.AutoButtonColor = false;
		K.Parent = y;
		local F = Instance.new("UICorner");
		F.CornerRadius = UDim.new(0, 6);
		F.Parent = K;
		local l = Instance.new("TextButton");
		l.Size = UDim2.new(0, 30, 0, 24);
		l.Position = UDim2.new(0, 145, .5, -12);
		l.Text = "\226\156\149";
		l.Font = Enum.Font.GothamBold;
		l.TextSize = 14;
		l.BackgroundColor3 = Color3.fromRGB(180, 50, 50);
		l.TextColor3 = Color3.fromRGB(255, 255, 255);
		l.BorderSizePixel = 0;
		l.AutoButtonColor = false;
		l.Parent = y;
		local e = Instance.new("UICorner");
		e.CornerRadius = UDim.new(0, 6);
		e.Parent = l;
		local O = Instance.new("TextButton");
		O.Name = c.MinimizedIcon;
		O.Size = UDim2.new(0, 45, 0, 45);
		O.Position = UDim2.new(.5, -22, 0, 15);
		O.Text = "\240\159\148\141";
		O.Font = Enum.Font.GothamBold;
		O.TextSize = 22;
		O.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
		O.TextColor3 = Color3.fromRGB(255, 255, 255);
		O.BorderSizePixel = 2;
		O.BorderColor3 = Color3.fromRGB(55, 55, 65);
		O.AutoButtonColor = false;
		O.Visible = false;
		O.ZIndex = 1000;
		O.Parent = S;
		local u = Instance.new("UICorner");
		u.CornerRadius = UDim.new(0, 8);
		u.Parent = O;
		local j = Instance.new("ScrollingFrame");
		j.Name = c.LogsFrame;
		j.Size = UDim2.new(1, -20, 1, -110);
		j.Position = UDim2.new(0, 10, 0, 45);
		j.BackgroundColor3 = Color3.fromRGB(15, 15, 20);
		j.BorderSizePixel = 0;
		j.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90);
		j.ScrollBarThickness = 8;
		j.AutomaticCanvasSize = Enum.AutomaticSize.Y;
		j.ScrollingDirection = Enum.ScrollingDirection.Y;
		j.CanvasSize = UDim2.new(0, 0, 0, 0);
		j.Parent = w;
		local RS = Instance.new("UICorner");
		RS.CornerRadius = UDim.new(0, 6);
		RS.Parent = j;
		local LS = Instance.new("UIListLayout");
		LS.Padding = UDim.new(0, 10);
		LS.SortOrder = Enum.SortOrder.LayoutOrder;
		LS.Parent = j;
		local QS = Instance.new("UIPadding");
		QS.PaddingLeft = UDim.new(0, 10);
		QS.PaddingRight = UDim.new(0, 10);
		QS.PaddingTop = UDim.new(0, 10);
		QS.PaddingBottom = UDim.new(0, 10);
		QS.Parent = j;
		local JS = Instance.new("Frame");
		JS.Size = UDim2.new(1, -20, 0, 50);
		JS.Position = UDim2.new(0, 10, 1, -60);
		JS.BackgroundColor3 = Color3.fromRGB(25, 25, 32);
		JS.BorderSizePixel = 0;
		JS.Parent = w;
		local cS = Instance.new("UICorner");
		cS.CornerRadius = UDim.new(0, 6);
		cS.Parent = JS;
		local xS = Instance.new("TextButton");
		xS.Size = UDim2.new(0, 90, 0, 30);
		xS.Position = UDim2.new(0, 10, .5, -15);
		xS.Text = "\240\159\151\145\239\184\143 Clear";
		xS.Font = Enum.Font.GothamBold;
		xS.TextSize = 13;
		xS.BackgroundColor3 = Color3.fromRGB(50, 50, 60);
		xS.TextColor3 = Color3.fromRGB(255, 255, 255);
		xS.BorderSizePixel = 0;
		xS.AutoButtonColor = false;
		xS.Parent = JS;
		local aS = Instance.new("UICorner");
		aS.CornerRadius = UDim.new(0, 6);
		aS.Parent = xS;
		local VS = Instance.new("TextBox");
		VS.Size = UDim2.new(0, 250, 0, 30);
		VS.Position = UDim2.new(0, 110, .5, -15);
		VS.PlaceholderText = "\240\159\148\142 Filter requests...";
		VS.Text = "";
		VS.Font = Enum.Font.Gotham;
		VS.TextSize = 12;
		VS.BackgroundColor3 = Color3.fromRGB(35, 35, 45);
		VS.TextColor3 = Color3.fromRGB(255, 255, 255);
		VS.PlaceholderColor3 = Color3.fromRGB(150, 150, 160);
		VS.BorderSizePixel = 0;
		VS.TextXAlignment = Enum.TextXAlignment.Left;
		VS.Parent = JS;
		local pS = Instance.new("UICorner");
		pS.CornerRadius = UDim.new(0, 6);
		pS.Parent = VS;
		local nS = Instance.new("UIPadding");
		nS.PaddingLeft = UDim.new(0, 10);
		nS.Parent = VS;
		local hS = Instance.new("TextLabel");
		hS.Size = UDim2.new(0, 150, 1, 0);
		hS.Position = UDim2.new(1, -160, 0, 0);
		hS.Text = "\240\159\147\138 Requests: 0";
		hS.Font = Enum.Font.GothamBold;
		hS.TextSize = 13;
		hS.BackgroundTransparency = 1;
		hS.TextColor3 = Color3.fromRGB(100, 200, 255);
		hS.TextXAlignment = Enum.TextXAlignment.Right;
		hS.Parent = JS;
		local YS = 0;
		local function XS(R, L, Q)
			R.MouseEnter:Connect(function()
				R.BackgroundColor3 = L;
			end);
			R.MouseLeave:Connect(function()
				R.BackgroundColor3 = Q;
			end);
		end;
		XS(s, Color3.fromRGB(50, 160, 80), Color3.fromRGB(40, 140, 60));
		XS(M, Color3.fromRGB(80, 80, 90), Color3.fromRGB(60, 60, 70));
		XS(K, Color3.fromRGB(80, 80, 90), Color3.fromRGB(60, 60, 70));
		XS(l, Color3.fromRGB(220, 70, 70), Color3.fromRGB(180, 50, 50));
		XS(xS, Color3.fromRGB(70, 70, 80), Color3.fromRGB(50, 50, 60));
		XS(O, Color3.fromRGB(45, 45, 55), Color3.fromRGB(30, 30, 38));
		s.MouseButton1Click:Connect(function()
			m = not m;
			s.Text = m and "\240\159\159\162 ON" or "\240\159\148\180 OFF";
			s.BackgroundColor3 = m and Color3.fromRGB(40, 140, 60) or Color3.fromRGB(140, 40, 40);
		end);
		local qS = false;
		M.MouseButton1Click:Connect(function()
			qS = true;
			w.Visible = false;
			O.Visible = true;
		end);
		O.MouseButton1Click:Connect(function()
			qS = false;
			w.Visible = true;
			O.Visible = false;
		end);
		local fS = false;
		local oS = w.Size;
		local NS = w.Position;
		K.MouseButton1Click:Connect(function()
			fS = not fS;
			if fS then
				w.Size = UDim2.new(.95, 0, .95, 0);
				w.Position = UDim2.new(.025, 0, .025, 0);
				K.Text = "\226\157\144";
			else
				w.Size = oS;
				w.Position = NS;
				K.Text = "\226\150\161";
			end;
		end);
		l.MouseButton1Click:Connect(function()
			if __namecall then
				hookmetamethod(game, "__namecall", __namecall);
			end;
			if __request then
				hookfunction(g, __request);
			end;
			S:Destroy();
			(getgenv()).HttpSpy = nil;
		end);
		xS.MouseButton1Click:Connect(function()
			for R, L in ipairs(j:GetChildren()) do
				if L:IsA("Frame") then
					L:Destroy();
				end;
			end;
			YS = 0;
			hS.Text = "\240\159\147\138 Requests: 0";
		end);
		(VS:GetPropertyChangedSignal("Text")):Connect(function()
			local R = string.lower(VS.Text);
			for L, Q in ipairs(j:GetChildren()) do
				if Q:IsA("Frame") then
					local L = Q:FindFirstChild("ContentLabel");
					if L and L.Text then
						Q.Visible = R == "" or string.find(string.lower(L.Text), R, 1, true) ~= nil;
					end;
				end;
			end;
		end);
		local function BS(Q, c)
			if L.SaveLogs then
				pcall(function()
					Y(J, n(Q, "%\027%[%d+m", ""));
				end);
			end;
			if not L.GuiEnabled then
				return;
			end;
			local x = Q:gsub("\027%[[%d;]+m", "");
			task.spawn(function()
				pcall(function()
					YS = YS + 1;
					hS.Text = "\240\159\147\138 Requests: " .. YS;
					local L = Instance.new("Frame");
					L.Name = R();
					L.Size = UDim2.new(1, -10, 0, 0);
					L.BackgroundColor3 = c and Color3.fromRGB(25, 40, 25) or Color3.fromRGB(35, 25, 40);
					L.BorderSizePixel = 0;
					L.AutomaticSize = Enum.AutomaticSize.Y;
					L.LayoutOrder = YS;
					L.Parent = j;
					local Q = Instance.new("UICorner");
					Q.CornerRadius = UDim.new(0, 6);
					Q.Parent = L;
					local J = Instance.new("UIPadding");
					J.PaddingLeft = UDim.new(0, 12);
					J.PaddingRight = UDim.new(0, 12);
					J.PaddingTop = UDim.new(0, 10);
					J.PaddingBottom = UDim.new(0, 10);
					J.Parent = L;
					local a = Instance.new("Frame");
					a.Size = UDim2.new(1, 0, 0, 20);
					a.BackgroundTransparency = 1;
					a.Parent = L;
					local V = Instance.new("TextLabel");
					V.Size = UDim2.new(0, 100, 1, 0);
					V.BackgroundTransparency = 1;
					V.Text = c and "\240\159\147\165 Response" or "\240\159\147\164 Request";
					V.TextColor3 = c and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 150, 100);
					V.Font = Enum.Font.GothamBold;
					V.TextSize = 12;
					V.TextXAlignment = Enum.TextXAlignment.Left;
					V.Parent = a;
					local p = Instance.new("TextLabel");
					p.Size = UDim2.new(0, 80, 1, 0);
					p.Position = UDim2.new(0, 110, 0, 0);
					p.BackgroundTransparency = 1;
					p.Text = "\226\143\176 " .. os.date("%H:%M:%S");
					p.TextColor3 = Color3.fromRGB(150, 150, 160);
					p.Font = Enum.Font.Gotham;
					p.TextSize = 11;
					p.TextXAlignment = Enum.TextXAlignment.Left;
					p.Parent = a;
					local n = Instance.new("TextButton");
					n.Size = UDim2.new(0, 60, 0, 20);
					n.Position = UDim2.new(1, -60, 0, 0);
					n.Text = "\240\159\147\139 Copy";
					n.Font = Enum.Font.GothamBold;
					n.TextSize = 11;
					n.BackgroundColor3 = Color3.fromRGB(60, 80, 120);
					n.TextColor3 = Color3.fromRGB(255, 255, 255);
					n.BorderSizePixel = 0;
					n.AutoButtonColor = false;
					n.Parent = a;
					local h = Instance.new("UICorner");
					h.CornerRadius = UDim.new(0, 4);
					h.Parent = n;
					XS(n, Color3.fromRGB(80, 100, 140), Color3.fromRGB(60, 80, 120));
					n.MouseButton1Click:Connect(function()
						setclipboard(x);
						n.Text = "\226\156\147 Copied";
						task.wait(1.5);
						n.Text = "\240\159\147\139 Copy";
					end);
					local Y = Instance.new("TextLabel");
					Y.Name = "ContentLabel";
					Y.Size = UDim2.new(1, 0, 0, 0);
					Y.Position = UDim2.new(0, 0, 0, 25);
					Y.Text = x;
					Y.TextColor3 = Color3.fromRGB(240, 240, 245);
					Y.BackgroundTransparency = 1;
					Y.TextXAlignment = Enum.TextXAlignment.Left;
					Y.TextYAlignment = Enum.TextYAlignment.Top;
					Y.TextWrapped = true;
					Y.Font = Enum.Font.Code;
					Y.TextSize = 13;
					Y.AutomaticSize = Enum.AutomaticSize.Y;
					Y.Parent = L;
					if VS.Text == "" then
						task.wait();
						j.CanvasPosition = Vector2.new(0, j.AbsoluteCanvasSize.Y);
					end;
				end);
			end);
		end;
		local function WS(R)
			for L, Q in W(getgc(true)) do
				if type(Q) == "function" and (islclosure(Q) and ((getfenv(Q)).script == (getfenv(saveinstance)).script and table.find(debug.getconstants(Q), R))) then
					return Q;
				end;
			end;
		end;
		local function PS(R, L)
			L = L or {};
			for R, Q in W(R) do
				if X(Q) == "table" then
					L[R] = PS(Q);
					continue;
				end;
				L[R] = Q;
			end;
			return L;
		end;
		local IS, kS;
		IS = hookmetamethod(game, "__namecall", newcclosure(function(R, ...)
				local L = I();
				if v[L] then
					BS("game:" .. (L .. ("(" .. (x.FormatArguments(...) .. ")\n\n"))));
				end;
				return IS(R, ...);
			end));
		kS = hookfunction(g, newcclosure(function(R)
				if X(R) ~= "table" then
					return kS(R);
				end;
				local Q = PS(R);
				if not m then
					return kS(R);
				end;
				if X(Q.Url) ~= "string" then
					return kS(R);
				end;
				if not L.ShowResponse then
					BS(z .. (".request(" .. (x.Serialize(Q) .. ")\n\n")));
					return kS(R);
				end;
				local J = q();
				(f(function()
					if Q.Url and k[Q.Url] then
						BS(z .. (".request(" .. (x.Serialize(Q) .. ") -- blocked url\n\n")));
						return o(J, {});
					end;
					if Q.Url then
						local R = string.match(Q.Url, "https?://(%w+.%w+)/");
						if R and i[R] then
							Q.Url = n(Q.Url, R, i[R], 1);
						end;
					end;
					E:Fire(Q);
					local R, c = B(kS, Q);
					if not R then
						P(c, 0);
					end;
					local a = {};
					for R, L in W(c) do
						a[R] = L;
					end;
					if a.Headers["Content-Type"] and (h(a.Headers["Content-Type"], "application/json") and L.AutoDecode) then
						local R = a.Body;
						local L, Q = B(game.HttpService.JSONDecode, game.HttpService, R);
						if L then
							a.Body = Q;
						end;
					end;
					BS(z .. (".request(" .. (x.Serialize(Q) .. ")\n\n")), false);
					BS("Response Data: " .. (x.Serialize(a) .. "\n\n"), true);
					o(J, T[Q.Url] and T[Q.Url](c) or c);
				end))();
				return N();
			end));
		if request then
			replaceclosure(request, g);
		end;
		if syn and syn.websocket then
			local R, L = debug.getupvalue(syn.websocket.connect, 1);
			L = hookfunction(R, function(...)
					BS("syn.websocket.connect(" .. (x.FormatArguments(...) .. ")\n\n"));
					return L(...);
				end);
		end;
		if syn and syn.websocket then
			local R;
			R = hookfunction(getupvalue(WS("ZeZLm2hpvGJrD6OP8A3aEszPNEw8OxGb"), 2), function(L, ...)
					BS("game.HttpGet(game, " .. (x.FormatArguments(...) .. ")\n\n"));
					return R(L, ...);
				end);
			local L;
			L = hookfunction(getupvalue(WS("gpGXBVpEoOOktZWoYECgAY31o0BlhOue"), 2), function(R, ...)
					BS("game.HttpPost(game, " .. (x.FormatArguments(...) .. ")\n\n"));
					return L(R, ...);
				end);
		end;
		for R, L in W(v) do
			if L then
				local L;
				L = hookfunction(game[R], newcclosure(function(Q, ...)
						BS("game." .. (R .. ("(game, " .. (x.FormatArguments(...) .. ")\n\n"))));
						return L(Q, ...);
					end));
			end;
		end;
		if not debug.info(2, "f") then
			BS("You are running an outdated version, please use the loadstring at https://github.com/NotDSF/HttpSpy\n");
		end;
		task.spawn(function()
			BS("HttpSpy " .. (Q .. (" - Anti-Detection Build\n\226\156\147 GUI Names Randomized\n\226\156\147 Stealth Mode Active\nChange Logs:\n\t" .. (a .. ("\nLogs saved to: " .. ((L.SaveLogs and J or "(Disabled)") .. "\n\n"))))));
		end);
		if not L.API then
			return;
		end;
		local mS = {};
		mS.OnRequest = E.Event;
		function mS.HookSynRequest(R, L, Q)
			T[L] = Q;
		end;
		function mS.ProxyHost(R, L, Q)
			i[L] = Q;
		end;
		function mS.RemoveProxy(R, L)
			if not i[L] then
				error("host isn\'t proxied", 0);
			end;
			i[L] = nil;
		end;
		function mS.UnHookSynRequest(R, L)
			if not T[L] then
				error("url isn\'t hooked", 0);
			end;
			T[L] = nil;
		end;
		function mS.BlockUrl(R, L)
			k[L] = true;
		end;
		function mS.WhitelistUrl(R, L)
			k[L] = false;
		end;
		function mS.ToggleGui(R, Q)
			S.Enabled = Q;
			L.GuiEnabled = Q;
		end;
		function mS.SetGuiPosition(R, L)
			w.Position = L;
		end;
		function mS.SetGuiSize(R, L)
			w.Size = L;
		end;
		function mS.GetGuiNames(R)
			return c;
		end;
		return mS;
	end);
if not V and p then
	warn("HttpSpy initialization failed: " .. tostring(p));
	if rconsoleprint then
		rconsoleprint("@@RED@@");
		rconsoleprint("HttpSpy initialization error: " .. (tostring(p) .. "\n"));
	end;
	return nil;
end;

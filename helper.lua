local encoding = require 'encoding'
local inicfg = require 'inicfg'
local sampev = require 'lib.samp.events'
local bNotf, notf = pcall(import, "imgui_notf.lua")
local imgui = require 'imgui'
local bNotf, notf = pcall(import, "imgui_notf.lua")
encoding.default = 'CP1251'
u8 = encoding.UTF8

local memory = require 'memory'

imgui.ToggleButton = require('imgui_addons').ToggleButton
local sBool = imgui.ImBool(false)
local main_window_state = imgui.ImBool(false)

local mainIni = inicfg.load({
config =
{
tlf = false,
time = false,
lock = false,
key = false,
aut = false,
abc = false,
acd = false,
mbc = false,
at = false,
act = false,
primer = ' ',
ssp = '1200',
tsp = 'Text',
bb = false,
aafk = false
}
}, 'helper')

local tlf = imgui.ImBool(mainIni.config.tlf)
local time = imgui.ImBool(mainIni.config.time)
local lock = imgui.ImBool(mainIni.config.lock)
local key = imgui.ImBool(mainIni.config.key)
local aut = imgui.ImBool(mainIni.config.aut)
local mbc = imgui.ImBool(mainIni.config.mbc)
local acd = imgui.ImBool(mainIni.config.acd)
local at = imgui.ImBool(mainIni.config.at)
local tsp = imgui.ImBuffer(u8'', 500)
local ssp = imgui.ImBuffer(u8'1200', 500)
local primer = imgui.ImBuffer(u8'', 500)
local smsbc = imgui.ImBuffer(u8'', 500)
local mbc = imgui.ImBool(mainIni.config.mbc)
local bb = imgui.ImBool(mainIni.config.bb)
local aafk = imgui.ImBool(mainIni.config.aafk)

local status = inicfg.load(mainIni, 'helper.ini')
if not doesFileExist('moonloader/config/helper.ini') then inicfg.save(mainIni, 'helper.ini') end

function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
    colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
    colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
    colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
    colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
    colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
    colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
    colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
    colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
apply_custom_style()

function imgui.OnDrawFrame()
  		imgui.ShowCursor = main_window_state.v
  if main_window_state.v then
		imgui.SetNextWindowSize(imgui.ImVec2(700, 267), imgui.Cond.FirstUseEver)
		if not window_pos then
			ScreenX, ScreenY = getScreenResolution()ScreenX, ScreenY = getScreenResolution()
			imgui.SetNextWindowPos(imgui.ImVec2(ScreenX / 2 , ScreenY / 2), imgui.Cond.FirsUseEver, imgui.ImVec2(0.5, 0.5))
		end
	  imgui.Begin(u8'Helper | ID VK Author @i_ne_v_seti', main_window_state, imgui.WindowFlags.NoResize)
	    imgui.BeginChild("##g_sexbar", imgui.ImVec2(682.5, 106), true)
			if imgui.CollapsingHeader(u8'������', imgui.ImVec2(10,5)) then
				imgui.Text(u8'������� ����� ��� �����.')
				imgui.SameLine()
				imgui.Text(u8'                                                                                     ������� ��������.')
				imgui.SameLine()
				imgui.TextQuestion(u8'��� �� ������������ ���� ������� ������� <</spam>>.')
				imgui.SameLine()
				imgui.TextWarrning(u8'������ ��� ������ ���� ��������� ������, �������� �������� � ����-��������.')
				imgui.InputText(u8' - ', tsp)
				imgui.SameLine()
				imgui.InputText(u8'', ssp)
			end
			if imgui.CollapsingHeader(u8'�����������') then
				imgui.Text(u8'������� ������.')
				imgui.SameLine()
				imgui.TextQuestion(u8'��� �� ������ ������ ������� ������� <</ca>>.')
				imgui.SameLine()
				imgui.TextWarrning(u8'������ ��� ���������� ��������� ��������� ������!')
				imgui.InputText(u8'', primer)
			end
			if imgui.CollapsingHeader(u8'���. �������') then
				imgui.Checkbox(u8"�������", tlf)
				imgui.SameLine()
				imgui.TextQuestion(u8'�� ���������� ������ <<P>> �� ������� ������� �������.')
				imgui.Checkbox(u8"����� �� ����", key)
				imgui.SameLine()
				imgui.TextQuestion(u8"��� ������� �� ������� <<K>> �� ��������/�������� �����")
				imgui.Checkbox(u8"�������� ����������", lock)
				imgui.SameLine()
				imgui.TextQuestion(u8"��� ������� �� ������� <<L>> �� ��������/�������� ���� ���������")
				imgui.Checkbox(u8"����", time)
				imgui.SameLine()
				imgui.TextQuestion(u8"��� ��������� ������ <<XX>> �� ���������� �� ����")
				imgui.Checkbox(u8'���� ���', aafk)
			end
			if imgui.CollapsingHeader(u8'������ � �����') then
				imgui.Checkbox(u8"���� ���� ����� �����", at)
				imgui.SameLine()
				imgui.TextQuestion(u8"����� ������� ����� ������ ��� �������� /time � ����������")
				imgui.Checkbox(u8"��������� ����� ������� ����", mbc)
				imgui.SameLine()
				imgui.TextQuestion(u8"��� ��������� ���������� ����� ������� ����.")
				imgui.InputText(u8"���������", smsbc)
				imgui.Checkbox(u8"������� �������", bb)
				imgui.SameLine()
				imgui.TextQuestion(u8"������ ���� ��� ��� ������� ������� ����� �� ������ ������ ��� ���� ����� ������ ������ ������ <<N>>")
			end
		imgui.EndChild()
		if imgui.CollapsingHeader(u8'�������� �������') then
			imgui.Text(u8'����� �������: Danil Korabelnikov (Danil_Conti)')
			imgui.Text(u8'������ �� ������ � BH -> ')
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(65/255, 105/255, 225/255, 1),u8'���')
			if imgui.IsItemClicked() then
				os.execute('start https://blast.hk/members/399616/')
			end
			imgui.Text(u8'')
			imgui.Text(u8'���� ������ ������ ����� �� ���������� � ������� ��� ��� �� ���������� ������ ������ � ��.')
			if imgui.Button(u8('��������� � �������')) then
				os.execute('start https://vk.com/i_ne_v_seti')
			end
		end
		if imgui.CollapsingHeader(u8'�������� ������/������ ������') then
				imgui.Text(u8'������� ��� �������.', 1)
				imgui.Text(u8"/spam - ������������/�������������� ���� ")
				imgui.Text(u8'/fh - ����������� ������� /findihouse [ID ����]')
				imgui.SameLine()
				imgui.TextQuestion(u8'����� ���.')
				imgui.Text(u8'/fbz - ����������� ������� /findibiz [ID �������]')
				imgui.SameLine()
				imgui.TextQuestion(u8'����� ������.')
				imgui.Text(u8'/mc [ID ������] - ����������� ������� /showmc [ID ������]')
				imgui.SameLine()
				imgui.TextQuestion(u8'�������� ���-����� ������.')
				imgui.Text(u8'/pass [ID ������] - ����������� ������� /showpass [ID ������]')
				imgui.SameLine()
				imgui.TextQuestion(u8'�������� ������� ������.')
				imgui.Text(u8'/lic [ID ������] - ����������� ������� /showlic [ID ������]')
				imgui.SameLine()
				imgui.TextQuestion(u8'�������� �������� ������.')
				imgui.Text(u8'/fc - ����������� ������� /fam [�����]')
				imgui.SameLine()
				imgui.TextQuestion(u8'�������� � ��� ����.')
				imgui.Text(u8'/fm - ����������� ������� /fammenu')
				imgui.SameLine()
				imgui.TextQuestion(u8'���� ���������� ������.')
				imgui.Text(u8'/fi [ID ������] - ����������� ������� /faminvite [ID ������]')
				imgui.SameLine()
				imgui.TextQuestion(u8'���������� ������ � �����.')
				imgui.Text('')
				imgui.Text(u8'������� ��� ���-��� ���� ������ ������.', imgui.ImVec2(20,5))
				imgui.SameLine()
				imgui.TextWarrning(u8'��� ��������� ������ ���� ���� ������� �� ����������.')
				imgui.Text(u8"ZZ ��� ��� ��� - ��������� ���� ")
				imgui.Text(u8'�� ������ <<P>> ��������� �������.')
				imgui.Text(u8'�� ������ <<L>> ��������� ���������.')
				imgui.Text(u8'�� ������ <<K>> �������� ����.')
			end
			if imgui.CollapsingHeader(u8'�������') then
				imgui.Text(u8'��- �������� ��� �������.')
				imgui.Text(u8'��- �������� � ������ (�������).')
				imgui.Text(u8'��- ����� ����, �.�. �������� ��� ���������.')
				imgui.Text(u8'��- "Team Kill" - �������� �����.')
				imgui.Text(u8'��- "Role Play"- ���� �� ����� ��� ������ ������ ��������� ���� ����.')
				imgui.Text(u8'��- "Meta Gaming" - ������������� ���������� �� ��������� ���� � ������� ���(����������: ��� � �� ).')
				imgui.Text(u8'��- "God Mood" - ��� ��� - �.�. ����� ����.')
				imgui.Text(u8'��- "Power Gaming" - ����������� �� ���� �����,�������� ����� � ���� ��� ������ � �� ����� �� �������� � ')
				imgui.Text(u8'�������� ��� ���� , ��� �������� ����� 5 ������ ������.')
				imgui.Text(u8'��- ����������� �� ����� ��� ���� �����.')
				imgui.Text(u8'��- "���� ���"- ����� ��� � �������� ( shift+space )')
				imgui.Text(u8'��-"��������� ������"')
				imgui.Text(u8'��- "������������� ������"')
				imgui.Text(u8'��- "������� ����". ������������ �����-������� � �����, �������, �������� � �.�. (� ���� ')
				imgui.Text(u8'���� ��������� ��������)')
				imgui.Text(u8'')
				imgui.Text(u8'���� ��� ����������: "��� ����� ��?" ��� (( )), �� �� ��������� ��, ��� ����� ��������� ��� ����� �.�. : " ���� ')
				imgui.Text(u8'����; ��� �������" � �.�. , � ���� ��� ���������� � ������������ � ���� ������, �.�. : (( ��� ����� ��? )) , �� ')
				imgui.Text(u8'�� � ����� � ������� ������ (( ��- �������� ��� �������.)). ')
				imgui.Text(u8'')
				imgui.Text(u8'���������. �� ��� ������� � ������� " (( )) " - ����� ���, �.�. � ���� ������� �� ��, ��� ��������� � ��������� ')
				imgui.Text(u8'����, � ����� �� �������� ������������.')
			end
		if imgui.Button(u8'���������', imgui.ImVec2(125,50)) then
			mainIni.config.primer = primer.v
			mainIni.config.ssp = ssp.v
			mainIni.config.tsp = tsp.v
			mainIni.config.tlf = tlf.v
			mainIni.config.time = time.v
			mainIni.config.lock = lock.v
			mainIni.config.key = key.v
			mainIni.config.aut = aut.v
			mainIni.config.mbc = mbc.v
			mainIni.config.acd = acd.v
			mainIni.config.mbc = mbc.v
			mainIni.config.at = at.v
			mainIni.config.smsbc = smsbc.v
			mainIni.config.bb = bb.v
			mainIni.config.aafk = aafk.v
			inicfg.save(mainIni, 'helper.ini')
		end
		imgui.SameLine()
		if imgui.Button(u8'�������������', imgui.ImVec2(125,50)) then
			mainIni.config.primer = ' '
			mainIni.config.tsp = ' '
			mainIni.config.ssp = '1200'
			thisScript():reload()
		end
		imgui.SameLine()
		if imgui.Button(u8'��������� ����������##check_update', imgui.ImVec2(125,50)) then
			local fpath = os.getenv('TEMP') .. '\\satiety-bot.json'
			downloadUrlToFile('https://gist.githubusercontent.com/CodesSamp/6980c0155468f6e8a7825076478cae43/raw/5b4ff429b410ce766274102bcce0a91b5fd32cf1/helper.json', fpath, function(id, status, p1, p2)
			    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					local f = io.open(fpath, 'r')
					if f then
						local info = decodeJson(f:read('*a'))
						updatelink = info.updateurl
						if info and info.latest then
							version = tonumber(info.latest)
							ver = tonumber(info.ver)
							if version > tonumber(thisScript().version) then
								new = 1
								sampAddChatMessage(('[Helper]: {FFFFFF}�������� ����������!'), 0xF1CB09)
							else
								update = false
								sampAddChatMessage(('[Helper]: {FFFFFF}� ��� ����������� ��������� ������!'), 0xF1CB09)
							end
						end
					end
				end
			end)
		end
		if new == 1 then
			imgui.SameLine()
			if imgui.Button(u8'��������##update') then
				lua_thread.create(function()
					sampAddChatMessage(('[Helper]: ����������...'), 0xF1CB09)
					wait(300)
					downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
						if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
							sampAddChatMessage(('[Helper]: ���������� ���������!'), 0xF1CB09)
							thisScript():reload()
						end
					end)
				end)
			end
		end
		imgui.SameLine()
		imgui.TextWarrning(u8'������ <<��������� ����������>> � ���� �����, �� ��������!!!')
		imgui.End()
	end
end

function main()
	while not isSampAvailable() do wait(0) end
		
	imgui.Process = false
		
	notf.addNotification("������ ��� ������� ��������", 5, 1)
		
	sampAddChatMessage('{610BBE}[Helper] {FFFFFF}������ ������� ������������� {E00B0B}Danil_Conti.')
	
	sampRegisterChatCommand('ca', calc)
		
	sampRegisterChatCommand('spam', function() 
	act = not act; sampAddChatMessage(act and '{01A0E9}���� �������!' or '{01A0E9}���� ��������!', -1)
	if act then
	 spam()
	end
	end)
		
	sampRegisterChatCommand('fh', function(num) 
		if num ~= nil then 
			sampSendChat('/findihouse '..num) 
		end 
	end)
	sampRegisterChatCommand('fbz', function(num) 
		if num ~= nil then 
			sampSendChat('/findibiz '..num) 
		end 
	end)
	sampRegisterChatCommand('pass', function(num) 
		if num ~= nil then 
			sampSendChat('/showpass '..num) 
		end 
	end)
	sampRegisterChatCommand('mc', function(num) 
		if num ~= nil then 
			sampSendChat('/showmc '..num) 
		end 
	end)
	sampRegisterChatCommand('lic', function(num) 
		if num ~= nil then 
			sampSendChat('/showlic '..num) 
		end 
	end)
	sampRegisterChatCommand('fc', function(num) 
		if num ~= nil then 
			sampSendChat('/fam '..num) 
		end 
	end)
	sampRegisterChatCommand('fm', function(num) 
		if num ~= nil then 
			sampSendChat('/fammenu'..num) 
		end 
	end)
	sampRegisterChatCommand('fi', function(num) 
		if num ~= nil then 
			sampSendChat('/faminvite'..num) 
		end 
	end)
	while true do
		wait(0)
		
		if bb.v and not sampIsCursorActive() then
			if testCheat('N') then
				sampSendChat('/buybiz')
			end
        end
		if tlf.v and wasKeyPressed(0x50) and not sampIsCursorActive() then
			sampSendChat("/phone")
		end
		if key.v and not sampIsCursorActive() then
			if testCheat("k") then
				sampSendChat("/key")
			end
		end
		if lock.v and not sampIsCursorActive() then
			if testCheat("l") then
				sampSendChat("/lock")
			end
		end
		if time.v then
			if testCheat("xx") and not sampIsCursorActive() then
				sampSendChat("/me �������� �� ���� ����� <<Rolex>> � ����������� <<��� �����.>> ")
				sampSendChat("/time")
				wait(1200)
				sampSendChat ("/do �� �����:  "..os.date('%H:%M:%S'))
			end 
		end
		if not sampIsCursorActive() then
			if testCheat("zz") then
				main_window_state.v = not main_window_state.v
				imgui.Process = main_window_state.v
			end
		end
		if main_window_state.v == false then
		  imgui.Process = false
		end
	end
end

function sampev.onSendCommand(command)
	if command == '/yes' then
		sampAddChatMessage('{610BBE}[Helper] {FFFFFF}����� �� ������, � �� ��� ������ ����������!')
		return false
	end
	if command == '/YES' then
		sampAddChatMessage('{610BBE}[Helper] {FFFFFF}����� �� ������, � �� ��� ������ ����������!')
		return false
	end
	if command == '/dice' then
		sampAddChatMessage('{610BBE}[Helper] {FFFFFF}����� �� ������, � �� ��� ������ ����������!')
		return false
	end
	if command == '/DICE' then
		sampAddChatMessage('{610BBE}[Helper] {FFFFFF}����� �� ������, � �� ��� ������ ����������!')
		return false
		end
	end

function spam()
	lua_thread.create(function()
		if act then
		  sampSendChat(u8:decode(tsp.v))
		  wait(mainIni.config.ssp)
		  return true
		end
	end)
end

function imgui.TextQuestion(text)
	imgui.TextDisabled('(?)')
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(450)
		imgui.TextUnformatted(text)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end

function imgui.TextWarrning(text)
    imgui.TextDisabled('(!)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450.0)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function calc()
    if mainIni.config.primer == '' then
        sampAddChatMessage('�� �� ����� ������.')
    else
        local func = load('return ' .. mainIni.config.primer)
        if func == nil then
            sampAddChatMessage('������.', -1)
        else
            local bool, res = pcall(func)
            if bool == false or type(res) ~= 'number' then
                sampAddChatMessage('������.', -1)
            
            else
                sampAddChatMessage('���������: ' .. res, -1)
            end
        end
    end
end

function sampev.onServerMessage(cl,msg)
	if string.find(msg,'%a+_%a+%[%d+%]:%s%s%s%s') 
	then  
	msg = string.gsub(msg, "{FFFFFF}", ""); 
	msg = string.gsub(msg, "{33CCFF}", "");
	msg = string.gsub(msg, "%a+_%a+%[%d+%]:%s%s%s%s", "");
	setClipboardText(msg)
	end
end

function sampev.onServerMessage(color, text)
  if acd.v then
    if text:find("�����������! ������ ���� ��������� ����������� ���!") and not text:find('�������') and not text:find('- |') then
			sampSendChat('/lock')
	  end
  end
	if mbc.v then
		if text:find("�����������! ������ ���� ��������� ����������� ���!") and not text:find('�������') and not text:find('- |') then
			lua_thread.create(function()
				wait(500)
				sampSendChat(u8:decode(smsbc.v))
			end)
		end
	end
	if at.v then
		if text:find("�����������! ������ ���� ��������� ����������� ���!") or text:find("(.-)����������! ������ ���� ��� ���!")  and not text:find('�������') and not text:find('- |') then
			lua_thread.create(function()
				sampSendChat("/me �������� �� ���� � ����������� ������� ������")
				sampSendChat("/time")
				wait(1200)
				sampSendChat ("/do �� �����  "..os.date('%H:%M:%S'))
			end)
		end
	end
end

function sampev.onShowDialog(dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, dialogText)
	if tlf.v then
		if dialogId == 1000 then
			setVirtualKeyDown(13,false)
		end
	end
end

function afk()
	if aafk then
		printString('~g~ AFK ON', 2000)
		memory.setuint8(7634870, 1, false)
		memory.setuint8(7635034, 1, false)
		memory.fill(7623723, 144, 8, false)
		memory.fill(5499528, 144, 6, false)
	end
end
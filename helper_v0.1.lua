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
			if imgui.CollapsingHeader(u8'Ñïàìåð', imgui.ImVec2(10,5)) then
				imgui.Text(u8'Ââåäèòå òåêñò äëÿ ñïàìà.')
				imgui.SameLine()
				imgui.Text(u8'                                                                                     Ââåäèòå çàäåðæêó.')
				imgui.SameLine()
				imgui.TextQuestion(u8'×òî áû àêòèâèðîâàòü ñïàì ââåäèòå êîìàíäó <</spam>>.')
				imgui.SameLine()
				imgui.TextWarrning(u8'Ïðåæäå ÷åì íà÷àòü ñïàì ñîõðàíèòå ñêðèïò, çàäåðæêà ââîäèòñÿ â ìèëè-ñåêóíäàõ.')
				imgui.InputText(u8' - ', tsp)
				imgui.SameLine()
				imgui.InputText(u8'', ssp)
			end
			if imgui.CollapsingHeader(u8'Êàëüêóëÿòîð') then
				imgui.Text(u8'Ââåäèòå ïðèìåð.')
				imgui.SameLine()
				imgui.TextQuestion(u8'×òî áû ðåøèòü ïðèìåð ââåäèòå êîìàíäó <</ca>>.')
				imgui.SameLine()
				imgui.TextWarrning(u8'Ïðåæäå ÷åì ïîñìîòðåòü ðåçóëüòàò ñîõðàíèòå ñêðèïò!')
				imgui.InputText(u8'', primer)
			end
			if imgui.CollapsingHeader(u8'Äîï. ôóíêöèè') then
				imgui.Checkbox(u8"Òåëåôîí", tlf)
				imgui.SameLine()
				imgui.TextQuestion(u8'Íà àíãëèéñêóþ êíîïêó <<P>> âû ñìîæåòå îòêðûòü òåëåôîí.')
				imgui.Checkbox(u8"Êëþ÷è îò àâòî", key)
				imgui.SameLine()
				imgui.TextQuestion(u8"Ïðè íàæàòèè íà êëàâèøó <<K>> âû âñòàâèòå/çàáåðåòå êëþ÷è")
				imgui.Checkbox(u8"Çàêðûòèå òðàíñïîðòà", lock)
				imgui.SameLine()
				imgui.TextQuestion(u8"Ïðè íàæàòèè íà êëàâèøó <<L>> âû çàêðîåòå/îòêðîåòå ñâîé òðàíñïîðò")
				imgui.Checkbox(u8"×àñû", time)
				imgui.SameLine()
				imgui.TextQuestion(u8"Ïðè ñî÷åòàíèè êëàâèø <<XX>> âû ïîñìîòðèòå íà ÷àñû")
				imgui.Checkbox(u8'Àíòè Àôê', aafk)
			end
			if imgui.CollapsingHeader(u8'Ïîìîùü â ëîâëå') then
				imgui.Checkbox(u8"Àâòî òàéì ïîñëå ëîâëè", at)
				imgui.SameLine()
				imgui.TextQuestion(u8"Ïîñëå óäà÷íîé ëîâëè ñêðèïò ñàì ïðîïèøåò /time ñ îòûãðîâêîé")
				imgui.Checkbox(u8"Ñîîáùåíèå ïîñëå ïîêóïêè àâòî", mbc)
				imgui.SameLine()
				imgui.TextQuestion(u8"Ýòî ñîîáùåíèå îòïðàâèòñÿ ïîñëå ïîêóïêè àâòî.")
				imgui.InputText(u8"Ñîîáùåíèå", smsbc)
				imgui.Checkbox(u8"Ïîêóïêà áèçíåñà", bb)
				imgui.SameLine()
				imgui.TextQuestion(u8"Âìåñòî òîãî ÷òî âàì ââîäèòü êîìàíäó êîãäà âû ëîâèòå áèçíåñ âàì íàäî áóäåò ïðîñòî íàæàòü êíîïêó <<N>>")
			end
		imgui.EndChild()
		if imgui.CollapsingHeader(u8'Îïèñàíèå ñêðèïòà') then
			imgui.Text(u8'Àâòîð ñêðèïòà: Danil Korabelnikov (Danil_Conti)')
			imgui.Text(u8'Ññûëêà íà àâòîðà â BH -> ')
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(65/255, 105/255, 225/255, 1),u8'òûê')
			if imgui.IsItemClicked() then
				os.execute('start https://blast.hk/members/399616/')
			end
			imgui.Text(u8'')
			imgui.Text(u8'Åñëè õîòèòå óçíàòü êàêóþ òî èíôîðìàöèþ î ñêðèïòå èëè ÷òî òî ïðåäëîæèòü ïèøèòå àâòîðó â âê.')
			if imgui.Button(u8('Ñâÿçàòüñÿ ñ àâòîðîì')) then
				os.execute('start https://vk.com/i_ne_v_seti')
			end
		end
		if imgui.CollapsingHeader(u8'Îïèñàíèå êîìàíä/ñïèñîê êîìàíä') then
				imgui.Text(u8'Ââîäèòü êàê êîìàíäû.', 1)
				imgui.Text(u8"/spam - àêòèâèðîâàòü/äåàêòèâèðîâàòü ñïàì ")
				imgui.Text(u8'/fh - ñîêðàù¸ííàÿ êîìàíäà /findihouse [ID äîìà]')
				imgui.SameLine()
				imgui.TextQuestion(u8'Íàéòè äîì.')
				imgui.Text(u8'/fbz - ñîêðàù¸ííàÿ êîìàíäà /findibiz [ID áèçíåñà]')
				imgui.SameLine()
				imgui.TextQuestion(u8'Íàéòè áèçíåñ.')
				imgui.Text(u8'/mc [ID Èãðîêà] - ñîêðàù¸ííàÿ êîìàíäà /showmc [ID èãðîêà]')
				imgui.SameLine()
				imgui.TextQuestion(u8'Ïîêàçàòü ìåä-êàðòó èãðîêó.')
				imgui.Text(u8'/pass [ID Èãðîêà] - ñîêðàù¸ííàÿ êîìàíäà /showpass [ID èãðîêà]')
				imgui.SameLine()
				imgui.TextQuestion(u8'Ïîêàçàòü ïàñïîðò èãðîêó.')
				imgui.Text(u8'/lic [ID Èãðîêà] - ñîêðàù¸ííàÿ êîìàíäà /showlic [ID èãðîêà]')
				imgui.SameLine()
				imgui.TextQuestion(u8'Ïîêàçàòü ëèöåíçèè èãðîêó.')
				imgui.Text(u8'/fc - ñîêðàù¸ííàÿ êîìàíäà /fam [òåêñò]')
				imgui.SameLine()
				imgui.TextQuestion(u8'Íàïèñàòü â ÷àò ôàìû.')
				imgui.Text(u8'/fm - ñîêðàù¸ííàÿ êîìàíäà /fammenu')
				imgui.SameLine()
				imgui.TextQuestion(u8'Ìåíþ óïðàâëåíèå ñåìüåé.')
				imgui.Text(u8'/fi [ID Èãðîêà] - ñîêðàù¸ííàÿ êîìàíäà /faminvite [ID Èãðîêà]')
				imgui.SameLine()
				imgui.TextQuestion(u8'Ïðèãëàñèòü èãðîêà â ñåìüþ.')
				imgui.Text('')
				imgui.Text(u8'Ââîäèòü êàê ÷èò-êîä ëèáî ïðîñòî íàæàòü.', imgui.ImVec2(20,5))
				imgui.SameLine()
				imgui.TextWarrning(u8'Âñå íàïèñàíûå êíîïêè íèæå áûëè óêàçàíû íà àíãëèéñêîì.')
				imgui.Text(u8"ZZ êàê ÷èò êîä - àêòèâàöèÿ ìåíþ ")
				imgui.Text(u8'Íà êíîïêó <<P>> îòêðîåòñÿ òåëåôîí.')
				imgui.Text(u8'Íà êíîïêó <<L>> çàêðîåòñÿ òðàíñïîðò.')
				imgui.Text(u8'Íà êíîïêó <<K>> âûñóíåöà êëþ÷.')
			end
			if imgui.CollapsingHeader(u8'Òåðìèíû') then
				imgui.Text(u8'ÄÌ- Óáèéñòâî áåç ïðè÷èíû.')
				imgui.Text(u8'ÄÁ- Óáèéñòâî ñ ìàøèíû (ìàøèíîé).')
				imgui.Text(u8'ÑÊ- Ñïàâí êèëë, ò.å. óáèéñòâî ïðè ïîÿâëåíèè.')
				imgui.Text(u8'ÒÊ- "Team Kill" - Óáèéñòâî ñâîèõ.')
				imgui.Text(u8'ÐÏ- "Role Play"- Èãðà ïî ðîëÿì ãäå êàæäûé äîëæåí ñîáëþäàòü ñâîþ ðîëü.')
				imgui.Text(u8'ÌÃ- "Meta Gaming" - Èñïîëüçîâàíèå èíôîðìàöèè èç ðåàëüíîãî ìèðà â èãðîâîé ÷àò(ñîêðàùåííî: ÎÎÑ â èñ ).')
				imgui.Text(u8'ÃÌ- "God Mood" - Áîã ìîä - ò.å. ðåæèì áîãà.')
				imgui.Text(u8'ÏÃ- "Power Gaming" - Èçîáðàæåíèå èç ñåáÿ ãåðîÿ,íàïðèìåð êîãäà ó òåáÿ íåò îðóæèÿ è òû èäåøü íà ÷åëîâåêà ó ')
				imgui.Text(u8'êîòîðîãî îíî åñòü , èëè íàïðèìåð äðàêà 5 ïðîòèâ îäíîãî.')
				imgui.Text(u8'ÐÊ- Âîçâðàùåíèå íà ìåñòî ãäå òåáÿ óáèëè.')
				imgui.Text(u8'ÁÕ- "Áàíè Õîï"- íîíÐÏ áåã ñ ïðûæêàìè ( shift+space )')
				imgui.Text(u8'ÓÊ-"Óãîëîâíûé Êîäåêñ"')
				imgui.Text(u8'ÀÊ- "Àêàäåìè÷åñêèé Êîäåêñ"')
				imgui.Text(u8'ÇÇ- "Çåëåíàÿ Çîíà". Îáùåñòâåííûå ìåñòà-ïëîùàäü ó ìýðèè, âîêçàëû, áîëüíèöû è ò.ï. (Â ýòîé ')
				imgui.Text(u8'çîíå çàïðåùåíî ñòðåëÿòü)')
				imgui.Text(u8'')
				imgui.Text(u8'Åñëè âàñ ñïðàøèâàþò: "×òî òàêîå ÄÌ?" áåç (( )), òî âû îòâå÷àåòå òî, ÷òî ìîãóò ñîêðàùàòü ýòè áóêâû ò.å. : " Äÿäÿ ')
				imgui.Text(u8'Ìèøà; Äîì Ìåäâåäÿ" è ò.ä. , à åñëè âàñ ñïðàøèâàþò ñ ïðèñóòñòâèåì â ÷àòå ñêîáîê, ò.å. : (( ×òî òàêîå ÄÌ? )) , òî ')
				imgui.Text(u8'âû â îòâåò â ñêîáêàõ ïèøåòå (( ÄÌ- óáèéñòâî áåç ïðè÷èíû.)). ')
				imgui.Text(u8'')
				imgui.Text(u8'Çàïîìíèòå. Âñ¸ ÷òî ïèøåòñÿ â ñêîáêàõ " (( )) " - íîíÐÏ ÷àò, ò.å. â íåãî ãîâîðÿò âñ¸ òî, ÷òî îòíîñèòñÿ ê ðåàëüíîìó ')
				imgui.Text(u8'ìèðó, è ïî÷òè íå êàñàåòñÿ âèðòóàëüíîãî.')
			end
		if imgui.Button(u8'Ñîõðàíèòü', imgui.ImVec2(125,50)) then
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
		if imgui.Button(u8'Ïåðåçàãðóçèòü', imgui.ImVec2(125,50)) then
			mainIni.config.primer = ' '
			mainIni.config.tsp = ' '
			mainIni.config.ssp = '1200'
			thisScript():reload()
		end
		imgui.SameLine()
		if imgui.Button(u8'Ïðîâåðèòü îáíîâëåíèÿ##check_update', imgui.ImVec2(125,50)) then
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
								sampAddChatMessage(('[Helper]: {FFFFFF}Äîñòóïíî îáíîâëåíèå!'), 0xF1CB09)
							else
								update = false
								sampAddChatMessage(('[Helper]: {FFFFFF}Ó âàñ óñòàíîâëåíà ïîñëåäíèÿ âåðñèÿ!'), 0xF1CB09)
							end
						end
					end
				end
			end)
		end
		if new == 1 then
			imgui.SameLine()
			if imgui.Button(u8'Îáíîâèòü##update') then
				lua_thread.create(function()
					sampAddChatMessage(('[Helper]: Îáíîâëÿþñü...'), 0xF1CB09)
					wait(300)
					downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
						if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
							sampAddChatMessage(('[Helper]: Îáíîâëåíèå çàâåðøåíî!'), 0xF1CB09)
							thisScript():reload()
						end
					end)
				end)
			end
		end
		imgui.SameLine()
		imgui.TextWarrning(u8'Êíîïêà <<Ïðîâåðèòü îáíîâëåíèå>> â áåòà òåñòå, íå íàæèìàòü!!!')
		imgui.End()
	end
end

function main()
	while not isSampAvailable() do wait(0) end
		
	imgui.Process = false
		
	notf.addNotification("Ñêðèïò áûë óñïåøíî çàãðóæåí", 5, 1)
		
	sampAddChatMessage('{610BBE}[Helper] {FFFFFF}Ñêðèïò óñïåøíî çàãðóæåíàâòîð {E00B0B}Danil_Conti.')
	
	sampRegisterChatCommand('ca', calc)
		
	sampRegisterChatCommand('spam', function() 
	act = not act; sampAddChatMessage(act and '{01A0E9}Ñïàì âêëþ÷åí!' or '{01A0E9}Ñïàì âûêëþ÷åí!', -1)
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
				sampSendChat("/me âçãëÿíóë íà ÷àñû ìàðêè <<Rolex>> ñ ãðàâèðîâêîé <<Áàí íàõóé.>> ")
				sampSendChat("/time")
				wait(1200)
				sampSendChat ("/do Íà ÷àñàõ:  "..os.date('%H:%M:%S'))
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
		sampAddChatMessage('{610BBE}[Helper] {FFFFFF}Âûéäè èç êàçèíî, à òî âñå äåíüãè ïðîèãðàåøü!')
		return false
	end
	if command == '/YES' then
		sampAddChatMessage('{610BBE}[Helper] {FFFFFF}Âûéäè èç êàçèíî, à òî âñå äåíüãè ïðîèãðàåøü!')
		return false
	end
	if command == '/dice' then
		sampAddChatMessage('{610BBE}[Helper] {FFFFFF}Âûéäè èç êàçèíî, à òî âñå äåíüãè ïðîèãðàåøü!')
		return false
	end
	if command == '/DICE' then
		sampAddChatMessage('{610BBE}[Helper] {FFFFFF}Âûéäè èç êàçèíî, à òî âñå äåíüãè ïðîèãðàåøü!')
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
        sampAddChatMessage('Âû íå ââåëè ïðèìåð.')
    else
        local func = load('return ' .. mainIni.config.primer)
        if func == nil then
            sampAddChatMessage('Îøèáêà.', -1)
        else
            local bool, res = pcall(func)
            if bool == false or type(res) ~= 'number' then
                sampAddChatMessage('Îøèáêà.', -1)
            
            else
                sampAddChatMessage('Ðåçóëüòàò: ' .. res, -1)
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
    if text:find("Ïîçäðàâëÿåì! Òåïåðü ýòîò òðàíñïîðò ïðèíàäëåæèò âàì!") and not text:find('ãîâîðèò') and not text:find('- |') then
			sampSendChat('/lock')
	  end
  end
	if mbc.v then
		if text:find("Ïîçäðàâëÿåì! Òåïåðü ýòîò òðàíñïîðò ïðèíàäëåæèò âàì!") and not text:find('ãîâîðèò') and not text:find('- |') then
			lua_thread.create(function()
				wait(500)
				sampSendChat(u8:decode(smsbc.v))
			end)
		end
	end
	if at.v then
		if text:find("Ïîçäðàâëÿåì! Òåïåðü ýòîò òðàíñïîðò ïðèíàäëåæèò âàì!") or text:find("(.-)Ïîçäðàâëÿþ! Òåïåðü ýòîò äîì âàø!")  and not text:find('ãîâîðèò') and not text:find('- |') then
			lua_thread.create(function()
				sampSendChat("/me âçãëÿíóë íà ÷àñû ñ ãðàâèðîâêîé Ñëîâèë ñëîâèë")
				sampSendChat("/time")
				wait(1200)
				sampSendChat ("/do Íà ÷àñàõ  "..os.date('%H:%M:%S'))
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

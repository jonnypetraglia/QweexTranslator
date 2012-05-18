;http://www.gettyicons.com/free-icon/103/mimi-deep-colour-icon-set/free-save-icon-png/
CurrentFile = locale.ini

About_Name=Qweex Translator
About_Version=1.0
About_DateLaunch=2012
About_Date=
About_CompiledDate=05/18/2012

Window_W:=700
Button_W:=32
IconSize:=24
Margin_:=5


	ButtonLast_X:=Window_W-Button_W-5
	ButtonFirst_X:=Margin_*3
	BMargin_:=floor((Button_W-IconSize)/2)
		BMargin_=%BMargin_%,%BMargin_%,%BMargin_%,%BMargin_%
	DDL_Y:=Margin_+3
	DDL_X:=ButtonFirst_X + 2*Margin_ + Button_W
	Listview_Y:=Margin_*2 + Button_W

gui, margin, %Margin_%, %Margin_%, %Margin_%, %Margin_%
Gui, +resize +minsize

gui, add, button, vbOpen gOpenFile y%Margin_% w%Button_W% h%Button_W% x%ButtonFirst_X% hwndhBtn 0x8000, % A_IsCompiled ? "" : "Open"
	ILButton(hBtn, A_ScriptName . ":4", IconSize, IconSize, BMargin_)
	gui, font, s13
gui, add, dropdownlist, x%DDL_X% y%DDL_Y% w200 vLangList gChangeLang disabled, <------------------------------------------------------------||
	gui, font
ImageNames=Info,Add,Open
ButtonGlabels=ShowAbout,NewLanguage,OpenFile
StringSplit, ButtonGlabels, ButtonGlabels, `,
gui, add, button, vbNew gNewLanguage y%Margin_% w%Button_W% h%Button_W% xp+210 hwndhBtn 0x8000 disabled, % A_IsCompiled ? "" : "New" 
	ILButton(hBtn, A_ScriptName . ":3", IconSize, IconSize, BMargin_)
gui, add, button, vbAbout gShowAbout y%Margin_% w%Button_W% h%Button_W% x%ButtonLast_X% hwndhBtn 0x8000, % A_IsCompiled ? "" : "Info" 
	ILButton(hBtn, A_ScriptName . ":5", IconSize, IconSize, BMargin_)
	
gui, font, s13	
gui, add, Listview, x%Margin_% y%Listview_Y% w%Window_W% r20 grid -ReadOnly gMainListview vMainListView, Translation|Phrase
gui, show,,% About_Name
LV_ModifyCol(1,Window_W/2*.97)
LV_ModifyCol(2,Window_W/2*.97)
Swap(1,2,LV_getCount("Column"),1)
gui, +LastFound
WinID:=WinExist()
return


OpenFile:
	FileSelectFile, TempVar, 11, %A_ScriptDir%, Choose a file to open, *.ini
	if(!TempVar)
		return
	guicontrol, -disabled, LangList
	guicontrol, -disabled, bNew
	CurrentFile:=TempVar
	ini_Load(INI_VAR, CurrentFile)
	Languages := ini_GetSections(INI_VAR)
	StringReplace, Languages, Languages, `n, |, All
	Sort, Languages, UZ
	guicontrol,,LangList, % RegExReplace(Languages,"English\|", "English||","",1)

ChangeLang:
	guicontrolget, LANG,, LangList
	LV_Delete()
	Keys:=ini_GetKeys(INI_VAR, LANG)
	Loop, Parse, Keys, `n
		LV_Add("", ini_Read(INI_VAR, LANG, A_LoopField,""), A_LoopField)
return


NewLanguage:
	InputBox, NewLanguage,% About_Name, Enter the name of the language:
	if(!NewLanguage)
		return
	if(InStr(Languages, NewLanguage))
	{
		msgbox, That Language already exists!
		return
	}
	InputBox, NewAuthor,% About_Name, Enter your name (or whatever you want to be known as):
	if(!NewAuthor)
		return
	Languages.=NewLanguage . "|"
	Sort, Languages, U
	guicontrol,,LangList, % RegExReplace(Languages, NewLanguage . "\|", NewLanguage . "||","",1)
	
	Keys:=ini_GetKeys(INI_VAR, LANG)
	Loop, Parse, Keys, `n
	{
		if(!A_LoopField)
			continue
		ini_write(INI_VAR, NewLanguage, A_LoopField, "")
		iniwrite,% "",% CurrentFile,% NewLanguage,% A_LoopField
	}
	ini_write(INI_VAR, NewLanguage, "Translator", NewAuthor)
	iniwrite,% NewAuthor,% CurrentFile,% NewLanguage, Translator
	
	gosub ChangeLang
return


MainListview:
	if(A_GuiEvent="DoubleClick")
		ControlSend, SysListView321, {F2}, ahk_id %WinID%
	else if(A_GuiEvent="e")
	{
		guicontrolget, LANG,, LangList
		LV_GetText(Translation,A_EventInfo)
		LV_GetText(Original,A_EventInfo, 2)
		iniwrite,% Translation,% CurrentFile,% LANG, % Original
	}
return

Guisize:
	AdjustResize("MainListview","w h")
	AdjustResize("bAbout","x")
return

guiclose:
exitapp

#include AboutWindow.ahk
#include ini.ahk
#include Swap.ahk
#include ILButton.ahk
#include AdjustResize.ahk
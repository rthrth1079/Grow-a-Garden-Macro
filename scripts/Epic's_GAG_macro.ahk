﻿#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn VarUnset, Off
SetWorkingDir A_ScriptDir . "\.."
KeyDelay := 40

Setkeydelay KeyDelay

GetRobloxClientPos()
pToken := Gdip_Startup()
bitmaps := Map()
bitmaps.CaseSense := 0
currentWalk := {pid:"", name:""} ; stores "pid" (script process ID) and "name" (pattern/movement name)
CoordMode "Mouse", "Screen"
CoordMode "Pixel", "Screen"
SendMode "Event"

WKey:="sc011" ; w
AKey:="sc01e" ; a
SKey:="sc01f" ; s
Dkey:="sc020" ; d


RotLeft := "vkBC" ; ,
RotRight := "vkBE" ; .
RotUp := "sc149" ; PgUp
RotDown := "sc151" ; PgDn
ZoomIn := "sc017" ; i
ZoomOut := "sc018" ; o
Ekey := "sc012" ; e
Rkey := "sc013" ; r
Lkey := "sc026" ; l
EscKey := "sc001" ; Esc
EnterKey := "sc01c" ; Enter
SpaceKey := "sc039" ; Space
SlashKey := "vk6F" ; /
SC_LShift:="sc02a" ; LShift


#Include "%A_ScriptDir%"
#include ..\lib\

#Include FormData.ahk
#Include Gdip_All.ahk
#include Gdip_ImageSearch.ahk
#include json.ahk
#Include roblox.ahk
#Include ComVar.ahk
#Include Promise.ahk
#Include WebView2.ahk
#Include WebViewToo.ahk

#Include ..\images\
#include bitmaps.ahk
#include ..\scripts\

#Include gui.ahk
#Include webhook.ahk
#Include timers.ahk



HyperSleep(ms) {
    static freq := (DllCall("QueryPerformanceFrequency", "Int64*", &f := 0), f)
    DllCall("QueryPerformanceCounter", "Int64*", &begin := 0)
    current := 0, finish := begin + ms * freq / 1000
    while (current < finish) {
        if ((finish - current) > 30000) {
            DllCall("Winmm.dll\timeBeginPeriod", "UInt", 1)
            DllCall("Sleep", "UInt", 1)
            DllCall("Winmm.dll\timeEndPeriod", "UInt", 1)
        }
        DllCall("QueryPerformanceCounter", "Int64*", &current)
    }
}

Walk(studs, MoveKey1, MoveKey2:=0) {
	Send "{" MoveKey1  " down}" (MoveKey2 ? "{" MoveKey2  " down}" : "")
	Sleep studs
	Send "{" MoveKey1  " up}" (MoveKey2 ? "{" MoveKey2  " up}" : "")
}
; Walk(studs, MoveKey1, MoveKey2:=0) {
; 	speed := 0.022
; 	sleepTime := studs / speed
; 	Send "{" MoveKey1  " down}" (MoveKey2 ? "{" MoveKey2  " down}" : "")
; 	Sleep sleepTime
; 	Send "{" MoveKey1  " up}" (MoveKey2 ? "{" MoveKey2  " up}" : "")
; }


CheckDisconnnect(){
    static VipLink := IniRead(settingsFile, "Settings", "VipLink")
    hwnd := GetRobloxHWND()
    GetRobloxClientPos()
    pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY + 30 "|" windowWidth "|" windowHeight - 30)
    if (Gdip_ImageSearch(pBMScreen, bitmaps["disconnected"], , , , , , 2) = 1 || GetRobloxHWND() == 0)  {
        PlayerStatus("Starting Grow A Garden", "0x00a838", ,false, ,false)    
        Gdip_DisposeImage(pBMScreen)
        CloseRoblox()
        PlaceID := 126884695634066

        linkCode := ""
        shareCode := ""

        if RegExMatch(VipLink, "privateServerLinkCode=(\d+)", &match)
            linkCode := match[1]
        else if RegExMatch(VipLink, "code=([a-f0-9]+)&type=Server", &match)
            shareCode := match[1]
        
        if linkCode {
        DeepLink := "roblox://placeID=" PlaceID "&linkCode=" linkCode
        } else if shareCode {
            DeepLink := "https://www.roblox.com/share?code=" shareCode "&type=Server"
        } else {
            DeepLink := "roblox://placeID=" PlaceID
        }
        try Run DeepLink

        loop 60 {
            if GetRobloxHWND() {
                Sleep(500)
                for hwnd in WinGetList(,, "Program Manager")
                {
                    p := WinGetProcessName("ahk_id " hwnd)
                    if (InStr(p, "Roblox") || InStr(p, "AutoHotkey"))
                        continue ; skip roblox and AHK windows
                    title := WinGetTitle("ahk_id " hwnd)
                    if (title = "")
                        continue ; skip empty title windows
                    s := WinGetStyle("ahk_id " hwnd)
                    if ((s & 0x8000000) || !(s & 0x10000000))
                        continue ; skip NoActivate and invisible windows
                    s := WinGetExStyle("ahk_id " hwnd)
                    if ((s & 0x80) || (s & 0x40000) || (s & 0x8))
                        continue ; skip ToolWindow and AlwaysOnTop windows
                    try
                    {
                        WinActivate "ahk_id " hwnd
                        WinMaximize("ahk_id " hwnd)
                        Sleep 500
                        Send "^{w}"
                    }
                    break
                }
                Sleep(500)
                ActivateRoblox()
                Sleep(25000)
                ActivateRoblox()
                ResizeRoblox()
                GetRobloxClientPos(GetRobloxHWND())
                MouseMove windowX + windowWidth//2, windowY + windowHeight//2
                Sleep(500)
                Click
                Click
                PlayerStatus("Game Succesfully loaded", "0x00a838", ,false)
                Sleep(1000)
                Send("{Tab}")
                Send("1")
                Sleep(300)
                CloseChat()
                Sleep(1500)
                return 1
            }
            Sleep(1000)
        }
        if (A_Index == 60){
            Sleep(500)
            for hwnd in WinGetList(,, "Program Manager")
            {
                p := WinGetProcessName("ahk_id " hwnd)
                if (InStr(p, "Roblox") || InStr(p, "AutoHotkey"))
                    continue ; skip roblox and AHK windows
                title := WinGetTitle("ahk_id " hwnd)
                if (title = "")
                    continue ; skip empty title windows
                s := WinGetStyle("ahk_id " hwnd)
                if ((s & 0x8000000) || !(s & 0x10000000))
                    continue ; skip NoActivate and invisible windows
                s := WinGetExStyle("ahk_id " hwnd)
                if ((s & 0x80) || (s & 0x40000) || (s & 0x8))
                    continue ; skip ToolWindow and AlwaysOnTop windows
                try
                {
                    WinActivate "ahk_id " hwnd
                    WinMaximize("ahk_id " hwnd)
                    Sleep 500
                    Send "^{w}"
                }
                break
            }
            Sleep(500)
        }
        Gdip_DisposeImage(pBMScreen)
        return 0

    } else {
        Gdip_DisposeImage(pBMScreen)
        return 0
    }
}

CloseChat(){
    ActivateRoblox()
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY "|" windowWidth * 0.25 "|" windowHeight //8)
    if (Gdip_ImageSearch(pBMScreen, bitmaps["Chat"] , &OutputList, , , , , 25) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + windowX
        y := Cords[2] + windowY
        MouseMove(x, y)
        Sleep(300)
        Click
    }
    Gdip_DisposeImage(pBMScreen)
}



openBag(){  
    ActivateRoblox()
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY "|" windowWidth * 0.5 "|" windowHeight //8)
    if (Gdip_ImageSearch(pBMScreen, bitmaps["Openbag"] , &OutputList, , , , , 100,,8) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + windowX + 2
        y := Cords[2] + windowY + 2
        MouseMove(x, y)
        Sleep(300)
        Click
        Sleep(500)
    }
    Gdip_DisposeImage(pBMScreen)
}

closeBag(){
    relativeMouseMove(0.95, 0.5)
    Click
    Sleep(500)
}

clearSearch(){
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    pBMScreen := Gdip_BitmapFromScreen(windowX + windowWidth // 2 "|" windowY + 30 "|" windowWidth // 2 "|" windowHeight - 30)
    if (Gdip_ImageSearch(pBMScreen, bitmaps["x"] , &OutputList, , , , , 25,,3) = 1 || Gdip_ImageSearch(pBMScreen, bitmaps["x2"] , &OutputList, , , , , 25,,3) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + windowX + windowWidth // 2 
        y := Cords[2] + windowY + 31
        MouseMove(x, y)
        Sleep(750)
        Click
        Click
        Sleep(250)
        Send("{Backspace}")
        Sleep(500)
    }
    if (Gdip_ImageSearch(pBMScreen, bitmaps["Favorite"] , &OutputList, , , , , 20,,6) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + windowX + windowWidth // 2 
        y := Cords[2] + windowY + 30
        MouseMove(x, y)
        Sleep(750)
        Click
        Sleep(500)
    }
    Gdip_DisposeImage(pBMScreen)
}


searchItem(keyword){
    keyword := StrReplace(keyword, " ", "%S+")
    ActivateRoblox()
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    openBag()
    Sleep(1000)
    clearSearch()
    Sleep(1000)
    cordx := 0
    cordy := 0
    pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY "|" windowWidth "|" windowHeight )
    if (Gdip_ImageSearch(pBMScreen, bitmaps["Search"] , &OutputList, , , , , 50) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + windowX
        y := Cords[2] + windowY
        cordx := x
        cordy := y
        MouseMove(x, y)
        Sleep(300)
        Click
        Sleep(500)
        Send(keyword)
        Sleep(500)
        Gdip_DisposeImage(pBMScreen)
    } else {
        PlayerStatus("Could not detect Search in inventory", "0xFF0000")
        Gdip_DisposeImage(pBMScreen)
    }
}

clickItem(keyword, searchbitmap){
    ActivateRoblox()
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    Sleep(500)
    capX := windowX
    capY := windowY + 200 + windowHeight - 600
    capW := windowWidth
    capH := windowHeight - (200 + windowHeight - 600)
    pBMScreen := Gdip_BitmapFromScreen(capX "|" capY "|" capW "|" capH)
    if (searchbitmap == "Bracket"){
        if (Gdip_ImageSearch(pBMScreen, bitmaps["Bracket2"], &OutputList, , , , , 20) = 1) {
            Cords := StrSplit(OutputList, ",")
            x := Cords[1] + capX + 4
            y := Cords[2] + capY + 4
            MouseMove(x, y)
            Sleep(250)
            Click
            Sleep(250)
            Gdip_DisposeImage(pBMScreen)
            closeBag()
            return true
        }
    }

    if (Gdip_ImageSearch(pBMScreen, bitmaps[searchbitmap], &OutputList, , , , , 20) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + capX + 4
        y := Cords[2] + capY + 4
        MouseMove(x, y)
        Sleep(250)
        Click
        Sleep(250)
        Gdip_DisposeImage(pBMScreen)
        closeBag()
        return true
    } else {
        PlayerStatus("Missing " keyword " in inventory!", "0xff0000")
        Gdip_DisposeImage(pBMScreen)
        closeBag()
        return false
    }
}


clickCategory(category){
    ActivateRoblox()
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    capX := windowX
    capY := windowY + 200 + windowHeight - 600
    capW := windowWidth
    capH := windowHeight - (200 + windowHeight - 600)
    pBMScreen := Gdip_BitmapFromScreen(capX "|" capY "|" capW "|" capH)
    if (Gdip_ImageSearch(pBMScreen, bitmaps[category] , &OutputList, , , , , 100) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + capX
        y := Cords[2] + capY
        MouseMove(x, y)
        Sleep(300)
        Click
    }
    Gdip_DisposeImage(pBMScreen)
}


equipRecall(){
    searchItem("recall")

    pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY "|" windowWidth "|" windowHeight )
    if (Gdip_ImageSearch(pBMScreen, bitmaps["Recall"] , &OutputList, , , , , 25) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + windowX
        y := Cords[2] + windowY
        MouseMove(x, y)
        Sleep(300)
        Send("{Click down}")
        Sleep(300)
    }
    Gdip_DisposeImage(pBMScreen)

    pBMScreen := Gdip_BitmapFromScreen(
        windowX "|" 
        windowY + windowHeight - (windowHeight // 8) - 35 "|" 
        windowWidth * 0.4 "|" 
        windowHeight // 8
    )
    if (Gdip_ImageSearch(pBMScreen, bitmaps["recall slot"] , &OutputList, , , , , 30,,6) = 1 || Gdip_ImageSearch(pBMScreen, bitmaps["recall slot2"] , &OutputList, , , , , 30,,6) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + windowX
        y := Cords[2] + windowY + windowHeight - (windowHeight // 8) 
        MouseMove(x, y)
        Sleep(300)
        Send("{Click up}")
        Sleep(300)
    }
    Send("{Click up}")
    Sleep(500)
    clearSearch()
    closeBag()
    Gdip_DisposeImage(pBMScreen)

}



CheckSetting(item,value){
    if (IniRead(settingsFile, item, value) == 1){
        return true
    }
    return false
}


relativeMouseMove(relx, rely) {
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    moveX := windowX + Round(relx * windowWidth)
    moveY := windowY + Round(rely * windowHeight)
    MouseMove(moveX,moveY)
}


Clickbutton(button, clickit := 1){
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)    
    
    if (button == "Garden" || button == "Sell" || button == "Seeds"){
        capX := windowX + (windowWidth // 4)
        capY := windowY + 30
        capW := windowWidth // 2
        capH := 100
        varation := 10
    } else if (button == "Xbutton") {
        capX := windowX + windowWidth * 0.60
        capY := windowY + windowHeight * 0.15
        capW := windowWidth * 0.38
        capH := windowHeight * 0.25
        varation := 50
    } else if (button == "Robux"){
        capX := windowX windowWidth // 4
        capY := windowY 
        capW := windowWidth //2
        capH := windowHeight
        varation := 10
    }

    pBMScreen := Gdip_BitmapFromScreen(capX "|" capY "|" capW "|" capH)
    if (Gdip_ImageSearch(pBMScreen, bitmaps[button], &OutputList, , , , , varation,,7) = 1) {
        if (clickit == 1){
            Cords := StrSplit(OutputList, ",")
            x := Cords[1] + capX - 2
            y := Cords[2] + capY 
            MouseMove(x, y)
            Sleep(10)
            Click
        }
        Gdip_DisposeImage(pBMScreen)
        return 1
    }
    if (button == "Seeds" || button == "Sell") {    
        if (Gdip_ImageSearch(pBMScreen, bitmaps[button], &OutputList, , , , , 100,,7) = 1) {
            if (clickit == 1){
                Cords := StrSplit(OutputList, ",")
                x := Cords[1] + capX - 2
                y := Cords[2] + capY 
                MouseMove(x, y)
                Sleep(10)
                Click
            }
            Gdip_DisposeImage(pBMScreen)
            return 1
        }
    } else if (button == "Robux"){
        if (Gdip_ImageSearch(pBMScreen, bitmaps["RobuxOld"], &OutputList, , , , , 10,,7) = 1) {
            if (clickit == 1){
                Cords := StrSplit(OutputList, ",")
                x := Cords[1] + capX - 2
                y := Cords[2] + capY 
                MouseMove(x, y)
                Sleep(10)
                Click
            }
            Gdip_DisposeImage(pBMScreen)
            return 1
        }
    } else if (button == "Xbutton"){
        if (Gdip_ImageSearch(pBMScreen, bitmaps["Xbutton2"], &OutputList, , , , , varation,,7) = 1) {
            if (clickit == 1){
                Cords := StrSplit(OutputList, ",")
                x := Cords[1] + capX - 2
                y := Cords[2] + capY 
                MouseMove(x, y)
                Sleep(10)
                Click
            }
            Gdip_DisposeImage(pBMScreen)
            return 1
        }
    }
    Gdip_DisposeImage(pBMScreen)
    return 0
}

ChangeCamera(type){
    Send("{" EscKey "}")
    HyperSleep(750)
    Send("{Tab}")
    HyperSleep(333)
    Send("{Down}")
    HyperSleep(333)
    Send("{Right}")
    HyperSleep(333)
    Send("{Right}")
    HyperSleep(333)
    checkCamera(type)
    Send("{" EscKey "}")
    HyperSleep(1000)
}


checkCamera(type){  
    ActivateRoblox()
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    loop 8 {
        pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY "|" windowWidth "|" windowHeight)
        if (Gdip_ImageSearch(pBMScreen, bitmaps[type] , , , , , , 25) = 1) {
            Gdip_DisposeImage(pBMScreen)
            return 1
        } else {
            Send("{Right}")
            Sleep(1000)
            Gdip_DisposeImage(pBMScreen)
        }
    }

}




ZoomAlign(){
    relativeMouseMove(0.5,0.5)
    Click
    Loop 40 {
        Send("{WheelUp}")
        Sleep 20
    }

    Sleep(500)
    Loop 6 {
        Send("{WheelDown}")
        Sleep 50
    }
    Sleep(100)
    Click
    Sleep(250)
}


CameraCorrection(){
    if (Disconnect()){
        Sleep(1500)
        equipRecall()
        Sleep(500)
    }
    Send("{o down}")
    Sleep 250
    Send("{o up}")
    Clickbutton("Garden")
    CloseClutter()
    Sleep(300)
    ChangeCamera("Follow")

    ZoomAlign()

    Click("Right", "Down")
    Sleep(200)
    relativeMouseMove(0.5, 0.5)
    Sleep(200)
    MouseMove(0, 800, 10, "R")
    Sleep(200)
    Click("Right", "Up")
    Sleep(250)

    loop 10 {
        Clickbutton("Sell") 
        Clickbutton("Seeds") 
    }
    Sleep(500)
    Clickbutton("Seeds")
    Sleep(250)

    ChangeCamera("Classic")
    Sleep(1000)
    relativeMouseMove(0.5,0.5)
    Sleep(500)
    PlayerStatus("Finished Aligning!","0x2260e6",,false,,false)
}

SpamClick(amount){
    loop amount {
        Click
        Sleep 20
    }
}






Crafting(Recipeitems, settingName, Names){
    ActivateRoblox()
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    
    for item in Recipeitems {
        if (IniRead(settingsFile, settingName, StrReplace(item.name, " ", "")) + 0 == 1){
            ; Claim Crafting item
            Send("{c}")
            Sleep(300)
            Send("{" Ekey "}")
            Sleep(2500)
            if (Clickbutton("Robux") == 1){
                PlayerStatus("Crafting not finished. Closing Robux prompt.","0xe67e22",,false)
                return Integer(item.CraftTime * 0.3)
            }
            CloseClutter()
            PlayerStatus("Claimed " item.Name "!", "0x22e6a8",,false)
            Send("{" Ekey "}")
            if !DetectShop("crafting"){
                return Integer(item.CraftTime * 1.1)
            }
            ; Choose to craft item
            buyShop(Names, settingName, true)

            for Material in item.Materials {
                searchTerm := StrReplace(Material, " kg", "")
                searchTerm := StrReplace(Material, " fd", "")
                searchItem(searchTerm)
                searchBitmap := searchTerm
                if RegExMatch(Material, " kg") {
                    searchBitmap := "Bracket"
                    clickCategory("Fruit")
                } else if RegExMatch(Material, "Seed") {
                    searchBitmap := "Seed"

                } else if RegExMatch(Material, " fd") {
                    clickCategory("Food")
                }
                clickItem(searchTerm, searchBitmap)
                Sleep(500)
                Send("{" Ekey "}")
                Send("{" Ekey "}")
                Sleep(500)
            }
            Send("{" Ekey "}")
            Send("{" Ekey "}")
            Sleep(1000)
            Send("1")
            Sleep(250)
            Send("1")
            PlayerStatus("Crafting " item.Name "!", "0x22e6a8",,false)
            return Integer(item.CraftTime * 1.1)
        }
    }
    return 99999999
}


CheckStock(index, list, crafting := false){
    ActivateRoblox()
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    captureWidth := 150
    captureHeight := windowHeight // 2 + 100

    captureX := windowX + (windowWidth // 2) - (captureWidth // 2) - 150
    captureY := windowY + (windowHeight // 2) - (captureHeight // 2) + 20

    pBMScreen := Gdip_BitmapFromScreen(captureX "|" captureY "|" captureWidth "|" captureHeight)
    If (Gdip_ImageSearch(pBMScreen, bitmaps["GreenStock"], &OutputList, , , , , 3,,3) = 1 || Gdip_ImageSearch(pBMScreen, bitmaps["GreenStock2"], &OutputList , , , , , 3,,3) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + captureX 
        y := Cords[2] + captureY 
        MouseMove(x, y)
        Sleep(100)
        Click
        Gdip_DisposeImage(pBMScreen)
    } else {
        Gdip_DisposeImage(pBMScreen)
        return 0
    }

    loop {
        pBMScreen := Gdip_BitmapFromScreen(captureX "|" captureY "|" captureWidth "|" captureHeight)
        If (Gdip_ImageSearch(pBMScreen, bitmaps["GreenStock"], &OutputList, , , , , 3,,3) = 1 || Gdip_ImageSearch(pBMScreen, bitmaps["GreenStock2"], &OutputList , , , , , 3,,3) = 1) {
            Cords := StrSplit(OutputList, ",")
            x := Cords[1] + captureX 
            y := Cords[2] + captureY 
            MouseMove(x, y)
            Click
            Gdip_DisposeImage(pBMScreen)
            Sleep(25)
        } else {
            Gdip_DisposeImage(pBMScreen)
            PlayerStatus("Bought " list[index] "s!", "0x22e6a8",,false)
            return 1
        }
        
        if (A_index == 50) {
            Gdip_DisposeImage(pBMScreen)
            return 0
        }
    }

}

buyShop(itemList, itemType, crafting := false){
    if (itemType == "Event" || itemType == "Eggs"){
        pos := 0.8
    } else {
        pos := 0.845
    }

    for (item in itemlist){
        if (A_index == 1){
            relativeMouseMove(0.4,pos)
            Click
            Sleep(300)
            relativeMouseMove(0.5,0.4)
            Sleep(100)
            Loop 55 {
                Send("{WheelUp}")
                Sleep 20
            }
            Sleep(500)
        } else {
            relativeMouseMove(0.4,pos)
        }
        if (A_index >= 19){
            if ((A_Index - 19) / 8 == 0.5){
                ScrollDown(0.75)
                Sleep(500)
            } else {
                ScrollDown(0.25  + (A_Index - 19) / 8)
                Sleep(500)
            }
        }
        Click
        Sleep(350)
        if (CheckSetting(itemType, StrReplace(item, " ", ""))){
            CheckStock(A_Index, itemlist, crafting)
        } else {
            Sleep(200)
        }
    }
    CloseShop(crafting)
}


ScrollDown(amount := 1) {
    DllCall("user32.dll\mouse_event", "UInt", 0x0800, "UInt", 0, "UInt", 0, "UInt", -amount * 120, "UPtr", 0)
}

; 1 = 1st option, 2 = 2nd option, etc for example the gear shop to open the shop
clickOption(option, optionamount){
    Sleep(500)
    ZoomAlign()
    Sleep(2000)
    Loop 4 {
        Send("{WheelUp}")
        Sleep 50
    }
    Sleep(500)

    switch optionamount {
        case 2:
            if (option == 1){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (540  / 1080)
            } else if (option == 2){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (750  / 1080)
            }
        case 3: 
            if (option == 1){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (390 / 1080)
            } else if (option == 2){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (570 / 1080)
            } else if (option == 3){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (770 / 1080)
            }      
        case 4:
            if (option == 1){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (390 / 1080)
            } else if (option == 2){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (550 / 1080)
            } else if (option == 3){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (750 / 1080)
            } else if (option == 4){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (874 / 1080)
            }

        case 5:
            if (option == 1){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (300 / 1080)
            } else if (option == 2){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (450 / 1080)
            } else if (option == 3){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (580 / 1080)
            } else if (option == 4){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (770 / 1080)
            } else if (option == 5){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (990 / 1080)
            }  

        case 6:
            if (option == 1){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (200 / 1080)
            } else if (option == 2){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (340 / 1080)
            } else if (option == 3){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (490 / 1080)
            } else if (option == 4){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (670 / 1080)
            } else if (option == 5){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (850 / 1080)
            } else if (option == 6){
                MouseMove windowWidth * (1500 / 1920), windowHeight * (1030 / 1080)

            }  
    }
    Sleep(500)
    Click
    Loop 4 {
        Send("{WheelDown}")
        Sleep 50
    }
    Sleep(2500)
}


DetectShop(shop){
    loop 15 {
        Sleep(500)
        if (Clickbutton("Xbutton",0) == 1){
            Sleep(2500)
            PlayerStatus("Detected " shop " shop opened", "0x22e6a8",,false,,false)
            return 1
        }
    }
    PlayerStatus("Failed to open " shop " shop", "0x22e6a8",,false,,true)
    return 0
}


CloseShop(crafting := false){
    if (crafting == True){
        return 1
    }
    loop 15 {
        Sleep(500)
        if (Clickbutton("Xbutton") == 1){
            Sleep(1000)
            PlayerStatus("Closed shop!", "0x22e6a8",,false,,false)
            return 1
        }
    }
    PlayerStatus("Failed to close shop.", "0xFF0000",,false,,true)
    return 0

}


CloseClutter(){
    Clickbutton("Xbutton")
    Sleep(100)
    Clickbutton("Robux")
    Sleep(300)
}

getItems(item){
    static fileContent := ""

    if !fileContent {
        try {
            request := ComObject("WinHttp.WinHttpRequest.5.1")
            request.Open("GET", "https://raw.githubusercontent.com/epicisgood/GAG-Updater/refs/heads/main/items.json", true)
            request.Send()
            request.WaitForResponse()
            fileContent := JSON.parse(request.ResponseText)
            global MyWindow
            MyWindow.ExecuteScriptAsync("document.querySelector('#random-message').textContent = '" fileContent["message"] "'")
            
        } catch as e {
            MsgBox "Request failed " e.Message
        }
    }
    names := []
    for itemObj in fileContent[item] {
        names.Push(itemObj["name"])
    }
    return names
    ; jsonData := fileContent
    ; return jsonData[item]
}

BuySeeds(){
    seedItems := getItems("Seeds")
    if !(CheckSetting("Seeds", "Seeds")){
        return
    }
    loop 3 {
        PlayerStatus("Going to buy Seeds!", "0x22e6a8",,false,,false)
        relativeMouseMove(0.5, 0.5)
        Sleep(500)
        Clickbutton("Seeds")
        Sleep(1000)
        Send("{" Ekey "}")
        if !DetectShop("Seeds"){
            CameraCorrection()
            continue
        }
        buyShop(seedItems, "Seeds")
        CloseClutter()
        return 1
    }
    PlayerStatus("Failed to buy seeds 3 times, CLOSING ROBLOX!", "0x001a12")
    CloseRoblox()
}






BuyGears(){
    gearItems := getItems("Gears")
    if !(CheckSetting("Gears", "Gears")){
        return
    }
    loop 3 {
        PlayerStatus("Going to buy Gears!", "0x22e6a8",,false,,false)
        ActivateRoblox()
        Clickbutton("Garden")
        Sleep(500)
        Send("1")
        Sleep(300)
        relativeMouseMove(0.5, 0.5)
        Click
        Sleep(1500)
        Send("{" Ekey "}")
        clickOption(1,2)
        if !DetectShop("gear"){
            CameraCorrection()
            continue
        }
        buyShop(gearItems, "Gears")
        CloseClutter()
        return 1
    }
    
    CloseClutter()
    Sleep(1500)
    equipRecall()
    PlayerStatus("Equiped recall wrench, failed to open gear shop 3 times.", "0x001a12")
}


BuyEggs(){
    if !(CheckSetting("Eggs", "Eggs")){
        return
    }
    eggitems := getItems("Eggs")
    loop 3 {
        PlayerStatus("Going to buy Eggs!", "0x22e6a8",,false,,false)
        ActivateRoblox()
        Clickbutton("Garden")
        Sleep(500)
        Send("1")
        MouseMove windowX + windowWidth//2, windowY + windowHeight//2
        Click
        Sleep(2000)
        Send("{s Down}")
        HyperSleep(600)
        Send("{s Up}")
        Sleep(1500)
        Send("{" Ekey "}")
        clickOption(1,6)
        if !DetectShop("egg"){
            CameraCorrection()
            continue
        }
        buyShop(eggitems, "Eggs")
        CloseClutter()
        return 1
    }
}

BuyCosmetics(){
    if !(CheckSetting("Settings", "Cosmetics")){
        return 0 
    }

    PlayerStatus("Going to buy Cosmetics!", "0x22e6a8",,false,,false)
    ActivateRoblox()
    Clickbutton("Garden")
    Sleep(500)
    Send("1")
    MouseMove windowX + windowWidth//2, windowY + windowHeight//2
    Click
    Sleep(2000)
    Send("{w Down}")
    HyperSleep(500)
    Send("{w Up}")
    Sleep(1500)
    Send("{" Ekey "}")
    if !DetectShop("Cosmetic"){
        return 0
    }
    ActivateRoblox()
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    capX := windowX + windowWidth * 0.15
    capY := windowY + windowHeight * 0.3
    capW := windowWidth * 0.65
    capH := windowHeight * 0.5
    loop {
        pBMScreen := Gdip_BitmapFromScreen(capX "|" capY "|" capW "|" capH)
        if (Gdip_ImageSearch(pBMScreen, bitmaps["Cosmetics"] , &OutputList, , , , , 25) = 1) {
            Cords := StrSplit(OutputList, ",")
            x := Cords[1] + capX
            y := Cords[2] + capY
            MouseMove(x, y)
            Sleep(200)
            Click
        } else {
            Gdip_DisposeImage(pBMScreen)
            break
        }
        if (A_Index == 50) {
            Gdip_DisposeImage(pBMScreen)
            break
        }
        Gdip_DisposeImage(pBMScreen)
    }
    PlayerStatus("Finished buying Cosmetics!", "0x22e6a8",,false)
    CloseShop()
    return 1
}


GearCraft(){
    if !(CheckSetting("GearCrafting", "GearCrafting")){
        return
    }
    PlayerStatus("Going to craft Gears!", "0x22e6a8",,false,,false)
    ActivateRoblox()
    Clickbutton("Garden")
    Sleep(500)
    Send("1")
    Sleep(300)
    relativeMouseMove(0.5, 0.5)
    Click
    Sleep(2000)
    Send("{" WKey " down}")
    HyperSleep(1200)
    Send("{" WKey " up}")
    Sleep(1000)
    GearRecipe := [
        { Name: "Lightning Rod", Materials: ["Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler"], CraftTime: 2700 },
        { Name: "Tanning Mirror", Materials: ["Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler"], CraftTime: 2700 },
        { Name: "Reclaimer", Materials: ["Common Egg", "Harvest Tool"], CraftTime: 1500 },
        { Name: "Tropical Mist Sprinkler", Materials: ["Coconut kg", "Dragon Fruit kg", "Mango kg", "Godly Sprinkler"], CraftTime: 3600 },
        { Name: "Berry Blusher Sprinkler", Materials: ["Grape kg", "Blueberry kg", "Strawberry kg", "Godly Sprinkler"], CraftTime: 3600 },
        { Name: "Spice Spirtzer Sprinkler", Materials: ["Pepper kg", "Ember Lily kg", "Cacao kg", "Master Sprinkler"], CraftTime: 3600 },
        { Name: "Sweet Soaker Sprinkler", Materials: ["Watermelon kg", "Watermelon kg", "Watermelon kg", "Master Sprinkler"], CraftTime: 3600 },
        { Name: "Flower Froster Sprinkler", Materials: ["Orange Tulip kg", "Daffodil kg", "Advanced Sprinkler", "Basic Sprinkler"], CraftTime: 3600 },
        { Name: "Stalk Sprout Sprinkler", Materials: ["Bamboo kg", "Beanstalk kg", "Mushroom kg", "Advanced Sprinkler"], CraftTime: 3600 },
        { Name: "Mutation Spray Choc", Materials: ["Cleaning Spray", "Cacao kg"], CraftTime: 720 },
        { Name: "Mutation Spray Chilled", Materials: ["Cleaning Spray", "Godly Sprinkler"], CraftTime: 300 },
        { Name: "Mutation Spray Shocked", Materials: ["Cleaning Spray", "Lightning Rod"], CraftTime: 1800 },
        { Name: "Anti Bee Egg", Materials: ["Bee Egg"], CraftTime: 7200 },
        { Name: "Small Toy", Materials: ["Common Egg", "Coconut Seed", "Coconut kg"], CraftTime: 600 },
        { Name: "Small Treat", Materials: ["Common Egg", "Dragon Fruit Seed", "Blueberry kg"], CraftTime: 600 },
        { Name: "Pet Pouch", Materials: ["Common Egg", "Corndog fd", "Small Pet Treat", "Small Pet Toy"], CraftTime: 1800 },
        { Name: "Pack Bee", Materials: ["Anti Bee Egg", "Sunflower kg", "Purple Dahila kg"], CraftTime: 14400 },
        
        
    ]
    GearNames := getItems("GearCrafting")

    global GearCraftingTime
    GearCraftingTime := Crafting(GearRecipe, "GearCrafting", GearNames)
    Sleep(1000)

}


SeedCraft(){
    if !(CheckSetting("SeedCrafting", "SeedCrafting")){
        return
    }
    PlayerStatus("Going to craft Seeds!", "0x22e6a8",,false,,false)
    ActivateRoblox()
    Clickbutton("Garden")
    Sleep(500)
    Send("1")
    Sleep(300)
    relativeMouseMove(0.5, 0.5)
    Click
    Sleep(2000)
    Send("{" WKey " down}")
    HyperSleep(800)
    Send("{" WKey " up}")
    Sleep(1000)
    SeedRecipe := [
        { Name: "Twisted Tangle", Materials: ["Cactus Seed", "Bamboo Seed", "Cactus kg", "Mango kg"], CraftTime: 900 },
        { Name: "Veinpetal", Materials: ["Orange Tulip Seed", "Daffodil Seed", "Beanstalk kg", "Burning bud kg"], CraftTime: 1200 },
        { Name: "Horsetail", Materials: ["Daffodil Seed", "Bamboo kg", "Corn kg"], CraftTime: 900 },
        { Name: "Lingonberry", Materials: ["Blueberry Seed", "Blueberry Seed", "Blueberry Seed", "Horsetail kg"], CraftTime: 900 },
        { Name: "Amber Spine", Materials: ["Cactus Seed", "Pumpkin kg", "Horsetail kg"], CraftTime: 1800 },        
        
    ]
    SeedNames := getItems("SeedCrafting")


    global SeedCraftingtime
    SeedCraftingTime := Crafting(SeedRecipe, "SeedCrafting", SeedNames) 
    Sleep(1000)

}



BuyMerchant(){
    if !(CheckSetting("Settings", "TravelingMerchant")){
        return
    }

    PlayerStatus("Going to buy Traveling Merchant!", "0x22e6a8",,false,,false)
    Clickbutton("Seeds")
    Sleep(1500)
    Send("{" Akey " down}")
    HyperSleep(250)
    Send("{" Akey " up}")
    
    Send("{" Wkey " down}")
    HyperSleep(1200)
    Send("{" Wkey " up}")
    
    Send("{" Dkey " down}")
    HyperSleep(250)
    Send("{" Dkey " up}")
    Sleep(1000)

    Send("{" Ekey "}")
    merchantItems := [
        "TravelingMerchant", "TravelingMerchant", "TravelingMerchant", "TravelingMerchant", "TravelingMerchant", "TravelingMerchant",
        "TravelingMerchant", "TravelingMerchant", "TravelingMerchant", "TravelingMerchant", "TravelingMerchant", "TravelingMerchant",
        "TravelingMerchant", "TravelingMerchant"
    ]
    DetectOnett()
    if DetectShop("traveling merchant"){
        buyShop(merchantItems, "Settings")
        CloseClutter()
        return 1
    }
    return 0
}

DetectOnett(){
    ActivateRoblox()
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    capX := windowX + windowWidth * 0.6411
    capY := windowY + windowHeight * 0.2065
    capW := windowWidth * 0.1
    capH := windowHeight * 0.1667
    
    pBMScreen := Gdip_BitmapFromScreen(capX "|" capY "|" capW "|" capH)
    if (Gdip_ImageSearch(pBMScreen, bitmaps["HoneyMerchant"], , , , , , 50) = 1) {
        PlayerStatus("My goat Onett has arrived!!","0xe1ff00",,false)
        Send("{" Ekey "}")
        clickOption(2,5)
        Gdip_DisposeImage(pBMScreen)
        return true
    }
    Gdip_DisposeImage(pBMScreen)
    return false

}





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main Macro Functions.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Disconnect(){
    loop 3 {
        if (CheckDisconnnect()){
            return 1
        }
    }
}
GearCraftingTime := 10000000000
SeedCraftingTime := 10000000000
EventCraftingTime := 10000000000

MainLoop() {

    if (GetRobloxHWND()){
        ResizeRoblox()
    }
    
    if (Disconnect()){
        Sleep(1500)
        return
    }

    MyWindow.Destroy()
    CloseChat() 
    equipRecall()
    CameraCorrection()
    BuySeeds()
    BuyGears()
    BuyEggs()
    BuyCosmetics()
    BuyBeanstalkEvent()
    global LastBeanstalkTime := nowUnix()
    ; CookingEvent()
    global LastCookingTime := nowUnix()


    GearCraft()
    global LastGearCraftingTime := nowUnix()
    SeedCraft()
    global LastSeedCraftingTime := nowUnix()
    BuyMerchant()
    global LastEventCraftingtime := nowUnix()
    loop {
        RewardInterupt()
        if (Disconnect()){
            Sleep(1500)
            equipRecall()
            Sleep(500)
            CameraCorrection()
        }
        ShowToolTip()
        Sleep(1000)
    }
    
    
    
}

ShowToolTip(){
    global GearCraftingTime
    global LastGearCraftingTime
    global LastSeedCraftingTime
    global SeedCraftingTime
    global LastCookingTime
    global LastBeanstalkTime

    static SeedsEnabled := IniRead(settingsFile, "Seeds", "Seeds") + 0
    static GearsEnabled := IniRead(settingsFile, "Gears", "Gears") + 0
    static EggsEnabled := IniRead(settingsFile, "Eggs", "Eggs") + 0
    static gearCraftingEnabled := IniRead(settingsFile, "GearCrafting", "GearCrafting") + 0
    static seedCraftingEnabled := IniRead(settingsFile, "SeedCrafting", "SeedCrafting") + 0
    static cosmeticEnabled := IniRead(settingsFile, "Settings", "Cosmetics") + 0
    static merchantEnabled := IniRead(settingsFile, "Settings", "TravelingMerchant") + 0
    static beanstalkEventEnabled := IniRead(settingsFile, "Events", "Events") + 0
    static CookingEnabled := IniRead(settingsFile, "Settings", "CookingEvent") + 0


    currentTime := nowUnix()
    shopR := Mod(300 - Mod(A_Min*60 + A_Sec, 300), 300)
    eggR := Mod(1800 - Mod(A_Min*60 + A_Sec, 1800), 1800)

    tooltipText := ""
    if (SeedsEnabled) {
        tooltipText .= "Seeds: " shopR//60 ":" Format("{:02}", Mod(shopR, 60)) "`n"
    }
    if (GearsEnabled) {
        tooltipText .= "Gears: " shopR//60 ":" Format("{:02}", Mod(shopR, 60)) "`n"
    }
    if (EggsEnabled) {
        tooltipText .= "Eggs: " eggR//60 ":" Format("{:02}", Mod(eggR, 60)) "`n"
    }
    
    if (beanstalkEventEnabled) {
        static beanstalkTime := 600
        beanstalkRemaining := Max(0, beanstalkTime - (currentTime - LastBeanstalkTime))
        beanstalkM := beanstalkRemaining // 60
        beanstalkS := Mod(beanstalkRemaining, 60)
        tooltipText .= "Beanstalk: " beanstalkM ":" Format("{:02}", beanstalkS) "`n"
    }

    if (false) {
    ; if (CookingEnabled) {
        static CookingTime := Integer(IniRead(settingsFile, "Settings", "CookingTime") * 1.1)
        CookingRemaining := Max(0, CookingTime - (currentTime - LastCookingTime))
        eventM := CookingRemaining // 60
        eventS := Mod(CookingRemaining, 60)
        tooltipText .= "Cooking for: " eventM ":" Format("{:02}", eventS) "`n"
    }

    if (cosmeticEnabled) {
        utcNow := A_NowUTC
        utcHour := FormatTime(utcNow, "H")
        utcMin := FormatTime(utcNow, "m")
        utcSec := FormatTime(utcNow, "s")

        totalSecNow := utcHour * 3600 + utcMin * 60 + utcSec
        nextcosmeticSec := Ceil(totalSecNow / (4 * 3600)) * 4 * 3600
        remainingSec := Mod(nextcosmeticSec - totalSecNow, 14400)  ; every 4 hours

        cosmeticH := remainingSec // 3600
        cosmeticM := Mod(remainingSec, 3600) // 60
        cosmeticS := Mod(remainingSec, 60)

        tooltipText .= "Cosmetics: " cosmeticH ":" Format("{:02}", cosmeticM) ":" Format("{:02}", cosmeticS) "`n"
    }

    if (merchantEnabled) {
        utcNow := A_NowUTC
        utcHour := FormatTime(utcNow, "H")
        utcMin := FormatTime(utcNow, "m")
        utcSec := FormatTime(utcNow, "s")

        totalSecNow := utcHour * 3600 + utcMin * 60 + utcSec
        nextMerchantSec := Ceil(totalSecNow / (4 * 3600)) * 4 * 3600
        remainingSec := Mod(nextMerchantSec - totalSecNow, 14400)  ; every 4 hours

        merchantH := remainingSec // 3600
        merchantM := Mod(remainingSec, 3600) // 60
        merchantS := Mod(remainingSec, 60)

        tooltipText .= "Merchant: " merchantH ":" Format("{:02}", merchantM) ":" Format("{:02}", merchantS) "`n"
    }

    if (gearCraftingEnabled) {
        gearCraftRemaining := Max(0, GearCraftingTime - (currentTime - LastGearCraftingTime))
        gearM := gearCraftRemaining // 60
        gearS := Mod(gearCraftRemaining, 60)
        tooltipText .= "Gear Crafting: " gearM ":" Format("{:02}", gearS) "`n"
    }

    if (seedCraftingEnabled) {
        seedCraftRemaining := Max(0, SeedCraftingTime - (currentTime - LastSeedCraftingTime))
        seedM := seedCraftRemaining // 60
        seedS := Mod(seedCraftRemaining, 60)
        tooltipText .= "Seed Crafting: " seedM ":" Format("{:02}", seedS) "`n"
    }
    

    ToolTip(tooltipText, 100, 100)
}



F3::
{


    ; ActivateRoblox()
    ; ResizeRoblox()
    ; hwnd := GetRobloxHWND()
    ; GetRobloxClientPos(hwnd)
    ; pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY + 30 "|" windowWidth "|" windowHeight - 30)
    ; Gdip_SaveBitmapToFile(pBMScreen,"ss.png")
    ; Gdip_DisposeImage(pBMScreen)
    GearCraft()
    PauseMacro()
}

BuyBeanstalkEvent(){
    if !(CheckSetting("Events", "Events")){
        return 0
    }
    PlayerStatus("Going to Event Shop!", "0x22e6a8",,false,,false)

    ; Step 1: Click the Sell button
    Clickbutton("Sell")
    Sleep(1500)

    ; go right (s)
    Send("{" Skey " down}")
    HyperSleep(400)
    Send("{" Skey " up}")

    ; down (s)
    Send("{" Akey " down}")
    HyperSleep(9800)
    Send("{" Akey " up}")

    ; Step 4: click E (entering a portal)
    Send("{" Ekey "}")
    Sleep(1200)

    ; go right (s)
    Send("{" Skey " down}")
    HyperSleep(100)
    Send("{" Skey " up}")

    ; down (a)
    Send("{" Akey " down}")
    HyperSleep(1200)
    Send("{" Akey " up}")

    ; go left (w)
    Send("{" Wkey " down}")
    HyperSleep(600)
    Send("{" Wkey " up}")

    ; down (a)
    Send("{" Akey " down}")
    HyperSleep(1900)
    Send("{" Akey " up}")

    ; down (s)
    Send("{" Skey " down}")
    HyperSleep(700)
    Send("{" Skey " up}")

    ; left (a)
    Send("{" Akey " down}")
    HyperSleep(700)
    Send("{" Akey " up}")

    ; click E (buying from a vendor)
    Send("{" Ekey "}")

    beanstalkItems := [
        "BeanstalkItem", "BeanstalkItem", "BeanstalkItem", "BeanstalkItem", "BeanstalkItem", "BeanstalkItem",
        "BeanstalkItem", "BeanstalkItem", "BeanstalkItem", "BeanstalkItem", "BeanstalkItem", "BeanstalkItem",
        "BeanstalkItem", "BeanstalkItem"
    ]

    PlayerStatus("Going to buy Beanstalk!", "0x22e6a8",,false,,false)
    clickOption(1,2)
    if !DetectShop("Beanstalk"){
        PlayerStatus("Failed to open beanstalk shop.", "0x001a12")
        return 0
    }
    buyShop(beanstalkItems, "Events")
    CloseClutter()
    return 1
}


CookingEvent(){
    if !(CheckSetting("Settings", "CookingEvent")){
        return 0
    }

    PlayerStatus("Going to Cooking Event!", "0x22e6a8",,false,,false)
    Clickbutton("Garden")
    Sleep(1500)
    Send("{" Ekey "}")
    Send("{" Ekey "}")
    Sleep(2500)
    if (Clickbutton("Robux") == 1){
        PlayerStatus("Crafting not finished. Closing Robux prompt.","0xe67e22",,false)
        return 0
    }
    PlayerStatus("Claimed food!", "0x22e6a8",,false)
    searchListraw := IniRead(settingsFile, "Settings", "SearchList")
    searchList := StrSplit(searchListRaw, ",")
    for index, item in searchList {
        item := Trim(item)
        searchItem(item)
        Sleep(500)
        clickCategory("Fruit")
        Sleep(500)
        clickItem(item, "Bracket")
        Sleep(500)
        Send("{" Ekey "}")
        Send("{" Ekey "}")
        Sleep(500)
    }

    relativeMouseMove(0.5,0.5)
    Click
    Loop 40 {
        Send("{WheelUp}")
        Sleep 20
    }
    Click
    Click
    ZoomAlign()
    PlayerStatus("Cooking food!", "0x22e6a8",,false)
    Send("1")
    Sleep(250)
    Send("1")
}

;BuyEvent(){
;   if !(CheckSetting("Events", "Events")){
;        return 0
;    }
;    PlayerStatus("Going to Event Shop!", "0x22e6a8",,false,,false)

;    if !DetectShop("Beanstalk"){
;        return 0 
;    }
;    buyShop(getItems("Events"), "Events")
;    CloseClutter()
;    return 1
;}






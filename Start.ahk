#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn VarUnset, Off
SetWorkingDir A_ScriptDir
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



#include %A_ScriptDir%\lib\

#Include FormData.ahk
#Include Gdip_All.ahk
#include Gdip_ImageSearch.ahk
#include json.ahk
#Include roblox.ahk
#Include ComVar.ahk
#Include Promise.ahk
#Include WebView2.ahk
#Include WebViewToo.ahk

#Include %A_ScriptDir%\images\
#include bitmaps.ahk
#include %A_ScriptDir%\scripts\

#Include gui.ahk
#Include webhook.ahk
#Include timers.ahk
#Include functions.ahk

; #Include comp.ahk ; for competitve event paid only or ya




CheckDisconnnect(){
    global VipLink
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
            DeepLink := "roblox://navigation/share_links?code=" shareCode "&type=Server"
        } else {
            DeepLink := "roblox://placeID=" PlaceID
        }
        try Run DeepLink


        loop 20 {
            if GetRobloxHWND() {
                ActivateRoblox()
                GetRobloxClientPos(GetRobloxHWND())
                ResizeRoblox()
                loop {
                    ActivateRoblox()
                    newWidth := windowWidth - 100
                    newHeight := windowHeight - 60
                    newX := windowX + (windowWidth - newWidth) // 4
                    newY := windowY + (windowHeight - newHeight) // 4

                    captureWidth := 10
                    captureHeight := 10
                    captureX := windowX  
                    captureY := windowY + (windowHeight - captureHeight) // 2  

                    pBMScreen := Gdip_BitmapFromScreen(captureX "|" captureY "|" captureWidth "|" captureHeight)


                    if !GetRobloxClientPos() {
                        PlayerStatus("Disconnected from roblox", "0xfa7900", ,false, ,false)
                        Gdip_DisposeImage(pBMScreen)
                        return 0
                    }
                    If (Gdip_ImageSearch(pBMScreen, bitmaps["loading"], , , , , , 2) = 1) {
                        Gdip_DisposeImage(pBMScreen)
                        PlayerStatus("Detected BSS Loading Screen", "0x0060c0", ,false, ,false)
                        MouseMove windowX + windowWidth//2, windowY + windowHeight//2
                        Sleep(10000)
                        Send(AKey)
                        Send(AKey)
                        Send(AKey)
                        Click
                        break
                    }
                    if (A_Index = 30 * 2) { ; Default, 15 seconds.
                        Gdip_DisposeImage(pBMScreen)
                        PlayerStatus("Did not detect Loading screen.", "0xff0000", ,false)
                        return 0
                    }
                    Gdip_DisposeImage(pBMScreen)
                    Sleep 1000 // 2 
                }
                loop {
                    ActivateRoblox()
                    captureWidth := 10
                    captureHeight := 10
                    captureX := windowX  ; Left edge
                    captureY := windowY + (windowHeight - captureHeight) // 2  

                    pBMScreen := Gdip_BitmapFromScreen(captureX "|" captureY "|" captureWidth "|" captureHeight)

                    if !GetRobloxClientPos() {
                        PlayerStatus("Disconnected from roblox", "0xfa7900", ,false, ,false)
                        Gdip_DisposeImage(pBMScreen)
                        return 0
                    }
                    If !(Gdip_ImageSearch(pBMScreen, bitmaps["loading"], , , , , , 2) = 1) {
                        Gdip_DisposeImage(pBMScreen)
                        PlayerStatus("Game Succesfully loaded", "0x00a838", ,false)
                        return 1
                    }
                    if (A_Index = 30 * 2) { ; Default, 15 seconds.
                        Gdip_DisposeImage(pBMScreen)
                        PlayerStatus("BSS Join Error.", "0xff0000", ,false)
                        return 0
                    }
                    Gdip_DisposeImage(pBMScreen)
                    Sleep 1000 // 2 
                }
    
            }
            if (A_Index = 20) {
                return 0
            }
            Sleep 1000
        }
    }
    Gdip_DisposeImage(pBMScreen)
    return 0

}


CheckSetting(value, item){
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


Clickbutton(button){
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)    
    
    if (button == "Garden" || button == "Sell" || button == "Seeds"){
        capX := windowX + (windowWidth // 4)
        capY := windowY + 30
        capW := windowWidth // 2
        capH := 100
    } else if (button == "Xbutton" || button == "Xbutton2") {
        capX := windowX + windowWidth * 0.6411
        capY := windowY + windowHeight * 0.2065
        capW := windowWidth * 0.1
        capH := windowHeight * 0.1667
    } 

    pBMScreen := Gdip_BitmapFromScreen(capX "|" capY "|" capW "|" capH)

    if (Gdip_ImageSearch(pBMScreen, bitmaps[button], &OutputList, , , , , 10,,7) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + capX - 2
        y := Cords[2] + capY 
        MouseMove(x, y)
        Click
        Gdip_DisposeImage(pBMScreen)
        return 1
    }
    Gdip_DisposeImage(pBMScreen)
}


ChangeCamera(){
    Send("{" EscKey "}")
    Sleep(350)
    Send("{Tab}")
    Sleep(350)
    Send("{Down}")
    Sleep(350)
    Send("{Right 2}")
    Sleep 350
    Send("{" EscKey "}")
    Sleep(750)
}



CameraCorrection(){
    ChangeCamera()

    Loop 40 {
        Send("{WheelUp}")
        Sleep 20
    }

    Sleep(300)
    Loop 6 {
        Send("{WheelDown}")
        Sleep 50
    }


    Click("Right", "Down")
    Sleep(200)
    relativeMouseMove(0.5, 0.5)
    Sleep(200)
    MouseMove(0, 800, 10, "R")
    Sleep(200)
    Click("Right", "Up")

    loop 10 {
        Clickbutton("Sell") ; sell button
        Sleep(50)
        Clickbutton("Seeds") ; seeds button
        Sleep(50)
    }
    ChangeCamera()
    Clickbutton("Garden") ; Garden button
    Click
    Sleep(500)
}

SpamClick(amount){
    loop amount {
        Click
        Sleep 20
    }
}

CheckStock(index, list){
    ActivateRoblox()
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    captureWidth := 150
    captureHeight := windowHeight // 2

    captureX := windowX + (windowWidth // 2) - (captureWidth // 2) - 150
    captureY := windowY + (windowHeight // 2) - (captureHeight // 2)

    pBMScreen := Gdip_BitmapFromScreen(captureX "|" captureY "|" captureWidth "|" captureHeight)
    If (Gdip_ImageSearch(pBMScreen, bitmaps["GreenStock"], &OutputList, , , , , 3,,3) = 1 || Gdip_ImageSearch(pBMScreen, bitmaps["GreenStock2"], &OutputList , , , , , 3,,3) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + captureX 
        y := Cords[2] + captureY 
        MouseMove(x, y)
        Gdip_DisposeImage(pBMScreen)
        Sleep(100)
        if (list[index] == "Carrot Seed"){
            SpamClick(25)
        }
        SpamClick(6)
        PlayerStatus("Bought " list[index] "s!", "0x22e6a8",,false)
        return 1
    }
    Gdip_DisposeImage(pBMScreen)
    return 0

}

buyShop(itemList, itemType){
    for (item in itemlist){
        if (A_index == 1){
            relativeMouseMove(0.5,0.4)
            Loop 40 {
                Send("{WheelUp}")
                Sleep 20
            }
            Sleep(100)
        } else {
            if (itemType == "Event"){
                relativeMouseMove(0.4,0.8)
            } else {
                relativeMouseMove(0.4,0.845)
            }
        }

        Click
        Sleep(300)
        if (CheckSetting(StrReplace(item, " ", ""), itemType)){
            CheckStock(A_Index, itemlist)
        }
    }
    Clickbutton("Xbutton")
    Clickbutton("Xbutton2")
}


BuySeeds(){
    seedItems := ["Carrot Seed", "Strawberry Seed", "Blueberry Seed", "Tomato Seed"
             , "Cauliflower Seed", "Watermelon Seed", "Rafflesia Seed"
             , "Green Apple Seed", "Avocado Seed", "Banana Seed", "Pineapple Seed"
             , "Kiwi Seed", "Bell Pepper Seed", "Prickly Pear Seed", "Loquat Seed"
             , "Feijoa Seed", "Pitcher Plant", "Sugar Apple"]



    PlayerStatus("Going to buy seeds!", "0x22e6a8",,false,,false)
    Clickbutton("Seeds")
    Click
    Sleep(1000)
    Send("{" Ekey "}")
    Sleep(2500)
    buyShop(seedItems, "Seeds")
}






BuyGears(){
    gearItems := [
        "Watering Can", "Trowel", "Recall Wrench", 
        "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Magnifying Glass",
        "Tanning Mirror", "Master Sprinkler", "Cleaning Spray",
        "Favorite Tool", "Harvest Tool", "Friendship Pot",
    ]


    PlayerStatus("Going to buy Gears!", "0x22e6a8",,false,,false)
    ActivateRoblox()
    Send("2")
    MouseMove windowX + windowWidth//2, windowY + windowHeight//2
    Click
    Sleep(1500)
    Send("{" Ekey "}")
    Sleep(2000)
    Loop 4 {
        Send("{WheelUp}")
        Sleep 50
    }
    Sleep(500)
    MouseMove windowWidth * (1714 / 1920), windowHeight * (400 / 1080)
    Click
    Loop 4 {
        Send("{WheelDown}")
        Sleep 50
    }
    Sleep(2500)
    buyShop(gearItems, "Gears")
}


BuyEvent(){
    
    EventItems := [
        "Summer Seed Pack", "Delphinium Seed", "Lily of the Valley Seed", 
        "Travelers Fruit Seed", "Burnt Mutation Spray", 
        "Oasis Crate", "Oasis Egg", "Hamster",
    ]
    PlayerStatus("Going to buy Summer Event Shop!", "0x22e6a8",,false,,false)
    ActivateRoblox()
    Clickbutton("Sell") ; sell button
    MouseMove windowX + windowWidth//2, windowY + windowHeight//2
    Sleep(1500)
    Send("{" AKey " down}")
    HyperSleep(10150)
    Send("{" Akey " up}")
    Send("{" Wkey " down}")
    HyperSleep(650)
    Send("{" Wkey " up}")
    Sleep(1000)
    Loop 3 {
        Send("{WheelDown}")
        Sleep 50
    }
    Sleep(500)
    Send("{" Ekey "}")
    Loop 3 {
        Send("{WheelUp}")
        Sleep 50
    }
    Sleep(2000)
    Loop 4 {
        Send("{WheelUp}")
        Sleep 50
    }
    Sleep(500)
    MouseMove windowWidth * (1714 / 1920), windowHeight * (400 / 1080)
    Click
    Loop 4 {
        Send("{WheelDown}")
        Sleep 50
    }
    Sleep(2500)
    buyShop(EventItems, "Event")
}



BuyEggs(){
    PlayerStatus("Going to buy Eggs!", "0x22e6a8",,false,,false)
    ActivateRoblox()
    Send("2")
    MouseMove windowX + windowWidth//2, windowY + windowHeight//2
    Click
    Sleep(1000)
    Send("{s Down}")
    Sleep(800)
    Send("{s Up}")
    Sleep(1000)
    Send("{" Ekey "}")
    Sleep(250)
    CheckEggStock()

    loop 2 {
        Sleep(1000)
        Send("{s Down}")
        Sleep(220)
        Send("{s Up}")
        Sleep(1000)
        Send("{" Ekey "}")
        Sleep(220)
        CheckEggStock()
    }

}



CheckEggStock(){
    ActivateRoblox()
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)

    eggColorMap := Map(
        "Common Egg",         "0xffffffff",
        "Common Summer Egg",  "0xffffff00",
        "Rare Summer Egg",    "0xffa2f1f0",
        "Mythical Egg",       "0xffffcc00",
        "Paradise Egg",       "0xffffcd32",
        "Bee Egg",            "0xffffaa00",
        "Bug Egg",            "0xffd5ff86",
    )

    eggitems := [
        "Common Egg", "Common Summer Egg", "Rare Summer Egg", 
        "Mythical Egg", "Paradise Egg", "Bee Egg", "Bug Egg"
    ]

    for egg in eggitems{
        captureWidth := windowWidth * 390 // 1920
        captureHeight := windowHeight * 70 // 1080

        captureX := windowX + (windowWidth // 2) - (captureWidth // 2) + windowWidth * 20 // 1920
        captureY := windowY + (windowHeight // 2) - (captureHeight // 2) - windowHeight * 170 // 1080

        pBMScreen := Gdip_BitmapFromScreen(captureX "|" captureY "|" captureWidth "|" captureHeight)

        if (Gdip_PixelSearch(pBMScreen,eggColorMap[egg],&x,&y,,,5)){
            if (CheckSetting(StrReplace(egg," ", ""), "Eggs")){ 
                CheckStock(A_Index, eggitems)
            } else {
                PlayerStatus("Skipping " Egg "!", "0x22e6a8",,false,,false)
            }
            Clickbutton("Xbutton")
            Clickbutton("Xbutton2")
            Gdip_DisposeImage(pBMScreen)
            return 1
        }
        Gdip_DisposeImage(pBMScreen)
    }
}













;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main Macro Functions.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Disconnect(){
    loop {
        if !(CheckDisconnnect()){
            return 0
        } else {
            return 1
        }
        if (A_Index == 3) {
            IniWrite("", settingsFile, "Settings", "url")
            PlayerStatus("Changing to public server....", "0x5745ff")
            return 1
        }
    }
}

MainLoop() {
    MyWindow.Destroy()

    if (GetRobloxHWND()){
        ResizeRoblox()
    }
    
    if (Disconnect()){
        return
    }
    Sleep(300)
    MouseMove windowX + windowWidth//2, windowY + windowHeight//2
    Click
    Click
    Sleep(1000)
    CameraCorrection()
    BuySeeds()
    BuyGears()
    BuyEggs()
    BuyEvent()
    loop {
        RewardInterupt()
        if (Disconnect()){
            return
        }
        ToolTip("Seed Shop: " (r:=Mod(300 - Mod(A_Min*60 + A_Sec, 300), 300))//60 ":" Mod(r,60) 
        "`nGear Shop: " (r:=Mod(300 - Mod(A_Min*60 + A_Sec, 300), 300))//60 ":" Mod(r,60) 
        "`nEgg Shop: " (r:=Mod(1800 - Mod(A_Min*60 + A_Sec, 1800),1800))//60 ":" Mod(r,60)), 1000
        Sleep(1000)
    }
    
    
    
}




F3::
{


    ActivateRoblox()
    ResizeRoblox()
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    
}
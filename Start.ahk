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
                ResizeRoblox()
                GetRobloxClientPos(GetRobloxHWND())
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
                        PlayerStatus("Detected Loading Screen", "0x0060c0", ,false, ,false)
                        MouseMove windowX + windowWidth//2, windowY + windowHeight//2
                        Sleep(15000)
                        Click
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
                        Sleep(1000)
                        Send("{Tab}")
                        Send("1")
                        Sleep(300)
                        CloseChat()
                        Sleep(500)
                        equipRecall()
                        Sleep(1000)
                        return 1
                    }
                    if (A_Index = 30 * 2) { ; Default, 15 seconds.
                        Gdip_DisposeImage(pBMScreen)
                        PlayerStatus("Join Error.", "0xff0000", ,false)
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
    if (Gdip_ImageSearch(pBMScreen, bitmaps["Openbag"] , &OutputList, , , , , 25) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + windowX + 50
        y := Cords[2] + windowY
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

equipRecall(){
    ActivateRoblox()
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    openBag()
    Sleep(1000)
    cordx := 0
    cordy := 0
    pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY "|" windowWidth "|" windowHeight )
    if (Gdip_ImageSearch(pBMScreen, bitmaps["Search"] , &OutputList, , , , , 25) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + windowX
        y := Cords[2] + windowY
        cordx := x
        cordy := y
        MouseMove(x, y)
        Sleep(300)
        Click
        Sleep(500)
        Send("recall")
        Sleep(300)
        Gdip_DisposeImage(pBMScreen)
    } else {
        PlayerStatus("Could not detect Search in inventory", "0xFF0000")
        Gdip_DisposeImage(pBMScreen)
    }


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
    if (Gdip_ImageSearch(pBMScreen, bitmaps["recall slot"] , &OutputList, , , , , 10,,6) = 1 || Gdip_ImageSearch(pBMScreen, bitmaps["recall slot2"] , &OutputList, , , , , 10,,6) = 1) {
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

clearSearch(){
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)
    pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY + 30 "|" windowWidth "|" windowHeight - 30)
    if (Gdip_ImageSearch(pBMScreen, bitmaps["x"] , &OutputList, , , , , 20,,6) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + windowX 
        y := Cords[2] + windowY + 30
        MouseMove(x, y)
        Sleep(750)
        Click
        Click
        Sleep(500)
    }
    if (Gdip_ImageSearch(pBMScreen, bitmaps["Favorite"] , &OutputList, , , , , 20,,6) = 1) {
        Cords := StrSplit(OutputList, ",")
        x := Cords[1] + windowX 
        y := Cords[2] + windowY + 30
        MouseMove(x, y)
        Sleep(750)
        Click
        Sleep(500)
    }
    Gdip_DisposeImage(pBMScreen)
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


Clickbutton(button, clickit := 1){
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
    } else if (button == "Robux"){
        capX := windowX + 5
        capY := windowY
        capW := windowWidth
        capH := windowHeight 
    }

    pBMScreen := Gdip_BitmapFromScreen(capX "|" capY "|" capW "|" capH)

    if (Gdip_ImageSearch(pBMScreen, bitmaps[button], &OutputList, , , , , 25,,7) = 1) {
        if (clickit == 1){
            Cords := StrSplit(OutputList, ",")
            x := Cords[1] + capX - 2
            y := Cords[2] + capY 
            MouseMove(x, y)
            Sleep(50)
            Click
        }
        Gdip_DisposeImage(pBMScreen)
        return 1
    }
    Gdip_DisposeImage(pBMScreen)
    return 0
}


ChangeCamera(){
    Send("{" EscKey "}")
    Sleep(250)
    Send("{Tab}")
    Sleep(250)
    Send("{Down}")
    Sleep(250)
    Send("{Right}")
    Sleep(250)
    Send("{Right}")
    Sleep 250
    Send("{" EscKey "}")
    Sleep(1000)
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
    CloseClutter()
    Sleep(300)
    ChangeCamera()

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
    ChangeCamera()
    Sleep(1000)
    Clickbutton("Garden") 
    Sleep(500)
}

SpamClick(amount){
    loop amount {
        Click
        Sleep 20
    }
}

CheckStock(index, list, crafter := 0){
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
        Gdip_DisposeImage(pBMScreen)
        Sleep(100)
        if (list[index] == "Carrot Seed" || list[index] == "Orange Tulip" || list[index] == "Bamboo Seed" || list[index] == "Mushroom Seed"){
            SpamClick(25)
        } else if (crafter == 1){
            Click
        } else {
            SpamClick(6)
        }
        Sleep(150)
        PlayerStatus("Bought " list[index] "s!", "0x22e6a8",,false)
        return 1
    }
    Gdip_DisposeImage(pBMScreen)
    return 0

}

buyShop(itemList, itemType, crafter := 0){
    for (item in itemlist){
        if (A_index == 1){
            relativeMouseMove(0.5,0.4)
            Sleep(100)
            Loop 40 {
                Send("{WheelUp}")
                Sleep 20
            }
            Sleep(500)
        } else {
            if (itemType == "Event" || itemType == "Eggs"){
                relativeMouseMove(0.4,0.8)
            } else {
                relativeMouseMove(0.4,0.845)
            }
        }

        Click
        Sleep(350)
        if (A_index >= 19){ ; last items
            relativeMouseMove(0.5, 0.5)
            ScrollDown(0.5) ; 0.25 means a quarter of normal scroll
            Sleep 100
        }
        if (CheckSetting(StrReplace(item, " ", ""), itemType)){
            CheckStock(A_Index, itemlist, crafter)
        } else {
            Sleep(200)
        }
    }
    CloseShop()
}


ScrollDown(amount := 1) {
    DllCall("user32.dll\mouse_event", "UInt", 0x0800, "UInt", 0, "UInt", 0, "UInt", -amount * 120, "UPtr", 0)
}

; 1 = 1st option, 2 = 2nd option, etc for example the gear shop to open the shop
clickOption(option){
    Sleep(500)
    ZoomAlign()
    Sleep(2000)
    Loop 4 {
        Send("{WheelUp}")
        Sleep 50
    }
    Sleep(500)

    if (option == "1"){
        MouseMove windowWidth * (1600 / 1920), windowHeight * (390 / 1080)
    } else if (option == "2"){
        MouseMove windowWidth * (1600 / 1920), windowHeight * (570 / 1080)
    } else if (option == "3"){
        MouseMove windowWidth * (1600 / 1920), windowHeight * (770 / 1080)
    } else if (option == "4"){
        MouseMove windowWidth * (1600 / 1920), windowHeight * (930 / 1080)
    }
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
        if (Clickbutton("Xbutton",0) == 1 || Clickbutton("Xbutton2",0) == 1){
            Sleep(333)
            PlayerStatus("Detected " shop " shop opened", "0x22e6a8",,false,,false)
            return 1
        }
    }
    PlayerStatus("Failed to open " shop " shop", "0x22e6a8",,false,,true)
    return 0
}


CloseShop(){
    loop 15 {
        Sleep(500)
        if (Clickbutton("Xbutton") == 1 || Clickbutton("Xbutton2") == 1){
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
    Clickbutton("Xbutton2")
    Clickbutton("Robux")
    Sleep(300)
}

BuySeeds(){
    seedItems := [
            "Carrot Seed", "Strawberry Seed", "Blueberry Seed", "Orange Tulip", "Tomato Seed", "Corn Seed"
             , "Daffodll Seed", "Watermelon Seed", "Pumpkin Seed"
             , "Apple Seed", "Bamboo Seed", "Coconut Seed", "Cactus Seed"
             , "Dragon Fruit Seed", "Mango Seed", "Grape Seed", "Mushroom Seed"
             , "Pepper Seed", "Cacao Seed", "Beanstalk Seed", "Ember Lily", "Sugar Apple", "Burning Bud", "Gaint Pinecone Seed"

    ]


    PlayerStatus("Going to buy Seeds!", "0x22e6a8",,false,,false)
    Clickbutton("Seeds")
    Sleep(1500)
    CloseClutter()
    Sleep(300)
    Send("{" Ekey "}")
    if !DetectShop("Seeds"){
        CloseRoblox()
        return 0
    }
    buyShop(seedItems, "Seeds")

}






BuyGears(){
    gearItems := [
        "Watering Can", "Trowel", "Recall Wrench", 
        "Basic Sprinkler", "Advanced Sprinkler", "Medium Toy", "Medium Treat",
        "Godly Sprinkler", "Magnifying Glass",
        "Tanning Mirror", "Master Sprinkler", "Cleaning Spray",
        "Favorite Tool", "Harvest Tool", "Friendship Pot", "Levelup Lollipop"
    ]


    PlayerStatus("Going to buy Gears!", "0x22e6a8",,false,,false)
    CloseClutter()
    Send("1")
    Sleep(300)
    relativeMouseMove(0.5, 0.5)
    Click
    Sleep(1500)
    Send("{" Ekey "}")
    clickOption('1')
    if !DetectShop("gear"){
        CloseRoblox()
        return 0
    }
    buyShop(gearItems, "Gears")
}


BuyEggs(){
    PlayerStatus("Going to buy Eggs!", "0x22e6a8",,false,,false)
    ActivateRoblox()
    Send("1")
    MouseMove windowX + windowWidth//2, windowY + windowHeight//2
    Click
    Sleep(1000)
    Send("{s Down}")
    HyperSleep(600)
    Send("{s Up}")
    Sleep(1000)
    Send("{" Ekey "}")
    Sleep(500)
    ZoomAlign()
    Sleep(2000)
    Loop 4 {
        Send("{WheelUp}")
        Sleep 50
    }
    Sleep(500)

    MouseMove windowWidth * (1600 / 1920), windowHeight * (150 / 1080)
    Click
    Loop 4 {
        Send("{WheelDown}")
        Sleep 50
    }
    Sleep(2500)

    if !DetectShop("egg"){
        CloseRoblox()
        return 0
    }
    eggitems := [
        "Common Egg", "Common Summer Egg", "Rare Summer Egg", 
        "Mythical Egg", "Paradise Egg", "Bug Egg"
    ]
    buyShop(eggitems, "Eggs")

}





currentnumber := 1
BuyEvent(){
    if (IniRead(settingsFile, "Settings", "DinoEvent") == "0"){
        return
    }

    PlayerStatus("Going to sacrifice a pet!", "0x22e6a8",,false,,false)
    CloseClutter()
    Sleep(300)
    Send("1")
    Sleep(300)
    relativeMouseMove(0.5, 0.5)
    Sleep(200)
    Click
    Sleep(1500)
    Send("{" Skey " down}")
    HyperSleep(200)
    Send("{" Skey " up}")
    Send("{" Dkey " down}")
    HyperSleep(8650)
    Send("{" Dkey " up}")
    Sleep(500)
    Send("{" Ekey "}")
    Sleep(1000)
    PlayerStatus("Collected ancient pet!!", "0x22e6a8",,false)
    
    Send("{" Wkey " down}")
    HyperSleep(350)
    Send("{" Wkey " up}")
    Sleep(300)
    Send("{" Dkey " down}")
    HyperSleep(100)
    Send("{" Dkey " up}")

    global currentnumber += 1
    if (currentnumber + 0 == 10) {
        currentnumber := 0 
        IniWrite("0", settingsFile, "Settings", "DinoEvent")
        PlayerStatus("Finished with selling all pets!", "0x22e6a8",,false,,false)
    }
    Sleep(2500)
    Send(currentnumber)
    Sleep(500)
    Send("{" Ekey "}")
    Sleep(1000)
    clickOption("3")
    PlayerStatus("Sacrificed a pet in " currentnumber " hotbar slot" , "0x22e6a8",,false)
}


GearCraft(){
    if (IniRead(settingsFile, "GearCrafting", "GearCrafting") == "0"){
        return
    }
    PlayerStatus("Going to craft Gears!", "0x22e6a8",,false,,false)
    CloseClutter()
    Sleep(300)
    Send("1")
    Sleep(300)
    relativeMouseMove(0.5, 0.5)
    Click
    Sleep(1500)
    Send("{" WKey " down}")
    HyperSleep(1200)
    Send("{" WKey " up}")
    Sleep(1000)
    GearRecipe := [
        { Name: "Lighting Rod", Materials: ["Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler"], CraftTime: 2700 },
        { Name: "Reclaimer", Materials: ["Common Egg item", "Harvesting Tool"], CraftTime: 1500 },
        { Name: "Tropical Mist Sprinkler", Materials: ["Coconut", "Dragon Fruit", "Mango", "Godly Sprinkler"], CraftTime: 3600 },
        { Name: "Berry Blusher Sprinkler", Materials: ["Grape", "Blueberry", "Strawberry", "Godly Sprinkler"], CraftTime: 3600 },
        { Name: "Spice Spirtzer Sprinkler", Materials: ["Pepper", "Ember Lily", "Cacao", "Master Sprinkler"], CraftTime: 3600 },
        { Name: "Sweet Soaker Sprinkler", Materials: ["Watermelon", "Watermelon", "Watermelon", "Master Sprinkler"], CraftTime: 3600 },
        { Name: "Flower Froster Sprinkler", Materials: ["Orange Tulip", "Daffodil", "Advanced Sprinkler", "Basic Sprinkler"], CraftTime: 3600 },
        { Name: "Stalk Sprout Sprinkler", Materials: ["Bamboo", "Beanstalk", "Mushroom", "Advanced Sprinkler"], CraftTime: 3600 },
        { Name: "Mutation Spray Choc", Materials: ["Cleaning Spray", "Cacao"], CraftTime: 720 },
        { Name: "Mutation Spray Chilled", Materials: ["Cleaning Spray", "Godly Sprinkler"], CraftTime: 300 },
        { Name: "Mutation Spray Shocked", Materials: ["Cleaning Spray", "Lighting Rod"], CraftTime: 1800 },
        { Name: "Anti Bee Egg", Materials: ["Bee Egg item"], CraftTime: 7200 },
        { Name: "Pack Bee", Materials: ["Anti Bee Egg item", "Sunflower", "Purple Dahila"], CraftTime: 14400 }
    ]
    GearNames := [
        "Lighting Rod",
        "Reclaimer",
        "Tropical Mist Sprinkler",
        "Berry Blusher Sprinkler",
        "Spice Spirtzer Sprinkler",
        "Sweet Soaker Sprinkler",
        "Flower Froster Sprinkler",
        "Stalk Sprout Sprinkler",
        "Mutation Spray Choc",
        "Mutation Spray Chilled",
        "Mutation Spray Shocked",
        "Anti Bee Egg",
        "Pack Bee"
    ]


    global GearCraftingTime := Crafting(GearRecipe, "GearCrafting", GearNames) + 200
    Sleep(1000)

}






GearCraftingTime := 100000 ; Default crafting time, will be overwritten by the first item in the recipe

Crafting(Recipeitems, settingName, Names){
    ActivateRoblox()
    hwnd := GetRobloxHWND()
    GetRobloxClientPos(hwnd)

    
    for item in Recipeitems {
        if (IniRead(settingsFile, settingName, StrReplace(item.name, " ", "")) == "1"){
            ; Claim Crafting item
            Send("{c}")
            Sleep(300)
            Send("{" Ekey "}")
            Sleep(2500)
            if (Clickbutton("Robux") == 1){
                PlayerStatus("Crafting not finished. Closing Robux prompt.","0xe67e22",,false)
                return item.CraftTime
            }
            CloseClutter()
            PlayerStatus("Claimed " item.Name "!", "0x22e6a8",,false)
            Send("{" Ekey "}")
            if !DetectShop("crafting"){
                CloseRoblox()
                return item.CraftTime
            }
            ; Choose to craft item
            buyShop(Names, settingName, 1)
            ; Search for the name 
            openBag()
            clearSearch()
            Sleep(1500)
            cordx := 0
            cordy := 0
            pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY + 30 "|" windowWidth "|" windowHeight - 30)
            if (Gdip_ImageSearch(pBMScreen, bitmaps["Search"] , &OutputList, , , , , 25,,2) = 1) {
                Cords := StrSplit(OutputList, ",")
                x := Cords[1] + windowX
                y := Cords[2] + windowY + 30
                cordx := x
                cordy := y
                Gdip_DisposeImage(pBMScreen)
            } else {
                PlayerStatus("Could not detect Search in inventory", "0xFF0000")
                Gdip_DisposeImage(pBMScreen)
                closeBag()
                return item.CraftTime
            }
            Gdip_DisposeImage(pBMScreen)
            ; Clicked on the search bar, now type the name

            for Material in item.Materials {
                MouseMove(cordx, cordy)
                Sleep(300)
                Click
                Sleep(1000)
                Send(StrReplace(Material, "item", ""))
                Sleep(1500)
                pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY + 30 "|" windowWidth "|" windowHeight - 30)
                if (Gdip_ImageSearch(pBMScreen, bitmaps[Material], &OutputList, , , , , 25,,2) = 1) {
                    Cords := StrSplit(OutputList, ",")
                    x := Cords[1] + windowX
                    y := Cords[2] + windowY + 30
                    MouseMove(x, y)
                    Sleep(250)
                    Click
                    Sleep(1000)
                    Send("{" Ekey "}")
                    Sleep(250)
                    Send("1")
                    Sleep(100)
                    Send("1")
                    Sleep(500)
                    Gdip_DisposeImage(pBMScreen)
                } else {
                    PlayerStatus("Missing " Material " for " item.Name "!", "0xff0000",,false,,pBMScreen)
                    Gdip_DisposeImage(pBMScreen)
                }
                clearSearch()
            }
            closeBag()
            Send("{" Ekey "}")
            Send("{" Ekey "}")
            Sleep(1000)
            CloseClutter()
            PlayerStatus("Crafting " item.Name "!", "0x22e6a8",,false)
            Clickbutton("Garden")
            return item.CraftTime
        }
    }
    return 99999999
}




; BuyMerchant(){
;     seedItems := [
;         "Mushroom Seed","Mushroom Seed","Mushroom Seed","Mushroom Seed","Mushroom Seed","Mushroom Seed",
;         "Mushroom Seed","Mushroom Seed","Mushroom Seed","Mushroom Seed","Mushroom Seed","Mushroom Seed",
;     ]

;     PlayerStatus("Going to buy Traveling Merchant!", "0x22e6a8",,false,,false)
;     Clickbutton("Seeds")
;     Sleep(1500)
;     CloseClutter()
;     Sleep(300)
;     Send("{" Akey " down}")
;     HyperSleep(250)
;     Send("{" Akey " down}")
    
;     Send("{" Wkey " down}")
;     HyperSleep(750)
;     Send("{" Wkey " down}")
    
;     Send("{" Dkey " down}")
;     HyperSleep(250)
;     Send("{" Dkey " down}")

;     Send("{" Ekey "}")
;     if !DetectShop("traveling merchant"){
;         return 0
;     }
;     buyShop(seedItems, "Seeds")
; }










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

    if (GetRobloxHWND()){
        ResizeRoblox()
    }
    
    if (Disconnect()){
        return
    }

    CloseChat() 
    CameraCorrection()
    BuySeeds()
    BuyGears()
    BuyEggs()
    BuyEvent()
    GearCraft()
    loop {
        RewardInterupt()
        if (Disconnect()){
            CameraCorrection()
        }
        ToolTip("Seed Shop: " (r:=Mod(300 - Mod(A_Min*60 + A_Sec, 300), 300))//60 ":" Mod(r,60) 
        "`nGear Shop: " (r:=Mod(300 - Mod(A_Min*60 + A_Sec, 300), 300))//60 ":" Mod(r,60) 
        "`nEgg Shop: " (r:=Mod(1800 - Mod(A_Min*60 + A_Sec, 1800),1800))//60 ":" Mod(r,60)), 1000
        Sleep(1000)
    }
    
    
    
}







F3::
{


    ; ActivateRoblox()
    ; ResizeRoblox()
    ; hwnd := GetRobloxHWND()
    ; GetRobloxClientPos(hwnd)
    ; pBMScreen := Gdip_BitmapFromScreen(windowX "|" windowY  "|" windowWidth "|" windowHeight)
    ; Gdip_SaveBitmapToFile(pBMScreen,"ss.png")
    ; Gdip_DisposeImage(pBMScreen)
    ; BuySeeds()
    ; BuyGears()
    BuyEggs()
    ; BuyEvent()
}



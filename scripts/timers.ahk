nowUnix() {
    return DateDiff(A_NowUTC, "19700101000000", "Seconds")
}



RewardChecker() {

    Rewardlist := []

    currentTime := nowUnix()
    if (A_Min == 0 && IniRead(settingsFile,'Settings',"SummerHarvest") == 1) {
        Rewardlist.Push("SummerHarvest")
        return Rewardlist
    }
    if (Mod(A_Min,5) == 0) {
        Rewardlist.Push("Seeds")
    }
    if (Mod(A_Min,5) == 0) {
        Rewardlist.Push("Gears")
    }
    if (Mod(A_Min,30) == 0) {
        Rewardlist.Push("Eggs")
    }
    if (Mod(A_Min,30) == 0) {
        Rewardlist.Push("Event")
    }
    ; if (Mod(A_Hour, 2) == 0) {
    ;     Rewardlist.Push("Cosmetic")
    ; }
    return Rewardlist
}


; Calls RewardChecker -> RewardChecked functions to see if we are able to run those things
RewardInterupt() {

    variable := RewardChecker()

    for (k, v in variable) {
        ToolTip("")
        ActivateRoblox()
        if (v = "SummerHarvest") {
            BuySeeds()
            BuyGears()
            SummerHarvest()
            BuyEggs()
            BuyEvent()
        }
        if (v = "Seeds") {
            BuySeeds()
        }
        if (v = "Gears") {
            BuyGears()
        }
        if (v = "Eggs") {
            BuyEggs()
        }
        if (v = "Event") {
            BuyEvent()
        }
    }
    
    if (variable.Length > 0)
        CameraCorrection()
        if (Mod(A_Min,5) == 0){
            thing := 60 - A_Sec 
            ToolTip("Seed Shop: " (r:=Mod(300 - Mod(A_Min*60 + A_Sec, 300), 300))//60 ":" Mod(r,60) 
            "`nGear Shop: " (r:=Mod(300 - Mod(A_Min*60 + A_Sec, 300), 300))//60 ":" Mod(r,60) 
            "`nEgg Shop: " (r:=Mod(1800 - Mod(A_Min*60 + A_Sec, 1800),1800))//60 ":" Mod(r,60)), 1000
            Sleep((A_sec + thing) * 1000)

        }
        return 1
}



SummerHarvest(){
    PlayerStatus("Doing Summer Harvest !", "0x22e6a8",,false,,false)
    ActivateRoblox()
    ; Check if we are facing the correct direction.
    loop 10 {
        Clickbutton("Garden")
        
        if (A_Index == 6 ){
            BuySeeds()
            BuyGears()
            CameraCorrection()
        }

        ; Collection of Tomatos.
        GetRobloxClientPos()
        Sleep(1500)
        pBMScreen := Gdip_BitmapFromScreen(
            windowX + windowWidth * 0.1775 "|"  ; 377 / 1920
            windowY + windowHeight * 0.41 "|" ; 474 / 1080
            windowWidth * 0.028 "|"            ; (329 - 377) / 1920 = -48 / 1920
            windowHeight * 0.041               ; (418 - 474) / 1080 = -56 / 1080
        )        
        if (Gdip_PixelSearch(pBMScreen, "0xff864a26",,,,,100))  {
            global WKey:="sc01f" ; w 
            global AKey:="sc020" ; a 
            global SKey:="sc011" ; s 
            global Dkey:="sc01e" ; d 
        }
        Gdip_DisposeImage(pBMScreen)

        Send("{" Skey " down}")
        HyperSleep(3550)
        Send("{" Skey " up}")
        Send("{" Dkey " down}")
        HyperSleep(850)
        Send("{" Dkey " up}")
        Send("{" Wkey " down}")
        HyperSleep(500)
        Send("{" Wkey " up}")
        Sleep(1500)
        Send("{" Ekey " down}")
        Sleep(25000) 
        Send("{" Ekey " up}")
    
        global WKey:="sc011" ; w
        global AKey:="sc01e" ; a
        global SKey:="sc01f" ; s
        global Dkey:="sc020" ; d


        ; For sell 
        Clickbutton("Sell")
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
        MouseMove windowWidth * (1700 / 1920), windowHeight * (750 / 1080)
        Click
        Loop 4 {
            Send("{WheelDown}")
            Sleep 50
        }
        PlayerStatus("Sold Summer Harvest!", "0x22e6a8",,false)
    }

}
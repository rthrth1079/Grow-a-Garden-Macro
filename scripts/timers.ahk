nowUnix() {
    return DateDiff(A_NowUTC, "19700101000000", "Seconds")
}



RewardChecker() {

    Rewardlist := []

    currentTime := nowUnix()
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
        if (A_index == 1) {
            CameraCorrection()
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
        ; if (v = "Event") {
        ;     BuyEvent()
        ; }
    }
    
    if (variable.Length > 0)
        if (Mod(A_Min,5) == 0){
            thing := 60 - A_Sec 
            ToolTip("Seed Shop: " (r:=Mod(300 - Mod(A_Min*60 + A_Sec, 300), 300))//60 ":" Mod(r,60) 
            "`nGear Shop: " (r:=Mod(300 - Mod(A_Min*60 + A_Sec, 300), 300))//60 ":" Mod(r,60) 
            "`nEgg Shop: " (r:=Mod(1800 - Mod(A_Min*60 + A_Sec, 1800),1800))//60 ":" Mod(r,60)), 1000
            Sleep((A_sec + thing) * 1000)

        }
        return 1
}



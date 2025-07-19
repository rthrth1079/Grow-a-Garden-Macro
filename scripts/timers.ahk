nowUnix() {
    return DateDiff(A_NowUTC, "19700101000000", "Seconds")
}

LastGearCraftingTime := nowUnix()
LastSeedCraftingTime := nowUnix()




FourHours(){
    UtcNow := A_NowUTC
    UtcHour := FormatTime(UtcNow, "H")
    if (Mod(UtcHour, 4) == 0 && A_min == 0) {
        return true
    } 
    return false

}


RewardChecker() {
    global LastGearCraftingTime, EventCraftingtime, LastSeedCraftingTime


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
    if (A_Min == 0) {
        Rewardlist.Push("Events")
    }
    if (FourHours() && IniRead(settingsFile, "Settings", "TravelingMerchant") + 0 == 1) {
        Rewardlist.Push("TravelingMerchant")
    }
    if (currentTime - LastGearCraftingTime >= GearCraftingTime && IniRead(settingsFile, "GearCrafting", "GearCrafting") + 0 == 1) {
        if !(A_Min == 4 || A_Min == 9) {
            Rewardlist.Push("GearCrafting")
        }
        
    }
    if (currentTime - LastSeedCraftingTime >= SeedCraftingTime && IniRead(settingsFile, "SeedCrafting", "SeedCrafting") + 0 == 1) {
        if !(A_Min == 4 || A_Min == 9) {
            Rewardlist.Push("SeedCrafting")
        }
        
    }
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
        if (v = "Events") {
            BuyEvent()
        }
        if (v = "GearCrafting") {
            GearCraft()
            Sleep(2000)
            global LastGearCraftingTime
            LastGearCraftingTime := nowUnix()
        }
        if (v = "SeedCrafting") {
            SeedCraft()
            Sleep(2000)
            global LastSeedCraftingTime
            LastSeedCraftingTime := nowUnix()
        }
        if (v = "TravelingMerchant") {
            BuyMerchant()
        }
    }
    
    if (variable.Length > 0)
        if (Mod(A_Min,5) == 0){
            Clickbutton("Garden")
            relativeMouseMove(0.5, 0.5)
            thing := 60 - A_Sec 
            ToolTip("Seed Shop: " (r:=Mod(300 - Mod(A_Min*60 + A_Sec, 300), 300))//60 ":" Mod(r,60) 
            "`nGear Shop: " (r:=Mod(300 - Mod(A_Min*60 + A_Sec, 300), 300))//60 ":" Mod(r,60) 
            "`nEgg Shop: " (r:=Mod(1800 - Mod(A_Min*60 + A_Sec, 1800),1800))//60 ":" Mod(r,60)), 1000
            Sleep((A_sec + thing) * 1000)

        }
        return 1
}



nowUnix() {
    return DateDiff(A_NowUTC, "19700101000000", "Seconds")
}


LastGearCraftingTime := nowUnix()
LastSeedCraftingTime := nowUnix()
LastEventCraftingtime := nowUnix()

LastCookingTime := nowUnix()

FourHours(){
    UtcNow := A_NowUTC
    UtcHour := FormatTime(UtcNow, "H")
    if (Mod(UtcHour, 4) == 0 && A_min == 0) {
        return true
    } 
    return false

}


RewardChecker() {
    global LastGearCraftingTime, EventCraftingtime, LastSeedCraftingTime, LastCookingTime

    static CookingTime := Integer(IniRead(settingsFile, "Settings", "CookingTime") * 1.1)

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
    if (FourHours() && CheckSetting("Settings", "Cosmetics")) {
        Rewardlist.Push("Cosmetics")
    }
    if (FourHours() && CheckSetting("Settings", "TravelingMerchant")) {
        Rewardlist.Push("TravelingMerchant")
    }
    if (currentTime - LastGearCraftingTime >= GearCraftingTime && CheckSetting("GearCrafting", "GearCrafting")) {
        if !(A_Min == 4 || A_Min == 9) {
            Rewardlist.Push("GearCrafting")
        }
        
    }
    if (currentTime - LastSeedCraftingTime >= SeedCraftingTime && CheckSetting("SeedCrafting", "SeedCrafting")) {
        if !(A_Min == 4 || A_Min == 9) {
            Rewardlist.Push("SeedCrafting")
        }
        
    }
    ; if (currentTime - LastCookingTime >= CookingTime && CheckSetting("Settings", "CookingEvent")) {
    ;     if !(A_Min == 4 || A_Min == 9) {
    ;         Rewardlist.Push("Event")
    ;     }
    ; }
    if (currentTime - LastBeanstalkTime >= BeanstalkTime && CheckSetting("Events", "Events")) {
        if !(A_Min == 4 || A_Min == 9) {
            Rewardlist.Push("Event")
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
        if (v = "Cosmetics") {
            BuyCosmetics()
        }
        ; if (v = "Event") {
        ;     CookingEvent()
        ;     Sleep(2000)
        ;     global LastCookingTime
        ;     LastCookingTime := nowUnix()
        ; }
        if (v = "Event") {
            BuyBeanstalkEvent()
            Sleep(2000)
            global LastBeanstalkTime := nowUnix()
            LastBeanstalkTime := nowUnix()
        }
    }
    
    if (variable.Length > 0) {
        if (Mod(A_Min,5) == 0){
            thing := 60 - A_Sec 
            loop thing {
                ShowToolTip()
                Sleep(1000)
            }

        }
        Clickbutton("Garden")
        relativeMouseMove(0.5, 0.5)
        return 1
    }
}



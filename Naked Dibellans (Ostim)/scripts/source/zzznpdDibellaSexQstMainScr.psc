Scriptname zzznpdDibellaSexQstMainScr extends Quest  

Actor Property Player Auto
MiscObject Property DibellaMark Auto
MiscObject Property Gold Auto
GlobalVariable Property DibellaSexCost Auto
Perk Property DibellaAgent Auto
ImageSpaceModifier Property BlackScreen Auto
ImageSpaceModifier Property FadeOut Auto
ImageSpaceModifier Property FadeIn Auto
ImageSpaceModifier Property FastFadeOut Auto
Spell Property DibellanArt Auto
Spell Property DibellanComfort Auto
Quest Property OSexIntegrationMainQuest Auto


string SuppressTagsForNotRough = "Cowgirl,Aggressive,Rough,Forced,Bound"
string SuppressTagsForMale = "Lesbian,FF,"

Function PracticeDibellanArts(Actor akActor)
		If DibellaSexCost.GetValue() > 0
			If Player.HasPerk(DibellaAgent)
				DibellaSexCost.SetValue(0)
			Else
				Player.RemoveItem(Gold,DibellaSexCost.GetValue() as Int)
			EndIf
		EndIf
		If ostimEnabled()
			Debug.Trace("Naked Dibellans: OStim  method...")
			haveSexOS(akActor)
		Else
			Debug.Trace("Naked Dibellans: Default method...")
			haveSexSFW()
		EndIf
EndFunction


Function haveSexSFW()
		Game.DisablePlayerControls(abMovement = True, abFighting = True, abCamSwitch = False, abLooking = False, abSneaking = True, abMenu = True, abActivate = True, abJournalTabs = False, aiDisablePOVType = 0)	
		FastFadeOut.Apply()
		Utility.Wait(1.0)
		FastFadeOut.PopTo(BlackScreen)
		Utility.Wait(5.0)
		BlackScreen.PopTo(FadeIn)
		Player.Additem(DibellaMark,1)
		RestoreSpells()
		UpdateCurrentInstanceGlobal(DibellaSexCost)
		Game.EnablePlayerControls()
EndFunction


Function haveSexOS(Actor akActor)
	OSexIntegrationMain ostim = OSexIntegrationMainQuest as OSexIntegrationMain
	bool sceneStarted = False
	If Player.GetActorBase().GetSex() == 1
		sceneStarted = ostim.StartScene(akActor,  player)
	Else
		sceneStarted = ostim.StartScene(player,  akActor)
	EndIf
	If sceneStarted
		RegisterForModEvent("ostim_end", "zzzDibSex_End")
	Else
		debug.Trace("Naked Dibellans: OStim could not start the scene.")
		haveSexSFW()
	EndIf
EndFunction

Event zzzDibSex_End(string eventName, string argString, float argNum, form sender)
	Player.Additem(DibellaMark,1)
	RestoreSpells()
	UnregisterForModEvent("ostim_end")
	UpdateCurrentInstanceGlobal(DibellaSexCost)
EndEvent

Bool Function ostimEnabled()
	Return ((OSexIntegrationMainQuest As OSexIntegrationMain).Installed == True)
EndFunction

Function RestoreSpells()
	Player.RemoveSpell(DibellanComfort)
	Player.AddSpell(DibellanComfort)
	DibellanArt.Cast(Player,Player)
EndFunction
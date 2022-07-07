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
Quest Property SexLabQuestFramework Auto

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
		If sexLabEnabled()
			Debug.Trace("Naked Dibellans: SexLab method...")
			haveSexSL(akActor)
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

Function haveSexSL(Actor akActor)
	SexLabFramework SexLab =  SexLabQuestFramework As SexLabFramework
	sslBaseAnimation[] anims
	actor[] sexActors = new actor[2]
	int position = Utility.RandomInt(1, 3) 
	If Player.GetActorBase().GetSex() == 1
		sexActors[0] = Player
		sexActors[1] = akActor
		If position == 1
			anims = SexLab.GetAnimationsByTags(2, "Vaginal,MF", SuppressTagsForNotRough, RequireAll=true)
		ElseIf position == 2
			anims = SexLab.GetAnimationsByTags(2, "Anal,MF", SuppressTagsForNotRough, RequireAll=true)
		Else
			anims = SexLab.GetAnimationsByTags(2, "Lesbian,Oral", SuppressTagsForNotRough, RequireAll=true)
		EndIf
	Else
		sexActors[0] = akActor
		sexActors[1] = Player
		If position == 1
			anims = SexLab.GetAnimationsByTags(2, "Vaginal", SuppressTagsForMale+SuppressTagsForNotRough, RequireAll=true)
		ElseIf position == 2
			anims = SexLab.GetAnimationsByTags(2, "Anal", SuppressTagsForMale+SuppressTagsForNotRough, RequireAll=true)
		Else
			anims = SexLab.GetAnimationsByTags(2, "Blowjob", SuppressTagsForMale+SuppressTagsForNotRough, RequireAll=true)
		EndIf
	EndIf
	sexActors = SexLab.SortActors(sexActors, true)
	RegisterForModEvent("AnimationEnd", "zzzDibSex_End")
	SexLab.StartSex(sexActors, anims, none, none, true, "")
EndFunction

Event zzzDibSex_End(string eventName, string argString, float argNum, form sender)
	Player.Additem(DibellaMark,1)
	RestoreSpells()
	UnregisterForModEvent("AnimationEnd")
	UpdateCurrentInstanceGlobal(DibellaSexCost)
EndEvent


Bool Function sexLabEnabled()
	Return ((SexLabQuestFramework As SexLabFramework).Enabled == True)
EndFunction

Function RestoreSpells()
	Player.RemoveSpell(DibellanComfort)
	Player.AddSpell(DibellanComfort)
	DibellanArt.Cast(Player,Player)
EndFunction
Scriptname zzzNPD_UnarmedCaster extends ActiveMagicEffect

Keyword Property NakedPriestessKeyword Auto

Actor myself

Event OnEffectStart(Actor akTarget, Actor akCaster)
	;Debug.Trace("Naked Dibella Priestess: Unequiping weapons for " + akTarget)
	If akTarget
		myself = akTarget
		unequipWeapons(myself)
		RegisterForAnimationEvent(myself, "WeaponSheathe")
	EndIf
endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
endEvent

Event OnUnload()
    RemoveEffect()
EndEvent

Event OnCellDetach()
    RemoveEffect()
EndEvent

Event OnDetachedFromCell()
    RemoveEffect()
EndEvent

Event OnAnimationEvent(ObjectReference akSource, String asEventName)
	If self && myself
		If akSource == myself
			If asEventName == "WeaponSheathe"
				unequipWeapons(myself)
			;ElseIf asEventName == "WeaponDraw"
			;
			EndIf
		EndIf
	EndIf
EndEvent

Function RemoveEffect()
    If self && myself
        If myself.HasMagicEffectWithKeyword(NakedPriestessKeyword)
            Dispel()
        EndIf
    EndIf
EndFunction

Function unequipWeapons(Actor akActor)
	Weapon akRWeapon = akActor.GetEquippedWeapon(False)
	If akRWeapon
		akActor.UnEquipItem(akRWeapon, False, True)
	EndIf
	Weapon akLWeapon = akActor.GetEquippedWeapon(True)
	If akLWeapon
		akActor.UnEquipItem(akLWeapon, False, True)		
	EndIf
EndFunction
<?xml version="1.0" encoding="utf-8"?>
<savedscenario>
	<meta>
		<gameVersion>1.2.3005 rev1190</gameVersion>
		<modIds>
			<li>ludeon.rimworld</li>
		</modIds>
		<modNames>
			<li>Core</li>
		</modNames>
	</meta>
	<scenario>
		<name>Refuge Escape</name>
		<summary>Solo survival; limited supplies</summary>
		<description>With everything you could fit into your bag, you snuck onto an escape pod and finally sought refuge from the dystopian empire you resided. Alone, it is up to you to fend for yourself and to realize your survival.</description>
		<playerFaction>
			<def>PlayerFaction</def>
			<factionDef>PlayerColony</factionDef>
		</playerFaction>
		<parts>
			<li Class="ScenPart_ConfigPage_ConfigureStartingPawns">
				<def>ConfigPage_ConfigureStartingPawns</def>
				<pawnCount>1</pawnCount>
				<pawnChoiceCount>8</pawnChoiceCount>
			</li>
			<li Class="ScenPart_PlayerPawnsArriveMethod">
				<def>PlayerPawnsArriveMethod</def>
				<method>DropPods</method>
			</li>
			<li Class="ScenPart_GameStartDialog">
				<def>GameStartDialog</def>
				<text>With everything you could fit into your bag, you snuck onto an escape pod and finally sought refuge from the dystopian empire you resided. 

Alone, it is up to you to fend for yourself and to realize your survival.</text>
				<closeSound>GameStartSting</closeSound>
			</li>
			<li Class="ScenPart_StartingThing_Defined">
				<def>StartingThing_Defined</def>
				<thingDef>MealSurvivalPack</thingDef>
				<count>15</count>
			</li>
			<li Class="ScenPart_StartingThing_Defined">
				<def>StartingThing_Defined</def>
				<thingDef>MedicineIndustrial</thingDef>
				<count>5</count>
			</li>
			<li Class="ScenPart_StartingThing_Defined">
				<def>StartingThing_Defined</def>
				<thingDef>Gun_Revolver</thingDef>
			</li>
		</parts>
	</scenario>
</savedscenario>
#include <sourcemod>
#include <ccsplayer>
#include <sdktools>
#include <sdkhooks>

#pragma semicolon 1
#pragma newdecls required

#define prefix " \x0A[\x0Bx\x08G\x0A]\x01 "
#define nomoney "You don't have enough \x06money\x01!"
#define disable "The Cash Shop is currently \x07disabled\x01!"
#define SHOP_ITEM_DISABLED 0
#define SHOP_ITEM_CT_ONLY 1
#define SHOP_ITEM_T_ONLY 2
#define SHOP_ITEM_ENABLED 3 


public Plugin myinfo = {
	name = "[xG] Cash Shop",
	author = "Jadow",
	description = "Use in game money to buy things",
	version = "1.1",
	url = "https://github.com/Jadowo/CSCashShop"
}

char displayprice[128];

//Toggles
ConVar FlashbangToggle;
ConVar SmokeToggle;
ConVar DecoyToggle;
ConVar TactAwareToggle;
ConVar HEToggle;
ConVar MolotovToggle;
ConVar BreachChargeToggle;
ConVar SnowballToggle;
ConVar GlockToggle;
ConVar USPToggle;
ConVar CZ75Toggle;
ConVar DeagleToggle;
ConVar BumpyToggle;
ConVar BizonToggle;
ConVar MP9Toggle;
ConVar FamasToggle;
ConVar NegevToggle;
ConVar ScoutToggle;
ConVar HeavyArmor10Toggle;
ConVar HeavyArmor15Toggle;
ConVar HeavyArmor20Toggle;
ConVar HeavyArmor25Toggle;
ConVar HeavyArmor100Toggle;
ConVar BodyArmor10Toggle;
ConVar BodyArmor15Toggle;
ConVar BodyArmor20Toggle;
ConVar BodyArmor25Toggle;
ConVar ExoBootsToggle;
ConVar BumpMineToggle;
ConVar ShieldToggle;
ConVar TactNadesToggle;
ConVar OffNadesToggle;
ConVar HeavyArmorToggle;
ConVar BodyArmorToggle;
ConVar PistolsToggle;
ConVar CashShopToggle;
ConVar PrimaryToggle;
ConVar MiscellaneousToggle;

//Price
ConVar FlashbangPrice;
ConVar SmokePrice;
ConVar DecoyPrice;
ConVar TactAwarePrice;
ConVar HEPrice;
ConVar MolotovPrice;
ConVar BreachChargePrice;
ConVar SnowballPrice;
ConVar GlockPrice;
ConVar USPPrice;
ConVar CZ75Price;
ConVar DeaglePrice;
ConVar BumpyPrice;
ConVar BizonPrice;
ConVar MP9Price;
ConVar FamasPrice;
ConVar NegevPrice;
ConVar ScoutPrice;
ConVar HeavyArmor10Price;
ConVar HeavyArmor15Price;
ConVar HeavyArmor20Price;
ConVar HeavyArmor25Price;
ConVar HeavyArmor100Price;
ConVar BodyArmor10Price;
ConVar BodyArmor15Price;
ConVar BodyArmor20Price;
ConVar BodyArmor25Price;
ConVar ExoBootsPrice;
ConVar BumpMinePrice;
ConVar ShieldPrice;

//Ammo
ConVar GlockAmmo;
ConVar GlockReserveAmmo;
ConVar USPAmmo;
ConVar USPReserveAmmo;
ConVar CZ75Ammo;
ConVar CZ75ReserveAmmo;
ConVar DeagleAmmo;
ConVar DeagleReserveAmmo;
ConVar BumpyAmmo;
ConVar BumpyReserveAmmo;
ConVar BizonAmmo;
ConVar BizonReserveAmmo;
ConVar MP9Ammo;
ConVar MP9ReserveAmmo;
ConVar FamasAmmo;
ConVar FamasReserveAmmo;
ConVar NegevAmmo;
ConVar NegevReserveAmmo;
ConVar ScoutAmmo;
ConVar ScoutReserveAmmo;

public void OnPluginStart(){
	
	RegConsoleCmd("sm_cashshop", Command_CashShop);
	RegConsoleCmd("sm_cs", Command_CashShop);
	HookEvent("round_end", Event_RoundEnd);
	
	//Tactical Grenade
	FlashbangPrice = CreateConVar("sm_cashshop_price_flashbang", "7000", "Price of Flashbang");
	SmokePrice = CreateConVar("sm_cashshop_price_smokegrenade", "7000", "Price of Smoke Grenade");
	DecoyPrice = CreateConVar("sm_cashshop_price_decoy", "5000", "Price of Decoy Grenade");
	TactAwarePrice = CreateConVar("sm_cashshop_price_tacticalawareness", "8000", "Price of Tactical Awareness Grenade");
	SnowballPrice = CreateConVar("sm_cashshop_price_snowball", "2500", "Price of Snowball");
	//Offensive Utility 
	HEPrice = CreateConVar("sm_cashshop_price_hegrenade", "8000", "Price of HE Grenade");
	MolotovPrice = CreateConVar("sm_cashshop_price_molotov", "10000", "Price of Molotov");
	BreachChargePrice = CreateConVar("sm_cashshop_price_breachcharge", "12000", "Price of Breach Charge");
	//Primaries
	BizonPrice = CreateConVar("sm_cashshop_price_bizon", "35000", "Price of PP Bizon");
	MP9Price = CreateConVar("sm_cashshop_price_mp9", "35000", "Price of PP Bizon");
	NegevPrice = CreateConVar("sm_cashshop_price_negev", "40000", "Price of PP Bizon");
	FamasPrice = CreateConVar("sm_cashshop_price_famas", "42000", "Price of PP Bizon");
	ScoutPrice = CreateConVar("sm_cashshop_price_scout", "45000", "Price of PP Bizon");
	//Pistols
	GlockPrice = CreateConVar("sm_cashshop_price_glock", "16000", "Price of Glock");
	USPPrice = CreateConVar("sm_cashshop_price_usp", "18000", "Price of USP");
	CZ75Price = CreateConVar("sm_cashshop_price_cz75a", "19000", "Price of CZ75A");
	DeaglePrice = CreateConVar("sm_cashshop_price_deagle", "20000", "Price of Deagle");
	BumpyPrice = CreateConVar("sm_cashshop_price_revolver", "20000", "Price of Revolver");
	//Heavy Armor
	HeavyArmor10Price = CreateConVar("sm_cashshop_price_heavyarmor10", "10000", "Price of Heavy Armor +10");
	HeavyArmor15Price = CreateConVar("sm_cashshop_price_heavyarmor15", "12000", "Price of Heavy Armor +15");
	HeavyArmor20Price = CreateConVar("sm_cashshop_price_heavyarmor20", "14000", "Price of Heavy Armor +20");
	HeavyArmor25Price = CreateConVar("sm_cashshop_price_heavyarmor25", "16000", "Price of Heavy Armor +25");
	HeavyArmor100Price = CreateConVar("sm_cashshop_price_heavyarmor100", "60000", "Price of Heavy Armor +100");
	//Body Armor
	BodyArmor10Price = CreateConVar("sm_cashshop_price_armor10", "5000",  "Price of Armor +10");
	BodyArmor15Price = CreateConVar("sm_cashshop_price_armor15", "6200",  "Price of Armor +15");
	BodyArmor20Price = CreateConVar("sm_cashshop_price_armor20", "7400",  "Price of Armor +20");
	BodyArmor25Price = CreateConVar("sm_cashshop_price_armor25", "8600",  "Price of Armor +25");
	//Miscellaneous
	ExoBootsPrice = CreateConVar("sm_cashshop_price_exoboots", "20000",  "Price of Exoboots");
	BumpMinePrice = CreateConVar("sm_cashshop_price_bumpmine", "6000",  "Price of BumpMine");
	ShieldPrice = CreateConVar("sm_cashshop_price_shield", "10000",  "Price of Shield");
	
	//Tactical Grenade
	FlashbangToggle = CreateConVar("sm_cashshop_toggle_flashbang", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	SmokeToggle = CreateConVar("sm_cashshop_toggle_smoke", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	DecoyToggle = CreateConVar("sm_cashshop_toggle_decoy", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	TactAwareToggle = CreateConVar("sm_cashshop_toggle_tacticalawareness", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	SnowballToggle = CreateConVar("sm_cashshop_toggle_snowball", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	//Offensive Utility
	HEToggle = CreateConVar("sm_cashshop_toggle_hegrenade", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	MolotovToggle = CreateConVar("sm_cashshop_toggle_molotov", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	BreachChargeToggle = CreateConVar("sm_cashshop_toggle_breachcharge", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	//Primaries
	BizonToggle = CreateConVar("sm_cashshop_toggle_bizon", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	MP9Toggle = CreateConVar("sm_cashshop_toggle_mp9", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	NegevToggle = CreateConVar("sm_cashshop_toggle_negev", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	FamasToggle = CreateConVar("sm_cashshop_toggle_famas", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	ScoutToggle = CreateConVar("sm_cashshop_toggle_scout", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	//Pistols
	GlockToggle = CreateConVar("sm_cashshop_toggle_glock", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	USPToggle = CreateConVar("sm_cashshop_toggle_usp", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	CZ75Toggle = CreateConVar("sm_cashshop_toggle_cz75a", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	DeagleToggle = CreateConVar("sm_cashshop_toggle_deagle", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	BumpyToggle = CreateConVar("sm_cashshop_toggle_revolver", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	//Heavy Armor
	HeavyArmor10Toggle = CreateConVar("sm_cashshop_toggle_heavyarmor10", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	HeavyArmor15Toggle = CreateConVar("sm_cashshop_toggle_heavyarmor15", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	HeavyArmor20Toggle = CreateConVar("sm_cashshop_toggle_heavyarmor20", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	HeavyArmor25Toggle = CreateConVar("sm_cashshop_toggle_heavyarmor25", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	HeavyArmor100Toggle = CreateConVar("sm_cashshop_toggle_heavyarmor100", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	//Body Armor
	BodyArmor10Toggle = CreateConVar("sm_cashshop_toggle_armor10", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	BodyArmor15Toggle = CreateConVar("sm_cashshop_toggle_armor15", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	BodyArmor20Toggle = CreateConVar("sm_cashshop_toggle_armor20", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	BodyArmor25Toggle = CreateConVar("sm_cashshop_toggle_armor25", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	//Upgrades
	ExoBootsToggle = CreateConVar("sm_cashshop_toggle_exoboots", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	BumpMineToggle = CreateConVar("sm_cashshop_toggle_bumpmine", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	ShieldToggle = CreateConVar("sm_cashshop_toggle_shield", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	
	//Menus
	CashShopToggle = CreateConVar("sm_cashshop_toggle_all", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	PrimaryToggle = CreateConVar("sm_cashshop_toggle_primary", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	TactNadesToggle = CreateConVar("sm_cashshop_toggle_tactnades", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	OffNadesToggle = CreateConVar("sm_cashshop_toggle_offnades", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	HeavyArmorToggle = CreateConVar("sm_cashshop_toggle_armor_heavy", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	BodyArmorToggle = CreateConVar("sm_cashshop_toggle_armor_body", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	PistolsToggle = CreateConVar("sm_cashshop_toggle_pistols", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	MiscellaneousToggle = CreateConVar("sm_cashshop_toggle_upgrade", "3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	
	//Ammo
	GlockAmmo = CreateConVar("sm_cashshop_ammo_glock", "0", "Ammo In Glock Magazine", _, true, 0.0, true, 20.0);
	USPAmmo = CreateConVar("sm_cashshop_ammo_usp", "0", "Ammo In USP Magazine", _, true, 0.0, true, 12.0);
	CZ75Ammo = CreateConVar("sm_cashshop_ammo_cz75a", "0", "Ammo In CZ75 Magazine", _, true, 0.0, true, 12.0);
	DeagleAmmo = CreateConVar("sm_cashshop_ammo_deagle", "0", "Ammo In Deagle Magazine", _, true, 0.0, true, 7.0);
	BumpyAmmo = CreateConVar("sm_cashshop_ammo_revolver", "0", "Ammo In Revolver Magazine", _, true, 0.0, true, 8.0);
	BizonAmmo = CreateConVar("sm_cashshop_ammo_bizon", "0", "Ammo In Bizon Magazine", _, true, 0.0, true, 64.0);
	MP9Ammo = CreateConVar("sm_cashshop_ammo_mp5", "0", "Ammo In MP9 Magazine", _, true, 0.0, true, 30.0);
	NegevAmmo = CreateConVar("sm_cashshop_ammo_negev", "0", "Ammo In Negev Magazine", _, true, 0.0, true, 150.0);
	FamasAmmo = CreateConVar("sm_cashshop_ammo_famas", "0", "Ammo In Famas Magazine", _, true, 0.0, true, 25.0);
	ScoutAmmo = CreateConVar("sm_cashshop_ammo_scout", "0", "Ammo In Scout Magazine", _, true, 0.0, true, 10.0);
	//Reserve Ammo
	GlockReserveAmmo = CreateConVar("sm_cashshop_ammo_reserve_glock", "6", "Ammo In Glock Reserve", _, true, 0.0, true, 120.0);
	USPReserveAmmo = CreateConVar("sm_cashshop_ammo_reserve_usp", "4", "Ammo In USP Reserve", _, true, 0.0, true, 24.0);
	CZ75ReserveAmmo = CreateConVar("sm_cashshop_ammo_reserve_cz75a", "6", "Ammo In CZ75 Reserve", _, true, 0.0, true, 12.0);
	DeagleReserveAmmo = CreateConVar("sm_cashshop_ammo_reserve_deagle", "2", "Ammo In Deagle Reserve", _, true, 0.0, true, 35.0);
	BumpyReserveAmmo = CreateConVar("sm_cashshop_ammo_reserve_revolver", "2", "Ammo In Revolver Reserve", _, true, 0.0, true, 8.0);
	BizonReserveAmmo = CreateConVar("sm_cashshop_ammo_reserve_bizon", "32", "Ammo In Bizon Reserve", _, true, 0.0, true, 120.0);
	MP9ReserveAmmo = CreateConVar("sm_cashshop_ammo_reserve_mp9", "20", "Ammo In MP9 Reserve", _, true, 0.0, true, 120.0);
	NegevReserveAmmo = CreateConVar("sm_cashshop_ammo_reserve_negev", "30", "Ammo In Negev Reserve", _, true, 0.0, true, 300.0);
	FamasReserveAmmo = CreateConVar("sm_cashshop_ammo_reserve_famas", "15", "Ammo In Famas Reserve", _, true, 0.0, true, 90.0);
	ScoutReserveAmmo = CreateConVar("sm_cashshop_ammo_reserve_scout", "5", "Ammo In Scout Reserve", _, true, 0.0, true, 90.0);
	
	AutoExecConfig(true, "plugin.cashshop-jb");
}

public void OnMapStart(){
	// When setting Heavy Armor, model is changed.
	PrecacheModel("models/player/custom_player/legacy/ctm_heavy.mdl");
	PrecacheModel("models/player/custom_player/legacy/tm_phoenix_heavy.mdl");
}

public Action Event_RoundEnd(Event hEvent, const char[] sName, bool bDontBroadcast){
	// Removing Heavy Armor when round ends
	
	CCSPlayer p;
	while(CCSPlayer.Next(p)){
		if(p.InGame){
			p.HeavyArmor = false;
			SetEntProp(p.Index, Prop_Send, "m_passiveItems", 0, 1, 1);
		}
	}
}

public Action Command_CashShop(int client, int args){
	CCSPlayer p = CCSPlayer(client);
	//Check if player on CT
	if (p.Alive && CS_TEAM_CT == p.Team){
		//Check if Cash Shop is enabled
		if(CashShopToggle.IntValue == SHOP_ITEM_CT_ONLY || CashShopToggle.IntValue == SHOP_ITEM_ENABLED){
			Menu menu = new Menu(Menu_CTShop);
			menu.SetTitle("Cash Shop");
			//Check if tacical grenade is enabled
			if(TactNadesToggle.IntValue == SHOP_ITEM_CT_ONLY || TactNadesToggle.IntValue == SHOP_ITEM_ENABLED){
				menu.AddItem("tactnades", "Tactical Grenade");
			}
			//Check if primaries is enabled
			if(PrimaryToggle.IntValue == SHOP_ITEM_CT_ONLY || PrimaryToggle.IntValue == SHOP_ITEM_ENABLED){
				menu.AddItem("primary", "Primaries");
			}
			//Check if offensive utility is enabled
			if(OffNadesToggle.IntValue == SHOP_ITEM_CT_ONLY || OffNadesToggle.IntValue == SHOP_ITEM_ENABLED){
				menu.AddItem("offnade", "Offensive Utility");
			}
			//Check if heavy armor is enabled
			if(HeavyArmorToggle.IntValue == SHOP_ITEM_CT_ONLY || HeavyArmorToggle.IntValue == SHOP_ITEM_ENABLED){
				menu.AddItem("harmor", "Heavy Armor");
			}
			//Check if miscellaneous is enabled
			if(MiscellaneousToggle.IntValue == SHOP_ITEM_CT_ONLY || MiscellaneousToggle.IntValue == SHOP_ITEM_ENABLED){
				menu.AddItem("miscellaneous", "Miscellaneous");
			}
			menu.Display(client, MENU_TIME_FOREVER);
			return Plugin_Handled;
		}
		//Print if disabled
		else{
			PrintToChat(client, prefix...disable);
		}
	}
	//Check if player on T
	else if(p.Alive && CS_TEAM_T == p.Team){
		//Check if Cassh Shop is enabled
		if(CashShopToggle.IntValue >= SHOP_ITEM_T_ONLY){
			Menu menu = new Menu(Menu_TShop);
			menu.SetTitle("Cash Shop");
			//Check if tacical grenade is enabled
			if(TactNadesToggle.IntValue >= SHOP_ITEM_T_ONLY){
				menu.AddItem("tactnades", "Tactical Grenade");
			}
			//Check if primaries is enabled
			if(PrimaryToggle.IntValue >= SHOP_ITEM_T_ONLY){
				menu.AddItem("primary", "Primaries");
			}
			//Check if pistol is enabled
			if(PistolsToggle.IntValue >= SHOP_ITEM_T_ONLY){
				menu.AddItem("pistols", "Pistols");
			}
			//Check if body armor is enabled
			if(BodyArmorToggle.IntValue >= SHOP_ITEM_T_ONLY){
				menu.AddItem("barmor", "Body Armor");
			}
			//Check if miscellaneous is enabled
			if(MiscellaneousToggle.IntValue == SHOP_ITEM_CT_ONLY || MiscellaneousToggle.IntValue == SHOP_ITEM_ENABLED){
				menu.AddItem("miscellaneous", "Miscellaneous");
			}
			menu.Display(client, MENU_TIME_FOREVER);
			return Plugin_Handled;
		}
		//Print if disabled
		else{
			PrintToChat(client, prefix...disable);
		}
	}
	else{
		PrintToChat(client, prefix..."You must be alive to use the cash shop!");
	}
	return Plugin_Handled;
}

public int Menu_CTShop(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (p.Alive && action == MenuAction_Select){
		char info[32], display[64];
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		//Check if tactnades is selected
		if (StrEqual(info, "tactnades")){
			Menu tnmenu = new Menu(Menu_TactNades);
			tnmenu.SetTitle("Tactical Grenades");
			//Check if flashbang is enabled 
			if(FlashbangToggle.IntValue == SHOP_ITEM_CT_ONLY || FlashbangToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Flashbang", FlashbangPrice.IntValue);
				tnmenu.AddItem("weapon_flashbang", displayprice);
			}
			//Check if smoke grenade is enabled
			if(SmokeToggle.IntValue == SHOP_ITEM_CT_ONLY || SmokeToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Smoke Grenade", SmokePrice.IntValue);
				tnmenu.AddItem("weapon_smokegrenade", displayprice);
			}
			//Check if decoy is enabled
			if(DecoyToggle.IntValue == SHOP_ITEM_CT_ONLY || DecoyToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Decoy Grenade", DecoyPrice.IntValue);
				tnmenu.AddItem("weapon_decoy", displayprice);
			}
			//Check if tactical awareness is enabled
			if(TactAwareToggle.IntValue == SHOP_ITEM_CT_ONLY || TactAwareToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Tactical Awareness Grenade", TactAwarePrice.IntValue);
				tnmenu.AddItem("weapon_tagrenade", displayprice);
			}
			//Check if snowball is enabled
			if(SnowballToggle.IntValue == SHOP_ITEM_CT_ONLY || SnowballToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Snowball", SnowballPrice.IntValue);
				tnmenu.AddItem("weapon_snowball", displayprice);
			}
			tnmenu.Display(client, MENU_TIME_FOREVER);
		}
		//Check if primary is selected
		else if (StrEqual(info, "primary")){
			Menu pmenu = new Menu(Menu_Primary);
			pmenu.SetTitle("Primaries");
			//Check if bizon is enabled 
			if(BizonToggle.IntValue == SHOP_ITEM_CT_ONLY || BizonToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Bizon", BizonPrice.IntValue);
				pmenu.AddItem("weapon_bizon", displayprice);
			}
			//Check if mp9 is enabled
			if(MP9Toggle.IntValue == SHOP_ITEM_CT_ONLY || MP9Toggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)MP9", MP9Price.IntValue);
				pmenu.AddItem("weapon_mp9", displayprice);
			}
			//Check if negev is enabled
			if(NegevToggle.IntValue == SHOP_ITEM_CT_ONLY || NegevToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Negev", NegevPrice.IntValue);
				pmenu.AddItem("weapon_negev", displayprice);
			}
			//Check if famas is enabled
			if(FamasToggle.IntValue == SHOP_ITEM_CT_ONLY || FamasToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Famas", FamasPrice.IntValue);
				pmenu.AddItem("weapon_famas", displayprice);
			}
			//Check if scout is enabled
			if(ScoutToggle.IntValue == SHOP_ITEM_CT_ONLY || ScoutToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)SSG08", ScoutPrice.IntValue);
				pmenu.AddItem("weapon_ssg08", displayprice);
			}
			pmenu.Display(client, MENU_TIME_FOREVER);
		}
		//Check if offnade is selected
		else if (StrEqual(info, "offnade")){
			Menu onmenu = new Menu(Menu_OffNades);
			menu.SetTitle("Offensive Utility");
			//Check if hegrenade is enabled
			if(HEToggle.IntValue == SHOP_ITEM_CT_ONLY || HEToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)HE Grenade", HEPrice.IntValue);
				onmenu.AddItem("weapon_hegrenade", displayprice);
			}
			//Check if molotov is enabled 
			if(MolotovToggle.IntValue == SHOP_ITEM_CT_ONLY || MolotovToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Molotov", MolotovPrice.IntValue);
				onmenu.AddItem("weapon_molotov", displayprice);
			}
			//Check if breach charge is enabled
			if(BreachChargeToggle.IntValue == SHOP_ITEM_CT_ONLY || BreachChargeToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Breach Charge", BreachChargePrice.IntValue);
				onmenu.AddItem("weapon_breachcharge", displayprice);
			}
			onmenu.Display(client, MENU_TIME_FOREVER);
		}
		//Check if harmor is selected
		else if (StrEqual(info, "harmor")){
			Menu hamenu = new Menu(Menu_HeavyArmor);
			hamenu.SetTitle("Heavy Armor");
			//Check if heavyarmor10 is enabled
			if(HeavyArmor10Toggle.IntValue == SHOP_ITEM_CT_ONLY || HeavyArmor10Toggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Add 10 Heavy Armor", HeavyArmor10Price.IntValue);
				hamenu.AddItem("ha10", displayprice);
			}
			if(HeavyArmor15Toggle.IntValue == SHOP_ITEM_CT_ONLY || HeavyArmor15Toggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Add 15 Heavy Armor", HeavyArmor15Price.IntValue);
				hamenu.AddItem("ha15", displayprice);
			}
			if(HeavyArmor20Toggle.IntValue == SHOP_ITEM_CT_ONLY || HeavyArmor20Toggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Add 20 Heavy Armor", HeavyArmor20Price.IntValue);
				hamenu.AddItem("ha20", displayprice);
			}
			if(HeavyArmor25Toggle.IntValue == SHOP_ITEM_CT_ONLY || HeavyArmor25Toggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Add 25 Heavy Armor", HeavyArmor25Price.IntValue);
				hamenu.AddItem("ha25", displayprice);
			}
			if(HeavyArmor100Toggle.IntValue == SHOP_ITEM_CT_ONLY || HeavyArmor100Toggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Add 100 Heavy Armor", HeavyArmor100Price.IntValue);
				hamenu.AddItem("ha100", displayprice);
			}
			hamenu.Display(client, MENU_TIME_FOREVER);
		}
		//check if upgrade is selected
		else if (StrEqual(info, "miscellaneous")){
			Menu upmenu = new Menu(Menu_Miscellaneous);
			upmenu.SetTitle("Miscellaneous");
			//Check if ExoBoots is enabled
			if(ExoBootsToggle.IntValue == SHOP_ITEM_CT_ONLY || ExoBootsToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)ExoBoots", ExoBootsPrice.IntValue);
				upmenu.AddItem("exoboots", displayprice);
			}
			//Check if BumpMine is enabled
			if(BumpMineToggle.IntValue == SHOP_ITEM_CT_ONLY || BumpMineToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Bump Mine", BumpMinePrice.IntValue);
				upmenu.AddItem("bumpmine", displayprice);
			}
			//Check if Shield is enabled
			if(ShieldToggle.IntValue == SHOP_ITEM_CT_ONLY || ShieldToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Shield", ShieldPrice.IntValue);
				upmenu.AddItem("shield", displayprice);
			}
		}
	}
	else if (p.Alive && action == MenuAction_End){
		delete menu;
	}
	else if (!p.Alive){
		PrintToChat(client, prefix..."You must be alive to use the cash shop!");
	}
}

public int Menu_TShop(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (p.Alive && action == MenuAction_Select){
		char info[32], display[64];
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		//Check if tactnades is selected
		if (StrEqual(info, "tactnades")){
			Menu tamenu = new Menu(Menu_TactNades);
			menu.SetTitle("Tactical Grenades");
			//Check if flashbang is enabled
			if(FlashbangToggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)Flashbang", FlashbangPrice.IntValue);
				tamenu.AddItem("weapon_flashbang", displayprice);
			}
			//Check if smokegrenade is enabled
			if(SmokeToggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)Smoke Grenade", SmokePrice.IntValue);
				tamenu.AddItem("weapon_smokegrenade", displayprice);
			}
			//Check if decoy is enabled
			if(DecoyToggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)Decoy Grenade", DecoyPrice.IntValue);
				tamenu.AddItem("weapon_decoy", displayprice);
			}
			//Check if tactical awareness is enabled
			if(TactAwareToggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)Tactical Awareness Grenade", TactAwarePrice.IntValue);
				tamenu.AddItem("weapon_tagrenade", displayprice);
			}
			//Check if snowball is enabled
			if(SnowballToggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)Snowball", SnowballPrice.IntValue);
				tamenu.AddItem("weapon_snowball", displayprice);
			}
			tamenu.Display(client, MENU_TIME_FOREVER);
		}
		//Check if primary is selected
		else if (StrEqual(info, "primary")){
			Menu pmenu = new Menu(Menu_Primary);
			menu.SetTitle("Primaries");
			//Check if bizon is enabled 
			if(BizonToggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)Bizon", BizonPrice.IntValue);
				pmenu.AddItem("weapon_bizon", displayprice);
			}
			//Check if mp9 is enabled
			if(MP9Toggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)MP9", MP9Price.IntValue);
				pmenu.AddItem("weapon_mp9", displayprice);
			}
			//Check if negev is enabled
			if(NegevToggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)Negev", NegevPrice.IntValue);
				pmenu.AddItem("weapon_negev", displayprice);
			}
			//Check if famas is enabled
			if(FamasToggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)Famas", FamasPrice.IntValue);
				pmenu.AddItem("weapon_famas", displayprice);
			}
			//Check if scout is enabled
			if(ScoutToggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)SSG08", ScoutPrice.IntValue);
				pmenu.AddItem("weapon_ssg08", displayprice);
			}
			pmenu.Display(client, MENU_TIME_FOREVER);
		}
		//Check if bodyarmor is selected
		else if (StrEqual(info, "barmor")){
			Menu bamenu = new Menu(Menu_BodyArmor);
			menu.SetTitle("Armor");
			//Check if bodyarmor is enabled
			if(BodyArmor10Toggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)Add 10 Body Amor", BodyArmor10Price.IntValue);
				bamenu.AddItem("ba10", displayprice);
			}
			if(BodyArmor15Toggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)Add 15 Body Amor", BodyArmor15Price.IntValue);
				bamenu.AddItem("ba15", displayprice);
			}
			if(BodyArmor20Toggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)Add 20 Body Amor", BodyArmor20Price.IntValue);
				bamenu.AddItem("ba20", displayprice);
			}
			if(BodyArmor25Toggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)Add 25 Body Amor", BodyArmor25Price.IntValue);
				bamenu.AddItem("ba25", displayprice);
			}
			bamenu.Display(client, MENU_TIME_FOREVER);
		}
		//Check if pistols is selected
		else if(StrEqual(info, "pistols")){
			Menu pmenu = new Menu(Menu_Pistols);
			pmenu.SetTitle("Pistols");
			//Check if glock is enabled
			if(GlockToggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)Glock", GlockPrice.IntValue);
				pmenu.AddItem("weapon_glock", displayprice);
			}
			if(USPToggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)USP", USPPrice.IntValue);
				pmenu.AddItem("weapon_usp", displayprice);
			}
			//Check if cz75 is enabled
			if(CZ75Toggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)CZ75A", CZ75Price.IntValue);
				pmenu.AddItem("weapon_cz75a", displayprice);
			}
			//Check if deagle is enabled
			if(DeagleToggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)Deagle", DeaglePrice.IntValue);
				pmenu.AddItem("weapon_deagle", displayprice);
			}
			//Check if revolver is enabled
			if(BumpyToggle.IntValue >= SHOP_ITEM_T_ONLY){
				Format(displayprice, sizeof(displayprice), "($%d)BumpyBumpy", BumpyPrice.IntValue);
				pmenu.AddItem("weapon_revolver", displayprice);
			}
			pmenu.Display(client, MENU_TIME_FOREVER);
		}
		//check if upgrade is selected
		else if (StrEqual(info, "miscellaneous")){
			Menu upmenu = new Menu(Menu_Miscellaneous);
			upmenu.SetTitle("Miscellaneous");
			//Check if ExoBoots is enabled
			if(ExoBootsToggle.IntValue == SHOP_ITEM_CT_ONLY || ExoBootsToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)ExoBoots", ExoBootsPrice.IntValue);
				upmenu.AddItem("exoboots", displayprice);
			}
			//Check if BumpMine is enabled
			if(BumpMineToggle.IntValue == SHOP_ITEM_CT_ONLY || BumpMineToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Bump Mine", BumpMinePrice.IntValue);
				upmenu.AddItem("bumpmine", displayprice);
			}
			//Check if Shield is enabled
			if(ShieldToggle.IntValue == SHOP_ITEM_CT_ONLY || ShieldToggle.IntValue == SHOP_ITEM_ENABLED){
				Format(displayprice, sizeof(displayprice), "($%d)Shield", ShieldPrice.IntValue);
				upmenu.AddItem("shield", displayprice);
			}
		}
	}
	else if (p.Alive && action == MenuAction_End){
		delete menu;
	}
	else if (!p.Alive){
		PrintToChat(client, prefix..."You must be alive to use the cash shop!");
	}
}

public int Menu_TactNades(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (p.Alive && action == MenuAction_Select){
		char info[32], display[64];
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		//Check if flashbang is selected
		if (StrEqual(info, "weapon_flashbang")){
		//Check if player has enough money
			if(p.Money >= FlashbangPrice.IntValue){
				p.Money -= FlashbangPrice.IntValue;
				GivePlayerWeapon(p, "weapon_flashbang");
				PrintToChat(client, prefix ... "You bought a \x0BFlashbang \x01for \x06$%d\x01!", FlashbangPrice.IntValue);
			}
			//Print if player does not have enough money
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		//Check if smokegrenade is selected
		else if (StrEqual(info, "weapon_smokegrenade")){
			if(p.Money >= SmokePrice.IntValue){
				p.Money -= SmokePrice.IntValue;
				GivePlayerWeapon(p, "weapon_smokegrenade");
				PrintToChat(client, prefix ... "You bought a \x0BSmoke Grenade \x01for \x06$%d\x01!", SmokePrice.IntValue);
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		//Check if decoy is selected
		else if (StrEqual(info, "weapon_decoy")){
			if(p.Money >= DecoyPrice.IntValue){
				p.Money -= DecoyPrice.IntValue;
				GivePlayerWeapon(p, "weapon_decoy");
				PrintToChat(client, prefix ... "You bought a \x0BDecoy Grenade \x01for \x06$%d\x01!", DecoyPrice.IntValue);
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		//Check if tagrenade is selected
		else if (StrEqual(info, "weapon_tagrenade")){
			if(p.Money >= TactAwarePrice.IntValue){
				p.Money -= TactAwarePrice.IntValue;
				GivePlayerWeapon(p, "weapon_tagrenade");
				PrintToChat(client, prefix ... "You bought a \x0BTactical Awareness Grenade \x01for \x06$%d\x01!", TactAwarePrice.IntValue);
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		//Check if snowball is selected
		else if (StrEqual(info, "weapon_snowball")){
			if(p.Money >= SnowballPrice.IntValue){
				p.Money -= SnowballPrice.IntValue;
				GivePlayerWeapon(p, "weapon_snowball");
				PrintToChat(client, prefix ... "You bought a \x0BSnowball \x01for \x06$%d\x01!", SnowballPrice.IntValue);
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
	}
	else if (p.Alive && action == MenuAction_End){
		delete menu;
	}
	else if (!p.Alive){
		PrintToChat(client, prefix..."You must be alive to use the cash shop!");
	}
}

public int Menu_OffNades(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (p.Alive && action == MenuAction_Select){
		char info[32], display[64];
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		//Check if hegrenade is selected
		if (StrEqual(info, "weapon_hegrenade")){
			//Check if player has enough money
			if(p.Money >= HEPrice.IntValue){
				p.Money -= HEPrice.IntValue;
				GivePlayerWeapon(p, "weapon_hegrenade");
				PrintToChat(client, prefix ... "You bought a \x07HE Grenade \x01for \x06$%d\x01!", HEPrice.IntValue);
			}
			//Print if player doesn't have enough money
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		//Check if decoy is selected
		else if (StrEqual(info, "weapon_molotov")){
			if(p.Money >= MolotovPrice.IntValue){
				p.Money -= MolotovPrice.IntValue;
				GivePlayerWeapon(p, "weapon_molotov");
				PrintToChat(client, prefix ... "You bought a \x07Molotov \x01for \x06$%d\x01!", MolotovPrice.IntValue);
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		//Check if breachcharge is selected
		else if (StrEqual(info, "weapon_breachcharge")){
			if(p.Money >= BreachChargePrice.IntValue){
				p.Money -= BreachChargePrice.IntValue;
				CWeapon bcwep = GivePlayerWeapon(p, "weapon_breachcharge");
				bcwep.Ammo = 1;
				PrintToChat(client, prefix ... "You bought a \x07Breach Charge \x01for \x06$%d\x01!", BreachChargePrice.IntValue);
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
	}
	else if (p.Alive && action == MenuAction_End){
		delete menu;
	}
	else if (!p.Alive){
		PrintToChat(client, prefix..."You must be alive to use the cash shop!");
	}
}

public int Menu_HeavyArmor(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (p.Alive && action == MenuAction_Select){
		char info[32], display[64];
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		//Check if heavyarmor is selected
		if (StrEqual(info, "ha10")){
			//Check if player has enough money
			if(p.Money >= HeavyArmor10Price.IntValue){
				p.Money -= HeavyArmor10Price.IntValue;
				//Add save hand and player model
				char sModel[PLATFORM_MAX_PATH];
				char sHand[PLATFORM_MAX_PATH];
				p.GetPropString(Prop_Send, "m_szArmsModel", sHand, sizeof(sHand));
				p.GetModel(sModel, sizeof(sModel));
				p.Armor = 10;
				p.Helmet = true;
				p.HeavyArmor = true;
				//set hand and player model
				p.SetModel(sModel);
				p.SetPropString(Prop_Send, "m_szArmsModel", sHand);
				PrintToChat(client, prefix ... "You bought \x0B10 Heavy Armor \x01for \x06$%d\x01!", HeavyArmor10Price.IntValue);
			}
			//Print if player doesn't have enough money
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "ha15")){
			if(p.Money >= HeavyArmor15Price.IntValue){
				p.Money -= HeavyArmor15Price.IntValue;
				char sModel[PLATFORM_MAX_PATH];
				char sHand[PLATFORM_MAX_PATH];
				p.GetPropString(Prop_Send, "m_szArmsModel", sHand, sizeof(sHand));
				p.GetModel(sModel, sizeof(sModel));
				p.Armor = 15;
				p.Helmet = true;
				p.HeavyArmor = true;
				p.SetModel(sModel);
				p.SetPropString(Prop_Send, "m_szArmsModel", sHand);
				PrintToChat(client, prefix ... "You bought \x0B15 Heavy Armor \x01for \x06$%d\x01!", HeavyArmor15Price.IntValue);
			}
				else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "ha20")){
			if(p.Money >= HeavyArmor20Price.IntValue){
				p.Money -= HeavyArmor20Price.IntValue;
				char sModel[PLATFORM_MAX_PATH];
				char sHand[PLATFORM_MAX_PATH];
				p.GetPropString(Prop_Send, "m_szArmsModel", sHand, sizeof(sHand));
				p.GetModel(sModel, sizeof(sModel));
				p.Armor = 20;
				p.Helmet = true;
				p.HeavyArmor = true;
				p.SetModel(sModel);
				p.SetPropString(Prop_Send, "m_szArmsModel", sHand);
				PrintToChat(client, prefix ... "You bought \x0B20 Heavy Armor \x01for \x06$%d\x01!", HeavyArmor20Price.IntValue);
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "ha25")){
			if(p.Money >= HeavyArmor25Price.IntValue){
				p.Money -= HeavyArmor25Price.IntValue;
				char sModel[PLATFORM_MAX_PATH];
				char sHand[PLATFORM_MAX_PATH];
				p.GetPropString(Prop_Send, "m_szArmsModel", sHand, sizeof(sHand));
				p.GetModel(sModel, sizeof(sModel));
				p.Armor = 25;
				p.Helmet = true;
				p.HeavyArmor = true;
				p.SetModel(sModel);
				p.SetPropString(Prop_Send, "m_szArmsModel", sHand);
				PrintToChat(client, prefix ... "You bought \x0B25 Heavy Armor \x01for \x06$%d\x01!", HeavyArmor25Price.IntValue);
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "ha100")){
			if(p.Money >= HeavyArmor100Price.IntValue){
				p.Money -= HeavyArmor100Price.IntValue;
				char sModel[PLATFORM_MAX_PATH];
				char sHand[PLATFORM_MAX_PATH];
				p.GetPropString(Prop_Send, "m_szArmsModel", sHand, sizeof(sHand));
				p.GetModel(sModel, sizeof(sModel));
				p.Armor = 100;
				p.Helmet = true;
				p.HeavyArmor = true;
				p.SetModel(sModel);
				p.SetPropString(Prop_Send, "m_szArmsModel", sHand);
				PrintToChat(client, prefix ... "You bought \x0B100 Heavy Armor \x01for \x06$%d\x01!", HeavyArmor100Price.IntValue);
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
	}
	else if (p.Alive && action == MenuAction_End){
		delete menu;
	}
	else if (!p.Alive){
		PrintToChat(client, prefix..."You must be alive to use the cash shop!");
	}
}

public int Menu_BodyArmor(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (p.Alive && action == MenuAction_Select){
		char info[32], display[64];
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		//Check if bodyarmor is selected
		if (StrEqual(info, "ba10")){
			//Check if player has enough money
			if(p.Money >= BodyArmor10Price.IntValue){
				p.Money -= BodyArmor10Price.IntValue;
				p.Armor += 10;
				p.Helmet = false;
				p.HeavyArmor = false;
				PrintToChat(client, prefix ... "You bought \x0B10 Body Armor \x01for \x06$%d\x01!", BodyArmor10Price.IntValue);
			}
			//Print if player doens't have enough money
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "ba15")){
			if(p.Money >= BodyArmor15Price.IntValue){
				p.Money -= BodyArmor15Price.IntValue;
				p.Armor += 15;
				p.Helmet = false;
				p.HeavyArmor = false;
				PrintToChat(client, prefix ... "You bought \x0B15 Body Armor \x01for \x06$%d\x01!", BodyArmor15Price.IntValue);
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "ba20")){
			if(p.Money >= BodyArmor20Price.IntValue){
				p.Money -= BodyArmor20Price.IntValue;
				p.Armor += 20;
				p.Helmet = false;
				p.HeavyArmor = false;
				PrintToChat(client, prefix ... "You bought \x0B20 Body Armor \x01for \x06$%d\x01!", BodyArmor20Price.IntValue);
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "ba25")){
			if(p.Money >= BodyArmor25Price.IntValue){
				p.Money -= BodyArmor25Price.IntValue;
				p.Armor += 25;
				p.Helmet = false;
				p.HeavyArmor = false;
				PrintToChat(client, prefix ... "You bought \x0B25 Body Armor \x01for \x06$%d\x01!", BodyArmor25Price.IntValue);
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
	}
	else if (p.Alive && action == MenuAction_End){
		delete menu;
	}
	else if (!p.Alive){
		PrintToChat(client, prefix..."You must be alive to use the cash shop!");
	}
}

public int Menu_Pistols(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (p.Alive && action == MenuAction_Select){
		char info[32], display[64];
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		//Check if player's secondary slot is empty
		if(p.GetWeapon(CS_SLOT_SECONDARY).IsNull){
			//Check if glock is selected
			if (StrEqual(info, "weapon_glock")){
				//Check if player has enough money
				if(p.Money >= GlockPrice.IntValue){
					p.Money -= GlockPrice.IntValue;
					CWeapon gkwep = GivePlayerWeapon(p, "weapon_glock");
					gkwep.Ammo = GlockAmmo.IntValue;
					gkwep.ReserveAmmo = GlockReserveAmmo.IntValue;
					PrintToChat(client, prefix ... "You bought a \x07Glock \x01for \x06$%d\x01!", GlockPrice.IntValue);
				}
				//Print if player doesn't have enough money
				else{
					PrintToChat(client, prefix ... nomoney);
				}
			}
			//Check if usp is selected
			else if (StrEqual(info, "weapon_usp")){
				//Check if player has enough money
				if(p.Money >= USPPrice.IntValue){
					p.Money -= USPPrice.IntValue;
					CWeapon uspwep = GivePlayerWeapon(p, "weapon_usp_silencer");
					uspwep.Ammo = USPAmmo.IntValue;
					uspwep.ReserveAmmo = USPReserveAmmo.IntValue;
					PrintToChat(client, prefix ... "You bought a \x07USP \x01for \x06$%d\x01!", USPPrice.IntValue);
				}
				//Print if player doesn't have enough money
				else{
					PrintToChat(client, prefix ... nomoney);
				}
			}
			//Check if cz75a is selected
			else if (StrEqual(info, "weapon_cz75a")){
				if(p.Money >= CZ75Price.IntValue){
					p.Money -= CZ75Price.IntValue;
					CWeapon czwep = GivePlayerWeapon(p, "weapon_cz75a");
					czwep.Ammo = CZ75Ammo.IntValue;
					czwep.ReserveAmmo = CZ75ReserveAmmo.IntValue;
					PrintToChat(client, prefix ... "You bought a \x07CZ75A \x01for \x06$%d\x01!", CZ75Price.IntValue);
				}
				else{
					PrintToChat(client, prefix ... nomoney);
				}
			}
			//Check if deagle is selected
			else if (StrEqual(info, "weapon_deagle")){
				if(p.Money >= DeaglePrice.IntValue){
					p.Money -= DeaglePrice.IntValue;
					CWeapon dgwep = GivePlayerWeapon(p, "weapon_deagle");
					dgwep.Ammo = DeagleAmmo.IntValue;
					dgwep.ReserveAmmo = DeagleReserveAmmo.IntValue;
					PrintToChat(client, prefix ... "You bought a \x07Deagle \x01for \x06$%d\x01!", DeaglePrice.IntValue);
				}
				else{
					PrintToChat(client, prefix ... nomoney);
				}
			}
			//Check if bumpy is selected
			else if (StrEqual(info, "weapon_revolver")){
				if(p.Money >= BumpyPrice.IntValue){
					p.Money -= BumpyPrice.IntValue;
					CWeapon r8wep = GivePlayerWeapon(p, "weapon_revolver");
					r8wep.Ammo = BumpyAmmo.IntValue;
					r8wep.ReserveAmmo = BumpyReserveAmmo.IntValue;
					PrintToChat(client, prefix ... "You bought a \x07Revolver \x01for \x06$%d\x01!", BumpyPrice.IntValue);
					PrintToConsole(client, "bumpy bumpy");
				}
				else{
					PrintToChat(client, prefix ... nomoney);
				}
			}
		}
		//Print if player already has a secondary
		else{
			PrintToChat(client, prefix ... "You already have a \x07secondary\x01!");
		}
	}
	else if (p.Alive && action == MenuAction_End){
		delete menu;
	}
	else if (!p.Alive){
		PrintToChat(client, prefix..."You must be alive to use the cash shop!");
	}
}

public int Menu_Primary(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (p.Alive && action == MenuAction_Select){
		char info[32], display[64];
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		//Check if player's primary slot is empty
		if(p.GetWeapon(CS_SLOT_PRIMARY).IsNull){
			//Check if bizon is selected
			if (StrEqual(info, "weapon_bizon")){
				//Check if player has enough money
				if(p.Money >= BizonPrice.IntValue){
					p.Money -= BizonPrice.IntValue;
					CWeapon ppwep = GivePlayerWeapon(p, "weapon_bizon");
					ppwep.Ammo = BizonAmmo.IntValue;
					ppwep.ReserveAmmo = BizonReserveAmmo.IntValue;
					PrintToChat(client, prefix ... "You bought a \x07Bizon \x01for \x06$%d\x01!", BizonPrice.IntValue);
				}
				//Print if player doesn't have enough money
				else{
					PrintToChat(client, prefix ... nomoney);
				}
			}
			//Check if mp9 is selected
			else if (StrEqual(info, "weapon_mp9")){
				//Check if player has enough money
				if(p.Money >= MP9Price.IntValue){
					p.Money -= MP9Price.IntValue;
					CWeapon mp9wep = GivePlayerWeapon(p, "weapon_mp9");
					mp9wep.Ammo = MP9Ammo.IntValue;
					mp9wep.ReserveAmmo = MP9ReserveAmmo.IntValue;
					PrintToChat(client, prefix ... "You bought a \x07MP9 \x01for \x06$%d\x01!", MP9Price.IntValue);
				}
				//Print if player doesn't have enough money
				else{
					PrintToChat(client, prefix ... nomoney);
				}
			}
			//Check if negev is selected
			else if (StrEqual(info, "weapon_negev")){
				if(p.Money >= NegevPrice.IntValue){
					p.Money -= NegevPrice.IntValue;
					CWeapon negevwep = GivePlayerWeapon(p, "weapon_negev");
					negevwep.Ammo = NegevAmmo.IntValue;
					negevwep.ReserveAmmo = NegevReserveAmmo.IntValue;
					PrintToChat(client, prefix ... "You bought a \x07Negev \x01for \x06$%d\x01!", NegevPrice.IntValue);
				}
				else{
					PrintToChat(client, prefix ... nomoney);
				}
			}
			//Check if famas is selected
			else if (StrEqual(info, "weapon_famas")){
				if(p.Money >= FamasPrice.IntValue){
					p.Money -= FamasPrice.IntValue;
					CWeapon famaswep = GivePlayerWeapon(p, "weapon_famas");
					famaswep.Ammo = FamasAmmo.IntValue;
					famaswep.ReserveAmmo = FamasReserveAmmo.IntValue;
					PrintToChat(client, prefix ... "You bought a \x07Famas \x01for \x06$%d\x01!", FamasPrice.IntValue);
				}
				else{
					PrintToChat(client, prefix ... nomoney);
				}
			}
			//Check if scout is selected
			else if (StrEqual(info, "weapon_ssg08")){
				if(p.Money >= ScoutPrice.IntValue){
					p.Money -= ScoutPrice.IntValue;
					CWeapon scoutwep = GivePlayerWeapon(p, "weapon_ssg08");
					scoutwep.Ammo = ScoutAmmo.IntValue;
					scoutwep.ReserveAmmo = ScoutReserveAmmo.IntValue;
					PrintToChat(client, prefix ... "You bought a \x07SSG08 \x01for \x06$%d\x01!", ScoutPrice.IntValue);
				}
				else{
					PrintToChat(client, prefix ... nomoney);
				}
			}
		}
		//Print if player already has a primary
		else{
				PrintToChat(client, prefix ... "You already have a \x07primary\x01!");
		}
	}
	else if (p.Alive && action == MenuAction_End){
		delete menu;
	}
	else if (!p.Alive){
		PrintToChat(client, prefix..."You must be alive to use the cash shop!");
	}
}

public int Menu_Miscellaneous(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (p.Alive && action == MenuAction_Select){
		char info[32], display[64];
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		if (StrEqual(info, "exoboots")){
			//Check if player has enough money
			if(p.Money >= ExoBootsPrice.IntValue){
				p.Money -= ExoBootsPrice.IntValue;
				SetEntProp(client, Prop_Send, "m_passiveItems", 1, 1, 1);
				PrintToChat(client, prefix ... "You bought \x07 ExoBoots \x01for \x06$%d\x01!", ExoBootsPrice.IntValue);
			}
			//Print if player doesn't have enough money
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "bumpmine")){
			//Check if player has enough money
			if(p.Money >= BumpMinePrice.IntValue){
				p.Money -= BumpMinePrice.IntValue;
				GivePlayerWeapon(p, "weapon_bumpmine");
				PrintToChat(client, prefix ... "You bought 3 \x07Bump Mines \x01for \x06$%d\x01!", BumpMinePrice.IntValue);
			}
			//Print if player doesn't have enough money
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "shield")){
			//Check if player has enough money
			if(p.Money >= ShieldPrice.IntValue){
				p.Money -= ShieldPrice.IntValue;
				GivePlayerWeapon(p, "weapon_shield");
				PrintToChat(client, prefix ... "You bought a \x07Shield \x01for \x06$%d\x01!", ShieldPrice.IntValue);
			}
			//Print if player doesn't have enough money
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
	}
	else if (p.Alive && action == MenuAction_End){
		delete menu;
	}
	else if (!p.Alive){
		PrintToChat(client, prefix..."You must be alive to use the cash shop!");
	}
}
#include <sourcemod>
#include <ccsplayer>
#include <sdktools>
#include <sdkhooks>

#pragma semicolon 1
#pragma newdecls required

#define NOMONEY "You don't have enough \x06money\x01!"
#define DISABLE "The Cash Shop is currently \x07disabled\x01!"
#define ALIVE "You must be \x07alive \x01to use the cash shop!"
#define XG_PREFIX_CHAT " \x0A[\x0Bx\x08G\x0A]\x01 "
#define XG_PREFIX_CHAT_WARN " \x07[\x0Bx\x08G\x07]\x01 "
enum ShopItemStatus{
	SHOP_ITEM_CT_ONLY = 1,
	SHOP_ITEM_T_ONLY,
	SHOP_ITEM_ENABLED
};

public Plugin myinfo = {
	name = "[xG] Cash Shop",
	author = "Jadow",
	description = "Use in game money to buy things",
	version = "1.1",
	url = "https://github.com/Jadowo/CSCashShop"
}
char displayprice[128];

//Toggles
//Tactical Grenade
ConVar FlashbangToggle;
ConVar SmokeToggle;
ConVar DecoyToggle;
ConVar TactAwareToggle;
//Offensive Utility 
ConVar HEToggle;
ConVar MolotovToggle;
ConVar BreachChargeToggle;
ConVar SnowballToggle;
//Primaries
ConVar BizonToggle;
ConVar MP9Toggle;
ConVar FamasToggle;
ConVar NegevToggle;
ConVar ScoutToggle;
//Pistols
ConVar GlockToggle;
ConVar USPToggle;
ConVar CZ75Toggle;
ConVar DeagleToggle;
ConVar BumpyToggle;
//Heavy Armor
ConVar HeavyArmor10Toggle;
ConVar HeavyArmor15Toggle;
ConVar HeavyArmor20Toggle;
ConVar HeavyArmor25Toggle;
ConVar HeavyArmor100Toggle;
//Body Armor
ConVar BodyArmor10Toggle;
ConVar BodyArmor15Toggle;
ConVar BodyArmor20Toggle;
ConVar BodyArmor25Toggle;
//Miscellaneous
ConVar ExoBootsToggle;
ConVar BumpMineToggle;
ConVar ShieldToggle;
//Menu
ConVar CashShopToggle;
ConVar TactNadesToggle;
ConVar OffNadesToggle;
ConVar PrimaryToggle;
ConVar PistolsToggle;
ConVar HeavyArmorToggle;
ConVar BodyArmorToggle;
ConVar MiscellaneousToggle;

//Prices
//Tactical Grenade
ConVar FlashbangPrice;
ConVar SmokePrice;
ConVar DecoyPrice;
ConVar TactAwarePrice;
//Offensive Utility 
ConVar HEPrice;
ConVar MolotovPrice;
ConVar BreachChargePrice;
ConVar SnowballPrice;
//Primaries
ConVar BizonPrice;
ConVar MP9Price;
ConVar FamasPrice;
ConVar NegevPrice;
ConVar ScoutPrice;
//Pistols
ConVar GlockPrice;
ConVar USPPrice;
ConVar CZ75Price;
ConVar DeaglePrice;
ConVar BumpyPrice;
//Heavy Armor
ConVar HeavyArmor10Price;
ConVar HeavyArmor15Price;
ConVar HeavyArmor20Price;
ConVar HeavyArmor25Price;
ConVar HeavyArmor100Price;
//Body Armor
ConVar BodyArmor10Price;
ConVar BodyArmor15Price;
ConVar BodyArmor20Price;
ConVar BodyArmor25Price;
//Miscellaneous
ConVar ExoBootsPrice;
ConVar BumpMinePrice;
ConVar ShieldPrice;

//Ammo & Reserve
//Primaries
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
//Pistols
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

public void OnPluginStart(){
	
	RegConsoleCmd("sm_cashshop", Command_CashShop);
	RegConsoleCmd("sm_cs", Command_CashShop);
	HookEvent("round_end", Event_RoundEnd);
	
	//Price
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
	
	//Toggle
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
	CCSPlayer p;
	while(CCSPlayer.Next(p)){
		if(p.InGame){
			p.HeavyArmor = false;
			//Removes ExoBoots
			SetEntProp(p.Index, Prop_Send, "m_passiveItems", 0, 1, 1);
		}
	}
}

public Action Command_CashShop(int client, int args){
	CCSPlayer p = CCSPlayer(client);
	if(p.Alive){
		if (CS_TEAM_CT == p.Team){
			if(CashShopToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || CashShopToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
				Menu menu = new Menu(Menu_CTShop);
				menu.SetTitle("Cash Shop");
				if(TactNadesToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || TactNadesToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					menu.AddItem("tactnades", "Tactical Grenade");
				}
				if(PrimaryToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || PrimaryToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					menu.AddItem("primary", "Primaries");
				}
				if(OffNadesToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || OffNadesToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					menu.AddItem("offnade", "Offensive Utility");
				}
				if(HeavyArmorToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || HeavyArmorToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					menu.AddItem("harmor", "Heavy Armor");
				}
				if(MiscellaneousToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || MiscellaneousToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					menu.AddItem("miscellaneous", "Miscellaneous");
				}
				menu.Display(client, MENU_TIME_FOREVER);
				return Plugin_Handled;
			}
			else{
				PrintToChat(client, XG_PREFIX_CHAT_WARN...DISABLE);
			}
		}
		else if(CS_TEAM_T == p.Team){
			if(CashShopToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
				Menu menu = new Menu(Menu_TShop);
				menu.SetTitle("Cash Shop");
				if(TactNadesToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					menu.AddItem("tactnades", "Tactical Grenade");
				}
				if(PrimaryToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					menu.AddItem("primary", "Primaries");
				}
				if(PistolsToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					menu.AddItem("pistols", "Pistols");
				}
				if(BodyArmorToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					menu.AddItem("barmor", "Body Armor");
				}
				if(MiscellaneousToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || MiscellaneousToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					menu.AddItem("miscellaneous", "Miscellaneous");
				}
				menu.Display(client, MENU_TIME_FOREVER);
				return Plugin_Handled;
			}
			else{
				PrintToChat(client, XG_PREFIX_CHAT_WARN...DISABLE);
			}
		}
	}
	else{
		PrintToChat(client, XG_PREFIX_CHAT_WARN...ALIVE);
	}
	return Plugin_Handled;
}

public int Menu_CTShop(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (action == MenuAction_Select){
		if(p.Alive){
			char info[32], display[64];
			menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
			if (StrEqual(info, "tactnades")){
				Menu tnmenu = new Menu(Menu_TactNades);
				tnmenu.SetTitle("Tactical Grenades");
				if(FlashbangToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || FlashbangToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Flashbang", FlashbangPrice.IntValue);
					tnmenu.AddItem("weapon_flashbang", displayprice);
				}
				if(SmokeToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || SmokeToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Smoke Grenade", SmokePrice.IntValue);
					tnmenu.AddItem("weapon_smokegrenade", displayprice);
				}
				if(DecoyToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || DecoyToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Decoy Grenade", DecoyPrice.IntValue);
					tnmenu.AddItem("weapon_decoy", displayprice);
				}
				if(TactAwareToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || TactAwareToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Tactical Awareness Grenade", TactAwarePrice.IntValue);
					tnmenu.AddItem("weapon_tagrenade", displayprice);
				}
				if(SnowballToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || SnowballToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Snowball", SnowballPrice.IntValue);
					tnmenu.AddItem("weapon_snowball", displayprice);
				}
				tnmenu.Display(client, MENU_TIME_FOREVER);
			}
			else if (StrEqual(info, "primary")){
				Menu primenu = new Menu(Menu_Primary);
				primenu.SetTitle("Primaries");
				if(BizonToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || BizonToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Bizon", BizonPrice.IntValue);
					primenu.AddItem("weapon_bizon", displayprice);
				}
				if(MP9Toggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || MP9Toggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)MP9", MP9Price.IntValue);
					primenu.AddItem("weapon_mp9", displayprice);
				}
				if(NegevToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || NegevToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Negev", NegevPrice.IntValue);
					primenu.AddItem("weapon_negev", displayprice);
				}
				if(FamasToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || FamasToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Famas", FamasPrice.IntValue);
					primenu.AddItem("weapon_famas", displayprice);
				}
				if(ScoutToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || ScoutToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)SSG08", ScoutPrice.IntValue);
					primenu.AddItem("weapon_ssg08", displayprice);
				}
				primenu.Display(client, MENU_TIME_FOREVER);
			}
			else if (StrEqual(info, "offnade")){
				Menu onmenu = new Menu(Menu_OffNades);
				onmenu.SetTitle("Offensive Utility");
				if(HEToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || HEToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)HE Grenade", HEPrice.IntValue);
					onmenu.AddItem("weapon_hegrenade", displayprice);
				}
				if(MolotovToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || MolotovToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Molotov", MolotovPrice.IntValue);
					onmenu.AddItem("weapon_molotov", displayprice);
				}
				if(BreachChargeToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || BreachChargeToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Breach Charge", BreachChargePrice.IntValue);
					onmenu.AddItem("weapon_breachcharge", displayprice);
				}
				onmenu.Display(client, MENU_TIME_FOREVER);
			}
			else if (StrEqual(info, "harmor")){
				Menu hamenu = new Menu(Menu_HeavyArmor);
				hamenu.SetTitle("Heavy Armor");
				if(HeavyArmor10Toggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || HeavyArmor10Toggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Add 10 Heavy Armor", HeavyArmor10Price.IntValue);
					hamenu.AddItem("ha10", displayprice);
				}
				if(HeavyArmor15Toggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || HeavyArmor15Toggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Add 15 Heavy Armor", HeavyArmor15Price.IntValue);
					hamenu.AddItem("ha15", displayprice);
				}
				if(HeavyArmor20Toggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || HeavyArmor20Toggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Add 20 Heavy Armor", HeavyArmor20Price.IntValue);
					hamenu.AddItem("ha20", displayprice);
				}
				if(HeavyArmor25Toggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || HeavyArmor25Toggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Add 25 Heavy Armor", HeavyArmor25Price.IntValue);
					hamenu.AddItem("ha25", displayprice);
				}
				if(HeavyArmor100Toggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || HeavyArmor100Toggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Add 100 Heavy Armor", HeavyArmor100Price.IntValue);
					hamenu.AddItem("ha100", displayprice);
				}
				hamenu.Display(client, MENU_TIME_FOREVER);
			}
			else if (StrEqual(info, "miscellaneous")){
				Menu upmenu = new Menu(Menu_Miscellaneous);
				upmenu.SetTitle("Miscellaneous");
				if(ExoBootsToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || ExoBootsToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)ExoBoots", ExoBootsPrice.IntValue);
					upmenu.AddItem("exoboots", displayprice);
				}
				if(BumpMineToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || BumpMineToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Bump Mine", BumpMinePrice.IntValue);
					upmenu.AddItem("bumpmine", displayprice);
				}
				if(ShieldToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || ShieldToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Riot Shield", ShieldPrice.IntValue);
					upmenu.AddItem("shield", displayprice);
				}
				upmenu.Display(client, MENU_TIME_FOREVER);
			}
		}
		else{
			PrintToChat(client, XG_PREFIX_CHAT_WARN...ALIVE);
	}
	}
	else if (action == MenuAction_End){
		delete menu;
	}
}

public int Menu_TShop(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (action == MenuAction_Select){
		if(p.Alive){
			char info[32], display[64];
			menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
			if (StrEqual(info, "tactnades")){
				Menu tamenu = new Menu(Menu_TactNades);
				tamenu.SetTitle("Tactical Grenades");
				if(FlashbangToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)Flashbang", FlashbangPrice.IntValue);
					tamenu.AddItem("weapon_flashbang", displayprice);
				}
				if(SmokeToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)Smoke Grenade", SmokePrice.IntValue);
					tamenu.AddItem("weapon_smokegrenade", displayprice);
				}
				if(DecoyToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)Decoy Grenade", DecoyPrice.IntValue);
					tamenu.AddItem("weapon_decoy", displayprice);
				}
				if(TactAwareToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)Tactical Awareness Grenade", TactAwarePrice.IntValue);
					tamenu.AddItem("weapon_tagrenade", displayprice);
				}
				if(SnowballToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)Snowball", SnowballPrice.IntValue);
					tamenu.AddItem("weapon_snowball", displayprice);
				}
				tamenu.Display(client, MENU_TIME_FOREVER);
			}
			else if (StrEqual(info, "primary")){
				Menu primenu = new Menu(Menu_Primary);
				primenu.SetTitle("Primaries");
				if(BizonToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)Bizon", BizonPrice.IntValue);
					primenu.AddItem("weapon_bizon", displayprice);
				}
				if(MP9Toggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)MP9", MP9Price.IntValue);
					primenu.AddItem("weapon_mp9", displayprice);
				}
				if(NegevToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)Negev", NegevPrice.IntValue);
					primenu.AddItem("weapon_negev", displayprice);
				}
				if(FamasToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)Famas", FamasPrice.IntValue);
					primenu.AddItem("weapon_famas", displayprice);
				}
				if(ScoutToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)SSG08", ScoutPrice.IntValue);
					primenu.AddItem("weapon_ssg08", displayprice);
				}
				primenu.Display(client, MENU_TIME_FOREVER);
			}
			else if (StrEqual(info, "barmor")){
				Menu bamenu = new Menu(Menu_BodyArmor);
				bamenu.SetTitle("Armor");
				if(BodyArmor10Toggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)Add 10 Body Armor", BodyArmor10Price.IntValue);
					bamenu.AddItem("ba10", displayprice);
				}
				if(BodyArmor15Toggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)Add 15 Body Armor", BodyArmor15Price.IntValue);
					bamenu.AddItem("ba15", displayprice);
				}
				if(BodyArmor20Toggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)Add 20 Body Armor", BodyArmor20Price.IntValue);
					bamenu.AddItem("ba20", displayprice);
				}
				if(BodyArmor25Toggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)Add 25 Body Armor", BodyArmor25Price.IntValue);
					bamenu.AddItem("ba25", displayprice);
				}
				bamenu.Display(client, MENU_TIME_FOREVER);
			}
			else if(StrEqual(info, "pistols")){
				Menu pmenu = new Menu(Menu_Pistols);
				pmenu.SetTitle("Pistols");
				if(GlockToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)Glock", GlockPrice.IntValue);
					pmenu.AddItem("weapon_glock", displayprice);
				}
				if(USPToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)USP", USPPrice.IntValue);
					pmenu.AddItem("weapon_usp", displayprice);
				}
				if(CZ75Toggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)CZ75A", CZ75Price.IntValue);
					pmenu.AddItem("weapon_cz75a", displayprice);
				}
				if(DeagleToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)Deagle", DeaglePrice.IntValue);
					pmenu.AddItem("weapon_deagle", displayprice);
				}
				if(BumpyToggle.IntValue >= view_as<int>(SHOP_ITEM_T_ONLY)){
					Format(displayprice, sizeof(displayprice), "($%d)Revolver", BumpyPrice.IntValue);
					pmenu.AddItem("weapon_revolver", displayprice);
				}
				pmenu.Display(client, MENU_TIME_FOREVER);
			}
			else if (StrEqual(info, "miscellaneous")){
				Menu upmenu = new Menu(Menu_Miscellaneous);
				upmenu.SetTitle("Miscellaneous");
				if(ExoBootsToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || ExoBootsToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)ExoBoots", ExoBootsPrice.IntValue);
					upmenu.AddItem("exoboots", displayprice);
				}
				if(BumpMineToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || BumpMineToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Bump Mine", BumpMinePrice.IntValue);
					upmenu.AddItem("bumpmine", displayprice);
				}
				if(ShieldToggle.IntValue == view_as<int>(SHOP_ITEM_CT_ONLY) || ShieldToggle.IntValue == view_as<int>(SHOP_ITEM_ENABLED)){
					Format(displayprice, sizeof(displayprice), "($%d)Riot Shield", ShieldPrice.IntValue);
					upmenu.AddItem("shield", displayprice);
				}
				upmenu.Display(client, MENU_TIME_FOREVER);
			}
		}
		else{
			PrintToChat(client, XG_PREFIX_CHAT_WARN...ALIVE);
		}
	}
	else if (action == MenuAction_End){
		delete menu;
	}
}

public int Menu_TactNades(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (action == MenuAction_Select){
		if(p.Alive){
			char info[32], display[64];
			menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
			if (StrEqual(info, "weapon_flashbang")){
				if(p.Money >= FlashbangPrice.IntValue){
					p.Money -= FlashbangPrice.IntValue;
					GivePlayerWeapon(p, "weapon_flashbang");
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x0BFlashbang \x01for \x06$%d\x01!", FlashbangPrice.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
			else if (StrEqual(info, "weapon_smokegrenade")){
				if(p.Money >= SmokePrice.IntValue){
					p.Money -= SmokePrice.IntValue;
					GivePlayerWeapon(p, "weapon_smokegrenade");
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x0BSmoke Grenade \x01for \x06$%d\x01!", SmokePrice.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
			else if (StrEqual(info, "weapon_decoy")){
				if(p.Money >= DecoyPrice.IntValue){
					p.Money -= DecoyPrice.IntValue;
					GivePlayerWeapon(p, "weapon_decoy");
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x0BDecoy Grenade \x01for \x06$%d\x01!", DecoyPrice.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
			else if (StrEqual(info, "weapon_tagrenade")){
				if(p.Money >= TactAwarePrice.IntValue){
					p.Money -= TactAwarePrice.IntValue;
					GivePlayerWeapon(p, "weapon_tagrenade");
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x0BTactical Awareness Grenade \x01for \x06$%d\x01!", TactAwarePrice.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
			else if (StrEqual(info, "weapon_snowball")){
				if(p.Money >= SnowballPrice.IntValue){
					p.Money -= SnowballPrice.IntValue;
					GivePlayerWeapon(p, "weapon_snowball");
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x0BSnowball \x01for \x06$%d\x01!", SnowballPrice.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
		}
		else{
			PrintToChat(client, XG_PREFIX_CHAT...ALIVE);
		}
	}
	else if (action == MenuAction_End){
		delete menu;
	}
}

public int Menu_OffNades(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (action == MenuAction_Select){
		if(p.Alive){
			char info[32], display[64];
			menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
			if (StrEqual(info, "weapon_hegrenade")){
				if(p.Money >= HEPrice.IntValue){
					p.Money -= HEPrice.IntValue;
					GivePlayerWeapon(p, "weapon_hegrenade");
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x07HE Grenade \x01for \x06$%d\x01!", HEPrice.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
			else if (StrEqual(info, "weapon_molotov")){
				if(p.Money >= MolotovPrice.IntValue){
					p.Money -= MolotovPrice.IntValue;
					GivePlayerWeapon(p, "weapon_molotov");
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x07Molotov \x01for \x06$%d\x01!", MolotovPrice.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
			else if (StrEqual(info, "weapon_breachcharge")){
				if(p.Money >= BreachChargePrice.IntValue){
					p.Money -= BreachChargePrice.IntValue;
					CWeapon bcwep = GivePlayerWeapon(p, "weapon_breachcharge");
					bcwep.Ammo = 1;
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x07Breach Charge \x01for \x06$%d\x01!", BreachChargePrice.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
		}
		else{
			PrintToChat(client, XG_PREFIX_CHAT_WARN...ALIVE);
		}
	}
	else if (action == MenuAction_End){
		delete menu;
	}
}

public int Menu_HeavyArmor(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (action == MenuAction_Select){
		if(p.Alive){
			char info[32], display[64];
			menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
			if (StrEqual(info, "ha10")){
				if(p.Money >= HeavyArmor10Price.IntValue){
					p.Money -= HeavyArmor10Price.IntValue;
					//Save viewmodel and player model
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
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought \x0B10 Heavy Armor \x01for \x06$%d\x01!", HeavyArmor10Price.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
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
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought \x0B15 Heavy Armor \x01for \x06$%d\x01!", HeavyArmor15Price.IntValue);
				}
					else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
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
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought \x0B20 Heavy Armor \x01for \x06$%d\x01!", HeavyArmor20Price.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
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
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought \x0B25 Heavy Armor \x01for \x06$%d\x01!", HeavyArmor25Price.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
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
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought \x0B100 Heavy Armor \x01for \x06$%d\x01!", HeavyArmor100Price.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
		}
		else{
			PrintToChat(client, XG_PREFIX_CHAT_WARN...ALIVE);
		}
	}
	else if (action == MenuAction_End){
		delete menu;
	}
}

public int Menu_BodyArmor(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (action == MenuAction_Select){
		if(p.Alive){
			char info[32], display[64];
			menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
			if (StrEqual(info, "ba10")){
				if(p.Money >= BodyArmor10Price.IntValue){
					p.Money -= BodyArmor10Price.IntValue;
					p.Armor += 10;
					p.Helmet = false;
					p.HeavyArmor = false;
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought \x0B10 Body Armor \x01for \x06$%d\x01!", BodyArmor10Price.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
			else if (StrEqual(info, "ba15")){
				if(p.Money >= BodyArmor15Price.IntValue){
					p.Money -= BodyArmor15Price.IntValue;
					p.Armor += 15;
					p.Helmet = false;
					p.HeavyArmor = false;
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought \x0B15 Body Armor \x01for \x06$%d\x01!", BodyArmor15Price.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
			else if (StrEqual(info, "ba20")){
				if(p.Money >= BodyArmor20Price.IntValue){
					p.Money -= BodyArmor20Price.IntValue;
					p.Armor += 20;
					p.Helmet = false;
					p.HeavyArmor = false;
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought \x0B20 Body Armor \x01for \x06$%d\x01!", BodyArmor20Price.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
			else if (StrEqual(info, "ba25")){
				if(p.Money >= BodyArmor25Price.IntValue){
					p.Money -= BodyArmor25Price.IntValue;
					p.Armor += 25;
					p.Helmet = false;
					p.HeavyArmor = false;
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought \x0B25 Body Armor \x01for \x06$%d\x01!", BodyArmor25Price.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
		}
		else{
			PrintToChat(client, XG_PREFIX_CHAT_WARN...ALIVE);
		}
	}
	else if (action == MenuAction_End){
		delete menu;
	}
}

public int Menu_Pistols(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (action == MenuAction_Select){
		if(p.Alive){
			char info[32], display[64];
			menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
			if(p.GetWeapon(CS_SLOT_SECONDARY).IsNull){
				if (StrEqual(info, "weapon_glock")){
					if(p.Money >= GlockPrice.IntValue){
						p.Money -= GlockPrice.IntValue;
						CWeapon gkwep = GivePlayerWeapon(p, "weapon_glock");
						gkwep.Ammo = GlockAmmo.IntValue;
						gkwep.ReserveAmmo = GlockReserveAmmo.IntValue;
						PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x07Glock \x01for \x06$%d\x01!", GlockPrice.IntValue);
					}
					else{
						PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
					}
				}
				else if (StrEqual(info, "weapon_usp")){
					if(p.Money >= USPPrice.IntValue){
						p.Money -= USPPrice.IntValue;
						CWeapon uspwep = GivePlayerWeapon(p, "weapon_usp_silencer");
						uspwep.Ammo = USPAmmo.IntValue;
						uspwep.ReserveAmmo = USPReserveAmmo.IntValue;
						PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x07USP \x01for \x06$%d\x01!", USPPrice.IntValue);
					}
					else{
						PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
					}
				}
				else if (StrEqual(info, "weapon_cz75a")){
					if(p.Money >= CZ75Price.IntValue){
						p.Money -= CZ75Price.IntValue;
						CWeapon czwep = GivePlayerWeapon(p, "weapon_cz75a");
						czwep.Ammo = CZ75Ammo.IntValue;
						czwep.ReserveAmmo = CZ75ReserveAmmo.IntValue;
						PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x07CZ75A \x01for \x06$%d\x01!", CZ75Price.IntValue);
					}
					else{
						PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
					}
				}
				else if (StrEqual(info, "weapon_deagle")){
					if(p.Money >= DeaglePrice.IntValue){
						p.Money -= DeaglePrice.IntValue;
						CWeapon dgwep = GivePlayerWeapon(p, "weapon_deagle");
						dgwep.Ammo = DeagleAmmo.IntValue;
						dgwep.ReserveAmmo = DeagleReserveAmmo.IntValue;
						PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x07Deagle \x01for \x06$%d\x01!", DeaglePrice.IntValue);
					}
					else{
						PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
					}
				}
				else if (StrEqual(info, "weapon_revolver")){
					if(p.Money >= BumpyPrice.IntValue){
						p.Money -= BumpyPrice.IntValue;
						CWeapon r8wep = GivePlayerWeapon(p, "weapon_revolver");
						r8wep.Ammo = BumpyAmmo.IntValue;
						r8wep.ReserveAmmo = BumpyReserveAmmo.IntValue;
						PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x07Revolver \x01for \x06$%d\x01!", BumpyPrice.IntValue);
						PrintToConsole(client, "bumpy bumpy");
					}
					else{
						PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
					}
				}
			}
			else{
				PrintToChat(client, XG_PREFIX_CHAT_WARN ... "You already have a \x07secondary\x01!");
			}
		}
		else{
			PrintToChat(client, XG_PREFIX_CHAT_WARN...ALIVE);
		}
	}
	else if (action == MenuAction_End){
		delete menu;
	}
}

public int Menu_Primary(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (action == MenuAction_Select){
		if(p.Alive){
			char info[32], display[64];
			menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
			if(p.GetWeapon(CS_SLOT_PRIMARY).IsNull){
				if (StrEqual(info, "weapon_bizon")){
					if(p.Money >= BizonPrice.IntValue){
						p.Money -= BizonPrice.IntValue;
						CWeapon ppwep = GivePlayerWeapon(p, "weapon_bizon");
						ppwep.Ammo = BizonAmmo.IntValue;
						ppwep.ReserveAmmo = BizonReserveAmmo.IntValue;
						PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x07Bizon \x01for \x06$%d\x01!", BizonPrice.IntValue);
					}
					else{
						PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
					}
				}
				else if (StrEqual(info, "weapon_mp9")){
					if(p.Money >= MP9Price.IntValue){
						p.Money -= MP9Price.IntValue;
						CWeapon mp9wep = GivePlayerWeapon(p, "weapon_mp9");
						mp9wep.Ammo = MP9Ammo.IntValue;
						mp9wep.ReserveAmmo = MP9ReserveAmmo.IntValue;
						PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x07MP9 \x01for \x06$%d\x01!", MP9Price.IntValue);
					}
					else{
						PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
					}
				}
				else if (StrEqual(info, "weapon_negev")){
					if(p.Money >= NegevPrice.IntValue){
						p.Money -= NegevPrice.IntValue;
						CWeapon negevwep = GivePlayerWeapon(p, "weapon_negev");
						negevwep.Ammo = NegevAmmo.IntValue;
						negevwep.ReserveAmmo = NegevReserveAmmo.IntValue;
						PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x07Negev \x01for \x06$%d\x01!", NegevPrice.IntValue);
					}
					else{
						PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
					}
				}

				else if (StrEqual(info, "weapon_famas")){
					if(p.Money >= FamasPrice.IntValue){
						p.Money -= FamasPrice.IntValue;
						CWeapon famaswep = GivePlayerWeapon(p, "weapon_famas");
						famaswep.Ammo = FamasAmmo.IntValue;
						famaswep.ReserveAmmo = FamasReserveAmmo.IntValue;
						PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x07Famas \x01for \x06$%d\x01!", FamasPrice.IntValue);
					}
					else{
						PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
					}
				}
				else if (StrEqual(info, "weapon_ssg08")){
					if(p.Money >= ScoutPrice.IntValue){
						p.Money -= ScoutPrice.IntValue;
						CWeapon scoutwep = GivePlayerWeapon(p, "weapon_ssg08");
						scoutwep.Ammo = ScoutAmmo.IntValue;
						scoutwep.ReserveAmmo = ScoutReserveAmmo.IntValue;
						PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x07SSG08 \x01for \x06$%d\x01!", ScoutPrice.IntValue);
					}
					else{
						PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
					}
				}
			}
			else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... "You already have a \x07primary\x01!");
			}
		}
		else{
			PrintToChat(client, XG_PREFIX_CHAT_WARN...ALIVE);
		}
	}
	else if (action == MenuAction_End){
		delete menu;
	}
}

public int Menu_Miscellaneous(Menu menu, MenuAction action, int client, int itemNum){
	CCSPlayer p = CCSPlayer(client);
	if (action == MenuAction_Select){
		if(p.Alive){
			char info[32], display[64];
			menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
			if (StrEqual(info, "exoboots")){
				if(p.Money >= ExoBootsPrice.IntValue){
					p.Money -= ExoBootsPrice.IntValue;
					SetEntProp(client, Prop_Send, "m_passiveItems", 1, 1, 1);
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought \x07 ExoBoots \x01for \x06$%d\x01!", ExoBootsPrice.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
			else if (StrEqual(info, "bumpmine")){
				if(p.Money >= BumpMinePrice.IntValue){
					p.Money -= BumpMinePrice.IntValue;
					GivePlayerWeapon(p, "weapon_bumpmine");
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought 3 \x07Bump Mines \x01for \x06$%d\x01!", BumpMinePrice.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
			else if (StrEqual(info, "shield")){
				if(p.Money >= ShieldPrice.IntValue){
					p.Money -= ShieldPrice.IntValue;
					GivePlayerWeapon(p, "weapon_shield");
					PrintToChat(client, XG_PREFIX_CHAT ... "You bought a \x07Riot Shield \x01for \x06$%d\x01!", ShieldPrice.IntValue);
				}
				else{
					PrintToChat(client, XG_PREFIX_CHAT_WARN ... NOMONEY);
				}
			}
		}
		else{
			PrintToChat(client, XG_PREFIX_CHAT_WARN...ALIVE);
		}
	}
	else if (action == MenuAction_End){
		delete menu;
	}
}
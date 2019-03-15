#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <ccsplayer>
#include <sdktools>
#include <sdkhooks>

#define prefix "[SM] "
#define nomoney "You don't have enough money!"
#define disable "This is currently disabled!"

public Plugin myinfo = 
{
	name = "Cash Shop",
	author = "Jadow",
	description = "Use in game money to buy things",
	version = "1.1",
	url = "https://github.com/Jadowo/CSCashShop"
};



ConVar FlashbangToggle;
ConVar SmokeToggle;
ConVar DecoyToggle;
ConVar TactAwareToggle;
ConVar HEToggle;
ConVar MolotovToggle;
ConVar BreachChargeToggle;
ConVar SnowballToggle;
ConVar GlockToggle;
ConVar CZ75Toggle;
ConVar DeagleToggle;
ConVar BumpyToggle;
ConVar HeavyArmor10Toggle;
ConVar HeavyArmor15Toggle;
ConVar HeavyArmor20Toggle;
ConVar HeavyArmor25Toggle;
ConVar BodyArmor10Toggle;
ConVar BodyArmor15Toggle;
ConVar BodyArmor20Toggle;
ConVar BodyArmor25Toggle;
ConVar FlashbangPrice;
ConVar SmokePrice;
ConVar DecoyPrice;
ConVar TactAwarePrice;
ConVar HEPrice;
ConVar MolotovPrice;
ConVar BreachChargePrice;
ConVar SnowballPrice;
ConVar GlockPrice;
ConVar CZ75Price;
ConVar DeaglePrice;
ConVar BumpyPrice;
ConVar HeavyArmor10Price;
ConVar HeavyArmor15Price;
ConVar HeavyArmor20Price;
ConVar HeavyArmor25Price;
ConVar BodyArmor10Price;
ConVar BodyArmor15Price;
ConVar BodyArmor20Price;
ConVar BodyArmor25Price;
ConVar TactNadesToggle;
ConVar OffNadesToggle;
ConVar HeavyArmorToggle;
ConVar BodyArmorToggle;
ConVar PistolsToggle;
ConVar CashShopToggle;


public void OnPluginStart()
{

	RegConsoleCmd("sm_cashshop", Command_CashShop);
	RegConsoleCmd("sm_cs", Command_CashShop);
	HookEvent("round_end", Event_RoundEnd);
	
	FlashbangPrice =				CreateConVar("sm_cashshop_price_flashbang",				"5000",  "Price of Flashbang");
	SmokePrice =					CreateConVar("sm_cashshop_price_smokegrenade",			"5000",  "Price of Smoke Grenade");
	DecoyPrice =					CreateConVar("sm_cashshop_price_decoy",					"5000",  "Price of Decoy Grenade");
	TactAwarePrice =				CreateConVar("sm_cashshop_price_tacticalawareness",		"5000",  "Price of Tactical Awareness Grenade");
	SnowballPrice =					CreateConVar("sm_cashshop_price_snowball",				"100",   "Price of Snowball");
	HEPrice =						CreateConVar("sm_cashshop_price_hegrenade",				"8000",  "Price of HE Grenade");
	MolotovPrice =					CreateConVar("sm_cashshop_price_molotov",				"8000",  "Price of Molotov");
	BreachChargePrice =				CreateConVar("sm_cashshop_price_breachcharge",			"12000", "Price of Breach Charge");
	GlockPrice =					CreateConVar("sm_cashshop_price_glock",					"16000", "Price of Glock");
	CZ75Price =						CreateConVar("sm_cashshop_price_cz75a",					"18000", "Price of CZ75A");
	DeaglePrice =					CreateConVar("sm_cashshop_price_deagle",				"20000", "Price of Deagle");
	BumpyPrice =					CreateConVar("sm_cashshop_price_revolver",				"20000", "Price of Revolver");
	HeavyArmor10Price =				CreateConVar("sm_cashshop_price_heavyarmor10",			"10000", "Price of Heavy Armor +10");
	HeavyArmor15Price =				CreateConVar("sm_cashshop_price_heavyarmor15",			"12000", "Price of Heavy Armor +15");
	HeavyArmor20Price =				CreateConVar("sm_cashshop_price_heavyarmor20",			"14000", "Price of Heavy Armor +20");
	HeavyArmor25Price =				CreateConVar("sm_cashshop_price_heavyarmor25",			"16000", "Price of Heavy Armor +25");
	BodyArmor10Price =				CreateConVar("sm_cashshop_price_armor10",				"4000",  "Price of Armor +10");
	BodyArmor15Price =				CreateConVar("sm_cashshop_price_armor15",				"5200",  "Price of Armor +15");
	BodyArmor20Price =				CreateConVar("sm_cashshop_price_armor20",				"6400",  "Price of Armor +20");
	BodyArmor25Price =				CreateConVar("sm_cashshop_price_armor25",				"7600",  "Price of Armor +25");
	
	
	FlashbangToggle =				CreateConVar("sm_cashshop_toggle_flashbang",			"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	SmokeToggle =					CreateConVar("sm_cashshop_toggle_smoke",				"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	DecoyToggle =					CreateConVar("sm_cashshop_toggle_decoy",				"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	TactAwareToggle =				CreateConVar("sm_cashshop_toggle_tacticalawareness", 	"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	SnowballToggle =				CreateConVar("sm_cashshop_toggle_snowball",				"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	HEToggle =						CreateConVar("sm_cashshop_toggle_hegrenade",			"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	MolotovToggle =					CreateConVar("sm_cashshop_toggle_molotov",				"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	BreachChargeToggle =			CreateConVar("sm_cashshop_toggle_breachcharge",			"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	GlockToggle =					CreateConVar("sm_cashshop_toggle_glock",				"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	CZ75Toggle =					CreateConVar("sm_cashshop_toggle_cz75a",				"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	DeagleToggle =					CreateConVar("sm_cashshop_toggle_deagle",				"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	BumpyToggle =					CreateConVar("sm_cashshop_toggle_revolver",				"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	HeavyArmor10Toggle =			CreateConVar("sm_cashshop_toggle_heavyarmor10",			"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	HeavyArmor15Toggle =			CreateConVar("sm_cashshop_toggle_heavyarmor15",			"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	HeavyArmor20Toggle =			CreateConVar("sm_cashshop_toggle_heavyarmor20",			"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	HeavyArmor25Toggle =			CreateConVar("sm_cashshop_toggle_heavyarmor25",			"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	BodyArmor10Toggle =				CreateConVar("sm_cashshop_toggle_armor2510",			"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	BodyArmor15Toggle =				CreateConVar("sm_cashshop_toggle_armor15",				"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	BodyArmor20Toggle =				CreateConVar("sm_cashshop_toggle_armor20",				"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	BodyArmor25Toggle =				CreateConVar("sm_cashshop_toggle_armor25",				"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	
	TactNadesToggle =				CreateConVar("sm_cashshop_toggle_tactnades",			"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	OffNadesToggle =				CreateConVar("sm_cashshop_toggle_offnades",				"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	HeavyArmorToggle =				CreateConVar("sm_cashshop_toggle_armor_heavy",			"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	BodyArmorToggle =				CreateConVar("sm_cashshop_toggle_armor_body",			"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	PistolsToggle =					CreateConVar("sm_cashshop_toggle_pistols",				"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	CashShopToggle =				CreateConVar("sm_cashshop_toggle_all",					"3", "0 = Disabled, 1 = CT, 2 = T, 3 = Both", _, true, 0.0, true, 3.0);
	
	
	AutoExecConfig(true, "plugin.cashshop-jb");
	}

public void OnMapStart() {
	// When setting Heavy Armor, model is changed.
	PrecacheModel("models/player/custom_player/legacy/ctm_heavy.mdl");
	PrecacheModel("models/player/custom_player/legacy/tm_phoenix_heavy.mdl");
}

public Action Event_RoundEnd(Event hEvent, const char[] sName, bool bDontBroadcast) {
	for(CCSPlayer p = CCSPlayer(0); CCSPlayer.Next(p);) {
		if(p.InGame && p.Team == CS_TEAM_CT) {
			p.HeavyArmor = false;
		}
	}
}

public Action Command_CashShop(int client, int args)
{
	CCSPlayer p = CCSPlayer(client);
	if (CS_TEAM_CT == p.Team)
	{
		if(CashShopToggle.IntValue == 1 || CashShopToggle.IntValue == 3){
			Menu menu = new Menu(Menu_CTShop);
			menu.SetTitle("Cash Shop");
			if(TactNadesToggle.IntValue == 1 || TactNadesToggle.IntValue == 3){
				menu.AddItem("tactnades",    "Tactical Grenade");
			}
			if(OffNadesToggle.IntValue == 1 || OffNadesToggle.IntValue == 3){
				menu.AddItem("offnade",      "Offensive Utility");
			}
			if(HeavyArmorToggle.IntValue == 1 || HeavyArmorToggle.IntValue == 3){
				menu.AddItem("harmor",       "Heavy Armor");
			}
			menu.Display(client, MENU_TIME_FOREVER);
			return Plugin_Handled;
		}
	}
	else if(CS_TEAM_T == p.Team)
	{
		Menu menu = new Menu(Menu_TShop);
		menu.SetTitle("Cash Shop");
		if(TactNadesToggle.IntValue > 1){
			menu.AddItem("tactnades",    "Tactical Grenade");
		}
		if(PistolsToggle.IntValue > 1){
			menu.AddItem("pistols",     "Pistols");
		}
		if(BodyArmorToggle.IntValue > 1){
			menu.AddItem("barmor",       "Body Armor");
		}
		menu.Display(client, MENU_TIME_FOREVER);
		return Plugin_Handled;
	}
	return Plugin_Handled;
}
char but[128];
public int Menu_CTShop(Menu menu, MenuAction action, int client, int itemNum)
{
	if (action == MenuAction_Select)
	{
		char info[32], display[64];
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		if (StrEqual(info, "tactnades"))
		{
			
			Menu tgmenu = new Menu(Menu_TactNades);
			tgmenu.SetTitle("Tactical Grenades");
			if(FlashbangToggle.IntValue == 1 || FlashbangToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Flashbang", FlashbangPrice.IntValue);
				tgmenu.AddItem("weapon_flashbang", but);
			}
			if(SmokeToggle.IntValue == 1 || SmokeToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Smoke Grenade", SmokePrice.IntValue);
				tgmenu.AddItem("weapon_smokegrenade", but);
			}
			if(DecoyToggle.IntValue == 1 || DecoyToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Decoy Grenade", DecoyPrice.IntValue);
				tgmenu.AddItem("weapon_decoygrenade", but);
			}
			if(TactAwareToggle.IntValue == 1 || TactAwareToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Tactical Awareness Grenade", TactAwarePrice.IntValue);
				tgmenu.AddItem("weapon_tagrenade", but);
			}
			if(SnowballToggle.IntValue == 1 || SnowballToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Snowball", SnowballPrice.IntValue);
				tgmenu.AddItem("weapon_snowball", but);
			}
			tgmenu.Display(client, MENU_TIME_FOREVER);
		}
		else if (StrEqual(info, "offnade"))
		{
			Menu tgmenu = new Menu(Menu_OffNades);
			tgmenu.SetTitle("Offensive Utility");
			if(HEToggle.IntValue == 1 || HEToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)", HEPrice.IntValue);
				tgmenu.AddItem("weapon_hegrenade", but);
			}
			if(MolotovToggle.IntValue == 1 || MolotovToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)", MolotovPrice.IntValue);
				tgmenu.AddItem("weapon_molotov", but);
			}
			if(BreachChargeToggle.IntValue == 1 || BreachChargeToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)", BreachChargePrice.IntValue);
				tgmenu.AddItem("weapon_breachcharge", but);
			}
			tgmenu.Display(client, MENU_TIME_FOREVER);
		}
		else if (StrEqual(info, "harmor"))
		{
			Menu tgmenu = new Menu(Menu_HeavyArmor);
			tgmenu.SetTitle("Heavy Armor");
			if(HeavyArmor10Toggle.IntValue == 1 || HeavyArmor10Toggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)", HeavyArmor10Price.IntValue);
				tgmenu.AddItem("ha10", but);
			}
			if(HeavyArmor15Toggle.IntValue == 1 || HeavyArmor15Toggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)", HeavyArmor15Price.IntValue);
				tgmenu.AddItem("ha15", but);
			}
			if(HeavyArmor20Toggle.IntValue == 1 || HeavyArmor20Toggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)", HeavyArmor20Price.IntValue);
				tgmenu.AddItem("ha20", but);
			}
			if(HeavyArmor25Toggle.IntValue == 1 || HeavyArmor25Toggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)", HeavyArmor25Price.IntValue);
				tgmenu.AddItem("ha25", but);
			}
			tgmenu.Display(client, MENU_TIME_FOREVER);
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}
public int Menu_TShop(Menu menu, MenuAction action, int client, int itemNum)
{
	if (action == MenuAction_Select)
	{
		char info[32], display[64];
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		if (StrEqual(info, "tactnades"))
		{
			
			Menu tgmenu = new Menu(Menu_TactNades);
			tgmenu.SetTitle("Tactical Grenades");
			if(FlashbangToggle.IntValue == 2 || FlashbangToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Flashbang", FlashbangPrice.IntValue);
				tgmenu.AddItem("weapon_flashbang", but);
			}
			if(SmokeToggle.IntValue == 2 || SmokeToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Smoke Grenade", SmokePrice.IntValue);
				tgmenu.AddItem("weapon_smokegrenade", but);
			}
			if(DecoyToggle.IntValue == 2 || DecoyToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Decoy Grenade", DecoyPrice.IntValue);
				tgmenu.AddItem("weapon_decoygrenade", but);
			}
			if(TactAwareToggle.IntValue == 2 || TactAwareToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Tactical Awareness Grenade", TactAwarePrice.IntValue);
				tgmenu.AddItem("weapon_tagrenade", but);
			}
			if(SnowballToggle.IntValue == 2 || SnowballToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Snowball", SnowballPrice.IntValue);
				tgmenu.AddItem("weapon_snowball", but);
			}
			tgmenu.Display(client, MENU_TIME_FOREVER);
		}
		else if (StrEqual(info, "barmor"))
		{
			Menu tgmenu = new Menu(Menu_BodyArmor);
			tgmenu.SetTitle("Armor");
			if(BodyArmor10Toggle.IntValue == 2 || BodyArmor10Toggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Add 10 Body Amor", BodyArmor10Price.IntValue);
				tgmenu.AddItem("ba10", but);
			}
			if(BodyArmor15Toggle.IntValue == 2 || BodyArmor15Toggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Add 15 Body Amor", BodyArmor15Price.IntValue);
				tgmenu.AddItem("ba15", but);
			}
			if(BodyArmor20Toggle.IntValue == 2 || BodyArmor20Toggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Add 20 Body Amor", BodyArmor20Price.IntValue);
				tgmenu.AddItem("ba20", but);
			}
			if(BodyArmor25Toggle.IntValue == 2 || BodyArmor25Toggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Add 25 Body Amor", BodyArmor25Price.IntValue);
				tgmenu.AddItem("ba25", but);
			}
			
			tgmenu.Display(client, MENU_TIME_FOREVER);
		}
		else if(StrEqual(info, "pistols"))
		{
			Menu tgmenu = new Menu(Menu_Pistols);
			tgmenu.SetTitle("Pistols");
			if(GlockToggle.IntValue == 2 || GlockToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Glock", GlockPrice.IntValue);
				tgmenu.AddItem("weapon_glock", but);
			}
			if(CZ75Toggle.IntValue == 2 || CZ75Toggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)CZ75A", CZ75Price.IntValue);
				tgmenu.AddItem("weapon_cz75a", but);
			}
			if(DeagleToggle.IntValue == 2 || DeagleToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)Deagle", DeaglePrice.IntValue);
				tgmenu.AddItem("weapon_deagle", but);
			}
			if(BumpyToggle.IntValue == 2 || BumpyToggle.IntValue == 3){
				Format(but, sizeof(but), "($%d)BumpyBumpy", BumpyPrice.IntValue);
				tgmenu.AddItem("weapon_revolver", but);
			}
			tgmenu.Display(client, MENU_TIME_FOREVER);
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

public int Menu_TactNades(Menu menu, MenuAction action, int client, int itemNum)
{
	if (action == MenuAction_Select)
	{
		CCSPlayer p = CCSPlayer(client);
		char info[32], display[64];
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		if (StrEqual(info, "weapon_flashbang"))
		{
			if(p.Money >= FlashbangPrice.IntValue){
				p.Money -= FlashbangPrice.IntValue;
				GivePlayerWeapon(p, "weapon_flashbang");
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}

		}
		else if (StrEqual(info, "weapon_smokegrenade"))
		{
			if(p.Money >= SmokePrice.IntValue){
				p.Money -= SmokePrice.IntValue;
				GivePlayerWeapon(p, "weapon_smokegrenade");
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "weapon_decoy"))
		{
			if(p.Money >= DecoyPrice.IntValue){
				p.Money -= DecoyPrice.IntValue;
				GivePlayerWeapon(p, "weapon_decoy");
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "weapon_tagrenade"))
		{
			if(p.Money >= TactAwarePrice.IntValue){
				p.Money -= TactAwarePrice.IntValue;
				GivePlayerWeapon(p, "weapon_tagrenade");
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "weapon_snowball"))
		{
			if(p.Money >= SnowballPrice.IntValue){
				p.Money -= SnowballPrice.IntValue;
				GivePlayerWeapon(p, "weapon_snowball");
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
	
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}

}

public int Menu_OffNades(Menu menu, MenuAction action, int client, int itemNum)
{
	if (action == MenuAction_Select)
	{
		CCSPlayer p = CCSPlayer(client);
		char info[32], display[64];
		//itemNum is the position of the item the client selected.
		//This gets the strings you set in AddItem() and stores them in info and display
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		if (StrEqual(info, "weapon_hegrenade"))
		{
			if(p.Money >= HEPrice.IntValue){
				p.Money -= HEPrice.IntValue;
				GivePlayerWeapon(p, "weapon_hegrenade");
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "weapon_molotov"))
		{
			if(p.Money >= MolotovPrice.IntValue){
				p.Money -= MolotovPrice.IntValue;
				GivePlayerWeapon(p, "weapon_molotov");
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "weapon_breachcharge"))
		{
			if(p.Money >= BreachChargePrice.IntValue){
				p.Money -= BreachChargePrice.IntValue;
				GivePlayerWeapon(p, "weapon_breachcharge");
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

public int Menu_HeavyArmor(Menu menu, MenuAction action, int client, int itemNum)
{
	if (action == MenuAction_Select)
	{
		CCSPlayer p = CCSPlayer(client);
		char info[32], display[64];
		//itemNum is the position of the item the client selected.
		//This gets the strings you set in AddItem() and stores them in info and display
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		if (StrEqual(info, "ha10"))
		{
			if(p.Money >= HeavyArmor10Price.IntValue){
				p.Money -= HeavyArmor10Price.IntValue;
				char sModel[PLATFORM_MAX_PATH];
				char sHand[PLATFORM_MAX_PATH];
				p.GetPropString(Prop_Send, "m_szArmsModel", sHand, sizeof(sHand));
				p.GetModel(sModel, sizeof(sModel));
				p.Armor = 10;
				p.Helmet = true;
				p.HeavyArmor = true;
				p.SetModel(sModel);
				p.SetPropString(Prop_Send, "m_szArmsModel", sHand);
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "ha15"))
		{
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
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "ha20"))
		{
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
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "ha25"))
		{
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
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

public int Menu_BodyArmor(Menu menu, MenuAction action, int client, int itemNum)
{
	if (action == MenuAction_Select)
	{
		CCSPlayer p = CCSPlayer(client);
		char info[32], display[64];
		//itemNum is the position of the item the client selected.
		//This gets the strings you set in AddItem() and stores them in info and display
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		if (StrEqual(info, "ba10"))
		{
			if(p.Money >= BodyArmor10Price.IntValue){
				p.Money -= BodyArmor10Price.IntValue;
				p.Armor += 10;
				p.Helmet = false;
				p.HeavyArmor = false;
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "ba15"))
		{
			if(p.Money >= BodyArmor15Price.IntValue){
				p.Money -= BodyArmor15Price.IntValue;
				p.Armor += 15;
				p.Helmet = false;
				p.HeavyArmor = false;
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "ba20"))
		{
			if(p.Money >= BodyArmor20Price.IntValue){
				p.Money -= BodyArmor20Price.IntValue;
				p.Armor += 20;
				p.Helmet = false;
				p.HeavyArmor = false;
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
		else if (StrEqual(info, "ba25"))
		{
			if(p.Money >= BodyArmor25Price.IntValue){
				p.Money -= BodyArmor25Price.IntValue;
				p.Armor += 25;
				p.Helmet = false;
				p.HeavyArmor = false;
			}
			else{
				PrintToChat(client, prefix ... nomoney);
			}
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

public int Menu_Pistols(Menu menu, MenuAction action, int client, int itemNum)
{
	if (action == MenuAction_Select)
	{
		CCSPlayer p = CCSPlayer(client);
		char info[32], display[64];
		//itemNum is the position of the item the client selected.
		//This gets the strings you set in AddItem() and stores them in info and display
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		if(p.GetWeapon(CS_SLOT_SECONDARY).IsNull){
			if (StrEqual(info, "weapon_glock"))
			{
				if(p.Money >= GlockPrice.IntValue){
					p.Money -= GlockPrice.IntValue;
					CWeapon gkwep = GivePlayerWeapon(p, "weapon_glock");
					gkwep.Ammo = 10;
					gkwep.ReserveAmmo = 0;
				}
				else{
					PrintToChat(client, prefix ... nomoney);
				}
			}
			else if (StrEqual(info, "weapon_cz75a"))
			{
				if(p.Money >= CZ75Price.IntValue){
					p.Money -= CZ75Price.IntValue;
					CWeapon czwep = GivePlayerWeapon(p, "weapon_cz75a");
					czwep.Ammo = 6;
					czwep.ReserveAmmo = 0;
				}
				else{
					PrintToChat(client, prefix ... nomoney);
				}
			}
			else if (StrEqual(info, "weapon_deagle"))
			{
				if(p.Money >= DeaglePrice.IntValue){
					p.Money -= DeaglePrice.IntValue;
					CWeapon dgwep = GivePlayerWeapon(p, "weapon_deagle");
					dgwep.Ammo = 2;
					dgwep.ReserveAmmo = 0;
				}
				else{
					PrintToChat(client, prefix ... nomoney);
				}
			}
			else if (StrEqual(info, "weapon_revolver"))
			{
				if(p.Money >= BumpyPrice.IntValue){
					p.Money -= BumpyPrice.IntValue;
					CWeapon r8wep = GivePlayerWeapon(p, "weapon_revolver");
					r8wep.Ammo = 1;
					r8wep.ReserveAmmo = 0;
				}
				else{
					PrintToChat(client, prefix ... nomoney);
				}
			}
		}
		else
		{
			PrintToChat(client, prefix ... "You already have a secondary!");
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

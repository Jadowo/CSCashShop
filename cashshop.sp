#pragma semicolon 1

#include <sourcemod>
#include <AutoExecConfig>
#include <ccsplayer>
#include <sdktools>
#include <sdkhooks>

#pragma newdecls required

public Plugin myinfo = 
{
	name = "Cash Shop",
	author = "Jadow",
	description = "Use in game money to buy things",
	version = "1.0",
	url = "https://github.com/Jadowo/CSCashShop"
};
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
ConVar Armor10Price;
ConVar Armor15Price;
ConVar Armor20Price;
ConVar Armor25Price;

public void OnPluginStart()
{

	RegConsoleCmd("sm_cashshop", Command_CashShop);
	RegConsoleCmd("sm_cs", Command_CashShop);
	HookEvent("round_end", Event_RoundEnd);
	
	FlashbangPrice = AutoExecConfig_CreateConVar("sm_cashshop_price_flashbang",               "5000", "Price of Flashbang");
	SmokePrice = AutoExecConfig_CreateConVar("sm_cashshop_price_smokegrenade",                "5000", "Price of Smoke Grenade");
	DecoyPrice = AutoExecConfig_CreateConVar("sm_cashshop_price_decoy",                       "5000", "Price of Decoy Grenade");
	TactAwarePrice = AutoExecConfig_CreateConVar("sm_cashshop_price_tacticalawareness",       "5000", "Price of Tactical Awareness Grenade");
	HEPrice = AutoExecConfig_CreateConVar("sm_cashshop_price_hegrenade",                      "8000", "Price of HE Grenade");
	MolotovPrice = AutoExecConfig_CreateConVar("sm_cashshop_price_molotov",                   "8000", "Price of Molotov");
	BreachChargePrice = AutoExecConfig_CreateConVar("sm_cashshop_price_breachcharge",         "12000", "Price of Breach Charge");
	SnowballPrice = AutoExecConfig_CreateConVar("sm_cashshop_price_snoball",                  "100", "Price of Snowball");
	GlockPrice = AutoExecConfig_CreateConVar("sm_cashshop_price_glock",                       "16000", "Price of Glock");
	CZ75Price = AutoExecConfig_CreateConVar("sm_cashshop_price_cz75a",                        "18000", "Price of CZ75A");
	DeaglePrice = AutoExecConfig_CreateConVar("sm_cashshop_price_deagle",                     "20000", "Price of Deagle");
	BumpyPrice = AutoExecConfig_CreateConVar("sm_cashshop_price_revolver",                    "20000", "Price of Revolver");
	HeavyArmor10Price = AutoExecConfig_CreateConVar("sm_cashshop_price_heavyarmor10",         "10000", "Price of Heavy Armor +10");
	HeavyArmor15Price = AutoExecConfig_CreateConVar("sm_cashshop_price_heavyarmor15",         "12000", "Price of Heavy Armor +15");
	HeavyArmor20Price = AutoExecConfig_CreateConVar("sm_cashshop_price_heavyarmor20",         "14000", "Price of Heavy Armor +20");
	HeavyArmor25Price = AutoExecConfig_CreateConVar("sm_cashshop_price_heavyarmor25",         "16000", "Price of Heavy Armor +25");
	Armor10Price = AutoExecConfig_CreateConVar("sm_cashshop_price_armor10",                   "4000", "Price of Armor +10");
	Armor15Price = AutoExecConfig_CreateConVar("sm_cashshop_price_armor15",                   "5200", "Price of Armor +15");
	Armor20Price = AutoExecConfig_CreateConVar("sm_cashshop_price_armor20",                   "6400", "Price of Armor +20");
	Armor25Price = AutoExecConfig_CreateConVar("sm_cashshop_price_armor25",                   "7600", "Price of Armor +25");
	
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
		Menu menu = new Menu(Menu_CTShop);
		menu.SetTitle("Cash Shop");
		menu.AddItem("tactnades", "Tactical Grenade");
		menu.AddItem("harmor", "Heavy Armor");
		menu.AddItem("offnade", "Offensive Utility");
		menu.Display(client, MENU_TIME_FOREVER);
		return Plugin_Handled;
		
	}
	else if(CS_TEAM_T == p.Team)
	{
		Menu menu = new Menu(Menu_TShop);
		menu.SetTitle("Cash Shop");
		menu.AddItem("tactnades", "Tactical Grenades");
		menu.AddItem("armor", "Body Armor");
		menu.AddItem("pistols", "Pistols");
		menu.Display(client, MENU_TIME_FOREVER);
		return Plugin_Handled;
	}
	return Plugin_Handled;
}

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
			tgmenu.AddItem("weapon_flashbang",       "($5000)Flashbang");
			tgmenu.AddItem("weapon_smokegrenade",    "($5000)Smoke Grenade");
			tgmenu.AddItem("weapon_decoy",           "($5000)Decoy Grenade");
			tgmenu.AddItem("weapon_tagrenade",       "($5000)Tactical Awareness Grenade");
			tgmenu.Display(client, MENU_TIME_FOREVER);
			menu.ExitBackButton = true;
		}
		else if (StrEqual(info, "offnade"))
		{
			Menu tgmenu = new Menu(Menu_OffNades);
			tgmenu.SetTitle("Offensive Utility");
			tgmenu.AddItem("weapon_hegrenade",       "($8000)HE Grenade");
			tgmenu.AddItem("weapon_molotov",         "($8000)Molotov");
			tgmenu.AddItem("weapon_breachcharge",    "($12000)Breach Charge");
			tgmenu.AddItem("weapon_snowball",        "($100)Snowball");
			tgmenu.Display(client, MENU_TIME_FOREVER);
			menu.ExitBackButton = true;
		}
		else if (StrEqual(info, "harmor"))
		{
			Menu tgmenu = new Menu(Menu_HeavyArmor);
			tgmenu.SetTitle("Heavy Armor");
			tgmenu.AddItem("h1",                     "($10000)Add 10 Heavy Armor");
			tgmenu.AddItem("h2",                     "($12000)Add 15 Heavy Armor");
			tgmenu.AddItem("h3",                     "($14000)Add 20 Heavy Armor");
			tgmenu.AddItem("h4",                     "($16000)Add 25 Heavy Armor");
			tgmenu.Display(client, MENU_TIME_FOREVER);
			menu.ExitBackButton = true;
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
			tgmenu.AddItem("weapon_flashbang",       "($5000)Flashbang");
			tgmenu.AddItem("weapon_smokegrenade",    "($5000)Smoke Grenade");
			tgmenu.AddItem("weapon_decoy",           "($5000)Decoy Grenade");
			tgmenu.AddItem("weapon_tagrenade",       "($5000)Tactical Awareness Grenade");
			tgmenu.Display(client, MENU_TIME_FOREVER);
			menu.ExitBackButton = true;
		}
		else if (StrEqual(info, "armor"))
		{
			Menu tgmenu = new Menu(Menu_BodyArmor);
			tgmenu.SetTitle("Armor");
			tgmenu.AddItem("ba1",                   "($4000)Add 10 Body Armor");
			tgmenu.AddItem("ba2",                   "($5200)Add 15 Body Armor");
			tgmenu.AddItem("ba3",                   "($6400)Add 20 Body Armor");
			tgmenu.AddItem("ba4",                   "($7600)Add 25 Body Armor");
			tgmenu.Display(client, MENU_TIME_FOREVER);
			menu.ExitBackButton = true;
		}
		else if(StrEqual(info, "pistols"))
		{
			Menu tgmenu = new Menu(Menu_Pistols);
			tgmenu.SetTitle("Pistols");
			tgmenu.AddItem("weapon_glock",          "($16000)Glock");
			tgmenu.AddItem("weapon_cz75a",          "($18000)CZ75A");
			tgmenu.AddItem("weapon_deagle",         "($20000)Deagle");
			tgmenu.AddItem("weapon_revolver",       "($20000)BumpyBumpy");
			tgmenu.Display(client, MENU_TIME_FOREVER);
			menu.ExitBackButton = true;
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
		//itemNum is the position of the item the client selected.
		//This gets the strings you set in AddItem() and stores them in info and display
		menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
		if (StrEqual(info, "weapon_flashbang"))
		{
			if(p.Money >= FlashbangPrice.IntValue){
				p.Money -= FlashbangPrice.IntValue;
				GivePlayerWeapon(p, "weapon_flashbang");
			}
		}
		else if (StrEqual(info, "weapon_smokegrenade"))
		{
			if(p.Money >= SmokePrice.IntValue){
				p.Money -= SmokePrice.IntValue;
				GivePlayerWeapon(p, "weapon_smokegrenade");
			}
		}
		else if (StrEqual(info, "weapon_decoy"))
		{
			if(p.Money >= DecoyPrice.IntValue){
				p.Money -= DecoyPrice.IntValue;
				GivePlayerWeapon(p, "weapon_decoy");
			}
		}
		else if (StrEqual(info, "weapon_tagrenade"))
		{
			if(p.Money >= TactAwarePrice.IntValue){
				p.Money -= TactAwarePrice.IntValue;
				GivePlayerWeapon(p, "weapon_tagrenade");
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
		}
		else if (StrEqual(info, "weapon_molotov"))
		{
			if(p.Money >= MolotovPrice.IntValue){
				p.Money -= MolotovPrice.IntValue;
				GivePlayerWeapon(p, "weapon_molotov");
			}
		}
		else if (StrEqual(info, "weapon_breachcharge"))
		{
			if(p.Money >= BreachChargePrice.IntValue){
				p.Money -= BreachChargePrice.IntValue;
				GivePlayerWeapon(p, "weapon_breachcharge");
			}
		}
		else if (StrEqual(info, "weapon_snowball"))
		{
			if(p.Money >= SnowballPrice.IntValue){
				p.Money -= SnowballPrice.IntValue;
				GivePlayerWeapon(p, "weapon_snowball");
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
		if (StrEqual(info, "h1"))
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
		}
		else if (StrEqual(info, "h2"))
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
		}
		else if (StrEqual(info, "h3"))
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
		}
		else if (StrEqual(info, "h4"))
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
		if (StrEqual(info, "ba1"))
		{
			if(p.Money >= Armor10Price.IntValue){
				p.Money -= Armor10Price.IntValue;
				p.Armor += 10;
				p.Helmet = false;
				p.HeavyArmor = false;
			}
		}
		else if (StrEqual(info, "ba2"))
		{
			if(p.Money >= Armor15Price.IntValue){
				p.Money -= Armor15Price.IntValue;
				p.Armor += 15;
				p.Helmet = false;
				p.HeavyArmor = false;
			}
		}
		else if (StrEqual(info, "ba3"))
		{
			if(p.Money >= Armor20Price.IntValue){
				p.Money -= Armor20Price.IntValue;
				p.Armor += 20;
				p.Helmet = false;
				p.HeavyArmor = false;
			}
		}
		else if (StrEqual(info, "ba4"))
		{
			if(p.Money >= Armor25Price.IntValue){
				p.Money -= Armor25Price.IntValue;
				p.Armor += 25;
				p.Helmet = false;
				p.HeavyArmor = false;
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
			}
			else if (StrEqual(info, "weapon_cz75a"))
			{
				if(p.Money >= CZ75Price.IntValue){
					p.Money -= CZ75Price.IntValue;
					CWeapon czwep = GivePlayerWeapon(p, "weapon_cz75a");
					czwep.Ammo = 6;
					czwep.ReserveAmmo = 0;
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
			}
			else if (StrEqual(info, "weapon_revolver"))
			{
				if(p.Money >= BumpyPrice.IntValue){
					p.Money -= BumpyPrice.IntValue;
					CWeapon r8wep = GivePlayerWeapon(p, "weapon_revolver");
					r8wep.Ammo = 1;
					r8wep.ReserveAmmo = 0;
				}
			}
		}
		else
		{
			PrintToChat(client, "[SM] You already have a secondary!");
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

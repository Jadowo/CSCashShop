#pragma semicolon 1

#include <sourcemod>
#include <ccsplayer>
#include <sdktools>
#include <sdkhooks>

#pragma newdecls required

public Plugin myinfo = 
{
	name = "Cash Shop",
	author = "Jadow",
	description = "Use in game money to buy things",
	version = "0.1",
	url = ""
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_tshop", Command_TCashShop);
	RegConsoleCmd("sm_ts", Command_TCashShop);
	RegConsoleCmd("sm_ctshop", Command_CTCashShop);
	RegConsoleCmd("sm_cts", Command_CTCashShop);
	PrecacheModel("models/player/custom_player/legacy/tm_phoenix_heavy.mdl");
}

public Action Command_CTCashShop(int client, int args)
{
	Menu menu = new Menu(Menu_CTShop);
	menu.SetTitle("Cash Shop");
	menu.AddItem("harmor", "Heavy Armor");
	menu.AddItem("tactnades", "Tactical Grenade");
	menu.AddItem("offnade", "Offensive Utility");
	menu.Display(client, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

public Action Command_TCashShop(int client, int args)
{
	Menu menu = new Menu(Menu_TShop);
	menu.SetTitle("Cash Shop");
	menu.AddItem("armor", "Body Armor");
	menu.AddItem("pistols", "Pistols");
	menu.AddItem("tactnades", "Tactical Grenades");
	
	menu.Display(client, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

public int Menu_CTShop(Menu menu, MenuAction action, int client, int itemNum)
{
	if (action == MenuAction_Select)
	{
		CCSPlayer p = CCSPlayer(client);
		if (CS_TEAM_CT == p.Team)
		{
			char info[32], display[64];
			menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
			if (StrEqual(info, "tactnades"))
			{
				Menu tgmenu = new Menu(Menu_TactNades);
				tgmenu.SetTitle("Tactical Grenades");
				tgmenu.AddItem("weapon_flashbang", "Flashbang");
				tgmenu.AddItem("weapon_smokegrenade", "Smoke Grenade");
				tgmenu.AddItem("weapon_decoy", "Decoy Grenade");
				tgmenu.AddItem("weapon_tagrenade", "Tactical Awareness Grenade");
				tgmenu.Display(client, MENU_TIME_FOREVER);
			}
			else if (StrEqual(info, "offnade"))
			{
				Menu tgmenu = new Menu(Menu_OffNades);
				tgmenu.SetTitle("Offensive Utility");
				tgmenu.AddItem("weapon_hegrenade", "HE Grenade");
				tgmenu.AddItem("weapon_molotov", "Molotov");
				tgmenu.AddItem("weapon_breachcharge", "Breach Charge");
				tgmenu.AddItem("weapon_snowball", "Snowball");
				tgmenu.Display(client, MENU_TIME_FOREVER);
			}
			else if (StrEqual(info, "harmor"))
			{
				Menu tgmenu = new Menu(Menu_HeavyArmor);
				tgmenu.SetTitle("Heavy Armor");
				tgmenu.AddItem("h1", "Add 10 Heavy Armor");
				tgmenu.AddItem("h2", "Add 15 Heavy Armor");
				tgmenu.AddItem("h3", "Add 20 Heavy Armor");
				tgmenu.AddItem("h4", "Add 25 Heavy Armor");
				tgmenu.Display(client, MENU_TIME_FOREVER);
			}
		}
		else
		{
			PrintToChat(client, "You are not on CT!");
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
		CCSPlayer p = CCSPlayer(client);
		if (CS_TEAM_T == p.Team)
		{
			char info[32], display[64];
			menu.GetItem(itemNum, info, sizeof(info), _, display, sizeof(display));
			if (StrEqual(info, "tactnades"))
			{
				Menu tgmenu = new Menu(Menu_TactNades);
				tgmenu.SetTitle("Tactical Grenades");
				tgmenu.AddItem("weapon_flashbang", "Flashbang");
				tgmenu.AddItem("weapon_smokegrenade", "Smoke Grenade");
				tgmenu.AddItem("weapon_decoy", "Decoy Grenade");
				tgmenu.AddItem("weapon_tagrenade", "Tactical Awareness Grenade");
				tgmenu.Display(client, MENU_TIME_FOREVER);
			}
			else if (StrEqual(info, "armor"))
			{
				Menu tgmenu = new Menu(Menu_BodyArmor);
				tgmenu.SetTitle("Armor");
				tgmenu.AddItem("ba1", "Add 10 Body Armor");
				tgmenu.AddItem("ba2", "Add 15 Body Armor");
				tgmenu.AddItem("ba3", "Add 20 Body Armor");
				tgmenu.AddItem("ba4", "Add 25 Body Armor");
				tgmenu.Display(client, MENU_TIME_FOREVER);
			}
			else if(StrEqual(info, "pistols"))
			{
				Menu tgmenu = new Menu(Menu_Pistols);
				tgmenu.SetTitle("Pistols");
				tgmenu.AddItem("weapon_glock", "Glock");
				tgmenu.AddItem("weapon_cz75a", "CZ75A");
				tgmenu.AddItem("weapon_deagle", "Deagle");
				tgmenu.AddItem("weapon_revolver", "BumpyBumpy");
				tgmenu.Display(client, MENU_TIME_FOREVER);
			}
		}
		else
		{
			PrintToChat(client, "You are not on T!");
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
		int fb, sg, dc, tg;
		fb = 5000;
		sg = 5000;
		dc = 5000;
		tg = 5000;
		if (StrEqual(info, "weapon_flashbang"))
		{
			if(p.Money >= fb){
				p.Money -= fb;
				GivePlayerWeapon(p, "weapon_flashbang");
			}
		}
		else if (StrEqual(info, "weapon_smokegrenade"))
		{
			if(p.Money >= sg){
				p.Money -= sg;
				GivePlayerWeapon(p, "weapon_smokegrenade");
			}
		}
		else if (StrEqual(info, "weapon_decoy"))
		{
			if(p.Money >= dc){
				p.Money -= dc;
				GivePlayerWeapon(p, "weapon_decoy");
			}
		}
		else if (StrEqual(info, "weapon_tagrenade"))
		{
			if(p.Money >= tg){
				p.Money -= tg;
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
		int he, mt, bc, sb;
		he = 5500;
		mt = 5500;
		bc = 5500;
		sb = 2500;
		if (StrEqual(info, "weapon_hegrenade"))
		{
			if(p.Money >= he){
				p.Money -= he;
				GivePlayerWeapon(p, "weapon_hegrenade");
			}
		}
		else if (StrEqual(info, "weapon_molotov"))
		{
			if(p.Money >= mt){
				p.Money -= mt;
				GivePlayerWeapon(p, "weapon_molotov");
			}
		}
		else if (StrEqual(info, "weapon_breachcharge"))
		{
			if(p.Money >= bc){
				p.Money -= bc;
				GivePlayerWeapon(p, "weapon_breachcharge");
			}
		}
		else if (StrEqual(info, "weapon_snowball"))
		{
			if(p.Money >= sb){
				p.Money -= sb;
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
		int ha1, ha2, ha3, ha4;
		ha1 = 52000;
		ha2 = 56000;
		ha3 = 60000;
		ha4 = 64000;
		if (StrEqual(info, "h1"))
		{
			if(p.Money >= ha1){
				p.Money -= ha1;
				char sModel[PLATFORM_MAX_PATH];
				p.GetModel(sModel, sizeof(sModel));
				p.Armor += 10;
				p.Helmet = true;
				p.HeavyArmor = true;
				p.SetModel(sModel);
			}
		}
		else if (StrEqual(info, "h2"))
		{
			if(p.Money >= ha2){
				p.Money -= ha2;
				char sModel[PLATFORM_MAX_PATH];
				p.GetModel(sModel, sizeof(sModel));
				p.Armor += 15;
				p.Helmet = true;
				p.HeavyArmor = true;
				p.SetModel(sModel);
			}
		}
		else if (StrEqual(info, "h3"))
		{
			if(p.Money >= ha3){
				p.Money -= ha3;
				char sModel[PLATFORM_MAX_PATH];
				p.GetModel(sModel, sizeof(sModel));
				p.Armor += 20;
				p.Helmet = true;
				p.HeavyArmor = true;
				p.SetModel(sModel);
			}
		}
		else if (StrEqual(info, "h4"))
		{
			if(p.Money >= ha4){
				p.Money -= ha4;
				char sModel[PLATFORM_MAX_PATH];
				p.GetModel(sModel, sizeof(sModel));
				p.Armor += 25;
				p.Helmet = true;
				p.HeavyArmor = true;
				p.SetModel(sModel);
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
		int a1, a2, a3, a4;
		a1 = 42000;
		a2 = 46000;
		a3 = 50000;
		a4 = 54000;
		if (StrEqual(info, "ba1"))
		{
			if(p.Money >= a1){
				p.Money -= a1;
				p.Armor += 10;
				p.Helmet = false;
				p.HeavyArmor = false;
			}
		}
		else if (StrEqual(info, "ba2"))
		{
			if(p.Money >= a2){
				p.Money -= a2;
				p.Armor += 15;
				p.Helmet = false;
				p.HeavyArmor = false;
			}
		}
		else if (StrEqual(info, "ba3"))
		{
			if(p.Money >= a3){
				p.Money -= a3;
				p.Armor += 20;
				p.Helmet = true;
				p.HeavyArmor = false;
			}
		}
		else if (StrEqual(info, "ba4"))
		{
			if(p.Money >= a4){
				p.Money -= a4;
				p.Armor += 25;
				p.Helmet = true;
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
		int gk, cz, dg, r8;
		gk = 500;
		cz = 500;
		dg = 500;
		r8 = 500;
		if (StrEqual(info, "weapon_glock"))
		{
			if(p.Money >= gk){
				p.Money -= gk;
				CWeapon gkwep = GivePlayerWeapon(p, "weapon_glock");
				gkwep.Ammo = 10;
				gkwep.ReserveAmmo = 0;
			}
		}
		else if (StrEqual(info, "weapon_cz75a"))
		{
			if(p.Money >= cz){
				p.Money -= cz;
				CWeapon czwep = GivePlayerWeapon(p, "weapon_cz75a");
				czwep.Ammo = 6;
				czwep.ReserveAmmo = 0;
			}
		}
		else if (StrEqual(info, "weapon_deagle"))
		{
			if(p.Money >= dg){
				p.Money -= dg;
				CWeapon dgwep = GivePlayerWeapon(p, "weapon_deagle");
				dgwep.Ammo = 3;
				dgwep.ReserveAmmo = 0;
			}
		}
		else if (StrEqual(info, "weapon_revolver"))
		{
			if(p.Money >= r8){
				p.Money -= r8;
				CWeapon r8wep = GivePlayerWeapon(p, "weapon_revolver");
				r8wep.Ammo = 4;
				r8wep.ReserveAmmo = 0;
			}
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}
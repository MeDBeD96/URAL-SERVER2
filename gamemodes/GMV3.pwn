//////////////////////////////////////////////////////////////////
/*
Онлайн организации не показывает


АРЕНДА МОПЕДА: 	1. Сделать таймер для аренды мопедов (переменная для отсчета времени оставшейся аренды (чтобы при перезаходе можно было сесть на свой мопед))
				2. Мопед надо вернуть, иначе штраф.
				3. Плюсовать к аренде сумму за бензин и за поломки.
    
Сделать систему ограблений (система масок) (Как скрываться?)
Как получить оружие? Система создания оружия

СИСТЕМА АВТОРЫНКА:  1. Добавить команду, чтобы продавать игроку
					2. Сделать координаты мест в автосалоне, где будет стоять транспорт
					3. Игрок должен заказать машину, транспортники привозят заказанные машины с завода
     
СИСТЕМА ОРГАНИЗАЦИЙ:  	1. Лидер сам выдает деньги членам организации
						2. Деньги поступают из бюджета, который формируется за счет деятельности организаций
						3. Надо пополнять запасы бензина из бюджета организации
						4. Лидер устанавливает скин игроку, сделать массив со скинами для каждой организации
						5. Чтобы вступить в организацию нужно выучиться в универе, переменные для каждой фракции. 
      
APED 'Angel Pine Electrical Document':  1. Можно открыть раздвигающиеся ворота дистанционно.
										2. Сделать батарею, которая разряжается. Заряжать можно дома и в каких нибудь местах. 

Система смерти, ранений и тд.

Полиция: 	1. Шипы для прокола колёс 
			2. Могут отключать двигатель преступнику дистанционно через APED

Финансы: 1. Можно брать кредит с 18 лет и если есть работа 

Система голода: максимально 7 часов

Учиться разным стилям боя

Система усталости: 	
					
					3. Усталость снимать дома или выпив кофе 
					5. 2 переменные: текущая усталость и максимальная, максимальная может увеличиваться от занятий спортом, мед.прлцедур, принятие душа и уменьшаться при смерти 
					Максимальная = 7 часов, из которых последний час нельзя бегать 

Система дома: 	1. Дома можно снять усталость 
				2. Если дверь закрыта другой человек может постучать, если открыта - сразу войти 
				3. Сделать переменную с классом дома, чем выше класс, тем меньше спать 
*/
// new check [4];		format(check,sizeof(check),"%d", IdleTime[playerid]); 		GameTextForPlayer(playerid, check, 1000, 3);
/////////////////////////////////////////////////////////////////

#include <a_samp>
#include <foreach>  
#include <a_actor>
#include <mxINI>
#include <streamer>
#include <sscanf2>
#include <izcmd>
#include <objects>
#include <keypad>

main()
{}

#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_ORANGE 0xFF8000AA
#define COLOR_BRIGHTRED 0xDB0000F6
#define COLOR_PROX 0xDFBB43FF

#define COL_WHITE "{FFFFFF}"
#define COL_BLUE "{00BFFF}"
#define COL_ORANGE "{ffcc00}"
#define COL_APED "{86a6ff}"
#define COL_YELLOW "{F3FF02}"
#define COL_RED "{A80000}"
#define COL_GREEN "{09ff00}"
#define COL_STATUS1 "{1aec29}"
#define COL_STATUS2 "{b5ec1a}"
#define COL_STATUS3 "{e1e306}"
#define COL_STATUS4 "{fff400}"
#define COL_STATUS5 "{ff9a00}"
#define COL_STATUS6 "{ff1010}"

#define NALOG_BUYCAR 10

#define CENA_BENZ 31
#define CENA_WOOD 1
#define CENA_ARENDI 1
#define CENA_APED 100

#define TIME_IDLE 300 // время для срабатывания рандомной анимации при стоянии
#define TIME_VAULTDOORCLOSE 300

#define KEYPAD_POLICE 1
#define KEYPAD_POLICE2 2
#define KEYPAD_BANKDOOR 3
#define KEYPAD_BANKDOOR2 4
#define KEYPAD_VAULTDOOR 5
#define KEYPAD_VAULTGATE 6
#define KEYPAD_FIREDOOR 7
#define KEYPAD_FIREDOOR2 8
#define KEYPAD_BANKDOOR3 9

#define VBUYTOBUY 0
#define VBUYTOCONGRESS 1
#define VBUYTOPOLICE 2
#define VBUYTOAMBULANCE 3
#define VBUYTOFIRE 4
#define VBUYTOVEH 5
#define VBUYTOLOGISTIC 6
#define VBUYTONEWS 7
#define VBUYTOSELL 50
#define VBUYTOCARKEY 100
#define VBUYTORENT 150

#undef MAX_PLAYERS
#define MAX_PLAYERS 5
#undef MAX_VEHICLES
#define MAX_VEHICLES 100
#define Name(%1) PlayerInfo[%1][pName]
#define MAX_HOUSES 50
#define MAX_ENTERS 50
#define MAX_CHECKPOINTS 23

#define ONEHOURS 3600
#define TWOHOURS 7200
#define THREEHOURS 10800
#define FOURHOURS 14400
#define FIVEHOURS 18000
#define SIXHOURS 21600
#define SEVENHOURS 25200
#define TENHOURS 36000

#define PROCESSOR_UPDATE 1000
#define FUEL_TIME 36000

#define forEx(%0,%1) for(new %1=0;%1<%0;%1++)
#define FERRIS_WHEEL_WAIT_TIME 1000     //Wait Time to enter a Cage
#define FERRIS_WHEEL_SPEED 0.007        //Speed of turn (Standart 0.005)

#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define PRESSING(%0,%1) \
	(%0 & (%1))
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

new Float:gFerrisCageOffsets[10][3]={{0.0699,0.0600,-11.7500},{-6.9100,-0.0899,-9.5000},{11.1600,0.0000,-3.6300},{-11.1600,-0.0399,3.6499},{-6.9100,-0.0899,9.4799},
	{0.0699,0.0600,11.7500},{6.9599,0.0100,-9.5000},{-11.1600,-0.0399,-3.6300},{11.1600,0.0000,3.6499},{7.0399,-0.0200,9.3600}},
    FerrisWheelObjects[12],
    Float:FerrisWheelAngle=0.0,
    FerrisWheelAlternate=0;
	
const
    MAX_FRACTIONS = 8,
    MAX_FRACTION_NAME_LENGTH = 50;
    
static const fraction_name[MAX_FRACTIONS][MAX_FRACTION_NAME_LENGTH] =
{
	{""COL_RED"Снять игрока с лидерства"},
    {"Конгресс округа 'Angel Pine'"},
    {"Департамент полиции округа 'Angel Pine'"},
	{"Министерство здравоохранения округа 'Angel Pine'"},
	{"Пожарный департамент округа 'Angel Pine'"},
	{"Транспортная компания округа 'Angel Pine'"},
	{"Логистическая компания округа 'Angel Pine'"},
	{"Новостное агенство округа 'Angel Pine'"}
};


new bool:PAccount[MAX_PLAYERS];
new bool:gPlayerLogged[MAX_PLAYERS];
new bool:SpecON[MAX_PLAYERS];
new bool:engine,lights,alarm,doors,bonnet,boot,objective;
new bool:animloading[MAX_PLAYERS];
new bool:Engine[MAX_VEHICLES];

new bool:PlayerRun[MAX_PLAYERS];

new Text:box[MAX_PLAYERS],Text:speed[MAX_PLAYERS],Text:fuel[MAX_PLAYERS];
new bool:IsPlayerBlackScreen[MAX_PLAYERS];
new blackmap; // чтобы карта стала черной

new 
    FonTimer[MAX_PLAYERS], 
    FonBox[MAX_PLAYERS], 
    PlayerText: fon_PTD[MAX_PLAYERS];  

new drev = 0; // для системы дерева
new kazna = 0; // для системы казны

new ActorWoodMan;
new ActorKapitoliyWomen;
new IDFrac[MAX_PLAYERS] = 0;
new IDLeader = 0;
new Text3D:sellveh[MAX_VEHICLES];
new RentCar[MAX_PLAYERS];
new PlayerMoney[MAX_PLAYERS];  // для античита 
new inputfuel[MAX_PLAYERS];
new PlayerTimerID[MAX_PLAYERS]; // индивидуальные таймеры 
new PlayerTimerIDTimer1Second; 

new bool:ClockIsOn[MAX_PLAYERS]; 
new bool:MapIsOn[MAX_PLAYERS]; 

new Text: skin[3];  //// Для скинов
new cskin[MAX_PLAYERS]; ////
new ManSkinList[4] = { 23, 35, 66, 95 }; ////	
new WomanSkinList[4] = { 148, 169, 196, 225 }; ////

new FixCarTime[MAX_PLAYERS]; // время починки
new IdleTime[MAX_PLAYERS]; // время стояния на месте

// двери, ворота время
new VaultDoorTime, LSPDGateTime, BankGateTime, CongressGateTime, FixGateTime, FixGate2Time; 
// двери, ворота id
new LSPDDoor, LSPDDoor2, BankGate, LSPDGate, BankDoor, BankDoor2, BankDoor3,
VaultGate, VaultDoor, CongressGate, FixGate, FixGate2, FireDoor, FireDoor2;
// двери, ворота состояние
new bool:LSPDDoorOpen, LSPDDoor2Open, BankDoorOpen, BankDoor2Open, BankDoor3Open, VaultDoorOpen, VaultGateOpen,
LSPDGateOpen, BankGateOpen, CongressGateOpen, FixGateOpen, FixGate2Open, FireDoorOpen, FireDoor2Open;


enum pInfo
{
    pName[MAX_PLAYER_NAME+1],
    pPass[64],
    pAdmin,
	pMoney,
	pSex,
	pSkin,
	pReg,
	Float:pPos_x,
	Float:pPos_y,
	Float:pPos_z,
	Float:pFa,
	pInt,
	pWorld,
	pCarKey,
	pMoneyDolg,
	pMember,
	pLeader,
	pJob,
	pMemberSkin,
	pRank,
	pMemberWarn,
	pRankName[32],
	pAPED,
	pAPEDBattery,
	pHunger,
	pEndurance,
	pEnduranceMax
}
new PlayerInfo[MAX_PLAYERS][pInfo];


enum vInfo
{
    vAdd,// Проверка на созданную машину
    vID,// Ид Машины
    vModel,// Модель Машины
    Float:vVx,// Позиция X
    Float:vVy,// Позиция Y
    Float:vVz,// Позиция Z
    Float:vVa,// Угол поворота A
    vColor,// Цвет 1
    vColor2,// Цвет 2
    vOwner[32],//владелец
    vPrice,
    vBuy,
    vLock,
    vFuel
}
new Veh[MAX_VEHICLES][vInfo];
new LastCar;// Максимальное колличество авто

enum HouseInfo//Naming the enum
{
    hAdd,
    hOwner[32], 
    hPrice,
	Float:hEnterX, 
    Float:hEnterY,
    Float:hEnterZ,
    Float:hEnterA,
    Float:hExitX,
    Float:hExitY,
    Float:hExitZ,
    Float:hExitA,
    hInt, 
    hVirt, 
    hOwned,
    hLock
}
new House[MAX_HOUSES][HouseInfo];//This is the var where we will read the house info.
new HouseEnter[MAX_HOUSES];
new HouseExit[MAX_HOUSES];
new LastHouse;

enum eInfo
{
    eAdd,
	Float:eEnterX,
    Float:eEnterY,
    Float:eEnterZ,
    Float:eEnterA,
    Float:eExitX,
    Float:eExitY,
    Float:eExitZ,
    Float:eExitA,
    eEnterInt,
    eEnterVirt,
	eExitInt,
    eExitVirt,
	eDesc[64]
	
};
new EnterInfo[MAX_ENTERS][eInfo];
new LastEnter;

enum
{
    DIALOG_ID_NONE, // 0
    DIALOG_ID_LOGIN, // 1
    DIALOG_ID_REGISTER,
	DIALOG_ID_KICK,
	DIALOG_ID_BAN,
	DIALOG_ID_CHOOSESEX,
	DIALOG_ID_BUYCAR,
	DIALOG_ID_VMENU,
	DIALOG_ID_REFILL,
	DIALOG_ID_WOODSTART,	
	DIALOG_ID_WOODSTOP,	
	DIALOG_ID_HOUSEENTER,
	DIALOG_ID_HOUSEEXIT,
	DIALOG_ID_SETLEADER,
	DIALOG_ID_SETLEADERRANK,
	DIALOG_ID_INVITEMEMBERYESNO,	
	DIALOG_ID_LMENU,
	DIALOG_ID_BACKTOLMENU,	
	DIALOG_ID_INVITEMEMBER,
	DIALOG_ID_LAYOFFMEMBER,
	DIALOG_ID_WARNMEMBER,
	DIALOG_ID_UNWARNMEMBER,
	DIALOG_ID_SETMEMBERRANK,
	DIALOG_ID_SETMEMBERRANKNAME,
	DIALOG_ID_SETMEMBERSKINID,
	DIALOG_ID_SETMEMBERSKIN,
	DIALOG_ID_RENTMOPED,
	DIALOG_ID_RENTMOPEDON,
	DIALOG_ID_GETAPED,
	DIALOG_ID_SELLCAR,
	DIALOG_ID_SELLCARPRICE,
	DIALOG_ID_SELLCARSUCCESS,
	DIALOG_ID_CHANGECLOTHES,
	DIALOG_ID_REASONUNLEADER,
	DIALOG_ID_PLAYERINFODIALOG,
	DIALOG_ID_APEDMENU,
	DIALOG_ID_APEDSETTINGS,
	DIALOG_ID_VIEWONLINEFRACTION,
};
#define DIALOG_TYPE_MAIN 20044
#define D_S_M DIALOG_STYLE_MSGBOX 
#define D_S_I DIALOG_STYLE_INPUT 
#define D_S_L DIALOG_STYLE_LIST 
#define D_S_P DIALOG_STYLE_PASSWORD 
#define D_S_T DIALOG_STYLE_TABLIST 
#define D_S_TH DIALOG_STYLE_TABLIST_HEADERS 


new VehicleNames[212][] = {
"Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster","Stretch","Manana","Infernus",
"Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Mr Whoopee","BF Injection",
"Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie",
"Stallion","Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
"Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
"Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina",
"Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood",
"Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa","RC Goblin","Hotring A","Hotring B",
"Bloodring Banger","Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain",
"Nebula","Majestic","Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent","Bullet","Clover",
"Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A",
"Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer",
"Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer A","Emperor",
"Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","Police Car","Police Car",
"Police Car","Police Ranger","Picador","S.W.A.T.","Alpha","Phoenix","Glendale","Sadler","L Trailer A","L Trailer B",
"Stair Trailer","Boxville","Farm Plow","U Trailer" };


new Float:RandomWood[6][3] =
{
    {-1630.6060,-2265.3108,33.8456},
    {-1631.8427,-2262.9824,33.1357},
    {-1620.1628,-2264.4209,33.0345},
    {-1618.9866,-2266.9070,33.5378},
    {-1635.1318,-2271.2375,35.3855},
    {-1633.7534,-2274.3398,36.3376}
};
new WoodRand[MAX_PLAYERS];




public OnGameModeInit()
{
    LoadWood();	
	LoadKazna();
	LoadHouses();
    ObjectLoad();
    LoadEnters();
	LoadVeh();
	
	ManualVehicleEngineAndLights();
    DisableInteriorEnterExits();
    SetNameTagDrawDistance(10.0);
    LimitGlobalChatRadius(0.0);
    ShowPlayerMarkers(0);
    EnableStuntBonusForAll(0);
	UsePlayerPedAnims();
	
    SetTimer("Processor",PROCESSOR_UPDATE,true);
    SetTimer("SpeedoUpdate",100,true);
	SetTimer("RotateFerrisWheel",FERRIS_WHEEL_WAIT_TIME,false);
	SetTimer("FuelTime", FUEL_TIME, true);
	
	SetGameModeText("GameMode v2.0");
	
    for(new i = 0; i < sizeof(EnterInfo); i++)
    {
        if(EnterInfo[i][eEnterX] != 0 && EnterInfo[i][eEnterY] != 0 && EnterInfo[i][eExitX] != 0 && EnterInfo[i][eExitY] != 0)
        {
         	Create3DTextLabel(EnterInfo[i][eDesc], COLOR_PROX, EnterInfo[i][eEnterX], EnterInfo[i][eEnterY], EnterInfo[i][eEnterZ] + 0.5, 7.0,  EnterInfo[i][eEnterVirt], 0);
			CreatePickup(1272, 23, EnterInfo[i][eEnterX], EnterInfo[i][eEnterY], EnterInfo[i][eEnterZ], EnterInfo[i][eEnterVirt]);
			CreatePickup(1272, 23, EnterInfo[i][eExitX], EnterInfo[i][eExitY], EnterInfo[i][eExitZ], EnterInfo[i][eExitVirt]);
        }
    }
	
	for(new i = 0; i < sizeof(House); i++)
    {
        if(House[i][hEnterX] != 0 && House[i][hEnterY] != 0 && House[i][hExitX] != 0 && House[i][hExitY] != 0)
        {
			CreatePickup(1273, 23, House[i][hEnterX], House[i][hEnterY], House[i][hEnterZ], 0);
			CreatePickup(1273, 23, House[i][hExitX], House[i][hExitY], House[i][hExitZ], House[i][hVirt]);
        }
    }
    
	CreatePickupWith3DText(1581, 362.6556,173.5869,1008.3828, "Получение APED\n>> Нажмите Y <<", 0, 5.0);
	CreatePickupWith3DText(1274, -1630.8824,-2234.4985,31.4766, "Работа дровосеком\n>> Нажмите Y <<", 0, 5.0);
	CreatePickupWith3DText(1212, 2537.3064,-1286.8135,1054.6406, "Продажа транспорта\n>> Нажмите Y <<", 0, 5.0);
	CreatePickupWith3DText(1212, -2032.7780,-116.5089,1035.1719, "Аренда транспорта\n>> Нажмите Y <<", 0, 5.0);
	CreatePickupWith3DText(1650, -2234.2949,-2568.0117,32.1219, "Автозаправочная станция\n>> Нажмите H <<", 0, 15.0);
	CreatePickupWith3DText(1650, -1541.2645,-2742.2102,48.7381, "Автозаправочная станция\n>> Нажмите H <<", 0, 15.0);
	CreatePickupWith3DText(1275, 254.8472,77.0973,1003.6406, "Раздевалка\n>> Нажмите Y <<", 0, 4.0); 
	CreatePickupWith3DText(1275, 267.0403,118.3147,1004.6172, "Раздевалка\n>> Нажмите Y <<", 0, 4.0); 	
	CreatePickupWith3DText(1275, 350.9631,188.9638,1019.9844, "Раздевалка\n>> Нажмите Y <<", 1, 4.0);
	
	
	
	LSPDDoor = CreateObject(1536,250.4500000,62.7500000,1002.6000000,0.0000000,0.0000000,90.0000000); //object(gen_doorext15) (3)
	LSPDDoor2 = CreateObject(1536,245.8000000,72.3500000,1002.6000000,0.0000000,0.0000000,0.0000000); //object(gen_doorext15) (8)
	BankGate = CreateObject(980, -2152.1001000,-2393.1001000,32.4000000,0.0000000,0.0000000,140.5000000); //object(subwaygate) (1)
	LSPDGate = CreateObject(980,-2090.0000000,-2322.2998000,32.4000000,0.0000000,0.0000000,51.7400000); //object(subwaygate) (3)
	BankDoor = CreateObject(3089, 2150.3604000,1605.7998000,1006.5200000,0.0000000,0.0000000,0.0000000); //object(ab_casdorlok) (3)
	BankDoor2 = CreateObject(3089, 2147.0801000,1604.7000000,1006.5000000,0.0000000,0.0000000,0.0000000); //object(ab_casdorlok) (4)
	BankDoor3 = CreateObject(3089,2149.8301000,1603.6000000,1002.3000000,0.0000000,0.0000000,270.0000000); //object(ab_casdorlok) (2)
	VaultGate = CreateObject(975,2141.5000000,1606.9000000,994.2000100,0.0000000,0.0000000,180.0000000); //object(columbiangate) (1)
	VaultDoor = CreateObject(2634,2144.2000000,1627.0000000,994.2600100,0.0000000,0.0000000,180.0000000); //object(ab_vaultdoor) (1)
	CongressGate = CreateObject(980,-2046.3000000,-2507.1001000,32.8000000,0.0000000,0.0000000,317.2500000); //object(airportgate) (1)
	FixGate = CreateObject(5020,-2397.3999000,-2194.2000000,34.0000000,0.0000000,0.0000000,274.7500000); //object(mul_las) (2)
	FixGate2 = CreateObject(5020,-2388.2000000,-2180.8999000,34.0300000,0.0000000,0.0000000,274.7460000); //object(mul_las) (4)
	FireDoor = CreateObject(1536,253.1000100,108.5800000,1002.2000000,0.0000000,0.0000000,90.0000000); //object(gen_doorext15) (12)
	FireDoor2 = CreateObject(1536,239.7500000,118.0900000,1002.2000000,0.0000000,0.0000000,270.0000000); //object(gen_doorext15) (15)
	
    ActorWoodMan = CreateActor(161, -1629.7593,-2233.2476,31.4766,135.0107);
    ApplyActorAnimation(ActorWoodMan, "PED", "idlestance_old", 3.9, 1, 0, 0, 0, 0);
    ActorKapitoliyWomen = CreateActor(216, 359.7169,173.6097,1008.3893,268.1367);
    ApplyActorAnimation(ActorKapitoliyWomen, "PED", "woman_idlestance", 3.9, 1, 0, 0, 0, 0);
	ConnectNPC("TrainDriverLV","train_lv");
    
    blackmap = GangZoneCreate(-3000.0,-3000.0,3000.0,3000.0);
	
	for(new v; v < MAX_VEHICLES; v++)// цикл машин
    {
        AddStaticVehicleEx(Veh[v][vModel],Veh[v][vVx],Veh[v][vVy],Veh[v][vVz],Veh[v][vVa],Veh[v][vColor],Veh[v][vColor2], 60000);
		if (Veh[v][vFuel] < 0) Veh[v][vFuel] = 0;
		if (Veh[v][vFuel] > 100) Veh[v][vFuel] = 100;
		
		SetVehicleParamsEx(v,false,false,false,Veh[v][vLock],false,false,false);
		Engine[v] = false;
		if(Veh[v][vAdd] == 1 && Veh[v][vBuy] == 0)
        {
			new string[50];
			format(string, sizeof(string), "Продается\nСтоимость: "COL_GREEN"%i $",Veh[v][vPrice]);
			sellveh[v] = Create3DTextLabel( string, COLOR_PROX, 0, 0, 0, 5.0, 0, 0 );
			Attach3DTextLabelToVehicle(Text3D:sellveh[v], v, 0.0, 0.0, 0.8);
        }
	}
	
	
	FerrisWheelObjects[10]=CreateObject(18877,-2109.0000000,-2397.0000000,44.3000000,0.0000000,0.0000000,322.0000000,300); // спицы
    FerrisWheelObjects[11]=CreateObject(18878,-2109.0000000,-2397.0000000,44.5000000,0.0000000,0.0000000,232.0000000,300); // колесо
    forEx((sizeof FerrisWheelObjects)-2,x)
	{
		FerrisWheelObjects[x]=CreateObject(18879,-2109.0000000,-2397.0000000,44.3000000,0.0000000,0.0000000,52.0000000,300); // кабинки
		AttachObjectToObject(FerrisWheelObjects[x], FerrisWheelObjects[10],gFerrisCageOffsets[x][0],gFerrisCageOffsets[x][1],gFerrisCageOffsets[x][2],0.0000000,0.0000000,52.0000000, 0);
	}
	
	skin[0] = TextDrawCreate(250.000000, 300.000000, "LD_BEAT:left"); 
    TextDrawBackgroundColor(skin[0], 255); 
    TextDrawFont(skin[0], 4); 
    TextDrawLetterSize(skin[0], 0.500000, 1.000000); 
    TextDrawColor(skin[0], -1); 
    TextDrawSetOutline(skin[0], 0); 
    TextDrawSetProportional(skin[0], 1); 
    TextDrawSetShadow(skin[0], 1); 
    TextDrawUseBox(skin[0], 1); 
    TextDrawBoxColor(skin[0], 255); 
    TextDrawTextSize(skin[0], 34.000000, 28.000000); 
    TextDrawSetSelectable(skin[0], true);//Данная функция добавлена в 0.3e, true - делает текстдрав кликабельным, false - отключает кликабельность 

    skin[1] = TextDrawCreate(360.000000, 300.000000, "LD_BEAT:right"); 
    TextDrawBackgroundColor(skin[1], 255); 
    TextDrawFont(skin[1], 4); 
    TextDrawLetterSize(skin[1], 0.500000, 1.000000); 
    TextDrawColor(skin[1], -1); 
    TextDrawSetOutline(skin[1], 0); 
    TextDrawSetProportional(skin[1], 1); 
    TextDrawSetShadow(skin[1], 1); 
    TextDrawUseBox(skin[1], 1); 
    TextDrawBoxColor(skin[1], 255); 
    TextDrawTextSize(skin[1], 34.000000, 28.000000); 
    TextDrawSetSelectable(skin[1], true); 

    skin[2] = TextDrawCreate(318.000000, 370.000000, FixText("Выбрать")); 
    TextDrawAlignment(skin[2], 2); 
    TextDrawBackgroundColor(skin[2], 255); 
    TextDrawFont(skin[2], 1); 
    TextDrawLetterSize(skin[2], 0.679999, 1.900000); 
    TextDrawColor(skin[2], -1); 
    TextDrawSetOutline(skin[2], 0); 
    TextDrawSetProportional(skin[2], 1); 
    TextDrawSetShadow(skin[2], 1); 
    TextDrawUseBox(skin[2], 1); 
    TextDrawBoxColor(skin[2], 0); 
    TextDrawTextSize(skin[2], 15.000000, 68.000000); 
    TextDrawSetSelectable(skin[2], true);  
	
	return 1;
}

public OnGameModeExit()
{
    foreach(Player, i)
	{
		if(IsPlayerConnected(i))
		{
			SavePlayer(i);
			gPlayerLogged[i] = false;
		}
	}
	
	forEx(sizeof FerrisWheelObjects,x)DestroyObject(FerrisWheelObjects[x]);
	
	TextDrawDestroy(skin[0]);TextDrawDestroy(skin[1]);TextDrawDestroy(skin[2]);//удаляем созданные текстдравы  
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	TogglePlayerSpectating(playerid, 1);
	SetSpawnInfo(playerid, 0, 0, PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z], PlayerInfo[playerid][pFa], 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
	ResetPlayerMoney(playerid); 
	
    for( new i = 0; i <= 20; i ++ ) SendClientMessage(playerid,COLOR_YELLOW,"");
	
    GetPlayerName(playerid, PlayerInfo[playerid][pName], MAX_PLAYER_NAME+1);
    new playername[MAX_PLAYER_NAME+1];// Масив для имени игрока

    new string[64];// Путь до папки с именем игрока
    GetPlayerName(playerid,playername,sizeof(playername));// Узнаём имя игрока
    format(string,sizeof(string),"Users/%s.ini", playername);// Путь к файлу с аккаунтом
    if(fexist(string))// Проверка на файл, если он есть то выполняется следующее действие.
    {
        PAccount[playerid] = true;// Аккаунт есть
    }
    else// Если файла с именем нет, то выполняется это действие.
    {
        PAccount[playerid] = false;// Аккаунта нет
    }

    if(!SpecON[playerid])
	{
	    TogglePlayerSpectating(playerid, true);
	    SetTimerEx("OnPlayerConnect", 300, 0, "i", playerid);
	    SpecON[playerid] = true;
	    return 1;
	}
	
	if(PAccount[playerid] == true)// Если аккаунт есть
    {
        ShowPlayerDialog(playerid,DIALOG_ID_LOGIN ,D_S_P,""COL_ORANGE"Окно Входа",""COL_BLUE"Добрый день!\nВаш аккаунт есть на сервере.\nВведите свой пароль в поле:","Ввод","Выход");
    }
    else// Если аккаунта нет
    {
        ShowPlayerDialog(playerid, DIALOG_ID_CHOOSESEX, D_S_M,""COL_ORANGE"Добро пожаловать на сервер",""COL_BLUE"бла-бла-бла\nВыберите ваш пол", "Мужской", "Женский");
    }
    
    gPlayerLogged[playerid] = false;
    ClearAnimations(playerid);
    animloading[playerid] = false;
	FonBox[playerid] = 0; 
    PlayerTextDrawDestroy(playerid, fon_PTD[playerid]);  
    
    PlayerInfo[playerid][pAdmin] = 0;
    PlayerInfo[playerid][pMoney] = 0;
    PlayerInfo[playerid][pSex] = 0;
    PlayerInfo[playerid][pSkin] = 0;
    PlayerInfo[playerid][pReg] = 0;
    PlayerInfo[playerid][pPos_x] = -2254.1497;
	PlayerInfo[playerid][pPos_y] = -2192.2520;
	PlayerInfo[playerid][pPos_z] = 34.9766;
	PlayerInfo[playerid][pFa] = 119.6331;
	PlayerInfo[playerid][pInt] = 0;
	PlayerInfo[playerid][pWorld] = 0;
	PlayerInfo[playerid][pCarKey] = 0;
	PlayerInfo[playerid][pMoneyDolg] = 0;
	PlayerInfo[playerid][pMember] = 0;
	PlayerInfo[playerid][pLeader] = 0;
	PlayerInfo[playerid][pJob] = 0;
	PlayerInfo[playerid][pMemberSkin] = 0;
	PlayerInfo[playerid][pRank] = 0;
	PlayerInfo[playerid][pMemberWarn] = 0;
	PlayerInfo[playerid][pRankName] = 0;
	PlayerInfo[playerid][pAPED] = 0;
	PlayerInfo[playerid][pAPEDBattery] = 0;
	PlayerInfo[playerid][pHunger] = 0;
	PlayerInfo[playerid][pEndurance] = 0;
	PlayerInfo[playerid][pEnduranceMax] = 0;
	
	//for(new pInfo:i; i<pInfo; ++i) PlayerInfo[playerid][i] = 0;  

    
    box[playerid] = TextDrawCreate(618,389,"_");
	TextDrawLetterSize(box[playerid],0.5,2.999999);
	TextDrawUseBox(box[playerid],1);
	TextDrawBoxColor(box[playerid],0x00000060);
	TextDrawTextSize(box[playerid],473,0);
	
	speed[playerid] = TextDrawCreate(478,389,"_");
	TextDrawLetterSize(speed[playerid],0.39,1.399999);
	TextDrawSetOutline(speed[playerid],1);
	
	fuel[playerid] = TextDrawCreate(478,404,"_");
	TextDrawLetterSize(fuel[playerid],0.39,1.399999);
	TextDrawSetOutline(fuel[playerid],1);
	
	PlayerTimerID[playerid] = SetTimerEx("PlayerUpdate", 200, 1, "d", playerid); 
	
	ObjectRemove(playerid);
	
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	ResetPlayerMoney(playerid); 
    TextDrawDestroy(box[playerid]);
	TextDrawDestroy(speed[playerid]);
	TextDrawDestroy(fuel[playerid]);
    SpecON[playerid] = false;
    SavePlayer(playerid);
    gPlayerLogged[playerid] = false;
	
	KillTimer(PlayerTimerID[playerid]);
	
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(PlayerInfo[playerid][pReg] == 1)
	{
		SetSkin(playerid);
		return 1;
	}
	if(PlayerInfo[playerid][pReg] == 2)
	{
		TogglePlayerSpectating(playerid, 0);
		SetPVarInt(playerid, "IsPlayerSpawn", 1);
		
		SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z]+0.5,
		PlayerInfo[playerid][pFa], 0, 0, 0, 0, 0, 0);
		SetPlayerPos(playerid,PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y],PlayerInfo[playerid][pPos_z] + 0.5);
		SetPlayerFacingAngle( playerid, PlayerInfo[playerid][pFa]); 
		SetPlayerInterior(playerid, PlayerInfo[playerid][pInt]);
		SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pWorld]);
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		SetCameraBehindPlayer(playerid);
		
		if(PlayerInfo[playerid][pAPED] == 0) GangZoneShowForPlayer(playerid, blackmap, 255);
		else 
		{
			GangZoneHideForPlayer(playerid, blackmap);
			TogglePlayerClock(playerid, 1);
			ClockIsOn[playerid] = true;
			MapIsOn[playerid] = true;
		}
		
		if(animloading[playerid] == false)
		{
			 PreloadAnimLib(playerid,"BOMBER");			 PreloadAnimLib(playerid,"RAPPING");			 PreloadAnimLib(playerid,"SHOP");			 PreloadAnimLib(playerid,"BEACH");
			 PreloadAnimLib(playerid,"SMOKING");			 PreloadAnimLib(playerid,"FOOD");			 PreloadAnimLib(playerid,"ON_LOOKERS");			 PreloadAnimLib(playerid,"DEALER");
			 PreloadAnimLib(playerid,"CRACK");			 PreloadAnimLib(playerid,"CARRY");			 PreloadAnimLib(playerid,"COP_AMBIENT");			 PreloadAnimLib(playerid,"PARK");
			 PreloadAnimLib(playerid,"INT_HOUSE");			 PreloadAnimLib(playerid,"FOOD");			 PreloadAnimLib(playerid,"CRIB");			 PreloadAnimLib(playerid,"ROB_BANK");
			 PreloadAnimLib(playerid,"JST_BUISNESS");			 PreloadAnimLib(playerid,"PED");			 PreloadAnimLib(playerid,"OTB");			 animloading[playerid] = true;
		}
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	DeletePVar(playerid, "IsPlayerSpawn");
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	Engine[vehicleid] = false;
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
    if(gPlayerLogged[playerid] != true || PlayerInfo[playerid][pReg] != 2) return 1;
	
    new string[145];
	
    format(string, sizeof(string), "%s говорит:"COL_WHITE" %s", Name(playerid), text);
    ProxDetector(playerid, COLOR_PROX, string, 10);
	
    SetPlayerChatBubble(playerid,text,COLOR_PROX,20.0,7000);
	
	GiveEndurance(playerid, -2);
	
    ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.1, 0, 1, 1, 1, 1, 1);
	
	
	
    SetTimerEx("ClearAnim", 2000, false, "d", playerid);
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    new veh = GetPlayerVehicleID(playerid);
    if (newstate == PLAYER_STATE_DRIVER)
	{
		if(Veh[veh][vBuy] == VBUYTOSELL)
	    {
			SendClientMessage(playerid,COLOR_WHITE,"Этот транспорт для дальнейшей продажи. Его необходимо припарковать.");
	    	return 1;
	    }
	    if(Veh[veh][vBuy] == VBUYTOBUY && Veh[veh][vPrice] > 0)
	    {
	    	new string[256];
	    	format(string,sizeof(string),""COL_BLUE"\nДанный транспорт выставлен на продажу.\nМодель: "COL_WHITE"%s\n"COL_BLUE"Стоимость: "COL_WHITE"%d $\n"COL_BLUE"Вы хотите\
			приобрести данный транспорт?\n",VehicleNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400], Veh[veh][vPrice]);
	    	ShowPlayerDialog(playerid,DIALOG_ID_BUYCAR,D_S_M,""COL_ORANGE"Авторынок",string,"Купить","Отмена");
	    	TogglePlayerControllable(playerid, 0);
	    	return 1;
	    }
	    if(Veh[veh][vBuy] == VBUYTORENT && GetPVarInt(playerid, "DostupRentCar"))
		{
		    ShowPlayerDialog(playerid, DIALOG_ID_RENTMOPEDON, D_S_M,""COL_ORANGE"Аренда мопеда",""COL_BLUE"Вы хотите взять в аренду данный мопед?\n", "Да", "Нет");
			RentCar[playerid] = veh;
			return 1;
		}
	    if(NoEngine(veh))
        {
			GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
			SetVehicleParamsEx(veh,true,lights,alarm,doors,bonnet,boot,objective);
        }
    }
	if (oldstate == PLAYER_STATE_DRIVER)
	{
		if(NoEngine(veh))
        {
			GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
			SetVehicleParamsEx(veh,false,lights,alarm,doors,bonnet,boot,objective);
        }
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid))
	{
		if(IsPlayerInRangeOfPoint(playerid, 0.5, RandomWood[WoodRand[playerid]][0], RandomWood[WoodRand[playerid]][1], RandomWood[WoodRand[playerid]][2]))
	 	{			
			SetPVarInt(playerid, "StartJob", 1);
			
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerAttachedObject(playerid,0,341,6,0.055999,0.014000,-0.108999,36.099945,-10.100026,-24.100002,1.000000,1.000000,1.000000);
			
			TogglePlayerControllable(playerid, 0);
			ClearAnimations(playerid);
			ApplyAnimation(playerid,"CHAINSAW","WEAPON_csaw",4.1, 1, 1, 1, 0, 0);
			
			GiveEndurance(playerid, -6);
			
			SetTimerEx("wood",5800,false,"i",playerid);
			return true;
	  	}
		if(IsPlayerInRangeOfPoint(playerid, 1.0,-1638.1555,-2252.6714,31.5890))
	 	{
	  		SetPVarInt(playerid, "StartJob", 0);
			
	  		if(IsPlayerAttachedObjectSlotUsed(playerid,1)) RemovePlayerAttachedObject(playerid,1);
			
		    ApplyAnimation( playerid, "CARRY", "putdwn", 4, 0, 1, 1, 0, 800);
			
			GiveEndurance(playerid, -1);
			
		    new a = 10 + random(20);
		    drev += a;
		    PlayerInfo[playerid][pMoneyDolg] += CENA_WOOD * a;
			
		    new Random = random(sizeof(RandomWood));
			SetPlayerRaceCheckpoint(playerid,0,RandomWood[Random][0], RandomWood[Random][1], RandomWood[Random][2],RandomWood[Random][0], RandomWood[Random][1],
			RandomWood[Random][2],0.5);
		   	WoodRand[playerid] = Random;
			
		    SaveWood();
		    return true;
		}
	}
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	if(objectid==FerrisWheelObjects[10])SetTimer("RotateFerrisWheel",FERRIS_WHEEL_WAIT_TIME,false);
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	
	if (HOLDING(KEY_SPRINT)) PlayerRun[playerid] = true;
	if (RELEASED(KEY_SPRINT)) PlayerRun[playerid] = false;
	
	new vid = GetPlayerVehicleID(playerid);
    if (newkeys == KEY_LOOK_BEHIND && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && !NoEngine(vid))
    {
        static Float:VehicleHP;
    	GetVehicleHealth(vid, VehicleHP);
		
    	if(VehicleHP <= 300.0) return SendClientMessage(playerid,COLOR_RED,"Состояние транспорта на низком уровне. Необходим ремонт.");
		
  		GetVehicleParamsEx(vid,engine,lights,alarm,doors,bonnet,boot,objective);
		
  		if (PlayerInfo[playerid][pAdmin] == 5)
  		{
		  		if(Engine[vid] != true)	
				{
					SetVehicleParamsEx(vid,true,lights,alarm,doors,bonnet,boot,objective);
					Engine[vid] = true;
					return 1;
				}
				else
				{
					SetVehicleParamsEx(vid,false,lights,alarm,doors,bonnet,boot,objective);
					Engine[vid] = false;
					return 1;
				}
		}

        if (RentCar[playerid] == vid)
		return StartEngine(vid, playerid);
		
  		if(PlayerInfo[playerid][pCarKey] == vid)
  		return StartEngine(vid, playerid);
	
		if(PlayerInfo[playerid][pMember] == Veh[vid][vBuy])
  		return StartEngine(vid, playerid);
	
		else return	SendClientMessage(playerid,COLOR_RED,"У вас нет ключей от этого транспорта.");
    }
    

    if(newkeys == KEY_JUMP)
	{
        if(IsPlayerInRangeOfPoint(playerid, 3.0,-2082.5891,-2418.1428,32.8820) || IsPlayerInRangeOfPoint(playerid, 3.0,-2089.1011,-2413.7351,32.9020) || 
		IsPlayerInRangeOfPoint(playerid, 3.0,-2095.4346,-2408.9075,32.8820) && !IsPlayerInAnyVehicle(playerid) && (GetTickCount() - GetPVarInt(playerid,"BatutUnBug")) >= 1500)
	    {
	        new Float:V[3];
	        GetPlayerVelocity(playerid,V[0],V[1],V[2]);
	        SetPlayerVelocity(playerid,V[0],V[1],floatabs(V[2]) + (float(random(2)) / 1.5));
	        SetPVarInt(playerid,"BatutUnBug",GetTickCount());
			
			GiveEndurance(playerid, -2);
	    }
    }
	
	if (newkeys == KEY_HANDBRAKE && !IsPlayerInAnyVehicle(playerid) || newkeys == KEY_CROUCH && IsPlayerInAnyVehicle(playerid))
	{
		
		if(PlayerInfo[playerid][pMember] == 2 && (IsPlayerInRangeOfPoint(playerid, 10.0, -2089.7480,-2322.1328,30.6250) && !IsPlayerInAnyVehicle(playerid)
			|| IsPlayerInRangeOfPoint(playerid, 15.0, -2089.7480,-2322.1328,30.6250) && IsPlayerInAnyVehicle(playerid)))
		{
				if(LSPDGateOpen) 
				{
					MoveObject (LSPDGate, -2090.0000000,-2322.2998000,32.4000000, 0.7, 0.0000000,0.0000000,51.7400000);
					LSPDGateOpen = false;
					LSPDGateTime = 0;
					GameTextForPlayer(playerid, FixText("~R~Ворота закрываются"), 1500, 3);
					return 1;
				}					
				else 	
				{
					MoveObject (LSPDGate, -2083.0000000,-2313.3000000,32.4000000, 0.7, 0.0000000,0.0000000,51.9850000);
					LSPDGateOpen = true;
					LSPDGateTime = 20;
					GameTextForPlayer(playerid, FixText ("~G~Ворота открываются"), 1500, 3);
					return 1;
				}
		}
			
		if(PlayerInfo[playerid][pMember] == 1 && (	IsPlayerInRangeOfPoint(playerid, 10.0, -2150.0566,-2395.3901,30.6250) && !IsPlayerInAnyVehicle(playerid)
			|| 										IsPlayerInRangeOfPoint(playerid, 15.0, -2150.0566,-2395.3901,30.6250) && IsPlayerInAnyVehicle(playerid)))
		{
				if(BankGateOpen) 
				{
					MoveObject (BankGate, -2152.1001000,-2393.1001000,32.4000000, 0.7, 0.0000000,0.0000000,140.5000000);
					BankGateOpen = false;
					BankGateTime = 0;
					GameTextForPlayer(playerid, FixText("~R~Ворота закрываются"), 1500, 3);
					return 1;
				}					
				else 	
				{
					MoveObject (BankGate, -2157.1001000,-2389.0000000,32.4000000, 0.7, 0.0000000,0.0000000,140.4990000);
					BankGateOpen = true;
					BankGateTime = 20;
					GameTextForPlayer(playerid, FixText ("~G~Ворота открываются"), 1500, 3);
					return 1;
				}
		}
			
		if(PlayerInfo[playerid][pMember] == 1 && (	IsPlayerInRangeOfPoint(playerid, 10.0, -2045.9153,-2506.9226,31.2927) && !IsPlayerInAnyVehicle(playerid)
			|| 										IsPlayerInRangeOfPoint(playerid, 15.0, -2045.9153,-2506.9226,31.2927) && IsPlayerInAnyVehicle(playerid)))
		{
				if(CongressGateOpen) 
				{
					MoveObject (CongressGate, -2046.3000000,-2507.1001000,32.8000000, 0.7, 0.0000000,0.0000000,317.2500000);
					CongressGateOpen = false;
					CongressGateTime = 0;
					GameTextForPlayer(playerid, FixText("~R~Ворота закрываются"), 1500, 3);
					return 1;
				}					
				else 	
				{
					MoveObject (CongressGate, -2037.9000000,-2514.8999000,32.8000000, 0.7, 0.0000000,0.0000000,317.2500000);
					CongressGateOpen = true;
					CongressGateTime = 20;
					GameTextForPlayer(playerid, FixText ("~G~Ворота открываются"), 1500, 3);
					return 1;
				}
		}
		

		if(PlayerInfo[playerid][pMember] == 5 && (	IsPlayerInRangeOfPoint(playerid, 10.0, -2397.3569,-2194.6267,33.3970) && !IsPlayerInAnyVehicle(playerid)
			|| 										IsPlayerInRangeOfPoint(playerid, 15.0, -2397.3569,-2194.6267,33.3970) && IsPlayerInAnyVehicle(playerid)))
		{
				if(FixGateOpen) 
				{
					MoveObject (FixGate, -2397.3999000,-2194.2000000,34.0000000, 0.7, 0.0000000,0.0000000,274.7500000);
					FixGateOpen = false;
					FixGateTime = 0;
					GameTextForPlayer(playerid, FixText("~R~Ворота закрываются"), 1500, 3);
					return 1;
				}					
				else 	
				{
					MoveObject (FixGate, -2397.2600000,-2195.8000000,35.6000000, 0.7, 0.0000000,270.0000000,274.7500000);
					FixGateOpen = true;
					FixGateTime = 600;
					GameTextForPlayer(playerid, FixText ("~G~Ворота открываются"), 1500, 3);
					return 1;
				}
		}
		
		if(PlayerInfo[playerid][pMember] == 5 && (	IsPlayerInRangeOfPoint(playerid, 10.0, -2388.1277,-2181.3235,33.4875) && !IsPlayerInAnyVehicle(playerid)
			|| 										IsPlayerInRangeOfPoint(playerid, 15.0, -2388.1277,-2181.3235,33.4875) && IsPlayerInAnyVehicle(playerid)))
		{		
				if(FixGate2Open) 
				{
					MoveObject (FixGate2, -2388.2000000,-2180.8999000,34.0300000, 0.7, 0.0000000,0.0000000,274.7460000);
					FixGate2Open = false;
					FixGate2Time = 0;
					GameTextForPlayer(playerid, FixText("~R~Ворота закрываются"), 1500, 3);
					return 1;
				}					
				else 	
				{
					MoveObject (FixGate2, -2388.3401000,-2179.2000000,35.6500000, 0.7, 0.0000000,90.0000000,274.7460000);
					FixGate2Open = true;
					FixGate2Time = 600;
					GameTextForPlayer(playerid, FixText ("~G~Ворота открываются"), 1500, 3);
					return 1;
				}
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 250.5928,64.5058,1003.6206))
		{
			if(LSPDDoorOpen) 
			return 	MoveObject (LSPDDoor, 250.4500000,62.7500000,1002.6000000, 0.01, 0.0000000,0.0000000,90.0000000), LSPDDoorOpen = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3);
					
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_POLICE, szKey);
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 247.5468,72.4742,1003.6206))
		{
			if(LSPDDoor2Open) 
			return 	MoveObject (LSPDDoor2, 245.8000000,72.3500000,1002.6000000, 0.01, 0.0000000,0.0000000,0.0000000), LSPDDoor2Open = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3);
			
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_POLICE2, szKey);
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 2151.3354,1606.1740,1006.1863))
		{
			if(BankDoorOpen) 
			return 	MoveObject (BankDoor, 2150.3604000,1605.7998000,1006.5200000, 0.05, 0.0000000,0.0000000,0.0000000), BankDoorOpen = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3);
		
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_BANKDOOR, szKey);
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 2148.0713,1605.0737,1006.1693))
		{
			if(BankDoor2Open) 
			return 	MoveObject (BankDoor2, 2147.0801000,1604.7000000,1006.5000000, 0.05, 0.0000000,0.0000000,0.0000000), BankDoor2Open = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3);
			
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_BANKDOOR2, szKey);
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 2143.9097,1626.4744,993.6882))
		{
			if(VaultDoorOpen) 
			return MoveObject (VaultDoor, 2144.2000000,1627.0000000,994.2600100, 0.1, 0.0000000,0.0000000,180.0000000), VaultDoorOpen = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3), VaultDoorTime = 0;
		
			if(VaultGateOpen) 
			return SendClientMessage(playerid,COLOR_WHITE,"Необходимо закрыть решетку.");
		
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_VAULTDOOR, szKey);
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 2145.7754,1606.6875,993.3350))
		{
			if(VaultGateOpen) 
			{
				MoveObject (VaultGate, 2141.5000000,1606.9000000,994.2000100, 0.5, 0.0000000,0.0000000,180.0000000), VaultGateOpen = false, 
				GameTextForPlayer(playerid, FixText("~R~Решетка закрывается"), 1500, 3);
				return 1;
			}
			
			if(!VaultDoorOpen) 
			{
				new var = 1337;
				new szKey[5]; valstr(szKey, var); 
			
				ShowPlayerKeypad(playerid, KEYPAD_VAULTGATE, szKey);
			}
			
			else return SendClientMessage(playerid,COLOR_WHITE,"Необходимо закрыть дверь в хранилище.");
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 252.6765,109.6760,1003.2188))
		{
			if(FireDoorOpen) 
			return 	MoveObject (FireDoor, 253.1000100,108.5800000,1002.2000000, 0.01, 0.0000000,0.0000000,90.0000000), FireDoorOpen = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3);
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_FIREDOOR, szKey);
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 240.1736,116.9190,1003.2257))
		{
			if(FireDoor2Open) 
			return 	MoveObject (FireDoor2, 239.7500000,118.0900000,1002.2000000, 0.01, 0.0000000,0.0000000,270.0000000), FireDoor2Open = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3);
			
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_FIREDOOR2, szKey);
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 2149.4817,1602.5496,1001.9677))
		{
			if(BankDoor3Open) 
			return 	MoveObject (BankDoor3, 2149.8301000,1603.6000000,1002.3000000, 0.01, 0.0000000,0.0000000,270.0000000), BankDoor3Open = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3);
			
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_BANKDOOR3, szKey);
		}

	}
	
    if (newkeys == 65536)
    {
		if (!IsPlayerBlackScreen[playerid])
		{
			if(		IsPlayerInRangeOfPoint(playerid, 3.0, 254.8472,77.0973,1003.6406) && PlayerInfo[playerid][pMember] == 2
				|| 	IsPlayerInRangeOfPoint(playerid, 3.0, 267.0403,118.3147,1004.6172) && PlayerInfo[playerid][pMember] == 4
				|| 	IsPlayerInRangeOfPoint(playerid, 3.0, 350.9631,188.9638,1019.9844) && PlayerInfo[playerid][pMember] == 3)
			{
				ShowPlayerDialog(playerid, DIALOG_ID_CHANGECLOTHES, D_S_M,""COL_ORANGE"Раздевалка",""COL_BLUE"Вы хотите переодеться?\n","Да","Нет");
				return 1;
			}
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 3.0, -2032.4177,-116.3887,1035.1719))
		{
		    new str[95];
		    format(str,sizeof(str), ""COL_BLUE"\nЗдравствуйте, у нас Вы можете арендовать мопед.\nСтоимость аренды мопеда: "COL_GREEN"%d $.",CENA_ARENDI);
			ShowPlayerDialog(playerid, DIALOG_ID_RENTMOPED, D_S_M,""COL_ORANGE"Аренда мопеда",str,"Арендовать","Отмена");
			return 1;
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.0, -1630.8824,-2234.4985,31.4766))
		{
			if(GetPVarInt(playerid, "PlayerWood") == 1 && GetPVarInt(playerid, "IsWork") != 0) 
			return ShowPlayerDialog(playerid, DIALOG_ID_WOODSTOP, D_S_M,""COL_ORANGE"Дровосек",""COL_WHITE"Вы хотите получить заработанные деньги?","Принять","Отмена");
		
			if(GetPVarInt(playerid, "IsWork") != 0) 
			return SendClientMessage(playerid, COLOR_RED,"Закончите предыдущую работу.");
		
			if(GetPVarInt(playerid, "PlayerWood") == 0) 
			return ShowPlayerDialog(playerid, DIALOG_ID_WOODSTART, D_S_M,""COL_ORANGE"Дровосек",""COL_WHITE"Здесь Вы можете подработать дровосеком.\n\
		Если устанете работать, то сложите оборудование и заходите за заработанными деньгами.","Начать","Отмена");
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.0, 362.6556,173.5869,1008.3828))
		{
			static D33[] = 
			"\t"COL_WHITE"Добрый день! Приветствуем Вас в здании конгресса. Меня зовут Моника.\t\n\n\
			\tУ меня Вы можете получить свой индивидуальный "COL_APED"APED"COL_WHITE" для комфортного проживания в штате.\t\n\
			\t"COL_APED"Angel Pine Electrical Document"COL_WHITE" - это многофункциональный электронный документ.\t\n\
			\t"COL_APED"APED"COL_WHITE" будет заменять Вам смартфон, навигатор, показывать полезную информацию и многое другое.\t\n\n\
			\tВы хотите получить его? Его стоимость - {09ff00}%d $.\t\n\n";
			new d33[512];
				
			if(PlayerInfo[playerid][pAPED] == 0)
			{
				format(d33, sizeof(d33), D33, CENA_APED);
				ShowPlayerDialog(playerid, DIALOG_ID_GETAPED, D_S_M,""COL_ORANGE"Получение APED",d33,"Да","Нет");
			}
			else SendClientMessage(playerid, COLOR_PROX,"Моника говорит: "COL_WHITE"У Вас уже есть APED! Извините, но мы не можем выдать еще один.");
			return 1;
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 2537.3064,-1286.8135,1054.6406))
		{
			if(PlayerInfo[playerid][pCarKey] == 0)
			return SendClientMessage(playerid, COLOR_GREY,"Вы не владеете личным транспортом.");
			
			static D34[] = 
					"\t"COL_WHITE"Добрый день! Меня зовут Алекс. У нас Вы можете выставить свой транспорт на продажу. \t\n\n\
					\tЕсли Вы согласны, то мы выплачиваем сразу всю сумму на руки и забираем ключи.\t\n\
					\tВаш транспорт будет продаваться с учетом налога на продажу.\t\n\
					\tНа данный момент налоговая ставка составляет "COL_APED"%d %%"COL_WHITE".\t\n\n\
					\tБудем оформлять Ваш транспорт на продажу?\t\n\n";
			new d34[512];
			
			format(d34, sizeof(d34), D34, NALOG_BUYCAR);
			ShowPlayerDialog(playerid, DIALOG_ID_SELLCAR, D_S_M,""COL_ORANGE"Продажа транспорта",d34,"Да","Нет");
			return 1;
		}
		
		new params[1];
		cmd_vmenu(playerid,params);
	}
	
	if (newkeys == 2)
   	{
		if(IsAtGasStation(playerid))
   	    {
		    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY,"Нужно находиться в транспорте.");
			
		    if(GetPVarInt(playerid, "Refill") == 1) return 1;
			
		    GetVehicleParamsEx(vid,engine,lights,alarm,doors,bonnet,boot,objective);
		    if(engine) 
			return SendClientMessage(playerid, COLOR_GREY,"Заглушите двигатель вашего транспортного средства.");
		
		    TogglePlayerControllable(playerid, 0);
			
		    new str[178];
			
		    format(str,sizeof(str), ""COL_BLUE"\nЗдравствуйте, вас приветствует АЗС округа 'Angel Pine'\nВведите количество литров, которое вы хотите наполнить в бензобак:\n\
			Стоимость одного литра: "COL_GREEN"%d $",CENA_BENZ);
			ShowPlayerDialog(playerid, DIALOG_ID_REFILL, D_S_I,""COL_ORANGE"АЗС",str,"Принять","Отмена");
		    return 1;
		}
	}
	
	if (newkeys == KEY_NO)
	{		
		ShowPlayerAPEDDialog(playerid);
	}
	
    if (newkeys == 1024)
   	{
    	for(new i = 0; i < MAX_HOUSES;i++)
		{
	        if(IsPlayerInRangeOfPoint(playerid, 1.5, House[i][hEnterX],House[i][hEnterY],House[i][hEnterZ]))
	        {
				if(House[i][hOwned] == 0)
				{
				  	new str[128];
					
				  	format(str,128, ""COL_BLUE"Этот дом выставлен на продажу\nЦена: "COL_GREEN"%d $\n"COL_BLUE"Хотите ли вы осмотреть дом?\n",House[i][hPrice]);
					ShowPlayerDialog(playerid, DIALOG_ID_HOUSEENTER, D_S_M,""COL_ORANGE"Покупка дома",str,"Да","Нет");
					
					SetPVarInt(playerid, "HouseID", i);
					return 1;
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 1.5, House[i][hExitX],House[i][hExitY],House[i][hExitZ])
				&& GetPlayerVirtualWorld(playerid) == House[i][hVirt])
			{
					ShowPlayerDialog(playerid, DIALOG_ID_HOUSEEXIT, D_S_M,""COL_ORANGE"Выход из дома",""COL_BLUE"Вы хотите выйти из дома?","Да","Нет");
					
					SetPVarInt(playerid, "HouseID", i);
					return 1;
			}
		}
		for(new i = 0; i < sizeof(EnterInfo); i++)
		{
		    if(IsPlayerInRangeOfPoint(playerid, 1.0, EnterInfo[i][eEnterX], EnterInfo[i][eEnterY], EnterInfo[i][eEnterZ]))
		    {
		        SetPlayerPosCW(playerid, EnterInfo[i][eExitX], EnterInfo[i][eExitY], EnterInfo[i][eExitZ], EnterInfo[i][eExitA],EnterInfo[i][eExitInt],EnterInfo[i][eExitVirt]);
				ApplyAnimation(playerid, "PED", "Walk_Wuzi", 4.1, 0, 1, 1, 1, 0, 1);
		        break;
		    }
		    else if(IsPlayerInRangeOfPoint(playerid, 1.0, EnterInfo[i][eExitX], EnterInfo[i][eExitY], EnterInfo[i][eExitZ]))
		    {
		        SetPlayerPosCW(playerid, EnterInfo[i][eEnterX], EnterInfo[i][eEnterY], EnterInfo[i][eEnterZ], EnterInfo[i][eEnterA],EnterInfo[i][eEnterInt], EnterInfo[i][eEnterVirt]);
				ApplyAnimation(playerid, "PED", "Walk_Wuzi", 4.1, 0, 1, 1, 1, 0, 1);
		        break;
		    }
		}
	}
	
	if(newkeys & KEY_SPRINT || newkeys & KEY_JUMP)  
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid, 1) && GetPVarInt(playerid, "StartJob") ==  1) 
		{
			RemovePlayerAttachedObject(playerid, 1);
			ApplyAnimation(playerid,"PED","getup_front",4.0,0,0,0,0,0); 
			
			GiveEndurance(playerid, -2);
			
			SetPVarInt(playerid, "StartJob", 0);
		    new Random = random(sizeof(RandomWood));
			SetPlayerRaceCheckpoint(playerid,0,RandomWood[Random][0], RandomWood[Random][1], RandomWood[Random][2],RandomWood[Random][0], RandomWood[Random][1],
			RandomWood[Random][2],0.5);
		   	WoodRand[playerid] = Random;
			
			SendClientMessage(playerid, COLOR_GREY,"Вы уронили бревна.");
		}
	}  
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
	{
	    case DIALOG_ID_LOGIN:
	    {
	        if(response)// Если игрок нажал первую кнопку входа
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {
	                ShowPlayerDialog(playerid, DIALOG_ID_LOGIN, D_S_P,""COL_ORANGE"Окно Входа",""COL_BLUE"Добрый день!\nВаш аккаунт есть на сервере.\n\
					Введите свой пароль в поле:","Ввод","Выход");
	                return 1;
	            }
	            new pass[64];// Масив с паролем
	            strmid(pass,inputtext,0,strlen(inputtext),64);// Считываем текст с диалога
	            OnPlayerLogin(playerid,pass);// Запускаем паблик входа
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	        {
				Kick(playerid);
	        }
	    }
	    
     	case DIALOG_ID_REGISTER:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {
	                ShowPlayerDialog(playerid, DIALOG_ID_REGISTER, D_S_P,""COL_ORANGE"Регистрация аккаунта"," "COL_BLUE"Приветствуем Вас на нашем сервере\n Придумайте себе цифровую подпись (пароль)\
					для дальнейшего проживания в округе 'Angel Pine'\n","Вход","Выход");
	                return 1;
	            }
	            new pass[64];// Масив с паролем
	            strmid(pass,inputtext,0,strlen(inputtext),64);// Считываем текст с диалога
	            OnPlayerRegister(playerid,pass);// Запускаем паблик регистрации
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	        {
	            Kick(playerid);
			}
	    }
	    
	    case DIALOG_ID_KICK:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
                Kick(playerid);
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	        {
	            Kick(playerid);
	        }
	    }
	    
	    case DIALOG_ID_BAN:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
                Ban(playerid);
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	        {
	            Ban(playerid);
	        }
	    }
	    
	    case DIALOG_ID_CHOOSESEX:
	    {
	        if(response)
	        {
                SetPVarInt(playerid, "Skin", 23);
                SetPVarInt(playerid, "Sex", 1);
				ShowPlayerDialog(playerid, DIALOG_ID_REGISTER, D_S_P,""COL_ORANGE"Регистрация аккаунта"," "COL_BLUE"Приветствуем Вас на нашем сервере\n Придумайте себе цифровую подпись (пароль)\
				для дальнейшего проживания в округе 'Angel Pine'\n","Вход","Выход");
	        }
	        else
	        {
                SetPVarInt(playerid, "Skin", 148);
                SetPVarInt(playerid, "Sex", 2);
				ShowPlayerDialog(playerid, DIALOG_ID_REGISTER, D_S_P,""COL_ORANGE"Регистрация аккаунта"," "COL_BLUE"Приветствуем Вас на нашем сервере\n Придумайте себе цифровую подпись (пароль)\
				для дальнейшего проживания в округе 'Angel Pine'\n","Вход","Выход");
	        }
	    }
			    
	    case DIALOG_ID_BUYCAR:
    	{
    		if(response)
        	{
        	    new car = GetPlayerVehicleID(playerid);
            	if(!IsPlayerInAnyVehicle(playerid) || Veh[car][vBuy] != VBUYTOBUY) return 1;
				
            	if(PlayerInfo[playerid][pMoney] < Veh[car][vPrice])
				{
					SendClientMessage(playerid,COLOR_RED,"У вас недостаточно денег для покупки");
					TogglePlayerControllable(playerid, 1);
					RemovePlayerFromVehicle(playerid);
					return 1;
				}
				
				if(PlayerInfo[playerid][pCarKey] != 0)
				{
					SendClientMessage(playerid,COLOR_RED,"У вас уже есть транспортное средство");
					TogglePlayerControllable(playerid, 1);
					RemovePlayerFromVehicle(playerid);
					return 1;
				}
				
			   	PlayerInfo[playerid][pCarKey] = car;
				
				Delete3DTextLabel(Text3D:sellveh[car]);
				
             	Veh[car][vBuy] = VBUYTOCARKEY;
             	Veh[car][vLock] = 0;
				strmid(Veh[car][vOwner], Name(playerid), 0, strlen(Name(playerid)), MAX_PLAYER_NAME+1);
				SaveVeh();
				
             	PlayerInfo[playerid][pMoney] -= Veh[car][vPrice];
				             	
             	SendClientMessage(playerid,COLOR_YELLOW,"Поздравляем с новой покупкой!");
				
             	TogglePlayerControllable(playerid, 1);
       			return 1;
 			}
 			else
			{
			    RemovePlayerFromVehicle(playerid);
			    TogglePlayerControllable(playerid, 1);
			}
		}
		
		case DIALOG_ID_VMENU:
  		{
    		if(response)
      		{
					new carid = GetAroundPlayerVehicleID(playerid, 4.0),
					str[128];
					
					switch(listitem)
					{
                            case 0://двери отк
                            {
                                if(Veh[carid][vLock] == 1)
                                {
	                                Veh[carid][vLock] = 0;
									
		                            GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
		                            SetVehicleParamsEx(carid,engine,lights,alarm,false,bonnet,boot,objective);
									
		                            format(str,sizeof(str),"%s открывает двери транспортного средства.",Name(playerid));
		    						ProxDetector(playerid,COLOR_PROX, str, 10.0);
									
		    						SaveVeh();
								}
                            }
                            case 1://двери зак
                            {
                                if(Veh[carid][vLock] == 0)
                                {
	                                Veh[carid][vLock] = 1;
									
		                            GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
		                            SetVehicleParamsEx(carid,engine,lights,alarm,true,bonnet,boot,objective);
									
		                            format(str,sizeof(str),"%s блокирует двери транспортного средства.",Name(playerid));
									ProxDetector(playerid,COLOR_PROX, str, 10.0);
									
		    						SaveVeh();
								}
                            }
                            case 2://багаж вкл
                            {
								if(boot) return 1;
								
                               	GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
	                            SetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,true,objective);
								
	                            format(str,sizeof(str),"%s открывает багажник транспортного средства.",Name(playerid));
	    						ProxDetector(playerid,COLOR_PROX, str, 10.0);
                            }
                            case 3://багаж выкл
                            {
								if(!boot) return 1;
								
	                            GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
	                            SetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,false,objective);
								
	                            format(str,sizeof(str),"%s закрывает багажник транспортного средства.",Name(playerid));
	    						ProxDetector(playerid,COLOR_PROX, str, 10.0);
                            }
                            case 4://капот вкл
                            {
								if(bonnet) return 1;
								
	                            GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
	                            SetVehicleParamsEx(carid,engine,lights,alarm,doors,true,boot,objective);
								
	                            format(str,sizeof(str),"%s открывает капот транспортного средства.",Name(playerid));
	    						ProxDetector(playerid,COLOR_PROX, str, 10.0);
                            }
                            case 5://капот выкл
                            {
								if(!bonnet) return 1;
								
								GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
	                            SetVehicleParamsEx(carid,engine,lights,alarm,doors,false,boot,objective);
								
	                            format(str,sizeof(str),"%s закрывает капот транспортного средства.",Name(playerid));
								ProxDetector(playerid,COLOR_PROX, str, 10.0);
                            }
					}
			}
		}
		
		case DIALOG_ID_REFILL:
    	{
    		if(response)
        	{
        	    new str[180];
        	    if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {
				    format(str,sizeof(str), ""COL_BLUE"\nЗдравствуйте, вас приветствует АЗС округа 'Angel Pine'\nВведите количество литров, которое вы хотите наполнить в бензобак:\n\
					Стоимость одного литра: "COL_GREEN"%d $",CENA_BENZ);
					ShowPlayerDialog(playerid, DIALOG_ID_REFILL, D_S_I,""COL_ORANGE"АЗС",str,"Принять","Отмена");
					return 1;
				}
	            new carid = GetPlayerVehicleID(playerid);
	            inputfuel[playerid] = strval(inputtext);
	            if(Veh[carid][vFuel] + inputfuel[playerid] > 100)
				{
					SendClientMessage(playerid, COLOR_GREY,"Введите меньшее количество литров.");
				    format(str,sizeof(str), ""COL_BLUE"\nЗдравствуйте, вас приветствует АЗС округа 'Angel Pine'\nВведите количество литров, которое вы хотите наполнить в бензобак:\n\
					Стоимость одного литра: "COL_GREEN"%d $",CENA_BENZ);
					ShowPlayerDialog(playerid, DIALOG_ID_REFILL, D_S_I,""COL_ORANGE"АЗС",str,"Принять","Отмена");
					return 1;
				}
				if(PlayerInfo[playerid][pMoney] < CENA_BENZ*inputfuel[playerid])
				{
                    TogglePlayerControllable(playerid, 1);
                    SendClientMessage(playerid, COLOR_RED,"У вас недостаточно денег.");
                    return 1;
				}
				SetPVarInt(playerid,"timer", SetTimerEx("Refill", 500, false, "ii", playerid, inputfuel[playerid]));
	            SetPVarInt(playerid, "Refill", 1);
           		PlayerInfo[playerid][pMoney] -= CENA_BENZ*inputfuel[playerid];
           		ShowPlayerDialog(playerid, DIALOG_ID_NONE, D_S_M,""COL_ORANGE"АЗС",""COL_BLUE"Ожидайте, идет заправка...","","");
			}
			else TogglePlayerControllable(playerid,1);
		}
		
		case DIALOG_ID_WOODSTART:
  		{
    		if(response)
      		{
        		new Random = random(sizeof(RandomWood));
       		 	SetPVarInt(playerid, "PlayerWood", 1);
				SetPVarInt(playerid, "IsWork", 1);
				SetPlayerRaceCheckpoint(playerid,0,RandomWood[Random][0], RandomWood[Random][1], RandomWood[Random][2],RandomWood[Random][0], RandomWood[Random][1],
				RandomWood[Random][2],0.5);
	
            	WoodRand[playerid] = Random;
            }
            return true;
    	}
		
  		case DIALOG_ID_WOODSTOP:
    	{
     		if(response)
       		{
  				DeletePVar(playerid, "PlayerWood");
				DeletePVar(playerid, "IsWork");
      			DisablePlayerRaceCheckpoint(playerid);
				
                if(IsPlayerAttachedObjectSlotUsed(playerid,0)) RemovePlayerAttachedObject(playerid,1);
                if(IsPlayerAttachedObjectSlotUsed(playerid,1)) RemovePlayerAttachedObject(playerid,2);
				
				if (PlayerInfo[playerid][pMoneyDolg] == 0)
				ShowPlayerDialog(playerid, DIALOG_ID_NONE, D_S_M,""COL_ORANGE"Дровосек",""COL_WHITE"К сожалению, ты ничего не заработал.\nМожет быть в другой раз..","Принять","");
				
				else
				{
					new str[58];
					
					format(str,sizeof(str), ""COL_BLUE"\nСпасибо за помощь, вот Ваши "COL_GREEN"%d $.\n",PlayerInfo[playerid][pMoneyDolg]);
					ShowPlayerDialog(playerid, DIALOG_ID_NONE, D_S_M,""COL_ORANGE"Дровосек",str,"Принять","");
					
					PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
				}
				
				PlayerInfo[playerid][pMoney] += PlayerInfo[playerid][pMoneyDolg];
				PlayerInfo[playerid][pMoneyDolg] = 0;
			}
   			return true;
      	}
		
      	case DIALOG_ID_HOUSEENTER:
    	{
    		if(response) 
			return	SetPlayerPosCW(playerid,House[GetPVarInt(playerid, "HouseID")][hExitX],House[GetPVarInt(playerid, "HouseID")][hExitY],House[GetPVarInt(playerid, "HouseID")][hExitZ],
		House[GetPVarInt(playerid, "HouseID")][hExitA],House[GetPVarInt(playerid, "HouseID")][hInt],House[GetPVarInt(playerid, "HouseID")][hVirt]),
					ApplyAnimation(playerid, "PED", "Walk_Wuzi", 4.1, 0, 1, 1, 1, 0, 1);
		}
		
		case DIALOG_ID_HOUSEEXIT:
    	{
    		if(response) 
			return	SetPlayerPosCW(playerid,House[GetPVarInt(playerid, "HouseID")][hEnterX],House[GetPVarInt(playerid, "HouseID")][hEnterY],
					House[GetPVarInt(playerid, "HouseID")][hEnterZ], House[GetPVarInt(playerid, "HouseID")][hEnterA],0,0),
					ApplyAnimation(playerid, "PED", "Walk_Wuzi", 4.1, 0, 1, 1, 1, 0, 1);
		}
		
		case DIALOG_ID_SETLEADER:
        {
            if(!response)	return 1;

            new target = GetPVarInt(playerid, "makeleader_target");
			
			if(listitem == 0)
			{
					if(PlayerInfo[target][pLeader] == 0) return SendClientMessage(playerid,COLOR_GREY,"Игрок не является лидером организации.");
					
					ShowPlayerDialog(playerid, DIALOG_ID_REASONUNLEADER, D_S_I, ""COL_ORANGE"Введите причину", ""COL_BLUE"Введите причину снятия игрока с лидерства организации:\n"
					, "Принять", "Назад");
            }
			else
			{
				static const
					fmt_player[] = "Вы назначили [%d] %s лидером организации "COL_ORANGE"'%s'",
					fmt_target[] = "Администратор [%d] %s назначил Вас лидером организации "COL_ORANGE"'%s'";

				new string[sizeof(fmt_target) + (-2+MAX_PLAYER_NAME+1) + (-2+5) + (-2+MAX_FRACTION_NAME_LENGTH)];

				format(string, sizeof(string), fmt_player, target, Name(target), fraction_name[listitem]);
				SendClientMessage(playerid, COLOR_GREEN, string);

				format(string, sizeof(string), fmt_target, playerid, Name(playerid), fraction_name[listitem]);
				SendClientMessage(target, COLOR_GREEN, string);

				PlayerInfo[target][pMember] = 
				PlayerInfo[target][pLeader] = listitem;

				ShowPlayerDialog(target, DIALOG_ID_SETLEADERRANK, D_S_I, ""COL_ORANGE"Установить ранг", ""COL_BLUE"Введите название для своего ранга\n"
					, "Принять", "");
				
				new toleaders[128];
				format(toleaders,sizeof(toleaders), "Администратор %s назначил %s лидером организации %s",Name(playerid),Name(target),fraction_name[listitem]);
				WriteLog("Leaders",toleaders);
			}
		}
		
		case DIALOG_ID_REASONUNLEADER:
		{
			if(response) 
			{
				if(!strlen(inputtext))
	            {
				    ShowPlayerDialog(playerid, DIALOG_ID_REASONUNLEADER, D_S_I, ""COL_ORANGE"Введите причину", ""COL_BLUE"Введите причину снятия игрока с лидерства организации:\n"
					, "Принять", "Назад");
					return 1;
				}
				new string[512],
					target = GetPVarInt(playerid, "makeleader_target");
	
				format(string,sizeof(string), ""COL_BLUE"\nАдминистратор [%d] %s снял вас с лидерства организации "COL_WHITE"%s\n"COL_BLUE"Причина: "COL_WHITE"%s",playerid,Name(playerid),
				fraction_name[PlayerInfo[target][pMember]], inputtext);
				ShowPlayerDialog(target, DIALOG_ID_NONE, D_S_M, ""COL_ORANGE"Информация", string, "Принять", "");
										
				format(string,sizeof(string), "Администратор [%d] %s снял лидерство организации %s c игрока [%d] %s, причина: %s",
				playerid, Name(playerid), fraction_name[PlayerInfo[target][pMember]], target, Name(target), inputtext);
				WriteLog("Unleader",string);
					
				PlayerInfo[target][pMember] = 0;
				PlayerInfo[target][pLeader] = 0;
				PlayerInfo[target][pMemberWarn] = 0;
				PlayerInfo[target][pMemberSkin] = 0;
				PlayerInfo[target][pRankName] = 0;
			}
			else
			{
				static const
					fmt_dlg_header[] = "Назначить лидером игрока "COL_WHITE"[%d] %s",
					fmt_dlg[] = "%s%s\n";

				new
					header_string[sizeof(fmt_dlg_header) + (-2+MAX_PLAYER_NAME+1) + (-2+5)],
					dialog_string[(sizeof(fmt_dlg) + (-2+MAX_FRACTION_NAME_LENGTH))*MAX_FRACTIONS],
					target = GetPVarInt(playerid, "makeleader_target");

				format(header_string, sizeof(header_string), fmt_dlg_header, target, PlayerInfo[target][pName]);

				for(new i = 0; i < MAX_FRACTIONS; i++)
					format(dialog_string, sizeof(dialog_string), fmt_dlg, dialog_string, fraction_name[i]);

				ShowPlayerDialog(playerid, DIALOG_ID_SETLEADER, D_S_L, header_string, dialog_string, "Выбрать", "Отмена");
			}
		}
		
		case DIALOG_ID_SETLEADERRANK:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {
	                ShowPlayerDialog(playerid, DIALOG_ID_SETLEADERRANK, D_S_I, ""COL_ORANGE"Установить ранг", ""COL_BLUE"Введите название для своего ранга\n"
				, "Принять", "");

	                return 1;
	            }
	            
    			strmid(PlayerInfo[playerid][pRankName], inputtext, 0, strlen(inputtext), 32);
           		SavePlayer(playerid);
            	
	        }
	        else return	ShowPlayerDialog(playerid, DIALOG_ID_SETLEADERRANK, D_S_I, ""COL_ORANGE"Установить ранг", ""COL_BLUE"Введите название ранга для лидера\n"
				, "Принять", "");
	    }
		
		case DIALOG_ID_INVITEMEMBERYESNO:
    	{
    	    new str[MAX_PLAYER_NAME+1+43];
    		if(response)
        	{
				PlayerInfo[playerid][pMember] = IDFrac[playerid];
                
			    format(str,sizeof(str),"[%d] %s принял предложение на работу.", playerid, Name(playerid));
    			SendClientMessage(IDLeader, COLOR_GREEN,str);
				
				SendClientMessage(playerid, COLOR_GREEN,"Вы приняли предложение на работу.");
				
				IDLeader = 0;
			}
			else
			{
			    format(str,sizeof(str),"[%d] %s отказался от предложения на работу.", playerid, Name(playerid));
    			SendClientMessage(IDLeader, COLOR_WHITE,str);
				
				SendClientMessage(playerid, COLOR_GREEN,"Вы приняли предложение на работу.");
				
				IDLeader = 0;
			}

		}
		
		case DIALOG_ID_LMENU:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
							new buffer[256];
							foreach(Player, i)
							{
								new meme = PlayerInfo[playerid][pMember];
								if(meme == PlayerInfo[i][pMember])
								{
									format(buffer, sizeof(buffer), ""COL_WHITE"Имя: {9DDAF2}%s "COL_WHITE"| ID: {9DDAF2}%d "COL_WHITE"| Ранг: {9DDAF2}%s "COL_WHITE"| Кол-во выговоров: {9DDAF2}%d\n",
									Name(i), i, PlayerInfo[i][pRankName], PlayerInfo[i][pMemberWarn]);
									ShowPlayerDialog(playerid, DIALOG_ID_BACKTOLMENU, D_S_M, ""COL_ORANGE"Члены организации онлайн", buffer, "Закрыть", "Назад");
								}
							}
					}
					case 1:
					{
						ShowPlayerDialog(playerid, DIALOG_ID_INVITEMEMBER, D_S_I, ""COL_ORANGE"Принять игрока", "\
						"COL_BLUE"Введите ID игрока, которого вы хотите принять на работу:\n\
						", "Принять", "Назад");
					}
					
					case 2:
					{
						ShowPlayerDialog(playerid, DIALOG_ID_LAYOFFMEMBER, D_S_I, ""COL_ORANGE"Уволить игрока", "\
						"COL_BLUE"Введите ID игрока, которого вы хотите уволить:\n\
						", "Принять", "Назад");
					}
					
					case 3:
					{
						ShowPlayerDialog(playerid, DIALOG_ID_WARNMEMBER, D_S_I, ""COL_ORANGE"Дать выговор", "\
						"COL_BLUE"Введите ID игрока, которому вы хотите дать выговор:\n\
						", "Принять", "Назад");
					}
					case 4:
					{
						ShowPlayerDialog(playerid, DIALOG_ID_UNWARNMEMBER, D_S_I, ""COL_ORANGE"Снять выговор", "\
						"COL_BLUE"Введите ID игрока, которому вы хотите снять выговор:\n\
						", "Принять", "Назад");
					}
					case 5:
					{
						ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERRANK, D_S_I, ""COL_ORANGE"Установить ранг", "\
						"COL_BLUE"Введите ID игрока, которому вы хотите установить ранг:\n\
						", "Принять", "Назад");
					}
					case 6:
					{
						ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERSKINID, D_S_I, ""COL_ORANGE"Установить скин", "\
						"COL_BLUE"Введите ID игрока, которому вы хотите установить скин:\n\
						", "Принять", "Назад");
					}					
				}
			}
			else ShowPlayerAPEDDialog(playerid);
			return 1;
		}
		
		case DIALOG_ID_BACKTOLMENU:
		{
			if(!response)
			{
		        ShowPlayerLeaderDialog(playerid);
			}
		}
		
		case DIALOG_ID_INVITEMEMBER:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {
	                ShowPlayerDialog(playerid, DIALOG_ID_INVITEMEMBER, D_S_I, ""COL_ORANGE"Принять игрока", "\
					"COL_BLUE"Введите ID игрока, которого вы хотите принять на работу:\n\
					", "Принять", "Назад");
	                return 1;
	            }
	            if (strval(inputtext) == INVALID_PLAYER_ID || !IsPlayerConnected(strval(inputtext)) || gPlayerLogged[strval(inputtext)] == false)
				return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети."), ShowPlayerLeaderDialog(playerid);
			
				if (strval(inputtext) == playerid) return SendClientMessage(playerid, COLOR_GREY, "Вы ввели свой ID."), ShowPlayerLeaderDialog(playerid);
				
				if (PlayerInfo[strval(inputtext)][pMember] > 0)
				return SendClientMessage(playerid, COLOR_GREY,"Этот игрок уже состоит в другой организации."), ShowPlayerLeaderDialog(playerid);
				
				IDFrac[strval(inputtext)] = PlayerInfo[playerid][pLeader];
				IDLeader = playerid;
				
				new string[128];
			 					
				format(string,sizeof(string), ""COL_BLUE"\n[%d] %s хочет принять Вас во организацию "COL_WHITE"%s\n",playerid,Name(playerid),fraction_name[PlayerInfo[playerid][pLeader]]);
				ShowPlayerDialog(strval(inputtext), DIALOG_ID_INVITEMEMBERYESNO, D_S_M,""COL_ORANGE"Приглашение в организацию",string, "Принять", "Отмена");
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	        {
	            ShowPlayerLeaderDialog(playerid);
	        }
	    }
		
	    case DIALOG_ID_LAYOFFMEMBER:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {
	                ShowPlayerDialog(playerid, DIALOG_ID_LAYOFFMEMBER, D_S_I, ""COL_ORANGE"Уволить игрока", "\
					"COL_BLUE"Введите ID игрока, которого вы хотите уволить:\n\
					", "Принять", "Назад");
	                return 1;
	            }
				
	            if (strval(inputtext) == INVALID_PLAYER_ID || !IsPlayerConnected(strval(inputtext)) || gPlayerLogged[strval(inputtext)] == false) 
				return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети."), ShowPlayerLeaderDialog(playerid);
				
				if(strval(inputtext) == playerid) 
				return SendClientMessage(playerid, COLOR_GREY, "Вы ввели свой ID."), ShowPlayerLeaderDialog(playerid);
				
				if(PlayerInfo[strval(inputtext)][pMember] != PlayerInfo[playerid][pMember])
				return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в вашей организации."), ShowPlayerLeaderDialog(playerid);
				
				new string[128];
				
				format(string,sizeof(string), ""COL_BLUE"\n[%d] %s уволил вас из организации "COL_WHITE"%s\n",playerid,Name(playerid),fraction_name[PlayerInfo[playerid][pLeader]]);
				ShowPlayerDialog(strval(inputtext), DIALOG_ID_NONE, D_S_M,""COL_ORANGE"Увольнение из организации",string, "Принять", "");
				
				PlayerInfo[strval(inputtext)][pMember] = 0;
				PlayerInfo[strval(inputtext)][pMemberWarn] = 0;
				PlayerInfo[strval(inputtext)][pMemberSkin] = 0;
				PlayerInfo[strval(inputtext)][pRankName] = 0;
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	        {
	            ShowPlayerLeaderDialog(playerid);
	        }
	    }
		
	    case DIALOG_ID_WARNMEMBER:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {
	                ShowPlayerDialog(playerid, DIALOG_ID_WARNMEMBER, D_S_I, ""COL_ORANGE"Дать выговор", "\
					"COL_BLUE"Введите ID игрока, которому вы хотите дать выговор:\n\
					", "Принять", "Назад");
	                return 1;
	            }
				
	            if (strval(inputtext) == INVALID_PLAYER_ID || !IsPlayerConnected(strval(inputtext)) || gPlayerLogged[strval(inputtext)] == false) 
				return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети."), ShowPlayerLeaderDialog(playerid);
			
				if(strval(inputtext) == playerid) 
				return SendClientMessage(playerid, COLOR_GREY, "Вы ввели свой ID."), ShowPlayerLeaderDialog(playerid);
				
				if(PlayerInfo[strval(inputtext)][pMember] != PlayerInfo[playerid][pMember]) 
				return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в вашей организации."), ShowPlayerLeaderDialog(playerid);
				
				PlayerInfo[strval(inputtext)][pMemberWarn] += 1;
				
				new string[128];
				
				format(string,sizeof(string), ""COL_BLUE"\n[%d] %s дал вам выговор. Количество выговоров: "COL_WHITE"%d\n",playerid,Name(playerid),PlayerInfo[strval(inputtext)][pMemberWarn]);
				ShowPlayerDialog(strval(inputtext), DIALOG_ID_NONE, D_S_M,""COL_ORANGE"Выговор",string, "Принять", "");
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	        {
	            ShowPlayerLeaderDialog(playerid);
	        }
	    }
		
	    case DIALOG_ID_UNWARNMEMBER:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {
	                ShowPlayerDialog(playerid, DIALOG_ID_UNWARNMEMBER, D_S_I, ""COL_ORANGE"Снять выговор", "\
					"COL_BLUE"Введите ID игрока, которому вы хотите снять выговор:\n\
					", "Принять", "Назад");
	                return 1;
	            }
				
	            if (strval(inputtext) == INVALID_PLAYER_ID || !IsPlayerConnected(strval(inputtext)) || gPlayerLogged[strval(inputtext)] == false) 
				return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети."), ShowPlayerLeaderDialog(playerid);
			
				if(strval(inputtext) == playerid) 
				return SendClientMessage(playerid, COLOR_GREY, "Вы ввели свой ID."), ShowPlayerLeaderDialog(playerid);
				
				if(PlayerInfo[strval(inputtext)][pMember] != PlayerInfo[playerid][pMember]) 
				return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в вашей организации."), ShowPlayerLeaderDialog(playerid);
				
				PlayerInfo[strval(inputtext)][pMemberWarn] -= 1;
				
				new string[128];
				
				format(string,sizeof(string), ""COL_BLUE"\n[%d] %s снял вам выговор. Количество выговоров: "COL_WHITE"%d\n",playerid,Name(playerid),PlayerInfo[strval(inputtext)][pMemberWarn]);
				ShowPlayerDialog(strval(inputtext), DIALOG_ID_NONE, D_S_M,""COL_ORANGE"Снятие выговора",string, "Принять", "");
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	        {
	            ShowPlayerLeaderDialog(playerid);
	        }
	    }
		
	    case DIALOG_ID_SETMEMBERRANK:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {
	                ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERRANK, D_S_I, ""COL_ORANGE"Установить ранг", "\
					"COL_BLUE"Введите ID игрока, которому вы хотите установить ранг:\n\
					", "Принять", "Назад");
	                return 1;
	            }
	            if (strval(inputtext) == INVALID_PLAYER_ID || !IsPlayerConnected(strval(inputtext)) || gPlayerLogged[strval(inputtext)] == false) 
				return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети."), ShowPlayerLeaderDialog(playerid);
			
				if(PlayerInfo[strval(inputtext)][pMember] != PlayerInfo[playerid][pMember]) 
				return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в вашей организации."), ShowPlayerLeaderDialog(playerid);
			
				SetPVarInt(playerid, "MemberRangID", strval(inputtext));
				new string[128];
				format(string,sizeof(string), ""COL_BLUE"Введите название ранга для игрока "COL_WHITE"[%d] %s\n",strval(inputtext),Name(strval(inputtext)));
				ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERRANKNAME, D_S_I,""COL_ORANGE"Установить ранг",string, "Принять", "Назад");
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	        {
	            ShowPlayerLeaderDialog(playerid);
	        }
	    }
		
	    case DIALOG_ID_SETMEMBERRANKNAME:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            new string[128];
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {
	                format(string,sizeof(string), ""COL_BLUE"Введите название ранга для игрока "COL_WHITE"[%d] %s\n",strval(inputtext),Name(strval(inputtext)));
					ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERRANKNAME, D_S_I,""COL_ORANGE"Установить ранг",string, "Принять", "Назад");
	                return 1;
	            }
	            if (GetPVarInt(playerid, "MemberRangID") == INVALID_PLAYER_ID || !IsPlayerConnected(GetPVarInt(playerid, "MemberRangID"))
					|| gPlayerLogged[GetPVarInt(playerid, "MemberRangID")] == false) 
				return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
			
				if(PlayerInfo[GetPVarInt(playerid, "MemberRangID")][pMember] != PlayerInfo[playerid][pMember]) 
				return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в вашей организации.");
			
				strmid(PlayerInfo[GetPVarInt(playerid, "MemberRangID")][pRankName], inputtext, 0, strlen(inputtext), 32);
				
				SendClientMessage(playerid, COLOR_GREEN,"Ранг установлен.");
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	        {
	            ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERRANK, D_S_I, ""COL_ORANGE"Установить ранг", "\
				"COL_BLUE"Введите ID игрока, которому вы хотите установить ранг:\n\
				", "Принять", "Назад");
    			return 1;
	        }
	    }
		
		case DIALOG_ID_SETMEMBERSKINID:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {
	                ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERSKINID, D_S_I, ""COL_ORANGE"Установить скин", "\
					"COL_BLUE"Введите ID игрока, которому вы хотите установить скин:\n\
					", "Принять", "Назад");
	                return 1;
	            }
	            if (strval(inputtext) == INVALID_PLAYER_ID || !IsPlayerConnected(strval(inputtext)) || gPlayerLogged[strval(inputtext)] == false) 
				return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети."), ShowPlayerLeaderDialog(playerid);
			
				if(PlayerInfo[strval(inputtext)][pMember] != PlayerInfo[playerid][pMember]) 
				return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в вашей организации."), ShowPlayerLeaderDialog(playerid);
			
				SetPVarInt(playerid, "MemberSkinID", strval(inputtext));
				
				new string[128];
				format(string,sizeof(string), ""COL_BLUE"Введите номер скина для игрока "COL_WHITE"[%d] %s\n",strval(inputtext),Name(strval(inputtext)));
				ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERSKIN, D_S_I,""COL_ORANGE"Установить скин",string, "Принять", "Назад");
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	        {
	            ShowPlayerLeaderDialog(playerid);
	        }
	    }
		
	    case DIALOG_ID_SETMEMBERSKIN:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            new string[128];
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {
	                format(string,sizeof(string), ""COL_BLUE"Введите номер скина для игрока "COL_WHITE"[%d] %s\n",strval(inputtext),Name(strval(inputtext)));
					ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERSKIN, D_S_I,""COL_ORANGE"Установить скин",string, "Принять", "Назад");
	                return 1;
	            }
	            if (GetPVarInt(playerid, "MemberSkinID") == INVALID_PLAYER_ID || !IsPlayerConnected(GetPVarInt(playerid, "MemberSkinID"))
					|| gPlayerLogged[GetPVarInt(playerid, "MemberSkinID")] == false) 
				return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
			
				if(PlayerInfo[GetPVarInt(playerid, "MemberSkinID")][pMember] != PlayerInfo[playerid][pMember]) 
				return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в вашей организации.");
			
				PlayerInfo[GetPVarInt(playerid, "MemberSkinID")][pMemberSkin] = strval(inputtext);
				
				SendClientMessage(playerid, COLOR_GREEN,"Скин установлен.");
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	        {
	            ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERSKINID, D_S_I, ""COL_ORANGE"Установить скин", "\
				"COL_BLUE"Введите ID игрока, которому вы хотите установить скин:\n\
				", "Принять", "Назад");
    			return 1;
	        }
	    }
		
	    case DIALOG_ID_RENTMOPED:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
                if(PlayerInfo[playerid][pMoney] < CENA_ARENDI) 
				return SendClientMessage(playerid, COLOR_RED,"У вас недостаточно денег.");
			
                PlayerInfo[playerid][pMoney] -= CENA_ARENDI;
                SetPVarInt(playerid, "DostupRentCar", 1);
                SendClientMessage(playerid, COLOR_WHITE,"Вы можете взять любой мопед на парковке.");
	        }
		}
		
		case DIALOG_ID_RENTMOPEDON:
	    {
	        if(response)
			{
				SendClientMessage(playerid, COLOR_WHITE,"Удачной дороги!");
				SetPVarInt(playerid, "DostupRentCar", 0);
				return 1;
			}
	        else	RentCar[playerid] = 0;
		}
		
		case DIALOG_ID_GETAPED:
		{
			if(response)
			{
				if(PlayerInfo[playerid][pMoney] < CENA_APED) return SendClientMessage(playerid, COLOR_PROX,"Моника говорит: "COL_WHITE"Этих денег недостаточно.");
				
				PlayerInfo[playerid][pMoney] = PlayerInfo[playerid][pMoney] - CENA_APED;
				PlayerInfo[playerid][pAPED] = 1;
				PlayerInfo[playerid][pAPEDBattery] = TENHOURS;
				
				GangZoneHideForPlayer(playerid, blackmap);
				TogglePlayerClock(playerid, 1);
				
				SendClientMessage(playerid, COLOR_PROX,"Моника говорит: "COL_WHITE"Теперь Вам будет комфортно жить в Angel Pine, поздравляю!");
				new string[MAX_PLAYER_NAME+1+46];
				
				format(string, sizeof(string), "%s передает деньги Монике и берет со стола APED.", Name(playerid));
				ProxDetector(playerid, COLOR_PROX, string, 10);
				
			}
			else SendClientMessage(playerid, COLOR_PROX,"Моника говорит: "COL_WHITE"Приходите в любое время!");
		}
		
		case DIALOG_ID_SELLCAR:
		{
			if(response)	ShowPlayerDialog(playerid, DIALOG_ID_SELLCARPRICE, D_S_I,""COL_ORANGE"Продажа транспорта",""COL_WHITE"Введите сумму, которую хотите получить за продажу транспорта:\n\n",
			"Принять","Отмена");
			else SendClientMessage(playerid, COLOR_PROX,"Алекс говорит: "COL_WHITE"Как надумаете продать свой транспорт - приходите!");
		}
		
		case DIALOG_ID_SELLCARPRICE:
		{
			if(response)
			{
				new string[170];
				
				if(!strlen(inputtext))
				return	ShowPlayerDialog(playerid, DIALOG_ID_SELLCARPRICE, D_S_I,""COL_ORANGE"Продажа транспорта",""COL_WHITE"Введите сумму, которую хотите получить за продажу транспорта:\n\n"
				,"Принять","Отмена");
			
				format(string,sizeof(string), ""COL_WHITE"Вы получите "COL_GREEN"%d $"COL_WHITE".\nВаш транспорт будет продаваться за "COL_GREEN"%d $"COL_WHITE" с учетом налога на продажу.\n\
				Вы согласны на сделку?", strval(inputtext), floatround(strval(inputtext) * NALOG_BUYCAR / 100 + strval(inputtext), floatround_ceil));
				ShowPlayerDialog(playerid, DIALOG_ID_SELLCARSUCCESS, D_S_M,""COL_ORANGE"Продажа транспорта",string, "Да", "Нет");
				
				SetPVarInt(playerid, "PriceCar", strval(inputtext));
			}
			else SendClientMessage(playerid, COLOR_PROX,"Алекс говорит: "COL_WHITE"Как надумаете продать свой транспорт - приходите!");
		}
		
		case DIALOG_ID_SELLCARSUCCESS:
		{			
			if(response)
			{
				new carid = PlayerInfo[playerid][pCarKey],
					string2[50],
					Float:x,Float:y,Float:z,Float:a;
				
				strmid(Veh[carid][vOwner], "Angel Pine", 0, 10, 11);
				Veh[carid][vPrice] = floatround(GetPVarInt(playerid, "PriceCar") * NALOG_BUYCAR / 100 + GetPVarInt(playerid, "PriceCar"), floatround_ceil);
				
				kazna += floatround(GetPVarInt(playerid, "PriceCar") * NALOG_BUYCAR / 100, floatround_ceil);
				SaveKazna();
				
				Veh[carid][vBuy] = VBUYTOBUY;
				Veh[carid][vLock] = 0;
				
				PlayerInfo[playerid][pCarKey] = 0;
				PlayerInfo[playerid][pMoney] = PlayerInfo[playerid][pMoney] + GetPVarInt(playerid, "PriceCar");
			
				format(string2, sizeof(string2), "Продается\nСтоимость: "COL_GREEN"%i $",Veh[carid][vPrice]);
				sellveh[carid] = Create3DTextLabel(string2, COLOR_PROX, 0, 0, 0, 5.0, 0, 0);
				Attach3DTextLabelToVehicle(Text3D:sellveh[carid], carid, 0.0, 0.0, 0.8);	

				GetVehiclePos(carid, x, y, z);	
				GetVehicleZAngle(carid, a);				
				
				Veh[carid][vVx] = x;// Устанавливаем позицию
				Veh[carid][vVy] = y;// Устанавливаем позицию
				Veh[carid][vVz] = z;// Устанавливаем позицию
				Veh[carid][vVa] = a;// Устанавливаем позицию
			
				GameTextForPlayer(playerid, FixText("~G~Транспорт продан"), 1500, 3);
				
				SaveVeh();
			}
			else ShowPlayerDialog(playerid, DIALOG_ID_SELLCARPRICE, D_S_I,""COL_ORANGE"Продажа транспорта",""COL_WHITE"Введите сумму, которую хотите получить за продажу транспорта:\n"
			,"Принять","Отмена");
		}
		
		case DIALOG_ID_CHANGECLOTHES: 
		{
			if(response)
			{
				new string[MAX_PLAYER_NAME+1+12];
				
				format(string, sizeof(string), "%s переодевается.", Name(playerid));
				ProxDetector(playerid, COLOR_PROX, string, 10);
				
				ShowFonForPlayer(playerid);
				
				IsPlayerBlackScreen[playerid] = true;

				GiveEndurance(playerid, -2);				
				
				SetTimerEx("BlackScreenTimer", 800, 0, "i", playerid);
			}
		}
		
		case DIALOG_ID_APEDMENU:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						ShowPlayerPlayerInfoDialog(playerid);					
					}
					case 1:
					{
						
					}					
					case 2:
					{
						ShowPlayerLeaderDialog(playerid);
					}					
					case 3:
					{
						ShowPlayerAPEDSettingsDialog(playerid);
					}
					case 4:
					{
						
					}					
				}
			}
			return 1;
		}
		
		case DIALOG_ID_PLAYERINFODIALOG:
		{	
			if(!response)
			{
				ShowPlayerAPEDDialog(playerid);
			}
		}
		
		case DIALOG_ID_APEDSETTINGS:
		{	
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						if(!ClockIsOn[playerid])
						{
							ClockIsOn[playerid] = true;
							TogglePlayerClock(playerid, 1);
							
						}
						else
						{
							ClockIsOn[playerid] = false;
							TogglePlayerClock(playerid, 0);	
						}
						
						ShowPlayerAPEDSettingsDialog(playerid);
					}
					case 1:
					{
						if(!MapIsOn[playerid])
						{
							MapIsOn[playerid] = true;
							GangZoneHideForPlayer(playerid, blackmap);
							
						}
						else
						{
							MapIsOn[playerid] = false;
							GangZoneShowForPlayer(playerid, blackmap, 255);						
						}
						
						ShowPlayerAPEDSettingsDialog(playerid);
					}										
				}
			}
			else ShowPlayerAPEDDialog(playerid);
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(PlayerInfo[playerid][pReg] == 1)
	{
		if(clickedid == Text:INVALID_TEXT_DRAW) // They pressed ESC to cancel the keypad, so close it and call OnPlayerKeypadInput with 'type'  KEYPAD_INPUT_CANCEL
		{
			TextDrawShowForPlayer(playerid, skin[0]); 
			TextDrawShowForPlayer(playerid, skin[1]); 
			TextDrawShowForPlayer(playerid, skin[2]); 
			SelectTextDraw(playerid, 0x2641FEAA);
		}
		if(clickedid == skin[0])//left 
		{ 
			cskin[playerid]--; 
			if(PlayerInfo[playerid][pSex] == 1)
			{ 
				if(cskin[playerid] < 0) cskin[playerid] = 3; 
				SetPlayerSkin(playerid, ManSkinList[cskin[playerid]]); 
				PlayerInfo[playerid][pSkin] = ManSkinList[cskin[playerid]];
			} 
			else if(PlayerInfo[playerid][pSex] == 2)
			{ 
				if(cskin[playerid] < 0) cskin[playerid] = 3; 
				SetPlayerSkin(playerid, WomanSkinList[cskin[playerid]]); 
				PlayerInfo[playerid][pSkin] = WomanSkinList[cskin[playerid]];
			} 
		} 
		else if(clickedid == skin[1])//right 
		{ 
			cskin[playerid]++; 
			if(PlayerInfo[playerid][pSex] == 1)
			{ 
				if(cskin[playerid] > 3) cskin[playerid] = 0; 
				SetPlayerSkin(playerid, ManSkinList[cskin[playerid]]); 
			} 
			else if(PlayerInfo[playerid][pSex] == 2)
			{ 
				if(cskin[playerid] > 3) cskin[playerid] = 0; 
				SetPlayerSkin(playerid, WomanSkinList[cskin[playerid]]); 
			} 
		} 
		else if(clickedid == skin[2])//select 
		{ 
			TextDrawHideForPlayer(playerid, skin[0]); 
			TextDrawHideForPlayer(playerid, skin[1]); 
			TextDrawHideForPlayer(playerid, skin[2]); 
			CancelSelectTextDraw(playerid); 
			
			PlayerInfo[playerid][pSkin] = GetPlayerSkin(playerid);
			PlayerInfo[playerid][pReg] = 2;
			gPlayerLogged[playerid] = true;
			
			SetPlayerPosCW(playerid, -2273.9778,-2204.9294,30.9775,216.1406, 0, 0);
			
			SpawnPlayer(playerid);
		}  
	}
    return 0;
}

public OnPlayerKeypadInput(playerid, keypadID, type, key) // 'key' contains the number that has already been entered in it's entirety
{			
	if(type == KEYPAD_INPUT_BAD)	GameTextForPlayer(playerid, FixText("~R~Доступ запрещен"), 1500, 3);
	
	if(keypadID == KEYPAD_POLICE && type == KEYPAD_INPUT_GOOD)
	{
		GameTextForPlayer(playerid, FixText("~G~Дверь открывается"), 1500, 3);
		MoveObject (LSPDDoor, 250.4400000,62.7500000,1002.6000000+0.01, 0.01, 0.0000000,0.0000000,180.0000000);		
		LSPDDoorOpen = true;		
	}
	
	if(keypadID == KEYPAD_POLICE2 && type == KEYPAD_INPUT_GOOD)
	{
		GameTextForPlayer(playerid, FixText("~G~Дверь открывается"), 1500, 3);
		MoveObject (LSPDDoor2, 245.7998000,72.3496100,1002.6000000+0.02, 0.01, 0.0000000,0.0000000,270.0000000);		
		LSPDDoor2Open = true;	
	}
	
	if(keypadID == KEYPAD_BANKDOOR && type == KEYPAD_INPUT_GOOD)
	{
		GameTextForPlayer(playerid, FixText("~G~Дверь открывается"), 1500, 3);
		MoveObject (BankDoor, 2150.3604000,1605.7998000,1006.5200000+0.1, 0.05, 0.0000000,0.0000000,90.0000000);		
		BankDoorOpen = true;
	}
	
	if(keypadID == KEYPAD_BANKDOOR2 && type == KEYPAD_INPUT_GOOD)
	{
		GameTextForPlayer(playerid, FixText("~G~Дверь открывается"), 1500, 3);
		MoveObject (BankDoor2, 2147.0801000,1604.7002000,1006.5000000+0.1, 0.05, 0.0000000,0.0000000,90.0000000);		
		BankDoor2Open = true;	
	}
	
	if(keypadID == KEYPAD_BANKDOOR3 && type == KEYPAD_INPUT_GOOD)
	{
		GameTextForPlayer(playerid, FixText("~G~Дверь открывается"), 1500, 3);
		MoveObject (BankDoor3, 2149.8301000,1603.5996000,1002.3000000+0.01, 0.01, 0.0000000,0.0000000,179.9950000);	
		BankDoor3Open = true;	
	}
	
	if(keypadID == KEYPAD_VAULTDOOR && type == KEYPAD_INPUT_GOOD)
	{	
		GameTextForPlayer(playerid, FixText("~G~Доступ разрешен"), 1500, 3);
		MoveObject (VaultDoor, 2145.0000000,1625.9000000,994.2600100, 0.04, 0.0000000,0.0000000,270.0000000);		
		VaultDoorOpen = true;
		VaultDoorTime = TIME_VAULTDOORCLOSE;		
	}
	
	if(keypadID == KEYPAD_VAULTGATE && type == KEYPAD_INPUT_GOOD)
	{
		GameTextForPlayer(playerid, FixText("~G~Доступ разрешен"), 1500, 3);
		MoveObject (VaultGate, 2138.2000000,1606.9000000,994.2000100, 0.5, 0.0000000,0.0000000,179.9950000);		
		VaultGateOpen = true;	
	}
	
	if(keypadID == KEYPAD_FIREDOOR && type == KEYPAD_INPUT_GOOD)
	{
		GameTextForPlayer(playerid, FixText("~G~Дверь открывается"), 1500, 3);
		MoveObject (FireDoor, 253.0996100,108.5800800,1002.2000000+0.01, 0.01, 0.0000000,0.0000000,180.0000000);		
		FireDoorOpen = true;		
	}
	
	if(keypadID == KEYPAD_FIREDOOR2 && type == KEYPAD_INPUT_GOOD)
	{
		GameTextForPlayer(playerid, FixText("~G~Дверь открывается"), 1500, 3);
		MoveObject (FireDoor2, 239.7500000,118.0898400,1002.2000000+0.01, 0.01, 0.0000000,0.0000000,0.0000000);		
		FireDoor2Open = true;	
	}
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
 	{
 		SetVehiclePos(GetPlayerVehicleID(playerid), fX, fY, fZ);
 		PutPlayerInVehicle(playerid, GetPlayerVehicleID(playerid), 0);
 	}
 	else
 	{
 		SetPlayerPos(playerid, fX, fY, fZ);
 	}
 	SetPlayerVirtualWorld(playerid, 0);
 	SetPlayerInterior(playerid, 0);
    return 1;
}


/////////////////////////////////////////////                    Команды Команды               / ///////////////////////////

////////////////////////////////                                АВТОМОБИЛИ

CMD:vmenu(playerid, params[])
{
	if(GetAroundPlayerVehicleID(playerid, 4.0) == PlayerInfo[playerid][pCarKey] || 
	Veh[GetAroundPlayerVehicleID(playerid, 4.0)][vBuy] == PlayerInfo[playerid][pMember])
 	{
  		new listitems[] = ""COL_BLUE"[1] - Открыть двери\n[2] - Закрыть двери\n[3] - Открыть багажник\n[4] - Закрыть багажник\n[5] - Открыть капот\n[6] - Закрыть капот\n";
    	ShowPlayerDialog(playerid, DIALOG_ID_VMENU, D_S_L, ""COL_ORANGE"Функции транспорта", listitems, "Выбрать", "Отмена");
    }
    return 1;
}

CMD:refill(playerid, params[])
{
    new	str[256], 
		carid = GetPlayerVehicleID(playerid);
		
    if(!IsPlayerInAnyVehicle(playerid)) return 1;
	
    if(!IsAtGasStation(playerid)) 
	return SendClientMessage(playerid, COLOR_GREY,"Вы находитесь далеко от АЗС.");

    if(GetPVarInt(playerid, "Refill") == 1) return 1;
	
    GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
    if(engine) return SendClientMessage(playerid, COLOR_RED,"Заглушите двигатель вашего транспортного средства.");
	
    TogglePlayerControllable(playerid,0);
    format(str,sizeof(str), ""COL_BLUE"\nЗдравствуйте, вас приветствует АЗС округа 'Angel Pine'\nВведите количество процентов, которое вы хотите наполнить в бензобак вашего транспорта:\n\
	Стоимость одного процента: "COL_GREEN"%d $",CENA_BENZ);
	ShowPlayerDialog(playerid, DIALOG_ID_REFILL, D_S_I,""COL_ORANGE"АЗС",str,"Принять","Отмена");
    return 1;
}

CMD:cveh(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
    if(sscanf(params,"iiii", params[0], params[1], params[2],params[3])) 
	return SendClientMessage(playerid, COLOR_GREY, "CMD: /cveh [ID транспорта] [цвет 1] [цвет 2] [цена]");

    if (params[0] < 400 || params[0] > 611) 
	return SendClientMessage(playerid, COLOR_GREY,"ID транспорта от 400 до 611.");

    new Float:x,Float:y,Float:z,Float:a;// Массив для позиции
	
    GetPlayerPos(playerid,x,y,z);// Узнаём позицию игрока
    GetPlayerFacingAngle(playerid,a);// Узнаём угол поворота игрока
    LastCar++;// Прибавляем к последней добавленной машине одну
	
    Veh[LastCar][vAdd] = 1;// Устанавливаем проверку на созданную машину
    Veh[LastCar][vModel] = params[0];// Устанавливаем модель машине
    Veh[LastCar][vVx] = x;// Устанавливаем позицию
    Veh[LastCar][vVy] = y;// Устанавливаем позицию
    Veh[LastCar][vVz] = z;// Устанавливаем позицию
    Veh[LastCar][vVa] = a;// Устанавливаем позицию
    Veh[LastCar][vColor] = params[1];// Устанавливаем машине цвет
    Veh[LastCar][vColor2] = params[2];// Устанавливаем машине цвет
    strmid(Veh[LastCar][vOwner], "Angel Pine", 0, 10, 11);
    Veh[LastCar][vPrice] = params[3];
    Veh[LastCar][vBuy] = VBUYTOSELL;
    Veh[LastCar][vLock] = 0;
    Veh[LastCar][vFuel] = 100;
	
    CreateVehicle(Veh[LastCar][vModel],Veh[LastCar][vVx]+2,Veh[LastCar][vVy]+2,Veh[LastCar][vVz]+1,Veh[LastCar][vVa],Veh[LastCar][vColor],Veh[LastCar][vColor2],60000);//
	return 1;
}

CMD:parkveh(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid)) 
	return SendClientMessage(playerid, COLOR_GREY, "Вы не в транспорте.");

    new Float:x,Float:y,Float:z,Float:a,
		currentveh = GetPlayerVehicleID(playerid),
		string[50];
		
	if(Veh[currentveh][vBuy] != VBUYTOSELL)
	return SendClientMessage(playerid, COLOR_GREY, "Данный транспорт не подлежит продаже.");
		
    GetPlayerPos(playerid,x,y,z);// Узнаём позицию игрока
    GetVehicleZAngle(currentveh, a);
	
    Veh[LastCar][vVx] = x;// Устанавливаем позицию
    Veh[LastCar][vVy] = y;// Устанавливаем позицию
    Veh[LastCar][vVz] = z;// Устанавливаем позицию
    Veh[LastCar][vVa] = a;// Устанавливаем позицию
	
	Veh[LastCar][vBuy] = VBUYTOBUY;
	
	format(string, sizeof(string), "Продается\nСтоимость: "COL_GREEN"%i $",Veh[LastCar][vPrice]);
	sellveh[LastCar] = Create3DTextLabel(string, COLOR_PROX, 0, 0, 0, 5.0, 0, 0 );
	Attach3DTextLabelToVehicle(Text3D:sellveh[LastCar], LastCar, 0.0, 0.0, 0.8);
	
	GameTextForPlayer(playerid, FixText("~G~Транспорт припаркован"), 1000, 3);
	
   	SaveVeh();// Сохраненяем машину
   	return 1;
}

CMD:fixcar(playerid, params[])
{
	if(FixCarTime[playerid] > 0) return 1;
	
	new veh = GetAroundPlayerVehicleID(playerid, 3.0),
		Float:VehicleHP;
	
    if (PlayerInfo[playerid][pMember] != 5) return 1;
	
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, -2396.5737,-2187.4832,33.4849))
	return SendClientMessage(playerid, COLOR_GREY,"Вам нужно находится в мастерской рядом с транспортом.");

	if(veh == INVALID_VEHICLE_ID || IsPlayerInAnyVehicle(playerid))
	return SendClientMessage(playerid, COLOR_GREY,"Вам нужно находится рядом с транспортом.");
		
	SetPVarInt(playerid, "VehID", veh);

	TogglePlayerControllable(playerid, 0);
	ApplyAnimation(playerid, "SHOP", "SHP_Serve_Loop", 4.1, 1, 1, 1, 1, 0, 1);

	SendClientMessage(playerid, COLOR_WHITE,"Вы приступили к ремонту транспорта.");
	
    GetVehicleHealth(veh, VehicleHP);
    if(VehicleHP >= 800.0) FixCarTime[playerid] = random(10)+10;
	else if(VehicleHP >= 500.0 && VehicleHP < 800.0) FixCarTime[playerid] = random(10)+30;
	else if(VehicleHP < 500.0) FixCarTime[playerid] = random(10)+50;
	
	GiveEndurance(playerid, -FixCarTime[playerid]);

	SetPVarInt(playerid,"FixCarTimer", SetTimerEx("FixCarTimer", 1000, false, "i", playerid));
    return 1;
}

CMD:tunecar(playerid, params[])
{
	
    if (PlayerInfo[playerid][pMember] != 5) return 1;
	
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, -2396.5737,-2187.4832,33.4849))
	return SendClientMessage(playerid, COLOR_GREY,"Вам нужно находится в мастерской рядом с транспортом.");
		
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) 
	return ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, D_S_L, ""COL_ORANGE"Тюнинг транспорта", ""COL_BLUE"Винилы\nПокраска\nКапот\nВентиляционные отверстия\nПодфарники\nВыхлопная труба\n\
	Передний бампер\nЗадний бампер\nКрыша\nСпойлер\nБоковые юбки\nНавесной бампер\nКолеса\nУсилители звука\nГидравлика\nЗакись азота", "Выбрать", "Отмена");	
	else SendClientMessage(playerid, COLOR_RED, "Вам нужно находится в транспорте.");
    return 1;
}

CMD:tow(playerid, params[])
{	
	new vehicleid = GetPlayerVehicleID(playerid),
		Float:x, Float:y, Float:z,
		Float:dist, Float:closedist = 8, closeveh;
	
	if (PlayerInfo[playerid][pMember] != 5) return 1;
	
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || GetVehicleModel(GetPlayerVehicleID(playerid)) != 525) 
	return SendClientMessage(playerid, COLOR_GREY, "Вам нужно находится в эвакуаторе.");

	if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))) 
	return DetachTrailerFromVehicle(GetPlayerVehicleID(playerid)), GameTextForPlayer(playerid, FixText("~L~Транспорт отцеплен"), 1000, 3);

	for(new i=1; i < MAX_VEHICLES; i++)
	{
		if(i != vehicleid && GetVehiclePos(i, x, y, z))
		{
			dist = GetPlayerDistanceFromPoint(playerid, x, y, z);
			if(dist < closedist)
			{
				closedist = dist;
				closeveh = i;
			}
		}
	}
	if(closeveh) return AttachTrailerToVehicle(closeveh, vehicleid), GameTextForPlayer(playerid, FixText("~G~Транспорт зацеплен"), 1000, 3); 
	return 1;
}

CMD:veh(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
    new Float:X,Float:Y,Float:Z;
	
	GetPlayerPos(playerid, X,Y,Z);
	
	if(sscanf(params,"d", params[0]))
	return SendClientMessage(playerid, COLOR_GREY, "CMD: /veh [ID транспорта]");

	if (params[0] < 400 || params[0] > 611) 
	return SendClientMessage(playerid, COLOR_GREY,"ID транспорта от 400 до 611.");

    CreateVehicle(params[0], X+1,Y+2,Z+1, 0.0, 0, 0, 60000);
	PutPlayerInVehicle(playerid, GetAroundPlayerVehicleID(playerid, 3), 0);
	return 1;
}

CMD:vehid(playerid, params[])
{
    new vehname[128];
	if (IsPlayerInAnyVehicle(playerid))
	{
		SendClientMessage(playerid,COLOR_RED,"-----------------------------------------");
		format(vehname, sizeof(vehname), "Name: %s",VehicleNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400]);
		SendClientMessage(playerid,COLOR_WHITE,vehname);
		format(vehname, sizeof(vehname), "Model ID: %d",GetVehicleModel(GetPlayerVehicleID(playerid)));
		SendClientMessage(playerid,COLOR_WHITE,vehname);
		format(vehname, sizeof(vehname), "Vehicle ID: %d",GetPlayerVehicleID(playerid));
		SendClientMessage(playerid,COLOR_WHITE,vehname);
		SendClientMessage(playerid,COLOR_RED,"-----------------------------------------");
	}
	return 1;
}

CMD:setvehhp(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid))
		SetVehicleHealth(GetPlayerVehicleID(playerid), 301.0);
	
	return 1;
}


////////////////////// АДМИНСКИЕ

CMD:makeleader(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
    
    extract params -> new player:target;	else
	return SendClientMessage(playerid,COLOR_GREY,"CMD: /makeleader [ID игрока]");

    if (target == INVALID_PLAYER_ID || !IsPlayerConnected(target) || gPlayerLogged[target] == false)
	return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    static const
        fmt_dlg_header[] = "Назначить лидером игрока "COL_WHITE"[%d] %s",
        fmt_dlg[] = "%s%s\n";

    new
        header_string[sizeof(fmt_dlg_header) + (-2+MAX_PLAYER_NAME+1) + (-2+5)],
        dialog_string[(sizeof(fmt_dlg) + (-2+MAX_FRACTION_NAME_LENGTH))*MAX_FRACTIONS];

    format(header_string, sizeof(header_string), fmt_dlg_header, target, PlayerInfo[target][pName]);

    for(new i = 0; i < MAX_FRACTIONS; i++)
        format(dialog_string, sizeof(dialog_string), fmt_dlg, dialog_string, fraction_name[i]);

    ShowPlayerDialog(playerid, DIALOG_ID_SETLEADER, D_S_L, header_string, dialog_string, "Выбрать", "Отмена");

    SetPVarInt(playerid, "makeleader_target", target);
    return 1;
}

CMD:kick(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	if(sscanf(params,"is[30]",params[0],params[1])) 
	return SendClientMessage(playerid,COLOR_GREY,"CMD: /kick [ID игрока] [Причина]");

	if (params[0] == INVALID_PLAYER_ID || !IsPlayerConnected(params[0]) || gPlayerLogged[params[0]] == false) 
	return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

	new str[128],
		string[128];
		
    format(str,sizeof(str),"Администратор [%d] %s кикнул игрока [%d] %s причина: %s",playerid,Name(playerid),params[0],Name(params[0]), params[1]);
    SendClientMessageToAll(COLOR_RED, str);
	
	format(string,sizeof(string), ""COL_BLUE"Вы были кикнуты администратором %s\nПричина: "COL_WHITE"%s\n", Name(playerid) ,params[1]);
	ShowPlayerDialog(params[0], DIALOG_ID_KICK, D_S_M,""COL_ORANGE"Kick",string, "Принять", "");
	
	TogglePlayerControllable(params[0], 0);
	
	WriteLog("Kick",str);
	return 1;
}

CMD:ban(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	if(sscanf(params,"is[30]",params[0],params[1])) 
	return SendClientMessage(playerid,COLOR_GREY,"CMD: /ban [ID игрока] [Причина]");

	if (params[0] == INVALID_PLAYER_ID || !IsPlayerConnected(params[0]) || gPlayerLogged[params[0]] == false) 
	return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
	new str[128],
		string[128];
		
    format(str,sizeof(str),"Администратор [%d] %s забанил игрока [%d] %s причина: %s", playerid,Name(playerid),params[0],Name(params[0]), params[1]);
    SendClientMessageToAll(COLOR_RED, str);
	
	format(string,sizeof(str), ""COL_BLUE"Вы были забанены администратором %s\nПричина: "COL_WHITE"%s\n", Name(playerid) ,params[1]);
	ShowPlayerDialog(params[0], DIALOG_ID_BAN, D_S_M,""COL_ORANGE"Ban",string, "Принять", "");
	
	TogglePlayerControllable(params[0], 0);
	
	WriteLog("Ban",str);
	return 1;
}

CMD:makeadmin(playerid, params[])
{
    //if (PlayerInfo[playerid][pAdmin] < 5) return 1;
    if (sscanf(params, "dd", params[0], params[1])) 
	return SendClientMessage(playerid, COLOR_GREY, "CMD: /makeadmin [ID игрока] [Уровень администратора]");

    if (params[0] == INVALID_PLAYER_ID || !IsPlayerConnected(params[0]) || gPlayerLogged[params[0]] == false) 
	return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    if (params[1] > 5 || params[1] < 0) 
	return SendClientMessage(playerid, COLOR_GREY,"Уровень администратора от 1 до 5.");

    PlayerInfo[params[0]][pAdmin] = params[1];
	
    new str[128];
	
    format(str,sizeof(str),"Администратор [%d] %s назначил игрока [%d] %s Администратором %d уровня", playerid,Name(playerid),params[0],Name(params[0]), params[1]);
    SendClientMessageToAll(COLOR_RED, str);
    return 1;
}

CMD:cc(playerid,params[])
{
	if(PlayerInfo[playerid][pAdmin] == 0) return 1;
   
	for( new i = 0; i <= 50; i ++ ) SendClientMessageToAll( COLOR_WHITE, "" );
	return 1;
}

CMD:setsex(playerid,params[])
{
	if(PlayerInfo[playerid][pSex] == 1) return PlayerInfo[playerid][pSex] = 2;
	else PlayerInfo[playerid][pSex] = 1;
	return 1;
}

CMD:a(playerid, params[])
{
    new string[145];
	if(PlayerInfo[playerid][pAdmin] == 0) return 1;
	
	if(sscanf(params, "s[145]", params[0])) 
	return SendClientMessage(playerid, COLOR_GREY, "CMD: /a [Сообщение]");

	format(string, sizeof(string), ""COL_ORANGE"Администратор [%d] %s: "COL_WHITE"%s", playerid,Name(playerid), params[0]);
	MessageToAdmin(COLOR_WHITE, string);
	return true;
}

CMD:setmoney(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
    if(sscanf(params,"ui", params[0], params[1])) 
	return SendClientMessage(playerid, COLOR_GREY, "CMD: /setmoney [ID игрока] [Кол-во денег]");

    PlayerInfo[params[0]][pMoney] = params[1];
    return true;
}

CMD:sethunger(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
    if(sscanf(params,"ui", params[0], params[1])) 
	return SendClientMessage(playerid, COLOR_GREY, "CMD: /sethunger [ID игрока] [Кол-во голода]");

    PlayerInfo[params[0]][pHunger] = params[1];
    return true;
}

CMD:setendurance(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
    if(sscanf(params,"ui", params[0], params[1])) 
	return SendClientMessage(playerid, COLOR_GREY, "CMD: /setendurance [ID игрока] [Кол-во выносливости]");

    PlayerInfo[params[0]][pEndurance] = params[1];
    return true;
}

CMD:setbattery(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
    if(sscanf(params,"ui", params[0], params[1])) 
	return SendClientMessage(playerid, COLOR_GREY, "CMD: /setbattery [ID игрока] [Заряд батареи]");

    PlayerInfo[params[0]][pAPEDBattery] = params[1];
    return true;
}

CMD:goto(playerid, params[])
{    
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
    
	if(sscanf(params,"d", params[0]))return SendClientMessage(playerid, COLOR_GREY, "CMD: /goto [ID игрока]");
	
	if (params[0] == INVALID_PLAYER_ID || !IsPlayerConnected(params[0]) || gPlayerLogged[params[0]] == false)
	return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(params[0], x, y, z);
	
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
 	{
 		SetVehiclePos(GetPlayerVehicleID(playerid), x+1, y+1, z);
		SetPlayerInterior(playerid, GetPlayerInterior(params[0]));
 		PutPlayerInVehicle(playerid, GetPlayerVehicleID(playerid), 0);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(params[0]));
 	}
	SetPlayerPos(playerid, x + 0.5, y + 0.5, z + 0.5);
	SetPlayerInterior(playerid, GetPlayerInterior(params[0]));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(params[0]));
	
    new str[MAX_PLAYER_NAME+1+45];
	
    format(str,sizeof(str),"Администратор [%d] %s телепортировался к вам.", playerid,Name(playerid));
    SendClientMessage(params[0],COLOR_BRIGHTRED, str);
	
    format(str,sizeof(str),"Вы телепортировались к игроку [%d] %s.",params[0],Name(params[0]));
    SendClientMessage(playerid,COLOR_BRIGHTRED, str);
	return 1;
}

CMD:gotox(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	if(sscanf(params,"fffd", params[0],params[1],params[2],params[3]))
	return SendClientMessage(playerid, COLOR_GREY, "CMD: /gotox [X] [Y] [Z] [ID интерьера]");

    SetPlayerPos(playerid, params[0],params[1],params[2]+1);
    SetPlayerInterior(playerid, params[3]);
	return 1;
}

CMD:gotoap(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
    SetPlayerPos(playerid, -1938.713745, -2468.400878, 30.772167);
    SetPlayerInterior(playerid, 0);
   	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}

CMD:gethere(playerid, params[])
{
    new Float:x, Float:y, Float:z,
		str[128];
		
    GetPlayerPos(playerid, x, y, z);
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	if(sscanf(params,"d", params[0]))
	return SendClientMessage(playerid, COLOR_GREY, "CMD: /gethere [ID игрока]");

	if (params[0] == INVALID_PLAYER_ID || !IsPlayerConnected(params[0]) || gPlayerLogged[params[0]] == false) 
	return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

	if(GetPlayerState(params[0]) == PLAYER_STATE_DRIVER)
 	{
 		SetVehiclePos(GetPlayerVehicleID(params[0]), x+1, y+1, z);
		LinkVehicleToInterior(GetPlayerVehicleID(params[0]), GetPlayerInterior(playerid));
 		PutPlayerInVehicle(params[0], GetPlayerVehicleID(params[0]), 0);
 	}
 	SetPlayerPos(params[0], x+1, y+1, z);
	SetPlayerInterior(params[0], GetPlayerInterior(playerid));
	SetPlayerVirtualWorld(params[0], GetPlayerVirtualWorld(playerid));
	
    format(str,sizeof(str),"Администратор [%d] %s телепортировал вас к себе.", playerid,Name(playerid));
    SendClientMessage(params[0],COLOR_BRIGHTRED, str);
	
    format(str,sizeof(str),"Вы телепортировали игрока [%d] %s к себе.",params[0],Name(params[0]));
    SendClientMessage(playerid,COLOR_BRIGHTRED, str);
	return 1;
}

CMD:givegun(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	//sscanf(params,"uii", params[0], params[1], params[2]);
    if(sscanf(params,"uii", params[0], params[1], params[2])) return SendClientMessage(playerid, COLOR_GREY, "CMD: /givegun [ID игрока] [ID оружия] [Кол-во патронов]");
    if(params[1] > 47 || params[1] < 1) return SendClientMessage(playerid, COLOR_GREY,"ID оружия от 1 до 46.");
    GivePlayerWeapon(params[0], params[1], params[2]);
    return true;
}


CMD:chouse1(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	if(sscanf(params,"i", params[0])) 
	return SendClientMessage(playerid, COLOR_GREY, "CMD: /chouse1 [цена]");

    new Float:x,Float:y,Float:z,Float:a;// Массив для позиции
	
    GetPlayerPos(playerid,x,y,z);// Узнаём позицию игрока
    GetPlayerFacingAngle(playerid,a);// Узнаём угол поворота игрока
    LastHouse++;// Прибавляем к последней добавленной машине одну
	
    House[LastHouse][hEnterX] = x;
    House[LastHouse][hEnterY] = y;
    House[LastHouse][hEnterZ] = z;
    House[LastHouse][hEnterA] = a;
    House[LastHouse][hEnterX] = x;
    House[LastHouse][hPrice] = params[0];
    strmid(House[LastHouse][hOwner], "Angel Pine", 0, 11, 999);
	
    HouseEnter[LastHouse] = CreatePickup(1273, 23, x, y, z, 0);
	
    SaveHouse();
    return 1;
}
CMD:chouse2(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
    new Float:x,Float:y,Float:z,Float:a;// Массив для позиции
	
    GetPlayerPos(playerid,x,y,z);// Узнаём позицию игрока
    GetPlayerFacingAngle(playerid,a);// Узнаём угол поворота игрока
	
    House[LastHouse][hExitX] = x;
    House[LastHouse][hExitY] = y;
    House[LastHouse][hExitZ] = z;
    House[LastHouse][hExitA] = a;
    House[LastHouse][hInt] = GetPlayerInterior(playerid);
    House[LastHouse][hVirt] = LastHouse;
    House[LastHouse][hOwned] = 0;
    House[LastHouse][hLock] = 0;
    House[LastHouse][hAdd] = 1;
	
    HouseExit[LastHouse] = CreatePickup(1273, 23, x, y, z, LastHouse);
	
	SetPlayerVirtualWorld(playerid, LastHouse);
	
    SaveHouse();
    return 1;
}

CMD:center(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	if(sscanf(params,"i, s[50]", params[0], params[1])) 
	return SendClientMessage(playerid, COLOR_GREY, "CMD: /center [Виртуальный мир] [Описание]");

    new Float:x,Float:y,Float:z,Float:a;// Массив для позиции
	
    GetPlayerPos(playerid,x,y,z);// Узнаём позицию игрока
    GetPlayerFacingAngle(playerid,a);// Узнаём угол поворота игрока
	
    LastEnter++;
    EnterInfo[LastEnter][eEnterX] = x;
    EnterInfo[LastEnter][eEnterY] = y;
    EnterInfo[LastEnter][eEnterZ] = z;
    EnterInfo[LastEnter][eEnterA] = a;
	EnterInfo[LastEnter][eEnterInt] = GetPlayerInterior(playerid);
    EnterInfo[LastEnter][eEnterVirt] = params[0];
    strmid(EnterInfo[LastEnter][eDesc], params[1], 0, strlen(params[1]), 999);
	
    Create3DTextLabel(EnterInfo[LastEnter][eDesc], COLOR_PROX, EnterInfo[LastEnter][eEnterX], EnterInfo[LastEnter][eEnterY], EnterInfo[LastEnter][eEnterZ], 7.0,
	EnterInfo[LastEnter][eEnterVirt], 0);
	CreatePickup(1272, 23, EnterInfo[LastEnter][eEnterX], EnterInfo[LastEnter][eEnterY], EnterInfo[LastEnter][eEnterZ], EnterInfo[LastEnter][eEnterVirt]);
	
	SetPlayerVirtualWorld(playerid, LastEnter);
	
    SaveEnter();
    return 1;
}
CMD:cexit(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	if(sscanf(params,"i", params[0])) 
	return SendClientMessage(playerid, COLOR_GREY, "CMD: /cexit [Виртуальный мир]");
	
    new Float:x,Float:y,Float:z,Float:a;// Массив для позиции
	
    GetPlayerPos(playerid,x,y,z);// Узнаём позицию игрока
    GetPlayerFacingAngle(playerid,a);// Узнаём угол поворота игрока
	
    EnterInfo[LastEnter][eExitX] = x;
    EnterInfo[LastEnter][eExitY] = y;
    EnterInfo[LastEnter][eExitZ] = z;
    EnterInfo[LastEnter][eExitA] = a;
    EnterInfo[LastEnter][eExitInt] = GetPlayerInterior(playerid);
    EnterInfo[LastEnter][eExitVirt] = params[0];
    EnterInfo[LastEnter][eAdd] = 1;
	
	CreatePickup(1272, 23, EnterInfo[LastEnter][eExitX], EnterInfo[LastEnter][eExitY], EnterInfo[LastEnter][eExitZ], EnterInfo[LastEnter][eExitVirt]);
	
	SetPlayerVirtualWorld(playerid, LastEnter);
	
    SaveEnter();
    return 1;
}

/////////////////////////////////////////////        ПОЛЬЗОВАТЕЛЬСКИЕ


CMD:hi(playerid, params[])
{
	if(sscanf(params,"i", params[0])) 
	return SendClientMessage(playerid, COLOR_GREY, "CMD: /hi [ID игрока]");
	
	if(IsPlayerInAnyVehicle(playerid)) return 1;
	
    if (params[0] == INVALID_PLAYER_ID || !IsPlayerConnected(params[0]) || gPlayerLogged[params[0]] == false)
	return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

	if(params[0] == playerid)  return  SendClientMessage(playerid,COLOR_GREY,"Вы указали свой ID.");
	
	if (IsPlayerNearPlayer(2.0, playerid, params[0]))
    {		
		new Float:angle,
			string[20+MAX_PLAYER_NAME+1*2];
		
		GetPlayerFacingAngle(playerid, angle);
		SetPlayerFacingAngle(params[0], angle + 180);
		
		format(string,sizeof(string),"%s пожимает руку %s.",Name(playerid), Name(params[0]));
		ProxDetector(playerid,COLOR_PROX, string, 10.0);
		
		ApplyAnimation(playerid,"GANGS","hndshkfa",4.0,0,0,0,0,0,1);
		ApplyAnimation(params[0],"GANGS","hndshkfa",4.0,0,0,0,0,0,1);
		return true;
	}
	else return SendClientMessage(playerid, COLOR_GREY, "Этот человек далеко от вас!");
}

CMD:report(playerid, params[])
{
    if(sscanf(params, "s[144]", params[0])) return SendClientMessage(playerid, COLOR_GREY, "CMD: /report [текст вопроса/жалобы]");
	
    new string[100 + MAX_PLAYER_NAME+1];
	
    format(string,sizeof(string),""COL_ORANGE""COL_RED"[REPORT]"COL_ORANGE" от игрока [%d] %s : "COL_WHITE"%s", playerid, Name(playerid), params[0]);
    MessageToAdmin(COLOR_WHITE, string);
	
    SendClientMessage(playerid, COLOR_GREEN, "Вы успешно отправили сообщение администрации.");
    return 1;
}

CMD:test(playerid, params[])
{
    ViewFactions(playerid);
    return 1;
}



/////////////////////////////////////////////                    Стоки Стоки Стоки                //////////////////////////////




SavePlayer(playerid)
{
    if(gPlayerLogged[playerid] != true) return 1;
    UpdatePlayerPosition(playerid);
    new string[64];
    format(string, sizeof(string), "Users/%s.ini", Name(playerid));
    new iniFile = ini_openFile(string);
    ini_setString(iniFile,"Pass",PlayerInfo[playerid][pPass]);
    ini_setInteger(iniFile,"Admin",PlayerInfo[playerid][pAdmin]);
    ini_setInteger(iniFile,"Money",PlayerInfo[playerid][pMoney]);
    ini_setInteger(iniFile,"Sex",PlayerInfo[playerid][pSex]);
    ini_setInteger(iniFile,"Skin",PlayerInfo[playerid][pSkin]);
    ini_setInteger(iniFile, "Reg", PlayerInfo[playerid][pReg]);
    ini_setFloat(iniFile, "Pos_x", PlayerInfo[playerid][pPos_x]);
	ini_setFloat(iniFile, "Pos_y", PlayerInfo[playerid][pPos_y]);
	ini_setFloat(iniFile, "Pos_z", PlayerInfo[playerid][pPos_z]);
	ini_setFloat(iniFile, "Fa", PlayerInfo[playerid][pFa]);
	ini_setInteger(iniFile, "Int", PlayerInfo[playerid][pInt]);
	ini_setInteger(iniFile, "World", PlayerInfo[playerid][pWorld]);
	ini_setInteger(iniFile, "CarKey", PlayerInfo[playerid][pCarKey]);
	ini_setInteger(iniFile, "MoneyDolg", PlayerInfo[playerid][pMoneyDolg]);
	ini_setInteger(iniFile, "Member", PlayerInfo[playerid][pMember]);
	ini_setInteger(iniFile, "Leader", PlayerInfo[playerid][pLeader]);
	ini_setInteger(iniFile, "Job", PlayerInfo[playerid][pJob]);
	ini_setInteger(iniFile, "MemberSkin", PlayerInfo[playerid][pMemberSkin]);
	ini_setInteger(iniFile, "Rank", PlayerInfo[playerid][pRank]);
	ini_setInteger(iniFile, "MemberWarn", PlayerInfo[playerid][pMemberWarn]);
	ini_setString(iniFile,"RankName",PlayerInfo[playerid][pRankName]);
	ini_setInteger(iniFile, "APED", PlayerInfo[playerid][pAPED]);
	ini_setInteger(iniFile, "APEDBattery", PlayerInfo[playerid][pAPEDBattery]);
	ini_setInteger(iniFile, "Hunger", PlayerInfo[playerid][pHunger]);
	ini_setInteger(iniFile, "Endurance", PlayerInfo[playerid][pEndurance]);
	ini_setInteger(iniFile, "EnduranceMax", PlayerInfo[playerid][pEnduranceMax]);
    ini_closeFile(iniFile);
    return 1;
}

OnPlayerRegister(playerid, password[])
{
    if(IsPlayerConnected(playerid))
    {
        new string[64];// Масив с путём для файла
        format(string,sizeof(string), "Users/%s.ini", Name(playerid));
        new iniFile = ini_createFile(string);// Создаём файл с именем игрока в папке players
        if(iniFile < 0)// Если Файла нет
        {
            iniFile = ini_openFile(string);// Открываем
        }
        if(iniFile >= 0)// Если файл есть
        {
            strmid(PlayerInfo[playerid][pPass],password,0,strlen(password),255);// Присваиваем масиву pPass, значение password[]
            ini_setString(iniFile,"Pass",PlayerInfo[playerid][pPass]);
			ini_setInteger(iniFile,"Admin",0);
   			ini_setInteger(iniFile,"Money",100);
			ini_setInteger(iniFile,"Sex", GetPVarInt(playerid, "Sex"));
			ini_setInteger(iniFile,"Skin", GetPVarInt(playerid, "Skin"));
		 	ini_setInteger(iniFile,"Reg", 1);
			ini_setFloat(iniFile, "Pos_x", -2230.6531);
			ini_setFloat(iniFile, "Pos_y", -1739.9501);
			ini_setFloat(iniFile, "Pos_z", 481.7513);
			ini_setFloat(iniFile, "Fa", 40.9857);
			ini_setInteger(iniFile, "Int", 0);
			ini_setInteger(iniFile, "World", 0);
			ini_setInteger(iniFile, "CarKey", 0);
			ini_setInteger(iniFile, "MoneyDolg", 0);
			ini_setInteger(iniFile, "Member", 0);
			ini_setInteger(iniFile, "Leader", 0);
			ini_setInteger(iniFile, "Job", 0);
			ini_setInteger(iniFile, "MemberSkin", 0);
			ini_setInteger(iniFile, "Rank", 0);
			ini_setInteger(iniFile, "MemberWarn", 0);
			ini_setString(iniFile,"RankName", "0");
			ini_setInteger(iniFile, "APED", 0);
			ini_setInteger(iniFile, "APEDBattery", 0);
			ini_setInteger(iniFile, "Hunger", SEVENHOURS);
			ini_setInteger(iniFile, "Endurance", SEVENHOURS);
			ini_setInteger(iniFile, "EnduranceMax", SEVENHOURS);
            ini_closeFile(iniFile);// Закрываем файл
        }
		
		PlayerInfo[playerid][pSex] = GetPVarInt(playerid, "Sex");
		PlayerInfo[playerid][pSkin] = GetPVarInt(playerid, "Skin");
		PlayerInfo[playerid][pMoney] = 100;
		PlayerInfo[playerid][pReg] = 1;	
		
		PlayerInfo[playerid][pHunger] = SEVENHOURS;
		PlayerInfo[playerid][pEndurance] = SEVENHOURS;	
		PlayerInfo[playerid][pEnduranceMax] = SEVENHOURS;			

		SetSkin(playerid);
    }
    return 1;
}

OnPlayerLogin(playerid,password[])
{
    if(IsPlayerConnected(playerid))// Проверка на подключение игрока
    {
        new string[64];// Масив с путём для файла
        new pass[64];// Масив с паролем
        format(string,sizeof(string), "Users/%s.ini", Name(playerid));// Добавляем имя игрока, в путь для загрузки
        new iniFile = ini_openFile(string);// Открываем файл
        ini_getString(iniFile,"Pass",pass,64);// Загружаем пароль
        if(strcmp(pass,password,true) == 0)// Если введёный пароль, соответсвует паролю при регистрации, то загружаем акк
        {
            ini_getString(iniFile,"Pass",PlayerInfo[playerid][pPass],64);
			ini_getInteger(iniFile,"Admin",PlayerInfo[playerid][pAdmin]);
			ini_getInteger(iniFile,"Money",PlayerInfo[playerid][pMoney]);
			ini_getInteger(iniFile,"Sex",PlayerInfo[playerid][pSex]);
			ini_getInteger(iniFile,"Skin",PlayerInfo[playerid][pSkin]);
			ini_getInteger(iniFile,"Reg",PlayerInfo[playerid][pReg]);
			ini_getFloat(iniFile, "Pos_x", PlayerInfo[playerid][pPos_x]);
			ini_getFloat(iniFile, "Pos_y", PlayerInfo[playerid][pPos_y]);
			ini_getFloat(iniFile, "Pos_z", PlayerInfo[playerid][pPos_z]);
			ini_getFloat(iniFile, "Fa", PlayerInfo[playerid][pFa]);
			ini_getInteger(iniFile, "Int", PlayerInfo[playerid][pInt]);
			ini_getInteger(iniFile, "World", PlayerInfo[playerid][pWorld]);
			ini_getInteger(iniFile, "CarKey", PlayerInfo[playerid][pCarKey]);
			ini_getInteger(iniFile, "MoneyDolg", PlayerInfo[playerid][pMoneyDolg]);
			ini_getInteger(iniFile, "Member", PlayerInfo[playerid][pMember]);
			ini_getInteger(iniFile, "Leader", PlayerInfo[playerid][pLeader]);
			ini_getInteger(iniFile, "Job", PlayerInfo[playerid][pJob]);
			ini_getInteger(iniFile, "MemberSkin", PlayerInfo[playerid][pMemberSkin]);
			ini_getInteger(iniFile, "Rank", PlayerInfo[playerid][pRank]);
			ini_getInteger(iniFile, "MemberWarn", PlayerInfo[playerid][pMemberWarn]);
			ini_getString(iniFile,"RankName",PlayerInfo[playerid][pRankName],64);
			ini_getInteger(iniFile, "APED", PlayerInfo[playerid][pAPED]);
			ini_getInteger(iniFile, "APEDBattery", PlayerInfo[playerid][pAPEDBattery]);
			ini_getInteger(iniFile, "Hunger", PlayerInfo[playerid][pHunger]);
			ini_getInteger(iniFile, "Endurance", PlayerInfo[playerid][pEndurance]);
			ini_getInteger(iniFile, "EnduranceMax", PlayerInfo[playerid][pEnduranceMax]);
            ini_closeFile(iniFile);// Закрываем файл
        }
        else// Если пароль не верен..
        {
            ini_closeFile(iniFile);// Закрываем файл
            ShowPlayerDialog(playerid, DIALOG_ID_LOGIN, D_S_P,""COL_ORANGE"Окно Входа",""COL_BLUE"Добрый день!\nВаш аккаунт есть на сервере.\nВведите свой пароль в поле:","Ввод","Выход");
            return 1;
        }
        gPlayerLogged[playerid] = true;
        TogglePlayerSpectating(playerid, false);
        
    }
    return 1;
}

UpdatePlayerPosition(playerid)
{
    if(GetPVarInt(playerid, "IsPlayerSpawn") == 0) return 1;
    new Float:x, Float:y, Float:z,Float:fa;
    GetPlayerPos(playerid,x,y,z);
    GetPlayerFacingAngle(playerid, fa);
    PlayerInfo[playerid][pPos_x] = x;
    PlayerInfo[playerid][pPos_y] = y;
    PlayerInfo[playerid][pPos_z] = z;
    PlayerInfo[playerid][pFa] = fa;
    PlayerInfo[playerid][pInt] = GetPlayerInterior(playerid);
    PlayerInfo[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
    return 1;
}


LoadHouses()
{
    new string[160],str[16],arrCoords[15][160];// Необходимые массивы
    new iniFile = ini_openFile("houseinfo.ini");// Выбираем файл для загрузки, и открываем
    {
        for(new h = 1; h < MAX_HOUSES; h++)// Цикл авто
        {
            format(str,sizeof(str),"hID %d",h);// Выбираем какой ид загружать
            ini_getString(iniFile,str,string);// Загружаем ид
            split(string,arrCoords,',');// Разделяем загруженные числа запятой
            House[h][hAdd] = strval(arrCoords[0]);// Загружаем проверку на созданую машину
            if(House[h][hAdd] != 0)// Если машина создана, то..
            {
                strmid(House[h][hOwner], arrCoords[1], 0, strlen(arrCoords[1]), MAX_PLAYER_NAME+1);// Загружаем модель
                House[h][hPrice] = strval(arrCoords[2]);// Загружаем позицию
                House[h][hEnterX] = floatstr(arrCoords[3]);// Загружаем позицию
                House[h][hEnterY] = floatstr(arrCoords[4]);// Загружаем позицию
                House[h][hEnterZ] = floatstr(arrCoords[5]);// Загружаем угол поворота
                House[h][hEnterA] = floatstr(arrCoords[6]);// Загружаем цвет
                House[h][hExitX] = floatstr(arrCoords[7]);// Загружаем второй цвет
                House[h][hExitY] = floatstr(arrCoords[8]);
                House[h][hExitZ] = floatstr(arrCoords[9]);
                House[h][hExitA] = floatstr(arrCoords[10]);
                House[h][hInt] = strval(arrCoords[11]);
                House[h][hVirt] = strval(arrCoords[12]);
                House[h][hOwned] = strval(arrCoords[13]);
                House[h][hLock] = strval(arrCoords[14]);
                LastHouse++;
            }
        }
        ini_closeFile(iniFile);// Закрываем файл
    }
}


SaveHouse()
{
    new string[160],str[32];// Необходимые массивы
    new iniFile = ini_openFile("houseinfo.ini");// Выбираем файл для записи, и открываем
    for(new h = 1; h < MAX_HOUSES; h++)// Цикл авто
    {
        format(string,sizeof(string),"%d ,%s, %d, %f, %f, %f, %f, %f, %f, %f, %f, %d, %d, %d, %d",// Выбираем что записывать..
        House[h][hAdd],
		House[h][hOwner],
		House[h][hPrice],
		House[h][hEnterX],
		House[h][hEnterY],
		House[h][hEnterZ],
		House[h][hEnterA],
		House[h][hExitX],
		House[h][hExitY],
		House[h][hExitZ],
		House[h][hExitA],
		House[h][hInt],
		House[h][hVirt],
		House[h][hOwned],
		House[h][hLock]
        );
        format(str,sizeof(str),"hID %d",h);// записываем ид машины
        ini_setString(iniFile,str,string);// записываем ид машины
    }
    ini_closeFile(iniFile);// Закрываем файл
}


LoadEnters()
{
    new string[200],str[16],arrCoords[15][160];// Необходимые массивы
    new iniFile = ini_openFile("enterinfo.ini");// Выбираем файл для загрузки, и открываем
    {
        for(new e = 1; e < MAX_ENTERS; e++)// Цикл авто
        {
            format(str,sizeof(str),"eID %d",e);// Выбираем какой ид загружать
            ini_getString(iniFile,str,string);// Загружаем ид
            split(string,arrCoords,',');// Разделяем загруженные числа запятой
            EnterInfo[e][eAdd] = strval(arrCoords[0]);
            if(EnterInfo[e][eAdd] != 0)
            {
                EnterInfo[e][eEnterX] = floatstr(arrCoords[1]);
                EnterInfo[e][eEnterY] = floatstr(arrCoords[2]);
                EnterInfo[e][eEnterZ] = floatstr(arrCoords[3]);
                EnterInfo[e][eEnterA] = floatstr(arrCoords[4]);
                EnterInfo[e][eExitX] = floatstr(arrCoords[5]);
                EnterInfo[e][eExitY] = floatstr(arrCoords[6]);
                EnterInfo[e][eExitZ] = floatstr(arrCoords[7]);
                EnterInfo[e][eExitA] = floatstr(arrCoords[8]);
                EnterInfo[e][eEnterInt] = strval(arrCoords[9]);
                EnterInfo[e][eEnterVirt] = strval(arrCoords[10]);
				EnterInfo[e][eExitInt] = strval(arrCoords[11]);
                EnterInfo[e][eExitVirt] = strval(arrCoords[12]);
                strmid(EnterInfo[e][eDesc], arrCoords[13], 1, strlen(arrCoords[13]), 60);
                LastEnter++;
            }
        }
        ini_closeFile(iniFile);// Закрываем файл
    }
}


SaveEnter()
{
    new string[200],str[32];// Необходимые массивы
    new iniFile = ini_openFile("enterinfo.ini");// Выбираем файл для записи, и открываем
    for(new e = 1; e < MAX_ENTERS; e++)
    {
        format(string,sizeof(string),"%d, %f, %f, %f, %f, %f, %f, %f, %f, %d, %d, %d, %d, %s",// Выбираем что записывать..
        EnterInfo[e][eAdd],
		EnterInfo[e][eEnterX],
		EnterInfo[e][eEnterY],
		EnterInfo[e][eEnterZ],
		EnterInfo[e][eEnterA],
		EnterInfo[e][eExitX],
		EnterInfo[e][eExitY],
		EnterInfo[e][eExitZ],
		EnterInfo[e][eExitA],
		EnterInfo[e][eEnterInt],
		EnterInfo[e][eEnterVirt],
		EnterInfo[e][eExitInt],
		EnterInfo[e][eExitVirt],
		EnterInfo[e][eDesc]
        );
        format(str,sizeof(str),"eID %d",e);// записываем ид
        ini_setString(iniFile,str,string);// записываем ид
    }
    ini_closeFile(iniFile);// Закрываем файл
}

LoadVeh()
{
    new string[128],str[16],arrCoords[13][128];// Необходимые массивы
    new iniFile = ini_openFile("vehicle.ini");// Выбираем файл для загрузки, и открываем
    {
        for(new v = 1; v < MAX_VEHICLES; v++)// Цикл Авто
        {
            format(str,sizeof(str),"vID %d",v);// Выбираем какой ид загружать
            ini_getString(iniFile,str,string);// Загружаем ид
            split(string,arrCoords,',');// Разделяем загруженные числа запятой
            Veh[v][vAdd] = strval(arrCoords[0]);// Загружаем проверку на созданую машину
            if(Veh[v][vAdd] != 0)// Если машина создана, то..
            {
                Veh[v][vModel] = strval(arrCoords[1]);// Загружаем модель
                Veh[v][vVx] = floatstr(arrCoords[2]);// Загружаем позицию
                Veh[v][vVy] = floatstr(arrCoords[3]);// Загружаем позицию
                Veh[v][vVz] = floatstr(arrCoords[4]);// Загружаем позицию
                Veh[v][vVa] = floatstr(arrCoords[5]);// Загружаем угол поворота
                Veh[v][vColor] = strval(arrCoords[6]);// Загружаем цвет
                Veh[v][vColor2] = strval(arrCoords[7]);// Загружаем второй цвет
                strmid(Veh[v][vOwner], arrCoords[8], 1, strlen(arrCoords[8]), MAX_PLAYER_NAME+1);
                Veh[v][vPrice] = strval(arrCoords[9]);
                Veh[v][vBuy] = strval(arrCoords[10]);
                Veh[v][vLock] = strval(arrCoords[11]);
                Veh[v][vFuel] = strval(arrCoords[12]);
                LastCar++;// Прибавляем машину к общему колличеству
            }
        }
        ini_closeFile(iniFile);// Закрываем файл
    }
}

SaveVeh()
{
    new string[128],str[32];// Необходимые массивы
    new iniFile = ini_openFile("vehicle.ini");// Выбираем файл для записи, и открываем
    for(new v = 1; v < MAX_VEHICLES; v++)// Цикл авто
    {
        format(string,sizeof(string),"%d, %d, %f, %f, %f, %f, %d, %d, %s, %d, %d, %d, %d",// Выбираем что записывать..
        Veh[v][vAdd],// Проверка на созданную машину
        Veh[v][vModel],// Модель машины
        Veh[v][vVx],// Позиция x
        Veh[v][vVy],// Позиция y
        Veh[v][vVz],// Позиция z
        Veh[v][vVa],// Угол поворота
        Veh[v][vColor],// Цвет 1
        Veh[v][vColor2],
        Veh[v][vOwner],
        Veh[v][vPrice],
        Veh[v][vBuy],
        Veh[v][vLock],
        Veh[v][vFuel]
        );
        format(str,sizeof(str),"vID %d",v);// записываем ид машины
        ini_setString(iniFile,str,string);// записываем ид машины
    }
    ini_closeFile(iniFile);// Закрываем файл
}

SaveWood()
{
	new iniFile = ini_openFile("Wood.ini");
 	ini_setInteger(iniFile,"Wood",drev);
 	ini_closeFile(iniFile);
	return true;
}

LoadWood()
{
	new iniFile = ini_openFile("Wood.ini");
 	ini_getInteger(iniFile,"Wood",drev);
  	ini_closeFile(iniFile);
  	return true;
}

SaveKazna()
{
	new iniFile = ini_openFile("Kazna.ini");
 	ini_setInteger(iniFile,"Kazna",kazna);
 	ini_closeFile(iniFile);
	return true;
}

LoadKazna()
{
	new iniFile = ini_openFile("Kazna.ini");
 	ini_getInteger(iniFile,"Kazna",kazna);
  	ini_closeFile(iniFile);
  	return true;
}

WriteLog(namelog[],string[])
{
    new text[256],log[50],computation1, computation2, computation3,File:LogFile,i;
    gettime(computation1, computation2, computation3);
    format(text, sizeof(text), "[%02d:%02d:%02d]%s\r\n",computation1,computation2,computation3,string);
    getdate(computation1, computation2, computation3);
    format(log,sizeof(log),"logs/%s/%02d.%02d.%d.ini",namelog,computation3,computation2,computation1);
    LogFile = fopen(log, io_append);
    while (text[i] != EOS)
    {
        fputchar(LogFile, text[i], false);
        i++;
    }
    fclose(LogFile);
}

MessageToAdmin(color, const string[])
{
    foreach(Player, i)
	if(IsPlayerConnected(i)) if(PlayerInfo[i][pAdmin] > 0)
	SendClientMessage(i, color, string);
    return 1;
}

PreloadAnimLib(playerid, animlib[])
{
    ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}

split(const strsrc[], strdest[][], delimiter)
{
    new i, li;
    new aNum;
    new len;
    while(i <= strlen(strsrc)){
        if(strsrc[i]==delimiter || i==strlen(strsrc)){
            len = strmid(strdest[aNum], strsrc, li, i, 128);
            strdest[aNum][len] = 0;
            li = i+1;
            aNum++;
        }
        i++;
    }
    return 1;
}

ProxDetector(playerid,color,msg[],Float:radius)
{
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	foreach(Player, i)
	{
		if(IsPlayerInRangeOfPoint(i,radius,x,y,z) && GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
		SendClientMessage(i,color,msg);    
	}
	return 1;
}

stock GetAroundPlayerVehicleID(playerid, Float:radius)
{
    new Float:vp[3],vehid = INVALID_VEHICLE_ID;
    for(new i = MAX_VEHICLES; i != 0; --i)
    {
        GetVehiclePos(i,vp[0],vp[1],vp[2]);
        if(IsPlayerInRangeOfPoint(playerid,radius,vp[0],vp[1],vp[2])) {
            vehid = i;
            break;
        }
    }
    return vehid;
}  

/*IsPlayerInWater(playerid)
{
    if(GetPlayerAnimationIndex(playerid))
    {
        new
            animlib[32],
            animname[32];
        GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, sizeof(animlib), animname, sizeof(animname));
        if((strcmp(animlib, "SWIM", true) == 0) || (strcmp(animlib, "PED", true) == 0 && strcmp(animname, "Swim_Tread", true) == 0)) return 1;
    }
    return 0;
}*/

/*IsPlayerCarry(playerid)
{
    if(GetPlayerAnimationIndex(playerid))
    {
        new
            animlib[32],
            animname[32];
        GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, sizeof(animlib), animname, sizeof(animname));
        if((strcmp(animlib, "PED", true) == 0) && strcmp(animname, "crry_prtial", true) == 0) return 1;
    }
    return 0;
}*/

IsPlayerIdle(playerid)
{
    if(GetPlayerAnimationIndex(playerid))
    {
        new
            animlib[32],
            animname[32];
        GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, sizeof(animlib), animname, sizeof(animname));
        if((strcmp(animlib, "PED", true) == 0) && strcmp(animname, "IDLE_stance", true) == 0) return 1;
		if((strcmp(animlib, "PED", true) == 0) && strcmp(animname, "CLIMB_jump2fall", true) == 0) return 1;
		if((strcmp(animlib, "PED", true) == 0) && strcmp(animname, "CLIMB_Stand_finish", true) == 0) return 1;
		if((strcmp(animlib, "PED", true) == 0) && strcmp(animname, "FALL_land", true) == 0) return 1;
		if((strcmp(animlib, "PED", true) == 0) && strcmp(animname, "FALL_collapse", true) == 0) return 1;
    }
    return 0;
}

IsPlayerRun(playerid)
{
    new Keys,ud,lr;
	GetPlayerKeys(playerid,Keys,ud,lr);
	
	if((lr == KEY_RIGHT || lr == KEY_LEFT || ud == KEY_DOWN || ud == KEY_UP) && PlayerRun[playerid] == true && !IsPlayerInAnyVehicle(playerid))
	return 1;
	return 0;
}

IsPlayerJump(playerid)
{
    if(GetPlayerAnimationIndex(playerid))
    {
        new
            animlib[32],
            animname[32];
        GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, sizeof(animlib), animname, sizeof(animname));
		if((strcmp(animlib, "PED", true) == 0) && strcmp(animname, "JUMP_LAUNCH", true) == 0) return 1;
		if((strcmp(animlib, "PED", true) == 0) && strcmp(animname, "JUMP_GLIDE", true) == 0) return 1;
    }
    return 0;
}

/*ReturnTypeVehicle (model)
{
    if ( 400 > model > 611 ) return -1;
    switch ( model )
    {
        case 509,481,510: return VELO;
        case 461..463,448,581,521..523,586,468,471: return MOTO;
        case 417,425,447,469,487,488,497,548,563: return HELICOPTER;
        case 460,476,511..513,519,520,553,577,592,593: return AIRPLANE;
        case 435,450,569,570,584,590,591,606..608,610,611: return TRAILER;
        case 472,473,493,595,484,430,453,452,446,454: return BOAT;
        case 499,498,609,524,578,455,403,414,443,514,515,408,456,433: return AUTO_B;
        case 441,464,465,501,564,594: return RC;
        default: return AUTO_A;
    }
    return -1;
}*/

NoEngine(veh)
{
    switch (GetVehicleModel(veh))
    {
        case 	509,481,510,417,425,447,469,487,488,497,548,563,460,476,511..513,519,520,553,577,592,593,435,450,569,570,584,590,591,606..608,
				610,611,472,473,493,595,484,430,452,454,441,464,465,501,564,594:
        return 1;
    }
    return 0;
}

GetVehicleSpeed(vehicleid)
{
    new Float:x, Float:y, Float:z;
    GetVehicleVelocity(vehicleid, x, y, z);
    return floatround(floatsqroot(x*x+y*y+z*z)*150);
}

IsAtGasStation(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
	
	if(	IsPlayerInRangeOfPoint(playerid, 10.0, -2232.4133,-2565.5027,32.1500) || 
		IsPlayerInRangeOfPoint(playerid, 10.0, -1539.2720,-2742.5432,48.5376)) return 1;
	return 0;
}

ShowPlayerLeaderDialog(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_ID_LMENU, D_S_L, ""COL_ORANGE"Меню лидера", "\
	"COL_WHITE"[1] "COL_BLUE"Члены организации\n\
	"COL_WHITE"[2] "COL_BLUE"Принять игрока\n\
	"COL_WHITE"[3] "COL_BLUE"Уволить игрока\n\
	"COL_WHITE"[4] "COL_BLUE"Дать выговор\n\
	"COL_WHITE"[5] "COL_BLUE"Снять выговор\n\
	"COL_WHITE"[6] "COL_BLUE"Установить ранг\n\
	"COL_WHITE"[7] "COL_BLUE"Установить скин\n\
	", "Выбрать", "Назад");
	return true;
}

ShowPlayerAPEDDialog(playerid)
{
	new Float:battery,
		d37[60];
		
	static D37[] = ""COL_ORANGE"Меню APED.     Заряд батареи: "COL_WHITE"[%d %%]";
		
	battery = floatround(PlayerInfo[playerid][pAPEDBattery] / 360, floatround_ceil);
	
	format(d37, sizeof(d37), D37, battery);
	
	ShowPlayerDialog(playerid, DIALOG_ID_APEDMENU, D_S_L, D37, "\
	"COL_WHITE"[1] "COL_BLUE"Информация о Вашем состоянии\n\
	"COL_WHITE"[2] "COL_BLUE"Действия\n\
	"COL_WHITE"[3] "COL_BLUE"Меню организации\n\
	"COL_WHITE"[4] "COL_BLUE"Настройки\n\
	"COL_WHITE"[5] "COL_BLUE"Помощь\n\
	", "Выбрать", "Закрыть");
	return true;
}

ShowPlayerAPEDSettingsDialog(playerid)
{
	static D36[] = 
			""COL_BLUE"Функция: \t"COL_WHITE"Состояние:"\
			"\n"COL_BLUE"Показывать часы: \t%s"\
			"\n"COL_BLUE"Показывать карту: \t%s";
	new d36[128],
		status1[20],
		status2[20];
		
	status1 = (ClockIsOn[playerid] == true) ?  (""COL_STATUS1"Включено") : (""COL_STATUS6"Выключено");
	status2 = (MapIsOn[playerid] == true) ?  (""COL_STATUS1"Включено") : (""COL_STATUS6"Выключено");
				
	format(d36, sizeof(d36), D36, status1, status2);
	ShowPlayerDialog(playerid, DIALOG_ID_APEDSETTINGS, D_S_TH,""COL_ORANGE"Настройки APED",d36,"Выбрать","Назад");
	return true;
}

ShowPlayerPlayerInfoDialog(playerid)
{
	static D35[] = 
			""COL_BLUE"Сытость: \t%s"\
			"\n"COL_BLUE"Усталость: \t%s"\
			"\n"COL_BLUE"Состояние здоровья: \t%s"\
			"\n\t"\
			"\n"COL_BLUE"Состояние здоровья: \t%s";
			
	new d35[256],
		d36[64],
		hunger[40],
		endurance[40],
		healths[25],
		Float:health,
		Float:battery;
		
    GetPlayerHealth(playerid,health);	
			
	if(health >= 100.0) healths = ""COL_STATUS1"Отличное";
	if(health >= 80.0 && health < 100.0) healths = ""COL_STATUS2"Хорошее";
	if(health >= 50.0 && health < 80.0) healths = ""COL_STATUS3"Среднее";
	if(health >= 11.0 && health < 50.0) healths = ""COL_STATUS5"Плохое";
	if(health > 0.0 && health < 11.0) healths = ""COL_STATUS6"Критическое";
		
	if(PlayerInfo[playerid][pHunger] > 0 && PlayerInfo[playerid][pHunger] <=3600) hunger = ""COL_STATUS6"Голодание";
	if(PlayerInfo[playerid][pHunger] > 3600 && PlayerInfo[playerid][pHunger] <=7200)  hunger = ""COL_STATUS5"Жутко голоден";
	if(PlayerInfo[playerid][pHunger] > 7200 && PlayerInfo[playerid][pHunger] <=10800) hunger = ""COL_STATUS4"Нужно плотно поесть";
	if(PlayerInfo[playerid][pHunger] > 10800 && PlayerInfo[playerid][pHunger] <=14400) hunger = ""COL_STATUS3"Нужно поесть";
	if(PlayerInfo[playerid][pHunger] > 14400 && PlayerInfo[playerid][pHunger] <=18000) hunger = ""COL_STATUS2"Нужно немного перекусить";
	if(PlayerInfo[playerid][pHunger] > 18000 && PlayerInfo[playerid][pHunger] <=25200) hunger = ""COL_STATUS1"Сыт";
	
	if(PlayerInfo[playerid][pEndurance] > 0 && PlayerInfo[playerid][pEndurance] <=3600) endurance = ""COL_STATUS6"Переутомление";
	if(PlayerInfo[playerid][pEndurance] > 3600 && PlayerInfo[playerid][pEndurance] <=7200)  endurance = ""COL_STATUS5"Недосыпание";
	if(PlayerInfo[playerid][pEndurance] > 7200 && PlayerInfo[playerid][pEndurance] <=10800) endurance = ""COL_STATUS4"Нужно поспать";
	if(PlayerInfo[playerid][pEndurance] > 10800 && PlayerInfo[playerid][pEndurance] <=14400) endurance = ""COL_STATUS3"Нужно отдохнуть";
	if(PlayerInfo[playerid][pEndurance] > 14400 && PlayerInfo[playerid][pEndurance] <=18000) endurance = ""COL_STATUS2"Нужно немного расслабиться";
	if(PlayerInfo[playerid][pEndurance] > 18000 && PlayerInfo[playerid][pEndurance] <=25200) endurance = ""COL_STATUS1"Полон сил";
				
	format(d35, sizeof(d35), D35, hunger, endurance, healths);
	ShowPlayerDialog(playerid, DIALOG_ID_PLAYERINFODIALOG, D_S_T,""COL_ORANGE"Информация о Вас",d35,"Выйти","Назад");
	return true;
}

SetPlayerPosCW(playerid, Float:x, Float:y, Float:z, Float:a, i, v)
{
	if(!IsPlayerBlackScreen[playerid])
	{	
		ShowFonForPlayer(playerid);
		
		IsPlayerBlackScreen[playerid] = true;
		
		TogglePlayerControllable(playerid, false);		
		SetTimerEx("TeleportCW", 800, 0, "iffffdd", playerid, x, y, z, a, i, v);
	}
    return 1;
}

ShowFonForPlayer(playerid) 
{ 
    if(!FonBox[playerid]) 
    { 
		TogglePlayerControllable(playerid, false);
		
        fon_PTD[playerid] = CreatePlayerTextDraw(playerid, -12.0000, -10.3555, "Box"); // пусто 
        PlayerTextDrawLetterSize(playerid, fon_PTD[playerid], 0.0000, 53.6333); 
        PlayerTextDrawTextSize(playerid, fon_PTD[playerid], 680.0000, 0.0000); 
        PlayerTextDrawUseBox(playerid, fon_PTD[playerid], 1); 
        PlayerTextDrawBoxColor(playerid, fon_PTD[playerid], 255); 

        FonBox[playerid] = 0; 
        FonTimer[playerid] = SetTimerEx("@_FonTimer", true, 100, "ii", playerid, 1); 
    } 
} 

HideFonForPlayer(playerid) 
{ 
    if(FonBox[playerid] > 0) 
    { 		
        FonBox[playerid] = 255; 
        FonTimer[playerid] = SetTimerEx("@_FonTimer", true, 100, "ii", playerid, 2); 
    } 
} 

@_FonTimer(playerid, type); 
@_FonTimer(playerid, type) 
{ 	
    PlayerTextDrawBoxColor(playerid, fon_PTD[playerid], FonBox[playerid]); 
    PlayerTextDrawShow(playerid, fon_PTD[playerid]); 

    if(1 == type) 
    { 
        if(++ FonBox[playerid] >= 255) 
			KillTimer(FonTimer[playerid]);
    } 
    else 
    { 
        if(-- FonBox[playerid] <= 0) 
        { 
            PlayerTextDrawDestroy(playerid, fon_PTD[playerid]); 
            KillTimer(FonTimer[playerid]);
			TogglePlayerControllable(playerid, true);

			IsPlayerBlackScreen[playerid] = false;			
        } 
    } 
    return true; 
} 

ViewFactions(playerid) 
{ 
    new string[1040], string1[1040]; 
    for (new i = 1; i != MAX_FRACTIONS; i ++) 
    {  
		new count = 0; 
		foreach(Player, p)
		{ 
			if(PlayerInfo[p][pMember] != i) continue; 
			count++; 
		}
        format(string, sizeof(string),""COL_BLUE"%s\t"COL_WHITE"[ %d ]\n", fraction_name[i], count); 
        strcat(string1, string, sizeof(string1)); 
    } 
    format(string, sizeof(string), ""COL_BLUE"Организация\t"COL_WHITE"Количество человек онлайн\n%s", string1); 
    ShowPlayerDialog(playerid, DIALOG_ID_VIEWONLINEFRACTION, D_S_TH, ""COL_ORANGE"Онлайн всех организаций", string, "Выход", ""); 
    return 1; 
}

CreatePickupWith3DText(model, Float:X, Float:Y, Float:Z, text[], virtualworld, Float:radius)
{
    CreatePickup(model, 23, Float:X, Float:Y, Float:Z, virtualworld);
	Create3DTextLabel(text, COLOR_PROX, Float:X, Float:Y, Float:Z, Float:radius, virtualworld, 0);
    return true;
} 

SetSkin(playerid)
{
	TogglePlayerSpectating(playerid, false);
	
	GameTextForPlayer(playerid, FixText("Выберите скин"), 5000, 3);
		
	SetPlayerVirtualWorld(playerid, playerid + 1);
	TogglePlayerControllable(playerid, 0);
	SetPlayerPos(playerid, -2230.6531,-1739.9501,481.7513);
	SetPlayerFacingAngle(playerid, 40.9857);
	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		
	SetPlayerCameraPos(playerid, -2233.4141,-1737.1089,481.8256);
	SetPlayerCameraLookAt(playerid, -2230.6531,-1739.9501,481.7513);
		
	TextDrawShowForPlayer(playerid, skin[0]); 
	TextDrawShowForPlayer(playerid, skin[1]); 
	TextDrawShowForPlayer(playerid, skin[2]); 
	SelectTextDraw(playerid, 0x2641FEAA);
	
	return 1;
}	

StartEngine(vehicleid, playerid)
{
	if(Veh[vehicleid][vFuel] > 0)
	{
		new string[MAX_PLAYER_NAME+1+53];
		if(Engine[vehicleid] == false)
		{
			SetVehicleParamsEx(vehicleid,true,lights,alarm,doors,bonnet,boot,objective);
			Engine[vehicleid] = true;
					
			format(string,sizeof(string),"%s вставляет ключ в замок зажигания (Заводит двигатель).",Name(playerid));
			ProxDetector(playerid,COLOR_PROX, string, 10.0);
			return 1;
		}
		if(Engine[vehicleid] == true)
		{
			SetVehicleParamsEx(vehicleid,false,lights,alarm,doors,bonnet,boot,objective);
			Engine[vehicleid] = false;
					
			format(string,sizeof(string),"%s вытаскивает ключ из замка зажигания (Глушит двигатель).",Name(playerid));
			ProxDetector(playerid,COLOR_PROX, string, 10.0);
			return 1;
		}
	}
	else return	SendClientMessage(playerid,COLOR_WHITE,"В этом транспорте нет бензина.");
	return 1;
}

IsPlayerNearPlayer(Float:rad, playerid, targetid)
{
    if(IsPlayerConnected(playerid) && IsPlayerConnected(targetid))
    {
                new Float:posx, Float:posy, Float:posz;
                new Float:oldposx, Float:oldposy, Float:oldposz;
                new Float:tempposx, Float:tempposy, Float:tempposz;
                GetPlayerPos(playerid, oldposx, oldposy, oldposz);
                GetPlayerPos(targetid, posx, posy, posz);
                tempposx = (oldposx -posx);
                tempposy = (oldposy -posy);
                tempposz = (oldposz -posz);
                if (((tempposx < rad) && (tempposx > -rad)) && ((tempposy < rad) && (tempposy > -rad)) && ((tempposz < rad) && (tempposz > -rad)))
                {
                        return 1;
                }
    }
    return 0;
}

GiveHunger(playerid, hunger)
{
	PlayerInfo[playerid][pHunger] += hunger;
	return 1;
}

GiveEndurance(playerid, endurance)
{
	PlayerInfo[playerid][pEndurance] += endurance;
	return 1;
}

FixText(string[]) 
{ 
	new result[256]; 
	for (new i=0; i < 256; i++) 
	{ 
		switch (string[i]) 
		{ 
			case 'а', 'А': result[i] = 'A'; 			case 'б', 'Б': result[i] = 'Ђ'; 			case 'в', 'В': result[i] = 'B'; 			case 'г', 'Г': result[i] = '‚'; 
			case 'д', 'Д': result[i] = 'ѓ'; 			case 'е', 'Е': result[i] = 'E'; 			case 'ё', 'Ё': result[i] = 'E'; 			case 'ж', 'Ж': result[i] = '„'; 
			case 'з', 'З': result[i] = '3'; 			case 'и', 'И': result[i] = '…'; 			case 'й', 'Й': result[i] = '†'; 			case 'к', 'К': result[i] = 'K'; 
			case 'л', 'Л': result[i] = '‡'; 			case 'м', 'М': result[i] = 'M'; 			case 'н', 'Н': result[i] = 'H'; 			case 'о', 'О': result[i] = 'O'; 
			case 'п', 'П': result[i] = 'Њ'; 			case 'р', 'Р': result[i] = 'P'; 			case 'с', 'С': result[i] = 'C'; 			case 'т', 'Т': result[i] = 'T'; 
			case 'у', 'У': result[i] = 'Y'; 			case 'ф', 'Ф': result[i] = 'Ѓ'; 			case 'х', 'Х': result[i] = 'X'; 			case 'ц', 'Ц': result[i] = '‰'; 
			case 'ч', 'Ч': result[i] = 'Ќ'; 			case 'ш', 'Ш': result[i] = 'Ћ'; 			case 'щ', 'Щ': result[i] = 'Љ'; 			case 'ъ', 'Ъ': result[i] = 'ђ'; 
			case 'ы', 'Ы': result[i] = '‘'; 			case 'ь', 'Ь': result[i] = '’'; 			case 'э', 'Э': result[i] = '“'; 			case 'ю', 'Ю': result[i] = '”'; 
			case 'я', 'Я': result[i] = '•'; 			default: result[i] = string[i]; 
		} 
	} 
	return result; 
} 
/////////////////////////////////////////////////////////////////        Другие PUBLIC и таймеры

forward PlayerUpdate(playerid);  
public PlayerUpdate(playerid)
{
	if(gPlayerLogged[playerid] == false) return 1;
	
	new check [20];		format(check,sizeof(check),"H: %d E: %d", PlayerInfo[playerid][pHunger],PlayerInfo[playerid][pEndurance]); 		GameTextForPlayer(playerid, check, 1000, 3);	
	
	if (PlayerInfo[playerid][pMoney] != GetPlayerMoney(playerid))
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
	}	
	
	SavePlayer(playerid);
	
	if(PlayerTimerIDTimer1Second == 4)
    {	

		if(PlayerInfo[playerid][pEndurance] > PlayerInfo[playerid][pEnduranceMax]) PlayerInfo[playerid][pEndurance] = PlayerInfo[playerid][pEnduranceMax];
		
		if(PlayerInfo[playerid][pHunger] > SEVENHOURS) PlayerInfo[playerid][pHunger] = SEVENHOURS;
			
		if(PlayerInfo[playerid][pHunger] > 0)
		{
			PlayerInfo[playerid][pHunger] --;
		}
		
		if(PlayerInfo[playerid][pEndurance] > 0)
		{
			PlayerInfo[playerid][pEndurance] --;
			
			if(PlayerInfo[playerid][pHunger] <= FIVEHOURS) GiveEndurance(playerid, -1);
			if(PlayerInfo[playerid][pHunger] <= FOURHOURS) GiveEndurance(playerid, -1);
			if(PlayerInfo[playerid][pHunger] <= THREEHOURS) GiveEndurance(playerid, -2);
			if(PlayerInfo[playerid][pHunger] <= TWOHOURS) GiveEndurance(playerid, -2);
			if(PlayerInfo[playerid][pHunger] <= ONEHOURS) GiveEndurance(playerid, -3);
			
			if(IsPlayerJump(playerid)) GiveEndurance(playerid, -2);
			
			if(IsPlayerRun(playerid)) GiveEndurance(playerid, -1);
		}
		
		if(PlayerInfo[playerid][pAPED] != 0) PlayerInfo[playerid][pAPEDBattery] --;
		
		
		new VID = GetPlayerVehicleID(playerid);
		GetVehicleParamsEx(VID,engine,lights,alarm,doors,bonnet,boot,objective);
		if(VID > 0)
		{
			new Float:VHP;
			GetVehicleHealth(VID, VHP);
			if(VHP < 300.0 && RentCar[playerid] != 0)
			{
				RentCar[playerid] = 0;
				PlayerInfo[playerid][pMoney] -= 1;
				SendClientMessage(playerid, COLOR_RED,"Штраф за поломку арендованного транспорта.");
			}
			if(VHP < 300.0 && Engine[VID] == true)
			SendClientMessage(playerid, COLOR_RED,"Состояние транспорта на низком уровне. Необходим ремонт.");
		}
		
		if(!IsPlayerInAnyVehicle(playerid) && IsPlayerConnected(playerid) && gPlayerLogged[playerid] != false)
		{	
			if(IsPlayerIdle(playerid))
			{
				IdleTime[playerid] ++;
					
				if (IdleTime[playerid] == TIME_IDLE)	
				switch(random(4)) 
				{
					case 0: ApplyAnimation(playerid, "PLAYIDLES", "stretch", 4.1, 0, 1, 1, 1, 1, 1);
					case 1: ApplyAnimation(playerid, "PLAYIDLES", "shldr", 4.1, 0, 1, 1, 1, 1, 1);
					case 2: ApplyAnimation(playerid, "PLAYIDLES", "time", 4.1, 0, 1, 1, 1, 1, 1);
					case 3: ApplyAnimation(playerid, "PLAYIDLES", "shift", 4.1, 0, 1, 1, 1, 1, 1);
				}
					
				if (IdleTime[playerid] >= TIME_IDLE + 5)
				{
					ClearAnimations(playerid);
					IdleTime[playerid] = 0;
				}
			}
			else IdleTime[playerid] = 0;
		}
		PlayerTimerIDTimer1Second = 0;
	}
    else PlayerTimerIDTimer1Second++;	
	
	new hour, minute;
	gettime(hour,minute);		
	SetPlayerTime(playerid, hour, minute);
	
    return 1;
}  

forward Processor();
public Processor()
{	
	for(new v = 1; v < MAX_VEHICLES; v++)
	{
		GetVehicleParamsEx(v,engine,lights,alarm,doors,bonnet,boot,objective);
		if(v > 0)
		{
			new Float:VHP;
			GetVehicleHealth(v, VHP);
			if(VHP < 300.0 && Engine[v] == true)
			{
				SetVehicleHealth(v, 300.0);
				SetVehicleParamsEx(v,false,lights,alarm,doors,bonnet,boot,objective);
				Engine[v] = false;
			}
			else if(VHP < 300.0 && Engine[v] == false)
			{
				SetVehicleHealth(v, 300.0);
			}
		}
	}
		
	if(VaultDoorOpen)
	{
		VaultDoorTime --;
		if(VaultDoorTime <=  0)
		{
			MoveObject (VaultDoor, 2144.2000000,1627.0000000,994.2600100, 0.1, 0.0000000,0.0000000,180.0000000);
			VaultDoorOpen = false;
			VaultDoorTime = 0;
		}
	}
	
	if(LSPDGateOpen)
	{
		LSPDGateTime --;
		if(LSPDGateTime <=  0) 
		{
			MoveObject (LSPDGate, -2090.0000000,-2322.2998000,32.4000000, 0.7, 0.0000000,0.0000000,51.7400000);
			LSPDGateOpen = false; 
			LSPDGateTime = 0;
		}
	}	
	
	if(BankGateOpen)
	{
		BankGateTime --;
		if(BankGateTime <=  0) 
		{
			MoveObject (BankGate, -2152.1001000,-2393.1001000,32.4000000, 0.7, 0.0000000,0.0000000,140.5000000);
			BankGateOpen = false;
			BankGateTime = 0;
		}
	}	
	
	if(CongressGateOpen)
	{
		CongressGateTime --;
		if(CongressGateTime <=  0) 
		{
			MoveObject (CongressGate, -2046.3000000,-2507.1001000,32.8000000, 0.7, 0.0000000,0.0000000,317.2500000);
			CongressGateOpen = false;
			CongressGateTime = 0;
		}
	}
	
	if(FixGateOpen)
	{
		FixGateTime --;
		if(FixGateTime <=  0) 
		{
			MoveObject (FixGate, -2397.3999000,-2194.2000000,34.0000000, 0.7, 0.0000000,0.0000000,274.7500000);
			FixGateOpen = false;
			FixGateTime = 0;
		}
	}
	
	if(FixGate2Open)
	{
		FixGate2Time --;
		if(FixGate2Time <=  0) 
		{
			MoveObject (FixGate2, -2388.2000000,-2180.8999000,34.0300000, 0.7, 0.0000000,0.0000000,274.7460000);
			FixGate2Open = false;
			FixGate2Time = 0;
		}
	}
	
	new hour;
	gettime(hour);
	SetWorldTime(hour);
	
    return 1;
}

forward SpeedoUpdate();
public SpeedoUpdate()
{
	foreach(Player, i)
	{
	    new string[24],vehicleid = GetPlayerVehicleID(i);
		if(IsPlayerConnected(i) && GetPlayerState(i) == PLAYER_STATE_DRIVER && !NoEngine(vehicleid))
		{
   			TextDrawShowForPlayer(i,box[i]);
			TextDrawShowForPlayer(i,speed[i]);
			TextDrawShowForPlayer(i,fuel[i]);
			format(string,sizeof(string),"~b~Speed: ~w~%d ~b~KM/H",GetVehicleSpeed(vehicleid));
			TextDrawSetString(speed[i],string);
			if(Veh[vehicleid][vFuel] <= 10)
			{
				format(string,sizeof(string),"~y~Fuel: ~r~%d ~y~%%",Veh[vehicleid][vFuel]);
				TextDrawSetString(fuel[i],string);
			}
			else
			{
				format(string,sizeof(string),"~y~Fuel: ~w~%d ~y~%%",Veh[vehicleid][vFuel]);
				TextDrawSetString(fuel[i],string);
			}

		}
  		if(!IsPlayerInAnyVehicle(i))
		{
			TextDrawHideForPlayer(i,box[i]);
			TextDrawHideForPlayer(i,speed[i]);
			TextDrawHideForPlayer(i,fuel[i]);
		}
	}
	return 1;
}

forward Refill(playerid, litr);
public Refill(playerid, litr)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if ( !litr || Veh[vehicleid][vFuel] >= 100 )
	{
        KillTimer( GetPVarInt(playerid,"_timer")),
        SetPVarInt(playerid, "Refill", 0),
        TogglePlayerControllable(playerid, 1);
        SaveVeh();
		new str[130];
        format(str,sizeof(str), ""COL_BLUE" Спасибо за то, что вы заправились на нашей АЗС.\n Заполнено "COL_WHITE"%d %% "COL_BLUE"бензобака.\n Оплачено: "COL_GREEN"%d$."
		, inputfuel[playerid], CENA_BENZ*inputfuel[playerid]);
		ShowPlayerDialog(playerid, DIALOG_ID_NONE, D_S_M,""COL_ORANGE"АЗС",str,"Принять","");
		return 1;
    }
    ++ Veh[vehicleid][vFuel];
    SetPVarInt(playerid,"_timer", SetTimerEx("Refill", 500, false, "ii", playerid, -- litr ) );
    return 1;
}

forward wood(playerid);
public wood(playerid)
{
        if(GetPVarInt(playerid, "StartJob") == 1)
        {
            if(IsPlayerAttachedObjectSlotUsed(playerid,0)) RemovePlayerAttachedObject(playerid,0);
			
			GiveEndurance(playerid, -1);
			
            ClearAnimations(playerid);
      	 	ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 1, 1, 1, 1, 1);
			
      	 	SetPlayerAttachedObject(playerid,1,1463,6,0.031000,0.141999,-0.216000,64.700080,170.200073,-88.599960,0.358000,0.261999,0.461999);
            SetTimerEx("TimeWood",1000,false,"i", playerid);
        }
        return true;
}
forward TimeWood(playerid);
public TimeWood(playerid)
{
        if(GetPVarInt(playerid, "StartJob") ==  1)
        {
			TogglePlayerControllable(playerid, 1);
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1, 1);
			SetPlayerRaceCheckpoint(playerid, 0, -1638.1555,-2252.6714,31.5890,-1638.1555,-2252.6714,31.5890,1);
	    }
        return true;
}


forward TeleportCW(playerid, Float:x, Float:y, Float:z, Float:a, i, v);
public TeleportCW(playerid, Float:x, Float:y, Float:z, Float:a, i, v)
{
	SetPlayerPos(playerid, x, y, z);
    SetPlayerInterior(playerid, i);
	SetPlayerVirtualWorld(playerid, v);
	SetPlayerFacingAngle(playerid, a);
	SetCameraBehindPlayer(playerid); 
	
	HideFonForPlayer(playerid);
    return 1;
}

forward BlackScreenTimer(playerid);
public BlackScreenTimer(playerid)
{
	if(GetPlayerSkin(playerid) != PlayerInfo[playerid][pMemberSkin])
		SetPlayerSkin(playerid, PlayerInfo[playerid][pMemberSkin]);
	
	else
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	
	HideFonForPlayer(playerid);
    return 1;
}

forward ClearAnim(playerid);
public ClearAnim(playerid)
{
	ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,0,0,0,0,0,0);
	return 1;
}

forward RotateFerrisWheel();
public RotateFerrisWheel()
{
        FerrisWheelAngle+=36;
        if(FerrisWheelAngle>=360)FerrisWheelAngle=0;
        if(FerrisWheelAlternate)FerrisWheelAlternate=0;
        else FerrisWheelAlternate=1;
        new Float:FerrisWheelModZPos=0.0;
        if(FerrisWheelAlternate)FerrisWheelModZPos=0.05;
        MoveObject(FerrisWheelObjects[10],-2109.0000000,-2397.0000000,44.3000000+FerrisWheelModZPos,FERRIS_WHEEL_SPEED,0,FerrisWheelAngle,52.3000000);
}

forward FixCarTimer(playerid);
public FixCarTimer(playerid)
{
	if(FixCarTime[playerid] ==  0)
	{	  
		KillTimer(GetPVarInt(playerid,"FixCarTimer"));	
		
		RepairVehicle(GetPVarInt(playerid, "VehID"));
				
		TogglePlayerControllable(playerid, 1);
		ClearAnimations(playerid);
				
		SendClientMessage(playerid, COLOR_WHITE,"Вы закончили ремонт транспорта.");
				
		DeletePVar(playerid, "VehID");
		return 1;				
	}
	new string[17];
	format(string,sizeof(string),FixText("~G~Осталось: %d"), FixCarTime[playerid]); 
	GameTextForPlayer(playerid, string, 1000, 3);
		
	FixCarTime[playerid] --;
	SetPVarInt(playerid,"FixCarTimer", SetTimerEx("FixCarTimer", 1000, false, "i", playerid));
	return 1;
}

forward FuelTime();
public FuelTime()
{
	for(new v = 1; v < MAX_VEHICLES; v++)
	{
		if(!NoEngine(v) && Veh[v][vAdd] != 0)
		{
			if(Engine[v] != false)//если двигатель у проверяемой машины работает
			{
				Veh[v][vFuel] -= 1;
				SaveVeh();
				
				if(Veh[v][vFuel] <= 0)	
					GetVehicleParamsEx(v,engine,lights,alarm,doors,bonnet,boot,objective),
					SetVehicleParamsEx(v,false,lights,alarm,doors,bonnet,boot,objective), Engine[v] = false;
			}
		}
	}
	return 1;
}

#if defined _ALS_GivePlayerMoney
    #undef GivePlayerMoney
#else
    #define _ALS_GivePlayerMoney
#endif
#define GivePlayerMoney Hook_GivePlayerMoney

Hook_GivePlayerMoney(playerid, amount)
{
    PlayerMoney[playerid] += amount;
    return GivePlayerMoney(playerid, amount);
}

#if defined _ALS_ResetPlayerMoney
    #undef ResetPlayerMoney
#else
    #define _ALS_ResetPlayerMoney
#endif
#define ResetPlayerMoney Hook_ResetPlayerMoney

Hook_ResetPlayerMoney(playerid)
{
    PlayerMoney[playerid] = 0;
    return ResetPlayerMoney(playerid);
}


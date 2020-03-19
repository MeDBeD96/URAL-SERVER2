//////////////////////////////////////////////////////////////////
/*

При обновлении позиций транспорта без водителя прыгают лодки. Сделать проверку на водный транспорт

АРЕНДА МОПЕДА: 	1. Сделать таймер для аренды мопедов (переменная для отсчета времени оставшейся аренды (чтобы при перезаходе можно было сесть на свой мопед))
				2. Мопед надо вернуть, иначе штраф. Нельзя взять новый пока не сдал старый
				3. Плюсовать к аренде сумму за бензин и за поломки.
				4. Если кто-то взял мопед, то другой может тоже его взять. Сделать чтобы занятый мопед не мог взять другой
    
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
      
APED 'Angel Pine Electronic Document':  1. Можно открыть раздвигающиеся ворота дистанционно.
										2. Батарею заряжать можно дома и в каких нибудь местах. 

Система смерти, ранений и тд.

Полиция: 	1. Шипы для прокола колёс 
			2. Могут отключать двигатель преступнику дистанционно через APED

Финансы: 1. Можно брать кредит с 18 лет и если есть работа 

Система дома: 	1. Дома можно снять усталость 
				2. Если дверь закрыта другой человек может постучать, если открыта - сразу войти 
				3. Сделать переменную с классом дома, чем выше класс, тем меньше спать 
				4. Пожары дома
				5. Автотушение дома, датчики дыма
*/
// new check [4];		format(check, sizeof(check),"%d", IdleTime[playerid]); 		GameTextForPlayer(playerid, check, 1000, 3);
/////////////////////////////////////////////////////////////////

#include 	<a_samp>

#undef 		MAX_PLAYERS
#define 	MAX_PLAYERS 			5
#undef 		MAX_VEHICLES
#define 	MAX_VEHICLES 			100

#define 	FIXES_ServerVarMsg 0
#include 	<fixes> 
#include 	<a_mysql>
#include 	<foreach> 
#include 	<streamer>
#include 	<sscanf2>
//#include 	<nex-ac>
#include 	<a_actor>
#include 	<dc_cmd>  
#include 	<keypad>
#include 	<textdraws>
#include	<FCNPC>
#include	<dc_kickfix>
#include	<colandreas>
#include 	<objects>
 
#define 	MYSQL_HOST			"localhost"//Адрес, по которому расположен MySQL-Сервер
#define 	MYSQL_USER			"root"//Имя пользователя, на которого была создана база данных
#define 	MYSQL_DATABASE		"samp"// Имя базы данных
#define 	MYSQL_PASSWORD		""//Пароль для доступа к серверу MySQL


main()
{}

#define 	COLOR_GREY 			0xAFAFAFAA
#define 	COLOR_GREEN 		0x33AA33AA
#define 	COLOR_RED 			0xAA3333AA
#define 	COLOR_YELLOW 		0xFFFF00AA
#define 	COLOR_WHITE 		0xFFFFFFAA
#define 	COLOR_ORANGE 		0xFF8000AA
#define 	COLOR_BRIGHTRED 	0xDB0000F6
#define 	COLOR_PROX 			0xDFBB43FF

#define 	COL_WHITE 			"{FFFFFF}"
#define 	COL_BLUE 			"{00BFFF}"
#define 	COL_ORANGE 			"{ffcc00}"
#define 	COL_APED 			"{86a6ff}"
#define 	COL_YELLOW 			"{F3FF02}"
#define 	COL_RED 			"{A80000}"
#define 	COL_GREEN 			"{09ff00}"
#define 	COL_STATUS1			"{1aec29}"
#define 	COL_STATUS2 		"{b5ec1a}"
#define 	COL_STATUS3 		"{e1e306}"
#define 	COL_STATUS4 		"{fff400}"
#define 	COL_STATUS5 		"{ff9a00}"
#define 	COL_STATUS6 		"{ff1010}"

#define 	DEFAULT_POS_X 		-2230.6531
#define 	DEFAULT_POS_Y 		-1739.9501
#define 	DEFAULT_POS_Z 		481.7513
#define 	DEFAULT_POS_A 		40.9857

#define 	NALOG_BUYCAR 		10
#define 	NALOG_BUYSELLHOUSE 	1

#define 	CENA_BENZ 		31
#define 	CENA_WOOD 		1
#define 	CENA_ARENDI 	1
#define 	CENA_APED 		100

#define 	TIME_IDLE 				300 // время для срабатывания рандомной анимации при стоянии
#define 	TIME_VAULTDOORCLOSE 	300
#define		SECONDS_TO_LOGIN 		60
#define		TIME_ZONE_AVAILABLE		5

#define 	VBUYTOCONGRESS 		1
#define 	VBUYTOPOLICE 		2
#define 	VBUYTOAMBULANCE		3
#define 	VBUYTOFIRE 			4
#define 	VBUYTOVEH 			5
#define 	VBUYTOLOGISTIC 		6
#define 	VBUYTONEWS 			7
#define 	VBUYTOSELL 			50
#define 	VBUYTOCARKEY 		100
#define 	VBUYTORENT 			150
#define 	VBUYTOBUY 			200

#define 	Name(%1) 		PlayerInfo[%1][pName]

#define 	MAX_HOUSES 		50
#define 	MAX_ENTERS 		50
#define 	MAX_APED 		500
#define 	MAX_ROBOTS 		20

#define 	ONEHOURS 		3600
#define 	TWOHOURS		7200
#define 	THREEHOURS 		10800
#define 	FOURHOURS 		14400
#define 	FIVEHOURS 		18000
#define 	SIXHOURS 		21600
#define	 	SEVENHOURS 		25200
#define 	TENHOURS 		36000

#define 	PROCESSOR_UPDATE 	1000
#define 	NPC_UPDATE 	500
#define 	FUEL_TIME 			60000

#define 	forEx(%0,%1) 			for(new %1=0;%1<%0;%1++)
#define 	FERRIS_WHEEL_WAIT_TIME	1000     //Wait Time to enter a Cage
#define 	FERRIS_WHEEL_SPEED 		0.007        //Speed of turn (Standart 0.005)

#define 	swap(%0,%1)    %0 = %0 + %1 - (%1 = %0) 

#define 	FLOAT_INFINITY	(Float:0x7F800000)

#define 	EMPTY_SLOT_OBJECT		5087
#define 	EMPTY_ID_SLOT_OBJECT	255


#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define PRESSING(%0,%1) \
	(%0 & (%1))
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
stock Float:frand(Float:min, Float:max) 
    return float(random(0)) / (float(cellmax) / (max - min)) + min; 

	
new MySQL:mysql_connect_ID;
	
new Float:gFerrisCageOffsets[10][3]={{0.0699,0.0600,-11.7500},{-6.9100,-0.0899,-9.5000},{11.1600,0.0000,-3.6300},{-11.1600,-0.0399,3.6499},
	{-6.9100,-0.0899,9.4799}, {0.0699,0.0600,11.7500},{6.9599,0.0100,-9.5000},{-11.1600,-0.0399,-3.6300},{11.1600,0.0000,3.6499},{7.0399,-0.0200,9.3600}},
    FerrisWheelObjects[12],
    Float:FerrisWheelAngle=0.0,
    FerrisWheelAlternate=0;
	
const
    MAX_FRACTIONS = 8,
    MAX_FRACTION_NAME_LENGTH = 50;
    
static const fraction_name[MAX_FRACTIONS][MAX_FRACTION_NAME_LENGTH] =
{
	{""COL_RED"Снять игрока с лидерства"},
    {"Конгресс округа Angel Pine"},
    {"Департамент полиции округа Angel Pine"},
	{"Министерство здравоохранения округа Angel Pine"},
	{"Пожарный департамент округа Angel Pine"},
	{"Транспортная компания округа Angel Pine"},
	{"Логистическая компания округа Angel Pine"},
	{"Новостное агенство округа Angel Pine"}
};

static updatepositiontimestamp[MAX_PLAYERS]; 
#if    !defined    AC_UP__IGNORE_TIME
    #define    AC_UP__IGNORE_TIME    2000
#endif


new bool:gPlayerLogged[MAX_PLAYERS char];
new bool:engine,lights,alarm,doors,bonnet,boot,objective, driver, passenger, backleft, backright;
new bool:animloading[MAX_PLAYERS char];
new bool:Engine[MAX_VEHICLES char]; 
new bool:tazer_status[MAX_PLAYERS char];
new bool:cuff_status[MAX_PLAYERS char];
new bool:PlayerRun[MAX_PLAYERS char];
new bool:PlayerDeath[MAX_PLAYERS char] = false;
new bool:CloseTextDrawAPED[MAX_PLAYERS char];
new bool:PlayerChoosePaintColor[MAX_PLAYERS char];
new bool:IsPlayerBlackScreen[MAX_PLAYERS char];
new bool:MapIsOn[MAX_PLAYERS char];

new p_muted[MAX_PLAYERS char];

new Float: VehPosX[MAX_VEHICLES];
new Float: VehPosY[MAX_VEHICLES];
new Float: VehPosZ[MAX_VEHICLES];
new Float: VehPosA[MAX_VEHICLES];

new EnterPickupID[MAX_PICKUPS]; // переменные для пикапов, чтобы показывало куда нажать
new ExitPickupID[MAX_PICKUPS];
new HouseEnterPickupID[MAX_PICKUPS];
new HouseExitPickupID[MAX_PICKUPS]; // 

new blackmap; // чтобы карта стала черной

new LSZone; // для гангзон
new SFZone;
new LVZone;

new LSArea; // для создания динамической зоны
new SFArea;
new LVArea;

new PlayerText: ColorInZone[MAX_PLAYERS];  

new PlayerText:mission1photo[MAX_PLAYERS];

new 
    FonTimer[MAX_PLAYERS], 
    FonBox[MAX_PLAYERS char], 
    PlayerText: fon_PTD[MAX_PLAYERS];  

new drev = 0; // для системы дерева
new purse = 0; // для системы казны

new ActorWoodMan, ActorKapitoliyWomen, ActorAPPD, ActorRestaraunt, ActorZero, ActorHospital, ActorGym,
	ActorManInBar;

new Text3D:sellVehInfo[MAX_VEHICLES];
new Text3D:aped[MAX_APED];
new apedpickup[MAX_APED];

new GymBar[MAX_PLAYERS];
new gymTimer[MAX_PLAYERS];

new RentCar[MAX_PLAYERS];
new PlayerMoney[MAX_PLAYERS];  // для античита 
new inputfuel[MAX_PLAYERS char];
new PlayerTimerID[MAX_PLAYERS]; // индивидуальные таймеры 

new PlayerTimerIDTimer1Second[MAX_PLAYERS char] = 0; 
new PlayerTimerIDTimer60Second[MAX_PLAYERS char] = 0;

new cskin[MAX_PLAYERS char];
new const ManSkinList[4] = { 25002, 25003, 25004, 25005 }; ////	
new const WomanSkinList[4] = { 25006, 25018, 25023, 25015 }; ////

new FixCarTime[MAX_PLAYERS]; // время починки
new IdleTime[MAX_PLAYERS]; // время стояния на месте

new SprayVehicle[MAX_PLAYERS];

// двери, ворота время
new VaultDoorTime, LSPDGateTime, BankGateTime, CongressGateTime, FixGateTime, FixGate2Time; 

// двери, ворота id
new LSPDDoor, LSPDDoor2, BankGate, LSPDGate, BankDoor, BankDoor2, BankDoor3,
VaultGate, VaultDoor, CongressGate, FixGate, FixGate2, FireDoor, FireDoor2, AmbulanceDoor;

// двери, ворота состояние
new bool:LSPDDoorOpen, bool:LSPDDoor2Open, bool:BankDoorOpen, bool:BankDoor2Open, bool:BankDoor3Open, bool:VaultDoorOpen, bool:VaultGateOpen,
bool:LSPDGateOpen, bool:BankGateOpen, bool:CongressGateOpen, bool:FixGateOpen, bool:FixGate2Open, bool:FireDoorOpen, bool:FireDoor2Open, bool:AmbulanceDoorOpen;


// mission1
new mission1NPC = INVALID_PLAYER_ID;
/*new Float:mission1NPCPoint[8][3] =
{
    {-2805.7886,-2416.0957,3.3622},
    {-2808.9956,-2392.1951,3.8278},
    {-2822.2949,-2382.3892,1.9524},
    {-2821.9534,-2426.1729,1.3270},
	{-2816.3906,-2455.8545,2.3588},
	{-2797.4797,-2476.0422,7.0233},
	{-2788.3767,-2456.7690,3.0069},
	{-2788.6538,-2416.6731,4.2462}
};
static countpoint; //для подчёта точек*/


new playeridmission1 = INVALID_PLAYER_ID;


new NPCGym = INVALID_PLAYER_ID;
new GymCheckpoint[MAX_PLAYERS];

new Robot[MAX_ROBOTS];

const MAX_ROBOTS_POSITION = 6; ////<<<<<< УВЕЛИЧИТЬ КОЛИЧЕСТВО ПОЗИЦИЙ
static const Float:RobotsPositions[MAX_ROBOTS_POSITION][4] =
{
    {97.6419,1940.1349, 	275.6489,1807.8584}, // зона 51
    {115.5006,2638.3711, 	435.6740,2422.5972}, // заброшенный аэро
	{2682.2903,-2508.5798,	2805.8279,-2390.1792}, // порт в лс
	{-1544.3752,480.2034, 	-1328.1273,461.2630}, // авианосец
	{-1981.2134,182.6544,	-2055.6548,99.9161}, // жд сф
	{-2611.3442,581.5984,	-2540.2063,658.1120} // болька сф
};
static const Float:RobotsZone[MAX_ROBOTS_POSITION][4] =
{
    {-83.0, 1679.0, 507.0, 2137.0},
    {-65.0, 2278.0, 563.0, 2749.0},
	{2368.0, -2586.0, 2861.0, -2225.0},
	{-1703.0, 355.0, -1218.0, 613.0},
	{-2170.0, -46.0, -1912.0, 386.0},
	{-2770.0, 410.0, -2396.0, 818.0}
};
new const AMOUNTROBOTSINAREA[MAX_ROBOTS_POSITION] = {20, 10, 15, 5, 10, 15};
////////////////  										^^^^^^^^^^^ДОБАВИТЬ КОЛИЧЕСТВО БОТОВ НА ЗОНЕ
new RobotsArea[MAX_ROBOTS_POSITION];

new TimerIDZoneAvailable[MAX_ROBOTS_POSITION];

new bool: IsRobotsAreaNotAvailable[MAX_ROBOTS_POSITION];


new Iterator:Admins<MAX_PLAYERS>;
new Iterator:APED<MAX_APED>;
new Iterator:House<MAX_HOUSES>;
new Iterator:Enters<MAX_ENTERS>;
new Iterator:Robots<MAX_ROBOTS>;
new Iterator:OrganisationsPlayer[MAX_FRACTIONS]<MAX_PLAYERS>;

new Iterator:RobotsVisible[MAX_ROBOTS_POSITION]<MAX_ROBOTS>;
new Iterator:PlayersInZone[MAX_ROBOTS_POSITION]<MAX_PLAYERS>;


enum pInfo
{
	pID,
    pName[MAX_PLAYER_NAME+1],
    pPass[65],
	pSalt[17],
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
	pRankName[33],
	pAPED,
	pAPEDBattery,
	pHunger,
	pEndurance,
	pEnduranceMax,
	Float:pHP,
	pHouse,
	pFightStyle,
	pCurrentFightStyle
}
new PlayerInfo[MAX_PLAYERS][pInfo];


enum vInfo
{
	vID,// Ид Машины
    vAdd,// Проверка на созданную машину
    vModel,// Модель Машины
    Float:vVPosX,// Позиция X
    Float:vVPosY,// Позиция Y
    Float:vVPosZ,// Позиция Z
    Float:vVZa,// Угол поворота A
    vColor1,// Цвет 1
    vColor2,// Цвет 2
    vOwner[24],//владелец
    vPrice,
    vBuy,
    vLock,
    vFuel,
	Float:vHP
}
new VehInfo[MAX_VEHICLES][vInfo];

new LastCar;// Максимальное колличество авто

enum hInfo//Naming the enum
{
	hID,
	hHouseID,
    hAdd,
    hOwner[24], 
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
new HouseInfo[MAX_HOUSES][hInfo];//This is the var where we will read the house info.

new HouseEnter[MAX_HOUSES];
new HouseExit[MAX_HOUSES];
const INVALID_HOUSE_ID = -1;

enum eInfo
{
	eID,
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

enum aInfo
{
	aID,
	aAPEDID,
    aPlayerID,
    Float:aPosX,
    Float:aPosY,
    Float:aPosZ,
    aVW,
	aBattery
}
new APEDInfo[MAX_APED][aInfo];

enum rInfo
{
	rVisible,
	rAreaID
}
new RobotsInfo[MAX_ROBOTS][rInfo];

const MAX_WEAPON_SLOTS = 2;
const MAX_MAIN_SLOTS = 16;
const MAX_SLOTS = 39;


enum iInfo
{
	iSlotSecondaryWeapon,
	iSlotBackpack,
	iSlotArmor,
	iSlotPrimaryWeapon,
	iSlotWeapon[MAX_WEAPON_SLOTS],
	iSlot[MAX_MAIN_SLOTS],
	iSlotAmount[MAX_MAIN_SLOTS]	
}
new InventoryInfo[MAX_PLAYERS][iInfo];

new idItem[MAX_PLAYERS] = EMPTY_SLOT_OBJECT;
new idSlot[MAX_PLAYERS char] = EMPTY_ID_SLOT_OBJECT;
new bool: IsInventoryOpen[MAX_PLAYERS char];

enum
{
	Nothing,
	TypeSecondaryWeapon,
	TypeBackpack,
	TypeArmor,
	TypePrimaryWeapon,
	TypeWeapon,
	TypeSlot,
	TypeMelee,
	TypeAmmo
}
new slotType[MAX_PLAYERS];
new mainSlotType[MAX_PLAYERS][MAX_MAIN_SLOTS];

enum
{
    DIALOG_ID_NONE, // 0
    DIALOG_ID_LOGIN, // 1
    DIALOG_ID_REGISTER,
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
	DIALOG_ID_APPDWEAPON,
	DIALOG_ID_ADMINMENU,
	DIALOG_ID_ADMINMENUTPLIST,
	DIALOG_ID_BUYSELLHOUSE,
	DIALOG_ID_BUYHOUSE,
	DIALOG_ID_BUYHOUSEACCEPT,
	DIALOG_ID_SELLHOUSE,
	DIALOG_ID_HOUSESETTINGS,
	DIALOG_ID_HOUSEKNOCK,
	DIALOG_ID_HOUSEFUNCTION,
	DIALOG_ID_TAKEAPED,
	DIALOG_ID_SHOPFOOD,
	DIALOG_ID_CHOOSEPAINTCOLOR1,
	DIALOG_ID_CHOOSEPAINTCOLOR2,
	DIALOG_ID_GYMBUY,
	DIALOG_ID_GYMBUYFS,
	DIALOG_ID_MISSION1
};
#define 	DIALOG_TYPE_MAIN	20044
#define 	D_S_M 				DIALOG_STYLE_MSGBOX 
#define 	D_S_I 				DIALOG_STYLE_INPUT 
#define 	D_S_L 				DIALOG_STYLE_LIST 
#define 	D_S_P 				DIALOG_STYLE_PASSWORD 
#define 	D_S_T 				DIALOG_STYLE_TABLIST 
#define 	D_S_TH				DIALOG_STYLE_TABLIST_HEADERS 

enum
{
	KEYPAD_NULL,
	KEYPAD_POLICE,
	KEYPAD_POLICE2,
	KEYPAD_BANKDOOR,
	KEYPAD_BANKDOOR2,
	KEYPAD_VAULTDOOR,
	KEYPAD_VAULTGATE,
	KEYPAD_FIREDOOR,
	KEYPAD_FIREDOOR2,
	KEYPAD_BANKDOOR3,
	KEYPAD_AMBULANCEDOOR
};

#if !defined BODY_PART_TORSO
enum
{
    BODY_PART_TORSO = 3,
    BODY_PART_GROIN,
    BODY_PART_LEFT_ARM,
    BODY_PART_RIGHT_ARM,
    BODY_PART_LEFT_LEG,
    BODY_PART_RIGHT_LEG,
    BODY_PART_HEAD
};
#endif 


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

const MAX_SHOP_FOOD_ITEMS = 7;
const MAX_SHOP_POS = 1;

enum shfInfo
{
    FoodName[40],
    FoodHunger,
    FoodPrice
};

new ShopFoodInfo[ MAX_SHOP_FOOD_ITEMS ][ shfInfo ] = 
{
    {"Клакбургер", 3600, 10},
    {"Клакбургер + клактошка", 5400, 15},
    {"Двойной клакбургер + клактошка + Спранк", 7200, 18},
	{"Клак-крылышки + Спранк", 6300, 17},
	{"Клак-салат", 2700, 6},
    {"Спранк", 1800, 7},
    {"Кофе Бэлл", 1800, 9}
};

enum ShopCoords
{
    Float:shX,
    Float:shY,
    Float:shZ
};

new ShopCoordsInfo[ MAX_SHOP_POS ][ ShopCoords ] = {
    {368.8175, -6.0951, 1001.8516}
};  

enum FightingStyleInfo
{
    fsID,
    fsName[14]
};

static const fighting_style[][FightingStyleInfo] =
{
    { FIGHT_STYLE_NORMAL, "Обычный" },
	{ FIGHT_STYLE_ELBOW, "Удары локтём" },
	{ FIGHT_STYLE_KNEEHEAD, "Захват + удар" },
    { FIGHT_STYLE_GRABKICK, "Без правил" },
    { FIGHT_STYLE_BOXING, "Бокс" },
    { FIGHT_STYLE_KUNGFU, "Кунг-фу" }    
};

const MAX_NAME_GUM_ACTION = 27;
enum gymInfo
{
    GymAction[MAX_NAME_GUM_ACTION],
    GymActionPrice
};

new GymInfo[ 2 ][ gymInfo ] = 
{
    {"Бег на дорожке", 100},
    {"Изучение стилей боя", 200}
};


public OnGameModeInit()
{	
	mysql_connect_ID = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE);
	mysql_tquery(mysql_connect_ID, !"SET CHARACTER SET 'utf8'", "", "");
	mysql_tquery(mysql_connect_ID, !"SET NAMES 'utf8'", "", "");
	mysql_tquery(mysql_connect_ID, !"SET character_set_client = 'cp1251'", "", "");
	mysql_tquery(mysql_connect_ID, !"SET character_set_connection = 'cp1251'", "", "");
	mysql_tquery(mysql_connect_ID, !"SET character_set_results = 'cp1251'", "", "");
	mysql_tquery(mysql_connect_ID, !"SET SESSION collation_connection = 'utf8_general_ci'", "", "");
	
	switch(mysql_errno())
{
    case 0: printf("---------[MySQL] Подключение к базе ""%s"" установлено---------", MYSQL_DATABASE);
    case 1044: print("Подключение к базе данных не удалось [Указано неизвестное имя пользователя]");
    case 1045: print("Подключение к базе данных не удалось [Указан неизвестный пароль]");
    case 1049: print("Подключение к базе данных не удалось [Указана неизвестная база данных]");
    case 2003: print("Подключение к базе данных не удалось [Хостинг с базой данных недоступен]");
    case 2005: print("Подключение к базе данных не удалось [Указан неизвестный адрес хостинга]");
    default: printf("Подключение к базе данных не удалось [Неизвестная ошибка. Код ошибки: %d]", mysql_errno());
}
	ObjectLoad();
	
	CollisionRemoveLoad();
	CA_Init();
	CollisionLoad();
	
	//LoadWood();	
	//LoadPurse();
	mysql_tquery(mysql_connect_ID, "SELECT * FROM `enters` WHERE `Add` = 1", "LoadEnters");
	mysql_tquery(mysql_connect_ID, "SELECT * FROM `houses` WHERE `Add` = 1", "LoadHouses");
	mysql_tquery(mysql_connect_ID, "SELECT * FROM `aped`", "LoadAPED");        
	mysql_tquery(mysql_connect_ID, "SELECT * FROM `vehicles` WHERE `Add` = 1", "LoadVeh");
	
	ManualVehicleEngineAndLights();
    DisableInteriorEnterExits();
    SetNameTagDrawDistance(10.0);
    LimitGlobalChatRadius(0.0);
    ShowPlayerMarkers(0);
    EnableStuntBonusForAll(0);
	//UsePlayerPedAnims();
	
	SetWeather(1);
	
	FCNPC_SetUpdateRate(100);
	
    SetTimer("Processor", PROCESSOR_UPDATE, false);
    SetTimer("SpeedoUpdate", 50, false);
	SetTimer("RotateFerrisWheel", FERRIS_WHEEL_WAIT_TIME, false);
	SetTimer("FuelTime", FUEL_TIME, false);
	
	SetGameModeText("GameMode v2.0");
    
	CreatePickupWith3DText(1581, 362.6556,173.5869,1008.3828, "Получение APED\n>> Нажмите Y <<", 0, 5.0);
	CreatePickupWith3DText(1274, -1630.8824,-2234.4985,31.4766, "Работа дровосеком\n>> Нажмите Y <<", 0, 5.0);
	CreatePickupWith3DText(1212, 2537.3064,-1286.8135,1054.6406, "Продажа транспорта\n>> Нажмите Y <<", 0, 5.0);
	CreatePickupWith3DText(1212, -2032.7780,-116.5089,1035.1719, "Аренда транспорта\n>> Нажмите Y <<", 0, 5.0);
	CreatePickupWith3DText(1650, -2234.2949,-2568.0117,32.1219, "Автозаправочная станция\n>> Нажмите H <<", 0, 15.0);
	CreatePickupWith3DText(1650, -1541.2645,-2742.2102,48.7381, "Автозаправочная станция\n>> Нажмите H <<", 0, 15.0);
	CreatePickupWith3DText(1275, 254.8472,77.0973,1003.6406, "Раздевалка\n>> Нажмите Y <<", 0, 4.0); 
	CreatePickupWith3DText(1275, 267.0403,118.3147,1004.6172, "Раздевалка\n>> Нажмите Y <<", 0, 4.0); 	
	CreatePickupWith3DText(1275, 350.9631,188.9638,1019.9844, "Раздевалка\n>> Нажмите Y <<", 1, 4.0);
	CreatePickupWith3DText(1275, 756.5243,5.3321,1000.6991, "Раздевалка\n>> Нажмите Y <<", 0, 4.0);
	CreatePickupWith3DText(2061, 222.9965,79.8031,1005.0391, "Выдача оружия\n>> Нажмите Y <<", 0, 4.0);
	CreatePickupWith3DText(1273, 371.1688,187.4530,1014.1875, "Отдел по работе с недвижимостью\n>> Нажмите Y <<", 0, 5.0);
	CreatePickupWith3DText(1582, 368.8175, -6.0951, 1001.8516, "Сделать заказ\n>> Нажмите Y <<", 0, 5.0);
	CreatePickupWith3DText(365, -2400.0496,-2183.4885,33.4849, "Взять баллончик\n>> Нажмите Y <<", 0, 2.0);
	CreatePickupWith3DText(1212, 772.8295,13.2882,1000.6979, "Занятия в спортзале\n>> Нажмите Y <<", 0, 2.0);
	
	Create3DTextLabel("Покраска транспорта", COLOR_PROX, -2385.7307,-2186.9722,33.4849, 5.0, 0, 0);
	Create3DTextLabel("Ремонт транспорта", COLOR_PROX, -2395.9583,-2188.6716,33.4849, 5.0, 0, 0);
	Create3DTextLabel("Бег на дорожке\n>> Нажмите F (ENTER) <<", COLOR_PROX, 773.4305,-2.8386,1000.8479, 1.2, 0, 0);
	Create3DTextLabel("Мужчина у барной стойки\n>> Нажмите Y <<", COLOR_PROX, 499.9667,-22.6924,1000.6797, 2.0, 0, 0);
		
	
	
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
	AmbulanceDoor = CreateObject(1537,346.7000100,169.0000000,1019.0000000,0.0000000,0.0000000,270.0000000); //object(gen_doorext16) (1)
	
    ActorWoodMan = CreateActor(25016, -1629.7593,-2233.2476,31.4766,135.0107);
    ApplyActorAnimation(ActorWoodMan, "SMOKING", "M_smk_loop", 3.9, 1, 0, 0, 0, 0);
	
    ActorKapitoliyWomen = CreateActor(25015, 359.7169,173.6097,1008.3893,268.1367);
    ApplyActorAnimation(ActorKapitoliyWomen, "PED", "woman_idlestance", 3.9, 1, 0, 0, 0, 0);
	
	ActorAPPD = CreateActor(25020, 220.8941,79.8343,1005.0391,270.7289);
	ApplyActorAnimation(ActorAPPD, "DEALER", "DEALER_IDLE", 3.9, 1, 0, 0, 0, 0);
	
	ActorRestaraunt = CreateActor(25014, -782.9186,498.3218,1371.7422,358.9113);
	ApplyActorAnimation(ActorRestaraunt, "COP_AMBIENT", "Coplook_think", 3.9, 0, 0, 0, 0, 0);
	
	ActorZero = CreateActor(25024, -2237.6453,128.5868,1035.4141,359.5548);
	ApplyActorAnimation(ActorZero, "COP_AMBIENT", "Coplook_think", 3.9, 1, 0, 0, 0, 0);
	
	ActorHospital = CreateActor(25026, 364.0134,169.4868,1019.9844,181.1555);
	SetActorVirtualWorld(ActorHospital, 1);
	SetActorPos(ActorHospital, 364.0134,169.4868,1019.9844);
	
	ActorGym = CreateActor(25001, 768.1992,13.3436,1000.7011,327.9911);
	ApplyActorAnimation(ActorGym, "GYMNASIUM", "GYMshadowbox", 3.9, 1, 1, 1, 0, 0);
	
	ActorManInBar = CreateActor(25025, 499.9667, -22.6924, 1000.6797, 268.3611);
	ApplyActorAnimation(ActorManInBar, "BAR", "BARman_idle", 4.1, 0, 0, 0, 1, 0);
	
	CreateActor(25023, -28.6500,-186.8251,1003.5469,0.8175);
	CreateActor(25019, -2034.8375,-116.8023,1035.1719,274.6687);
	CreateActor(25018, 162.3062,-81.1858,1001.8047,180.4836);
	
	mission1NPC = FCNPC_Create("Mission1NPC");
	NPCGym = FCNPC_Create("NPCGym");
	
	new string[10];
	for(new i = 0; i < MAX_ROBOTS; i++)
    {
		format(string, sizeof(string), "Robot_%d", i);		
		Robot[i] = FCNPC_Create(string);
		FCNPC_Spawn(Robot[i], 25007, 0.0, 0.0, 0.0);
		FCNPC_SetVirtualWorld(Robot[i], 1);
		RobotsInfo[i][rAreaID] = -1;
		Iter_Add(Robots, i);
	}
	
	Iter_Init(RobotsVisible);
	Iter_Init(PlayersInZone);
	Iter_Init(OrganisationsPlayer);
    
    blackmap = GangZoneCreate(-3000.0,-3000.0,3000.0,3000.0);
	
	LSZone = GangZoneCreate(-286.0, -2778.0, 2974.0, 486.0);
	SFZone = GangZoneCreate(-2978.0, -782.0, -978.0, 1566.0);
	LVZone = GangZoneCreate(-866.0, 518.0, 2978.0, 2982.0);
	
	LSArea = CreateDynamicRectangle(-286.0, -2778.0, 2974.0, 486.0, 0, 0);
	SFArea= CreateDynamicRectangle(-2978.0, -782.0, -978.0, 1566.0, 0, 0);
	LVArea = CreateDynamicRectangle(-866.0, 518.0, 2978.0, 2982.0, 0, 0);
	
	for(new i = 0; i < MAX_ROBOTS_POSITION; i++)	
		RobotsArea[i] = CreateDynamicRectangle(RobotsZone[i][0], RobotsZone[i][1], RobotsZone[i][2], RobotsZone[i][3], 0, 0);
	
	
	FerrisWheelObjects[10] = CreateObject(18877,-2109.0000000,-2397.0000000,44.3000000,0.0000000,0.0000000,322.0000000,300); // спицы
    FerrisWheelObjects[11] = CreateObject(18878,-2109.0000000,-2397.0000000,44.5000000,0.0000000,0.0000000,232.0000000,300); // колесо
    forEx((sizeof FerrisWheelObjects)-2,x)
	{
		FerrisWheelObjects[x]=CreateObject(18879,-2109.0000000,-2397.0000000,44.3000000,0.0000000,0.0000000,52.0000000,300); // кабинки
		AttachObjectToObject(FerrisWheelObjects[x], FerrisWheelObjects[10],gFerrisCageOffsets[x][0],gFerrisCageOffsets[x][1],gFerrisCageOffsets[x][2],0.0000000,0.0000000,52.0000000, 0);
	}
	

	return 1;
}

public OnGameModeExit()
{	
	FCNPC_Destroy(mission1NPC);
	FCNPC_Destroy(NPCGym);
	for(new i = 0; i < MAX_ROBOTS; i++)
		FCNPC_Destroy(Robot[i]);
	
    foreach(Player, i)
	{
		SaveAccount(i);
		gPlayerLogged{i} = false;
		PlayerTextDrawDestroy(i, ColorInZone[i]);
	}
	
	for(new i; i < sizeof(ChangeColor); i++)
		TextDrawDestroy(ChangeColor[i]);
	
	forEx(sizeof FerrisWheelObjects,x) 
		DestroyObject(FerrisWheelObjects[x]);
	
	for(new i; i < 2; i++)
		TextDrawDestroy(skin[i]);
	
	DestroyAllDynamicAreas();
	
	GangZoneDestroy(LSZone); GangZoneDestroy(SFZone); GangZoneDestroy(LVZone);
	
	mysql_close(mysql_connect_ID);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{	
	SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z] + 0.5,
	PlayerInfo[playerid][pFa], 0, 0, 0, 0, 0, 0);
	if(!GetPVarInt(playerid, "OnPlayerRequestClassFix"))
	{
		if(GetPVarInt(playerid, "OnPlayerRequestClass_F4_Bug")) return SpawnPlayer(playerid);
		TogglePlayerSpectating(playerid, true);
		SetTimerEx("@_TogglePlayerSpectatingOff", 500, 0, "i", playerid);
	}
	else DeletePVar(playerid, "OnPlayerRequestClassFix"), SpawnPlayer(playerid);  
	
	return 1;
}

public OnPlayerConnect(playerid)
{	
	LoadingTextDraws(playerid);	
	
	SetPVarInt(playerid, "OnPlayerRequestClassFix", 1);
	TogglePlayerSpectating(playerid, true);//Собстно, начало обхода
	SetTimerEx("SetPlayerCameraPosForReqClass", 100, 0, "i", playerid);//А это для того, чтоб камера изменилась при начале слежки  
	
	ResetPlayerMoney(playerid); 
	
	GetPlayerName(playerid, PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
	new query_string[49+MAX_PLAYER_NAME-4];
	mysql_format(mysql_connect_ID, query_string, sizeof(query_string), "SELECT * FROM `accounts` WHERE `Name` = '%s'", PlayerInfo[playerid][pName]);
	mysql_tquery(mysql_connect_ID, query_string, "FindPlayerInTable", "i", playerid);
	
    for( new i = 0; i <= 20; i ++ ) SendClientMessage(playerid, COLOR_WHITE, "");
	
	SetPVarInt(playerid, "player_kick_time", GetTickCount() + SECONDS_TO_LOGIN * 1000); 
    
    gPlayerLogged{playerid} = false;
    ClearAnimations(playerid);
    animloading{playerid} = false;
	PlayerDeath{playerid} = false;
	FonBox{playerid} = 0; 
	
    PlayerTextDrawDestroy(playerid, fon_PTD[playerid]);  
	PlayerTextDrawDestroy(playerid, ColorInZone[playerid]); 
	
	PlayerInfo[playerid][pHP] = 100.0;
	
	PlayerTimerID[playerid] = SetTimerEx("PlayerUpdate", 180, 1, "d", playerid); 
	
	ObjectRemove(playerid);
	
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	CancelSelectTextDraw(playerid); 
	
	ResetPlayerMoney(playerid);	
	
    SaveAccount(playerid);
    gPlayerLogged{playerid} = false;
	IsInventoryOpen{playerid} = false;
	
	KillTimer(PlayerTimerID[playerid]);
	PlayerTimerID[playerid] = 0;
	
	memset(PlayerInfo[playerid], 0, pInfo);	
	
	PlayerTextDrawDestroy(playerid, mission1photo[playerid]);
	
	if(playerid == playeridmission1)
		playeridmission1 = INVALID_PLAYER_ID;
	
	if(IsValidDynamicCP(GymCheckpoint[playerid]))
				DestroyDynamicCP(GymCheckpoint[playerid]);

	for(new z = 0; z < MAX_ROBOTS_POSITION; z++)
	{
		if(!Iter_Contains(PlayersInZone[z], playerid)) continue;
		Iter_Remove(PlayersInZone[z], playerid); 
	}
	
	if(PlayerInfo[playerid][pAdmin] > 0)
		Iter_Remove(Admins, playerid);
	
	if(PlayerInfo[playerid][pMember] > 0)
		Iter_Remove(OrganisationsPlayer[PlayerInfo[playerid][pMember]], playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{	
	DeletePVar(playerid, "OnPlayerRequestClass_F4_Bug");
	
	updatepositiontimestamp[playerid] = GetTickCount()+AC_UP__IGNORE_TIME;
	
	if(PlayerInfo[playerid][pReg] == 1)
		return SetSkin(playerid);

	if(PlayerInfo[playerid][pReg] == 2)
	{
		if(PlayerDeath{playerid})
		{			
			SetPlayerPos(playerid, 343.2550, 161.0479, 1020.7661);
			SetPlayerFacingAngle(playerid, 269.9050); 
			SetPlayerInterior(playerid, 3);
			SetPlayerVirtualWorld(playerid, 1);
			
			ApplyAnimation(playerid, "CRACK", "crckidle4", 4.1, 0, 1, 1, 1, 1);
			
			PlayerInfo[playerid][pHP] = 10.0;
			PlayerDeath{playerid} = false;
		}
		else
		{
			SetPlayerPos(playerid,PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y],PlayerInfo[playerid][pPos_z] + 0.5);
			SetPlayerFacingAngle( playerid, PlayerInfo[playerid][pFa]); 
			SetPlayerInterior(playerid, PlayerInfo[playerid][pInt]);
			SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pWorld]);
		}		
		
		TogglePlayerSpectating(playerid, 0);
		SetPVarInt(playerid, "IsPlayerSpawn", 1);
		
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pCurrentFightStyle]);		
		
		SetPlayerHealth(playerid, PlayerInfo[playerid][pHP]);
		GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
		
		SetCameraBehindPlayer(playerid);
		
		if(PlayerInfo[playerid][pAPED] == 0) 
			GangZoneShowForPlayer(playerid, blackmap, 255);
		else 
		{
			GangZoneHideForPlayer(playerid, blackmap);
			GangZoneShowForPlayer(playerid, LSZone, 0x7FFF0055);
			GangZoneShowForPlayer(playerid, SFZone, 0x0000FF55);
			GangZoneShowForPlayer(playerid, LVZone, 0xFFFF0055);
			MapIsOn{playerid} = true;
		}
		
		for(new z = 0; z < MAX_ROBOTS_POSITION; z++)
		{
			if(IsPlayerInDynamicArea(playerid, RobotsArea[z]) && !Iter_Contains(PlayersInZone[z], playerid))
				Iter_Add(PlayersInZone[z], playerid);			
		}
		
		if(animloading{playerid} == false)
		{
			PreloadAnimLib(playerid,"BOMBER");		PreloadAnimLib(playerid,"RAPPING");			PreloadAnimLib(playerid,"SHOP");
			PreloadAnimLib(playerid,"BEACH");		PreloadAnimLib(playerid,"SMOKING");			PreloadAnimLib(playerid,"FOOD");
			PreloadAnimLib(playerid,"ON_LOOKERS");	PreloadAnimLib(playerid,"DEALER");			PreloadAnimLib(playerid,"CRACK");
			PreloadAnimLib(playerid,"CARRY");		PreloadAnimLib(playerid,"COP_AMBIENT");		PreloadAnimLib(playerid,"PARK");
			PreloadAnimLib(playerid,"INT_HOUSE");	PreloadAnimLib(playerid,"FOOD");			PreloadAnimLib(playerid,"CRIB");
			PreloadAnimLib(playerid,"ROB_BANK");	PreloadAnimLib(playerid,"JST_BUISNESS");	PreloadAnimLib(playerid,"PED");
			PreloadAnimLib(playerid,"OTB");			PreloadAnimLib(playerid,"BAR");				PreloadAnimLib(playerid,"GYMNASIUM");
			PreloadAnimLib(playerid,"COP_AMBIENT");	PreloadAnimLib(playerid,"WUZI");			PreloadAnimLib(playerid,"COLT45");
			animloading{playerid} = true;
		}
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	PlayerDeath{playerid} = true;
	PlayerInfo[playerid][pHP] = 1.0;
	
	if (IsPlayerBlackScreen{playerid})
		HideFonForPlayer(playerid);
	
	DeletePVar(playerid, "IsPlayerSpawn");
	DeletePVar(playerid, "PlayerRunInGym");
	DeletePVar(playerid, "IsTazed");
	DeletePVar(playerid, "StartJob");
	DeletePVar(playerid, "PlayerWood");
	DeletePVar(playerid, "IsWork");
	DeletePVar(playerid, "IsPlayerInGymCC");
	DeletePVar(playerid, "NumberOfWins");
	DeletePVar(playerid, "NumberOfLose");
	
	/*if(playerid == playeridmission1)
	{
		FCNPC_StopAim(mission1NPC);
		FCNPC_GoTo(mission1NPC, mission1NPCPoint[countpoint][0], mission1NPCPoint[countpoint][1], mission1NPCPoint[countpoint][2],
		MOVE_TYPE_WALK, MOVE_SPEED_WALK, true);
		countpoint ++;
		mission1NPCAttacked = false;
		FCNPC_SetWeapon(mission1NPC, 0);
		
		playeridmission1 = INVALID_PLAYER_ID;
		
		RemovePlayerMapIcon(playeridmission1, 0);
		RemovePlayerMapIcon(playeridmission1, 1);
	}*/
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	SetVehicleHealth(vehicleid, VehInfo[vehicleid][vHP]);
	Engine{vehicleid} = false;
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
    if(gPlayerLogged{playerid} != true || PlayerInfo[playerid][pReg] != 2) return 0;
	
	if(GetPVarInt(playerid, "MuteTime") > GetTickCount())
	{
		SendClientMessage(playerid, COLOR_GREY, "Вы заткнуты.");
		return 0;
	}
	
    new string[145];

	strcat(string, Name(playerid));
	strcat(string, " говорит: "COL_WHITE"");
	strcat(string, text);
    ProxDetector(playerid, COLOR_PROX, string, 10.0);
	
    SetPlayerChatBubble(playerid, text, COLOR_PROX, 10.0, 5000);
	
	GiveEndurance(playerid, -1);
	
    ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.1, 0, 1, 1, 1, 1, 1);
		
    SetTimerEx("@_ClearAnim", 1900, false, "d", playerid);
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	new Float:x, Float:y, Float:z, Float:a;

	GetVehiclePos(vehicleid, x, y, z);	
	GetVehicleZAngle(vehicleid, a);
	
	VehPosX[vehicleid] = x;
	VehPosY[vehicleid] = y;
	VehPosZ[vehicleid] = z;
	VehPosA[vehicleid] = a;
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    new veh = GetPlayerVehicleID(playerid);
	
    if (newstate == PLAYER_STATE_DRIVER)
	{
		if(VehInfo[veh][vBuy] == VBUYTOSELL)
			SendClientMessage(playerid, COLOR_WHITE, "Этот транспорт для дальнейшей продажи. Его необходимо припарковать.");

	    if(VehInfo[veh][vBuy] == VBUYTOBUY && VehInfo[veh][vPrice] > 0)
	    {
	    	new string[256];
			
	    	format(string, sizeof(string), ""COL_BLUE"\nДанный транспорт выставлен на продажу.\nМодель: "COL_WHITE"%s\n"COL_BLUE"Стоимость: "COL_WHITE"%d $\n\
			"COL_BLUE"Вы хотите приобрести данный транспорт?\n", VehicleNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400], VehInfo[veh][vPrice]);
	    	ShowPlayerDialog(playerid, DIALOG_ID_BUYCAR, D_S_M, ""COL_ORANGE"Покупка транспорта", string, "Купить", "Отмена");
	    }
	    if(VehInfo[veh][vBuy] == VBUYTORENT && GetPVarInt(playerid, "DostupRentCar"))
		{			
		    ShowPlayerDialog(playerid, DIALOG_ID_RENTMOPEDON, D_S_M,""COL_ORANGE"Аренда мопеда",""COL_BLUE"Вы хотите взять в аренду данный мопед?\n",
			"Да", "Нет");
			RentCar[playerid] = veh;
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
			if(PlayerInfo[playerid][pEndurance] < TWOHOURS) 
			{
				DisablePlayerRaceCheckpoint(playerid);
				DeletePVar(playerid, "StartJob");
				SendClientMessage(playerid, COLOR_GREY, "Вы устали, отдохните.");
				return 1;
			}			
			SetPVarInt(playerid, "StartJob", 1);
			
			DisablePlayerRaceCheckpoint(playerid);
			SetPlayerAttachedObject(playerid,0,341,6,0.055999,0.014000,-0.108999,36.099945,-10.100026,-24.100002,1.000000,1.000000,1.000000);
			
			TogglePlayerControllable(playerid, 0);
			ClearAnimations(playerid);
			ApplyAnimation(playerid,"CHAINSAW","WEAPON_csaw",4.1, 1, 1, 1, 0, 0);
			
			GiveEndurance(playerid, -6);
			
			SetTimerEx("wood", 5800, false, "i", playerid);
			return true;
	  	}
		if(IsPlayerInRangeOfPoint(playerid, 1.0,-1638.1555,-2252.6714,31.5890))
	 	{
	  		DeletePVar(playerid, "StartJob");
			
	  		if(IsPlayerAttachedObjectSlotUsed(playerid,1)) RemovePlayerAttachedObject(playerid,1);
			
		    ApplyAnimation( playerid, "CARRY", "putdwn", 4.0, 0, 1, 1, 0, 800);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			
			GiveEndurance(playerid, -1);
			
		    new a = 10 + random(20);
		    drev += a;
		    PlayerInfo[playerid][pMoneyDolg] += CENA_WOOD * a;
			UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "MoneyDolg", PlayerInfo[playerid][pMoneyDolg]);
			
		    new Random = random(sizeof(RandomWood));
			SetPlayerRaceCheckpoint(playerid,0,RandomWood[Random][0], RandomWood[Random][1], RandomWood[Random][2],RandomWood[Random][0], RandomWood[Random][1],
			RandomWood[Random][2],0.5);
		   	WoodRand[playerid] = Random;
			
		    //SaveWood();
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
	if(objectid==FerrisWheelObjects[10]) 
		SetTimer("RotateFerrisWheel", FERRIS_WHEEL_WAIT_TIME, false);
	
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	foreach(Enters, i)
	{
		if(	pickupid == EnterPickupID[i] && !IsPlayerBlackScreen{playerid} ||
			pickupid == ExitPickupID[i] && !IsPlayerBlackScreen{playerid})
				GameTextForPlayer(playerid, FixText("~W~~k~~SNEAK_ABOUT~"), 1500, 1);
	}
	
	foreach(House, i)
	{
		if(	pickupid == HouseEnterPickupID[i] && !IsPlayerBlackScreen{playerid} ||
			pickupid == HouseExitPickupID[i] && !IsPlayerBlackScreen{playerid})
				GameTextForPlayer(playerid, FixText("~W~~k~~SNEAK_ABOUT~"), 1500, 1);
	}
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
	if (HOLDING(KEY_FIRE) && HOLDING(KEY_AIM) && GetAroundPlayerVehicleID(playerid, 4.0) != 0 
	&& IsPlayerInRangeOfPoint(playerid, 5.0, -2385.7307, -2186.9722, 33.4849) && PlayerInfo[playerid][pMember] == 5)
	{		
		if(GetPlayerWeapon(playerid) == WEAPON_SPRAYCAN)
		{
			SprayVehicle[playerid] = SetTimerEx("SprayCanVehicle", 3000, false, "ii", playerid, GetAroundPlayerVehicleID(playerid, 4.0));
		
			SetPVarInt(playerid, "PlayerSprayOnVehicle", 1);
			GameTextForPlayer(playerid, FixText("~W~Вы начали покраску транспорта"), 1500, 3);
		}
	}
	
	if ((RELEASED(KEY_FIRE) || RELEASED(KEY_AIM)) && GetPVarInt(playerid, "PlayerSprayOnVehicle"))
	{		
		DeletePVar(playerid, "PlayerSprayOnVehicle");
		KillTimer(SprayVehicle[playerid]);
		GameTextForPlayer(playerid, FixText("~R~Вы прервали покраску"), 1500, 3);
	}
	
	new vid = GetPlayerVehicleID(playerid);
    if (newkeys == KEY_LOOK_BEHIND && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && !NoEngine(vid))
    {
        static Float:VehicleHP;
    	GetVehicleHealth(vid, VehicleHP);
		
    	if(VehicleHP <= 300.0) 
			return SendClientMessage(playerid,COLOR_RED,"Состояние транспорта на низком уровне. Необходим ремонт.");
		
  		GetVehicleParamsEx(vid,engine,lights,alarm,doors,bonnet,boot,objective);
		
  		if (PlayerInfo[playerid][pAdmin] == 5)
  		{
			SetVehicleParamsEx(vid, !Engine{vid} ? true : false, lights,alarm,doors,bonnet,boot,objective);
			Engine{vid} = !Engine{vid};
		}

        else if (RentCar[playerid] == vid)
			return StartEngine(vid, playerid);
		
  		else if(PlayerInfo[playerid][pCarKey] == vid)
			return StartEngine(vid, playerid);
	
		else if(PlayerInfo[playerid][pMember] == VehInfo[vid][vBuy])
			return StartEngine(vid, playerid);
	
		else 
			return	SendClientMessage(playerid,COLOR_RED,"У Вас нет ключей от этого транспорта.");
    }
    
	if(newkeys & KEY_FIRE)
    {
        if(tazer_status{playerid})
        {
            new targetplayer = GetPlayerTargetPlayer(playerid);
            if(targetplayer != INVALID_PLAYER_ID && !GetPVarInt(targetplayer, "IsTazed") && GetPlayerWeapon(playerid) == 0)
            {				
				new string[23 + MAX_PLAYER_NAME*2];
	
				format(string, sizeof(string), "%s ударил электрошокером %s.", Name(playerid), Name(targetplayer));
				ProxDetector(playerid, COLOR_PROX, string, 10);
				
                TogglePlayerControllable(targetplayer, 0);
				ClearAnimations(targetplayer);
				ApplyAnimation(targetplayer, "CRACK", "crckdeth1", 4.0, 0, 0, 0, 1, 0, 1);
				
				SetPVarInt(targetplayer, "IsTazed", 1);
				
                SetTimerEx("@_TogglePlayerControllPublic", 10000, 0, "%d", targetplayer);
            }
        }
		if(cuff_status{playerid})
			ClearAnimations(playerid);
    }  
	
    if(newkeys == KEY_JUMP)
	{
        if(IsPlayerInRangeOfPoint(playerid, 3.0,-2082.5891,-2418.1428,32.8820) || IsPlayerInRangeOfPoint(playerid, 3.0,-2089.1011,-2413.7351,32.9020) || 
		IsPlayerInRangeOfPoint(playerid, 3.0,-2095.4346,-2408.9075,32.8820) && !IsPlayerInAnyVehicle(playerid) && (GetTickCount() - GetPVarInt(playerid,"BatutUnBug")) >= 1500)
	    {
	        new Float:V[3];
	        GetPlayerVelocity(playerid,V[0],V[1],V[2]);
	        SetPlayerVelocity(playerid,V[0],V[1],floatabs(V[2]) + (float(random(2)) / 1.5));
	        SetPVarInt(playerid,"BatutUnBug", GetTickCount());
			
			GiveEndurance(playerid, -2);
	    }
		
		if(cuff_status{playerid})
			ClearAnimations(playerid);
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
		

		if(PlayerInfo[playerid][pMember] == 5 && (	IsPlayerInRangeOfPoint(playerid, 4.0, -2397.3569,-2194.6267,33.3970) && !IsPlayerInAnyVehicle(playerid)
			|| 										IsPlayerInRangeOfPoint(playerid, 10.0, -2397.3569,-2194.6267,33.3970) && IsPlayerInAnyVehicle(playerid)))
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
		
		if(PlayerInfo[playerid][pMember] == 5 && (	IsPlayerInRangeOfPoint(playerid, 4.0, -2388.1277,-2181.3235,33.4875) && !IsPlayerInAnyVehicle(playerid)
			|| 										IsPlayerInRangeOfPoint(playerid, 10.0, -2388.1277,-2181.3235,33.4875) && IsPlayerInAnyVehicle(playerid)))
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
		
		
		foreach(new i : House)
		{
	        if(	IsPlayerInRangeOfPoint(playerid, 1.5, HouseInfo[i][hEnterX], HouseInfo[i][hEnterY], HouseInfo[i][hEnterZ]) &&
			PlayerInfo[playerid][pHouse] == i 
			|| (IsPlayerInRangeOfPoint(playerid, 1.5, HouseInfo[i][hExitX], HouseInfo[i][hExitY], HouseInfo[i][hExitZ]) && 
			GetPlayerVirtualWorld(playerid) == HouseInfo[i][hVirt]))
	        {				
				if(!IsPlayerBlackScreen{playerid})
				{
					static D43[] = 
							""COL_BLUE"Объект: \t"COL_WHITE"Состояние:"\
							"\n"COL_BLUE"Дверь: \t%s";
					new d43[sizeof(D43)+20],
						status1[20];
						
					status1 = (HouseInfo[i][hLock] == 0) ?  (""COL_STATUS1"Открыта") : (""COL_STATUS6"Закрыта");
								
					format(d43, sizeof(d43), D43, status1);
					ShowPlayerDialog(playerid, DIALOG_ID_HOUSESETTINGS, D_S_TH,""COL_ORANGE"Настройки дома", d43, "Выбрать", "Назад");
					
					SetPVarInt(playerid, "IDHouseForClose", i);
					return true; 	
				}
			}
		}
		
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 250.0249,64.1209,1003.6406))
		{
			if(LSPDDoorOpen) 
			return 	MoveObject (LSPDDoor, 250.4500000,62.7500000,1002.6000000, 0.01, 0.0000000,0.0000000,90.0000000), LSPDDoorOpen = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3);
					
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_POLICE, szKey);
			ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 1, 1, 0, 1100, 1);
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 247.5468,72.4742,1003.6206))
		{
			if(LSPDDoor2Open) 
			return 	MoveObject (LSPDDoor2, 245.8000000,72.3500000,1002.6000000, 0.01, 0.0000000,0.0000000,0.0000000), LSPDDoor2Open = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3);
			
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_POLICE2, szKey);
			ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 1, 1, 0, 1100, 1);
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 2151.3354,1606.1740,1006.1863))
		{
			if(BankDoorOpen) 
			return 	MoveObject (BankDoor, 2150.3604000,1605.7998000,1006.5200000, 0.05, 0.0000000,0.0000000,0.0000000), BankDoorOpen = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3);
		
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_BANKDOOR, szKey);
			ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 1, 1, 0, 1100, 1);
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 2148.0713,1605.0737,1006.1693))
		{
			if(BankDoor2Open) 
			return 	MoveObject (BankDoor2, 2147.0801000,1604.7000000,1006.5000000, 0.05, 0.0000000,0.0000000,0.0000000), BankDoor2Open = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3);
			
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_BANKDOOR2, szKey);
			ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 1, 1, 0, 1100, 1);
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
			ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 1, 1, 0, 1100, 1);
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
				ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 1, 1, 0, 1100, 1);
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
			ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 1, 1, 0, 1100, 1);
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 240.1736,116.9190,1003.2257))
		{
			if(FireDoor2Open) 
			return 	MoveObject (FireDoor2, 239.7500000,118.0900000,1002.2000000, 0.01, 0.0000000,0.0000000,270.0000000), FireDoor2Open = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3);
			
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_FIREDOOR2, szKey);
			ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 1, 1, 0, 1100, 1);
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 2149.4817,1602.5496,1001.9677))
		{
			if(BankDoor3Open) 
			return 	MoveObject (BankDoor3, 2149.8301000,1603.6000000,1002.3000000, 0.01, 0.0000000,0.0000000,270.0000000), BankDoor3Open = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3);
			
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_BANKDOOR3, szKey);
			ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 1, 1, 0, 1100, 1);
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 346.4707,170.1382,1020.0643))
		{
			if(AmbulanceDoorOpen) 
			return 	MoveObject (AmbulanceDoor, 346.7000100,169.0000000,1019.0000000, 0.01, 0.0000000,0.0000000,270.0000000), AmbulanceDoorOpen = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3);
			
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_AMBULANCEDOOR, szKey);
			ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 1, 1, 0, 1100, 1);
		}

	}
	
    if (newkeys == KEY_YES)
    {
		if (!IsPlayerBlackScreen{playerid})
		{
			if(		IsPlayerInRangeOfPoint(playerid, 3.0, 254.8472,77.0973,1003.6406) && PlayerInfo[playerid][pMember] == 2
				|| 	IsPlayerInRangeOfPoint(playerid, 3.0, 267.0403,118.3147,1004.6172) && PlayerInfo[playerid][pMember] == 4
				|| 	IsPlayerInRangeOfPoint(playerid, 3.0, 350.9631,188.9638,1019.9844) && PlayerInfo[playerid][pMember] == 3
				|| 	IsPlayerInRangeOfPoint(playerid, 3.0, 756.5243,5.3321,1000.6991) && GetPVarInt(playerid, "ChooseGymAction") != 0
				|| 	IsPlayerInRangeOfPoint(playerid, 3.0, 756.5243,5.3321,1000.6991) && GetPVarInt(playerid, "IsPlayerInGymCC") == 1)
					return ShowPlayerDialog(playerid, DIALOG_ID_CHANGECLOTHES, D_S_M,""COL_ORANGE"Раздевалка", ""COL_BLUE"Вы хотите переодеться?\n", "Да", "Нет");
					
			else if(IsPlayerInRangeOfPoint(playerid, 3.0, 756.5243,5.3321,1000.6991) && GetPVarInt(playerid, "ChooseGymAction") == 0)
				SendClientMessage(playerid, COLOR_GREY, "Раздевалка только для тех, кто приобрел разовый абонемент.");
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 222.9965,79.8031,1005.0391) && PlayerInfo[playerid][pMember] == 2)
		{
			static D39[] = 
					""COL_WHITE"Привет, %s!\n\
					Пришел получить свою амуницию и оружие?\n";
					
			new d39[26+43-2+MAX_PLAYER_NAME+1];
			
			format(d39, sizeof(d39), D39, Name(playerid));
			
			ShowPlayerDialog(playerid, DIALOG_ID_APPDWEAPON, D_S_M, ""COL_ORANGE"Комната хранения оружия", d39, "Да", "Нет");
			return 1;
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 2.5, /*499.9667,-22.6924,1000.6797*/-2805.1089, -2427.4063, 3.8156))
		{			
			if(playeridmission1 == playerid)
				return SendClientMessage(playerid, COLOR_PROX,"Мужчина говорит: "COL_WHITE"Приведи ко мне того смельчака, а потом и поговорим.");
			
			if(playeridmission1 != INVALID_PLAYER_ID)
				return SendClientMessage(playerid, COLOR_PROX,"Мужчина говорит: "COL_WHITE"Мужик, отвали!");
			
			static D45[] = 
					"\t"COL_WHITE"Эй, парень! Хочешь подзаработать деньжат?\t\n\
					\tУ меня тут один смельчак взял денег в долг и пропал.\t\n\
					\tПрошло много времени, уже и процентик накапал солидный.\t\n\
					\tЯ знаю несколько мест где он может скрываться.\t\n\
					\tЕсли приведешь его ко мне, то можешь забрать себе этот процент.\t\n\
					\tДальше я уже с ним сам разберусь. Ну что, берешься?\t\n";

			ShowPlayerDialog(playerid, DIALOG_ID_MISSION1, D_S_M,""COL_ORANGE"Мужчина у барной стойки", D45, "Да", "Нет");
			
			playeridmission1 = playerid;
			return 1;
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 3.0, -2032.4177, -116.3887, 1035.1719))
		{
			if(GetPVarInt(playerid, "DostupRentCar"))
				return SendClientMessage(playerid, COLOR_WHITE, "Возьмите любой понравившийся мопед на улице и начинайте аренду.");
			
		    new str[144];
			
		    format(str, sizeof(str), ""COL_BLUE"\nЗдравствуйте, у нас Вы можете арендовать мопед.\nСтоимость аренды: "COL_GREEN"%d $.\n\
			"COL_BLUE"Хотите воспользоваться арендой?", CENA_ARENDI);
			ShowPlayerDialog(playerid, DIALOG_ID_RENTMOPED, D_S_M, ""COL_ORANGE"Аренда мопеда", str, "Да", "Нет");
			return 1;
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 772.8295,13.2882,1000.6979))
		{
		    ShowPlayerGymDialog(playerid);
			SendClientMessage(playerid, COLOR_ORANGE, "INFO: Абонемент действует полчаса, а также сгорает при выходе из игры/поражении на ринге.");
			return 1;
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.0, -1630.8824,-2234.4985,31.4766))
		{
			if(GetPVarInt(playerid, "PlayerWood") == 1 && GetPVarInt(playerid, "IsWork") != 0 || PlayerInfo[playerid][pMoneyDolg] > 0) 
				return ShowPlayerDialog(playerid, DIALOG_ID_WOODSTOP, D_S_M,""COL_ORANGE"Дровосек",""COL_WHITE"Вы хотите получить заработанные деньги?",
				"Принять", "Отмена");
				
			if(PlayerInfo[playerid][pEndurance] < TWOHOURS) 
				return SendClientMessage(playerid, COLOR_PROX,"Гарри говорит: "COL_WHITE"Выглядите уставшим, отдохните как следует.");
		
			if(GetPVarInt(playerid, "IsWork") != 0) 
				return SendClientMessage(playerid, COLOR_RED,"Закончите предыдущую работу.");
		
			if(GetPVarInt(playerid, "PlayerWood") == 0) 
				return ShowPlayerDialog(playerid, DIALOG_ID_WOODSTART, D_S_M,""COL_ORANGE"Дровосек",""COL_WHITE"Здесь Вы можете подработать дровосеком.\n\
				Если устанете работать, то сложите оборудование и заходите за заработанными деньгами.", "Начать", "Отмена");
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.0, 362.6556,173.5869,1008.3828))
		{
			static D33[] = 
			"\t"COL_WHITE"Добрый день! Приветствуем Вас в здании конгресса. Меня зовут Моника.\t\n\n\
			\tУ меня Вы можете получить свой индивидуальный "COL_APED"APED"COL_WHITE" для комфортного проживания в штате.\t\n\
			\t"COL_APED"Angel Pine Electronic Document"COL_WHITE" - это многофункциональный электронный документ.\t\n\
			\t"COL_APED"APED"COL_WHITE" будет заменять Вам смартфон, навигатор, показывать полезную информацию и многое другое.\t\n\n\
			\tВы хотите получить его? Его стоимость - {09ff00}%d $.\t\n\n";
			
			new d33[512];
				
			if(PlayerInfo[playerid][pAPED] == 0)
			{
				format(d33, sizeof(d33), D33, CENA_APED);
				ShowPlayerDialog(playerid, DIALOG_ID_GETAPED, D_S_M,""COL_ORANGE"Получение APED",d33,"Да","Нет");
			}
			else 
				return SendClientMessage(playerid, COLOR_PROX,"Моника говорит: "COL_WHITE"У Вас уже есть APED! Извините, но мы не можем выдать еще один.");
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
					
			new d34[sizeof(D34)+3];
			
			format(d34, sizeof(d34), D34, NALOG_BUYCAR);
			ShowPlayerDialog(playerid, DIALOG_ID_SELLCAR, D_S_M,""COL_ORANGE"Продажа транспорта",d34,"Да","Нет");
			return 1;
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 371.1688,187.4530,1014.1875))
		{			
			static D40[] = 
					"\t"COL_WHITE"Здравствуйте! У нас Вы можете купить себе дом и зарегистрировать его. \t\n\
					\tТакже здесь Вы сможете выставить свой дом на продажу, если он у Вас имеется.\t\n\n\
					\tЗа каждую совершенную операций мы берем комиссию в размере "COL_APED"%d %%.\t\n\n\
					\t"COL_WHITE"Хотите купить себе дом или продать свой?\t\n";
					
			new d40[sizeof(D40)+8];
			
			format(d40, sizeof(d40), D40, NALOG_BUYSELLHOUSE);
			ShowPlayerDialog(playerid, DIALOG_ID_BUYSELLHOUSE, D_S_M, ""COL_ORANGE"Отдел по работе с недвижимостью", d40, "Купить", "Продать");
			return 1;
		}

		if(IsPlayerInRangeOfPoint(playerid, 1.0, -2400.0496,-2183.4885,33.4849))
		{			
			for(new i; i < sizeof(ChangeColor); i++)
			{
				TextDrawSetPreviewModel(ChangeColor[i], 19349);
				TextDrawShowForPlayer(playerid,ChangeColor[i]);
			}
			GameTextForPlayer(playerid, FixText("~G~Выберите 1 цвет"), 1500, 3);
								
			SelectTextDraw(playerid, 0xFFFFFF66);
			
			PlayerChoosePaintColor{playerid} = true;
			return 1;
		}
		
		foreach(new i : APED)
		{
			if(IsPlayerInRangeOfPoint(playerid, 1.1, APEDInfo[i][aPosX], APEDInfo[i][aPosY], APEDInfo[i][aPosZ]) && 
			GetPlayerVirtualWorld(playerid) == APEDInfo[i][aVW] && PlayerInfo[playerid][pAPED] == 2)
			{
				if(PlayerInfo[playerid][pID] == APEDInfo[i][aPlayerID])
				{
					ShowPlayerDialog(playerid, DIALOG_ID_TAKEAPED, D_S_M, ""COL_ORANGE"Идет зарядка APED...", ""COL_WHITE"Вы хотите снять APED с зарядки?\n",
					"Да", "Нет");
					SetPVarInt(playerid, "IDAPED", i);
					return 1;
				}
				else 
					SendClientMessage(playerid, COLOR_GREY,"Вы не можете взять чужой APED.");
			}
		}	
	
		foreach(new i : House)
		{
			if(IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[i][hExitX], HouseInfo[i][hExitY], HouseInfo[i][hExitZ])
			&& GetPlayerVirtualWorld(playerid) == HouseInfo[i][hVirt] && HouseInfo[i][hOwned] != 0 && !IsPlayerBlackScreen{playerid})
				return ShowPlayerHouseDialog(playerid);
		}
		
		if(IsAtCafe(playerid))
			return ShowCafeDialog(playerid);
		
		if(!GetPVarInt(playerid, "Refill")) 
			cmd::vmenu(playerid);
	}
	
	if (newkeys == KEY_CROUCH)
   	{
		if(IsAtGasStation(playerid))
   	    {
		    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
				return SendClientMessage(playerid, COLOR_GREY,"Нужно находиться в транспорте.");
			
		    if(GetPVarInt(playerid, "Refill") == 1) return 1;
			
		    GetVehicleParamsEx(vid,engine,lights,alarm,doors,bonnet,boot,objective);
			
		    if(engine) 
				return SendClientMessage(playerid, COLOR_GREY,"Заглушите двигатель вашего транспортного средства.");
		
		    TogglePlayerControllable(playerid, 0);
			
		    new str[178];
			
			format(str, sizeof(str),
			""COL_BLUE"Здравствуйте, Вас приветствует АЗС округа 'Angel Pine'\n\nВведите количество литров, которое Вы хотите наполнить в бензобак:\nСтоимость одного литра: "COL_GREEN"%d $", CENA_BENZ);
			ShowPlayerDialog(playerid, DIALOG_ID_REFILL, D_S_I, ""COL_ORANGE"АЗС", str, "Принять", "Отмена");
		    return 1;
		}
	}
	
	if (newkeys == KEY_NO && PlayerInfo[playerid][pAPED] == 1 && !IsPlayerBlackScreen{playerid})
	{		
		if(PlayerInfo[playerid][pAPEDBattery] > 0)
		{
			for(new i; i < 9; i++)
				TextDrawShowForPlayer(playerid, TDEditor_TD[i]);
			
			TextDrawShowForPlayer(playerid, TDAPEDPercent[playerid]);
			
			if(PlayerInfo[playerid][pAdmin] > 0) 
				TextDrawShowForPlayer(playerid, TDEditor_TD[9]);
			
			SelectTextDraw(playerid, 0x00FF00FF);
			CloseTextDrawAPED{playerid} = true;
			
			new string[MAX_PLAYER_NAME+1+38];
					
			format(string, sizeof(string), "%s достает свой APED и смотрит на его экран.", Name(playerid));
			ProxDetector(playerid, COLOR_PROX, string, 10);
		}			
		else 
			return SendClientMessage(playerid,COLOR_GREY,"Ваш APED разряжен.");
	}
	
    if (newkeys == KEY_WALK && !IsPlayerBlackScreen{playerid})
   	{
    	foreach(new i : House)
		{
	        if(IsPlayerInRangeOfPoint(playerid, 1.5, HouseInfo[i][hEnterX],HouseInfo[i][hEnterY],HouseInfo[i][hEnterZ]))
	        {
				if(HouseInfo[i][hOwned] == 0 && HouseInfo[i][hAdd] != 0)
				{
				  	new string[140];
					
				  	format(string, sizeof(string), ""COL_BLUE"Этот дом выставлен на продажу.\n\nID дома: "COL_WHITE"%d\n"COL_BLUE"Цена: "COL_GREEN"%d $\n\n"COL_BLUE"Хотите ли Вы осмотреть дом?\n", i, HouseInfo[i][hPrice]);
					
					ShowPlayerDialog(playerid, DIALOG_ID_HOUSEENTER, D_S_M, ""COL_ORANGE"Покупка дома", string, "Да", "Нет");
					
					SetPVarInt(playerid, "HouseID", i);
					return 1;
				}
				
				if(PlayerInfo[playerid][pHouse] == i)
				{
					if(HouseInfo[i][hLock] == 1) return SendClientMessage(playerid, COLOR_GREY, "Дверь закрыта.");
				  	SetPlayerPosCW(playerid, HouseInfo[i][hExitX], HouseInfo[i][hExitY], HouseInfo[i][hExitZ], HouseInfo[i][hExitA],HouseInfo[i][hInt], HouseInfo[i][hVirt]);
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.1, 0, 1, 1, 1, 0, 1);
					return 1;
				}
				
				if(PlayerInfo[playerid][pHouse] != i && HouseInfo[i][hOwned] != 0)
				{
					if(HouseInfo[i][hLock] == 1) return 
					ShowPlayerDialog(playerid, DIALOG_ID_HOUSEKNOCK, D_S_M, ""COL_ORANGE"Постучаться домой",
					""COL_WHITE"Дверь закрыта.\nВы хотите постучаться?\n", "Да", "Нет"), SetPVarInt(playerid, "HouseKnockID", i);
					
				  	SetPlayerPosCW(playerid, HouseInfo[i][hExitX], HouseInfo[i][hExitY], HouseInfo[i][hExitZ], HouseInfo[i][hExitA],HouseInfo[i][hInt], HouseInfo[i][hVirt]);
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.1, 0, 1, 1, 1, 0, 1);
					return 1;
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 1.5, HouseInfo[i][hExitX],HouseInfo[i][hExitY],HouseInfo[i][hExitZ])
			&& GetPlayerVirtualWorld(playerid) == HouseInfo[i][hVirt] && HouseInfo[i][hAdd] != 0)
			{
				ShowPlayerDialog(playerid, DIALOG_ID_HOUSEEXIT, D_S_M, ""COL_ORANGE"Выход из дома", ""COL_BLUE"Вы хотите выйти из дома?", "Да", "Нет");
					
				SetPVarInt(playerid, "HouseID", i);
				return 1;
			}
		}
		foreach(Enters, i)
		{
		    if(IsPlayerInRangeOfPoint(playerid, 1.0, EnterInfo[i][eEnterX], EnterInfo[i][eEnterY], EnterInfo[i][eEnterZ]) && EnterInfo[i][eAdd] == 1)
		    {
		        SetPlayerPosCW(playerid, EnterInfo[i][eExitX], EnterInfo[i][eExitY], EnterInfo[i][eExitZ], EnterInfo[i][eExitA],EnterInfo[i][eExitInt],EnterInfo[i][eExitVirt]);
				ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.1, 0, 1, 1, 1, 0, 1);
		        break;
		    }
		    else if(IsPlayerInRangeOfPoint(playerid, 1.0, EnterInfo[i][eExitX], EnterInfo[i][eExitY], EnterInfo[i][eExitZ]) && EnterInfo[i][eAdd] == 1)
		    {
		        SetPlayerPosCW(playerid, EnterInfo[i][eEnterX], EnterInfo[i][eEnterY], EnterInfo[i][eEnterZ], EnterInfo[i][eEnterA],EnterInfo[i][eEnterInt], EnterInfo[i][eEnterVirt]);
				ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.1, 0, 1, 1, 1, 0, 1);
		        break;
		    }
		}
	}
	
	if(newkeys == KEY_CTRL_BACK && !IsPlayerInAnyVehicle(playerid) || newkeys == KEY_CROUCH && IsPlayerInAnyVehicle(playerid))
	{
		if(!IsInventoryOpen{playerid})
			ShowInventory(playerid);
	}
	
	if (HOLDING(KEY_SPRINT))
	{
		if(GetPVarInt(playerid, "PlayerRunInGym"))
		{
			if(PlayerInfo[playerid][pEndurance] < TWOHOURS || GetPVarInt(playerid, "ChooseGymAction") != 1) 
			{
				GymBar[playerid] = 0;
				GameTextForPlayer(playerid, "", 500, 5);
				GameTextForPlayer(playerid, "", 500, 3);
				
				TogglePlayerControllable(playerid, 0);
				SetCameraBehindPlayer(playerid);
				ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_getoff", 4.1, 0, 0, 0, 1, 1, 1);
				SetTimerEx("@_ClearAnimAfterGetOff", 2800, false, "%d", playerid);
				
				if(PlayerInfo[playerid][pEndurance] < TWOHOURS)
					SendClientMessage(playerid, COLOR_GREY, "Вы устали, передохните.");
				
				return 1;
			}
			
			GymBar[playerid] ++;
			ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_jog", 4.1, 1, 0, 0, 1, 1, 1);
			GameTextForPlayer(playerid, "~w~~k~~PED_SPRINT~", 10000, 5);
			
			switch(GymBar[playerid])
			{
				case 1: GameTextForPlayer(playerid, "~b~~h~~h~~h~I~b~IIIIIIIII", 10000, 3);			
				case 2: GameTextForPlayer(playerid, "~b~~h~~h~~h~II~b~IIIIIIII", 10000, 3);			
				case 3: GameTextForPlayer(playerid, "~b~~h~~h~~h~III~b~IIIIIII", 10000, 3);			
				case 4: GameTextForPlayer(playerid, "~b~~h~~h~~h~IIII~b~IIIIII", 10000, 3);				
				case 5: GameTextForPlayer(playerid, "~b~~h~~h~~h~IIIII~b~IIIII", 10000, 3);
				case 6: GameTextForPlayer(playerid, "~b~~h~~h~~h~IIIIII~b~IIII", 10000, 3);			
				case 7: GameTextForPlayer(playerid, "~b~~h~~h~~h~IIIIIII~b~III", 10000, 3);				
				case 8: GameTextForPlayer(playerid, "~b~~h~~h~~h~IIIIIIII~b~II", 10000, 3);				
				case 9: GameTextForPlayer(playerid, "~b~~h~~h~~h~IIIIIIIII~b~I", 10000, 3);
				
				case 10:
				{
					GameTextForPlayer(playerid, "~b~~h~~h~~h~IIIIIIIIII", 10000, 3),
					GymBar[playerid] = 0;
					
					GiveEndurance(playerid, -3);
					PlayerInfo[playerid][pEnduranceMax] ++;
					UpdateDataInt(PlayerInfo[playerid][pID], "accounts",  "EnduranceMax", PlayerInfo[playerid][pEnduranceMax]);
				}
			}			
			return 1;
		}
		
		PlayerRun{playerid} = true;
		
		if(PlayerInfo[playerid][pEndurance] < TWOHOURS && !IsPlayerInAnyVehicle(playerid))
		{
			TogglePlayerControllable(playerid, 0);
			ClearAnimations(playerid);
			ApplyAnimation(playerid, "FAT", "IDLE_tired", 4.0, 1, 0, 0, 0, 0);
			SetPVarInt(playerid, "PlayerIdleTired", 1);
		}
	}
	if (RELEASED(KEY_SPRINT)) 
	{		
		PlayerRun{playerid} = false;
		
		if(PlayerInfo[playerid][pEndurance] < TWOHOURS && GetPVarInt(playerid, "PlayerIdleTired"))
			TogglePlayerControllable(playerid, 1), DeletePVar(playerid, "PlayerIdleTired");
	}
	
	if(newkeys & KEY_SECONDARY_ATTACK)
	{	
		if(GetPVarInt(playerid, "PlayerRunInGym"))
		{
			GymBar[playerid] = 0;
			GameTextForPlayer(playerid, "", 500, 5);
			GameTextForPlayer(playerid, "", 500, 3);
			
			TogglePlayerControllable(playerid, 0);
			SetCameraBehindPlayer(playerid);
			ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_getoff", 4.1, 0, 0, 0, 1, 1);
			SetTimerEx("@_ClearAnimAfterGetOff", 2800, false, "%d", playerid);				 
			return 1;
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 773.4604, -2.5011, 1000.8479) && !GetPVarInt(playerid, "PlayerRunInGym"))
		{
			if(GetPVarInt(playerid, "ChooseGymAction") != 1)
				return SendClientMessage(playerid, COLOR_GREY, "Чтобы заниматься на дорожке приобретите разовый абонемент.");
			
			if(PlayerInfo[playerid][pEndurance] < TWOHOURS) 
				return SendClientMessage(playerid, COLOR_GREY, "Вы устали и не можете заниматься.");
			
			if(	PlayerInfo[playerid][pSex] == 1 && GetPlayerCustomSkin(playerid) != 25009 || 
				PlayerInfo[playerid][pSex] == 2 && GetPlayerCustomSkin(playerid) != 25013)
				return SendClientMessage(playerid, COLOR_GREY, "Для того, чтобы начать заниматься переоденьтесь в раздевалке.");
				
			SetPlayerPos(playerid, 773.4844,-1.3190,1000.7);
			SetPlayerFacingAngle(playerid, 179.6896);
			TogglePlayerControllable(playerid, 0);
			ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_geton", 4.1, 0, 0, 0, 1, 1);				
			
			SetTimerEx("@_ApplyAnimGetOnGym", 2000, false, "%d", playerid);
				
			SetPlayerCameraPos(playerid, 770.9681, -1.1875, 999.8527);
			SetPlayerCameraLookAt(playerid, 771.8660, -1.6245, 1000.0884);
			return 1;
		}
		
		new model[6] = {441, 464, 501, 465, 564, 594};
		
		for(new i; i < sizeof model; i++)
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == model[i])
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			SetPlayerPos(playerid, x+1.0, y+1.0, z+0.5);
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
	new Float:health;
	
	if (PlayerInfo[playerid][pHP] != GetPlayerHealth(playerid, health))
		SetPlayerHealth(playerid, PlayerInfo[playerid][pHP]);
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

public OnTrailerUpdate(playerid, vehicleid)
{
    new Float:x, Float:y, Float:z, Float:a;

	GetVehiclePos(vehicleid, x, y, z);	
	GetVehicleZAngle(vehicleid, a);
	
	VehPosX[vehicleid] = x;
	VehPosY[vehicleid] = y;
	VehPosZ[vehicleid] = z;
	VehPosA[vehicleid] = a;
    return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
	{
		
		case DIALOG_ID_REGISTER:
		{
			if(!response)
			{
				ShowPlayerDialog(playerid, DIALOG_ID_NONE, DIALOG_STYLE_MSGBOX, ""COL_ORANGE"Оповещение", ""COL_BLUE"Вы были отсоединены от сервера.\n\
				Для выхода с сервера введите \"/q\" в чат", "", "");				
				return Kick(playerid);
			}
			if(!strlen(inputtext)) 
				return ShowPlayerDialog(playerid, DIALOG_ID_REGISTER, D_S_P, ""COL_ORANGE"Регистрация аккаунта",
				""COL_RED"Ошибка: "COL_BLUE"Вы не ввели пароль!\n\n\
				"COL_YELLOW"Примечание:\n"COL_BLUE"Пароль чувствителен к регистру. Пароль должен содержать "COL_WHITE"от 3 до 30 символов.\n\
				"COL_BLUE"Пароль может содержать латинские/кириллические символы и цифры "COL_WHITE"(aA-zZ, аА-яЯ, 0-9).\n\n\
				"COL_WHITE"\tВведите пароль для регистрации нового аккаунта:\n", "Регистрация", "Выход");
			
			if(!(3 <= strlen(inputtext) <= 30)) 
				return ShowPlayerDialog(playerid, DIALOG_ID_REGISTER, D_S_P, ""COL_ORANGE"Регистрация аккаунта",
				""COL_RED"Ошибка: "COL_BLUE"Пароль должен содержать "COL_WHITE"от 3 до 30 символов.\n\n\
				"COL_YELLOW"Примечание:\n"COL_BLUE"Пароль чувствителен к регистру.\n\
				Пароль может содержать латинские/кириллические символы и цифры "COL_WHITE"(aA-zZ, аА-яЯ, 0-9).\n\n\
				"COL_WHITE"\tВведите пароль для регистрации нового аккаунта:\n", "Регистрация", "Выход");
			
			for(new i = strlen(inputtext)-1; i != -1; i--)
			{
				switch(inputtext[i])
				{
					case '0'..'9', 'а'..'я', 'a'..'z', 'А'..'Я', 'A'..'Z': continue;
					
					default: return ShowPlayerDialog(playerid, DIALOG_ID_REGISTER, D_S_P, ""COL_ORANGE"Регистрация аккаунта",
					""COL_RED"Ошибка: "COL_BLUE"Пароль может содержать только латинские/кириллические символы и цифры "COL_WHITE"(aA-zZ, аА-яЯ, 0-9).\n\n\
					"COL_YELLOW"Примечание:\n"COL_BLUE"Пароль чувствителен к регистру.\n\n\
					"COL_WHITE"\tВведите пароль для регистрации нового аккаунта:\n", "Регистрация", "Выход");
				}
			}
			
			PlayerInfo[playerid][pPass][0] = EOS;
			
			for (new i = 0; i < 16; i++) PlayerInfo[playerid][pSalt][i] = random(94) + 33;
			SHA256_PassHash(inputtext, PlayerInfo[playerid][pSalt], PlayerInfo[playerid][pPass], 65);
			
			DeletePVar(playerid, "player_kick_time");
			
			CreateNewAccount(playerid, PlayerInfo[playerid][pPass], PlayerInfo[playerid][pSalt]);
			return 1;
		}
		
		case DIALOG_ID_LOGIN:
		{
			if(!response)
			{
				ShowPlayerDialog(playerid, DIALOG_ID_NONE, DIALOG_STYLE_MSGBOX, ""COL_ORANGE"Оповещение", ""COL_BLUE"Вы были отсоединены от сервера.\n\
				Для выхода с сервера введите \"/q\" в чат", "", "");
			}
			
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_ID_LOGIN, D_S_P, ""COL_ORANGE"Авторизация",
			""COL_RED"Ошибка: "COL_BLUE"Вы не ввели пароль!\nВведите пароль от аккаунта для входа на сервер:", "Вход", "Выход");
			
			new hashed_pass[65];
			SHA256_PassHash(inputtext, PlayerInfo[playerid][pSalt], hashed_pass, 65);

			if (strcmp(hashed_pass, PlayerInfo[playerid][pPass]) == 0)
			{
				DeletePVar(playerid, "player_kick_time");
				
				new query_string[49+MAX_PLAYER_NAME];
				
				mysql_format(mysql_connect_ID, query_string, sizeof(query_string), "SELECT * FROM `accounts` WHERE `Name` = '%s'", PlayerInfo[playerid][pName]);
				mysql_tquery(mysql_connect_ID, query_string, "UploadPlayerAccount", "i", playerid);
			}
			else
			{
				switch(GetPVarInt(playerid, "WrongPassword"))
				{
					case 0: ShowPlayerDialog(playerid, DIALOG_ID_LOGIN, D_S_P, ""COL_ORANGE"Авторизация",
					""COL_RED"Ошибка: "COL_BLUE"Вы ввели неверный пароль! У Вас осталось 3 попытки.\n\
					Введите пароль от аккаунта для входа на сервер:", "Вход", "Выход");
					
					case 1: ShowPlayerDialog(playerid, DIALOG_ID_LOGIN, D_S_P, ""COL_ORANGE"Авторизация",
					""COL_RED"Ошибка: "COL_BLUE"Вы ввели неверный пароль! У Вас осталось 2 попытки.\n\
					Введите пароль от аккаунта для входа на сервер:", "Вход", "Выход");
					
					case 2: ShowPlayerDialog(playerid, DIALOG_ID_LOGIN, D_S_P, ""COL_ORANGE"Авторизация",
					""COL_RED"Ошибка: "COL_BLUE"Вы ввели неверный пароль! У Вас осталась последняя попытка.\n\
					Введите пароль от аккаунта для входа на сервер:", "Вход", "Выход");
					
					default:
					{
						ShowPlayerDialog(playerid, DIALOG_ID_NONE, DIALOG_STYLE_MSGBOX, "Оповещение",
						""COL_BLUE"Вы были отсоединены от сервера.\nДля выхода с сервера введите \"/q\" в чат", "Выход", "");
						return Kick(playerid);
					}
				}
				SetPVarInt(playerid, "WrongPassword", GetPVarInt(playerid, "WrongPassword")+1);
			}
			return 1;
		}
	    
	    case DIALOG_ID_CHOOSESEX:
	    {
			SetPVarInt(playerid, "Skin", response ? 25002 : 25006);
			SetPVarInt(playerid, "Sex", response ? 1 : 2);
			
			ShowPlayerDialog(playerid, DIALOG_ID_REGISTER, D_S_P,""COL_ORANGE"Регистрация аккаунта"," "COL_BLUE"Приветствуем Вас на нашем сервере\n\
				Придумайте себе пароль для дальнейшего проживания в округе 'Angel Pine'\n", "Регистрация", "Выход");			
	    }
			    
	    case DIALOG_ID_BUYCAR:
    	{
    		if(response)
        	{
        	    new car = GetPlayerVehicleID(playerid);
            	if(!IsPlayerInAnyVehicle(playerid) || VehInfo[car][vBuy] != VBUYTOBUY) return 1;
				
            	if(PlayerInfo[playerid][pMoney] < VehInfo[car][vPrice])
					return SendClientMessage(playerid, COLOR_GREY, "У Вас недостаточно денег для покупки");
				
				if(PlayerInfo[playerid][pCarKey] != 0)
					return SendClientMessage(playerid, COLOR_GREY, "Можно иметь только одно транспортное средство.");
				
			   	PlayerInfo[playerid][pCarKey] = car;
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts",  "CarKey", PlayerInfo[playerid][pCarKey]);
				
				Delete3DTextLabel(Text3D:sellVehInfo[car]);
				
             	VehInfo[car][vBuy] = VBUYTOCARKEY;
             	VehInfo[car][vLock] = false;
				strmid(VehInfo[car][vOwner], Name(playerid), 0, strlen(Name(playerid)), MAX_PLAYER_NAME);
				UpdateDataInt(car, "vehicles", "Buy", VehInfo[car][vBuy]);
				UpdateDataInt(car, "vehicles", "Lock", VehInfo[car][vLock]);
				UpdateDataVarchar(car, "vehicles", "Owner", VehInfo[car][vOwner]);
				
             	PlayerInfo[playerid][pMoney] -= VehInfo[car][vPrice];
				             	
             	GameTextForPlayer(playerid, FixText("~G~Поздравляем с покупкой"), 1500, 3);
				
             	TogglePlayerControllable(playerid, 1);
       			return 1;
 			}
		}
		
		case DIALOG_ID_VMENU:
  		{
    		if(response)
      		{				
				if(listitem >= 0 && listitem <= 7)
                {
					static const
						fmt_str1_0[] = " запускает двигатель.",
						fmt_str1_1[] = " глушит двигатель.",
						fmt_str2_0[] = " включает ближний свет фар.",
						fmt_str2_1[] = " выключает ближний свет фар.",
						fmt_str3_0[] = " активирует сигнализацию.",
						fmt_str3_1[] = " деактивирует сигнализацию.",
						fmt_str4_0[] = " открывает двери.",
						fmt_str4_1[] = " закрывает двери.",
						fmt_str5_0[] = " открывает капот.",
						fmt_str5_1[] = " закрывает капот.",
						fmt_str6_0[] = " открывает багажник.",
						fmt_str6_1[] = " закрывает багажник.",
						fmt_str7_0[] = " открывает окна.",
						fmt_str7_1[] = " закрывает окна.",
						fmt_str8_0[] = " активирует поиск транспорта по GPS.",
						fmt_str8_1[] = " деактивирует поиск транспорта по GPS.";
					
					const
						size = sizeof(fmt_str8_1) + (MAX_PLAYER_NAME+1);
					
					new string[size];
					
                    new params[7],
						carid = GetAroundPlayerVehicleID(playerid, 4.0);
						
                    GetVehicleParamsEx(carid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
					
					strcat(string, Name(playerid));
					switch(listitem)
					{
						case 0: 
						{
							strcat(string, (!params[0]) ? (fmt_str1_0) : (fmt_str1_1)); 
							Engine{carid} = (Engine{carid}) ? false : true;
						}
						case 1: strcat(string, (!params[1]) ? (fmt_str2_0) : (fmt_str2_1));
						case 2: strcat(string, (!params[2]) ? (fmt_str3_0) : (fmt_str3_1));
						case 3: 
						{
							strcat(string, (!params[3]) ? (fmt_str4_1) : (fmt_str4_0));
							VehInfo[carid][vLock] = !params[listitem];
							UpdateDataInt(carid, "vehicles", "Lock", !params[listitem]);
						}
						case 4: strcat(string, (!params[4]) ? (fmt_str5_0) : (fmt_str5_1));
						case 5: strcat(string, (!params[5]) ? (fmt_str6_0) : (fmt_str6_1));
						case 6: strcat(string, (!params[6]) ? (fmt_str8_0) : (fmt_str8_1));
						case 7: strcat(string, (driver) ? (fmt_str7_0) : (fmt_str7_1)),
								driver = !driver,
								SetVehicleParamsCarWindows(carid, driver, driver, 1, 1);
					}
					ProxDetector(playerid,COLOR_PROX, string, 10.0);
					
					params[listitem] = !params[listitem];
                    SetVehicleParamsEx(carid, params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
										
					ShowPlayerVehicleDialog(playerid);
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
				    format(str, sizeof(str), ""COL_RED"Ошибка: "COL_BLUE"Вы не ввели количество литров!\n\n\
					Введите количество литров, которое Вы хотите залить в бензобак:\nСтоимость одного литра: "COL_GREEN"%d $",CENA_BENZ);
					ShowPlayerDialog(playerid, DIALOG_ID_REFILL, D_S_I, ""COL_ORANGE"АЗС", str, "Принять", "Отмена");
					return 1;
				}
				
	            inputfuel{playerid} = strval(inputtext);
				
	            if(VehInfo[GetPlayerVehicleID(playerid)][vFuel] + inputfuel{playerid} >= 100)
				{
				    format(str, sizeof(str), ""COL_RED"Ошибка: "COL_BLUE"Введите меньшее количество литров!\n\n\
					Введите количество литров, которое Вы хотите залить в бензобак:\nСтоимость одного литра: "COL_GREEN"%d $",CENA_BENZ);
					ShowPlayerDialog(playerid, DIALOG_ID_REFILL, D_S_I, ""COL_ORANGE"АЗС", str, "Принять", "Отмена");
					return 1;
				}
				
				if(PlayerInfo[playerid][pMoney] < CENA_BENZ*inputfuel{playerid})
				{
                    format(str, sizeof(str), ""COL_RED"Ошибка: "COL_BLUE"Недостаточно денег!\n\n\
					Введите количество литров, которое Вы хотите залить в бензобак:\nСтоимость одного литра: "COL_GREEN"%d $",CENA_BENZ);
					ShowPlayerDialog(playerid, DIALOG_ID_REFILL, D_S_I, ""COL_ORANGE"АЗС", str, "Принять", "Отмена");
					return 1;
				}
				
				SetPVarInt(playerid,"timer", SetTimerEx("Refill", 500, false, "ii", playerid, inputfuel{playerid}));
	            SetPVarInt(playerid, "Refill", 1);
				
           		PlayerInfo[playerid][pMoney] -= CENA_BENZ*inputfuel{playerid};
				
				GameTextForPlayer(playerid, FixText("~G~Ожидайте, идет заправка..."), 3000, 3);
			}
			else 
				TogglePlayerControllable(playerid, 1);
		}
		
		case DIALOG_ID_WOODSTART:
  		{
    		if(response)
      		{
        		new Random = random(sizeof(RandomWood));
       		 	SetPVarInt(playerid, "PlayerWood", 1);
				SetPVarInt(playerid, "IsWork", 1);
				SetPlayerRaceCheckpoint(playerid,0,RandomWood[Random][0], RandomWood[Random][1], RandomWood[Random][2],RandomWood[Random][0],
				RandomWood[Random][1], RandomWood[Random][2],0.5);
	
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
				
                if(IsPlayerAttachedObjectSlotUsed(playerid, 0)) RemovePlayerAttachedObject(playerid, 1);
                if(IsPlayerAttachedObjectSlotUsed(playerid, 1)) RemovePlayerAttachedObject(playerid, 2);
				
				if (PlayerInfo[playerid][pMoneyDolg] == 0)
					ShowPlayerDialog(playerid, DIALOG_ID_NONE, D_S_M,""COL_ORANGE"Дровосек",""COL_WHITE"К сожалению, ты ничего не заработал.\n\
					Может быть в другой раз..","Закрыть","");				
				else
				{
					new str[46 -2 + 9];
					
					format(str, sizeof(str), ""COL_BLUE"Спасибо за помощь, вот Ваши "COL_GREEN"%d $.\n",PlayerInfo[playerid][pMoneyDolg]);
					ShowPlayerDialog(playerid, DIALOG_ID_NONE, D_S_M,""COL_ORANGE"Дровосек",str,"Принять","");
					
					PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
				}
				
				PlayerInfo[playerid][pMoney] += PlayerInfo[playerid][pMoneyDolg];
				PlayerInfo[playerid][pMoneyDolg] = 0;
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "MoneyDolg", PlayerInfo[playerid][pMoneyDolg]);
			}
   			return true;
      	}
		
      	case DIALOG_ID_HOUSEENTER:
    	{
    		if(response) 
			{
				SetPlayerPosCW(playerid,HouseInfo[GetPVarInt(playerid, "HouseID")][hExitX],HouseInfo[GetPVarInt(playerid, "HouseID")][hExitY],
				HouseInfo[GetPVarInt(playerid, "HouseID")][hExitZ], HouseInfo[GetPVarInt(playerid, "HouseID")][hExitA], 
				HouseInfo[GetPVarInt(playerid, "HouseID")][hInt],HouseInfo[GetPVarInt(playerid, "HouseID")][hVirt]);
				ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.1, 0, 1, 1, 1, 0, 1);
			}
		}
		
		case DIALOG_ID_HOUSEEXIT:
    	{
    		if(response) 
			{
				if(HouseInfo[GetPVarInt(playerid, "HouseID")][hLock] == 1) 
					return SendClientMessage(playerid, COLOR_GREY, "Дверь закрыта.");
				
				SetPlayerPosCW(playerid,HouseInfo[GetPVarInt(playerid, "HouseID")][hEnterX],HouseInfo[GetPVarInt(playerid, "HouseID")][hEnterY],
				HouseInfo[GetPVarInt(playerid, "HouseID")][hEnterZ], HouseInfo[GetPVarInt(playerid, "HouseID")][hEnterA],0,0);
				ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.1, 0, 1, 1, 1, 0, 1);
			}
		}
		
		
		case DIALOG_ID_REASONUNLEADER:
		{
			if(response) 
			{
				if(!strlen(inputtext))
					return ShowPlayerDialog(playerid, DIALOG_ID_REASONUNLEADER, D_S_I, ""COL_ORANGE"Введите причину",
					""COL_BLUE"Введите причину снятия игрока с лидерства организации:\n", "Принять", "Назад");
				
				new string[512],
					target = GetPVarInt(playerid, "makeleader_target");
	
				format(string, sizeof(string), ""COL_BLUE"\nАдминистратор [%d] %s снял Вас с лидерства организации "COL_WHITE"%s\n\
				"COL_BLUE"Причина: "COL_WHITE"%s",playerid,Name(playerid), fraction_name[PlayerInfo[target][pMember]], inputtext);
				ShowPlayerDialog(target, DIALOG_ID_NONE, D_S_M, ""COL_ORANGE"Информация", string, "Принять", "");
										
				format(string, sizeof(string), "Администратор [%d] %s снял лидерство организации %s c игрока [%d] %s, причина: %s",
				playerid, Name(playerid), fraction_name[PlayerInfo[target][pMember]], target, Name(target), inputtext);
				
				WriteLogByTypeName("Unleader", PlayerInfo[playerid][pID], PlayerInfo[target][pID], inputtext);
				
				Iter_Remove(OrganisationsPlayer[PlayerInfo[playerid][pMember]], target);
					
				PlayerInfo[target][pMember] = 
				PlayerInfo[target][pLeader] = 
				PlayerInfo[target][pMemberWarn] = 
				PlayerInfo[target][pMemberSkin] = 0;
				strmid(PlayerInfo[target][pRankName], " ", 0, strlen(inputtext), 1);
				UpdateDataInt(PlayerInfo[target][pID], "accounts", "Member", PlayerInfo[target][pMember]);
				UpdateDataInt(PlayerInfo[target][pID], "accounts", "Leader", PlayerInfo[target][pLeader]);
				UpdateDataInt(PlayerInfo[target][pID], "accounts", "MemberWarn", PlayerInfo[target][pMemberWarn]);
				UpdateDataInt(PlayerInfo[target][pID], "accounts", "MemberSkin", PlayerInfo[target][pMemberSkin]);
				UpdateDataVarchar(PlayerInfo[target][pID], "accounts", "RankName", PlayerInfo[target][pRankName]);
			}
			else
			{
				static const
					fmt_dlg_header[] = ""COL_ORANGE"Назначить лидером игрока "COL_WHITE"[%d] %s",
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
		
		case DIALOG_ID_SETLEADER:
        {
            new target = GetPVarInt(playerid, "makeleader_target");
			
			if(listitem == 0)
			{
					if(PlayerInfo[target][pLeader] == 0) 
						return SendClientMessage(playerid, COLOR_GREY, "Игрок не является лидером организации.");
					
					ShowPlayerDialog(playerid, DIALOG_ID_REASONUNLEADER, D_S_I, ""COL_ORANGE"Введите причину",
					""COL_BLUE"Введите причину снятия игрока с лидерства организации:\n", "Принять", "Назад");
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
				
				if(Iter_Contains(OrganisationsPlayer[PlayerInfo[playerid][pMember]], target))
					Iter_Remove(OrganisationsPlayer[PlayerInfo[playerid][pMember]], target);

				PlayerInfo[target][pMember] = 
				PlayerInfo[target][pLeader] = listitem;
				UpdateDataInt(PlayerInfo[target][pID], "accounts", "Member", PlayerInfo[target][pMember]);
				UpdateDataInt(PlayerInfo[target][pID], "accounts", "Leader", PlayerInfo[target][pLeader]);
				
				Iter_Add(OrganisationsPlayer[PlayerInfo[playerid][pMember]], target);
				
				WriteLogByTypeName("Leader", PlayerInfo[playerid][pID], PlayerInfo[target][pID], fraction_name[listitem]);

				ShowPlayerDialog(target, DIALOG_ID_SETLEADERRANK, D_S_I, ""COL_ORANGE"Установить ранг", ""COL_BLUE"Введите название для своего ранга:\n",
				"Принять", "");
			}
		}
		
		case DIALOG_ID_SETLEADERRANK:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
					return ShowPlayerDialog(playerid, DIALOG_ID_SETLEADERRANK, D_S_I, ""COL_ORANGE"Установить ранг",
					""COL_RED"Вы не ввели название ранга!\n"COL_BLUE"Введите название для своего ранга:\n", "Принять", "");

				
				if (strlen(inputtext) > 32)
					return ShowPlayerDialog(playerid, DIALOG_ID_SETLEADERRANK, D_S_I, ""COL_ORANGE"Установить ранг",
					""COL_RED"Введите не более 32 символов!\n"COL_BLUE"Введите название для своего ранга:\n", "Принять", "");
	            
    			strmid(PlayerInfo[playerid][pRankName], inputtext, 0, strlen(inputtext), 33);
				UpdateDataVarchar(PlayerInfo[playerid][pID], "accounts", "RankName", PlayerInfo[playerid][pRankName]);            	
	        }
	        else 
				return ShowPlayerDialog(playerid, DIALOG_ID_SETLEADERRANK, D_S_I, ""COL_ORANGE"Установить ранг",
					""COL_RED"Необходимо указать название ранга!\n"COL_BLUE"Введите название для своего ранга:\n", "Принять", "");
	    }
		
		case DIALOG_ID_INVITEMEMBERYESNO:
    	{
    	    new str[MAX_PLAYER_NAME+1+43];
    		if(response)
        	{
				PlayerInfo[playerid][pMember] = GetPVarInt(playerid, "InviteFromOrganisationID");
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "Member", PlayerInfo[playerid][pMember]);
                
			    format(str, sizeof(str), "[%d] %s принял предложение на работу.", playerid, Name(playerid));
				
				SendClientMessage(playerid, COLOR_GREEN,"Вы приняли предложение на работу.");
				
				Iter_Add(OrganisationsPlayer[PlayerInfo[playerid][pMember]], playerid);
			}
			else
			{
			    format(str, sizeof(str), "[%d] %s отказался от предложения на работу.", playerid, Name(playerid));
				
				SendClientMessage(playerid, COLOR_RED,"Вы отказались от предложения на работу.");
			}
			SendClientMessage(GetPVarInt(playerid, "IDOrganisationsLeader"), response ? COLOR_GREEN : COLOR_RED, str);
			
			DeletePVar(playerid, "InviteFromOrganisationID");
			DeletePVar(playerid, "IDOrganisationsLeader");	
		}
		
		case DIALOG_ID_LMENU:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{ 
						new string[1024], string1[1024];
						foreach(OrganisationsPlayer[PlayerInfo[playerid][pMember]], i)
						{							
							format(string, sizeof(string), ""COL_APED"%s \t"COL_APED"%d \t"COL_APED"%s \t"COL_APED"%d\n",
									Name(i), i, PlayerInfo[i][pRankName], PlayerInfo[i][pMemberWarn]);									
							strcat(string1, string, sizeof(string1)); 
						} 
						format(string, sizeof(string), ""COL_WHITE"Имя: \t"COL_WHITE"ID: \t"COL_WHITE"Ранг: \t"COL_WHITE"Кол-во выговоров: \n%s", string1); 
						ShowPlayerDialog(playerid, DIALOG_ID_BACKTOLMENU, D_S_TH, ""COL_ORANGE"Члены организации онлайн", string, "Закрыть", "Назад"); 
					}
					case 1:
						ShowPlayerDialog(playerid, DIALOG_ID_INVITEMEMBER, D_S_I, ""COL_ORANGE"Принять игрока", "\
						"COL_BLUE"Введите ID игрока, которого Вы хотите принять на работу:\n\
						", "Принять", "Назад");
					
					case 2:
						ShowPlayerDialog(playerid, DIALOG_ID_LAYOFFMEMBER, D_S_I, ""COL_ORANGE"Уволить игрока", "\
						"COL_BLUE"Введите ID игрока, которого Вы хотите уволить:\n\
						", "Принять", "Назад");
					
					case 3:
						ShowPlayerDialog(playerid, DIALOG_ID_WARNMEMBER, D_S_I, ""COL_ORANGE"Сделать выговор", "\
						"COL_BLUE"Введите ID игрока, которому Вы хотите дать выговор:\n\
						", "Принять", "Назад");
					case 4:
						ShowPlayerDialog(playerid, DIALOG_ID_UNWARNMEMBER, D_S_I, ""COL_ORANGE"Снять выговор", "\
						"COL_BLUE"Введите ID игрока, которому Вы хотите снять выговор:\n\
						", "Принять", "Назад");
					case 5:
						ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERRANK, D_S_I, ""COL_ORANGE"Установить ранг", "\
						"COL_BLUE"Введите ID игрока, которому Вы хотите установить ранг:\n\
						", "Принять", "Назад");
					case 6:
						ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERSKINID, D_S_I, ""COL_ORANGE"Установить скин", "\
						"COL_BLUE"Введите ID игрока, которому Вы хотите установить скин:\n\
						", "Принять", "Назад");					
				}
			}
			return 1;
		}
		
		case DIALOG_ID_BACKTOLMENU:
		{
			if(!response)
		        ShowPlayerLeaderDialog(playerid);
		}
		
		case DIALOG_ID_INVITEMEMBER:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
					return ShowPlayerDialog(playerid, DIALOG_ID_INVITEMEMBER, D_S_I, ""COL_ORANGE"Принять игрока", "\
					"COL_BLUE"Введите ID игрока, которого Вы хотите принять на работу:\n\
					", "Принять", "Назад");
					
	            if (strval(inputtext) == INVALID_PLAYER_ID || gPlayerLogged{strval(inputtext)} == false)
					return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети."), ShowPlayerLeaderDialog(playerid);
			
				if (strval(inputtext) == playerid) 
					return SendClientMessage(playerid, COLOR_GREY, "Вы ввели свой ID."), ShowPlayerLeaderDialog(playerid);
				
				if (PlayerInfo[strval(inputtext)][pMember] > 0)
					return SendClientMessage(playerid, COLOR_GREY,"Этот игрок уже состоит в другой организации."), ShowPlayerLeaderDialog(playerid);
				
				SetPVarInt(strval(inputtext), "InviteFromOrganisationID", PlayerInfo[playerid][pLeader]);
				SetPVarInt(strval(inputtext), "IDOrganisationsLeader", playerid);
				
				new string[66 - 6 + 4 + MAX_PLAYER_NAME + MAX_FRACTION_NAME_LENGTH];
				
				SendClientMessage(playerid, COLOR_WHITE, "Ожидайте ответа на Ваше предложение.");
			 					
				format(string, sizeof(string), ""COL_BLUE"\n[%d] %s хочет принять Вас во организацию "COL_WHITE"%s\n", playerid, Name(playerid),
				fraction_name[PlayerInfo[playerid][pLeader]]);
				ShowPlayerDialog(strval(inputtext), DIALOG_ID_INVITEMEMBERYESNO, D_S_M, ""COL_ORANGE"Приглашение в организацию", string, "Принять", "Отмена");
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	            ShowPlayerLeaderDialog(playerid);
	    }
		
	    case DIALOG_ID_LAYOFFMEMBER:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
					return ShowPlayerDialog(playerid, DIALOG_ID_LAYOFFMEMBER, D_S_I, ""COL_ORANGE"Уволить игрока", "\
					"COL_BLUE"Введите ID игрока, которого Вы хотите уволить:\n", "Принять", "Назад");
				
	            if (strval(inputtext) == INVALID_PLAYER_ID || gPlayerLogged{strval(inputtext)} == false) 
					return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети."), ShowPlayerLeaderDialog(playerid);
				
				if(strval(inputtext) == playerid) 
					return SendClientMessage(playerid, COLOR_GREY, "Вы ввели свой ID."), ShowPlayerLeaderDialog(playerid);
				
				if(PlayerInfo[strval(inputtext)][pMember] != PlayerInfo[playerid][pMember])
					return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в Вашей организации."), ShowPlayerLeaderDialog(playerid);
				
				new string[49 - 6 +4 + MAX_FRACTION_NAME_LENGTH + MAX_PLAYER_NAME];
				
				format(string, sizeof(string), "Вы уволили [%d] %s из организации.", strval(inputtext), Name(strval(inputtext)));
				SendClientMessage(playerid, COLOR_WHITE, string);
				
				format(string, sizeof(string), ""COL_BLUE"\n[%d] %s уволил Вас из организации "COL_WHITE"%s\n", playerid, Name(playerid),
				fraction_name[PlayerInfo[playerid][pLeader]]);
				ShowPlayerDialog(strval(inputtext), DIALOG_ID_NONE, D_S_M, ""COL_ORANGE"Увольнение из организации", string, "Принять", "");
				
				Iter_Remove(OrganisationsPlayer[PlayerInfo[playerid][pMember]], strval(inputtext));
				
				PlayerInfo[strval(inputtext)][pMember] =
				PlayerInfo[strval(inputtext)][pMemberWarn] =
				PlayerInfo[strval(inputtext)][pMemberSkin] =
				PlayerInfo[strval(inputtext)][pRankName] = 0;
				UpdateDataInt(PlayerInfo[strval(inputtext)][pID], "accounts", "Member", PlayerInfo[strval(inputtext)][pMember]);
				UpdateDataInt(PlayerInfo[strval(inputtext)][pID], "accounts", "MemberWarn", PlayerInfo[strval(inputtext)][pMemberWarn]);
				UpdateDataInt(PlayerInfo[strval(inputtext)][pID], "accounts", "MemberSkin", PlayerInfo[strval(inputtext)][pMemberSkin]);
				UpdateDataVarchar(PlayerInfo[strval(inputtext)][pID], "accounts", "RankName", PlayerInfo[strval(inputtext)][pRankName]);
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	            ShowPlayerLeaderDialog(playerid);
	    }
		
	    case DIALOG_ID_WARNMEMBER:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
					return ShowPlayerDialog(playerid, DIALOG_ID_WARNMEMBER, D_S_I, ""COL_ORANGE"Сделать выговор", "\
					"COL_BLUE"Введите ID игрока, которому Вы хотите сделать выговор:\n\
					", "Принять", "Назад");
				
	            if (strval(inputtext) == INVALID_PLAYER_ID || gPlayerLogged{strval(inputtext)} == false) 
					return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети."), ShowPlayerLeaderDialog(playerid);
			
				if(strval(inputtext) == playerid) 
					return SendClientMessage(playerid, COLOR_GREY, "Вы ввели свой ID."), ShowPlayerLeaderDialog(playerid);
				
				if(PlayerInfo[strval(inputtext)][pMember] != PlayerInfo[playerid][pMember]) 
					return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в Вашей организации."), ShowPlayerLeaderDialog(playerid);
				
				PlayerInfo[strval(inputtext)][pMemberWarn] += 1;
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "MemberWarn", PlayerInfo[playerid][pMemberWarn]);
				
				new string[62 - 6 +1 + 4 + MAX_PLAYER_NAME];
				
				format(string, sizeof(string), ""COL_BLUE"\n[%d] %s сделал Вам выговор. Количество выговоров: "COL_WHITE"%d\n", playerid, Name(playerid),
				PlayerInfo[strval(inputtext)][pMemberWarn]);
				ShowPlayerDialog(strval(inputtext), DIALOG_ID_NONE, D_S_M,""COL_ORANGE"Выговор", string, "Принять", "");
				
				format(string, sizeof(string), "Вы сделали выговор игроку %s.", Name(GetPVarInt(playerid, "MemberRangID")));
				SendClientMessage(playerid, COLOR_GREEN, string);
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	            ShowPlayerLeaderDialog(playerid);
	    }
		
	    case DIALOG_ID_UNWARNMEMBER:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
					return ShowPlayerDialog(playerid, DIALOG_ID_UNWARNMEMBER, D_S_I, ""COL_ORANGE"Снять выговор", "\
					"COL_BLUE"Введите ID игрока, которому Вы хотите снять выговор:\n\
					", "Принять", "Назад");
				
	            if (strval(inputtext) == INVALID_PLAYER_ID || gPlayerLogged{strval(inputtext)} == false) 
					return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети."), ShowPlayerLeaderDialog(playerid);
			
				if(strval(inputtext) == playerid) 
					return SendClientMessage(playerid, COLOR_GREY, "Вы ввели свой ID."), ShowPlayerLeaderDialog(playerid);
				
				if(PlayerInfo[strval(inputtext)][pMember] != PlayerInfo[playerid][pMember]) 
					return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в Вашей организации."), ShowPlayerLeaderDialog(playerid);
				
				if(PlayerInfo[strval(inputtext)][pMemberWarn] == 0) 
					return SendClientMessage(playerid, COLOR_GREY,"У игрока нет выговоров."), ShowPlayerLeaderDialog(playerid);
				
				PlayerInfo[strval(inputtext)][pMemberWarn] -= 1;
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "MemberWarn", PlayerInfo[playerid][pMemberWarn]);
				
				new string[74 - 6 +1 + 4 + MAX_PLAYER_NAME];
				
				format(string, sizeof(string), ""COL_BLUE"\n[%d] %s снял вам выговор. Количество выговоров: "COL_WHITE"%d\n", playerid, Name(playerid), 
				PlayerInfo[strval(inputtext)][pMemberWarn]);
				ShowPlayerDialog(strval(inputtext), DIALOG_ID_NONE, D_S_M, ""COL_ORANGE"Снятие выговора", string, "Принять", "");
				
				format(string, sizeof(string), "Вы сняли выговор игроку %s.", Name(GetPVarInt(playerid, "MemberRangID")));
				SendClientMessage(playerid, COLOR_GREEN, string);
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	            ShowPlayerLeaderDialog(playerid);
	    }
		
	    case DIALOG_ID_SETMEMBERRANK:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
					return ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERRANK, D_S_I, ""COL_ORANGE"Установить ранг", "\
					"COL_BLUE"Введите ID игрока, которому Вы хотите установить ранг:\n\
					", "Принять", "Назад");
					
	            if (strval(inputtext) == INVALID_PLAYER_ID || gPlayerLogged{strval(inputtext)} == false) 
					return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети."), ShowPlayerLeaderDialog(playerid);
			
				if(PlayerInfo[strval(inputtext)][pMember] != PlayerInfo[playerid][pMember]) 
					return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в Вашей организации."), ShowPlayerLeaderDialog(playerid);
			
				SetPVarInt(playerid, "MemberRangID", strval(inputtext));
				
				new string[112+MAX_PLAYER_NAME -4 +2];
				format(string, sizeof(string), ""COL_BLUE"Введите название ранга для игрока "COL_WHITE"[%d] %s\n", strval(inputtext), Name(strval(inputtext)));
				ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERRANKNAME, D_S_I, ""COL_ORANGE"Установить ранг", string, "Принять", "Назад");
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	            ShowPlayerLeaderDialog(playerid);
	    }
		
	    case DIALOG_ID_SETMEMBERRANKNAME:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {	   
				new string[110 + 4 + MAX_PLAYER_NAME - 4];
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {					
	                format(string, sizeof(string), ""COL_RED"Вы не ввели название ранга!\n"COL_BLUE"Введите название ранга для игрока "COL_WHITE"[%d] %s\n",
					strval(inputtext), Name(strval(inputtext)));
					ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERRANKNAME, D_S_I, ""COL_ORANGE"Установить ранг", string, "Принять", "Назад");
	                return 1;
	            }
					
				if (32 < strlen(inputtext))
				{					
	                format(string, sizeof(string), ""COL_RED"Введите менее 32 символов!\n"COL_BLUE"Введите название ранга для игрока "COL_WHITE"[%d] %s\n",
					GetPVarInt(playerid, "MemberRangID"), Name(GetPVarInt(playerid, "MemberRangID")));
					ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERRANKNAME, D_S_I, ""COL_ORANGE"Установить ранг", string, "Принять", "Назад");
	                return 1;
				}
					
	            if (GetPVarInt(playerid, "MemberRangID") == INVALID_PLAYER_ID || gPlayerLogged{GetPVarInt(playerid, "MemberRangID")} == false) 
					return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
			
				if(PlayerInfo[GetPVarInt(playerid, "MemberRangID")][pMember] != PlayerInfo[playerid][pMember]) 
					return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в Вашей организации.");
				
				strmid(PlayerInfo[GetPVarInt(playerid, "MemberRangID")][pRankName], inputtext, 0, strlen(inputtext), 33);
				UpdateDataVarchar(PlayerInfo[GetPVarInt(playerid, "MemberRangID")][pID], "accounts", "RankName",
				PlayerInfo[GetPVarInt(playerid, "MemberRangID")][pRankName]);
								
				format(string, sizeof(string), "Вы установили игроку %s ранг %s.", Name(GetPVarInt(playerid, "MemberRangID")), inputtext);
				SendClientMessage(playerid, COLOR_GREEN, string);
				
				format(string, sizeof(string), "[%d] %s установил Вам ранг %s.", playerid, Name(playerid), inputtext);
				SendClientMessage(GetPVarInt(playerid, "MemberRangID"), COLOR_GREEN, string);
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	            ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERRANK, D_S_I, ""COL_ORANGE"Установить ранг", "\
				"COL_BLUE"Введите ID игрока, которому Вы хотите установить ранг:\n\
				", "Принять", "Назад");
	    }
		
		case DIALOG_ID_SETMEMBERSKINID:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
					return ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERSKINID, D_S_I, ""COL_ORANGE"Установить скин", "\
					"COL_BLUE"Введите ID игрока, которому Вы хотите установить скин:\n\
					", "Принять", "Назад");
				
	            if (strval(inputtext) == INVALID_PLAYER_ID || gPlayerLogged{strval(inputtext)} == false) 
				{
					SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
					ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERSKINID, D_S_I, ""COL_ORANGE"Установить скин", "\
					"COL_BLUE"Введите ID игрока, которому Вы хотите установить скин:\n\
					", "Принять", "Назад");
					return 1;
				}
			
				if(PlayerInfo[strval(inputtext)][pMember] != PlayerInfo[playerid][pMember]) 
				{
					SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в Вашей организации.");
					ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERSKINID, D_S_I, ""COL_ORANGE"Установить скин", "\
					"COL_BLUE"Введите ID игрока, которому Вы хотите установить скин:\n\
					", "Принять", "Назад");
					return 1;
				}
			
				SetPVarInt(playerid, "MemberSkinID", strval(inputtext));
				
				new string[128];
				
				format(string, sizeof(string), ""COL_BLUE"Введите номер скина для игрока "COL_WHITE"[%d] %s\n", strval(inputtext), Name(strval(inputtext)));
				ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERSKIN, D_S_I, ""COL_ORANGE"Установить скин", string, "Принять", "Назад");
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	            ShowPlayerLeaderDialog(playerid);
	    }
		
	    case DIALOG_ID_SETMEMBERSKIN:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
	            new string[60 + 5 + MAX_PLAYER_NAME - 4];
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {
	                format(string, sizeof(string), ""COL_BLUE"Введите номер скина для игрока "COL_WHITE"[%d] %s\n",strval(inputtext),Name(strval(inputtext)));
					ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERSKIN, D_S_I,""COL_ORANGE"Установить скин", string, "Принять", "Назад");
	                return 1;
	            }
	            if (GetPVarInt(playerid, "MemberSkinID") == INVALID_PLAYER_ID || gPlayerLogged{GetPVarInt(playerid, "MemberSkinID")} == false) 
					return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
			
				if(PlayerInfo[GetPVarInt(playerid, "MemberSkinID")][pMember] != PlayerInfo[playerid][pMember]) 
					return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в Вашей организации.");
			
				PlayerInfo[GetPVarInt(playerid, "MemberSkinID")][pMemberSkin] = strval(inputtext);
				UpdateDataInt(PlayerInfo[GetPVarInt(playerid, "MemberSkinID")][pID], "accounts", "MemberSkin",
				PlayerInfo[GetPVarInt(playerid, "MemberSkinID")][pMemberSkin]);
				
				format(string, sizeof(string), "Вы установили игроку %s скин № %d.", Name(GetPVarInt(playerid, "MemberSkinID")), strval(inputtext));
				SendClientMessage(playerid, COLOR_GREEN, string);
				
				format(string, sizeof(string), "[%d] %s установил Вам организационный скин № %d.", playerid, Name(playerid), strval(inputtext));
				SendClientMessage(GetPVarInt(playerid, "MemberSkinID"), COLOR_GREEN, string);
	        }
	        else// Если игрок нажал Esc, вернём ему диалог
	            ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERSKINID, D_S_I, ""COL_ORANGE"Установить скин", "\
				"COL_BLUE"Введите ID игрока, которому Вы хотите установить скин:\n\
				", "Принять", "Назад");
	    }
		
	    case DIALOG_ID_RENTMOPED:
	    {
	        if(response)// Если игрок нажал первую кнопку
	        {
                if(PlayerInfo[playerid][pMoney] < CENA_ARENDI) 
					return SendClientMessage(playerid, COLOR_RED,"У Вас недостаточно денег.");
			
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
	        else	
				RentCar[playerid] = 0;
		}
		
		case DIALOG_ID_GETAPED:
		{
			if(response)
			{
				//if(PlayerInfo[playerid][pMoney] < CENA_APED) 
					//return SendClientMessage(playerid, COLOR_PROX,"Моника говорит: "COL_WHITE"Этих денег недостаточно.");
				
				//PlayerInfo[playerid][pMoney] = PlayerInfo[playerid][pMoney] - CENA_APED;
				PlayerInfo[playerid][pAPED] = 1;
				PlayerInfo[playerid][pAPEDBattery] = TENHOURS;
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "APED", PlayerInfo[playerid][pAPED]);
				
				
				GangZoneHideForPlayer(playerid, blackmap);
				GangZoneShowForPlayer(playerid, LSZone, 0x7FFF0055);
				GangZoneShowForPlayer(playerid, SFZone, 0x0000FF55);
				GangZoneShowForPlayer(playerid, LVZone, 0xFFFF0055);
				
				MapIsOn{playerid} = true;
				
				SendClientMessage(playerid, COLOR_PROX,"Моника говорит: "COL_WHITE"Теперь Вам будет комфортно жить в Angel Pine, поздравляю!");
				
				new string[MAX_PLAYER_NAME+1+46];
				
				format(string, sizeof(string), "%s передает деньги Монике и берет со стола APED.", Name(playerid));
				ProxDetector(playerid, COLOR_PROX, string, 5.0);
				
			}
			else 
				SendClientMessage(playerid, COLOR_PROX,"Моника говорит: "COL_WHITE"Приходите в любое время!");
		}
		
		case DIALOG_ID_SELLCAR:
		{
			if(response)	
				ShowPlayerDialog(playerid, DIALOG_ID_SELLCARPRICE, D_S_I,""COL_ORANGE"Продажа транспорта",
				""COL_WHITE"Введите сумму, которую хотите получить за продажу транспорта:\n\n", "Принять", "Отмена");
			else 
				ProxDetector(playerid, COLOR_PROX,"Алекс говорит: "COL_WHITE"Как надумаете продать свой транспорт - приходите!", 5.0);
		}
		
		case DIALOG_ID_SELLCARPRICE:
		{
			if(response)
			{
				if(!strlen(inputtext))
					return	ShowPlayerDialog(playerid, DIALOG_ID_SELLCARPRICE, D_S_I,""COL_ORANGE"Продажа транспорта",
					""COL_WHITE"Введите сумму, которую хотите получить за продажу транспорта:\n\n"
					,"Принять","Отмена");
				
				new string[170];
				
				format(string, sizeof(string), ""COL_WHITE"Вы получите "COL_GREEN"%d $"COL_WHITE".\nВаш транспорт будет продаваться за "COL_GREEN"%d $ \
				"COL_WHITE"с учетом налога на продажу.\nВы согласны на сделку?", strval(inputtext),
				floatround(strval(inputtext) * NALOG_BUYCAR / 100 + strval(inputtext), floatround_ceil));
				ShowPlayerDialog(playerid, DIALOG_ID_SELLCARSUCCESS, D_S_M,""COL_ORANGE"Продажа транспорта", string, "Да", "Нет");
				
				SetPVarInt(playerid, "PriceCar", strval(inputtext));
			}
			else 
				ProxDetector(playerid, COLOR_PROX,"Алекс говорит: "COL_WHITE"Как надумаете продать свой транспорт - приходите!", 5.0);
		}
		
		case DIALOG_ID_SELLCARSUCCESS:
		{			
			if(response)
			{
				new carid = PlayerInfo[playerid][pCarKey],
					string2[50],
					Float:x,Float:y,Float:z,Float:a;
				
				strmid(VehInfo[carid][vOwner], "Angel Pine", 0, 10, 11);
				VehInfo[carid][vPrice] = floatround(GetPVarInt(playerid, "PriceCar") * NALOG_BUYCAR / 100 + GetPVarInt(playerid, "PriceCar"), floatround_ceil);				
				VehInfo[carid][vBuy] = VBUYTOBUY;
				VehInfo[carid][vLock] = false;
				
				UpdateDataInt(carid, "vehicles", "Price", VehInfo[carid][vPrice]);
				UpdateDataInt(carid, "vehicles", "Buy", VehInfo[carid][vBuy]);
				UpdateDataInt(carid, "vehicles", "Lock", VehInfo[carid][vLock]);
				UpdateDataVarchar(carid, "vehicles", "Owner", VehInfo[carid][vOwner]);
				
				purse += floatround(GetPVarInt(playerid, "PriceCar") * NALOG_BUYCAR / 100, floatround_ceil);
				//SavePurse();
				
				PlayerInfo[playerid][pCarKey] = 0;
				PlayerInfo[playerid][pMoney] = PlayerInfo[playerid][pMoney] + GetPVarInt(playerid, "PriceCar");
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "CarKey", PlayerInfo[playerid][pCarKey]);
			
				format(string2, sizeof(string2), "Продается\nСтоимость: "COL_GREEN"%i $",VehInfo[carid][vPrice]);
				sellVehInfo[carid] = Create3DTextLabel(string2, COLOR_PROX, 0, 0, 0, 5.0, 0, 0);
				Attach3DTextLabelToVehicle(Text3D:sellVehInfo[carid], carid, 0.0, 0.0, 0.8);	

				GetVehiclePos(carid, x, y, z);	
				GetVehicleZAngle(carid, a);				
				
				VehInfo[carid][vVPosX] = x;// Устанавливаем позицию
				VehInfo[carid][vVPosY] = y;// Устанавливаем позицию
				VehInfo[carid][vVPosZ] = z;// Устанавливаем позицию
				VehInfo[carid][vVZa] = a;// Устанавливаем позицию
			
				GameTextForPlayer(playerid, FixText("~G~Транспорт продан"), 1500, 3);
			}
			else 
				ShowPlayerDialog(playerid, DIALOG_ID_SELLCARPRICE, D_S_I,""COL_ORANGE"Продажа транспорта",
				""COL_WHITE"Введите сумму, которую хотите получить за продажу транспорта:\n", "Принять", "Отмена");
		}
		
		case DIALOG_ID_CHANGECLOTHES: 
		{
			if(response)
			{
				new string[MAX_PLAYER_NAME+1+49];
				
				format(string, sizeof(string), "%s достает сменную одежду из шкафа и переодевается.", Name(playerid));
				ProxDetector(playerid, COLOR_PROX, string, 5.0);
				
				ShowFonForPlayer(playerid);
				
				IsPlayerBlackScreen{playerid} = true;

				GiveEndurance(playerid, -2);		

				ApplyAnimation(playerid, "WUZI", "Walkstart_Idle_01", 4.1, 0, 1, 1, 0, 1600, 1);				
				
				SetTimerEx("BlackScreenTimer", 500, 0, "i", playerid);
			}
		}
		
		case DIALOG_ID_PLAYERINFODIALOG:
		{	
			if(response)
			{
				for(new i; i <= 9; i++)
					TextDrawHideForPlayer(playerid, TDEditor_TD[i]);
				
				TextDrawHideForPlayer(playerid, TDAPEDPercent[playerid]);
				
				CancelSelectTextDraw(playerid); 
				CloseTextDrawAPED{playerid} = false;
				
				new string[MAX_PLAYER_NAME+1 -2 +42];
				
				format(string, sizeof(string), "%s поднимает взгляд с экрана и убирает APED.", Name(playerid));
				ProxDetector(playerid, COLOR_PROX, string, 3.0);
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
						if(!MapIsOn{playerid})
						{
							MapIsOn{playerid} = true;
							GangZoneHideForPlayer(playerid, blackmap);
							GangZoneShowForPlayer(playerid, LSZone, 0x7FFF0055);
							GangZoneShowForPlayer(playerid, SFZone, 0x0000FF55);
							GangZoneShowForPlayer(playerid, LVZone, 0xFFFF0055);
							
						}
						else
						{
							MapIsOn{playerid} = false;
							GangZoneShowForPlayer(playerid, blackmap, 255);	
							GangZoneHideForPlayer(playerid, LSZone);
							GangZoneHideForPlayer(playerid, SFZone);
							GangZoneHideForPlayer(playerid, LVZone);							
						}
						
						ShowPlayerAPEDSettingsDialog(playerid);
					}										
				}
			}
		}
		
		case DIALOG_ID_APPDWEAPON: 
		{
			if(response)
			{
				new string[MAX_PLAYER_NAME+1 -2 +39];
				
				format(string, sizeof(string), "%s забирает со стола амуницию, оружие и патроны.", Name(playerid));
				ProxDetector(playerid, COLOR_PROX, string, 3.0);
				
				GivePlayerWeapon(playerid, 24, 35);
				GivePlayerWeapon(playerid, 3, 1);
				SetPlayerArmour(playerid, 100.0);
			}
		}
		
		case DIALOG_ID_ADMINMENU: 
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: 
					{
						static const
							fmt_dlg[] = "%s"COL_WHITE"[ %d ] "COL_BLUE"%s\n";

						new dialog_string[(sizeof(fmt_dlg) + (-2+MAX_FRACTION_NAME_LENGTH))*MAX_FRACTIONS];

						for(new i = 1; i < MAX_FRACTIONS; i++)
							format(dialog_string, sizeof(dialog_string), fmt_dlg, dialog_string, i, fraction_name[i]);
						
						ShowPlayerDialog(playerid, DIALOG_ID_ADMINMENUTPLIST, D_S_L, ""COL_ORANGE"Телепорт по местам", dialog_string
						,"Принять", "Назад");
					}
				}					
			}
		}
		
		case DIALOG_ID_ADMINMENUTPLIST:
		{
			if(response)
			{
				new Float:TPList[7][3] =
				{
						{-2061.0405,-2538.1675,30.6250},
						{-2070.8337,-2312.8096,30.6250},
						{-2217.1873,-2297.8496,31.1628},
						{-2191.3755,-2336.2871,30.6010},
						{-2396.7039,-2205.0300,33.6179},
						{-1858.3770,-1647.6699,26.0955},
						{-2113.4824,-2453.0422,30.6250}
				};
					
				SetPlayerPos(playerid, TPList[listitem][0], TPList[listitem][1], TPList[listitem][2]);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);	
			}
			else 
				ShowPlayerAdminDialog(playerid);
			return 1;
		}
		
		case DIALOG_ID_BUYSELLHOUSE:
		{
			if(response)
			{
				if(PlayerInfo[playerid][pHouse] != INVALID_HOUSE_ID) 
					return ProxDetector(playerid, COLOR_PROX,
					"Марта говорит: "COL_WHITE"В нашей базе данных есть сведения, что у Вас уже есть дом. \
					Необходимо продать его, прежде чем покупать новый.", 5.0); 
				
				static const 	title[] = ""COL_WHITE"ID: \t"COL_WHITE"Стоимость: \n";
								
				new string[sizeof(title) + 15*MAX_HOUSES];				
				string = title;
				
				new count;
				
				foreach(new h : House)
				{
					if(HouseInfo[h][hAdd] != 1 || HouseInfo[h][hOwned] != 0) continue;
					format(string, sizeof(string),"%s%i\t"COL_GREEN"%i\n", string, h, HouseInfo[h][hPrice]);
					count ++;
				}
				
				new header[70];

				format(header, sizeof(header), ""COL_ORANGE"Покупка дома. Количество свободных домов: "COL_APED"%d", count);				
				ShowPlayerDialog(playerid, DIALOG_ID_BUYHOUSE, D_S_TH, header, string, "Купить", "Выход");
			}
			else
			{
				new houseid = PlayerInfo[playerid][pHouse];
				
				if(houseid == INVALID_HOUSE_ID) 
					return ProxDetector(playerid, COLOR_PROX,
					"Марта говорит: "COL_WHITE"В нашей базе данных нет сведений о Вашем доме.", 5.0);
				
				static D42[] = 
					""COL_WHITE"Ваш № дома: "COL_APED"%d.\n\
					"COL_WHITE"Его первоначальная стоимость: "COL_STATUS2"%d $\n\n\
					"COL_WHITE"Выставив дом на продажу Вы получите: "COL_GREEN"%d $\n\n\
					"COL_WHITE"Вы уверены, что хотите продать его?";
					
				new d42[sizeof(D42)-2-2-2+10*2];
			
				format(d42, sizeof(d42), D42, houseid, HouseInfo[houseid][hPrice], HouseInfo[houseid][hPrice] / 2);				
				ShowPlayerDialog(playerid, DIALOG_ID_SELLHOUSE, D_S_M, ""COL_ORANGE"Продажа дома", d42, "Да", "Нет");
				return 1;
			}
			return 1;
		}
		
		case DIALOG_ID_SELLHOUSE:
		{
			if(response)
			{				
				new houseid = PlayerInfo[playerid][pHouse];
				HouseInfo[houseid][hOwned] =
             	HouseInfo[houseid][hLock] = 0;
				strmid(HouseInfo[houseid][hOwner], "Angel Pine", 0, 10, 11);
				
				UpdateDataIntWithChoiseID(houseid, "houses", "Owned", "HouseID", HouseInfo[houseid][hOwned]);
				UpdateDataIntWithChoiseID(houseid, "houses", "Lock", "HouseID", HouseInfo[houseid][hLock]);
				UpdateDataVarcharWithChoiseID(houseid, "houses", "Owner", "HouseID", HouseInfo[houseid][hOwner]);
				
				purse -= HouseInfo[houseid][hPrice]/2;
				//SavePurse();
				
             	PlayerInfo[playerid][pMoney] += HouseInfo[houseid][hPrice]/2;
				PlayerInfo[playerid][pHouse] = INVALID_HOUSE_ID;
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "House", PlayerInfo[playerid][pHouse]);
				
				GameTextForPlayer(playerid, FixText("~G~Дом продан"), 1500, 3);
			}
			else 
				return ProxDetector(playerid, COLOR_PROX, "Марта говорит: "COL_WHITE"Приходите как надумаете продать свой дом.", 5.0);
			
			return 1;
		}
		
		case DIALOG_ID_BUYHOUSE:
		{
			if(response)
			{
				if(PlayerInfo[playerid][pMoney] < HouseInfo[strval(inputtext)][hPrice])
				{
					static const 	title[] = ""COL_WHITE"ID: \t"COL_WHITE"Стоимость: \n";
								
					new string[sizeof(title) + 15*MAX_HOUSES];					
					string = title;
					
					new count;
				
					foreach(new h : House)
					{
						if(HouseInfo[h][hAdd] != 1 || HouseInfo[h][hOwned] != 0) continue;
						format(string, sizeof(string),"%s%i\t"COL_GREEN"%i\n", string, h, HouseInfo[h][hPrice]);
						count ++;
					}
				
					new header[70];

					format(header, sizeof(header), ""COL_ORANGE"Покупка дома. Количество свободных домов: "COL_APED"%d", count);					
					ShowPlayerDialog(playerid, DIALOG_ID_BUYHOUSE, D_S_TH, header, string, "Купить", "Выход");
					
					ProxDetector(playerid, COLOR_PROX, "Марта говорит: "COL_WHITE"У Вас недостаточно денег для покупки этого дома!", 5.0);
					return 1;
				}
				
				static D41[] = 
					""COL_WHITE"Вы выбрали дом № "COL_APED"%d.\n\
					"COL_WHITE"Стоимость дома - "COL_GREEN"%d $\n\
					"COL_WHITE"Хотите купить его и зарегистрировать на себя?";
					
				new d41[sizeof(D41)-2-2+10];
			
				format(d41, sizeof(d41), D41, strval(inputtext), HouseInfo[strval(inputtext)][hPrice]);				
				ShowPlayerDialog(playerid, DIALOG_ID_BUYHOUSEACCEPT, D_S_M, ""COL_ORANGE"Покупка дома", d41, "Да", "Нет");
				
				SetPVarInt(playerid, "BuyHouseID", strval(inputtext));
			}
			else 
				return ProxDetector(playerid, COLOR_PROX, 
				"Марта говорит: "COL_WHITE"У нас дома раскупают как горячие пирожки, так что не медлите с покупкой!", 5.0);
			return 1;
		}
		
		case DIALOG_ID_BUYHOUSEACCEPT:
		{
			if(response)
			{
				new houseid = GetPVarInt(playerid, "BuyHouseID");
				
             	HouseInfo[houseid][hOwned] =
             	HouseInfo[houseid][hLock] = 1;
				strmid(HouseInfo[houseid][hOwner], Name(playerid), 0, strlen(Name(playerid)), MAX_PLAYER_NAME);
				
				UpdateDataIntWithChoiseID(houseid, "houses", "Owned", "HouseID", HouseInfo[houseid][hOwned]);
				UpdateDataIntWithChoiseID(houseid, "houses", "Lock", "HouseID", HouseInfo[houseid][hLock]);
				UpdateDataVarcharWithChoiseID(houseid, "houses", "Owner", "HouseID", HouseInfo[houseid][hOwner]);
				
				purse += HouseInfo[houseid][hPrice];
				//SavePurse();
				
             	PlayerInfo[playerid][pMoney] -= HouseInfo[houseid][hPrice];
				PlayerInfo[playerid][pHouse] = houseid;
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "House", PlayerInfo[playerid][pHouse]);
				             	
             	GameTextForPlayer(playerid, FixText("~G~Поздравляем с покупкой"), 1500, 3);
				
				DeletePVar(playerid, "BuyHouseID");
			}
			else
			{
				DeletePVar(playerid, "BuyHouseID");
				
				static const 	title[] = ""COL_WHITE"ID: \t"COL_WHITE"Стоимость: \n";
								
				new string[sizeof(title) + 15*MAX_HOUSES];					
				string = title;
				
				new count;
				
				foreach(new h : House)
				{
					if(HouseInfo[h][hAdd] != 1 || HouseInfo[h][hOwned] != 0) continue;
					format(string, sizeof(string),"%s%i\t"COL_GREEN"%i\n", string, h, HouseInfo[h][hPrice]);
					count ++;
				}
				
				new header[70];
				
				format(header, sizeof(header), ""COL_ORANGE"Покупка дома. Количество свободных домов: "COL_APED"%d", count);
				ShowPlayerDialog(playerid, DIALOG_ID_BUYHOUSE, D_S_TH, header, string, "Купить", "Выход");
			}
			return 1;
		}
		
		case DIALOG_ID_HOUSESETTINGS:
		{
			if(response)
			{
				new houseid = GetPVarInt(playerid, "IDHouseForClose");
				
             	HouseInfo[houseid][hLock] = (!HouseInfo[houseid][hLock]) ? 1 : 0;
				UpdateDataIntWithChoiseID(houseid, "houses", "Lock", "HouseID", HouseInfo[houseid][hLock]);
				
             	GameTextForPlayer(playerid, (HouseInfo[houseid][hLock] == 1) ? 
				FixText("~R~Дверь закрыта") : FixText("~G~Дверь открыта"), 1500, 3);
				return 1;
			}
		}
		
		case DIALOG_ID_HOUSEKNOCK:
		{
			if(response)
			{
				new houseid = GetPVarInt(playerid, "HouseKnockID"),
					string[MAX_PLAYER_NAME+18-2];
		
				format(string, sizeof(string),"%s стучит в дверь.",Name(playerid));
				ProxDetector(playerid,COLOR_PROX, string, 10.0);
				
             	GameTextForPlayer(playerid, FixText("~G~]Стук в дверь]"), 1500, 3);
				
				foreach(Player, i)
				{
					if(IsPlayerInRangeOfPoint(i, 20.0, HouseInfo[houseid][hExitX], HouseInfo[houseid][hExitY], HouseInfo[houseid][hExitZ]) &&
					GetPlayerVirtualWorld(i) == HouseInfo[houseid][hVirt])
					{
						SendClientMessage(i, COLOR_PROX, "Кто-то постучал в дверь.");
						GameTextForPlayer(i, FixText("~G~]Стук в дверь]"), 1500, 3);
					}
				}
				return 1;
			}
		}
		
		case DIALOG_ID_HOUSEFUNCTION:
		{	
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						ShowFonForPlayer(playerid);
						SetPVarInt(playerid,"SleepTimer", SetTimerEx("SleepTimer", 1000, false, "i", playerid));
						SetPVarInt(playerid,"Sleep", 1);
						ApplyAnimation(playerid, "SUNBATHE", "batherdown", 4.1, 0, 1, 1, 1, 1, 1);
					}
					case 1:
					{
						
					}	
					case 2:
					{
						if(PlayerInfo[playerid][pAPED] == 2) 
							return SendClientMessage(playerid, COLOR_GREY, "Ваш APED уже на зарядке.");
						
						if(PlayerInfo[playerid][pAPED] != 1) 
							return SendClientMessage(playerid, COLOR_GREY, "У Вас нет APED.");
						
						new Float:x, Float:y, Float:z;
	
						GetPlayerPos(playerid, x, y, z);
						
						new id = Iter_Free(APED);
						if(id == ITER_NONE) 
						{
							SendClientMessage(playerid, -1, "Лимит APED исчерпан.");
							return 1;
						}
						
						APEDInfo[id][aPlayerID] = PlayerInfo[playerid][pID];
						APEDInfo[id][aPosX] = x;
						APEDInfo[id][aPosY] = y;
						APEDInfo[id][aPosZ] = z;
						APEDInfo[id][aVW] = GetPlayerVirtualWorld(playerid);
						APEDInfo[id][aBattery] = PlayerInfo[playerid][pAPEDBattery];
						
						static 
							string[140+4+10+10+10+3];

						string[0] = '\0';
						format(string, sizeof(string), 
							"\
							INSERT INTO `aped`  (`APEDID`, `PlayerID`, `PosX`, `PosY`, `PosZ`, `VirtualWorld`, `Battery`)\
							VALUES ('%d', '%d', '%f', '%f', '%f', '%d', '%d')", 
								id,
								APEDInfo[id][aPlayerID],
								APEDInfo[id][aPosX],
								APEDInfo[id][aPosY],
								APEDInfo[id][aPosZ],
								APEDInfo[id][aVW],
								APEDInfo[id][aBattery]);
								
						mysql_tquery(mysql_connect_ID, string);
		
						format(string, sizeof(string),"%s ставит свой APED на зарядку.", Name(playerid));
						ProxDetector(playerid,COLOR_PROX, string, 5.0);
						
						SendClientMessage(playerid, COLOR_ORANGE, "INFO: Чтобы снять APED с зарядки нажмите ~k~~CONVERSATION_YES~.");
						
						apedpickup[id] = CreatePickup(1575, 23, APEDInfo[id][aPosX], APEDInfo[id][aPosY], APEDInfo[id][aPosZ], APEDInfo[id][aVW]);
						
						new str[48+3], 
						battery = floatround(APEDInfo[id][aBattery] * 100 / TENHOURS, floatround_ceil);		
						
						format(str, sizeof(str), "APED заряжается\nЗаряд батереи: "COL_GREEN"%d %%", battery);
						
						aped[id] = Create3DTextLabel(str, COLOR_WHITE, APEDInfo[id][aPosX], APEDInfo[id][aPosY],
						APEDInfo[id][aPosZ], 1.0, APEDInfo[id][aVW], 0);
						
						PlayerInfo[playerid][pAPED] = 2;
						UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "APED", PlayerInfo[playerid][pAPED]);
						
						Iter_Add(APED, id);
						
					}
				}
			}
		}
		
		case DIALOG_ID_TAKEAPED:
		{
			if(response)
			{
				new string[MAX_PLAYER_NAME+44-2];
		
				format(string, sizeof(string),"%s отключает APED от зарядки и забирает его.", Name(playerid));
				ProxDetector(playerid,COLOR_PROX, string, 5.0);
				
				PlayerInfo[playerid][pAPED] = 1;
				PlayerInfo[playerid][pAPEDBattery] = APEDInfo[GetPVarInt(playerid, "IDAPED")][aBattery];
				
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "APED", PlayerInfo[playerid][pAPED]);
				
				Delete3DTextLabel(Text3D:aped[GetPVarInt(playerid, "IDAPED")]);
				DestroyPickup(apedpickup[GetPVarInt(playerid, "IDAPED")]);
				
				static
					query_string[37+64+11+10+1];
				mysql_format(mysql_connect_ID, query_string, sizeof(query_string), "DELETE FROM aped WHERE APEDID = '%d'", GetPVarInt(playerid, "IDAPED"));
				mysql_tquery(mysql_connect_ID, query_string);
				
				Iter_Remove(APED, GetPVarInt(playerid, "IDAPED"));
				return 1;
			}
		}
		
		case DIALOG_ID_SHOPFOOD:
		{
			if(response)
			{
				if(PlayerInfo[playerid][pMoney] < ShopFoodInfo[listitem][FoodPrice]) 
					return SendClientMessage(playerid, COLOR_GREY, "У Вас недостаточно денег.");
						
				PlayerInfo[playerid][pMoney] -= ShopFoodInfo[listitem][FoodPrice];
				
				new    string[MAX_PLAYER_NAME+25+40+27];

				strcat(string, Name(playerid));
				strcat(string, " выбирает в меню позицию \"");
				strcat(string, ShopFoodInfo[listitem][FoodName]);
				strcat(string, "\" и передает деньги кассиру.");
				
				ProxDetector(playerid,COLOR_PROX, string, 5.0);
				
				switch(listitem)
				{
					case 0..4: 	GiveHunger(playerid, ShopFoodInfo[listitem][FoodHunger]), 
								ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 1, 1, 1, 1, 1),
								SetTimerEx("@_ClearAnim", 4000, false, "d", playerid);
								
					case 5: 	GiveHunger(playerid, ShopFoodInfo[listitem][FoodHunger]),
								SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
								
					case 6: 	GiveEndurance(playerid, ShopFoodInfo[listitem][FoodHunger]),
								ApplyAnimation(playerid, "VENDING", "VEND_Drink2_P", 4.0, 1, 1, 1, 1, 1),
								SetTimerEx("@_ClearAnim", 1900, false, "d", playerid);
								
				}
			}
		}

		case DIALOG_ID_GYMBUY:
		{
			if(response)
			{
				if(PlayerInfo[playerid][pMoney] < GymInfo[listitem][GymActionPrice]) 
					return SendClientMessage(playerid, COLOR_GREY, "У Вас недостаточно денег.");
				
				switch(listitem)
				{								
					case 0: 	
					{
						PlayerInfo[playerid][pMoney] -= GymInfo[0][GymActionPrice];
				
						new string[MAX_PLAYER_NAME+36+MAX_NAME_GUM_ACTION+36];

						strcat(string, Name(playerid));
						strcat(string, " приобретает разовый абонемент на \"");
						strcat(string, GymInfo[0][GymAction]);
						strcat(string, "\" и передает деньги администратору.");
						
						ProxDetector(playerid,COLOR_PROX, string, 5.0);
						
						SendClientMessage(playerid, COLOR_WHITE, 
						"Переоденьтесь в раздевалке, а затем вставайте на беговую дорожку и нажмите ~k~~VEHICLE_ENTER_EXIT~.");
						
						SetPVarInt(playerid, "ChooseGymAction", 1);	
						
						if(gymTimer[playerid])
							KillTimer(gymTimer[playerid]);
						
						gymTimer[playerid] = SetTimerEx("GymTimer", 1000*60*30, false, "i", playerid);
						
					}								
					case 1: ShowPlayerFightStyleDialog(playerid);											
				}
			}
		}

		case DIALOG_ID_GYMBUYFS:
		{
			if(response)
			{
					PlayerInfo[playerid][pMoney] -= GymInfo[1][GymActionPrice];
				
					new string[MAX_PLAYER_NAME+36+MAX_NAME_GUM_ACTION+36];

					strcat(string, Name(playerid));
					strcat(string, " приобретает разовый абонемент на \"");
					strcat(string, GymInfo[1][GymAction]);
					strcat(string, "\" и передает деньги администратору.");
						
					ProxDetector(playerid, COLOR_PROX, string, 5.0);
					
					format(string, sizeof(string), "Выбранный стиль боя для изучения - %s. Переоденьтесь в раздевалке и выходите на ринг (встаньте на чекпоинт).",
					fighting_style[listitem][fsName]);
					SendClientMessage(playerid, COLOR_WHITE, string);

					SetPVarInt(playerid, "ChooseGymAction", listitem+2);		

					if(gymTimer[playerid])
							KillTimer(gymTimer[playerid]);
						
					gymTimer[playerid] = SetTimerEx("GymTimer", 1000*60*30, false, "i", playerid);				
			}
			else 
				return ShowPlayerGymDialog(playerid);
		}
		
		case DIALOG_ID_MISSION1:
		{
			if(response)
			{
				if(mission1photo[playerid])
					PlayerTextDrawDestroy(playerid, mission1photo[playerid]);
				
				mission1photo[playerid] = CreatePlayerTextDraw(playerid, 350.0, 20.0, "_");
				PlayerTextDrawFont(playerid, mission1photo[playerid], TEXT_DRAW_FONT_MODEL_PREVIEW);
				PlayerTextDrawUseBox(playerid, mission1photo[playerid], 1);
				PlayerTextDrawBoxColor(playerid, mission1photo[playerid], 0x000000FF);
				PlayerTextDrawTextSize(playerid, mission1photo[playerid], 140.0, 140.0);
				PlayerTextDrawSetPreviewModel(playerid, mission1photo[playerid], 43);
				PlayerTextDrawShow(playerid, mission1photo[playerid]);
				
				SetPlayerMapIcon(playerid, 0, -2804.9104, -2440.9480, 3.4075, 58, 0, MAPICON_GLOBAL);
				SetPlayerMapIcon(playerid, 1, -2004.2189, -2821.4851, 4.2078, 53, 0, MAPICON_GLOBAL);
				
				SetTimer("Mission1Photo", 10000, false);	

				playeridmission1 = playerid;
				
				if(!FCNPC_IsSpawned(mission1NPC))
					FCNPC_Spawn(mission1NPC, 43, -2805.1089, -2427.4063, 3.8156);
				else
				{
					FCNPC_SetPosition(mission1NPC, -2805.1089, -2427.4063, 3.8156);
					FCNPC_Respawn(mission1NPC);
				}				

				static D46[] = 
					"\t"COL_WHITE"Отлично! Найди его и приведи в указанную точку.\t\n\
					\tЭто дом на краю пляжа. Я отметил на твоей карте.\t\n\
					\tТакже отправил тебе фото этого смельчака, чтобы было легче его найти.\t\n\
					\tКоординаты мест, где он может находиться, можешь найти там же - на карте.\t\n\
					\tОбычно он отдыхает на пляже неподалеку от бара. Все понял?\t\n";

				ShowPlayerDialog(playerid, DIALOG_ID_NONE, D_S_M,""COL_ORANGE"Мужчина у барной стойки", D46, "Понял", "");			
			}
			else 
				return ProxDetector(playerid, COLOR_PROX, "Мужчина тихим голосом: "COL_WHITE"Ну как хочешь.", 2.0), playeridmission1 = INVALID_PLAYER_ID;
		}
		
		
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid) 
{
	if(checkpointid == GymCheckpoint[playerid])
	{
		if(PlayerInfo[playerid][pEndurance] < TWOHOURS) 
			return SendClientMessage(playerid, COLOR_GREY, "Вы устали и не можете заниматься.");
		
		if(!FCNPC_IsDead(NPCGym))
			return SendClientMessage(playerid, COLOR_GREY, "Подождите пока закончится бой.");
		
		SetPlayerPos(playerid, 763.0496,-2.0470,1001.5942);
		SetPlayerFacingAngle(playerid, 44.3001);
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid, 0);
		PlayerInfo[playerid][pHP] = 100;
		
		FCNPC_Spawn(NPCGym, 25017, 758.6925,2.3802,1001.5942);	
		
		if(FCNPC_IsDead(NPCGym))
		{
			FCNPC_Respawn(NPCGym);
			FCNPC_SetPosition(NPCGym, 758.6925,2.3802,1001.5942);
		}		
		SetPlayerFightingStyle(playerid, fighting_style[GetPVarInt(playerid, "ChooseGymAction")-2][fsID]);				
		FCNPC_SetAngle(NPCGym, 223.2010);
		FCNPC_SetVirtualWorld(NPCGym, 0);
		FCNPC_SetHealth(NPCGym, 100.0);
		FCNPC_SetSkin(NPCGym, GetPVarInt(playerid, "ChooseGymAction") == 7 ? 25008 : 25001);
		FCNPC_Stop(NPCGym);
		FCNPC_StopAttack(NPCGym);		
		
		GameTextForPlayer(playerid, FixText("~W~3 секунды до боя"), 3000, 3);
		
		new string[11];
		
		format(string, sizeof(string), FixText("Побед: %d/3"), GetPVarInt(playerid, "NumberOfWins"));
		GameTextForPlayer(playerid, string, 3000, 5);
		SendClientMessage(playerid, COLOR_ORANGE, "INFO: Для изучения стиля боя необходимо победить 3 раза. После 2 поражений бой заканчивается.");
		
		SetTimerEx("PlayerFightNPC", 3000, false, "d", playerid);
		
		DestroyDynamicCP(GymCheckpoint[playerid]);
	}	
	return 1;
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid) 
{
   return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(GetPlayerInterior(playerid) != 0) return 1;
	
	if(areaid == LSArea || areaid == SFArea || areaid == LVArea)
	{	
		ColorInZone[playerid] = CreatePlayerTextDraw(playerid, -12.0000, -10.3555, "Box"); // пусто 
		PlayerTextDrawLetterSize(playerid, ColorInZone[playerid], 0.0000, 53.6333); 
		PlayerTextDrawTextSize(playerid, ColorInZone[playerid], 680.0000, 0.0000); 
		PlayerTextDrawUseBox(playerid, ColorInZone[playerid], 1);  
		
		if(areaid == LSArea)
		{
			PlayerTextDrawBoxColor(playerid, ColorInZone[playerid], 0x7FFF0022);		
			SetPlayerWeather(playerid, 9);
		}
		
		if(areaid == SFArea)
		{
			PlayerTextDrawBoxColor(playerid, ColorInZone[playerid], 0x0000FF11);
			SetPlayerWeather(playerid, 8);	
		}
		
		if(areaid == LVArea)
		{
			PlayerTextDrawBoxColor(playerid, ColorInZone[playerid], 0xFFFF0022);
			SetPlayerWeather(playerid, 19);
		}
		
		PlayerTextDrawShow(playerid, ColorInZone[playerid]);
	}
	
	for(new z = 0; z < MAX_ROBOTS_POSITION; z++)
	{
		if(areaid == RobotsArea[z])
			Iter_Add(PlayersInZone[z], playerid); 
	}
	
    return 1;
}
 
public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(areaid == LSArea || areaid == SFArea || areaid == LVArea)
	{
		PlayerTextDrawDestroy(playerid, ColorInZone[playerid]); 
		SetPlayerWeather(playerid, 1);
	}
	
	for(new z = 0; z < MAX_ROBOTS_POSITION; z++)
	{
		if(areaid == RobotsArea[z])
		{
			if(!Iter_Contains(PlayersInZone[z], playerid)) continue;
			Iter_Remove(PlayersInZone[z], playerid); 
		}
	}
    return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(PlayerInfo[playerid][pAdmin] == 0) return 1;
	
	new Float:x, Float:y, Float:z;
    GetPlayerPos(clickedplayerid, x, y, z);
	
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
 	{
 		SetVehiclePos(GetPlayerVehicleID(playerid), x+1, y+1, z);
		SetPlayerInterior(playerid, GetPlayerInterior(clickedplayerid));
 		PutPlayerInVehicle(playerid, GetPlayerVehicleID(playerid), 0);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(clickedplayerid));
 	}
	SetPlayerPos(playerid, x + 0.5, y + 0.5, z + 0.5);
	SetPlayerInterior(playerid, GetPlayerInterior(clickedplayerid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(clickedplayerid));
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(PlayerInfo[playerid][pReg] == 1)
	{
		if(clickedid == Text:INVALID_TEXT_DRAW)
		{
			for(new i; i <= 2; i++)
				TextDrawShowForPlayer(playerid, skin[i]); 
		
			SelectTextDraw(playerid, 0x2641FEAA);
		}
		if(clickedid == skin[0])//left 
		{ 
			--cskin{playerid}; 
			if(PlayerInfo[playerid][pSex] == 1)
			{ 
				if(cskin{playerid} < 0) cskin{playerid} = 3;
				SetPlayerSkin(playerid, ManSkinList[cskin{playerid}]);					
			} 
			else if(PlayerInfo[playerid][pSex] == 2)
			{ 
				if(cskin{playerid} < 0) cskin{playerid} = 3;
				SetPlayerSkin(playerid, WomanSkinList[cskin{playerid}]); 
			} 
		} 
		else if(clickedid == skin[1])//right 
		{ 
			cskin{playerid}++;  
			if(PlayerInfo[playerid][pSex] == 1)
			{ 
				if(cskin{playerid} > 3)  cskin{playerid} = 0;
				SetPlayerSkin(playerid, ManSkinList[cskin{playerid}]); 
			} 
			else if(PlayerInfo[playerid][pSex] == 2)
			{ 
				if(cskin{playerid} > 3) cskin{playerid} = 0;
				SetPlayerSkin(playerid, WomanSkinList[cskin{playerid}]);				
			} 
		} 
		else if(clickedid == skin[2])//select 
		{ 
			for(new i; i <= 2; i++)
				TextDrawHideForPlayer(playerid, skin[i]);
			
			CancelSelectTextDraw(playerid); 
			
			PlayerInfo[playerid][pSkin] = GetPlayerCustomSkin(playerid);
			PlayerInfo[playerid][pReg] = 2;
			UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "Skin", PlayerInfo[playerid][pSkin]);
			UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "Reg", PlayerInfo[playerid][pReg]);
			
			gPlayerLogged{playerid} = true;
			
			ShowFonForPlayer(playerid);
			SetTimerEx("HideFonAfterReg", 1300, false, "d", playerid);
		}  
	}
	
	if((clickedid == Text:INVALID_TEXT_DRAW || clickedid == TDEditor_TD[2]) && CloseTextDrawAPED{playerid})
	{
		for(new i; i <= 9; i++)
			TextDrawHideForPlayer(playerid, TDEditor_TD[i]);
		
		TextDrawHideForPlayer(playerid, TDAPEDPercent[playerid]);
		
		CancelSelectTextDraw(playerid); 
		CloseTextDrawAPED{playerid} = false;
		
		new string[MAX_PLAYER_NAME+1 -2 +42];
				
		format(string, sizeof(string), "%s поднимает взгляд с экрана и убирает APED.", Name(playerid));
		ProxDetector(playerid, COLOR_PROX, string, 3.0);
	}
	
	if(clickedid == TDEditor_TD[9] && CloseTextDrawAPED{playerid})
		ShowPlayerAdminDialog(playerid);		
	
	if(clickedid == TDEditor_TD[5] && CloseTextDrawAPED{playerid})
	{
		
	}
	
	if(clickedid == TDEditor_TD[6] && CloseTextDrawAPED{playerid})	
		ShowPlayerPlayerInfoDialog(playerid);		
	
	if(clickedid == TDEditor_TD[7] && CloseTextDrawAPED{playerid})
	{
		if(PlayerInfo[playerid][pMember] == 0)
			return SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в организации.");
		
		if(PlayerInfo[playerid][pLeader] != 0)
			ShowPlayerLeaderDialog(playerid);	
		else
			SendClientMessage(playerid, COLOR_GREY, "Меню члена организации.");
	}
	
	if(clickedid == TDEditor_TD[8] && CloseTextDrawAPED{playerid})
		ShowPlayerAPEDSettingsDialog(playerid);		
	
    if (PlayerChoosePaintColor{playerid} && (clickedid == ChangeColor[1] || clickedid == Text:INVALID_TEXT_DRAW))
    {
		if(GetPVarInt(playerid, "ChooseColor1") != 0)
			DeletePVar(playerid, "ChooseColor1");
		
		PlayerChoosePaintColor{playerid} = false;
		
		CancelSelectTextDraw(playerid);
		
		for(new i; i < sizeof(ChangeColor); i++)
			TextDrawHideForPlayer(playerid,ChangeColor[i]);
	}
	
	for(new i = 2; i < sizeof(ChangeColor); i++)
    {
		if(clickedid == ChangeColor[i] && PlayerChoosePaintColor{playerid})
		{					
			if(GetPVarInt(playerid, "ChooseColor1") != 0)
			{
				GivePlayerWeapon(playerid, 41, 1000);
										
				SetPVarInt(playerid, "ChooseColor2", i);
										
				CancelSelectTextDraw(playerid);
				
				PlayerChoosePaintColor{playerid} = false;
									
				for(new j; j < sizeof(ChangeColor); j++)
					TextDrawHideForPlayer(playerid,ChangeColor[j]);
			}
			else
			{
				SetPVarInt(playerid, "ChooseColor1", i);
				GameTextForPlayer(playerid, FixText("~G~Выберите 2 цвет"), 1500, 3);
			}
		}
	}
	
	if(clickedid == Text:INVALID_TEXT_DRAW && IsInventoryOpen{playerid})
		HideInventory(playerid);
	
	if(IsInventoryOpen{playerid})
	{
		static double_click_timer[MAX_PLAYERS];	
		
		if(GetTickCount() - double_click_timer[playerid] < 400) 
		{	
			for(new i; i < MAX_WEAPON_SLOTS; i++)
			{
				if(clickedid == PlayerInventory[playerid][5+i] && InventoryInfo[playerid][iSlotWeapon][i] != EMPTY_SLOT_OBJECT
				&& InventoryInfo[playerid][iSlotPrimaryWeapon] == EMPTY_SLOT_OBJECT)
				{
					swap(InventoryInfo[playerid][iSlotPrimaryWeapon], InventoryInfo[playerid][iSlotWeapon][i]);
							
					TextDrawSetPreviewModel(PlayerInventory[playerid][4], InventoryInfo[playerid][iSlotPrimaryWeapon]);
					TextDrawShowForPlayer(playerid, PlayerInventory[playerid][4]);	
						
					TextDrawSetPreviewModel(PlayerInventory[playerid][5+i], InventoryInfo[playerid][iSlotWeapon][i]);
					TextDrawShowForPlayer(playerid, PlayerInventory[playerid][5+i]);
					
					idItem[playerid] = EMPTY_SLOT_OBJECT;
					slotType[playerid] = Nothing;	
					idSlot{playerid} = EMPTY_ID_SLOT_OBJECT;
					return 1;
				}
			}	
		}

		double_click_timer[playerid] = GetTickCount();		
		
		if(clickedid == PlayerInventory[playerid][4] && InventoryInfo[playerid][iSlotPrimaryWeapon] != EMPTY_SLOT_OBJECT)
		{
			SendClientMessage(playerid, COLOR_WHITE, "Нажал на слот осн. оружия.");	
			
			idItem[playerid] = InventoryInfo[playerid][iSlotPrimaryWeapon];
			slotType[playerid] = TypePrimaryWeapon;
			return 1;
		}
		
		if(clickedid == PlayerInventory[playerid][1] && InventoryInfo[playerid][iSlotSecondaryWeapon] != EMPTY_SLOT_OBJECT
		&& idSlot{playerid} == EMPTY_ID_SLOT_OBJECT)
		{
			SendClientMessage(playerid, COLOR_WHITE, "Нажал на слот втор. оружия.");			
			idItem[playerid] = InventoryInfo[playerid][iSlotSecondaryWeapon];
			slotType[playerid] = TypeSecondaryWeapon;
			return 1;
		}
		
		if(clickedid == PlayerInventory[playerid][2] && InventoryInfo[playerid][iSlotBackpack] != EMPTY_SLOT_OBJECT && idSlot{playerid} == EMPTY_ID_SLOT_OBJECT)
		{
			SendClientMessage(playerid, COLOR_WHITE, "Нажал на слот рюкзак.");			
			idItem[playerid] = InventoryInfo[playerid][iSlotBackpack];
			slotType[playerid] = TypeBackpack;
			return 1;
		}
		
		if(clickedid == PlayerInventory[playerid][3] && InventoryInfo[playerid][iSlotArmor] != EMPTY_SLOT_OBJECT && idSlot{playerid} == EMPTY_ID_SLOT_OBJECT)
		{
			SendClientMessage(playerid, COLOR_WHITE, "Нажал на слот армор.");			
			idItem[playerid] = InventoryInfo[playerid][iSlotArmor];
			slotType[playerid] = TypeArmor;
			return 1;
		}
		
		for(new i; i < MAX_WEAPON_SLOTS; i++)
		{
			if(clickedid == PlayerInventory[playerid][5+i] && InventoryInfo[playerid][iSlotWeapon][i] != EMPTY_SLOT_OBJECT)
			{
				SendClientMessage(playerid, COLOR_WHITE, "Нажал на слот оружия.");			
				idItem[playerid] = InventoryInfo[playerid][iSlotWeapon][i];
				slotType[playerid] = TypeWeapon;
				idSlot{playerid} = i;
				return 1;
			}
		}
		
		for(new i; i < MAX_MAIN_SLOTS; i++)
		{
			if(clickedid == PlayerInventory[playerid][7+i] && idItem[playerid] == EMPTY_SLOT_OBJECT && InventoryInfo[playerid][iSlot][i] != EMPTY_SLOT_OBJECT)
			{
				SendClientMessage(playerid, COLOR_WHITE, "Нажал на слот.");			
				idItem[playerid] = InventoryInfo[playerid][iSlot][i];
				slotType[playerid] = TypeSlot;
				idSlot{playerid} = i;
				mainSlotType[playerid][i] = GetTypeSlotFromModel(idItem[playerid]);
				return 1;
			}
		}
	
		if(idItem[playerid] != EMPTY_SLOT_OBJECT)
		{
			if(slotType[playerid] == TypeSlot)
			{
				for(new i= 1; i < 4; i++)
				{
					if(clickedid == PlayerInventory[playerid][i] && GetTypeSlotFromModel(InventoryInfo[playerid][iSlot][idSlot{playerid}]) == i)
					{
						if(i == 1)
						{
							swap(InventoryInfo[playerid][iSlotSecondaryWeapon], InventoryInfo[playerid][iSlot][idSlot{playerid}]);
							
							TextDrawSetPreviewModel(PlayerInventory[playerid][1], InventoryInfo[playerid][iSlotSecondaryWeapon]);
							TextDrawShowForPlayer(playerid, PlayerInventory[playerid][1]);						
						}
						if(i == 2)
						{
							swap(InventoryInfo[playerid][iSlotBackpack], InventoryInfo[playerid][iSlot][idSlot{playerid}]);
							
							TextDrawSetPreviewModel(PlayerInventory[playerid][2], InventoryInfo[playerid][iSlotBackpack]);
							TextDrawShowForPlayer(playerid, PlayerInventory[playerid][2]);	
						}
						if(i == 3)
						{
							swap(InventoryInfo[playerid][iSlotArmor], InventoryInfo[playerid][iSlot][idSlot{playerid}]);
							
							TextDrawSetPreviewModel(PlayerInventory[playerid][3], InventoryInfo[playerid][iSlotArmor]);
							TextDrawShowForPlayer(playerid, PlayerInventory[playerid][3]);	
						}
						TextDrawShowForPlayer(playerid, PlayerInventory[playerid][i]);
						TextDrawSetPreviewModel(PlayerInventory[playerid][7+idSlot{playerid}], InventoryInfo[playerid][iSlot][idSlot{playerid}]);
						TextDrawShowForPlayer(playerid, PlayerInventory[playerid][7+idSlot{playerid}]);	
						
						idItem[playerid] = EMPTY_SLOT_OBJECT;
						slotType[playerid] = Nothing;	
						idSlot{playerid} = EMPTY_ID_SLOT_OBJECT;
					}					
				}
				for(new i; i < MAX_MAIN_SLOTS; i++)
				{
					if(clickedid == PlayerInventory[playerid][7+i])
					{
						SendClientMessage(playerid, COLOR_WHITE, "Нажал на слот.");
							
						swap(InventoryInfo[playerid][iSlot][i], InventoryInfo[playerid][iSlot][idSlot{playerid}]);
							
						TextDrawSetPreviewModel(PlayerInventory[playerid][7+idSlot{playerid}], InventoryInfo[playerid][iSlot][idSlot{playerid}]);
						TextDrawShowForPlayer(playerid, PlayerInventory[playerid][7+idSlot{playerid}]);	
					
						TextDrawSetPreviewModel(PlayerInventory[playerid][7+i], InventoryInfo[playerid][iSlot][i]);					
						TextDrawShowForPlayer(playerid, PlayerInventory[playerid][7+i]);
						
						idItem[playerid] = EMPTY_SLOT_OBJECT;
						slotType[playerid] = Nothing;	
						idSlot{playerid} = EMPTY_ID_SLOT_OBJECT;
					}
				}
				
			}
			
			if(slotType[playerid] == TypeWeapon)
			{
				if(clickedid == PlayerInventory[playerid][4] || clickedid == PlayerInventory[playerid][5] || clickedid == PlayerInventory[playerid][6])
				{
					if(clickedid == PlayerInventory[playerid][4])
					{
						SendClientMessage(playerid, COLOR_WHITE, "Нажал на слот осн. оружия.");
							
						swap(InventoryInfo[playerid][iSlotPrimaryWeapon], InventoryInfo[playerid][iSlotWeapon][idSlot{playerid}]);
							
						TextDrawSetPreviewModel(PlayerInventory[playerid][4], InventoryInfo[playerid][iSlotPrimaryWeapon]);
						TextDrawShowForPlayer(playerid, PlayerInventory[playerid][4]);	
						
						TextDrawSetPreviewModel(PlayerInventory[playerid][5+idSlot{playerid}], InventoryInfo[playerid][iSlotWeapon][idSlot{playerid}]);
						TextDrawShowForPlayer(playerid, PlayerInventory[playerid][5+idSlot{playerid}]);
					}
					
					for(new i; i < MAX_MAIN_SLOTS; i++)
					{
						if(clickedid == PlayerInventory[playerid][5+i])
						{
							if(i == 0)
							{
								swap(InventoryInfo[playerid][iSlotWeapon][i], InventoryInfo[playerid][iSlotWeapon][i+1]);
								TextDrawSetPreviewModel(PlayerInventory[playerid][5], InventoryInfo[playerid][iSlotWeapon][i]);							
								TextDrawSetPreviewModel(PlayerInventory[playerid][6], InventoryInfo[playerid][iSlotWeapon][i+1]);
							}
							else 
							{
								swap(InventoryInfo[playerid][iSlotWeapon][i], InventoryInfo[playerid][iSlotWeapon][i-1]);
								TextDrawSetPreviewModel(PlayerInventory[playerid][5], InventoryInfo[playerid][iSlotWeapon][i-1]);							
								TextDrawSetPreviewModel(PlayerInventory[playerid][6], InventoryInfo[playerid][iSlotWeapon][i]);
							}
							TextDrawShowForPlayer(playerid, PlayerInventory[playerid][5]);						
							TextDrawShowForPlayer(playerid, PlayerInventory[playerid][6]);
						}									
					}
					idItem[playerid] = EMPTY_SLOT_OBJECT;
					slotType[playerid] = Nothing;	
					idSlot{playerid} = EMPTY_ID_SLOT_OBJECT;
				}
				else
					SendClientMessage(playerid, COLOR_GREY, "Оружие из инвентаря необходимо поместить в слот основного оружия.");
			
			}
			
			if(slotType[playerid] == TypePrimaryWeapon)
			{
				if(clickedid == PlayerInventory[playerid][5] || clickedid == PlayerInventory[playerid][6])
				{				
					if(clickedid == PlayerInventory[playerid][5])
					{
						SendClientMessage(playerid, COLOR_WHITE, "Нажал на слот 1 оружия в инвентаре.");
						
						swap(InventoryInfo[playerid][iSlotWeapon][0], InventoryInfo[playerid][iSlotPrimaryWeapon]);
						
						TextDrawSetPreviewModel(PlayerInventory[playerid][5], InventoryInfo[playerid][iSlotWeapon][0]);					
						TextDrawShowForPlayer(playerid, PlayerInventory[playerid][5]);
					}			
					if(clickedid == PlayerInventory[playerid][6])
					{
						SendClientMessage(playerid, COLOR_WHITE, "Нажал на слот 2 оружия в инвентаре.");	
						
						swap(InventoryInfo[playerid][iSlotWeapon][1], InventoryInfo[playerid][iSlotPrimaryWeapon]);	
						
						TextDrawSetPreviewModel(PlayerInventory[playerid][6], InventoryInfo[playerid][iSlotWeapon][1]);					
						TextDrawShowForPlayer(playerid, PlayerInventory[playerid][6]);
					}
					
					TextDrawSetPreviewModel(PlayerInventory[playerid][4], InventoryInfo[playerid][iSlotPrimaryWeapon]);
					TextDrawShowForPlayer(playerid, PlayerInventory[playerid][4]);
					
					idItem[playerid] = EMPTY_SLOT_OBJECT;
					slotType[playerid] = Nothing;
				}
				else
					SendClientMessage(playerid, COLOR_GREY, "Оружие необходимо поместить в слот основных оружий.");
			}
			
			if(slotType[playerid] == TypeSecondaryWeapon || slotType[playerid] == TypeBackpack || slotType[playerid] == TypeArmor)
			{
				new bool:correctSlot = true;
				
				for(new i; i < MAX_MAIN_SLOTS; i++)
				{
					if(clickedid != PlayerInventory[playerid][7+i]) continue;
					else
						correctSlot = true;
					
					if(correctSlot && InventoryInfo[playerid][iSlot][i] == EMPTY_SLOT_OBJECT)
					{
						if(slotType[playerid] == TypeSecondaryWeapon)
						{							
							swap(InventoryInfo[playerid][iSlot][i], InventoryInfo[playerid][iSlotSecondaryWeapon]); // 1
							TextDrawSetPreviewModel(PlayerInventory[playerid][1], InventoryInfo[playerid][iSlotSecondaryWeapon]);
							TextDrawShowForPlayer(playerid, PlayerInventory[playerid][1]);
						}
						else if(slotType[playerid] == TypeBackpack)			
						{							
							swap(InventoryInfo[playerid][iSlot][i], InventoryInfo[playerid][iSlotBackpack]); // 2
							TextDrawSetPreviewModel(PlayerInventory[playerid][2], InventoryInfo[playerid][iSlotBackpack]);
							TextDrawShowForPlayer(playerid, PlayerInventory[playerid][2]);
						}
						else if(slotType[playerid] == TypeArmor)		
						{							
							swap(InventoryInfo[playerid][iSlot][i], InventoryInfo[playerid][iSlotArmor]); // 3
							TextDrawSetPreviewModel(PlayerInventory[playerid][3], InventoryInfo[playerid][iSlotArmor]);					
							TextDrawShowForPlayer(playerid, PlayerInventory[playerid][3]);
						}						
						TextDrawSetPreviewModel(PlayerInventory[playerid][7+i], InventoryInfo[playerid][iSlot][i]);
						TextDrawShowForPlayer(playerid, PlayerInventory[playerid][7+i]);	
									
						idItem[playerid] = EMPTY_SLOT_OBJECT;
						slotType[playerid] = Nothing;
					}
					else
						return SendClientMessage(playerid, COLOR_GREY, "Предмет необходимо поместить в пустой слот.");
				}
			}
		}
	}
    return 0;
}

public OnPlayerKeypadInput(playerid, keypadID, type, key) // 'key' contains the number that has already been entered in it's entirety
{			
	if(type == KEYPAD_INPUT_BAD)	
		GameTextForPlayer(playerid, FixText("~R~Доступ запрещен"), 1500, 3);
	
	if(type == KEYPAD_INPUT_GOOD)
	{
		GameTextForPlayer(playerid, FixText("~G~Дверь открывается"), 1500, 3);
		if(keypadID == KEYPAD_POLICE)
		{
			MoveObject (LSPDDoor, 250.4400000,62.7500000,1002.6000000+0.01, 0.01, 0.0000000,0.0000000,180.0000000);		
			LSPDDoorOpen = true;		
		}
		
		if(keypadID == KEYPAD_POLICE2)
		{
			MoveObject (LSPDDoor2, 245.7998000,72.3496100,1002.6000000+0.02, 0.01, 0.0000000,0.0000000,270.0000000);		
			LSPDDoor2Open = true;	
		}
		
		if(keypadID == KEYPAD_BANKDOOR)
		{
			MoveObject (BankDoor, 2150.3604000,1605.7998000,1006.5200000+0.1, 0.05, 0.0000000,0.0000000,90.0000000);		
			BankDoorOpen = true;
		}
		
		if(keypadID == KEYPAD_BANKDOOR2)
		{
			MoveObject (BankDoor2, 2147.0801000,1604.7002000,1006.5000000+0.1, 0.05, 0.0000000,0.0000000,90.0000000);		
			BankDoor2Open = true;	
		}
		
		if(keypadID == KEYPAD_BANKDOOR3)
		{
			MoveObject (BankDoor3, 2149.8301000,1603.5996000,1002.3000000+0.01, 0.01, 0.0000000,0.0000000,179.9950000);	
			BankDoor3Open = true;	
		}
		
		if(keypadID == KEYPAD_AMBULANCEDOOR)
		{
			MoveObject (AmbulanceDoor, 346.7002000,169.0000000,1019.0000000+0.01, 0.01, 0.0000000,0.0000000,180.0000000);	
			AmbulanceDoorOpen = true;	
		}
		
		if(keypadID == KEYPAD_VAULTDOOR)
		{	
			GameTextForPlayer(playerid, FixText("~G~Доступ разрешен"), 1500, 3);
			MoveObject (VaultDoor, 2145.0000000,1625.9000000,994.2600100, 0.04, 0.0000000,0.0000000,270.0000000);		
			VaultDoorOpen = true;
			VaultDoorTime = TIME_VAULTDOORCLOSE;		
		}
		
		if(keypadID == KEYPAD_VAULTGATE)
		{
			GameTextForPlayer(playerid, FixText("~G~Доступ разрешен"), 1500, 3);
			MoveObject (VaultGate, 2138.2000000,1606.9000000,994.2000100, 0.5, 0.0000000,0.0000000,179.9950000);		
			VaultGateOpen = true;	
		}
		
		if(keypadID == KEYPAD_FIREDOOR)
		{
			MoveObject (FireDoor, 253.0996100,108.5800800,1002.2000000+0.01, 0.01, 0.0000000,0.0000000,180.0000000);		
			FireDoorOpen = true;		
		}
		
		if(keypadID == KEYPAD_FIREDOOR2)
		{
			MoveObject (FireDoor2, 239.7500000,118.0898400,1002.2000000+0.01, 0.01, 0.0000000,0.0000000,0.0000000);		
			FireDoor2Open = true;	
		}
	}
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	CA_FindZ_For2DCoord(fX, fY, fZ);
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
 	{
 		SetVehiclePos(GetPlayerVehicleID(playerid), fX, fY, fZ+0.5);
 		PutPlayerInVehicle(playerid, GetPlayerVehicleID(playerid), 0);
 	}
 	else
 		SetPlayerPos(playerid, fX, fY, fZ+0.5);

 	SetPlayerVirtualWorld(playerid, 0);
 	SetPlayerInterior(playerid, 0);
    return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
	/*if(issuerid != INVALID_PLAYER_ID) // если игрок не ударился сам
    {
        new issuerweaponid = GetPlayerWeapon(issuerid);
        if(19 <= issuerweaponid <= 34 || issuerweaponid == 38) // если урон от огнестрельного оружия
        {
            switch(bodypart)
            {
                case BODY_PART_TORSO: // туловище
                    amount = 75.0;
					
                case BODY_PART_GROIN: // пах
                    amount = 35.0;
					
                case BODY_PART_LEFT_ARM, BODY_PART_RIGHT_ARM, BODY_PART_LEFT_LEG, BODY_PART_RIGHT_LEG: // руки, ноги
                    amount = 50.0;
					
                case BODY_PART_HEAD: // голова
                    amount = 100.0;
            }
        }
		if(issuerweaponid == 0)
			amount = 5.0;
    }*/
	PlayerInfo[playerid][pHP] -= amount;	
    return 1;
}

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
	if(VehInfo[vehicleid][vAdd] != 1 || TypeVehicle(GetVehicleModel(vehicleid)) == 8 || TypeVehicle(GetVehicleModel(vehicleid)) == 3) return 1;
	
	if(GetVehicleDistanceFromPoint(vehicleid, VehPosX[vehicleid], VehPosY[vehicleid], VehPosZ[vehicleid]) > 0.5)
	{
		SetVehiclePos(vehicleid, VehPosX[vehicleid], VehPosY[vehicleid], VehPosZ[vehicleid]);
		SetVehicleZAngle(vehicleid, VehPosA[vehicleid]);
	}
	return 1; 
} 


public OnPlayerCommandReceived(playerid, cmdtext[])
{
    if(!gPlayerLogged{playerid}) return 0;
    return 1; // разрешить выполнение команды
}  

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if(success == -1) // если команда не найдена
    {
        return SendClientMessage(playerid, COLOR_GREY, "Такой команды не существует.");
    }
    return 1;
}

public OnPlayerFinishedDownloading(playerid, virtualworld)
{
    return 1;
}

enum attached_object_data
{
    Float:ao_x,
    Float:ao_y,
    Float:ao_z,
    Float:ao_rx,
    Float:ao_ry,
    Float:ao_rz,
    Float:ao_sx,
    Float:ao_sy,
    Float:ao_sz
}
 
new ao[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS][attached_object_data];
 
// The data should be stored in the above array when attached objects are attached.
 
public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    if(response)
    {
		new i = index;
        SendClientMessage(playerid, COLOR_GREEN, "Attached object edition saved.");
 
        ao[playerid][index][ao_x] = fOffsetX;
        ao[playerid][index][ao_y] = fOffsetY;
        ao[playerid][index][ao_z] = fOffsetZ;
        ao[playerid][index][ao_rx] = fRotX;
        ao[playerid][index][ao_ry] = fRotY;
        ao[playerid][index][ao_rz] = fRotZ;
        ao[playerid][index][ao_sx] = fScaleX;
        ao[playerid][index][ao_sy] = fScaleY;
        ao[playerid][index][ao_sz] = fScaleZ;
		printf("%d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f", index, modelid, boneid, ao[playerid][i][ao_x], ao[playerid][i][ao_y], ao[playerid][i][ao_z], ao[playerid][i][ao_rx], ao[playerid][i][ao_ry], ao[playerid][i][ao_rz], ao[playerid][i][ao_sx], ao[playerid][i][ao_sy], ao[playerid][i][ao_sz]);
    }
    else
    {
        SendClientMessage(playerid, COLOR_RED, "Attached object edition not saved.");
 
        new i = index;
        SetPlayerAttachedObject(playerid, index, modelid, boneid, ao[playerid][i][ao_x], ao[playerid][i][ao_y], ao[playerid][i][ao_z], ao[playerid][i][ao_rx], ao[playerid][i][ao_ry], ao[playerid][i][ao_rz], ao[playerid][i][ao_sx], ao[playerid][i][ao_sy], ao[playerid][i][ao_sz]);
    }
    return 1;
}


public FCNPC_OnSpawn(npcid)
{
	//FCNPC_GoTo(mission1NPC, mission1NPCPoint[countpoint][0], mission1NPCPoint[countpoint][1], mission1NPCPoint[countpoint][2],
	//MOVE_TYPE_WALK, MOVE_SPEED_WALK, true);
    //countpoint ++;
	//FCNPC_SetWeapon(mission1NPC, 0);
	//FCNPC_SetWeapon(mission1NPC, 24);
	//FCNPC_SetAmmo(mission1NPC, 100);
	return 1;
}

public FCNPC_OnRespawn(npcid)
{
	//FCNPC_GoTo(mission1NPC, mission1NPCPoint[countpoint][0], mission1NPCPoint[countpoint][1], mission1NPCPoint[countpoint][2],
	//MOVE_TYPE_WALK, MOVE_SPEED_WALK, true);
    //countpoint ++;
	//FCNPC_SetWeapon(mission1NPC, 0);
	return 1;
}

public FCNPC_OnReachDestination(npcid)
{
    //if(countpoint == sizeof(mission1NPCPoint)) countpoint = 0;
    //FCNPC_GoTo(mission1NPC, mission1NPCPoint[countpoint][0], mission1NPCPoint[countpoint][1], mission1NPCPoint[countpoint][2],
	//MOVE_TYPE_WALK, MOVE_SPEED_WALK, true);
    //countpoint ++;
    return 1;
}

public FCNPC_OnTakeDamage(npcid, issuerid, Float:amount, weaponid, bodypart)
{
	if(npcid == NPCGym)
	{		
		FCNPC_SetHealth(NPCGym, FCNPC_GetHealth(NPCGym) - 3.0);
		FCNPC_GoToPlayer(NPCGym, issuerid, FCNPC_MOVE_TYPE_WALK, FCNPC_MOVE_SPEED_WALK);
		return 1;
	}

	foreach(Robots, r)
	{		
		new Float:x[MAX_ROBOTS], Float:y[MAX_ROBOTS], Float:z[MAX_ROBOTS],
			Float:px, Float:py, Float:pz,
			Float:x1, Float:y1, Float:z1;
				
		FCNPC_GetPosition(Robot[r], x[r], y[r], z[r]);
		GetPlayerPos(issuerid, px, py, pz);
		
		/*if(GetPlayerDistanceFromPoint(issuerid, x[r], y[r], z[r]) < 100 && !CA_RayCastLine(x[r], y[r], z[r], px, py, pz, x1, y1, z1) &&
		!Iter_Contains(Robots, issuerid))
			FCNPC_AimAtPlayer(Robot[r], issuerid, true);*/
		
		for(new i = 0; i < MAX_ROBOTS_POSITION; i++)
		{
			if(RobotsInfo[r][rAreaID] != i) continue;
			
			new Float: min_x, Float: min_y, Float: zcoord;
			
			min_x = frand(RobotsPositions[i][0], RobotsPositions[i][2]);
			min_y = frand(RobotsPositions[i][1], RobotsPositions[i][3]);	
			CA_FindZ_For2DCoord(min_x, min_y, zcoord); // координата Z
					
			if(CA_RayCastLine(x[r], y[r], z[r], min_x, min_y, zcoord+0.5, x1, y1, z1) == 0 && npcid == Robot[r])
				FCNPC_GoTo(Robot[r], min_x, min_y, zcoord+0.5, FCNPC_MOVE_TYPE_AUTO, FCNPC_MOVE_SPEED_AUTO, FCNPC_MOVE_MODE_COLANDREAS);
		}
	}

	
	/*if(playeridmission1 == damagerid)
	{
		FCNPC_SetWeapon(mission1NPC, 24);
		FCNPC_SetAmmo(mission1NPC, 100);
		FCNPC_Stop(mission1NPC);
		FCNPC_AimAtPlayer(mission1NPC, playeridmission1, true);
		mission1NPCAttacked = true;
		
		switch(weaponid)
		{
				case 0: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 3);
				case 1: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 5);
				case 2: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 7);
				case 3: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 6);
				case 4: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 8);
				case 5: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 10);
				case 6: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 10);
				case 7: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 9);
				case 8: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 15);
				case 14: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 0.5);
				case 15: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 5);
				case 16: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 70);
				case 18: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 5);
				case 22: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 11);
				case 23: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 11);
				case 24: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 45);
				case 25: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 50);
				case 26: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 50);
				case 27: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 65);
				case 28: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 10);
				case 29: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 15);
				case 30: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 27);
				case 31: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 23);
				case 32: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 15);
				case 33: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 55);
				case 34: FCNPC_SetHealth(npcid, FCNPC_GetHealth(npcid) - 70);
		}
		if(FCNPC_GetHealth(npcid) < 1) 
			FCNPC_Kill(npcid);
	}*/
	return 1;
}

public FCNPC_OnDeath(npcid, killerid, reason)
{
	foreach(Robots, i)
	{
		if(npcid == Robot[i])
		{
			new string[9];
			format(string, sizeof(string), "Robot_%d", i);	
			SendClientMessage(killerid, COLOR_WHITE, string);
			RobotsInfo[i][rVisible] = 0;
			for(new z = 0; z < MAX_ROBOTS_POSITION; z++)
			{
				if(!Iter_Contains(RobotsVisible[z], i)) continue;
				Iter_Remove(RobotsVisible[z], i); 
			}
			return 1;
		}
	}
	/*if(npcid == mission1NPC)
	{
		mission1NPCDead = true;
		countpoint = 0;
		playeridmission1 = INVALID_PLAYER_ID;
		
		RemovePlayerMapIcon(playeridmission1, 0);
		RemovePlayerMapIcon(playeridmission1, 1);
	}*/
    return 1;
}

public FCNPC_OnStreamIn(npcid, forplayerid)
{
	return 1;
}

public FCNPC_OnStreamOut(npcid, forplayerid)
{
	return 1;
}

public FCNPC_OnGiveDamage(npcid, damagedid, Float:amount, weaponid, bodypart)
{
	//PlayerInfo[damagedid][pHP] -= amount;
	return 1;
}

public FCNPC_OnUpdate(npcid)
{
	/*foreach(Robots, i)
	{
		if(FCNPC_IsSpawned(Robot[i]))
		{
			if(CA_IsRobotOnSurface(i)) continue;
				
			new Float:x, Float:y, Float:z;
			FCNPC_GetPosition(Robot[i], x, y, z);
			CA_FindZ_For2DCoord(x, y, z); // координата Z
			FCNPC_SetPosition(Robot[i], x, y, z+1.0);
			
			if(!CA_IsRobotBlocked(i)) continue;
			if(FCNPC_IsMoving(Robot[i]))
				FCNPC_Stop(Robot[i]);
		}
	}	*/
	return 1;
}

forward NPCGymTimer(playerid);
public NPCGymTimer(playerid)
{		
	FCNPC_GoToPlayer(NPCGym, playerid, FCNPC_MOVE_TYPE_WALK, FCNPC_MOVE_SPEED_WALK);
	
	if(!IsPlayerInRangeOfPoint(playerid, 7.0, 760.6885,0.1531,1001.5942))
	{
		FCNPC_StopAttack(NPCGym);			
		FCNPC_SetVirtualWorld(NPCGym, 1);
			
		if(FCNPC_IsMovingAtPlayer(NPCGym, playerid))
			FCNPC_Stop(NPCGym);	
		FCNPC_Kill(NPCGym);
		
		KillTimer(GetPVarInt(playerid,"TimerIDGymFight"));
		
		SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pCurrentFightStyle]);
		
		DeletePVar(playerid, "NumberOfWins");
		DeletePVar(playerid, "NumberOfLose");
		DeletePVar(playerid, "ChooseGymAction");		
		return 1;
	}
	
	if(PlayerInfo[playerid][pHP] < 15 || FCNPC_GetHealth(NPCGym) < 15)
	{			
		if(FCNPC_GetHealth(NPCGym) < 15 || FCNPC_IsDead(NPCGym))
			SetPVarInt(playerid, "NumberOfWins", GetPVarInt(playerid, "NumberOfWins")+ 1);
		
		if(PlayerInfo[playerid][pHP] < 15)
			SetPVarInt(playerid, "NumberOfLose", GetPVarInt(playerid, "NumberOfLose")+ 1);
		
		if(FCNPC_IsDead(NPCGym))
			FCNPC_Respawn(NPCGym);
		
		if(GetPVarInt(playerid, "NumberOfWins") == 3 || GetPVarInt(playerid, "NumberOfLose") == 2)
		{
			FCNPC_StopAttack(NPCGym);			
			FCNPC_SetVirtualWorld(NPCGym, 1);
			
			if(FCNPC_IsMovingAtPlayer(NPCGym, playerid))
				FCNPC_Stop(NPCGym);	
			FCNPC_Kill(NPCGym);
			
			GameTextForPlayer(playerid, GetPVarInt(playerid, "NumberOfLose") == 2 ? FixText("~R~Поражение!") :  FixText("~G~Победа!"), 5000, 3);
		
			KillTimer(GetPVarInt(playerid,"TimerIDGymFight"));		
			
			SetPlayerPos(playerid, 765.1835,-1.4311,1000.7148);
			SetPlayerFacingAngle(playerid, 271.1791);
			SetCameraBehindPlayer(playerid);
			
			if(GetPVarInt(playerid, "NumberOfLose") == 2)
			{
				ApplyAnimation(playerid, "CASINO", "cards_lose", 4.1, 0, 1, 1, 0, 2000, 1);
				SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pCurrentFightStyle]);
			}
			else
			{
				ApplyAnimation (playerid, "CRIB", "PED_Console_Win", 4.1, 0, 1, 1, 0, 2500, 1);
				
				PlayerInfo[playerid][pCurrentFightStyle] = fighting_style[GetPVarInt(playerid, "ChooseGymAction")-2][fsID];
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "CurrentFightStyle", PlayerInfo[playerid][pCurrentFightStyle]);
				
				SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pCurrentFightStyle]);
			}
			
			DeletePVar(playerid, "NumberOfWins");
			DeletePVar(playerid, "NumberOfLose");
			DeletePVar(playerid, "ChooseGymAction");			
			return 1;			
		}
		
		SetPlayerPos(playerid, 763.0496, -2.0470, 1001.5942);
		SetPlayerFacingAngle(playerid, 44.3001);
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid, 0);
		PlayerInfo[playerid][pHP] = 100;

		FCNPC_SetPosition(NPCGym, 758.6925, 2.3802, 1001.5942);						
		FCNPC_SetAngle(NPCGym, 223.2010);
		FCNPC_SetHealth(NPCGym, 100.0);
		FCNPC_StopAttack(NPCGym);
		FCNPC_ClearAnimations(NPCGym);
		
		if(FCNPC_IsMovingAtPlayer(NPCGym, playerid))
				FCNPC_Stop(NPCGym);		
		
		GameTextForPlayer(playerid, FixText("~W~3 секунды до боя"), 3000, 3);
		
		new string[11];
		format(string, sizeof(string), FixText("Побед: %d/3"), GetPVarInt(playerid, "NumberOfWins")); 
		GameTextForPlayer(playerid, string, 3000, 5);
				
		KillTimer(GetPVarInt(playerid,"TimerIDGymFight"));
		SetTimerEx("PlayerFightNPC", 3000, false, "d", playerid);
	}
    return 1;
}

SpawnRobots(robotid)
{
	FCNPC_Respawn(Robot[robotid]),
	SendClientMessage(0, COLOR_GREEN,"respawn");		
	
	FCNPC_SetVirtualWorld(Robot[robotid], 0);
	
    FCNPC_SetWeaponAccuracy(Robot[robotid], 31, 0.1);
    FCNPC_SetWeapon(Robot[robotid], 31);
    FCNPC_SetAmmo(Robot[robotid], 9999);
	FCNPC_SetAmmoInClip(Robot[robotid], 30);
	
	RobotsInfo[robotid][rVisible] = 1;
	return 1;
}

/////////////////////////////////////////////                    Команды Команды               / ///////////////////////////

////////////////////////////////                                АВТОМОБИЛИ

CMD:vmenu(playerid)
{
	new carid = GetAroundPlayerVehicleID(playerid, 4.0);
	
	if(carid == PlayerInfo[playerid][pCarKey] || VehInfo[carid][vBuy] == PlayerInfo[playerid][pMember] ||
		RentCar[playerid] == carid)
		return ShowPlayerVehicleDialog(playerid);
	
	return 1;
}

CMD:refill(playerid)
{		
    if(!IsPlayerInAnyVehicle(playerid)) return 1;
	
    if(!IsAtGasStation(playerid)) 
		return SendClientMessage(playerid, COLOR_GREY,"Вы находитесь далеко от АЗС.");

    if(GetPVarInt(playerid, "Refill") == 1) return 1;
	
    GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine,lights,alarm,doors,bonnet,boot,objective);
    if(engine) 
		return SendClientMessage(playerid, COLOR_RED,"Заглушите двигатель вашего транспортного средства.");
	
    TogglePlayerControllable(playerid,0);
	
    new str[178];
			
	format(str, sizeof(str), ""COL_BLUE"Здравствуйте, Вас приветствует АЗС округа 'Angel Pine'\n\n\
	Введите количество литров, которое Вы хотите наполнить в бензобак:\nСтоимость одного литра: "COL_GREEN"%d $", CENA_BENZ);
	ShowPlayerDialog(playerid, DIALOG_ID_REFILL, D_S_I, ""COL_ORANGE"АЗС", str, "Принять", "Отмена");
    return 1;
}

CMD:cveh(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
    extract params -> new carid, col1, col2, price;	else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /cveh [ID транспорта] [цвет 1] [цвет 2] [цена]");

    if (carid < 400 || carid > 611) 
		return SendClientMessage(playerid, COLOR_GREY,"ID транспорта от 400 до 611.");

    new Float:x,Float:y,Float:z,Float:a;// Массив для позиции
	
    GetPlayerPos(playerid,x,y,z);// Узнаём позицию игрока
    GetPlayerFacingAngle(playerid,a);// Узнаём угол поворота игрока
    LastCar++;// Прибавляем к последней добавленной машине одну
	
    VehInfo[LastCar][vAdd] = true;// Устанавливаем проверку на созданную машину
    VehInfo[LastCar][vModel] = carid;// Устанавливаем модель машине
    VehInfo[LastCar][vVPosX] = x;// Устанавливаем позицию
    VehInfo[LastCar][vVPosY] = y;// Устанавливаем позицию
    VehInfo[LastCar][vVPosZ] = z;// Устанавливаем позицию
    VehInfo[LastCar][vVZa] = a;// Устанавливаем позицию
    VehInfo[LastCar][vColor1] = col1;// Устанавливаем машине цвет
    VehInfo[LastCar][vColor2] = col2;// Устанавливаем машине цвет
    strmid(VehInfo[LastCar][vOwner], "Angel Pine", 0, 10, 11);
    VehInfo[LastCar][vPrice] = price;
    VehInfo[LastCar][vBuy] = VBUYTOSELL;
    VehInfo[LastCar][vLock] = false;
    VehInfo[LastCar][vFuel] = 100;
	
	static 
        string[159+11+144+10+1];

    string[0] = '\0';
    format(string, sizeof(string), 
        "\
            INSERT INTO `vehicles` (`Add`, `Model`, `VPosX`, `VPosY`, `VPosZ`, `VZa`, `Color1`, `Color2`, `Owner`, `Price`, `Buy`, `Lock`, `Fuel`, `VHP`) \
			VALUES ('%d', '%d', '%f', '%f', '%f', '%f', '%d', '%d', '%s', '%d', '%d', '%d', '%d', '1000.0')\
        ", 
            VehInfo[LastCar][vAdd],
			VehInfo[LastCar][vModel],
            VehInfo[LastCar][vVPosX],
            VehInfo[LastCar][vVPosY],
			VehInfo[LastCar][vVPosZ],
			VehInfo[LastCar][vVZa],
			VehInfo[LastCar][vColor1],
			VehInfo[LastCar][vColor2],
			VehInfo[LastCar][vOwner],
			VehInfo[LastCar][vPrice],
			VehInfo[LastCar][vBuy],
			VehInfo[LastCar][vLock],
			VehInfo[LastCar][vFuel]);
			
    mysql_tquery(mysql_connect_ID, string);
	
    CreateVehicle(VehInfo[LastCar][vModel],VehInfo[LastCar][vVPosX]+2,VehInfo[LastCar][vVPosY]+2,VehInfo[LastCar][vVPosZ]+1,VehInfo[LastCar][vVZa],
	VehInfo[LastCar][vColor1],VehInfo[LastCar][vColor2],60000);//
	return 1;
}

CMD:parkveh(playerid)
{
	if (PlayerInfo[playerid][pMember] != 5) return 1;
	
	if(!IsPlayerInAnyVehicle(playerid)) 
		return SendClientMessage(playerid, COLOR_GREY, "Вы не в транспорте.");

    new Float:x,Float:y,Float:z,Float:a,
		currentveh = GetPlayerVehicleID(playerid),
		string[50];
		
	if(VehInfo[currentveh][vBuy] != VBUYTOSELL)
		return SendClientMessage(playerid, COLOR_GREY, "Данный транспорт не подлежит продаже.");
		
    GetVehiclePos(currentveh, x, y, z);// Узнаём позицию игрока
    GetVehicleZAngle(currentveh, a);
	
    VehInfo[LastCar][vVPosX] = x;// Устанавливаем позицию
    VehInfo[LastCar][vVPosY] = y;// Устанавливаем позицию
    VehInfo[LastCar][vVPosZ] = z;// Устанавливаем позицию
    VehInfo[LastCar][vVZa] = a;// Устанавливаем позицию
	
	VehInfo[LastCar][vBuy] = VBUYTOBUY;
	
	UpdateDataFloat(LastCar, "vehicles", "VPosX", x);
	UpdateDataFloat(LastCar, "vehicles", "VPosY", y);
	UpdateDataFloat(LastCar, "vehicles", "VPosZ", z);
	UpdateDataFloat(LastCar, "vehicles", "VZa", a);
	
	UpdateDataInt(LastCar, "vehicles", "Buy", VehInfo[LastCar][vBuy]);	
	
	format(string, sizeof(string), "Продается\nСтоимость: "COL_GREEN"%i $",VehInfo[LastCar][vPrice]);
	sellVehInfo[LastCar] = Create3DTextLabel(string, COLOR_PROX, 0, 0, 0, 5.0, 0, 0 );
	Attach3DTextLabelToVehicle(Text3D:sellVehInfo[LastCar], LastCar, 0.0, 0.0, 0.8);
	
	GameTextForPlayer(playerid, FixText("~G~Транспорт припаркован"), 1000, 3);
   	return 1;
}

CMD:updateallvehpos(playerid)
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	foreach (new v : Vehicle) 
	{ 
		new Float:x,Float:y,Float:z,Float:a;
			
		GetVehiclePos(v, x, y, z);// Узнаём позицию
		GetVehicleZAngle(v, a);
		
		VehInfo[v][vVPosX] = x;// Устанавливаем позицию
		VehInfo[v][vVPosY] = y;// Устанавливаем позицию
		VehInfo[v][vVPosZ] = z;// Устанавливаем позицию
		VehInfo[v][vVZa] = a;// Устанавливаем позицию

		UpdateDataFloat(v, "vehicles", "VPosX", x);
		UpdateDataFloat(v, "vehicles", "VPosY", y);
		UpdateDataFloat(v, "vehicles", "VPosZ", z);
		UpdateDataFloat(v, "vehicles", "VZa", a);
		
		SetVehicleToRespawn(v);
		
		GameTextForPlayer(playerid, FixText("~G~Позиция всего транспорта обновлена"), 1000, 3);		
	}
	return 1;
}

CMD:updatevehpos(playerid)
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	if(!IsPlayerInAnyVehicle(playerid)) 
		return SendClientMessage(playerid, COLOR_GREY, "Вы не в транспорте.");

    new Float:x,Float:y,Float:z,Float:a,
		currentveh = GetPlayerVehicleID(playerid);
		
    GetVehiclePos(currentveh, x, y, z);// Узнаём позицию игрока
    GetVehicleZAngle(currentveh, a);
	
    VehInfo[currentveh][vVPosX] = x;// Устанавливаем позицию
    VehInfo[currentveh][vVPosY] = y;// Устанавливаем позицию
    VehInfo[currentveh][vVPosZ] = z;// Устанавливаем позицию
    VehInfo[currentveh][vVZa] = a;// Устанавливаем позицию
	
	UpdateDataFloat(currentveh, "vehicles", "VPosX", x);
	UpdateDataFloat(currentveh, "vehicles", "VPosY", y);
	UpdateDataFloat(currentveh, "vehicles", "VPosZ", z);
	UpdateDataFloat(currentveh, "vehicles", "VZa", a);	
	
	GameTextForPlayer(playerid, FixText("~G~Позиция транспорта обновлена"), 1000, 3);
   	return 1;
}

CMD:fixcar(playerid)
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

CMD:tunecar(playerid)
{	
    if (PlayerInfo[playerid][pMember] != 5) return 1;
	
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, -2396.5737,-2187.4832,33.4849))
		return SendClientMessage(playerid, COLOR_GREY,"Вам нужно находится в мастерской рядом с транспортом.");
		
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) 
		return ShowPlayerDialog(playerid, DIALOG_TYPE_MAIN, D_S_L, ""COL_ORANGE"Тюнинг транспорта",
		""COL_BLUE"Винилы\nПокраска\nКапот\nВентиляционные отверстия\nПодфарники\nВыхлопная труба\n\
		Передний бампер\nЗадний бампер\nКрыша\nСпойлер\nБоковые юбки\nНавесной бампер\nКолеса\nУсилители звука\nГидравлика\nЗакись азота",
		"Выбрать", "Отмена");	
	else 
		SendClientMessage(playerid, COLOR_RED, "Вам нужно находится в транспорте.");
    return 1;
}

CMD:tow(playerid)
{		
	if (PlayerInfo[playerid][pMember] != 5) return 1;
	
	new vehicleid = GetPlayerVehicleID(playerid);
	
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || GetVehicleModel(vehicleid) != 525) 
		return SendClientMessage(playerid, COLOR_GREY, "Вам нужно находится в эвакуаторе.");

	if(IsTrailerAttachedToVehicle(vehicleid)) 
		return DetachTrailerFromVehicle(vehicleid), GameTextForPlayer(playerid, FixText("~L~Транспорт отцеплен"), 1000, 3);

	new Float:x, Float:y, Float:z,
		Float:dist, Float:closedist = 8, closeveh;	
		
	foreach (new v : Vehicle) 
	{ 
		if(v != vehicleid && GetVehiclePos(v, x, y, z))
		{
			dist = GetPlayerDistanceFromPoint(playerid, x, y, z);
			if(dist < closedist)
			{
				closedist = dist;
				closeveh = v;
			}
		}
	}
	if(closeveh) 
		return AttachTrailerToVehicle(closeveh, vehicleid), GameTextForPlayer(playerid, FixText("~G~Транспорт зацеплен"), 1000, 3); 
	return 1;
}

CMD:veh(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	extract params -> new carid;	else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /veh [ID транспорта]");

	if (carid < 400 || carid > 611) 
		return SendClientMessage(playerid, COLOR_GREY,"ID транспорта от 400 до 611.");
	
	new Float:X, Float:Y, Float:Z, Float: A;
	
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, A);

    CreateVehicle(carid, X+1,Y+2,Z+1, A, 0, 0, 60000);
	PutPlayerInVehicle(playerid, GetAroundPlayerVehicleID(playerid, 3), 0);
	
	SetVehicleParamsEx(GetAroundPlayerVehicleID(playerid, 3), true, lights, alarm, doors, bonnet, boot, objective);		
	Engine{GetAroundPlayerVehicleID(playerid, 3)} = true;
	return 1;
}

CMD:vehid(playerid)
{
    new vehname[30];
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

CMD:setvehhp(playerid)
{
	if (IsPlayerInAnyVehicle(playerid))
		SetVehicleHealth(GetPlayerVehicleID(playerid), 301.0);	
	return 1;
}


////////////////////// АДМИНСКИЕ

CMD:makeleader(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
    
    extract params -> new player:targetid;	else
		return SendClientMessage(playerid,COLOR_GREY,"CMD: /makeleader [ID игрока]");

    if (targetid == INVALID_PLAYER_ID || gPlayerLogged{targetid} == false)
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    static const
        fmt_dlg_header[] = ""COL_ORANGE"Назначить лидером игрока "COL_WHITE"[%d] %s",
        fmt_dlg[] = ""COL_BLUE"%s%s\n";

    new
        header_string[sizeof(fmt_dlg_header) + (-2+MAX_PLAYER_NAME+1) + (-2+5)],
        dialog_string[(sizeof(fmt_dlg) + (-2+MAX_FRACTION_NAME_LENGTH))*MAX_FRACTIONS];

    format(header_string, sizeof(header_string), fmt_dlg_header, targetid, PlayerInfo[targetid][pName]);

    for(new i = 0; i < MAX_FRACTIONS; i++)
        format(dialog_string, sizeof(dialog_string), fmt_dlg, dialog_string, fraction_name[i]);

    ShowPlayerDialog(playerid, DIALOG_ID_SETLEADER, D_S_L, header_string, dialog_string, "Выбрать", "Отмена");

    SetPVarInt(playerid, "makeleader_target", targetid);
    return 1;
}

CMD:kick(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	extract params -> new player:targetid, string:reason[70];	else
		return SendClientMessage(playerid,COLOR_GREY,"CMD: /kick [ID игрока] [Причина]");

	if (targetid == INVALID_PLAYER_ID || gPlayerLogged{targetid} == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

	new string[128];
		
    format(string, sizeof(string),"Администратор [%d] %s кикнул игрока [%d] %s причина: %s", playerid, Name(playerid), targetid, Name(targetid), reason);
    SendClientMessageToAll(COLOR_RED, string);
	
	format(string, sizeof(string), ""COL_BLUE"Вы были кикнуты администратором %s\nПричина: "COL_WHITE"%s\n", Name(playerid), reason);
	ShowPlayerDialog(targetid, DIALOG_ID_NONE, D_S_M,""COL_ORANGE"Kick", string, "Принять", "");	
	
	TogglePlayerControllable(targetid, 0);
	
	Kick(playerid);
	
	WriteLogByTypeName("Kick", PlayerInfo[playerid][pID], PlayerInfo[targetid][pID], reason);  
	return 1;
}

CMD:ban(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	extract params -> new player:targetid, string:reason[70];	else
		return SendClientMessage(playerid,COLOR_GREY,"CMD: /ban [ID игрока] [Причина]");

	if (targetid == INVALID_PLAYER_ID || gPlayerLogged{targetid} == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
	
	new string[128];
		
    format(string, sizeof(string),"Администратор [%d] %s забанил игрока [%d] %s причина: %s", playerid, Name(playerid), targetid, Name(targetid), reason);
    SendClientMessageToAll(COLOR_RED, string);
	
	format(string, sizeof(string), ""COL_BLUE"Вы были забанены администратором %s\nПричина: "COL_WHITE"%s\n", Name(playerid), reason);
	ShowPlayerDialog(targetid, DIALOG_ID_NONE, D_S_M, ""COL_ORANGE"Ban", string, "Принять", "");
	
	TogglePlayerControllable(targetid, 0);
	
	Ban(playerid);
	
	WriteLogByTypeName("Ban", PlayerInfo[playerid][pID], PlayerInfo[targetid][pID], reason);  
	return 1;
}

CMD:setfstyle(playerid, params[])
{
    extract params -> new player:targetid, style; else // sscanf2
        return SendClientMessage(playerid, COLOR_GREY, "CMD: /set [ID игрока/часть ника] [ID стиля (1-6)]");
		
    if (style < 1 || style > 6)
        return SendClientMessage(playerid, -1, "Ошибка: ID стиля боя должен быть от 1 до 6.");
	
    --style;
	
    SetPlayerFightingStyle(targetid, fighting_style[style][fsID]);
	
    new string[128];
	
    GetPlayerName(targetid, string, sizeof(string));
    format(string, sizeof(string), "Вы установили игроку %s стиль боя \"%s\".", string, fighting_style[style][fsName]);
	
	PlayerInfo[playerid][pCurrentFightStyle] = fighting_style[style][fsID];
	UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "CurrentFightStyle", PlayerInfo[playerid][pCurrentFightStyle]);
    return SendClientMessage(playerid, -1, string);
}

CMD:makeadmin(playerid, params[])
{
    //if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	new targetid, lvl;
	
    if (sscanf(params, "dD(5)", targetid, lvl)) 
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /makeadmin [ID игрока] [Уровень администратора]");

    if (targetid == INVALID_PLAYER_ID || gPlayerLogged{targetid} == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    if (lvl < 0 || lvl > 5) 
		return SendClientMessage(playerid, COLOR_GREY,"Уровень администратора от 1 до 5.");

    PlayerInfo[targetid][pAdmin] = lvl;
	UpdateDataInt(PlayerInfo[targetid][pID], "accounts", "Admin", PlayerInfo[targetid][pAdmin]);
	
    new str[71 + MAX_PLAYER_NAME*2 + 8 - 8];
	
    format(str, sizeof(str),"Администратор [%d] %s назначил игрока [%d] %s Администратором %d уровня",
	playerid, Name(playerid), targetid, Name(targetid), lvl);
    SendClientMessageToAll(COLOR_RED, str);
    return 1;
}

CMD:cc(playerid) // by Daniel_Cortez \\ pro-pawn.ru
{
    if(PlayerInfo[playerid][pAdmin] != 0)
    {
        // объявить строковую константу и счётчик цикла
        static const str[] = "";
        new i = 100;

        // трюк, предотвращающий краш компилятора (баг sysreq.c)
        // (баг исправлен в патчах от Zeex, в компиляторах версий 0x030A и новее
        // обход бага не нужен, для чего и используется директива #if)
#if __Pawn < 0x030A
        { if(0 == i) SendClientMessageToAll(0, str); }
#endif

        // передать параметры для SendClientMessageToAll
        #emit    push.c        str
        #emit    push.c        0xFFFFFFFF
        #emit    push.c        8

        // вызвать функцию 100 раз
        do{
            #emit    sysreq.c    SendClientMessageToAll
        }while(--i);

        // освободить стековое пространство, зарезервированное под параметры
        #emit    stack        12
    }
    return 1;
}  

CMD:changesex(playerid)
{
	PlayerInfo[playerid][pSex] = (PlayerInfo[playerid][pSex] == 1) ? 2 : 1;
	UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "Sex", PlayerInfo[playerid][pSex]);
	return 1;
}

CMD:a(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] == 0) return 1;
	
	extract params -> new string:message[80]; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /a [Сообщение]");
	
	static const
			fmt_str0[] = "(ADMIN) "COL_ORANGE"[%d] %s: "COL_WHITE"%s";
		
	new string[sizeof(fmt_str0) -2 -2 -2 +5 + MAX_PLAYER_NAME +67];
	
    format(string, sizeof(string), fmt_str0, playerid, Name(playerid), message);    
	return MessageToAdmin(COLOR_RED, string);	
}

CMD:setskin(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	new targetid, id;
	
    if(sscanf(params,"ui", targetid, id)) 
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /setskin [ID игрока] [ID скина]");

	if (targetid == INVALID_PLAYER_ID || gPlayerLogged{targetid} == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    SetPlayerSkin(targetid, id);
	
	PlayerInfo[targetid][pSkin] = id;
	UpdateDataInt(PlayerInfo[targetid][pID], "accounts", "Skin", PlayerInfo[targetid][pSkin]);
    return 1;
}

CMD:setmoney(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	new targetid, amount;
	
    if(sscanf(params,"ui", targetid, amount)) 
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /setmoney [ID игрока] [Кол-во денег]");

	if (targetid == INVALID_PLAYER_ID || gPlayerLogged{targetid} == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    PlayerInfo[targetid][pMoney] = amount;
    return true;
}

CMD:sethunger(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	new targetid, amount;
	
    if(sscanf(params,"uI(25200)", targetid, amount)) 
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /sethunger [ID игрока] [Кол-во голода]");

	if (targetid == INVALID_PLAYER_ID || gPlayerLogged{targetid} == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    PlayerInfo[targetid][pHunger] = amount;
    return true;
}

CMD:setendurance(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	new targetid, amount;
	
    if(sscanf(params,"uI(25200)", targetid, amount)) 
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /setendurance [ID игрока] [Кол-во выносливости]");

	if (targetid == INVALID_PLAYER_ID || gPlayerLogged{targetid} == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    PlayerInfo[targetid][pEndurance] = amount;
    return true;
}

CMD:setbattery(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	new targetid, amount;
	
    if(sscanf(params,"uI(36000)", targetid, amount)) 
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /setbattery [ID игрока] [Заряд батареи]");
	
	if (targetid == INVALID_PLAYER_ID || gPlayerLogged{targetid} == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    PlayerInfo[targetid][pAPEDBattery] = amount;
	return true;
}

CMD:sethp(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;

    new targetid, amount;
	
    if(sscanf(params, "dI(100)", targetid, amount))
        return SendClientMessage(playerid, COLOR_GREY, "CMD: /sethp [ID игрока] [Количество HP]");
	
    if (targetid == INVALID_PLAYER_ID || gPlayerLogged{targetid} == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
	
    if(!(0 <= amount))
        return SendClientMessage(playerid, COLOR_GREY, "Количество здоровья от 0 до 100.");
	
	PlayerInfo[targetid][pHP] = amount;
	return 1;
}

CMD:maxparams(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;

    new targetid;
	
    if(sscanf(params, "d", targetid))
        return SendClientMessage(playerid, COLOR_GREY, "CMD: /maxparams [ID игрока] ");
	
    if (targetid == INVALID_PLAYER_ID || gPlayerLogged{targetid} == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
	
	PlayerInfo[targetid][pHP] = 100;
	PlayerInfo[targetid][pAPEDBattery] = 36000;
	PlayerInfo[targetid][pHunger] = 25200;
	PlayerInfo[targetid][pEndurance] = PlayerInfo[targetid][pEnduranceMax];
	return 1;
}

CMD:goto(playerid, params[])
{    
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
    
	extract params -> new player:targetid; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /goto [ID игрока]");
	
	if (targetid == INVALID_PLAYER_ID || gPlayerLogged{targetid} == false)
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);
	
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
 	{
 		SetVehiclePos(GetPlayerVehicleID(playerid), x+1, y+1, z);
 		PutPlayerInVehicle(playerid, GetPlayerVehicleID(playerid), 0);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(targetid));
 	}
	SetPlayerPos(playerid, x + 0.5, y + 0.5, z + 0.5);
	SetPlayerInterior(playerid, GetPlayerInterior(targetid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
	
    new str[MAX_PLAYER_NAME+1+45];
	
    format(str, sizeof(str),"Администратор [%d] %s телепортировался к вам.", playerid,Name(playerid));
    SendClientMessage(targetid,COLOR_BRIGHTRED, str);
	
    format(str, sizeof(str),"Вы телепортировались к игроку [%d] %s.",targetid,Name(targetid));
    SendClientMessage(playerid,COLOR_BRIGHTRED, str);
	return 1;
}

CMD:gotox(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	extract params -> new Float:X, Float:Y, Float:Z, inter; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /gotox [X] [Y] [Z] [ID интерьера]");

    SetPlayerPos(playerid, X, Y, Z+1);
    SetPlayerInterior(playerid, inter);
	return 1;
}

CMD:gotoap(playerid)
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
    SetPlayerPos(playerid, -1938.713745, -2468.400878, 30.772167);
    SetPlayerInterior(playerid, 0);
   	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}

CMD:gotoveh(playerid, params[])
{    
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
    
	new string[41-2+4];
	
	extract params -> new carid; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /gotoveh [ID транспорта]");
	
	SetPlayerPos(playerid, VehInfo[carid][vVPosX], VehInfo[carid][vVPosY], VehInfo[carid][vVPosZ] + 0.5);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	
    format(string, sizeof(string),"Вы телепортировались к транспорту ID %d.", carid);
    SendClientMessage(playerid, COLOR_BRIGHTRED, string);
	return 1;
}

CMD:gotohouse(playerid, params[])
{    
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
    
	new string[41-2+4];
	
	extract params -> new houseid; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /gotohouse [ID дома]");
	
	SetPlayerPos(playerid, HouseInfo[houseid][hEnterX], HouseInfo[houseid][hEnterY], HouseInfo[houseid][hEnterZ] + 0.5);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	
    format(string, sizeof(string),"Вы телепортировались к дому ID %d.", houseid);
    SendClientMessage(playerid, COLOR_BRIGHTRED, string);
	return 1;
}

CMD:gotoaped(playerid, params[])
{    
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
    
	new string[41-2+4];
	
	extract params -> new apedid; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /gotoaped [ID APED]");
	
	SetPlayerPos(playerid, APEDInfo[apedid][aPosX], APEDInfo[apedid][aPosY], APEDInfo[apedid][aPosZ] + 0.5);
	
    format(string, sizeof(string),"Вы телепортировались к APED ID %d.", apedid);
    SendClientMessage(playerid, COLOR_BRIGHTRED, string);
	return 1;
}

CMD:gethere(playerid, params[])
{
    new Float:x, Float:y, Float:z,
		str[48 + MAX_PLAYER_NAME + 4 - 2 - 2];
		
    GetPlayerPos(playerid, x, y, z);
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	extract params -> new player:targetid; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /gethere [ID игрока]");

	if (targetid == INVALID_PLAYER_ID || gPlayerLogged{targetid} == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

	if(GetPlayerState(targetid) == PLAYER_STATE_DRIVER)
 	{
 		SetVehiclePos(GetPlayerVehicleID(targetid), x+1, y+1, z);
		LinkVehicleToInterior(GetPlayerVehicleID(targetid), GetPlayerInterior(playerid));
 		PutPlayerInVehicle(targetid, GetPlayerVehicleID(targetid), 0);
 	}
 	SetPlayerPos(targetid, x+1, y+1, z);
	SetPlayerInterior(targetid, GetPlayerInterior(playerid));
	SetPlayerVirtualWorld(targetid, GetPlayerVirtualWorld(playerid));
	
    format(str, sizeof(str),"Администратор [%d] %s телепортировал Вас к себе.", playerid,Name(playerid));
    SendClientMessage(targetid, COLOR_BRIGHTRED, str);
	
    format(str, sizeof(str),"Вы телепортировали игрока [%d] %s к себе.",targetid,Name(targetid));
    SendClientMessage(playerid, COLOR_BRIGHTRED, str);
	return 1;
}

CMD:setweather(playerid, params[])
{    
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
    
	extract params -> new weatherid; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /setweather [ID погоды]");
	
	SetWeather(weatherid);
	return 1;
}

CMD:setvw(playerid, params[])
{    
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
    
	extract params -> new vw; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /setvw [ID виртуального мира]");
	
	SetPlayerVirtualWorld(playerid, vw);
	return 1;
}
CMD:givegun(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	new _playerid, weaponid, bullet;
	
	if(sscanf(params,"udD(1)", _playerid, weaponid, bullet)) 
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /givegun [ID игрока] [ID оружия] [Кол-во патронов]");
	
	if (_playerid == INVALID_PLAYER_ID || gPlayerLogged{_playerid} == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

	if(weaponid > 47 || weaponid < 1 || (19 <= weaponid <= 21))
        return SendClientMessage(playerid, COLOR_GREY,"ID оружия: 1..18, 22..46.");
	
    GivePlayerWeapon(_playerid, weaponid, bullet);
    return true;
}


CMD:chouse1(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	extract params -> new price; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /chouse1 [цена]");

    new Float:x,Float:y,Float:z,Float:a;// Массив для позиции
	
    GetPlayerPos(playerid,x,y,z);// Узнаём позицию игрока
    GetPlayerFacingAngle(playerid,a);// Узнаём угол поворота игрока
	
	new id = Iter_Free(House);
	if(id == ITER_NONE) 
	{
		SendClientMessage(playerid, -1, "Лимит домов исчерпан.");
		return 1;
	}
	Iter_Add(House, id);
	
	HouseInfo[id][hEnterX] = x;
    HouseInfo[id][hEnterY] = y;
    HouseInfo[id][hEnterZ] = z;
    HouseInfo[id][hEnterA] = a;
    HouseInfo[id][hPrice] = price;
    strmid(HouseInfo[id][hOwner], "Angel Pine", 0, 10, 11);
	
	static const
        create_house[] = "INSERT INTO `houses`\
				(`HouseID`,  `Owner`,  `Price`,\
					`EnterX`,  `EnterY`,  `EnterZ`,  `EnterA`)\
		 VALUES\
				('%d', '%s', '%d',\
					'%f', '%f', '%f', '%f')";
	
    new query_string[sizeof(create_house)+4+10+10+10+10+10+11];
	
    mysql_format(mysql_connect_ID, query_string, sizeof(query_string), create_house, 
	
				id, HouseInfo[id][hOwner], HouseInfo[id][hPrice],
					HouseInfo[id][hEnterX], HouseInfo[id][hEnterY], HouseInfo[id][hEnterZ], HouseInfo[id][hEnterA]);
	
    mysql_tquery(mysql_connect_ID, query_string);
	
    HouseEnter[id] = CreatePickup(1273, 23, x, y, z, 0);
	printf("%s", query_string);
	
    return 1;
}
CMD:chouse2(playerid)
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
    new Float:x,Float:y,Float:z,Float:a;// Массив для позиции
	
    GetPlayerPos(playerid,x,y,z);// Узнаём позицию игрока
    GetPlayerFacingAngle(playerid,a);// Узнаём угол поворота игрока
	
	new id = Iter_Last(House);
	
    HouseInfo[id][hExitX] = x;
    HouseInfo[id][hExitY] = y;
    HouseInfo[id][hExitZ] = z;
    HouseInfo[id][hExitA] = a;
    HouseInfo[id][hInt] = GetPlayerInterior(playerid);
    HouseInfo[id][hVirt] = id+1;
    HouseInfo[id][hOwned] = false;
    HouseInfo[id][hLock] = false;
    HouseInfo[id][hAdd] = true;
	
	static const
        create_house[] = "UPDATE `houses` SET \
				`Add` = '%d',\
					`ExitX` = '%f',  `ExitY` = '%f',  `ExitZ` = '%f',  `ExitA` = '%f',\
						`Int` = '%d',	`VirtualWorld` = '%d',\
							`Owned` = '%d',  `Lock` = '%d' \
\
				WHERE 			`HouseID` = '%d'";
	
    new query_string[sizeof(create_house)+1+10+10+10+10+3+4+1+1+3];
		
	mysql_format(mysql_connect_ID, query_string, sizeof(query_string), create_house, 
		
				HouseInfo[id][hAdd],
					HouseInfo[id][hExitX], HouseInfo[id][hExitY], HouseInfo[id][hExitZ], HouseInfo[id][hExitA],
						HouseInfo[id][hInt], HouseInfo[id][hVirt],
							HouseInfo[id][hOwned], HouseInfo[id][hLock],
			
								id);
		
	mysql_tquery(mysql_connect_ID, query_string);
	
	printf("%s", query_string);
	
    HouseExit[id] = CreatePickup(1273, 23, x, y, z, HouseInfo[id][hVirt]);
	
	SetPlayerVirtualWorld(playerid, HouseInfo[id][hVirt]);
    return 1;
}

CMD:center(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	 
	extract params -> new vw, string:desc[64]; else
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
    EnterInfo[LastEnter][eEnterVirt] = vw;
    strmid(EnterInfo[LastEnter][eDesc], desc, 0, strlen(desc), 64);
	
    Create3DTextLabel(EnterInfo[LastEnter][eDesc], COLOR_PROX, EnterInfo[LastEnter][eEnterX], EnterInfo[LastEnter][eEnterY], EnterInfo[LastEnter][eEnterZ], 7.0,
	EnterInfo[LastEnter][eEnterVirt], 0);
	CreatePickup(1272, 23, EnterInfo[LastEnter][eEnterX], EnterInfo[LastEnter][eEnterY], EnterInfo[LastEnter][eEnterZ], EnterInfo[LastEnter][eEnterVirt]);
	
	SetPlayerVirtualWorld(playerid, vw);
	
    //SaveEnter();
    return 1;
}
CMD:cexit(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	extract params -> new vw; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /cexit [Виртуальный мир]");
	
    new Float:x,Float:y,Float:z,Float:a;// Массив для позиции
	
    GetPlayerPos(playerid,x,y,z);// Узнаём позицию игрока
    GetPlayerFacingAngle(playerid,a);// Узнаём угол поворота игрока
	
    EnterInfo[LastEnter][eExitX] = x;
    EnterInfo[LastEnter][eExitY] = y;
    EnterInfo[LastEnter][eExitZ] = z;
    EnterInfo[LastEnter][eExitA] = a;
    EnterInfo[LastEnter][eExitInt] = GetPlayerInterior(playerid);
    EnterInfo[LastEnter][eExitVirt] = vw;
    EnterInfo[LastEnter][eAdd] = 1;
	
	CreatePickup(1272, 23, EnterInfo[LastEnter][eExitX], EnterInfo[LastEnter][eExitY], EnterInfo[LastEnter][eExitZ], EnterInfo[LastEnter][eExitVirt]);
	
	SetPlayerVirtualWorld(playerid, vw);
	
    //SaveEnter();
    return 1;
}

CMD:onlineorg(playerid)
{
    ViewFactions(playerid);
    return 1;
}

CMD:mute(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
    new targetid, minutes;
	
	if(sscanf(params,"uD(10)", targetid, minutes)) 
        return SendClientMessage(playerid, COLOR_GREY, "CMD: /mute [ID игрока] [Кол-во минут]");
	
	if (targetid == INVALID_PLAYER_ID || gPlayerLogged{targetid} == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
	
	p_muted{targetid} = !p_muted{targetid};
	
	static const
        fmt_str[] = "Администратор [%d] %s снял блокировку чата с игрока [%d] %s.",
		fmt_str1[] = "Администратор [%d] %s заблокировал чат игроку [%d] %s на %d минут.";		
		
	SetPVarInt(targetid, "MuteTime", GetTickCount() + minutes * 60000);

    new str[sizeof(fmt_str) - 2 + MAX_PLAYER_NAME - 2 + 3 - 2 + MAX_PLAYER_NAME - 2 + 3 - 2 + 11];
	
    format(str, sizeof(str), p_muted{targetid} ? (fmt_str1) : (fmt_str),  playerid, Name(playerid), targetid, Name(targetid), minutes);
	
	return SendClientMessageToAll(COLOR_RED, str);
}

CMD:editattach(playerid, params[])
{
	extract params -> new id;  else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /editattach [ID слота]");
	
	EditAttachedObject(playerid, id);
	return 1;
}

/////////////////////////////////////////////        ПОЛЬЗОВАТЕЛЬСКИЕ


CMD:hi(playerid, params[])
{
	extract params -> new player:target ; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /hi [ID игрока]");
	
    if (target == INVALID_PLAYER_ID || gPlayerLogged{target} == false)
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

	if(target == playerid)  
		return  SendClientMessage(playerid,COLOR_GREY,"Вы указали свой ID.");
	
	if (IsPlayerNearPlayer(1.5, playerid, target) && !IsPlayerInAnyVehicle(playerid) && !IsPlayerInAnyVehicle(target))
    {		
		new string[15+MAX_PLAYER_NAME * 2];
		
		new Float:x, Float:y, Float:z;
		
		GetPlayerPos(playerid, x, y, z);
		SetPlayerFacingPos(target, x, y);
		
		format(string, sizeof(string),"%s пожимает руку %s.",Name(playerid), Name(target));
		ProxDetector(playerid,COLOR_PROX, string, 4.0);
		
		ApplyAnimation(playerid,"GANGS","hndshkfa",4.0,0,0,0,0,0,1);
		ApplyAnimation(target,"GANGS","hndshkfa",4.0,0,0,0,0,0,1);
	}
	else 
		return SendClientMessage(playerid, COLOR_GREY, "Этот человек далеко от Вас!");
	
	return 1;
}

CMD:report(playerid, params[])
{
    extract params -> new string:message[80] ; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /report [текст вопроса/жалобы]");
	
	static const
			fmt_str0[] = "(REPORT)"COL_ORANGE" от [%d] %s : "COL_WHITE"%s";
		
	new string[145];
	
    format(string, sizeof(string), fmt_str0, playerid, Name(playerid), message);
    MessageToAdmin(COLOR_RED, string);	
    
    return SendClientMessage(playerid, COLOR_GREEN, "Вы успешно отправили сообщение администрации.");
}

CMD:coin(playerid)
{
    if(PlayerInfo[playerid][pMoney] <= 0)
        return SendClientMessage(playerid, COLOR_GREY, "У Вас нет ни одной монеты.");

    static const    coin_str0[] = " подбросил монетку, выпал",
                    coin_str1[] = "а \"решка\".", coin_str2[] = " \"орёл\".";

    new    string[MAX_PLAYER_NAME+(sizeof(coin_str0)-1)+(sizeof(coin_str1)-1)+1];

    strcat(string, Name(playerid));
	strcat(string, coin_str0);
    strcat(string, (random(2)) ? (coin_str1) : (coin_str2));
	
	ProxDetector(playerid,COLOR_PROX, string, 5.0);
    return 1;
}  

CMD:tazer(playerid)
{
	if(PlayerInfo[playerid][pMember] == 2)
	{
		static const tazer_str0[] = " достает электрошокер.", tazer_str1[] = " убирает электрошокер.";

		new string[MAX_PLAYER_NAME+(sizeof(tazer_str0))+1];

		strcat(string, Name(playerid));
		strcat(string, (!tazer_status{playerid}) ? (tazer_str0) : (tazer_str1));
		ProxDetector(playerid,COLOR_PROX, string, 5.0);
		
		if(!tazer_status{playerid})
			SetPlayerAttachedObject(playerid, 0, 18642, 6, 0.06, 0.01, 0.08, 180.0, 0.0, 0.0);
		else
			RemovePlayerAttachedObject(playerid, 0);
		
		tazer_status{playerid} = !tazer_status{playerid};
	}
    return 1;
}  

CMD:cuff(playerid, params[])
{
	if(PlayerInfo[playerid][pMember] == 2)
	{
		extract params -> new player:target ; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /cuff [ID игрока]");
	
		if (target == INVALID_PLAYER_ID || gPlayerLogged{target} == false)
			return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

		if(target == playerid)  
			return  SendClientMessage(playerid,COLOR_GREY,"Вы указали свой ID.");
		
		if (IsPlayerNearPlayer(1.5, playerid, target) && !IsPlayerInAnyVehicle(playerid) && !IsPlayerInAnyVehicle(target))
		{		
			static const cuff_str0[] = " надевает наручники на ", cuff_str1[] = " снимает наручники с ";
			
			new string[MAX_PLAYER_NAME*2 +(sizeof(cuff_str0)) +1];
			
			strcat(string, Name(playerid));
			strcat(string, !cuff_status{target} ? cuff_str0 : cuff_str1);
			strcat(string, Name(target));
			strcat(string, ".");
			
			ProxDetector(playerid,COLOR_PROX, string, 5.0);			
			
			if(!cuff_status{target})
				SetPlayerAttachedObject(target, 0, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977,-81.700035, 0.891999, 1.000000, 1.168000);
			else
				RemovePlayerAttachedObject(target, 0);
			
			SetPlayerSpecialAction(target, !cuff_status{target} ? SPECIAL_ACTION_CUFFED : SPECIAL_ACTION_NONE);
			
			format(string, sizeof(string), "[%d] %s ", playerid, Name(playerid));
			strcat(string, !cuff_status{target} ? "надевает на Вас наручники." : "снимает с Вас наручники.");
			SendClientMessage(target, COLOR_RED, string);
			
			cuff_status{target} = !cuff_status{target};
		}
	}
	return 1;
}

CMD:test(playerid, params[])
{
	extract params -> new id;
	SetPlayerAttachedObject(playerid, 1, id, 1);
	return 1;
}


/////////////////////////////////////////////                    Стоки Стоки Стоки                //////////////////////////////

SaveAccount(playerid)
{
	if(gPlayerLogged{playerid} != true || GetPVarInt(playerid, "IsPlayerSpawn") == 0) return 1;
	
    if(GetTickCount() > updatepositiontimestamp[playerid])
	{
		new Float:x, Float:y, Float:z,Float:fa;
		
		GetPlayerPos(playerid,x,y,z);
		GetPlayerFacingAngle(playerid, fa);
		
		PlayerInfo[playerid][pPos_x] = x;
		PlayerInfo[playerid][pPos_y] = y;
		PlayerInfo[playerid][pPos_z] = z;
		PlayerInfo[playerid][pFa] = fa;
		PlayerInfo[playerid][pInt] = GetPlayerInterior(playerid);
		PlayerInfo[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
		
		static const
        save_account[] = "UPDATE `accounts` SET \
\
				`Money` = '%d', \
					`PosX` = '%f',  `PosY` = '%f',  `PosZ` = '%f',  `Fa` = '%f',\
						`Int` = '%d',	`World` = '%d',\
							`APEDBattery` = '%d',  `Hunger` = '%d',  `Endurance` = '%d', `HP` = '%f'\
\
								WHERE `ID` = '%d'";
	
		new query_string[sizeof(save_account)+100];
		
		mysql_format(mysql_connect_ID, query_string, sizeof(query_string), save_account, 
		
				PlayerInfo[playerid][pMoney],
					PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z], PlayerInfo[playerid][pFa],
						PlayerInfo[playerid][pInt],	PlayerInfo[playerid][pWorld],
							PlayerInfo[playerid][pAPEDBattery],	PlayerInfo[playerid][pHunger], PlayerInfo[playerid][pEndurance], PlayerInfo[playerid][pHP],
				
								PlayerInfo[playerid][pID]);
		
		mysql_tquery(mysql_connect_ID, query_string);
		//printf(query_string);
	}
    return 1;
}


stock CreateNewAccount(playerid, password[], salt[])
{
	static const
        create_account[] = "INSERT INTO `accounts`\
\
				(`Name`,  `Password`,  `Salt`, `Admin`,  `Money`,  `Sex`,  `Skin`,  `Reg`,\
					`PosX`,  `PosY`,  `PosZ`,  `Fa`,  `Int` , `World`,\
						`CarKey`,  `MoneyDolg`,  `Member`,  `Leader`,  `Job`,\
							`MemberSkin`,  `Rank`, `MemberWarn`,  `RankName`,\
								`APED`,  `APEDBattery`,  `Hunger`,  `Endurance`,  `EnduranceMax`,  `HP`,\
									`House`,  `FightStyle`,  `CurrentFightStyle`)\
\
		VALUES ('%s', '%s', '%e', '%d', '%d', '%d', '%d', '%d', 	\
					'%f', '%f', '%f', '%f', '%d', '%d',					\
						'%d', '%d', '%d', '%d', '%d',						\
							'%d', '%d', '%d', '%s',								\
								'%d', '%d', '%d', '%d', '%d', '%f',					\
									'%d', '%d', '%d')";
	
    new query_string[sizeof(create_account)+500+MAX_PLAYER_NAME];
	
    mysql_format(mysql_connect_ID, query_string, sizeof(query_string), create_account, 
	
				PlayerInfo[playerid][pName], password, salt, 0, 100, GetPVarInt(playerid, "Sex"),	GetPVarInt(playerid, "Skin"), 1,
					-2272.7549, -2203.3040, 31.2922, 218.6473, 0, 0,
						0, 0, 0, 0, 0,
							0, 0, 0, " ",
								0, 0, SEVENHOURS, SEVENHOURS, SEVENHOURS, 100.0,
									-1, FIGHT_STYLE_NORMAL, FIGHT_STYLE_NORMAL);
	
    mysql_tquery(mysql_connect_ID, query_string, "UploadPlayerAccountNumber", "i", playerid);
	printf(query_string);
	
	PlayerInfo[playerid][pSex] = GetPVarInt(playerid, "Sex");
	PlayerInfo[playerid][pSkin] = GetPVarInt(playerid, "Skin");
	PlayerInfo[playerid][pMoney] = 100;
	PlayerInfo[playerid][pHP] = 100.0;
	PlayerInfo[playerid][pReg] = 1;		
	PlayerInfo[playerid][pHunger] = SEVENHOURS;
	PlayerInfo[playerid][pEndurance] = SEVENHOURS;	
	PlayerInfo[playerid][pEnduranceMax] = SEVENHOURS;
	PlayerInfo[playerid][pCurrentFightStyle] = FIGHT_STYLE_NORMAL;
	
    SetSkin(playerid);
    return 1;
}

forward UploadPlayerAccountNumber(playerid);
public UploadPlayerAccountNumber(playerid) 
	PlayerInfo[playerid][pID] = cache_insert_id();

forward UploadPlayerAccount(playerid);
public UploadPlayerAccount(playerid)
{
    cache_get_value_name_int(0, "ID", PlayerInfo[playerid][pID]);
	cache_get_value_name_int(0, "Admin", PlayerInfo[playerid][pAdmin]);
	cache_get_value_name_int(0, "Money", PlayerInfo[playerid][pMoney]);
	cache_get_value_name_int(0, "Sex", PlayerInfo[playerid][pSex]);
	cache_get_value_name_int(0, "Skin", PlayerInfo[playerid][pSkin]);
	cache_get_value_name_int(0, "Reg", PlayerInfo[playerid][pReg]);
	cache_get_value_name_float(0, "PosX", PlayerInfo[playerid][pPos_x]);
	cache_get_value_name_float(0, "PosY", PlayerInfo[playerid][pPos_y]);
	cache_get_value_name_float(0, "PosZ", PlayerInfo[playerid][pPos_z]);
	cache_get_value_name_float(0, "Fa", PlayerInfo[playerid][pFa]);
	cache_get_value_name_int(0, "Int", PlayerInfo[playerid][pInt]);
	cache_get_value_name_int(0, "World", PlayerInfo[playerid][pWorld]);
	cache_get_value_name_int(0, "CarKey", PlayerInfo[playerid][pCarKey]);
	cache_get_value_name_int(0, "MoneyDolg", PlayerInfo[playerid][pMoneyDolg]);
	cache_get_value_name_int(0, "Member", PlayerInfo[playerid][pMember]);
	cache_get_value_name_int(0, "Leader", PlayerInfo[playerid][pLeader]);
	cache_get_value_name_int(0, "Job", PlayerInfo[playerid][pJob]);
	cache_get_value_name_int(0, "MemberSkin", PlayerInfo[playerid][pMemberSkin]);
	cache_get_value_name_int(0, "Rank", PlayerInfo[playerid][pRank]);
	cache_get_value_name_int(0, "MemberWarn", PlayerInfo[playerid][pMemberWarn]);
	cache_get_value_name(0, "RankName",PlayerInfo[playerid][pRankName],33);
	cache_get_value_name_int(0, "APED", PlayerInfo[playerid][pAPED]);
	cache_get_value_name_int(0, "APEDBattery", PlayerInfo[playerid][pAPEDBattery]);
	cache_get_value_name_int(0, "Hunger", PlayerInfo[playerid][pHunger]);
	cache_get_value_name_int(0, "Endurance", PlayerInfo[playerid][pEndurance]);
	cache_get_value_name_int(0, "EnduranceMax", PlayerInfo[playerid][pEnduranceMax]);
	cache_get_value_name_float(0, "HP", PlayerInfo[playerid][pHP]);
	cache_get_value_name_int(0, "House", PlayerInfo[playerid][pHouse]);
	cache_get_value_name_int(0, "FightStyle", PlayerInfo[playerid][pFightStyle]);
	cache_get_value_name_int(0, "CurrentFightStyle", PlayerInfo[playerid][pCurrentFightStyle]);
	
	gPlayerLogged{playerid} = true;
	TogglePlayerSpectating(playerid, false);
	PlayerDeath{playerid} = false;
	
	if(PlayerInfo[playerid][pAdmin] > 0)
		Iter_Add(Admins, playerid);
	
	if(PlayerInfo[playerid][pMember] > 0)
		Iter_Add(OrganisationsPlayer[PlayerInfo[playerid][pMember]], playerid);	
	
	new query_string[56+10];
	
	mysql_format(mysql_connect_ID, query_string, sizeof(query_string), "SELECT * FROM `playersinventory` WHERE `PlayerID` = '%d' LIMIT 1",
	PlayerInfo[playerid][pID]);
	mysql_tquery(mysql_connect_ID, query_string, "UplodPlayerInventory", "i", playerid);
	
    return 1;
}

forward UplodPlayerInventory(playerid); 
public UplodPlayerInventory(playerid) 
{ 
    new row_count;
    cache_get_row_count(row_count);
 
    for (new i; i < row_count; i++)
    {
		cache_get_value_name_int(i, "SecondaryWeapon", InventoryInfo[playerid][iSlotSecondaryWeapon]); 
		cache_get_value_name_int(i, "Backpack", InventoryInfo[playerid][iSlotBackpack]);
		cache_get_value_name_int(i, "Armor", InventoryInfo[playerid][iSlotArmor]);
		cache_get_value_name_int(i, "PrimaryWeapon", InventoryInfo[playerid][iSlotPrimaryWeapon]); 
		cache_get_value_name_int(i, "Weapon1", InventoryInfo[playerid][iSlotWeapon][0]);
		cache_get_value_name_int(i, "Weapon2", InventoryInfo[playerid][iSlotWeapon][1]);
		cache_get_value_name_int(i, "Slot1", InventoryInfo[playerid][iSlot][0]); 
		cache_get_value_name_int(i, "Slot2", InventoryInfo[playerid][iSlot][1]); 
		cache_get_value_name_int(i, "Slot3", InventoryInfo[playerid][iSlot][2]); 
		cache_get_value_name_int(i, "Slot4", InventoryInfo[playerid][iSlot][3]); 
		cache_get_value_name_int(i, "Slot5", InventoryInfo[playerid][iSlot][4]); 
		cache_get_value_name_int(i, "Slot6", InventoryInfo[playerid][iSlot][5]); 
		cache_get_value_name_int(i, "Slot7", InventoryInfo[playerid][iSlot][6]); 
		cache_get_value_name_int(i, "Slot8", InventoryInfo[playerid][iSlot][7]); 
		cache_get_value_name_int(i, "Slot9", InventoryInfo[playerid][iSlot][8]); 
		cache_get_value_name_int(i, "Slot10", InventoryInfo[playerid][iSlot][9]); 
		cache_get_value_name_int(i, "Slot11", InventoryInfo[playerid][iSlot][10]); 
		cache_get_value_name_int(i, "Slot12", InventoryInfo[playerid][iSlot][11]); 
		cache_get_value_name_int(i, "Slot13", InventoryInfo[playerid][iSlot][12]); 
		cache_get_value_name_int(i, "Slot14", InventoryInfo[playerid][iSlot][13]); 
		cache_get_value_name_int(i, "Slot15", InventoryInfo[playerid][iSlot][14]); 
		cache_get_value_name_int(i, "Slot16", InventoryInfo[playerid][iSlot][15]);
		cache_get_value_name_int(i, "SlotAmount1", InventoryInfo[playerid][iSlotAmount][0]); 		
		cache_get_value_name_int(i, "SlotAmount2", InventoryInfo[playerid][iSlotAmount][1]); 		
		cache_get_value_name_int(i, "SlotAmount3", InventoryInfo[playerid][iSlotAmount][2]); 		
		cache_get_value_name_int(i, "SlotAmount4", InventoryInfo[playerid][iSlotAmount][3]); 		
		cache_get_value_name_int(i, "SlotAmount5", InventoryInfo[playerid][iSlotAmount][4]); 		
		cache_get_value_name_int(i, "SlotAmount6", InventoryInfo[playerid][iSlotAmount][5]); 		
		cache_get_value_name_int(i, "SlotAmount7", InventoryInfo[playerid][iSlotAmount][6]); 		
		cache_get_value_name_int(i, "SlotAmount8", InventoryInfo[playerid][iSlotAmount][7]); 		
		cache_get_value_name_int(i, "SlotAmount9", InventoryInfo[playerid][iSlotAmount][8]); 		
		cache_get_value_name_int(i, "SlotAmount10", InventoryInfo[playerid][iSlotAmount][9]); 		
		cache_get_value_name_int(i, "SlotAmount11", InventoryInfo[playerid][iSlotAmount][10]); 		
		cache_get_value_name_int(i, "SlotAmount12", InventoryInfo[playerid][iSlotAmount][11]); 		
		cache_get_value_name_int(i, "SlotAmount13", InventoryInfo[playerid][iSlotAmount][12]); 		
		cache_get_value_name_int(i, "SlotAmount14", InventoryInfo[playerid][iSlotAmount][13]); 		
		cache_get_value_name_int(i, "SlotAmount15", InventoryInfo[playerid][iSlotAmount][14]); 		
		cache_get_value_name_int(i, "SlotAmount16", InventoryInfo[playerid][iSlotAmount][15]); 		
    } 
    return 1; 
}  

SaveInventory(playerid)
{
	if(!gPlayerLogged{playerid}) return 1;
			
	static const
		save_inventory[] = "UPDATE `playersinventory` SET \
\
				`SecondaryWeapon` = '%d', `Backpack` = '%d', `Armor` = '%d', `PrimaryWeapon` = '%d', `Weapon1` = '%d', `Weapon2` = '%d', `Slot1` = '%d',\
				`Slot2` = '%d', `Slot3` = '%d', `Slot4` = '%d', `Slot5` = '%d', `Slot6` = '%d', `Slot7` = '%d', `Slot8` = '%d', `Slot9` = '%d',\
				`Slot10` = '%d', `Slot11` = '%d', `Slot12` = '%d', `Slot13` = '%d', `Slot14` = '%d', `Slot15` = '%d', `Slot16` = '%d', `SlotAmount1` = '%d',\
				`SlotAmount2` = '%d', `SlotAmount3` = '%d', `SlotAmount4` = '%d', `SlotAmount5` = '%d', `SlotAmount6` = '%d', `SlotAmount7` = '%d',\
				`SlotAmount8` = '%d', `SlotAmount9` = '%d', `SlotAmount10` = '%d', `SlotAmount11` = '%d', `SlotAmount12` = '%d', `SlotAmount13` = '%d',\
				`SlotAmount14` = '%d', `SlotAmount15` = '%d', `SlotAmount16` = '%d' \
\
								WHERE `PlayerID` = '%d'";
	
	new query_string[sizeof(save_inventory)+5*39 -2*4];
		
	mysql_format(mysql_connect_ID, query_string, sizeof(query_string), save_inventory, 
		
				InventoryInfo[playerid][iSlotSecondaryWeapon], InventoryInfo[playerid][iSlotBackpack], InventoryInfo[playerid][iSlotArmor],
				InventoryInfo[playerid][iSlotPrimaryWeapon], InventoryInfo[playerid][iSlotWeapon][0], InventoryInfo[playerid][iSlotWeapon][1],
				InventoryInfo[playerid][iSlot][0], InventoryInfo[playerid][iSlot][1], InventoryInfo[playerid][iSlot][2], InventoryInfo[playerid][iSlot][3], 
				InventoryInfo[playerid][iSlot][4], InventoryInfo[playerid][iSlot][5], InventoryInfo[playerid][iSlot][6], InventoryInfo[playerid][iSlot][7], 
				InventoryInfo[playerid][iSlot][8], InventoryInfo[playerid][iSlot][9], InventoryInfo[playerid][iSlot][10], InventoryInfo[playerid][iSlot][11], 
				InventoryInfo[playerid][iSlot][12], InventoryInfo[playerid][iSlot][13], InventoryInfo[playerid][iSlot][14], InventoryInfo[playerid][iSlot][15], 
				InventoryInfo[playerid][iSlotAmount][0], InventoryInfo[playerid][iSlotAmount][1], InventoryInfo[playerid][iSlotAmount][2], 
				InventoryInfo[playerid][iSlotAmount][3], InventoryInfo[playerid][iSlotAmount][4], InventoryInfo[playerid][iSlotAmount][5], 
				InventoryInfo[playerid][iSlotAmount][6], InventoryInfo[playerid][iSlotAmount][7], InventoryInfo[playerid][iSlotAmount][8], 
				InventoryInfo[playerid][iSlotAmount][9], InventoryInfo[playerid][iSlotAmount][10], InventoryInfo[playerid][iSlotAmount][11], 
				InventoryInfo[playerid][iSlotAmount][12], InventoryInfo[playerid][iSlotAmount][13], InventoryInfo[playerid][iSlotAmount][14], 
				InventoryInfo[playerid][iSlotAmount][15],
				
								PlayerInfo[playerid][pID]);
		
	mysql_tquery(mysql_connect_ID, query_string);
	printf(query_string);
    return 1;
}

stock NewAccountInventory(playerid)
{
	static const
        create_inventory[] = "INSERT INTO `playersinventory` (`PlayerID`, `SecondaryWeapon`, `Backpack`, `Armor`, `PrimaryWeapon`, `Weapon1`, `Weapon2`, \
		`Slot1`, `Slot2`, `Slot3`, `Slot4`, `Slot5`, `Slot6`, `Slot7`, `Slot8`, `Slot9`, `Slot10`, `Slot11`, `Slot12`, `Slot13`, `Slot14`, `Slot15`, `Slot16`, \
		`SlotAmount1`, `SlotAmount2`, `SlotAmount3`, `SlotAmount4`, `SlotAmount5`, `SlotAmount6`, `SlotAmount7`, `SlotAmount8`, `SlotAmount9`, `SlotAmount10`, \
		`SlotAmount11`, `SlotAmount12`, `SlotAmount13`, `SlotAmount14`, `SlotAmount15`, `SlotAmount16`) \
		VALUES ('%d', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '5087', '0', '0', '0', '0', '0', \
		'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0')"; 
	
    new query_string[sizeof(create_inventory)+6-2];
	
    mysql_format(mysql_connect_ID, query_string, sizeof(query_string), create_inventory, PlayerInfo[playerid][pID]);	
    mysql_tquery(mysql_connect_ID, query_string);
	printf(query_string);
	
	mysql_format(mysql_connect_ID, query_string, sizeof(query_string), "SELECT * FROM `playersinventory` WHERE `PlayerID` = '%d' LIMIT 1",
	PlayerInfo[playerid][pID]);
	mysql_tquery(mysql_connect_ID, query_string, "UplodPlayerInventory", "i", playerid);
	printf(query_string);
	
    return 1;
}

forward LoadHouses();
public LoadHouses()
{
	new row_count;
    cache_get_row_count(row_count);
 
    if(row_count > MAX_APED)// Проверка нужна как раз на случай, если ты решишь изменить значение MAX_APED и укажешь его меньше, чем есть домов в базе
    {
        row_count = MAX_APED;
        print("Warning: Часть домов не загрузилась");
    }
 
    for (new i, h; i < row_count; i++)
    {		
			cache_get_value_name_int(i, "HouseID", h);
			cache_get_value_name_int(i, "Add", HouseInfo[h][hAdd]);
			cache_get_value_name(i, "Owner", HouseInfo[h][hOwner]);
			cache_get_value_name_int(i, "Price", HouseInfo[h][hPrice]);
			cache_get_value_name_float(i, "EnterX", HouseInfo[h][hEnterX]);
			cache_get_value_name_float(i, "EnterY", HouseInfo[h][hEnterY]);
			cache_get_value_name_float(i, "EnterZ", HouseInfo[h][hEnterZ]);
			cache_get_value_name_float(i, "EnterA", HouseInfo[h][hEnterA]);
			cache_get_value_name_float(i, "ExitX", HouseInfo[h][hExitX]);
			cache_get_value_name_float(i, "ExitY", HouseInfo[h][hExitY]);
			cache_get_value_name_float(i, "ExitZ", HouseInfo[h][hExitZ]);
			cache_get_value_name_float(i, "ExitA", HouseInfo[h][hExitA]);
			cache_get_value_name_int(i, "Int", HouseInfo[h][hInt]);
			cache_get_value_name_int(i, "VirtualWorld", HouseInfo[h][hVirt]);
			cache_get_value_name_int(i, "Owned", HouseInfo[h][hOwned]);
			cache_get_value_name_int(i, "Lock", HouseInfo[h][hLock]);
			
			HouseEnterPickupID[i] = CreatePickup(1273, 23, HouseInfo[h][hEnterX], HouseInfo[h][hEnterY], HouseInfo[h][hEnterZ], 0);
			HouseExitPickupID[i] = CreatePickup(1273, 23, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ], HouseInfo[h][hVirt]);
			
			Iter_Add(House, h);
			
			
	}
	print(" "); printf("---=== %d houses loaded. ===---", Iter_Count(House)); print(" ");
	return 1;
}


forward LoadEnters();
public LoadEnters()
{
	new row_count;
    cache_get_row_count(row_count);
 
    if(row_count > MAX_ENTERS)
    {
        row_count = MAX_ENTERS;
        print("Warning: Часть входов не загрузилась");
    }
 
    for (new i, e; i < row_count; i++)
    {		
			cache_get_value_name_int(i, "EnterID", e);
			cache_get_value_name_int(i, "Add", EnterInfo[e][eAdd]);
			cache_get_value_name_float(i, "EnterX", EnterInfo[e][eEnterX]);
			cache_get_value_name_float(i, "EnterY", EnterInfo[e][eEnterY]);
			cache_get_value_name_float(i, "EnterZ", EnterInfo[e][eEnterZ]);
			cache_get_value_name_float(i, "EnterA", EnterInfo[e][eEnterA]);
			cache_get_value_name_float(i, "ExitX", EnterInfo[e][eExitX]);
			cache_get_value_name_float(i, "ExitY", EnterInfo[e][eExitY]);
			cache_get_value_name_float(i, "ExitZ", EnterInfo[e][eExitZ]);
			cache_get_value_name_float(i, "ExitA", EnterInfo[e][eExitA]);
			cache_get_value_name_int(i, "EnterInt", EnterInfo[e][eEnterInt]);
			cache_get_value_name_int(i, "EnterVirt", EnterInfo[e][eEnterVirt]);
			cache_get_value_name_int(i, "ExitInt", EnterInfo[e][eExitInt]);
			cache_get_value_name_int(i, "ExitVirt", EnterInfo[e][eExitVirt]);
			cache_get_value_name(i, "Desc", EnterInfo[e][eDesc]);
			
         	Create3DTextLabel(EnterInfo[i][eDesc], COLOR_PROX, EnterInfo[i][eEnterX], EnterInfo[i][eEnterY], EnterInfo[i][eEnterZ] + 0.5,
			7.0,  EnterInfo[i][eEnterVirt], 0);
			EnterPickupID[i] = CreatePickup(1272, 23, EnterInfo[i][eEnterX], EnterInfo[i][eEnterY], EnterInfo[i][eEnterZ], EnterInfo[i][eEnterVirt]);
			ExitPickupID[i] = CreatePickup(1272, 23, EnterInfo[i][eExitX], EnterInfo[i][eExitY], EnterInfo[i][eExitZ], EnterInfo[i][eExitVirt]);
			
			Iter_Add(Enters, e);			
	}
	print(" "); printf("---=== %d enters loaded. ===---", Iter_Count(Enters)); print(" ");
	return 1;
}

SaveOneVeh(vehicleid)
{
	new Float:x, Float:y, Float:z, Float:za, Float:VHP;
			
	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, za);	

	GetVehicleHealth(vehicleid, VHP);	
	
	VehInfo[vehicleid][vVPosX] = x;
	VehInfo[vehicleid][vVPosY] = y;
	VehInfo[vehicleid][vVPosZ] = z;
	VehInfo[vehicleid][vVZa] = za;
	VehInfo[vehicleid][vHP] = VHP;		
	
	static const
		save_veh[] = "UPDATE `vehicles` SET \
				`VPosX` = '%f', `VPosY` = '%f',  `VPosZ` = '%f',  `VZa` = '%f', `VHP` = '%f' \
					WHERE `ID` = '%d'";
	
	new query_string[sizeof(save_veh)-12+63+15];
			
	mysql_format(mysql_connect_ID, query_string, sizeof(query_string), save_veh, 
			
				VehInfo[vehicleid][vVPosX],	VehInfo[vehicleid][vVPosY],	VehInfo[vehicleid][vVPosZ],	VehInfo[vehicleid][vVZa], VehInfo[vehicleid][vHP],
				
					vehicleid);
			
	mysql_tquery(mysql_connect_ID, query_string);
	printf(query_string);
	
	return 1;
}


forward LoadVeh();
public LoadVeh()
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
  	{
 		new v;
		while(LastCar < rows)
		{
			cache_get_value_name_int(LastCar, "ID", v);
			cache_get_value_name_int(LastCar, "Add", VehInfo[v][vAdd]);
			cache_get_value_name_int(LastCar, "Model", VehInfo[v][vModel]);
			cache_get_value_name_float(LastCar, "VPosX", VehInfo[v][vVPosX]);
			cache_get_value_name_float(LastCar, "VPosY", VehInfo[v][vVPosY]);
			cache_get_value_name_float(LastCar, "VPosZ", VehInfo[v][vVPosZ]);
			cache_get_value_name_float(LastCar, "VZa", VehInfo[v][vVZa]);
			cache_get_value_name_int(LastCar, "Color1", VehInfo[v][vColor1]);
			cache_get_value_name_int(LastCar, "Color2", VehInfo[v][vColor2]);
			cache_get_value_name(LastCar, "Owner", VehInfo[v][vOwner]);
			cache_get_value_name_int(LastCar, "Price", VehInfo[v][vPrice]);
			cache_get_value_name_int(LastCar, "Buy", VehInfo[v][vBuy]);
			cache_get_value_name_int(LastCar, "Lock", VehInfo[v][vLock]);
			cache_get_value_name_int(LastCar, "Fuel", VehInfo[v][vFuel]);
			cache_get_value_name_float(LastCar, "VHP", VehInfo[v][vHP]);
			
			AddStaticVehicleEx(VehInfo[v][vModel],VehInfo[v][vVPosX],VehInfo[v][vVPosY],VehInfo[v][vVPosZ],VehInfo[v][vVZa],
			VehInfo[v][vColor1],VehInfo[v][vColor2], 60000);
			LastCar++;
			
			if (VehInfo[v][vFuel] < 0) VehInfo[v][vFuel] = 0;
			if (VehInfo[v][vFuel] > 100) VehInfo[v][vFuel] = 100;
			if (VehInfo[v][vHP] < 1) VehInfo[v][vHP] = 1000.0;
			
			SetVehicleParamsEx(v,false,false,false,VehInfo[v][vLock],false,false,false);
			SetVehicleHealth(v, VehInfo[v][vHP]);
			Engine{v} = false;
			
			VehPosX[v] = VehInfo[v][vVPosX];
			VehPosY[v] = VehInfo[v][vVPosY];
			VehPosZ[v] = VehInfo[v][vVPosZ];
			VehPosA[v] = VehInfo[v][vVZa];
			
			
			if(VehInfo[v][vAdd] == 1 && VehInfo[v][vBuy] == VBUYTOBUY)
			{
				static const
					fmt_str0[] = "Продается\nСтоимость: "COL_GREEN"%i $";
					
				new string[sizeof(fmt_str0) + (-2+10)];
				
				format(string, sizeof(string), fmt_str0 ,VehInfo[v][vPrice]);
				sellVehInfo[v] = Create3DTextLabel( string, COLOR_PROX, 0, 0, 0, 5.0, 0, 0 );
				Attach3DTextLabelToVehicle(Text3D:sellVehInfo[v], v, 0.0, 0.0, 0.8);
			}
		}
		print(" "); printf("---=== %d vehicles loaded. ===---", LastCar); print(" ");
	}
	return 1;
}

forward LoadAPED();
public LoadAPED()
{
	new row_count;
    cache_get_row_count(row_count);
 
    if(row_count > MAX_APED)// Проверка нужна как раз на случай, если ты решишь изменить значение MAX_APED и укажешь его меньше, чем есть домов в базе
    {
        row_count = MAX_APED;
        print("Warning: Часть APED не загрузилась");
    }
 
    for (new i, idx; i < row_count; i++)
    {
			cache_get_value_name_int(i, "APEDID", idx);
			cache_get_value_name_int(i, "PlayerID", APEDInfo[idx][aPlayerID]);
			cache_get_value_name_float(i, "PosX", APEDInfo[idx][aPosX]);
			cache_get_value_name_float(i, "PosY", APEDInfo[idx][aPosY]);
			cache_get_value_name_float(i, "PosZ", APEDInfo[idx][aPosZ]);
			cache_get_value_name_int(i, "VirtualWorld", APEDInfo[idx][aVW]);
			cache_get_value_name_int(i, "Battery", APEDInfo[idx][aBattery]);
			
			/*printf("%d, %d, %f, %f, %f, %d, %d", idx, APEDInfo[idx][aPlayerID], APEDInfo[idx][aPosX], APEDInfo[idx][aPosY], APEDInfo[idx][aPosZ],
			APEDInfo[idx][aVW], APEDInfo[idx][aBattery]);*/
			
			Iter_Add(APED, idx);
			
			apedpickup[idx] = CreatePickup(1575, 23, APEDInfo[idx][aPosX], APEDInfo[idx][aPosY], APEDInfo[idx][aPosZ], APEDInfo[idx][aVW]);
						
			new str[48+3], 
				battery = floatround(APEDInfo[idx][aBattery] * 100 / TENHOURS, floatround_ceil);		
						
			format(str, sizeof(str), "APED заряжается\nЗаряд батереи: "COL_GREEN"%d %%", battery);
			aped[idx] = Create3DTextLabel(str, COLOR_WHITE, APEDInfo[idx][aPosX], APEDInfo[idx][aPosY],	APEDInfo[idx][aPosZ], 1.0, APEDInfo[idx][aVW], 0);
	}
	print(" "); printf("---=== %d APED loaded. ===---", Iter_Count(APED)); print(" ");
	return 1;
}

/*SaveWood()
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

SavePurse()
{
	new iniFile = ini_openFile("Purse.ini");
 	ini_setInteger(iniFile,"Purse", purse);
 	ini_closeFile(iniFile);
	return true;
}

LoadPurse()
{
	new iniFile = ini_openFile("Purse.ini");
 	ini_getInteger(iniFile,"Purse",purse);
  	ini_closeFile(iniFile);
  	return true;
}*/

WriteLogByTypeName(const type_name[], account_id, target_id, const log_message[])
{
    static 
        string[159+11+144+10+1];

    string[0] = '\0';
    format(string, sizeof(string), 
        "\
            INSERT INTO logs (PlayerID, TypeID, TargetID, Message, Date) \
                SELECT %d, lt.LogTypeID, %d, '%s', NOW() FROM log_type as lt WHERE LogTypeName = '%s'\
        ", 
            account_id,
			target_id,
            log_message,
            type_name);
    mysql_tquery(mysql_connect_ID, string);
	
	printf("%s", string);
    return 1;
} 

UpdateDataInt(ID, const table_name[], const field_name[], value)
{
    static
        query_string[37+64+11+10+1];
    mysql_format(mysql_connect_ID, query_string, sizeof(query_string), "UPDATE %s SET `%s` = %d WHERE ID = %d", table_name, field_name, value, ID);
    mysql_tquery(mysql_connect_ID, query_string);
	printf("%s", query_string);
    return 1;
} 

UpdateDataIntWithChoiseID(ID, const table_name[], const field_name[], const column_name[], value)
{
    static
        query_string[37+64+11+10+1];
    mysql_format(mysql_connect_ID, query_string, sizeof(query_string), "	UPDATE %s SET `%s` = %d WHERE `%s` = %d",
																			table_name, field_name, value, column_name, ID);
    mysql_tquery(mysql_connect_ID, query_string);
	printf("%s", query_string);
    return 1;
} 

UpdateDataVarchar(ID, const table_name[], const field_name[], value[])
{
    static
        query_string[37+64+11+10+1];
    mysql_format(mysql_connect_ID, query_string, sizeof(query_string), "UPDATE %s SET `%s` = '%s' WHERE ID = %d", table_name, field_name, value, ID);
    mysql_tquery(mysql_connect_ID, query_string); 
	printf("%s", query_string);
    return 1;
}  

UpdateDataVarcharWithChoiseID(ID, const table_name[], const field_name[], const column_name[], value[])
{
    static
        query_string[37+64+11+10+1];
    mysql_format(mysql_connect_ID, query_string, sizeof(query_string), 		"UPDATE %s SET `%s` = '%s' WHERE `%s` = %d", 
																			table_name, field_name, value, column_name, ID);
    mysql_tquery(mysql_connect_ID, query_string); 
	printf("%s", query_string);
    return 1;
}  

UpdateDataFloat(ID, const table_name[], const field_name[], Float:value)
{
    static
        query_string[37+64+11+10+1];
    mysql_format(mysql_connect_ID, query_string, sizeof(query_string), "UPDATE %s SET `%s` = '%f' WHERE ID = %d", table_name, field_name, value, ID);
    mysql_tquery(mysql_connect_ID, query_string);
	printf("%s", query_string);	
    return 1;
} 

MessageToAdmin(color, const string[])
{
    foreach(Admins, i)
		SendClientMessage(i, color, string);
    return 1;
}

PreloadAnimLib(playerid, const animlib[])
    ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);

ProxDetector(playerid, color, const string[], Float:max_range, Float:max_ratio = 1.6)
{
    new
        Float:pos_x,
        Float:pos_y,
        Float:pos_z,
        Float:range,
        Float:range_ratio,
        Float:range_with_ratio,
        clr_r, clr_g, clr_b,
        Float:color_r, Float:color_g, Float:color_b;
 
    if (!GetPlayerPos(playerid, pos_x, pos_y, pos_z)) {
        return 0;
    }
 
    color_r = float(color >> 24 & 0xFF);
    color_g = float(color >> 16 & 0xFF);
    color_b = float(color >> 8 & 0xFF);
    range_with_ratio = max_range * max_ratio;
 
    foreach (new i : Player) {
        if (!IsPlayerStreamedIn(playerid, i)) {
            continue;
        }
 
        range = GetPlayerDistanceFromPoint(i, pos_x, pos_y, pos_z);
        if (range > max_range) {
            continue;
        }
 
        range_ratio = (range_with_ratio - range) / range_with_ratio;
        clr_r = floatround(range_ratio * color_r);
        clr_g = floatround(range_ratio * color_g);
        clr_b = floatround(range_ratio * color_b);
 
        SendClientMessage(i, (color & 0xFF) | (clr_b << 8) | (clr_g << 16) | (clr_r << 24), string);
    }
 
    SendClientMessage(playerid, color, string);
    return 1;
}

GetAroundPlayerVehicleID(playerid, Float:radius)
{
    new Float:vp[3],vehid = 0;
    foreach(Vehicle, i)
    {
        GetVehiclePos(i,vp[0],vp[1],vp[2]);
        if(IsPlayerInRangeOfPoint(playerid,radius,vp[0],vp[1],vp[2])) {
            vehid = i;
            break;
        }
    }
    return vehid;
}   

SetPlayerFacingPos(playerid, Float:x, Float:y)
{// by Daniel_Cortez \\ pro-pawn.ru
    static Float:ax, Float:ay, Float:az;
    if(GetPlayerPos(playerid, ax, ay, az) == 0)
        return 0;
    return SetPlayerFacingAngle(playerid, atan2(y-ay, x-ax)-90.00);
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
        if((strcmp(animlib, "PED", true) == 0) && strcmp(animname, "IDLE_stance", true) == 0 ||
		((strcmp(animlib, "PED", true) == 0) && strcmp(animname, "CLIMB_jump2fall", true) == 0) ||
		((strcmp(animlib, "PED", true) == 0) && strcmp(animname, "CLIMB_Stand_finish", true) == 0) ||
		((strcmp(animlib, "PED", true) == 0) && strcmp(animname, "FALL_land", true) == 0) ||
		((strcmp(animlib, "PED", true) == 0) && strcmp(animname, "FALL_collapse", true) == 0))
		
		return 1;
    }
    return 0;
}

IsPlayerRun(playerid)
{
    new Keys,ud,lr;
	GetPlayerKeys(playerid,Keys,ud,lr);
	
	if((lr == KEY_RIGHT || lr == KEY_LEFT || ud == KEY_DOWN || ud == KEY_UP) && PlayerRun{playerid} == true && !IsPlayerInAnyVehicle(playerid))
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

IsPlayerInArmor(playerid)
{
	new ArmorSkinID[5] = {25010, 25011, 25012, 25027, 25028};
	
	for(new i; i < 5; i++)
	{
		if(GetPlayerCustomSkin(playerid) == ArmorSkinID[i])
			return 1;
	}
	return 0;
}

IsPlayerInZone(playerid)
{
	if((IsPlayerInDynamicArea(playerid, LSZone) || IsPlayerInDynamicArea(playerid, SFZone) || IsPlayerInDynamicArea(playerid, LVZone)) && 
	GetPlayerInterior(playerid) == 0)
			return 1;
	return 0;
}

GetWeaponModel(weaponid)
{
        switch(weaponid)
        {
            case 1:			return 331; 
			case 2..8:		return weaponid+331; 
			case 9:			return 341; 
			case 10..15:	return weaponid+311; 
			case 16..18:	return weaponid+326;
			case 22..29:	return weaponid+324;
			case 30,31:		return weaponid+325;
			case 32:		return 372;
			case 33..45:	return weaponid+324;
			case 46:		return 371;
        }
        return 0;
}

GetWeaponIDFromModel(modelid)
{
	switch(modelid)
	{
		case 331: return 1; case 333: return 2; case 334: return 3;
		case 335: return 4; case 336: return 5; case 337: return 6;
		case 338: return 7; case 339: return 8; case 341: return 9;
		case 321: return 11; case 322: return 11; case 323: return 12;
		case 324: return 13; case 325: return 14; case 326: return 15;
		case 342: return 16; case 343: return 17; case 344: return 18;
		case 346: return 22; case 347: return 23; case 348: return 24;
		case 349: return 25; case 350: return 26; case 351: return 27;
		case 352: return 28; case 353: return 29; case 355: return 30;
		case 356: return 31; case 372: return 32; case 357: return 33; 
		case 358: return 34; case 359: return 35; case 360: return 36;
		case 361: return 37; case 362: return 38; case 363: return 39;
		case 365: return 41; case 366: return 42; case 371: return 46;
	}
	return -1;
}

GetTypeSlotFromModel(modelid)
{
	new secondaryWeaponModelID[6] = {346, 347, 348, 350, 352, 372};
	new backpackModelID[2] = {371, 19559};
	new armorModelID[3] = {373, 19515, 1242};
	new primaryWeaponModelID[7] = {349, 351, 353, 355, 356, 357, 358};
	new meleeWeaponModelID[11] = {326, 331, 333, 334, 335, 336, 337, 338, 339, 365, 367};
	
	
	for(new i; i < sizeof secondaryWeaponModelID; i++)
		if(modelid == secondaryWeaponModelID[i]) 		return TypeSecondaryWeapon;
	
	for(new i; i < sizeof backpackModelID; i++)
		if(modelid == backpackModelID[i]) 				return TypeBackpack;
	
	for(new i; i < sizeof armorModelID; i++)
		if(modelid == armorModelID[i]) 					return TypeArmor;
	
	for(new i; i < sizeof meleeWeaponModelID; i++)
		if(modelid == meleeWeaponModelID[i]) 			return TypeMelee;
	
	if(modelid == 2040) 								return TypeAmmo;
	
	return TypeSlot;
}


TypeVehicle (model)
{
    if ( 400 > model > 611 ) return -1;
    switch (model)
    {
        case 509,481,510: return 4; // bicycle
        case 461..463,448,581,521..523,586,468,471: return 3; // moto
        case 417,425,447,469,487,488,497,548,563: return 5; // heli
        case 460,476,511..513,519,520,553,577,592,593: return 6; // airplane
        case 435,450,569,570,584,590,591,606..608,610,611: return 7; // прицеп
        case 472,473,493,595,484,430,453,452,446,454: return 8; // boat
        case 499,498,609,524,578,455,403,414,443,514,515,408,456,433: return 2; // heavy
        case 441,464,465,501,564,594: return 9; // RC
        default: return 1; // auto
    }
    return -1;
}

IsAtCafe(playerid)
{
    for(new i=0; i < sizeof(ShopCoordsInfo); i++)
        if(IsPlayerInRangeOfPoint(playerid, 2.0, ShopCoordsInfo[i][shX], ShopCoordsInfo[i][shY], ShopCoordsInfo[i][shZ]))
            return 1;
    return 0;
} 

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
	new
	    Float:x,
	    Float:y,
	    Float:z,
		vel;

	GetVehicleVelocity( vehicleid, x, y, z );

	vel = floatround( floatsqroot( x*x + y*y + z*z ) * 180 );			// KM/H
//	vel = floatround( floatsqroot( x*x + y*y + z*z ) * 180 / 1.609344 ); // MPH

	return vel;
}

IsAtGasStation(playerid)
{
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
	"COL_WHITE"[4] "COL_BLUE"Сделать выговор\n\
	"COL_WHITE"[5] "COL_BLUE"Снять выговор\n\
	"COL_WHITE"[6] "COL_BLUE"Установить ранг\n\
	"COL_WHITE"[7] "COL_BLUE"Установить скин\n\
	", "Выбрать", "Назад");
	return true;
}

ShowPlayerHouseDialog(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_ID_HOUSEFUNCTION, D_S_L, ""COL_ORANGE"Действия в доме", "\
	"COL_WHITE"[1] "COL_BLUE"Поспать\n\
	"COL_WHITE"[2] "COL_BLUE"Покушать\n\
	"COL_WHITE"[3] "COL_BLUE"Зарядить APED\n\
	", "Выбрать", "Выйти");
	return true;
}

ShowPlayerGymDialog(playerid)
{
	static GymDialog[] = 
			""COL_WHITE"[1] "COL_BLUE"%s: \t"COL_GREEN"%d$\n\
			"COL_WHITE"[2] "COL_BLUE"%s: \t"COL_GREEN"%d$";
			
	new string[128];
				
	format(string, sizeof(string), GymDialog, GymInfo[0][GymAction], GymInfo[0][GymActionPrice], GymInfo[1][GymAction], GymInfo[1][GymActionPrice]);
	ShowPlayerDialog(playerid, DIALOG_ID_GYMBUY, D_S_T,""COL_ORANGE"Что Вас интересует?", string, "Выбрать", "Выход");
	return true;
}

ShowPlayerFightStyleDialog(playerid)
{
	new string[(26+15)*6],
		string1[(26+15)*6];
	
    for(new i; i < sizeof(fighting_style); i++)
	{
        format(string, sizeof(string), ""COL_WHITE"[%d] "COL_BLUE"%s\n", i+1, fighting_style[i][fsName]);
        strcat(string1, string, sizeof(string1)); 
    } 
    format(string, sizeof(string), "%s", string1);  	
		
    return ShowPlayerDialog(playerid, DIALOG_ID_GYMBUYFS, D_S_L,""COL_ORANGE"Выберите стиль боя, который Вы хотите изучить:", string, "Выбрать", "Назад");
}

ShowPlayerAdminDialog(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_ID_ADMINMENU, D_S_L, ""COL_ORANGE"Меню администратора", "\
	"COL_WHITE"[1] "COL_BLUE"Телепорт по местам\n\
	", "Выбрать", "Назад");
	return true;
}

ShowPlayerAPEDSettingsDialog(playerid)
{
	static D36[] = 
			""COL_BLUE"Функция: \t"COL_WHITE"Состояние:"\
			"\n"COL_BLUE"Показывать карту: \t%s";
			
	new d36[128],
		status2[20];
		
	status2 = (MapIsOn{playerid} == true) ?  (""COL_STATUS1"Включено") : (""COL_STATUS6"Выключено");
				
	format(d36, sizeof(d36), D36, status2);
	ShowPlayerDialog(playerid, DIALOG_ID_APEDSETTINGS, D_S_TH,""COL_ORANGE"Настройки APED",d36,"Выбрать","Назад");
	return true;
}

ShowPlayerPlayerInfoDialog(playerid)
{
	static D35[] = 
			" \t "\
			"\n"COL_BLUE"Сытость: \t%s"\
			"\n"COL_BLUE"Усталость: \t%s"\
			"\n"COL_BLUE"Состояние здоровья: \t%s"\
			"\n\t"\
			"\n"COL_BLUE"Наличные: \t"COL_GREEN"%d $"\
			"\n"COL_BLUE"Ключи от автомобиля №: \t %s"\
			"\n"COL_BLUE"Ключи от дома №: \t %s"\
			"\n"COL_BLUE"Организация: \t%s";
			
	new d35[24+26+35+38+38+28 + 10 + MAX_FRACTION_NAME_LENGTH +37+39+24+33],
		d36[69-6+4],
		hunger[37],
		endurance[39],
		healths[24],
		money,
		carkey[4],
		org[MAX_FRACTION_NAME_LENGTH],
		Float:health,
		Float:battery,
		house[4];
		
    GetPlayerHealth(playerid,health);
	
	battery = floatround(PlayerInfo[playerid][pAPEDBattery] / 360, floatround_ceil);
	
	money = PlayerInfo[playerid][pMoney];
	
	if(PlayerInfo[playerid][pCarKey] > 0)
		valstr(carkey, PlayerInfo[playerid][pCarKey]);
	else
		carkey = " ";
	
	if(PlayerInfo[playerid][pHouse] >= 0)
		valstr(house, PlayerInfo[playerid][pHouse]);
	else
		house = " ";
	
	if(PlayerInfo[playerid][pMember] > 0)
		org = fraction_name[PlayerInfo[playerid][pMember]];
	else
		org = " ";
	
	static D36[] = ""COL_ORANGE"Меню APED.          Заряд батареи: "COL_WHITE"[ %.0f %% ]";
			
	if(health >= 100.0) healths = ""COL_STATUS1"Отличное";
	if(80.0 <= health < 100.0) healths = ""COL_STATUS2"Хорошее";
	if(50.0 <= health < 80.0) healths = ""COL_STATUS3"Среднее";
	if(11.0 <= health < 50.0) healths = ""COL_STATUS5"Плохое";
	if(0.0 < health < 11.0) healths = ""COL_STATUS6"Критическое";
		
	if(0 < PlayerInfo[playerid][pHunger] <= ONEHOURS) hunger = ""COL_STATUS6"Голодание";
	if(ONEHOURS < PlayerInfo[playerid][pHunger] <= TWOHOURS)  hunger = ""COL_STATUS5"Жутко голоден";
	if(TWOHOURS < PlayerInfo[playerid][pHunger] <= THREEHOURS) hunger = ""COL_STATUS4"Нужно плотно поесть";
	if(THREEHOURS < PlayerInfo[playerid][pHunger] <= FOURHOURS) hunger = ""COL_STATUS3"Нужно поесть";
	if(FOURHOURS < PlayerInfo[playerid][pHunger] <= SIXHOURS) hunger = ""COL_STATUS2"Нужно немного перекусить";
	if(SIXHOURS < PlayerInfo[playerid][pHunger] <= SEVENHOURS) hunger = ""COL_STATUS1"Сыт";
	
	if(0 < PlayerInfo[playerid][pEndurance] <=ONEHOURS) endurance = ""COL_STATUS6"Переутомление";
	if(ONEHOURS < PlayerInfo[playerid][pEndurance] <= TWOHOURS)  endurance = ""COL_STATUS5"Недосыпание";
	if(TWOHOURS < PlayerInfo[playerid][pEndurance] <= THREEHOURS) endurance = ""COL_STATUS4"Нужно поспать";
	if(THREEHOURS < PlayerInfo[playerid][pEndurance] <= FOURHOURS) endurance = ""COL_STATUS3"Нужно отдохнуть";
	if(FOURHOURS < PlayerInfo[playerid][pEndurance] <= SIXHOURS) endurance = ""COL_STATUS2"Нужно немного расслабиться";
	if(SIXHOURS < PlayerInfo[playerid][pEndurance]) endurance = ""COL_STATUS1"Полон сил";
				
	format(d35, sizeof(d35), D35, hunger, endurance, healths, money, carkey, house, org);
	format(d36, sizeof(d36), D36, battery);
	ShowPlayerDialog(playerid, DIALOG_ID_PLAYERINFODIALOG, D_S_T, d36, d35, "Выйти", "Назад");
	return 1;
}

ShowPlayerVehicleDialog(playerid)
{
	new carid = GetAroundPlayerVehicleID(playerid, 4.0);
	GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
	GetVehicleParamsCarWindows(carid, driver, passenger, backleft, backright);
	
	static D37[] = 
				""COL_BLUE"Функция: \t"COL_WHITE"Состояние:"\
				"\n"COL_BLUE"Двигатель: \t%s"\
				"\n"COL_BLUE"Фары: \t%s"\
				"\n"COL_BLUE"Сигнализация: \t%s%s";
				
	static D44[] = 
				"\n"COL_BLUE"Двери: \t%s"\			
				"\n"COL_BLUE"Капот: \t%s"\
				"\n"COL_BLUE"Багажник: \t%s"\
				"\n"COL_BLUE"Поиск автомобиля по GPS: \t%s"\
				"\n"COL_BLUE"Окна: \t%s";
				
	new d38[42-4+4+20+1],
		status1[21], status2[22], status3[25], status4[27], status5[19], status6[19], status7[24], status8[24],
		d37[42+(25+21)+(20+22)+(28+25) + (20+27)+(20+19)+(21+19)+(36+24)+(17+24)],
		d44[(20+27)+(20+19)+(21+19)+(36+24)+(17+24)];
				
	static D38[] = ""COL_ORANGE"Состояние транспорта: "COL_WHITE"[ID:%d] %s";
		
	status1 = (engine) ?  (""COL_STATUS1"Заведен") : (""COL_STATUS6"Заглушен");
	status2 = (lights) ?  (""COL_STATUS1"Включены") : (""COL_STATUS6"Выключены");
	status3 = (alarm) ?  (""COL_STATUS1"Активирована") : (""COL_STATUS6"Отключена");
	status4 = (doors) ?  (""COL_STATUS6"Закрыты") : (""COL_STATUS1"Открыты");
	status5 = (bonnet) ?  (""COL_STATUS1"Открыт") : (""COL_STATUS6"Закрыт");
	status6 = (boot) ?  (""COL_STATUS1"Открыт") : (""COL_STATUS6"Закрыт");
	status7 = (objective) ?  (""COL_STATUS1"Активирован") : (""COL_STATUS6"Отключен");
	status8 = (!driver) ?  (""COL_STATUS1"Открыты") : (""COL_STATUS6"Закрыты");
	
	if(TypeVehicle(GetVehicleModel(carid)) == 1 || TypeVehicle(GetVehicleModel(carid)) == 2)
	{
		format(d44, sizeof(d44), D44, status4, status5, status6, status7, status8);
		strcat(d44, d37, sizeof(d44)); 
	} 
		
	format(d37, sizeof(d37), D37, status1, status2, status3, d44);
	format(d38, sizeof(d38), D38, carid, VehicleNames[GetVehicleModel(carid)-400]);	
	ShowPlayerDialog(playerid, DIALOG_ID_VMENU, D_S_TH, d38, d37, "Выбрать", "Выход");
	
	return 1;
}

ShowCafeDialog(playerid)
{
    new string[44*MAX_SHOP_FOOD_ITEMS],
		string1[44*MAX_SHOP_FOOD_ITEMS];
	
    for(new i; i < sizeof(ShopFoodInfo); i++)
	{
        format(string, sizeof(string), ""COL_BLUE"%s\t "COL_GREEN"%d $\n", ShopFoodInfo[i][FoodName], ShopFoodInfo[i][FoodPrice]);
        strcat(string1, string, sizeof(string1)); 
    } 
    format(string, sizeof(string), ""COL_BLUE"Меню\t"COL_WHITE"Стоимость\n%s", string1);  	
		
    return ShowPlayerDialog(playerid, DIALOG_ID_SHOPFOOD, D_S_TH,""COL_ORANGE"Покупка еды", string, "Купить", "Отмена");
}



SetPlayerPosCW(playerid, Float:x, Float:y, Float:z, Float:a, i, v)
{
	if(!IsPlayerBlackScreen{playerid})
	{	
		ShowFonForPlayer(playerid);
		
		IsPlayerBlackScreen{playerid} = true;
		
		TogglePlayerControllable(playerid, false);		
		SetTimerEx("TeleportCW", 500, 0, "iffffdd", playerid, x, y, z, a, i, v);
	}
    return 1;
}

ShowFonForPlayer(playerid) 
{ 
    if(!FonBox{playerid}) 
    { 
		TogglePlayerControllable(playerid, false);
		
		IsPlayerBlackScreen{playerid} = true;
		
        fon_PTD[playerid] = CreatePlayerTextDraw(playerid, -12.0000, -10.3555, "Box"); // пусто 
        PlayerTextDrawLetterSize(playerid, fon_PTD[playerid], 0.0000, 53.6333); 
        PlayerTextDrawTextSize(playerid, fon_PTD[playerid], 680.0000, 0.0000); 
        PlayerTextDrawUseBox(playerid, fon_PTD[playerid], 1); 
        PlayerTextDrawBoxColor(playerid, fon_PTD[playerid], 255); 

        FonBox{playerid} = 0; 
        FonTimer[playerid] = SetTimerEx("@_FonTimer", true, 50, "ii", playerid, 1); 
    } 
} 

HideFonForPlayer(playerid) 
{ 
    if(FonBox{playerid} > 0) 
    { 		
        FonBox{playerid} = 255; 
        FonTimer[playerid] = SetTimerEx("@_FonTimer", true, 50, "ii", playerid, 2); 
    } 
} 

@_FonTimer(playerid, type); 
@_FonTimer(playerid, type) 
{ 	
    PlayerTextDrawBoxColor(playerid, fon_PTD[playerid], FonBox{playerid}); 
    PlayerTextDrawShow(playerid, fon_PTD[playerid]); 

    if(1 == type) 
    { 
        if(++ FonBox{playerid} >= 255) 
			KillTimer(FonTimer[playerid]);
    } 
    else 
    { 
        if(-- FonBox{playerid} <= 0) 
        { 
            PlayerTextDrawDestroy(playerid, fon_PTD[playerid]); 
            KillTimer(FonTimer[playerid]);
			TogglePlayerControllable(playerid, true);

			IsPlayerBlackScreen{playerid} = false;			
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

CreatePickupWith3DText(model, Float:X, Float:Y, Float:Z, const text[], virtualworld, Float:radius)
{
    CreatePickup(model, 23, Float:X, Float:Y, Float:Z, virtualworld);
	Create3DTextLabel(text, COLOR_PROX, Float:X, Float:Y, Float:Z, Float:radius, virtualworld, 0);
    return true;
}

CA_IsRobotOnSurface(robotid, Float:tolerance=1.5)
{
	new Float:x, Float:y, Float:z;
	FCNPC_GetPosition(Robot[robotid], x, y, z);

	// Check if player is actually on the ground
	if(!CA_RayCastLine(x, y, z, x, y, z-tolerance, x, y, z))
		return 0;
	return 1;
}

/*CA_IsRobotBlocked(robotid, Float:dist=1.5, Float:height=0.5)
{
	new Float:x, Float:y, Float:z, Float:endx, Float:endy, Float:fa;
	FCNPC_GetPosition(Robot[robotid], x, y, z);
	z -= 1.0 + height;
	fa = FCNPC_GetAngle(Robot[robotid]);

	endx = (x + dist * floatsin(-fa,degrees));
	endy = (y + dist * floatcos(-fa,degrees));
	if(CA_RayCastLine(x, y, z, endx, endy, z, x, y, z))
		return 1;
	return 0;
}*/ 

SetSkin(playerid)
{
	TogglePlayerSpectating(playerid, false);
	
	GameTextForPlayer(playerid, FixText("Выберите скин"), 5000, 3);
		
	SetPlayerVirtualWorld(playerid, playerid + 1);
	TogglePlayerControllable(playerid, 0);
	SetPlayerPos(playerid, -2230.6531,-1739.9501,481.7513);
	SetPlayerFacingAngle(playerid, 40.9857);
	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	SetPlayerFightingStyle(playerid, PlayerInfo[playerid][pCurrentFightStyle]);
		
	SetPlayerCameraPos(playerid, -2233.4141,-1737.1089,481.8256);
	SetPlayerCameraLookAt(playerid, -2230.6531,-1739.9501,481.7513);
		
	for(new i; i <= 2; i++)
				TextDrawShowForPlayer(playerid, skin[i]); 
			
	SelectTextDraw(playerid, 0x2641FEAA);
	
	return 1;
}	

StartEngine(vehicleid, playerid)
{
	if(VehInfo[vehicleid][vFuel] > 0)
	{
		static const
			fmt_str0[] = "%s вставляет ключ в замок зажигания (Запускает двигатель).",
			fmt_str1[] = "%s вытаскивает ключ из замка зажигания (Глушит двигатель).";
		
		const
			size = sizeof(fmt_str1) + (MAX_PLAYER_NAME+1-2);
		
		new string[size];

		SetVehicleParamsEx(vehicleid, !Engine{vehicleid} ? true : false, lights, alarm, doors, bonnet, boot, objective);
		
		Engine{vehicleid} = !Engine{vehicleid};
		 
		format(string, sizeof(string), (Engine{vehicleid}) ? (fmt_str0) : (fmt_str1), Name(playerid));
		ProxDetector(playerid, COLOR_PROX, string, 10.0);
	}
	else 
		return	SendClientMessage(playerid,COLOR_WHITE,"В этом транспорте нет бензина.");
	
	return 1;
}

IsVehicleOccupied(vehicleid) 
{ 
    foreach(Player, i)
	{
        if(IsPlayerInVehicle(i,vehicleid)) return 1; 
	}
    return 0; 
}  

SetRobotPosInRect(robotid, Float:min_x, Float:min_y, Float:max_x, Float:max_y)	
{
    min_x = frand(min_x, max_x);
    min_y = frand(min_y, max_y);	
	CA_FindZ_For2DCoord(min_x, min_y, max_x); // координата Z
	return FCNPC_SetPosition(Robot[robotid], min_x, min_y, max_x+0.5); // max_x - координата Z
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
					return 1;
    }
    return 0;
}

GiveHunger(playerid, hunger)
	return PlayerInfo[playerid][pHunger] += hunger;

GiveEndurance(playerid, endurance)
	return PlayerInfo[playerid][pEndurance] += endurance;

memset(aArray[], iValue, iSize = sizeof(aArray)) { 
    new iAddress; 
    #emit LOAD.S.pri 12 
    #emit STOR.S.pri iAddress 
    iSize *= 4; 
    while (iSize > 0) { 
        if (iSize >= 4096) { 
            #emit LOAD.S.alt iAddress 
            #emit LOAD.S.pri iValue 
            #emit FILL 4096 
            iSize -= 4096; 
            iAddress += 4096; 
        } else if (iSize >= 1024) { 
            #emit LOAD.S.alt iAddress 
            #emit LOAD.S.pri iValue 
            #emit FILL 1024 
            iSize -= 1024; 
            iAddress += 1024; 
        } else if (iSize >= 256) { 
            #emit LOAD.S.alt iAddress 
            #emit LOAD.S.pri iValue 
            #emit FILL 256 
            iSize -= 256; 
            iAddress += 256; 
        } else if (iSize >= 64) { 
            #emit LOAD.S.alt iAddress 
            #emit LOAD.S.pri iValue 
            #emit FILL 64 
            iSize -= 64; 
            iAddress += 64; 
        } else if (iSize >= 16) { 
            #emit LOAD.S.alt iAddress 
            #emit LOAD.S.pri iValue 
            #emit FILL 16 
            iSize -= 16; 
            iAddress += 16; 
        } else { 
            #emit LOAD.S.alt iAddress 
            #emit LOAD.S.pri iValue 
            #emit FILL 4 
            iSize -= 4; 
            iAddress += 4; 
        } 
    } 
    #pragma unused aArray 
}  

FixText(const string[]) 
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
	if(gPlayerLogged{playerid} == false) return 1;
	
	if (PlayerInfo[playerid][pMoney] != GetPlayerMoney(playerid))
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
	}
	
	if(PlayerInfo[playerid][pHP] < 0.0) 
		PlayerInfo[playerid][pHP] = 1.0;
	
	if(PlayerInfo[playerid][pHP] > 100.0) 
		PlayerInfo[playerid][pHP] = 100.0;
	
	
	if(PlayerTimerIDTimer1Second{playerid} == 4)
    {	

		//new check [20];		format(check, sizeof(check), "%d", PlayerTimerIDTimer60Second{playerid}); 		GameTextForPlayer(playerid, check, 1000, 3);
		//printf("%d", loginkicktimer[playerid]);

		if(IsPlayerInZone(playerid) && !IsPlayerInArmor(playerid))
			PlayerInfo[playerid][pHP] -= 1.0;
			
		if(PlayerInfo[playerid][pHunger] > SIXHOURS && !IsPlayerInZone(playerid) && PlayerInfo[playerid][pHP] < 100.0 &&
		PlayerInfo[playerid][pEndurance] > ONEHOURS)
			PlayerInfo[playerid][pHP] += 1.0;
	
		if(PlayerInfo[playerid][pEndurance] > PlayerInfo[playerid][pEnduranceMax]) 
			PlayerInfo[playerid][pEndurance] = PlayerInfo[playerid][pEnduranceMax];
		
		if(PlayerInfo[playerid][pHunger] > SEVENHOURS) 
			PlayerInfo[playerid][pHunger] = SEVENHOURS;
			
		if(PlayerInfo[playerid][pHunger] > 0)
			GiveHunger(playerid, -1);
		
		if(PlayerInfo[playerid][pEndurance] > 0 && !GetPVarInt(playerid,"Sleep"))
		{
			GiveEndurance(playerid, -1);
			
			if(PlayerInfo[playerid][pHunger] <= FIVEHOURS) GiveEndurance(playerid, -1);
			if(PlayerInfo[playerid][pHunger] <= FOURHOURS) GiveEndurance(playerid, -1);
			if(PlayerInfo[playerid][pHunger] <= THREEHOURS) GiveEndurance(playerid, -2);
			if(PlayerInfo[playerid][pHunger] <= TWOHOURS) GiveEndurance(playerid, -2);				
			if(PlayerInfo[playerid][pHunger] <= ONEHOURS) GiveEndurance(playerid, -3);
			
			if(IsPlayerJump(playerid)) GiveEndurance(playerid, -2);
			
			if(IsPlayerRun(playerid)) GiveEndurance(playerid, -1);
				
			if(PlayerInfo[playerid][pEndurance] <= ONEHOURS)
			{				
				PlayerTimerIDTimer60Second{playerid} ++;
				if(PlayerTimerIDTimer60Second{playerid} == 60)
				{				
					PlayerInfo[playerid][pHP] -= 1.0;
					PlayerTimerIDTimer60Second{playerid} = 0;
				}
			}				
		}		
		
		if(PlayerInfo[playerid][pAPEDBattery] > TENHOURS) 
			PlayerInfo[playerid][pAPEDBattery] = TENHOURS;
		
		if(PlayerInfo[playerid][pAPEDBattery] <= 0) 
			PlayerInfo[playerid][pAPEDBattery] = 0;
		
		if(PlayerInfo[playerid][pAPED] == 1 && PlayerInfo[playerid][pAPEDBattery] > 0)
		{
			PlayerInfo[playerid][pAPEDBattery] --;
			
			new string[10],
				battery = floatround(PlayerInfo[playerid][pAPEDBattery] / 360, floatround_ceil);
			
			format(string, sizeof(string), "%d %%", battery);
			TextDrawSetString(TDAPEDPercent[playerid], string);
		}
		
		
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
			if(VHP < 300.0 && Engine{VID} == true)
				SendClientMessage(playerid, COLOR_RED,"Состояние транспорта на низком уровне. Необходим ремонт.");
		}
		
		if(!IsPlayerInAnyVehicle(playerid) && gPlayerLogged{playerid} != false)
		{	
			if(IsPlayerIdle(playerid))
			{
				IdleTime[playerid] ++;
					
				if (IdleTime[playerid] == TIME_IDLE)	
				switch(random(4)) 
				{
					case 0: ApplyAnimation(playerid, "PLAYIDLES", "stretch", 4.1, 0, 1, 1, 0, 1, 1);
					case 1: ApplyAnimation(playerid, "PLAYIDLES", "shldr", 4.1, 0, 1, 1, 0, 1, 1);
					case 2: ApplyAnimation(playerid, "PLAYIDLES", "time", 4.1, 0, 1, 1, 0, 1, 1);
					case 3: ApplyAnimation(playerid, "PLAYIDLES", "shift", 4.1, 0, 1, 1, 0, 1, 1);
				}
					
				if (IdleTime[playerid] >= TIME_IDLE + 5)
				{
					ClearAnimations(playerid);
					IdleTime[playerid] = 0;
				}
			}
			else IdleTime[playerid] = 0;
		}
		
		foreach(Robots, r)
		{
			new Float:x[MAX_ROBOTS], Float:y[MAX_ROBOTS], Float:z[MAX_ROBOTS],
				Float:px, Float:py, Float:pz,
				Float:x1, Float:y1, Float:z1;
				
			FCNPC_GetPosition(Robot[r], x[r], y[r], z[r]);
			GetPlayerPos(playerid, px, py, pz);
			
			if(CA_RayCastLine(x[r], y[r], z[r], px, py, pz, x1, y1, z1) == 0)
			{
				if(GetPlayerDistanceFromPoint(playerid, x[r], y[r], z[r]) < 1)
				{
					if(FCNPC_IsMoving(Robot[r]))
						FCNPC_Stop(Robot[r]);
				}
				
				else if(1 <= GetPlayerDistanceFromPoint(playerid, x[r], y[r], z[r]) < 60)
				{
					if(FCNPC_IsMoving(Robot[r]))
						FCNPC_Stop(Robot[r]);
					
					FCNPC_AimAtPlayer(Robot[r], playerid, true);
				}
				
				else if(60 <= GetPlayerDistanceFromPoint(playerid, x[r], y[r], z[r]) < 80)
				{	
					if(FCNPC_IsMoving(Robot[r]))
						FCNPC_Stop(Robot[r]);
					
					if(!FCNPC_IsShooting(Robot[r]) || !FCNPC_IsReloading(Robot[r]))
						FCNPC_AimAtPlayer(Robot[r], playerid, false);
				}
				
				else if(GetPlayerDistanceFromPoint(playerid, x[r], y[r], z[r]) >= 80)
				{	
					if(FCNPC_IsMoving(Robot[r]))
						FCNPC_Stop(Robot[r]);
					
					if(FCNPC_IsAimingAtPlayer(Robot[r], playerid) && !FCNPC_IsShooting(Robot[r]))
						FCNPC_StopAim(Robot[r]);
				}
			}
			else
			{
				//if(FCNPC_IsMoving(Robot[r]))
				//		FCNPC_Stop(Robot[r]);
					
				if(FCNPC_IsAimingAtPlayer(Robot[r], playerid))
				{	
					FCNPC_StopAim(Robot[r]);
				
					FCNPC_GoTo(Robot[r], x1+2.0, y1+2.0, z1+0.5, FCNPC_MOVE_TYPE_AUTO, FCNPC_MOVE_SPEED_AUTO, FCNPC_MOVE_MODE_COLANDREAS);
				}
			}
		}
				
		SaveAccount(playerid);
		PlayerTimerIDTimer1Second{playerid} = 0;
	}
    else PlayerTimerIDTimer1Second{playerid}++;	
	
	new hour, minute;
	gettime(hour,minute);		
	SetPlayerTime(playerid, hour, minute);
	
	new string[11];
	
	format(string, sizeof(string), "%02d:%02d", hour, minute);
	TextDrawSetString(TDEditor_TD[4], string);
	
	new armedbody_pTick[MAX_PLAYERS];
	if(GetTickCount() - armedbody_pTick[playerid] > 113)
	{
		new weaponid[7], weaponammo[7];
		
		for(new i = 1; i < sizeof weaponid; i++)
		{
			GetPlayerWeaponData(playerid, i, weaponid[i], weaponammo[i]);
			if(weaponid[i] && weaponammo[i] > 0)
			{
				if(GetPlayerWeapon(playerid) != weaponid[i])
				{
					if(!IsPlayerAttachedObjectSlotUsed(playerid, i))
					{
						new const BoneAttachedWeapon[7] = {0, 1, 8, 7, 1, 1, 1};
						new const Float: CoordAttachedWeapon[7][9] =
						{
							{},
							{0.264999, -0.154999, 0.029999, 0.500006, -115.000000, 0.0, 1.0, 1.0, 1.0},
							{0.013000, -0.039999, 0.130999, -90.100006, 0.0, 0.0, 1.0, 1.0, 1.0},
							{0.031000, 0.006999, -0.057999, -94.100013, 15.999994, 1.600000, 1.0, 1.0, 1.0},
							{-0.047999, -0.136999, 0.010000, 0.000000, -171.799972, 14.699994, 1.0, 1.0, 1.0},
							{0.321000, -0.080999, -0.134000, 174.100082, 155.200286, 16.000137, 1.099998, 1.0, 1.0},
							{0.007999, -0.088999, -0.077999, 174.199783, 8.200004, 3.100003, 1.099998, 1.0}
						};
							
						SetPlayerAttachedObject(playerid, i, GetWeaponModel(weaponid[i]), BoneAttachedWeapon[i], CoordAttachedWeapon[i][0]
						, CoordAttachedWeapon[i][1], CoordAttachedWeapon[i][2], CoordAttachedWeapon[i][3], CoordAttachedWeapon[i][4]
						, CoordAttachedWeapon[i][5], CoordAttachedWeapon[i][6]);
						
						if(i == 2 || i == 3) continue;
						
						ClearAnimations(playerid);
						ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 1, 0, 400);
					}
				}
				else 
				{
					if(IsPlayerAttachedObjectSlotUsed(playerid, i))
					{
						RemovePlayerAttachedObject(playerid, i);
						
						ClearAnimations(playerid);
						if(i == 2 || i == 3)
							ApplyAnimation(playerid, "COLT45", "sawnoff_reload", 4.1, 0, 1, 1, 0, 500);
						else
							ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 1, 0, 500);
					}
				}
                armedbody_pTick[playerid] = GetTickCount();
			}
        }
	}
	
    return 1;
}  

forward Processor();
public Processor()
{	
	foreach(Player, i)
	{
		if(IsPlayerConnected(i) && GetPVarInt(i, "player_kick_time") != 0 && GetPVarInt(i, "player_kick_time") < GetTickCount()) 
		{
			SendClientMessage(i, COLOR_RED,"Вы были отключены от сервера из-за бездействия.");
			GameTextForPlayer(i, FixText("~R~Отключение от сервера"), 1500, 3);
			
			Kick(i);
		}
	}
	
	foreach (new v : Vehicle) 
	{	
		new Float:VHP, Float:angle, Float:x, Float:y, Float:z;	
		
		GetVehiclePos(v, x, y, z);
		GetVehicleZAngle(v, angle);
		GetVehicleHealth(v, VHP);
		
		if(VehInfo[v][vBuy] == VBUYTOCARKEY && IsVehicleOccupied(v) &&		
		(	floatround(VehInfo[v][vVPosX]) != floatround(x) ||
			floatround(VehInfo[v][vVPosY]) != floatround(y) || 
			floatround(VehInfo[v][vVZa]) != floatround(angle) 	||
			VehInfo[v][vHP] != VHP))
			SaveOneVeh(v);		
			
		if(VHP < 300.0)
		{
			SetVehicleHealth(v, 300.0);
			SetVehicleZAngle(v, angle);
			if(Engine{v} == true)
			{
				GetVehicleParamsEx(v,engine,lights,alarm,doors,bonnet,boot,objective);	
				SetVehicleParamsEx(v,false,lights,alarm,doors,bonnet,boot,objective);
				Engine{v} = false;
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
	
	foreach(new i : APED)
	{
		if(APEDInfo[i][aBattery] <  TENHOURS)
		{
			if(APEDInfo[i][aBattery] >=  TENHOURS)	
				return APEDInfo[i][aBattery] = TENHOURS;
				
			APEDInfo[i][aBattery] += 60;
			
			if(APEDInfo[i][aBattery] >=  TENHOURS)	
			APEDInfo[i][aBattery] = TENHOURS;
			
			static
				query_string[37+64+11+10+1];
			mysql_format(mysql_connect_ID, query_string, sizeof(query_string), "UPDATE aped SET `Battery` = %d WHERE APEDID = %d", APEDInfo[i][aBattery], i);
			mysql_tquery(mysql_connect_ID, query_string);
			
			new str[48+3], 
				battery = floatround(APEDInfo[i][aBattery] * 100 / TENHOURS, floatround_ceil);		
							
			format(str, sizeof(str), "APED заряжается\nЗаряд батереи: "COL_GREEN"%d %%", battery);
			
			Update3DTextLabelText(aped[i], COLOR_WHITE,str);
		}
	}
	
	for(new i = 0; i < MAX_ROBOTS_POSITION; i++)
	{
		new string[13];
		
		foreach(Player, p)
		{	
			if(IsPlayerInDynamicArea(p, RobotsArea[i]) && !IsRobotsAreaNotAvailable[i])
			{			
				IsRobotsAreaNotAvailable[i] = true;
					
				format(string, sizeof(string), "Недоступна %d", i);
				SendClientMessageToAll(COLOR_RED, string);
				
				for(new r = 0, count = 0; count < AMOUNTROBOTSINAREA[i]; r++)
				{
					if(r == MAX_ROBOTS && count == 0)
					{
						SendClientMessageToAll(COLOR_RED, "Боты кончились, есть игроки в зоне."); 
						break;
					}
					if(r == MAX_ROBOTS) 
					{
						SendClientMessageToAll(COLOR_RED, "Боты кончились."); 
						break;
					}
					if(RobotsInfo[r][rVisible] == 1) continue;
					
					SpawnRobots(r);
					SetRobotPosInRect(r, RobotsPositions[i][0], RobotsPositions[i][1], RobotsPositions[i][2], RobotsPositions[i][3]);				
					FCNPC_SetAngle(Robot[r], random(360));
					
					format(string, sizeof(string), "%d", r);
					SendClientMessageToAll(COLOR_RED, string);
					
					RobotsInfo[r][rAreaID] = i;
					
					count++;
					
					Iter_Add(RobotsVisible[i], r);
				}
				
				format(string, sizeof(string), "%d", Iter_Count(RobotsVisible[i]));
				SendClientMessageToAll(COLOR_RED, string);
			}
		}
		
		if(Iter_Count(PlayersInZone[i]) == 0 && !TimerIDZoneAvailable[i] && IsRobotsAreaNotAvailable[i])
			TimerIDZoneAvailable[i] = SetTimerEx("ZoneAvailable", 1000*TIME_ZONE_AVAILABLE, false, "d", i);
	}
	
	foreach(Robots, i)
	{
		if(!FCNPC_GetVirtualWorld(Robot[i]))
		{
			if(CA_IsRobotOnSurface(i)) continue;
				
			new Float:x, Float:y, Float:z;
			FCNPC_GetPosition(Robot[i], x, y, z);
			CA_FindZ_For2DCoord(x, y, z); // координата Z
			FCNPC_SetPosition(Robot[i], x, y, z+1.0);
			
			/*if(!CA_IsRobotBlocked(i)) continue;
			if(FCNPC_IsMoving(Robot[i]))
				FCNPC_Stop(Robot[i]);*/
		}
	}
	
	SetTimer("Processor", PROCESSOR_UPDATE, false);
    return 1;
}

forward ZoneAvailable(id);
public ZoneAvailable(id)
{
	foreach(new p : Player)
	{
		if(IsPlayerInDynamicArea(p, RobotsArea[id])) 
		{
			SendClientMessageToAll(COLOR_RED, "Кто-то в зоне."); 
			TimerIDZoneAvailable[id] = SetTimerEx("ZoneAvailable", 1000*TIME_ZONE_AVAILABLE, false, "d", id);
			return 1;
		}
	}
	new string[11];
	
	format(string, sizeof(string), "Доступна %d", id);
	SendClientMessageToAll(COLOR_GREEN, string);
	
	IsRobotsAreaNotAvailable[id] = false;
				
	foreach(RobotsVisible[id], r)
	{
		FCNPC_SetVirtualWorld(Robot[r], 1);
		RobotsInfo[r][rVisible] = 0;
		RobotsInfo[r][rAreaID] = -1;
	}
	Iter_Clear(RobotsVisible[id]);
	
	TimerIDZoneAvailable[id] = 0;
	
	return 1;
}

forward SpeedoUpdate();
public SpeedoUpdate()
{
	foreach(Player, i)
	{
	    new string[24], vehicleid = GetPlayerVehicleID(i);
		if(GetPlayerState(i) == PLAYER_STATE_DRIVER && !NoEngine(vehicleid))
		{
			TextDrawShowForPlayer(i, TDEditor_SpeedBox1[i]);
			TextDrawShowForPlayer(i, TDEditor_SpeedBox2[i]);
			TextDrawShowForPlayer(i, TDEditor_SpeedBox3[i]);
			TextDrawShowForPlayer(i, TDEditor_SpeedBox4[i]);
			TextDrawShowForPlayer(i, TDSpeedoEngine[i]);
			TextDrawShowForPlayer(i, TDSpeedoSpeed[i]);
			TextDrawShowForPlayer(i, TDSpeedoFuel[i]);
			TextDrawShowForPlayer(i, TDSpeedoDoors[i]);
			TextDrawShowForPlayer(i, TDSpeedoSpeedI[i]);
			TextDrawShowForPlayer(i, TDSpeedoFuelI[i]);

			format(string, sizeof(string), "%d", GetVehicleSpeed(vehicleid));
			TextDrawSetString(TDSpeedoSpeed[i], string);
			
			format(string, sizeof(string), "%d %%", VehInfo[vehicleid][vFuel]);
			TextDrawSetString(TDSpeedoFuel[i], string);
		}
		
		if(VehInfo[vehicleid][vFuel] <= 100)				
			TextDrawSetString(TDSpeedoFuelI[i], "I_I_I_I_I_I_I_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 90)			
			TextDrawSetString(TDSpeedoFuelI[i], "I_I_I_I_I_I_I_I_I_I_I_I~w~_I");
		if(VehInfo[vehicleid][vFuel] <= 80)				
			TextDrawSetString(TDSpeedoFuelI[i], "I_I_I_I_I_I_I_I_I_I_I~w~_I_I");
		if(VehInfo[vehicleid][vFuel] <= 75)
			TextDrawSetString(TDSpeedoFuelI[i], "I_I_I_I_I_I_I_I_I_I~w~_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 70)
			TextDrawSetString(TDSpeedoFuelI[i], "I_I_I_I_I_I_I_I_I~w~_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 60)
			TextDrawSetString(TDSpeedoFuelI[i], "I_I_I_I_I_I_I_I~w~_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 50)
			TextDrawSetString(TDSpeedoFuelI[i], "I_I_I_I_I_I_I~w~_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 40)
			TextDrawSetString(TDSpeedoFuelI[i], "I_I_I_I_I_I~w~_I_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 30)
			TextDrawSetString(TDSpeedoFuelI[i], "I_I_I_I_I~w~_I_I_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 20)
			TextDrawSetString(TDSpeedoFuelI[i], "I_I_I_I~w~_I_I_I_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 15)
			TextDrawSetString(TDSpeedoFuelI[i], "I_I_I~w~_I_I_I_I_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 10)
			TextDrawSetString(TDSpeedoFuelI[i], "I_I~w~_I_I_I_I_I_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 5)
			TextDrawSetString(TDSpeedoFuelI[i], "I~w~_I_I_I_I_I_I_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] == 0)
			TextDrawSetString(TDSpeedoFuelI[i], "~w~I_I_I_I_I_I_I_I_I_I_I_I_I");
		
		if(GetVehicleSpeed(vehicleid) == 0.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~IIIIIIIIIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 5.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~I~b~IIIIIIIIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 10.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~II~b~IIIIIIIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 15.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~III~b~IIIIIIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 20.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIII~b~IIIIIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 25.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIII~b~IIIIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 30.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIII~b~IIIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 35.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIII~b~IIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 40.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIII~b~IIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 45.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIII~b~IIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 50.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIII~b~IIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 55.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIII~b~IIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 60.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIII~b~IIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 70.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIII~b~IIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 80.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIIII~b~IIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 90.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIIIII~b~IIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 100.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIIIIII~b~IIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 110.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIIIIIII~b~IIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 120.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIII~b~IIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 130.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIII~b~IIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 140.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIII~b~IIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 150.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIII~b~IIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 160.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIIII~b~IIIIII");
		if(GetVehicleSpeed(vehicleid) >= 170.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIIIII~b~IIIII");
		if(GetVehicleSpeed(vehicleid) >= 180.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIIIIII~b~IIII");
		if(GetVehicleSpeed(vehicleid) >= 190.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIIIIIII~b~III");
		if(GetVehicleSpeed(vehicleid) >= 200.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIIIIIIII~b~II");
		if(GetVehicleSpeed(vehicleid) >= 210.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIIIIIIIII~b~I");
		if(GetVehicleSpeed(vehicleid) >= 220.0)				
			TextDrawSetString(TDSpeedoSpeedI[i], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIIIIIIIIII");
		
		if(!VehInfo[vehicleid][vLock])			
			TextDrawSetString(TDSpeedoDoors[i], "~g~doors");
		else 
			TextDrawSetString(TDSpeedoDoors[i], "~r~doors");
		
		if(Engine{vehicleid})			
			TextDrawSetString(TDSpeedoEngine[i], "~b~~h~~h~~h~engine");
		else 
			TextDrawSetString(TDSpeedoEngine[i], "engine");
		

		
		/*if(GetVehicleSpeed(vehicleid) >= 110.0)
		{
			new Float:x,Float:y,Float:z;
			GetVehicleVelocity(vehicleid, x, y, z);
			SetVehicleVelocity(vehicleid, x*0.99, y*0.99, z*0.99);
		}*/
		
  		if(!IsPlayerInAnyVehicle(i))
		{			
			TextDrawHideForPlayer(i, TDEditor_SpeedBox1[i]);
			TextDrawHideForPlayer(i, TDEditor_SpeedBox2[i]);
			TextDrawHideForPlayer(i, TDEditor_SpeedBox3[i]);
			TextDrawHideForPlayer(i, TDEditor_SpeedBox4[i]);
			
			TextDrawHideForPlayer(i, TDSpeedoEngine[i]);
			TextDrawHideForPlayer(i, TDSpeedoSpeed[i]);
			TextDrawHideForPlayer(i, TDSpeedoFuel[i]);
			TextDrawHideForPlayer(i, TDSpeedoDoors[i]);
			TextDrawHideForPlayer(i, TDSpeedoSpeedI[i]);
			TextDrawHideForPlayer(i, TDSpeedoFuelI[i]);
		}
	}
	SetTimer("SpeedoUpdate", 50, false);
	return 1;
}

forward FuelTime();
public FuelTime()
{
	foreach (new v : Vehicle) 
	{ 
		if(!NoEngine(v) && VehInfo[v][vAdd] != 0)
		{
			if(Engine{v} == true)//если двигатель у проверяемой машины работает
			{				
				VehInfo[v][vFuel] -= 1;
				UpdateDataInt(v, "vehicles", "Fuel", VehInfo[v][vFuel]);
				
				
				if(VehInfo[v][vFuel] <= 0)	
				{
					VehInfo[v][vFuel] = 0;
					GetVehicleParamsEx(v,engine,lights,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(v,false,lights,alarm,doors,bonnet,boot,objective);
					Engine{v} = false;
				}
			}
		}
	}
	SetTimer("FuelTime", FUEL_TIME, false);
	return 1;
}

forward Refill(playerid, litr);
public Refill(playerid, litr)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if ( !litr || VehInfo[vehicleid][vFuel] >= 100 )
	{
        KillTimer( GetPVarInt(playerid,"_timer"));
		
		DeletePVar(playerid, "Refill");
		
        TogglePlayerControllable(playerid, 1);
		
		new str[130];
		
        format(str, sizeof(str), ""COL_BLUE"Спасибо за то, что Вы заправились на нашей АЗС.\nЗаполнено "COL_WHITE"%d %% "COL_BLUE"бензобака.\n\
		Оплачено: "COL_GREEN"%d$.", inputfuel{playerid}, CENA_BENZ*inputfuel{playerid});
		ShowPlayerDialog(playerid, DIALOG_ID_NONE, D_S_M, ""COL_ORANGE"АЗС", str, "Принять", "");
		return 1;
    }
    ++ VehInfo[vehicleid][vFuel];
	UpdateDataInt(vehicleid, "vehicles", "Fuel", VehInfo[vehicleid][vFuel]);
	
    SetPVarInt(playerid,"_timer", SetTimerEx("Refill", 500, false, "ii", playerid, -- litr ) );
    return 1;
}

forward SprayCanVehicle(playerid, vehicleid);
public SprayCanVehicle(playerid, vehicleid)
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, -2385.7307, -2186.9722, 33.4849)) return 1;
	
	if(vehicleid == GetAroundPlayerVehicleID(playerid, 4.0))
	{
		GameTextForPlayer(playerid, FixText("~G~Вы успешно перекрасили транспорт"), 1500, 3);
		
		ChangeVehicleColor(vehicleid, ColorsAvailable[GetPVarInt(playerid, "ChooseColor1")-2], ColorsAvailable[GetPVarInt(playerid, "ChooseColor2")-2]);
		
		UpdateDataInt(vehicleid, "vehicles", "Color1", ColorsAvailable[GetPVarInt(playerid, "ChooseColor1")-2]);	
		UpdateDataInt(vehicleid, "vehicles", "Color2", ColorsAvailable[GetPVarInt(playerid, "ChooseColor2")-2]);	
		
		SetPlayerAmmo(playerid, WEAPON_SPRAYCAN, 0);
		
		DeletePVar(playerid, "PlayerSprayOnVehicle");	
		DeletePVar(playerid, "ChooseColor1");	
		DeletePVar(playerid, "ChooseColor2");	
	}
	else
	{
		GameTextForPlayer(playerid, FixText("~R~Вы далеко от транспорта"), 1500, 3);
		DeletePVar(playerid, "PlayerSprayOnVehicle");
	}
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
      	 	ApplyAnimation(playerid, "CARRY", "liftup", 4.0, 0, 1, 1, 0, 1300);
			
      	 	SetPlayerAttachedObject(playerid,1,1463,6,0.031000,0.141999,-0.216000,64.700080,170.200073,-88.599960,0.358000,0.261999,0.461999);
            SetTimerEx("TimeWood", 1300, false, "i", playerid);
        }
        return true;
}
forward TimeWood(playerid);
public TimeWood(playerid)
{
        if(GetPVarInt(playerid, "StartJob") ==  1)
        {
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			
			TogglePlayerControllable(playerid, 1);
			SetPlayerRaceCheckpoint(playerid, 0, -1638.1555,-2252.6714,31.5890,-1638.1555,-2252.6714,31.5890,1);
	    }
        return true;
}

forward Mission1Photo(playerid);
public Mission1Photo(playerid)
{		
	PlayerTextDrawHide(playerid, PlayerText:mission1photo[playerid]);
    return 1;
}

forward PlayerFightNPC(playerid);
public PlayerFightNPC(playerid)
{	
	GameTextForPlayer(playerid, FixText("~G~БОЙ"), 1000, 3);	
	
	TogglePlayerControllable(playerid, 1);
	
	FCNPC_GoToPlayer(NPCGym, playerid, FCNPC_MOVE_TYPE_WALK, FCNPC_MOVE_SPEED_WALK);
	FCNPC_SetFightingStyle(NPCGym, fighting_style[GetPVarInt(playerid, "ChooseGymAction")-2][fsID]);
	FCNPC_MeleeAttack(NPCGym, -1, true);
	
	SetPVarInt(playerid,"TimerIDGymFight", SetTimerEx("NPCGymTimer", NPC_UPDATE, true, "d", playerid));
    return 1;
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
	HideFonForPlayer(playerid);
	
	if(		IsPlayerInRangeOfPoint(playerid, 3.0, 756.5243,5.3321,1000.6991) && GetPVarInt(playerid, "ChooseGymAction") != 0
		|| 	IsPlayerInRangeOfPoint(playerid, 3.0, 756.5243,5.3321,1000.6991) && GetPVarInt(playerid, "IsPlayerInGymCC") == 1)
	{
		if(IsValidDynamicCP(GymCheckpoint[playerid]))
			DestroyDynamicCP(GymCheckpoint[playerid]);
			
		if(GetPVarInt(playerid, "IsPlayerInGymCC") == 1)
		{
			SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
			DeletePVar(playerid, "IsPlayerInGymCC");
		}
		else
		{
			SetPVarInt(playerid, "IsPlayerInGymCC", 1);
			
			switch(GetPVarInt(playerid, "ChooseGymAction"))
			{				
				case 1: SetPlayerSkin(playerid, PlayerInfo[playerid][pSex] == 1 ? 25009 : 25013);
				case 2..6:
				{
					SetPlayerSkin(playerid, PlayerInfo[playerid][pSex] == 1 ? 25001 : 25013);
					GymCheckpoint[playerid] = CreateDynamicCP(764.7575,-3.4573,1000.7129, 0.7, 0, 5, playerid, 15.0);
				}
				case 7: 
				{
					SetPlayerSkin(playerid, PlayerInfo[playerid][pSex] == 1 ? 25008 : 25013);
					GymCheckpoint[playerid] = CreateDynamicCP(764.7575,-3.4573,1000.7129, 0.7, 0, 5, playerid, 15.0);
				}
			}				
		}
		
		return 1;
	}	

	if(GetPlayerCustomSkin(playerid) != PlayerInfo[playerid][pMemberSkin])
		SetPlayerSkin(playerid, PlayerInfo[playerid][pMemberSkin]);	
	else
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
    return 1;
}



@_ClearAnim(playerid);
@_ClearAnim(playerid)
	return ApplyAnimation(playerid,"CARRY","crry_prtial", 4.0, 0, 0, 0, 0, 0, 0);
	
@_ClearAnimAfterGetOff(playerid);
@_ClearAnimAfterGetOff(playerid)
{
	if(GetPVarInt(playerid, "PlayerRunInGym"))
		TogglePlayerControllable(playerid, 1), ApplyAnimation(playerid,"CARRY","crry_prtial", 4.0, 0, 0, 0, 0, 0, 0), DeletePVar(playerid, "PlayerRunInGym");
	return 1;
}
	
@_ApplyAnimGetOnGym(playerid);
@_ApplyAnimGetOnGym(playerid)
{
	if(!GetPVarInt(playerid, "PlayerRunInGym"))
	{
		ApplyAnimation(playerid, "GYMNASIUM", "gym_tread_walk", 4.1, 1, 0, 0, 1, 1, 1);
		SetPVarInt(playerid, "PlayerRunInGym", 1);
		GameTextForPlayer(playerid, "~b~IIIIIIIIII", 10000, 3);
		GameTextForPlayer(playerid, "~w~~k~~PED_SPRINT~", 10000, 5);
		SendClientMessage(playerid, COLOR_WHITE, "Для бега нажимайте ~k~~PED_SPRINT~. Чтобы закончить нажмите ~k~~VEHICLE_ENTER_EXIT~");
	}
	return 1;
}
	
@_TogglePlayerControllPublic(playerid);
@_TogglePlayerControllPublic(playerid)
	return TogglePlayerControllable(playerid, 1), ClearAnimations(playerid), DeletePVar(playerid, "IsTazed");


	
forward RotateFerrisWheel();
public RotateFerrisWheel()
{
        FerrisWheelAngle+=36;
        if(FerrisWheelAngle>=360) 
			FerrisWheelAngle=0;
		
        if(FerrisWheelAlternate) 
			FerrisWheelAlternate=0;
        else 
			FerrisWheelAlternate=1;
		
        new Float:FerrisWheelModZPos=0.0;
        if(FerrisWheelAlternate)
			FerrisWheelModZPos=0.05;
		
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
				
		SendClientMessage(playerid, COLOR_GREEN,"Вы закончили ремонт транспорта.");
				
		DeletePVar(playerid, "VehID");
		return 1;				
	}
	new string[17];
	format(string, sizeof(string),FixText("~G~Осталось: %d"), FixCarTime[playerid]); 
	GameTextForPlayer(playerid, string, 1000, 3);
		
	FixCarTime[playerid] --;
	SetPVarInt(playerid,"FixCarTimer", SetTimerEx("FixCarTimer", 1000, false, "i", playerid));
	return 1;
}

forward SleepTimer(playerid);
public SleepTimer(playerid)
{
	if(PlayerInfo[playerid][pEndurance] >=  PlayerInfo[playerid][pEnduranceMax])
	{
		new string[25],
			chill = floatround(PlayerInfo[playerid][pEndurance] * 100 / PlayerInfo[playerid][pEnduranceMax], floatround_ceil);
		
		format(string, sizeof(string),FixText("~G~Уровень отдыха: %d %%"), chill); 
		GameTextForPlayer(playerid, string, 1000, 3);
		
		KillTimer(GetPVarInt(playerid,"SleepTimer"));	
		
		HideFonForPlayer(playerid);
				
		SendClientMessage(playerid, COLOR_GREEN,"Вы отдохнули.");
		
		DeletePVar(playerid,"Sleep");
		
		ApplyAnimation(playerid, "SUNBATHE", "Lay_Bac_out", 4.1, 0, 1, 1, 1, 1, 1);
		SetTimerEx("@_ClearAnim", 1500, false, "d", playerid);
		return 1;				
	}
	new string[25],
		chill = floatround(PlayerInfo[playerid][pEndurance] * 100 / PlayerInfo[playerid][pEnduranceMax], floatround_ceil);
		
	format(string, sizeof(string),FixText("~G~Уровень отдыха: %d %%"), chill); 
	GameTextForPlayer(playerid, string, 1000, 3);
		
	PlayerInfo[playerid][pEndurance] += 600;
	
	SetPVarInt(playerid,"SleepTimer", SetTimerEx("SleepTimer", 1000, false, "i", playerid));
	return 1;
}

forward FindPlayerInTable(playerid);
public FindPlayerInTable(playerid)
{
    new rows;
    cache_get_row_count(rows);
 
    if(!rows)
    {
        ShowPlayerDialog(playerid, DIALOG_ID_CHOOSESEX, D_S_M,""COL_ORANGE"Окно регистрации",
		""COL_BLUE"Приветствуем Вас на нашем сервере!\nДля регистрации выберите пол Вашего персонажа\n", "Мужской", "Женский");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_ID_LOGIN, D_S_P, ""COL_ORANGE"Авторизация",
		""COL_BLUE"Добрый день!\nВаш аккаунт есть на сервере.\nВведите свой пароль в поле:", "Ввод", "Выход");
		
		cache_get_value(0, "Password", PlayerInfo[playerid][pPass], 65);
		cache_get_value(0, "Salt", PlayerInfo[playerid][pSalt], 17);
    }
    return 1;
}

forward GymTimer(playerid);
public GymTimer(playerid)
{
	DeletePVar(playerid, "ChooseGymAction");	
	gymTimer[playerid] = 0;
	
	SendClientMessage(playerid, COLOR_WHITE, "Срок действия разового абонемента истек.");
}

forward HideFonAfterReg(playerid);
public HideFonAfterReg(playerid)
{	
	NewAccountInventory(playerid);

	HideFonForPlayer(playerid);
	
	PlayerInfo[playerid][pPos_x] = -2272.7549;
	PlayerInfo[playerid][pPos_y] = -2203.3040;
	PlayerInfo[playerid][pPos_z] = 31.2922;
	PlayerInfo[playerid][pFa] = 218.6473;
	
	SpawnPlayer(playerid);
	return 1;
}

forward SetPlayerCameraPosForReqClass(playerid);
public SetPlayerCameraPosForReqClass(playerid)
{
    /*SetPlayerCameraPos(playerid, -2052.9094,-2517.8618,86.9391);
    SetPlayerCameraLookAt(playerid, -2074.1409,-2480.8386,73.3136);*/
	
	InterpolateCameraPos(playerid, -2095.5276, -2569.6130, 77.1595, -2311.9031, -2425.6443, 72.2214, 25000, CAMERA_MOVE);
	InterpolateCameraLookAt(playerid, -2095.8398, -2568.6594, 76.9695, -2310.9009, -2425.6340, 72.0614, 25000, CAMERA_MOVE);
}

forward TogglePlayerSpectatingOff(playerid);
public TogglePlayerSpectatingOff(playerid) 
{
    TogglePlayerSpectating(playerid, false),
    SetPVarInt(playerid, "OnPlayerRequestClass_F4_Bug", GetPVarInt(playerid, "OnPlayerRequestClass_F4_Bug")+1);//Чпок
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



ShowInventory(playerid)
{
	for(new i; i < 13; i++)
		TextDrawShowForPlayer(playerid, Inventory[i]); // показываем стандартные боксы
	
	TextDrawSetPreviewModel(PlayerInventory[playerid][0], GetPlayerCustomSkin(playerid)); // + модельку перса	
	TextDrawSetPreviewModel(PlayerInventory[playerid][1], InventoryInfo[playerid][iSlotSecondaryWeapon]);
	TextDrawSetPreviewModel(PlayerInventory[playerid][2], InventoryInfo[playerid][iSlotBackpack]);
	TextDrawSetPreviewModel(PlayerInventory[playerid][3], InventoryInfo[playerid][iSlotArmor]);
	TextDrawSetPreviewModel(PlayerInventory[playerid][4], InventoryInfo[playerid][iSlotPrimaryWeapon]);
	TextDrawSetPreviewModel(PlayerInventory[playerid][5], InventoryInfo[playerid][iSlotWeapon][0]);
	TextDrawSetPreviewModel(PlayerInventory[playerid][6], InventoryInfo[playerid][iSlotWeapon][1]);
	
	for(new i; i < MAX_MAIN_SLOTS; i++)
	{		
		new string[6];
			
		format(string, sizeof(string), "%d", InventoryInfo[playerid][iSlotAmount][i]);
		TextDrawSetString(PlayerInventory[playerid][23+i], string);
		TextDrawSetPreviewModel(PlayerInventory[playerid][7+i], InventoryInfo[playerid][iSlot][i]);
	}
	
	for(new i; i < MAX_SLOTS-16; i++)
		TextDrawShowForPlayer(playerid, PlayerInventory[playerid][i]); // показываем кликабельные боксы
	
	for(new i; i < 16; i++)
	{
		if(InventoryInfo[playerid][iSlotAmount][i] != 0)	
			TextDrawShowForPlayer(playerid, PlayerInventory[playerid][23+i]); // показываем кликабельные боксы
	}

	IsInventoryOpen{playerid} = true;
	SelectTextDraw(playerid, 0xFFFFFFAA);
	return 1;
}

HideInventory(playerid)
{
	IsInventoryOpen{playerid} = false;
	CancelSelectTextDraw(playerid);
		
	for(new i; i < 13; i++)
		TextDrawHideForPlayer(playerid, Inventory[i]); // скрываем стандартные боксы
		
	for(new i; i < MAX_SLOTS; i++)
		TextDrawHideForPlayer(playerid, PlayerInventory[playerid][i]); // скрываем ячейки
	
	return 1;
}
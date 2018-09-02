//////////////////////////////////////////////////////////////////
/*

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
										2. Батарею заряжать можно дома и в каких нибудь местах. 

Система смерти, ранений и тд.

Полиция: 	1. Шипы для прокола колёс 
			2. Могут отключать двигатель преступнику дистанционно через APED

Финансы: 1. Можно брать кредит с 18 лет и если есть работа 

Система голода: 

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

#include 	<a_samp>

#undef 		MAX_PLAYERS
#define 	MAX_PLAYERS 	5
#undef 		MAX_VEHICLES
#define 	MAX_VEHICLES 	100

#define 	FIXES_ServerVarMsg 0
#include 	<fixes> 
#include 	<a_mysql>
#include 	<foreach> 
#include 	<streamer>
#include 	<sscanf2>
//#include 	<nex-ac>
#include 	<a_actor>
#include 	<dc_cmd>  
#include 	<objects>
#include 	<keypad>
#include 	<textdraws>
 
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
#define		SECONDS_TO_LOGIN 		10

#define 	VBUYTOBUY 			0
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

#define 	Name(%1) 		PlayerInfo[%1][pName]

#define 	MAX_HOUSES 		50
#define 	MAX_ENTERS 		50
#define 	MAX_APED 		500

#define 	ONEHOURS 		3600
#define 	TWOHOURS		7200
#define 	THREEHOURS 		10800
#define 	FOURHOURS 		14400
#define 	FIVEHOURS 		18000
#define 	SIXHOURS 		21600
#define	 	SEVENHOURS 		25200
#define 	TENHOURS 		36000

#define 	PROCESSOR_UPDATE 	1000
#define 	FUEL_TIME 			60000

#define 	forEx(%0,%1) 			for(new %1=0;%1<%0;%1++)
#define 	FERRIS_WHEEL_WAIT_TIME	1000     //Wait Time to enter a Cage
#define 	FERRIS_WHEEL_SPEED 		0.007        //Speed of turn (Standart 0.005)

#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define PRESSING(%0,%1) \
	(%0 & (%1))
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
	
new MySQL:mysql_connect_ID;
	
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


new bool:gPlayerLogged[MAX_PLAYERS];
new bool:SpecON[MAX_PLAYERS];
new bool:engine,lights,alarm,doors,bonnet,boot,objective;
new bool:animloading[MAX_PLAYERS];
new bool:Engine[MAX_VEHICLES]; 
new bool:tazer_status[MAX_PLAYERS char];
new bool:PlayerRun[MAX_PLAYERS];
new bool:PlayerDeath[MAX_PLAYERS];
new bool:CloseTextDrawAPED[MAX_PLAYERS];
new bool:IsPlayerBlackScreen[MAX_PLAYERS];
new bool:MapIsOn[MAX_PLAYERS];

new p_muted[MAX_PLAYERS char];

new Text:box[MAX_PLAYERS],Text:speed[MAX_PLAYERS],Text:fuel[MAX_PLAYERS];

new blackmap; // чтобы карта стала черной

new 
    FonTimer[MAX_PLAYERS], 
    FonBox[MAX_PLAYERS], 
    PlayerText: fon_PTD[MAX_PLAYERS];  

new drev = 0; // для системы дерева
new purse = 0; // для системы казны

new ActorWoodMan, ActorKapitoliyWomen, ActorAPPD, ActorRestaraunt, ActorZero, ActorHospital;

new IDFrac[MAX_PLAYERS] = 0;
new IDLeader = 0;

new Text3D:sellVehInfo[MAX_VEHICLES];
new Text3D:aped[MAX_APED];
new apedpickup[MAX_APED];

new RentCar[MAX_PLAYERS];
new PlayerMoney[MAX_PLAYERS];  // для античита 
new inputfuel[MAX_PLAYERS];
new PlayerTimerID[MAX_PLAYERS]; // индивидуальные таймеры 
new loginkicktimer[MAX_PLAYERS];

new PlayerTimerIDTimer1Second;
new PlayerTimerIDTimer60Second;  

new cskin[MAX_PLAYERS]; ////
new ManSkinList[4] = { 23, 35, 66, 95 }; ////	
new WomanSkinList[4] = { 148, 169, 196, 225 }; ////

new FixCarTime[MAX_PLAYERS]; // время починки
new IdleTime[MAX_PLAYERS]; // время стояния на месте

// двери, ворота время
new VaultDoorTime, LSPDGateTime, BankGateTime, CongressGateTime, FixGateTime, FixGate2Time; 

// двери, ворота id
new LSPDDoor, LSPDDoor2, BankGate, LSPDGate, BankDoor, BankDoor2, BankDoor3,
VaultGate, VaultDoor, CongressGate, FixGate, FixGate2, FireDoor, FireDoor2, AmbulanceDoor;

// двери, ворота состояние
new bool:LSPDDoorOpen, LSPDDoor2Open, BankDoorOpen, BankDoor2Open, BankDoor3Open, VaultDoorOpen, VaultGateOpen,
LSPDGateOpen, BankGateOpen, CongressGateOpen, FixGateOpen, FixGate2Open, FireDoorOpen, FireDoor2Open, AmbulanceDoorOpen;


new Iterator:APED<MAX_APED>;
new Iterator:House<MAX_HOUSES>;


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
	pRankName[32],
	pAPED,
	pAPEDBattery,
	pHunger,
	pEndurance,
	pEnduranceMax,
	Float:pHP,
	pHouse
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
new APEDInfo[MAX_APED][aInfo];//This is the var where we will read the house info.

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
	DIALOG_ID_TAKEAPED
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
	KEYPAD_POLICE,
	KEYPAD_POLICE2,
	KEYPAD_BANKDOOR,
	KEYPAD_BANKDOOR2,
	KEYPAD_VAULTDOOR,
	KEYPAD_VAULTGATE,
	KEYPAD_FIREDOOR,
	KEYPAD_FIREDOOR2,
	KEYPAD_BANKDOOR3,
	KEYPAD_AMBULANCEDOOR,
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

	LoadingTextDraws();
    ObjectLoad();
	
	//LoadWood();	
	//LoadPurse();
	//LoadEnters();
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
	
    SetTimer("Processor", PROCESSOR_UPDATE, false);
    SetTimer("SpeedoUpdate", 50, false);
	SetTimer("RotateFerrisWheel", FERRIS_WHEEL_WAIT_TIME, false);
	SetTimer("FuelTime", FUEL_TIME, false);
	
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
    
	CreatePickupWith3DText(1581, 362.6556,173.5869,1008.3828, "Получение APED\n>> Нажмите Y <<", 0, 5.0);
	CreatePickupWith3DText(1274, -1630.8824,-2234.4985,31.4766, "Работа дровосеком\n>> Нажмите Y <<", 0, 5.0);
	CreatePickupWith3DText(1212, 2537.3064,-1286.8135,1054.6406, "Продажа транспорта\n>> Нажмите Y <<", 0, 5.0);
	CreatePickupWith3DText(1212, -2032.7780,-116.5089,1035.1719, "Аренда транспорта\n>> Нажмите Y <<", 0, 5.0);
	CreatePickupWith3DText(1650, -2234.2949,-2568.0117,32.1219, "Автозаправочная станция\n>> Нажмите H <<", 0, 15.0);
	CreatePickupWith3DText(1650, -1541.2645,-2742.2102,48.7381, "Автозаправочная станция\n>> Нажмите H <<", 0, 15.0);
	CreatePickupWith3DText(1275, 254.8472,77.0973,1003.6406, "Раздевалка\n>> Нажмите Y <<", 0, 4.0); 
	CreatePickupWith3DText(1275, 267.0403,118.3147,1004.6172, "Раздевалка\n>> Нажмите Y <<", 0, 4.0); 	
	CreatePickupWith3DText(1275, 350.9631,188.9638,1019.9844, "Раздевалка\n>> Нажмите Y <<", 1, 4.0);
	CreatePickupWith3DText(2061, 222.9965,79.8031,1005.0391, "Выдача оружия\n>> Нажмите Y <<", 0, 4.0);
	CreatePickupWith3DText(1273, 371.1688,187.4530,1014.1875, "Отдел по работе с недвижимостью\n>> Нажмите Y <<", 0, 5.0);
		
	
	
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
	
    ActorWoodMan = CreateActor(161, -1629.7593,-2233.2476,31.4766,135.0107);
    ApplyActorAnimation(ActorWoodMan, "PED", "idlestance_old", 3.9, 1, 0, 0, 0, 0);
	
    ActorKapitoliyWomen = CreateActor(141, 359.7169,173.6097,1008.3893,268.1367);
    ApplyActorAnimation(ActorKapitoliyWomen, "PED", "woman_idlestance", 3.9, 1, 0, 0, 0, 0);
	
	ActorAPPD = CreateActor(309, 220.8941,79.8343,1005.0391,270.7289);
	ApplyActorAnimation(ActorAPPD, "DEALER", "DEALER_IDLE", 3.9, 1, 0, 0, 0, 0);
	
	ActorRestaraunt = CreateActor(189, -782.9186,498.3218,1371.7422,358.9113);
	ApplyActorAnimation(ActorRestaraunt, "DEALER", "DEALER_IDLE_01", 3.9, 0, 0, 0, 0, 0);
	
	ActorZero = CreateActor(289, -2237.6453,128.5868,1035.4141,359.5548);
	ApplyActorAnimation(ActorZero, "COP_AMBIENT", "Coplook_think", 3.9, 0, 0, 0, 0, 0);
	
	ActorHospital = CreateActor(308, 364.0134,169.4868,1019.9844,181.1555);
	SetActorVirtualWorld(ActorHospital, 1);
	
	CreateActor(192, -28.6500,-186.8251,1003.5469,0.8175);
	CreateActor(194, -2034.8375,-116.8023,1035.1719,274.6687);
	CreateActor(219, 162.3062,-81.1858,1001.8047,180.4836);	
	
	ConnectNPC("TrainDriverLV","train_lv");
    
    blackmap = GangZoneCreate(-3000.0,-3000.0,3000.0,3000.0);
	
	
	FerrisWheelObjects[10]=CreateObject(18877,-2109.0000000,-2397.0000000,44.3000000,0.0000000,0.0000000,322.0000000,300); // спицы
    FerrisWheelObjects[11]=CreateObject(18878,-2109.0000000,-2397.0000000,44.5000000,0.0000000,0.0000000,232.0000000,300); // колесо
    forEx((sizeof FerrisWheelObjects)-2,x)
	{
		FerrisWheelObjects[x]=CreateObject(18879,-2109.0000000,-2397.0000000,44.3000000,0.0000000,0.0000000,52.0000000,300); // кабинки
		AttachObjectToObject(FerrisWheelObjects[x], FerrisWheelObjects[10],gFerrisCageOffsets[x][0],gFerrisCageOffsets[x][1],gFerrisCageOffsets[x][2],0.0000000,0.0000000,52.0000000, 0);
	}
	
	return 1;
}

public OnGameModeExit()
{
    foreach(Player, i)
	{
		SaveAccount(i);
		gPlayerLogged[i] = false;
	}
	
	forEx(sizeof FerrisWheelObjects,x) DestroyObject(FerrisWheelObjects[x]);
	
	TextDrawDestroy(skin[0]);TextDrawDestroy(skin[1]);TextDrawDestroy(skin[2]);//удаляем созданные текстдравы  
	mysql_close(mysql_connect_ID);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	/*
	TogglePlayerSpectating(playerid, 1);
	
	SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z] + 0.5,
	PlayerInfo[playerid][pFa], 0, 0, 0, 0, 0, 0);
	
	SpawnPlayer(playerid);*/
	
	SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z] + 0.5,
	PlayerInfo[playerid][pFa], 0, 0, 0, 0, 0, 0);
	if(!GetPVarInt(playerid, "OnPlayerRequestClassFix"))
	{
		if(GetPVarInt(playerid, "OnPlayerRequestClass_F4_Bug")) return SpawnPlayer(playerid);
		TogglePlayerSpectating(playerid, true);
		SetTimerEx("TogglePlayerSpectatingOff", 500, 0, "i", playerid);
	}
	else DeletePVar(playerid, "OnPlayerRequestClassFix"), SpawnPlayer(playerid);  
	
	return 1;
}

public OnPlayerConnect(playerid)
{		
	SetPVarInt(playerid, "OnPlayerRequestClassFix", 1);
	TogglePlayerSpectating(playerid, true);//Собстно, начало обхода
	SetTimerEx("SetPlayerCameraPosForReqClass", 100, 0, "i", playerid);//А это для того, чтоб камера изменилась при начале слежки  
	
	GetPlayerName(playerid, PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
	new query_string[49+MAX_PLAYER_NAME-4];
	mysql_format(mysql_connect_ID, query_string, sizeof(query_string), "SELECT * FROM `accounts` WHERE `Name` = '%s'", PlayerInfo[playerid][pName]);
	mysql_tquery(mysql_connect_ID, query_string, "FindPlayerInTable","i", playerid);
	
	ResetPlayerMoney(playerid); 
	
    for( new i = 0; i <= 20; i ++ ) SendClientMessage(playerid,COLOR_YELLOW,"");

    if(!SpecON[playerid])
	{
	    TogglePlayerSpectating(playerid, true);
	    SetTimerEx("OnPlayerConnect", 300, 0, "i", playerid);
	    SpecON[playerid] = true;
	    return 1;
	}
    
    gPlayerLogged[playerid] = false;
    ClearAnimations(playerid);
    animloading[playerid] = false;
	PlayerDeath[playerid] = false;
	FonBox[playerid] = 0; 
    PlayerTextDrawDestroy(playerid, fon_PTD[playerid]);  
    
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
    SaveAccount(playerid);
    gPlayerLogged[playerid] = false;
	
	memset(PlayerInfo[playerid],0, pInfo);
	
	KillTimer(PlayerTimerID[playerid]);
	if (loginkicktimer[playerid])
		KillTimer(loginkicktimer[playerid]);
	
	return 1;
}

public OnPlayerSpawn(playerid)
{
	
	DeletePVar(playerid, "OnPlayerRequestClass_F4_Bug");
	
	updatepositiontimestamp[playerid] = GetTickCount()+AC_UP__IGNORE_TIME;
	
	if(PlayerInfo[playerid][pReg] == 1)
	{
		SetSkin(playerid);
		return 1;
	}
	if(PlayerInfo[playerid][pReg] == 2)
	{
		if(PlayerDeath[playerid])
		{			
			SetPlayerPos(playerid, 343.2550, 161.0479, 1020.7661);
			SetPlayerFacingAngle(playerid, 269.9050); 
			SetPlayerInterior(playerid, 3);
			SetPlayerVirtualWorld(playerid, 1);
			
			ApplyAnimation(playerid, "CRACK", "crckidle4", 4.1, 0, 1, 1, 1, 1, 1);
			
			PlayerInfo[playerid][pHP] = 10.0;
			
			PlayerDeath[playerid] = false;
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
		
		SetPlayerHealth(playerid, PlayerInfo[playerid][pHP]);
		GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
		
		SetCameraBehindPlayer(playerid);
		
		if(PlayerInfo[playerid][pAPED] == 0) GangZoneShowForPlayer(playerid, blackmap, 255);
		else 
		{
			GangZoneHideForPlayer(playerid, blackmap);
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
	PlayerDeath[playerid] = true;
	PlayerInfo[playerid][pHP] = 1.0;
	DeletePVar(playerid, "IsPlayerSpawn");
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	SetVehicleHealth(vehicleid, VehInfo[vehicleid][vHP]);
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
	
	if(p_muted{playerid})
	{
		SendClientMessage(playerid, COLOR_GREY, "Вы заткнуты.");
		return 0;
	}  
	
    new string[145];
	
    format(string, sizeof(string), "%s говорит:"COL_WHITE" %s", Name(playerid), text);
    ProxDetector(playerid, COLOR_PROX, string, 10);
	
    SetPlayerChatBubble(playerid,text,COLOR_PROX,20.0,7000);
	
	GiveEndurance(playerid, -1);
	
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
		if(VehInfo[veh][vBuy] == VBUYTOSELL)
	    {
			SendClientMessage(playerid,COLOR_WHITE,"Этот транспорт для дальнейшей продажи. Его необходимо припарковать.");
	    	return 1;
	    }
	    if(VehInfo[veh][vBuy] == VBUYTOBUY && VehInfo[veh][vPrice] > 0)
	    {
	    	new string[256];
			
	    	format(string,sizeof(string),""COL_BLUE"\nДанный транспорт выставлен на продажу.\nМодель: "COL_WHITE"%s\n"COL_BLUE"Стоимость: "COL_WHITE"%d $\n\
			"COL_BLUE"Вы хотите приобрести данный транспорт?\n",VehicleNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400], VehInfo[veh][vPrice]);
	    	ShowPlayerDialog(playerid,DIALOG_ID_BUYCAR,D_S_M,""COL_ORANGE"Авторынок",string,"Купить","Отмена");
	    	return 1;
	    }
	    if(VehInfo[veh][vBuy] == VBUYTORENT && GetPVarInt(playerid, "DostupRentCar"))
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
			
		    ApplyAnimation( playerid, "CARRY", "putdwn", 4.0, 0, 1, 1, 0, 800);
			
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
	
	if (HOLDING(KEY_SPRINT))
	{
		PlayerRun[playerid] = true;
		
		if(PlayerInfo[playerid][pEndurance] < TWOHOURS && !IsPlayerInAnyVehicle(playerid))
		{
			TogglePlayerControllable(playerid, 0);
			ClearAnimations(playerid);
			ApplyAnimation(playerid, "FAT", "IDLE_tired", 4.0, 1, 0, 0, 0, 0);			
		}
	}
	if (RELEASED(KEY_SPRINT)) 
	{
		PlayerRun[playerid] = false;
		
		if(PlayerInfo[playerid][pEndurance] < TWOHOURS)
		{
			TogglePlayerControllable(playerid, 1);
		}
	}
	
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
	
		if(PlayerInfo[playerid][pMember] == VehInfo[vid][vBuy])
  		return StartEngine(vid, playerid);
	
		else return	SendClientMessage(playerid,COLOR_RED,"У вас нет ключей от этого транспорта.");
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
				
                SetTimerEx("TogglePlayerControllablePublic", 10000, 0, "%d", targetplayer);
            }
        }
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
		
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 346.4707,170.1382,1020.0643))
		{
			if(AmbulanceDoorOpen) 
			return 	MoveObject (AmbulanceDoor, 346.7000100,169.0000000,1019.0000000, 0.01, 0.0000000,0.0000000,270.0000000), AmbulanceDoorOpen = false, 
					GameTextForPlayer(playerid, FixText("~R~Дверь закрывается"), 1500, 3);
			
			new var = 1337;
			new szKey[5]; valstr(szKey, var); 
			
			ShowPlayerKeypad(playerid, KEYPAD_AMBULANCEDOOR, szKey);
		}
		
		foreach(new i : House)
		{
	        if(		IsPlayerInRangeOfPoint(playerid, 1.5, HouseInfo[i][hEnterX], HouseInfo[i][hEnterY], HouseInfo[i][hEnterZ])
				||	(IsPlayerInRangeOfPoint(playerid, 1.5, HouseInfo[i][hExitX], HouseInfo[i][hExitY], HouseInfo[i][hExitZ]) &&
					GetPlayerVirtualWorld(playerid) == HouseInfo[i][hVirt]))
	        {				
				if(PlayerInfo[playerid][pHouse] == i)
				{
					static D43[] = 
							""COL_BLUE"Объект: \t"COL_WHITE"Состояние:"\
							"\n"COL_BLUE"Дверь: \t%s";
					new d43[sizeof(D43)+20],
						status1[20];
						
					status1 = (HouseInfo[i][hLock] == 0) ?  (""COL_STATUS1"Открыта") : (""COL_STATUS6"Закрыта");
								
					format(d43, sizeof(d43), D43, status1);
					ShowPlayerDialog(playerid, DIALOG_ID_HOUSESETTINGS, D_S_TH,""COL_ORANGE"Настройки дома", d43, "Выбрать", "Назад");
					return true; 	
				}
			}
		}

	}
	
    if (newkeys == KEY_YES)
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
		
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 222.9965,79.8031,1005.0391) && PlayerInfo[playerid][pMember] == 2)
		{
			static D39[] = 
					""COL_WHITE"Привет, %s!\n\
					Пришел получить свою амуницию и оружие?\n";
					
			new d39[26+43-2+MAX_PLAYER_NAME+1];
			
			format(d39, sizeof(d39), D39, Name(playerid));
			
			ShowPlayerDialog(playerid, DIALOG_ID_APPDWEAPON, D_S_M,""COL_ORANGE"Комната хранения оружия", d39, "Да", "Нет");
			return 1;
		}
		
		if(IsPlayerInRangeOfPoint(playerid, 3.0, -2032.4177,-116.3887,1035.1719))
		{
		    new str[95];
			
		    format(str,sizeof(str), ""COL_BLUE"\nЗдравствуйте, у нас Вы можете арендовать мопед.\nСтоимость аренды мопеда: "COL_GREEN"%d $.", CENA_ARENDI);
			ShowPlayerDialog(playerid, DIALOG_ID_RENTMOPED, D_S_M, ""COL_ORANGE"Аренда мопеда", str, "Арендовать", "Отмена");
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
			new d34[400];
			
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
			new d40[sizeof(D40)];
			
			format(d40, sizeof(d40), D40, NALOG_BUYSELLHOUSE);
			ShowPlayerDialog(playerid, DIALOG_ID_BUYSELLHOUSE, D_S_M,""COL_ORANGE"Отдел по работе с недвижимостью",d40,"Купить","Продать");
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
			&& GetPlayerVirtualWorld(playerid) == HouseInfo[i][hVirt] && HouseInfo[i][hOwned] != 0 && !IsPlayerBlackScreen[playerid])
			{
				ShowPlayerHouseDialog(playerid);
				return 1;
			}
		}
		
		if(!GetPVarInt(playerid, "Refill")) cmd::vmenu(playerid, "");
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
			
		    format(str,sizeof(str), ""COL_BLUE"\nЗдравствуйте, вас приветствует АЗС округа 'Angel Pine'\nВведите количество литров, которое вы хотите наполнить в бензобак:\n\
			Стоимость одного литра: "COL_GREEN"%d $",CENA_BENZ);
			ShowPlayerDialog(playerid, DIALOG_ID_REFILL, D_S_I,""COL_ORANGE"АЗС",str,"Принять","Отмена");
		    return 1;
		}
	}
	
	if (newkeys == KEY_NO && PlayerInfo[playerid][pAPEDBattery] > 0 && PlayerInfo[playerid][pAPED] == 1)
	{		
		for(new i; i <= 9; i++)
		{
			TextDrawShowForPlayer(playerid, TDEditor_TD[i]);
		}
		if(PlayerInfo[playerid][pAdmin] > 0) TextDrawShowForPlayer(playerid, TDEditor_TD[10]);
		SelectTextDraw(playerid, 0x00FF00FF);
		CloseTextDrawAPED[playerid] = true;
		
		new string[MAX_PLAYER_NAME+1+38];
				
		format(string, sizeof(string), "%s достает свой APED и смотрит на его экран.", Name(playerid));
		ProxDetector(playerid, COLOR_PROX, string, 10);
	}
	
    if (newkeys == KEY_WALK && !IsPlayerBlackScreen[playerid])
   	{
    	foreach(new i : House)
		{
	        if(IsPlayerInRangeOfPoint(playerid, 1.5, HouseInfo[i][hEnterX],HouseInfo[i][hEnterY],HouseInfo[i][hEnterZ]))
	        {
				if(HouseInfo[i][hOwned] == 0 && HouseInfo[i][hAdd] != 0)
				{
				  	new string[140];
					
				  	format(string, sizeof(string), ""COL_BLUE"Этот дом выставлен на продажу.\n\nID дома: "COL_WHITE"%d\n"COL_BLUE"Цена: "COL_GREEN"%d $\n\n"COL_BLUE"Хотите ли вы осмотреть дом?\n", i, HouseInfo[i][hPrice]);
					
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
		for(new i = 0; i < sizeof(EnterInfo); i++)
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
	
	if(newkeys & KEY_SPRINT || newkeys & KEY_JUMP)  
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid, 1) && GetPVarInt(playerid, "StartJob") ==  1) 
		{
			RemovePlayerAttachedObject(playerid, 1);
			ClearAnimations(playerid);
			ApplyAnimation(playerid,"PED","getup_front", 4.0, 0, 0, 0, 0, 0); 
			
			GiveEndurance(playerid, -2);
			
			SetPVarInt(playerid, "StartJob", 0);
		    new Random = random(sizeof(RandomWood));
			SetPlayerRaceCheckpoint(playerid,0,RandomWood[Random][0], RandomWood[Random][1], RandomWood[Random][2],RandomWood[Random][0], RandomWood[Random][1],
			RandomWood[Random][2],0.5);
		   	WoodRand[playerid] = Random;
			
			SendClientMessage(playerid, COLOR_GREY,"Вы уронили бревна.");
		}
		/*if(PlayerInfo[playerid][pEndurance] < TWOHOURS)
			ClearAnimations(playerid), ApplyAnimation(playerid, "FAT", "IDLE_tired", 4.0, 0, 0, 0, 0, 0);*/
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
		
		case DIALOG_ID_REGISTER:
		{
			if(!response)
			{
				ShowPlayerDialog(playerid, DIALOG_ID_NONE, DIALOG_STYLE_MSGBOX, ""COL_ORANGE"Оповещение", ""COL_BLUE"Вы были отсоединены от сервера.\n\
				Для выхода с сервера введите \"/q\" в чат", "", "");
				
				return Kick(playerid);
			}
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_ID_REGISTER, D_S_P, ""COL_ORANGE"Регистрация аккаунта",
			""COL_RED"Ошибка: "COL_BLUE"Вы не ввели пароль!\n\n\
			"COL_YELLOW"Примечание:\n"COL_BLUE"Пароль чувствителен к регистру. Пароль должен содержать "COL_WHITE"от 3 до 30 символов.\n\
			"COL_BLUE"Пароль может содержать латинские/кириллические символы и цифры "COL_WHITE"(aA-zZ, аА-яЯ, 0-9).\n\n\
			"COL_WHITE"\tВведите пароль для регистрации нового аккаунта:\n", "Регистрация", "Выход");
			
			if(30 < strlen(inputtext) ||  strlen(inputtext) < 3) return ShowPlayerDialog(playerid, DIALOG_ID_REGISTER, D_S_P, ""COL_ORANGE"Регистрация аккаунта",
			""COL_RED"Ошибка: "COL_BLUE"Пароль должен содержать "COL_WHITE"от 3 до 30 символов.\n\
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
			
			//strins(PlayerInfo[playerid][pPass], inputtext, 0);
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
				new query_string[49+MAX_PLAYER_NAME];
				
				mysql_format(mysql_connect_ID, query_string, sizeof(query_string), "SELECT * FROM `accounts` WHERE `Name` = '%s'", PlayerInfo[playerid][pName]);
				mysql_tquery(mysql_connect_ID, query_string, "UploadPlayerAccount","i", playerid);
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
				
				ShowPlayerDialog(playerid, DIALOG_ID_REGISTER, D_S_P,""COL_ORANGE"Регистрация аккаунта"," "COL_BLUE"Приветствуем Вас на нашем сервере\n Придумайте себе пароль \
				для дальнейшего проживания в округе 'Angel Pine'\n", "Регистрация","Выход");
	        }
	        else
	        {
                SetPVarInt(playerid, "Skin", 148);
                SetPVarInt(playerid, "Sex", 2);
				
				ShowPlayerDialog(playerid, DIALOG_ID_REGISTER, D_S_P,""COL_ORANGE"Регистрация аккаунта"," "COL_BLUE"Приветствуем Вас на нашем сервере\n Придумайте себе пароль \
				для дальнейшего проживания в округе 'Angel Pine'\n", "Регистрация", "Выход");
	        }
	    }
			    
	    case DIALOG_ID_BUYCAR:
    	{
    		if(response)
        	{
        	    new car = GetPlayerVehicleID(playerid);
            	if(!IsPlayerInAnyVehicle(playerid) || VehInfo[car][vBuy] != VBUYTOBUY) return 1;
				
            	if(PlayerInfo[playerid][pMoney] < VehInfo[car][vPrice])
				{
					SendClientMessage(playerid,COLOR_RED,"У вас недостаточно денег для покупки");
					return 1;
				}
				
				if(PlayerInfo[playerid][pCarKey] != 0)
				{
					SendClientMessage(playerid,COLOR_RED,"У вас уже есть транспортное средство");
					return 1;
				}
				
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
 			/*else
			{
			    RemovePlayerFromVehicle(playerid);
			    TogglePlayerControllable(playerid, 1);
			}*/
		}
		
		case DIALOG_ID_VMENU:
  		{
    		if(response)
      		{				
				if(listitem >= 0 && listitem <= 6)
                {
					static const
						fmt_str1_0[] = " вставляет ключ в замок зажигания (Заводит двигатель).",
						fmt_str1_1[] = " вытаскивает ключ из замка зажигания (Глушит двигатель).",
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
						fmt_str7_0[] = " активирует поиск транспорта по GPS.",
						fmt_str7_1[] = " деактивирует поиск транспорта по GPS.";
					
					const
						size = sizeof(fmt_str7_1) + (MAX_PLAYER_NAME+1);
					
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
							Engine[carid] = (Engine[carid]) ? false : true;
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
						case 6: strcat(string, (!params[6]) ? (fmt_str7_0) : (fmt_str7_1));
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
				    format(str,sizeof(str), ""COL_BLUE"\nЗдравствуйте, вас приветствует АЗС округа 'Angel Pine'\nВведите количество литров, которое вы хотите наполнить в бензобак:\n\
					Стоимость одного литра: "COL_GREEN"%d $",CENA_BENZ);
					ShowPlayerDialog(playerid, DIALOG_ID_REFILL, D_S_I,""COL_ORANGE"АЗС",str,"Принять","Отмена");
					return 1;
				}
				
	            new carid = GetPlayerVehicleID(playerid);
	            inputfuel[playerid] = strval(inputtext);
				
	            if(VehInfo[carid][vFuel] + inputfuel[playerid] > 100)
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
				
				GameTextForPlayer(playerid, FixText("~G~Ожидайте, идет заправка..."), 3000, 3);
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
					new str[46 -2 + 9];
					
					format(str,sizeof(str), ""COL_BLUE"\nСпасибо за помощь, вот Ваши "COL_GREEN"%d $.\n",PlayerInfo[playerid][pMoneyDolg]);
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
				UpdateDataInt(PlayerInfo[target][pID], "accounts", "Member", PlayerInfo[target][pMember]);
				UpdateDataInt(PlayerInfo[target][pID], "accounts", "Leader", PlayerInfo[target][pLeader]);
				
				WriteLogByTypeName("Leader", PlayerInfo[playerid][pID], PlayerInfo[target][pID], fraction_name[listitem]);

				ShowPlayerDialog(target, DIALOG_ID_SETLEADERRANK, D_S_I, ""COL_ORANGE"Установить ранг", ""COL_BLUE"Введите название для своего ранга\n",
				"Принять", "");
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
				
				WriteLogByTypeName("Unleader", PlayerInfo[playerid][pID], PlayerInfo[target][pID], inputtext);
					
				PlayerInfo[target][pMember] = 0;
				PlayerInfo[target][pLeader] = 0;
				PlayerInfo[target][pMemberWarn] = 0;
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
				UpdateDataVarchar(PlayerInfo[playerid][pID], "accounts", "RankName", PlayerInfo[playerid][pRankName]);
            	
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
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "Member", PlayerInfo[playerid][pMember]);
                
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
						new string[1040], string1[85 + MAX_PLAYER_NAME + 4 + 32 + 1]; 
						foreach(Player, i)
						{  
							if(PlayerInfo[playerid][pMember] != PlayerInfo[i][pMember]) continue; 
							
							format(string, sizeof(string), ""COL_APED"%s \t"COL_APED"%d \t"COL_APED"%s \t"COL_APED"%d\n",
									Name(i), i, PlayerInfo[i][pRankName], PlayerInfo[i][pMemberWarn]);
									
							strcat(string1, string, sizeof(string1)); 
						} 
						format(string, sizeof(string), ""COL_WHITE"Имя: \t"COL_WHITE"ID: \t"COL_WHITE"Ранг: \t"COL_WHITE"Кол-во выговоров: \n%s", string1); 
						ShowPlayerDialog(playerid, DIALOG_ID_BACKTOLMENU, D_S_TH, ""COL_ORANGE"Члены организации онлайн", string, "Закрыть", "Назад"); 
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
	            if (strval(inputtext) == INVALID_PLAYER_ID || gPlayerLogged[strval(inputtext)] == false)
				return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети."), ShowPlayerLeaderDialog(playerid);
			
				if (strval(inputtext) == playerid) return SendClientMessage(playerid, COLOR_GREY, "Вы ввели свой ID."), ShowPlayerLeaderDialog(playerid);
				
				if (PlayerInfo[strval(inputtext)][pMember] > 0)
				return SendClientMessage(playerid, COLOR_GREY,"Этот игрок уже состоит в другой организации."), ShowPlayerLeaderDialog(playerid);
				
				IDFrac[strval(inputtext)] = PlayerInfo[playerid][pLeader];
				IDLeader = playerid;
				
				new string[66 - 6 + 4 + MAX_PLAYER_NAME + MAX_FRACTION_NAME_LENGTH];
			 					
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
				
	            if (strval(inputtext) == INVALID_PLAYER_ID || gPlayerLogged[strval(inputtext)] == false) 
				return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети."), ShowPlayerLeaderDialog(playerid);
				
				if(strval(inputtext) == playerid) 
				return SendClientMessage(playerid, COLOR_GREY, "Вы ввели свой ID."), ShowPlayerLeaderDialog(playerid);
				
				if(PlayerInfo[strval(inputtext)][pMember] != PlayerInfo[playerid][pMember])
				return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в вашей организации."), ShowPlayerLeaderDialog(playerid);
				
				new string[49 - 6 +4 + MAX_FRACTION_NAME_LENGTH + MAX_PLAYER_NAME];
				
				format(string,sizeof(string), ""COL_BLUE"\n[%d] %s уволил вас из организации "COL_WHITE"%s\n",playerid,Name(playerid),fraction_name[PlayerInfo[playerid][pLeader]]);
				ShowPlayerDialog(strval(inputtext), DIALOG_ID_NONE, D_S_M,""COL_ORANGE"Увольнение из организации",string, "Принять", "");
				
				PlayerInfo[strval(inputtext)][pMember] = 0;
				PlayerInfo[strval(inputtext)][pMemberWarn] = 0;
				PlayerInfo[strval(inputtext)][pMemberSkin] = 0;
				PlayerInfo[strval(inputtext)][pRankName] = 0;
				UpdateDataInt(PlayerInfo[strval(inputtext)][pID], "accounts", "Member", PlayerInfo[strval(inputtext)][pMember]);
				UpdateDataInt(PlayerInfo[strval(inputtext)][pID], "accounts", "MemberWarn", PlayerInfo[strval(inputtext)][pMemberWarn]);
				UpdateDataInt(PlayerInfo[strval(inputtext)][pID], "accounts", "MemberSkin", PlayerInfo[strval(inputtext)][pMemberSkin]);
				UpdateDataVarchar(PlayerInfo[strval(inputtext)][pID], "accounts", "RankName", PlayerInfo[strval(inputtext)][pRankName]);
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
				
	            if (strval(inputtext) == INVALID_PLAYER_ID || gPlayerLogged[strval(inputtext)] == false) 
				return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети."), ShowPlayerLeaderDialog(playerid);
			
				if(strval(inputtext) == playerid) 
				return SendClientMessage(playerid, COLOR_GREY, "Вы ввели свой ID."), ShowPlayerLeaderDialog(playerid);
				
				if(PlayerInfo[strval(inputtext)][pMember] != PlayerInfo[playerid][pMember]) 
				return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в вашей организации."), ShowPlayerLeaderDialog(playerid);
				
				PlayerInfo[strval(inputtext)][pMemberWarn] += 1;
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "MemberWarn", PlayerInfo[playerid][pMemberWarn]);
				
				new string[62 - 6 +1 + 4 + MAX_PLAYER_NAME];
				
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
				
	            if (strval(inputtext) == INVALID_PLAYER_ID || gPlayerLogged[strval(inputtext)] == false) 
				return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети."), ShowPlayerLeaderDialog(playerid);
			
				if(strval(inputtext) == playerid) 
				return SendClientMessage(playerid, COLOR_GREY, "Вы ввели свой ID."), ShowPlayerLeaderDialog(playerid);
				
				if(PlayerInfo[strval(inputtext)][pMember] != PlayerInfo[playerid][pMember]) 
				return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в вашей организации."), ShowPlayerLeaderDialog(playerid);
				
				PlayerInfo[strval(inputtext)][pMemberWarn] -= 1;
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "MemberWarn", PlayerInfo[playerid][pMemberWarn]);
				
				new string[74 - 6 +1 + 4 + MAX_PLAYER_NAME];
				
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
	            if (strval(inputtext) == INVALID_PLAYER_ID || gPlayerLogged[strval(inputtext)] == false) 
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
	            new string[63 + 4 + MAX_PLAYER_NAME - 4];
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {
	                format(string,sizeof(string), ""COL_BLUE"Введите название ранга для игрока "COL_WHITE"[%d] %s\n",strval(inputtext),Name(strval(inputtext)));
					ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERRANKNAME, D_S_I,""COL_ORANGE"Установить ранг",string, "Принять", "Назад");
	                return 1;
	            }
	            if (GetPVarInt(playerid, "MemberRangID") == INVALID_PLAYER_ID || gPlayerLogged[GetPVarInt(playerid, "MemberRangID")] == false) 
				return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
			
				if(PlayerInfo[GetPVarInt(playerid, "MemberRangID")][pMember] != PlayerInfo[playerid][pMember]) 
				return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в вашей организации.");
			
				strmid(PlayerInfo[GetPVarInt(playerid, "MemberRangID")][pRankName], inputtext, 0, strlen(inputtext), 32);
				UpdateDataVarchar(PlayerInfo[GetPVarInt(playerid, "MemberRangID")][pID], "accounts", "RankName",
				PlayerInfo[GetPVarInt(playerid, "MemberRangID")][pRankName]);
				
				format(string, sizeof(string), "Вы установили игроку %s ранг %s.", Name(GetPVarInt(playerid, "MemberRangID")), inputtext);
				SendClientMessage(playerid, COLOR_GREEN, string);
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
				
	            if (strval(inputtext) == INVALID_PLAYER_ID || gPlayerLogged[strval(inputtext)] == false) 
				{
					SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
					ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERSKINID, D_S_I, ""COL_ORANGE"Установить скин", "\
					"COL_BLUE"Введите ID игрока, которому вы хотите установить скин:\n\
					", "Принять", "Назад");
					return 1;
				}
			
				if(PlayerInfo[strval(inputtext)][pMember] != PlayerInfo[playerid][pMember]) 
				{
					SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в вашей организации.");
					ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERSKINID, D_S_I, ""COL_ORANGE"Установить скин", "\
					"COL_BLUE"Введите ID игрока, которому вы хотите установить скин:\n\
					", "Принять", "Назад");
					return 1;
				}
			
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
	            new string[60 + 5 + MAX_PLAYER_NAME - 4];
	            if(!strlen(inputtext))// Если окно ввода пустое, выводим диалог снова
	            {
	                format(string,sizeof(string), ""COL_BLUE"Введите номер скина для игрока "COL_WHITE"[%d] %s\n",strval(inputtext),Name(strval(inputtext)));
					ShowPlayerDialog(playerid, DIALOG_ID_SETMEMBERSKIN, D_S_I,""COL_ORANGE"Установить скин",string, "Принять", "Назад");
	                return 1;
	            }
	            if (GetPVarInt(playerid, "MemberSkinID") == INVALID_PLAYER_ID || gPlayerLogged[GetPVarInt(playerid, "MemberSkinID")] == false) 
				return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
			
				if(PlayerInfo[GetPVarInt(playerid, "MemberSkinID")][pMember] != PlayerInfo[playerid][pMember]) 
				return SendClientMessage(playerid, COLOR_GREY,"Этот игрок не работает в вашей организации.");
			
				PlayerInfo[GetPVarInt(playerid, "MemberSkinID")][pMemberSkin] = strval(inputtext);
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "MemberSkin", PlayerInfo[playerid][pMemberSkin]);
				
				format(string, sizeof(string), "Вы установили игроку %s скин № %d.", Name(GetPVarInt(playerid, "MemberSkinID")), strval(inputtext));
				SendClientMessage(playerid, COLOR_GREEN, string);
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
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "APED", PlayerInfo[playerid][pAPED]);
				
				
				GangZoneHideForPlayer(playerid, blackmap);
				
				MapIsOn[playerid] = true;
				
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
				
				//SaveOneVeh(carid);
			}
			else ShowPlayerDialog(playerid, DIALOG_ID_SELLCARPRICE, D_S_I,""COL_ORANGE"Продажа транспорта",""COL_WHITE"Введите сумму, которую хотите получить за продажу транспорта:\n"
			,"Принять","Отмена");
		}
		
		case DIALOG_ID_CHANGECLOTHES: 
		{
			if(response)
			{
				new string[MAX_PLAYER_NAME+1+49];
				
				format(string, sizeof(string), "%s достает сменную одежду из шкафа и переодевается.", Name(playerid));
				ProxDetector(playerid, COLOR_PROX, string, 10);
				
				ShowFonForPlayer(playerid);
				
				IsPlayerBlackScreen[playerid] = true;

				GiveEndurance(playerid, -2);				
				
				SetTimerEx("BlackScreenTimer", 500, 0, "i", playerid);
			}
		}
		
		case DIALOG_ID_PLAYERINFODIALOG:
		{	
			if(response)
			{
				for(new i; i <= 10; i++)
				{
					TextDrawHideForPlayer(playerid, TDEditor_TD[i]);
				}
				CancelSelectTextDraw(playerid); 
				CloseTextDrawAPED[playerid] = false;
			}
			if(!response)
			{
				new string[MAX_PLAYER_NAME+1 -2 +42];
				
				format(string, sizeof(string), "%s поднимает взгляд с экрана и убирает APED.", Name(playerid));
				ProxDetector(playerid, COLOR_PROX, string, 10);
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
		}
		
		case DIALOG_ID_APPDWEAPON: 
		{
			if(response)
			{
				new string[MAX_PLAYER_NAME+1 -2 +39];
				
				format(string, sizeof(string), "%s забирает со стола амуницию, оружие и патроны.", Name(playerid));
				ProxDetector(playerid, COLOR_PROX, string, 3);
				
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
						
						ShowPlayerDialog(playerid, DIALOG_ID_ADMINMENUTPLIST, D_S_L,""COL_ORANGE"Телепорт по местам", dialog_string
						,"Принять","Назад");
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
			else ShowPlayerAdminDialog(playerid);
			return 1;
		}
		
		case DIALOG_ID_BUYSELLHOUSE:
		{
			if(response)
			{
				if(PlayerInfo[playerid][pHouse] != 0) return ProxDetector(playerid, COLOR_PROX,
				"Марта говорит: "COL_WHITE"В нашей базе данных есть сведения, что у Вас уже есть дом. Необходимо продать его, прежде чем покупать новый.", 10.0); 
				
				static const 	title[] = ""COL_WHITE"ID: \t"COL_WHITE"Стоимость: \n";
								
				new string[sizeof(title) + 15*MAX_HOUSES];
				
				string = title;
				
				foreach(new h : House)
				{
					if(HouseInfo[h][hAdd] != 1 || HouseInfo[h][hOwned] != 0) continue;
					format(string, sizeof(string),"%s%i\t"COL_GREEN"%i\n", string, h, HouseInfo[h][hPrice]);
				}
				
				new header[58];

				format(header, sizeof(header), ""COL_ORANGE"Покупка дома. Количество свободных домов: "COL_APED"%d", Iter_Count(House));
				
				ShowPlayerDialog(playerid, DIALOG_ID_BUYHOUSE, D_S_TH, header, string, "Купить", "Выход");
			}
			else
			{
				new houseid = PlayerInfo[playerid][pHouse];
				
				if(houseid == 0) return ProxDetector(playerid, COLOR_PROX,
				"Марта говорит: "COL_WHITE"В нашей базе данных нет сведений о Вашем доме.", 10.0);
				
				static D42[] = 
					""COL_WHITE"Ваш № дома: "COL_APED"%d.\n\
					"COL_WHITE"Его первоначальная стоимость: "COL_STATUS2"%d $\n\n\
					"COL_WHITE"Выставив дом на продажу вы получите: "COL_GREEN"%d $\n\n\
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
				HouseInfo[houseid][hOwned] = 0;
             	HouseInfo[houseid][hLock] = 0;
				strmid(HouseInfo[houseid][hOwner], "Angel Pine", 0, 10, 11);
				
				UpdateDataInt(houseid, "houses", "Owned", HouseInfo[houseid][hOwned]);
				UpdateDataInt(houseid, "houses", "Lock", HouseInfo[houseid][hLock]);
				UpdateDataVarchar(houseid, "houses", "Owner", HouseInfo[houseid][hOwner]);
				
				purse -= HouseInfo[houseid][hPrice]/2;
				//SavePurse();
				
             	PlayerInfo[playerid][pMoney] += HouseInfo[houseid][hPrice]/2;
				PlayerInfo[playerid][pHouse] = 0;
				UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "House", PlayerInfo[playerid][pHouse]);

				
				GameTextForPlayer(playerid, FixText("~G~Дом продан"), 1500, 3);
			}
			else return ProxDetector(playerid, COLOR_PROX, 
			"Марта говорит: "COL_WHITE"Приходите как надумаете продать свой дом.", 10.0);
			
			return 1;
		}
		
		case DIALOG_ID_BUYHOUSE:
		{
			if(response)
			{
				if(PlayerInfo[playerid][pMoney] < HouseInfo[listitem+1][hPrice])
				{
					static const 	title[] = ""COL_WHITE"ID: \t"COL_WHITE"Стоимость: \n";
								
					new string[sizeof(title) + 15*MAX_HOUSES];
					
					string = title;
					
					foreach(new h : House)
					{
						if(HouseInfo[h][hAdd] != 1 || HouseInfo[h][hOwned] != 0) continue;
						format(string, sizeof(string),"%s%i\t"COL_GREEN"%i\n", string, h, HouseInfo[h][hPrice]);
					}
					
					ShowPlayerDialog(playerid, DIALOG_ID_BUYHOUSE, D_S_TH, ""COL_ORANGE"Покупка дома", string, "Купить", "Выход");
					
					ProxDetector(playerid, COLOR_PROX, "Марта говорит: "COL_WHITE"У Вас недостаточно денег для покупки этого дома!", 10.0);
					return 1;
				}
				
				static D41[] = 
					""COL_WHITE"Вы выбрали дом № "COL_APED"%d.\n\
					"COL_WHITE"Стоимость дома - "COL_GREEN"%d $\n\
					"COL_WHITE"Хотите купить его и зарегистрировать на себя?";
					
				new d41[sizeof(D41)-2-2+10];
			
				format(d41, sizeof(d41), D41, listitem+1, HouseInfo[listitem+1][hPrice]);
				
				ShowPlayerDialog(playerid, DIALOG_ID_BUYHOUSEACCEPT, D_S_M, ""COL_ORANGE"Покупка дома", d41, "Да", "Нет");
				
				SetPVarInt(playerid, "BuyHouseID", listitem+1);
			}
			else return ProxDetector(playerid, COLOR_PROX, 
			"Марта говорит: "COL_WHITE"У нас дома раскупают как горячие пирожки, так что не медлите с покупкой!", 10.0);
			return 1;
		}
		
		case DIALOG_ID_BUYHOUSEACCEPT:
		{
			if(response)
			{
				new houseid = GetPVarInt(playerid, "BuyHouseID");
				
             	HouseInfo[houseid][hOwned] = 1;
             	HouseInfo[houseid][hLock] = 1;
				strmid(HouseInfo[houseid][hOwner], Name(playerid), 0, strlen(Name(playerid)), MAX_PLAYER_NAME);
				
				UpdateDataInt(houseid, "houses", "Owned", HouseInfo[houseid][hOwned]);
				UpdateDataInt(houseid, "houses", "Lock", HouseInfo[houseid][hLock]);
				UpdateDataVarchar(houseid, "houses", "Owner", HouseInfo[houseid][hOwner]);
				
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
				
				foreach(new h : House)
				{
					if(HouseInfo[h][hAdd] != 1) continue;
					format(string, sizeof(string),"%s%i\t"COL_GREEN"%i\n", string, h, HouseInfo[h][hPrice]);
				}
				
				ShowPlayerDialog(playerid, DIALOG_ID_BUYHOUSE, D_S_TH, ""COL_ORANGE"Покупка дома", string, "Купить", "Выход");
			}
			return 1;
		}
		
		case DIALOG_ID_HOUSESETTINGS:
		{
			if(response)
			{
				new houseid = PlayerInfo[playerid][pHouse];
				
             	HouseInfo[houseid][hLock] = (!HouseInfo[houseid][hLock]) ? 1 : 0;
				UpdateDataInt(houseid, "houses", "Lock", HouseInfo[houseid][hLock]);
				
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
		
				format(string,sizeof(string),"%s стучит в дверь.",Name(playerid));
				ProxDetector(playerid,COLOR_PROX, string, 10.0);
				
             	GameTextForPlayer(playerid, FixText("~G~*Стук в дверь*"), 1500, 3);
				
				foreach(Player, i)
				{
					if(IsPlayerInRangeOfPoint(i, 20.0, HouseInfo[houseid][hExitX], HouseInfo[houseid][hExitY], HouseInfo[houseid][hExitZ]) &&
					GetPlayerVirtualWorld(i) == HouseInfo[houseid][hVirt])
					{
						SendClientMessage(i, COLOR_PROX, "Кто-то постучал в дверь.");
						GameTextForPlayer(i, FixText("~G~*Стук в дверь*"), 1500, 3);
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
					}
					case 1:
					{
						
					}	
					case 2:
					{
						if(PlayerInfo[playerid][pAPED] == 2) 
							return SendClientMessage(playerid, COLOR_GREY, "Ваш APED уже на зарядке.");
						
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
		
						format(string,sizeof(string),"%s ставит свой APED на зарядку.", Name(playerid));
						ProxDetector(playerid,COLOR_PROX, string, 10.0);
						
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
		
				format(string,sizeof(string),"%s отключает APED от зарядки и забирает его.", Name(playerid));
				ProxDetector(playerid,COLOR_PROX, string, 10.0);
				
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
		if(clickedid == Text:INVALID_TEXT_DRAW)
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
			} 
			else if(PlayerInfo[playerid][pSex] == 2)
			{ 
				if(cskin[playerid] < 0) cskin[playerid] = 3; 
				SetPlayerSkin(playerid, WomanSkinList[cskin[playerid]]); 
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
			UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "Skin", PlayerInfo[playerid][pSkin]);
			UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "Reg", PlayerInfo[playerid][pReg]);
			
			gPlayerLogged[playerid] = true;
			
			ShowFonForPlayer(playerid);
			SetTimerEx("HideFonAfterReg", 1300, false, "d", playerid);
		}  
	}
	
	if((clickedid == Text:INVALID_TEXT_DRAW || clickedid == TDEditor_TD[2]) && CloseTextDrawAPED[playerid])
	{
		for(new i; i <= 10; i++)
		{
			TextDrawHideForPlayer(playerid, TDEditor_TD[i]);
		}
		CancelSelectTextDraw(playerid); 
		CloseTextDrawAPED[playerid] = false;
		new string[MAX_PLAYER_NAME+1 -2 +42];
				
		format(string, sizeof(string), "%s поднимает взгляд с экрана и убирает APED.", Name(playerid));
		ProxDetector(playerid, COLOR_PROX, string, 10);
	}
	
	if(clickedid == TDEditor_TD[10] && CloseTextDrawAPED[playerid])
	{
		ShowPlayerAdminDialog(playerid);		
	}
	
	if(clickedid == TDEditor_TD[6] && CloseTextDrawAPED[playerid])
	{		
	}
	
	if(clickedid == TDEditor_TD[7] && CloseTextDrawAPED[playerid])
	{	
		ShowPlayerPlayerInfoDialog(playerid);		
	}
	
	if(clickedid == TDEditor_TD[8] && CloseTextDrawAPED[playerid])
	{
		ShowPlayerLeaderDialog(playerid);	
	}
	
	if(clickedid == TDEditor_TD[9] && CloseTextDrawAPED[playerid])
	{	
		ShowPlayerAPEDSettingsDialog(playerid);		
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
	
	if(keypadID == KEYPAD_AMBULANCEDOOR && type == KEYPAD_INPUT_GOOD)
	{
		GameTextForPlayer(playerid, FixText("~G~Дверь открывается"), 1500, 3);
		MoveObject (AmbulanceDoor, 346.7002000,169.0000000,1019.0000000+0.01, 0.01, 0.0000000,0.0000000,180.0000000);	
		AmbulanceDoorOpen = true;	
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

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
	PlayerInfo[playerid][pHP] -= amount;
	
	if(issuerid != INVALID_PLAYER_ID) // если игрок не ударился сам
    {
        new issuerweaponid = GetPlayerWeapon(issuerid);
        if(19 <= issuerweaponid <= 34 || issuerweaponid == 38) // если урон от огнестрельного оружия
        {
            switch(bodypart)
            {
                case BODY_PART_TORSO: // туловище
                {
                    PlayerInfo[playerid][pHP] -= 75.0;
                }
                case BODY_PART_GROIN: // пах
                {
                    PlayerInfo[playerid][pHP] -= 35.0;
                }
                case BODY_PART_LEFT_ARM, BODY_PART_RIGHT_ARM, BODY_PART_LEFT_LEG, BODY_PART_RIGHT_LEG: // руки, ноги
                {
                    PlayerInfo[playerid][pHP] -= 50.0;
                }
                case BODY_PART_HEAD: // голова
                {
                    PlayerInfo[playerid][pHP] -= 100.0;
                }
            }
        }
    } 
    return 1;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
    if(!gPlayerLogged[playerid]) return 0;
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


/////////////////////////////////////////////                    Команды Команды               / ///////////////////////////

////////////////////////////////                                АВТОМОБИЛИ

CMD:vmenu(playerid, params[])
{
	new carid = GetAroundPlayerVehicleID(playerid, 4.0);
	
	if(carid == PlayerInfo[playerid][pCarKey] || VehInfo[carid][vBuy] == PlayerInfo[playerid][pMember])
		return ShowPlayerVehicleDialog(playerid);
	
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
    if(engine) 
		return SendClientMessage(playerid, COLOR_RED,"Заглушите двигатель вашего транспортного средства.");
	
    TogglePlayerControllable(playerid,0);
	
    format(str,sizeof(str), ""COL_BLUE"\nЗдравствуйте, вас приветствует АЗС округа 'Angel Pine'\nВведите количество процентов, которое вы хотите наполнить в бензобак вашего транспорта:\n\
	Стоимость одного процента: "COL_GREEN"%d $",CENA_BENZ);
	ShowPlayerDialog(playerid, DIALOG_ID_REFILL, D_S_I,""COL_ORANGE"АЗС",str,"Принять","Отмена");
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
	
    CreateVehicle(VehInfo[LastCar][vModel],VehInfo[LastCar][vVPosX]+2,VehInfo[LastCar][vVPosY]+2,VehInfo[LastCar][vVPosZ]+1,VehInfo[LastCar][vVZa],VehInfo[LastCar][vColor1],VehInfo[LastCar][vColor2],60000);//
	return 1;
}

CMD:parkveh(playerid, params[])
{
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
		Передний бампер\nЗадний бампер\nКрыша\nСпойлер\nБоковые юбки\nНавесной бампер\nКолеса\nУсилители звука\nГидравлика\nЗакись азота",
		"Выбрать", "Отмена");	
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
	if(closeveh) return AttachTrailerToVehicle(closeveh, vehicleid), GameTextForPlayer(playerid, FixText("~G~Транспорт зацеплен"), 1000, 3); 
	return 1;
}

CMD:veh(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
    new Float:X,Float:Y,Float:Z;
	
	GetPlayerPos(playerid, X,Y,Z);
	
	extract params -> new carid;	else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /veh [ID транспорта]");

	if (carid < 400 || carid > 611) 
		return SendClientMessage(playerid, COLOR_GREY,"ID транспорта от 400 до 611.");

    CreateVehicle(carid, X+1,Y+2,Z+1, 0.0, 0, 0, 60000);
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
    
    extract params -> new player:targetid;	else
		return SendClientMessage(playerid,COLOR_GREY,"CMD: /makeleader [ID игрока]");

    if (targetid == INVALID_PLAYER_ID || gPlayerLogged[targetid] == false)
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

	if (targetid == INVALID_PLAYER_ID || gPlayerLogged[targetid] == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

	new string[128];
		
    format(string,sizeof(string),"Администратор [%d] %s кикнул игрока [%d] %s причина: %s", playerid, Name(playerid), targetid, Name(targetid), reason);
    SendClientMessageToAll(COLOR_RED, string);
	
	format(string,sizeof(string), ""COL_BLUE"Вы были кикнуты администратором %s\nПричина: "COL_WHITE"%s\n", Name(playerid), reason);
	ShowPlayerDialog(targetid, DIALOG_ID_KICK, D_S_M,""COL_ORANGE"Kick",string, "Принять", "");
	
	TogglePlayerControllable(targetid, 0);
	
	WriteLogByTypeName("Kick", PlayerInfo[playerid][pID], PlayerInfo[targetid][pID], reason);  
	return 1;
}

CMD:ban(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	extract params -> new player:targetid, string:reason[70];	else
		return SendClientMessage(playerid,COLOR_GREY,"CMD: /ban [ID игрока] [Причина]");

	if (targetid == INVALID_PLAYER_ID || gPlayerLogged[targetid] == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
	
	new string[128];
		
    format(string,sizeof(string),"Администратор [%d] %s забанил игрока [%d] %s причина: %s", playerid, Name(playerid), targetid, Name(targetid), reason);
    SendClientMessageToAll(COLOR_RED, string);
	
	format(string,sizeof(string), ""COL_BLUE"Вы были забанены администратором %s\nПричина: "COL_WHITE"%s\n", Name(playerid), reason);
	ShowPlayerDialog(targetid, DIALOG_ID_BAN, D_S_M,""COL_ORANGE"Ban",string, "Принять", "");
	
	TogglePlayerControllable(targetid, 0);
	
	WriteLogByTypeName("Ban", PlayerInfo[playerid][pID], PlayerInfo[targetid][pID], reason);  
	return 1;
}

CMD:makeadmin(playerid, params[])
{
    //if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	new targetid, lvl;
	
    if (sscanf(params, "dD(5)", targetid, lvl)) 
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /makeadmin [ID игрока] [Уровень администратора]");

    if (targetid == INVALID_PLAYER_ID || gPlayerLogged[targetid] == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    if (lvl < 0 || lvl > 5) 
		return SendClientMessage(playerid, COLOR_GREY,"Уровень администратора от 1 до 5.");

    PlayerInfo[targetid][pAdmin] = lvl;
	UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "Admin", PlayerInfo[playerid][pAdmin]);
	
    new str[71 + MAX_PLAYER_NAME*2 + 8 - 8];
	
    format(str,sizeof(str),"Администратор [%d] %s назначил игрока [%d] %s Администратором %d уровня", playerid, Name(playerid), targetid, Name(targetid),
	lvl);
    SendClientMessageToAll(COLOR_RED, str);
    return 1;
}

CMD:cc(playerid, params[]) // by Daniel_Cortez \\ pro-pawn.ru
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

CMD:setsex(playerid,params[])
{
	PlayerInfo[playerid][pSex] = (PlayerInfo[playerid][pSex] == 1) ? 2 : 1;
	UpdateDataInt(PlayerInfo[playerid][pID], "accounts", "Sex", PlayerInfo[playerid][pSex]);
	return 1;
}

CMD:a(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] == 0) return 1;
	
	new text;
	if(sscanf(params, "s[145]", text)) 
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /a [Сообщение]");

	new string[145];
	format(string, sizeof(string), ""COL_ORANGE"Администратор [%d] %s: "COL_WHITE"%s", playerid, Name(playerid), text);
	MessageToAdmin(COLOR_WHITE, string);
	
	return true;
}

CMD:setmoney(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	new targetid, amount;
	
    if(sscanf(params,"ui", targetid, amount)) 
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /setmoney [ID игрока] [Кол-во денег]");

	if (targetid == INVALID_PLAYER_ID || gPlayerLogged[targetid] == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    PlayerInfo[targetid][pMoney] = amount;
    return true;
}

CMD:sethunger(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	new targetid, amount;
	
    if(sscanf(params,"ui", targetid, amount)) 
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /sethunger [ID игрока] [Кол-во голода]");

	if (targetid == INVALID_PLAYER_ID || gPlayerLogged[targetid] == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    PlayerInfo[targetid][pHunger] = amount;
    return true;
}

CMD:setendurance(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	new targetid, amount;
	
    if(sscanf(params,"ui", targetid, amount)) 
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /setendurance [ID игрока] [Кол-во выносливости]");

	if (targetid == INVALID_PLAYER_ID || gPlayerLogged[targetid] == false) 
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
	
	if (targetid == INVALID_PLAYER_ID || gPlayerLogged[targetid] == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    PlayerInfo[targetid][pAPEDBattery] = amount;
	return true;
}

CMD:sethp(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;

    new targetid, amount;
	
    if(sscanf(params, "uI(100)", targetid, amount))
        return SendClientMessage(playerid, COLOR_GREY, "CMD: /sethp [ID игрока] [Количество HP]");
	
    if (targetid == INVALID_PLAYER_ID || gPlayerLogged[targetid] == false) 
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
	
    if(!(0 <= amount <= 100))
        return SendClientMessage(playerid, COLOR_GREY, "Количество здоровья от 0 до 100.");
	
	PlayerInfo[targetid][pHP] = amount;
	return 1;
}

CMD:goto(playerid, params[])
{    
    if (PlayerInfo[playerid][pAdmin] < 5) return 1;
    
	extract params -> new player:targetid; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /goto [ID игрока]");
	
	if (targetid == INVALID_PLAYER_ID || gPlayerLogged[targetid] == false)
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);
	
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
 	{
 		SetVehiclePos(GetPlayerVehicleID(playerid), x+1, y+1, z);
		SetPlayerInterior(playerid, GetPlayerInterior(targetid));
 		PutPlayerInVehicle(playerid, GetPlayerVehicleID(playerid), 0);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(targetid));
 	}
	SetPlayerPos(playerid, x + 0.5, y + 0.5, z + 0.5);
	SetPlayerInterior(playerid, GetPlayerInterior(targetid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
	
    new str[MAX_PLAYER_NAME+1+45];
	
    format(str,sizeof(str),"Администратор [%d] %s телепортировался к вам.", playerid,Name(playerid));
    SendClientMessage(targetid,COLOR_BRIGHTRED, str);
	
    format(str,sizeof(str),"Вы телепортировались к игроку [%d] %s.",targetid,Name(targetid));
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

CMD:gotoap(playerid, params[])
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
	
    format(string,sizeof(string),"Вы телепортировались к транспорту ID %d.", carid);
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
	
    format(string,sizeof(string),"Вы телепортировались к дому ID %d.", houseid);
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
	
    format(string,sizeof(string),"Вы телепортировались к APED ID %d.", apedid);
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

	if (targetid == INVALID_PLAYER_ID || gPlayerLogged[targetid] == false) 
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
	
    format(str,sizeof(str),"Администратор [%d] %s телепортировал вас к себе.", playerid,Name(playerid));
    SendClientMessage(targetid,COLOR_BRIGHTRED, str);
	
    format(str,sizeof(str),"Вы телепортировали игрока [%d] %s к себе.",targetid,Name(targetid));
    SendClientMessage(playerid,COLOR_BRIGHTRED, str);
	return 1;
}

CMD:givegun(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5) return 1;
	
	new _playerid, weaponid, bullet;
	
	if(sscanf(params,"udD(1)", _playerid, weaponid, bullet)) 
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /givegun [ID игрока] [ID оружия] [Кол-во патронов]");
	
	if (_playerid == INVALID_PLAYER_ID || gPlayerLogged[_playerid] == false) 
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
CMD:chouse2(playerid, params[])
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

CMD:onlineorg(playerid, params[])
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
	
	if (targetid == INVALID_PLAYER_ID || gPlayerLogged[targetid] == false) 
	return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");
	
	p_muted{targetid} = !p_muted{targetid};
	
    new server_tick = GetTickCount();
	
	static const
        fmt_str[] = "Администратор [%d] %s снял блокировку чата с игрока [%d] %s.",
		fmt_str1[] = "Администратор [%d] %s заблокировал чат игроку [%d] %s на %d минут.";		
		
	SetPVarInt(targetid, "MuteTime", server_tick + minutes * 60000);

    new str[sizeof(fmt_str) - 2 + MAX_PLAYER_NAME - 2 + 3 - 2 + MAX_PLAYER_NAME - 2 + 3 - 2 + 11];
	
    format(str, sizeof(str), p_muted{targetid} ? (fmt_str1) : (fmt_str),  playerid, Name(playerid), targetid, Name(targetid), minutes);
	
	return SendClientMessageToAll(COLOR_RED, str);
}

/////////////////////////////////////////////        ПОЛЬЗОВАТЕЛЬСКИЕ


CMD:hi(playerid, params[])
{
	extract params -> new player:target ; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /hi [ID игрока]");
	
	if(IsPlayerInAnyVehicle(playerid)) return 1;
	
    if (target == INVALID_PLAYER_ID || gPlayerLogged[target] == false)
		return SendClientMessage(playerid, COLOR_GREY, "Этот игрок сейчас не в сети.");

	if(target == playerid)  
		return  SendClientMessage(playerid,COLOR_GREY,"Вы указали свой ID.");
	
	if (IsPlayerNearPlayer(1.5, playerid, target))
    {		
		new string[20+(MAX_PLAYER_NAME+1) * 2];
		
		new Float:x, Float:y, Float:z;
		
		GetPlayerPos(playerid, x, y, z);
		SetPlayerFacingPos(target, x, y);
		
		format(string,sizeof(string),"%s пожимает руку %s.",Name(playerid), Name(target));
		ProxDetector(playerid,COLOR_PROX, string, 10.0);
		
		ApplyAnimation(playerid,"GANGS","hndshkfa",4.0,0,0,0,0,0,1);
		ApplyAnimation(target,"GANGS","hndshkfa",4.0,0,0,0,0,0,1);
		return true;
	}
	else return SendClientMessage(playerid, COLOR_GREY, "Этот человек далеко от вас!");
}

CMD:report(playerid, params[])
{
    extract params -> new string:message[128] ; else
		return SendClientMessage(playerid, COLOR_GREY, "CMD: /report [текст вопроса/жалобы]");
	
	static const
			fmt_str0[] = ""COL_RED"[REPORT]"COL_ORANGE" от игрока [%d] %s : "COL_WHITE"%s";
		
	const
		size0 = sizeof(fmt_str0) - (9+12+11) - (2+2) + 5 + (MAX_PLAYER_NAME+1-2) + 128;
			
	#if size0 > 144
		#define size 144
	#endif
		
	new string[size];
	#undef size
	
    format(string,sizeof(string), fmt_str0, playerid, Name(playerid), message);
    MessageToAdmin(COLOR_WHITE, string);
	
    SendClientMessage(playerid, COLOR_GREEN, "Вы успешно отправили сообщение администрации.");
    return 1;
}

CMD:coin(playerid, params[])
{
    if(PlayerInfo[playerid][pMoney] <= 0)
        return SendClientMessage(playerid, COLOR_GREY, "У вас нет ни одной монеты.");

    static const    coin_str0[] = " подбросил монетку, выпал",
                    coin_str1[] = "а \"решка\".", coin_str2[] = " \"орёл\".";

    new    string[MAX_PLAYER_NAME+(sizeof(coin_str0)-1)+(sizeof(coin_str1)-1)+1];

    strcat(string, Name(playerid));
	strcat(string, coin_str0);
    strcat(string, (random(2)) ? (coin_str1) : (coin_str2));
	
	ProxDetector(playerid,COLOR_PROX, string, 10.0);
    return 1;
}  

CMD:tazer(playerid, params[])
{
	if(PlayerInfo[playerid][pMember] == 2)
	{
		static const tazer_str0[] = " достает электрошокер.", tazer_str1[] = " убирает электрошокер.";

		new string[MAX_PLAYER_NAME+(sizeof(tazer_str0))+1];

		strcat(string, Name(playerid));
		strcat(string, (!tazer_status{playerid}) ? (tazer_str0) : (tazer_str1));
		
		if(!tazer_status{playerid})
		{
			SetPlayerAttachedObject(playerid, 0, 18642, 6, 0.06, 0.01, 0.08, 180.0, 0.0, 0.0);
			tazer_status{playerid} = true;
			
			ProxDetector(playerid,COLOR_PROX, string, 10.0);
		}
		else
		{
			RemovePlayerAttachedObject(playerid, 0);
			tazer_status{playerid} = false;
			
			ProxDetector(playerid,COLOR_PROX, string, 10.0);
		}
	}
    return 1;
}  


/////////////////////////////////////////////                    Стоки Стоки Стоки                //////////////////////////////

SaveAccount(playerid)
{
	if(gPlayerLogged[playerid] != true || GetPVarInt(playerid, "IsPlayerSpawn") == 0) return 1;
	
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
	
		new query_string[sizeof(save_account)+90];
		
		mysql_format(mysql_connect_ID, query_string, sizeof(query_string), save_account, 
		
				PlayerInfo[playerid][pMoney],
					PlayerInfo[playerid][pPos_x], PlayerInfo[playerid][pPos_y], PlayerInfo[playerid][pPos_z], PlayerInfo[playerid][pFa],
						PlayerInfo[playerid][pInt],	PlayerInfo[playerid][pWorld],
							PlayerInfo[playerid][pAPEDBattery],	PlayerInfo[playerid][pHunger], PlayerInfo[playerid][pEndurance], PlayerInfo[playerid][pHP],
				
								PlayerInfo[playerid][pID]);
		
		mysql_tquery(mysql_connect_ID, query_string);
	}
	//printf(query_string);*/
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
									`House`)\
\
		VALUES ('%s', '%s', '%e', '%d', '%d', '%d', '%d', '%d', 	\
					'%f', '%f', '%f', '%f', '%d', '%d',					\
						'%d', '%d', '%d', '%d', '%d',						\
							'%d', '%d', '%d', '%s',								\
								'%d', '%d', '%d', '%d', '%d', '%f',					\
									'%d')";
	
    new query_string[sizeof(create_account)+400+MAX_PLAYER_NAME];
	
    mysql_format(mysql_connect_ID, query_string, sizeof(query_string), create_account, 
	
				PlayerInfo[playerid][pName], password, salt, 0, 100, GetPVarInt(playerid, "Sex"),	GetPVarInt(playerid, "Skin"), 1,
					-2272.7549, -2203.3040, 31.2922, 218.6473, 0, 0,
						0, 0, 0, 0, 0,
							0, 0, 0, " ",
								0, 0, SEVENHOURS, SEVENHOURS, SEVENHOURS, 100.0,
									0);
	
    mysql_tquery(mysql_connect_ID, query_string, "UploadPlayerAccountNumber", "i", playerid);
	
	PlayerInfo[playerid][pSex] = GetPVarInt(playerid, "Sex");
	PlayerInfo[playerid][pSkin] = GetPVarInt(playerid, "Skin");
	PlayerInfo[playerid][pMoney] = 100;
	PlayerInfo[playerid][pHP] = 100.0;
	PlayerInfo[playerid][pReg] = 1;		
	PlayerInfo[playerid][pHunger] = SEVENHOURS;
	PlayerInfo[playerid][pEndurance] = SEVENHOURS;	
	PlayerInfo[playerid][pEnduranceMax] = SEVENHOURS;
	
    SetSkin(playerid);
    return 1;
}

forward UploadPlayerAccountNumber(playerid);
public UploadPlayerAccountNumber(playerid) PlayerInfo[playerid][pID] = cache_insert_id();

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
	cache_get_value_name(0, "RankName",PlayerInfo[playerid][pRankName],32);
	cache_get_value_name_int(0, "APED", PlayerInfo[playerid][pAPED]);
	cache_get_value_name_int(0, "APEDBattery", PlayerInfo[playerid][pAPEDBattery]);
	cache_get_value_name_int(0, "Hunger", PlayerInfo[playerid][pHunger]);
	cache_get_value_name_int(0, "Endurance", PlayerInfo[playerid][pEndurance]);
	cache_get_value_name_int(0, "EnduranceMax", PlayerInfo[playerid][pEnduranceMax]);
	cache_get_value_name_float(0, "HP", PlayerInfo[playerid][pHP]);
	cache_get_value_name_int(0, "House", PlayerInfo[playerid][pHouse]);
	
	
	gPlayerLogged[playerid] = true;
	TogglePlayerSpectating(playerid, false);
	KillTimer(loginkicktimer[playerid]);
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
			
			CreatePickup(1273, 23, HouseInfo[h][hEnterX], HouseInfo[h][hEnterY], HouseInfo[h][hEnterZ], 0);
			CreatePickup(1273, 23, HouseInfo[h][hExitX], HouseInfo[h][hExitY], HouseInfo[h][hExitZ], HouseInfo[h][hVirt]);
			
			Iter_Add(House, h);
			
			
	}
	print(" "); printf("---=== %d houses loaded. ===---", Iter_Count(House)); print(" ");
	return 1;
}


/*LoadEnters()
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
*/

SaveOneVeh(vehicleid)
{
	new Float:x, Float:y, Float:z,Float:za;
			
	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, za);			
	
	if(VehInfo[vehicleid][vVPosX] != x || VehInfo[vehicleid][vVPosY] != y || VehInfo[vehicleid][vVZa] != za)
	{
		VehInfo[vehicleid][vVPosX] = x;
		VehInfo[vehicleid][vVPosY] = y;
		VehInfo[vehicleid][vVPosZ] = z;
		VehInfo[vehicleid][vVZa] = za;
		
		static const
			save_veh[] = "UPDATE `vehicles` SET \
					`VPosX` = '%f', `VPosY` = '%f',  `VPosZ` = '%f',  `VZa` = '%f' \
\
						WHERE `ID` = '%d'";
		
		new query_string[sizeof(save_veh)-12+63];
				
		mysql_format(mysql_connect_ID, query_string, sizeof(query_string), save_veh, 
				
					VehInfo[vehicleid][vVPosX],	VehInfo[vehicleid][vVPosY],	VehInfo[vehicleid][vVPosZ],	VehInfo[vehicleid][vVZa],
					
						vehicleid);
				
		mysql_tquery(mysql_connect_ID, query_string);
		//printf(query_string);
	}
	
	new Float:VHP;
	GetVehicleHealth(vehicleid, VHP);
	
	if(VehInfo[vehicleid][vHP] != VHP)
	{
		static const
			save_vehhp[] = "UPDATE `vehicles` SET \
						`VHP` = '%f' \
\
							WHERE `ID` = '%d'";
							
		new query_stringhp[sizeof(save_vehhp)-2+15];
		
		VehInfo[vehicleid][vHP] = VHP;		
				
		mysql_format(mysql_connect_ID, query_stringhp, sizeof(query_stringhp), save_vehhp, 
				
						VehInfo[vehicleid][vHP],
					
							vehicleid);
				
		mysql_tquery(mysql_connect_ID, query_stringhp);
		//printf(query_stringhp);
	}			
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
			Engine[v] = false;
			
			
			if(VehInfo[v][vAdd] == 1 && VehInfo[v][vBuy] == 0)
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

WriteLogByTypeName(type_name[], account_id, target_id, log_message[])
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

UpdateDataVarchar(ID, const table_name[], const field_name[], value[])
{
    static
        query_string[37+64+11+10+1];
    mysql_format(mysql_connect_ID, query_string, sizeof(query_string), "UPDATE %s SET `%s` = '%s' WHERE ID = %d", table_name, field_name, value, ID);
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
    foreach(Player, i)
	if(PlayerInfo[i][pAdmin] > 0)
	SendClientMessage(i, color, string);
    return 1;
}

PreloadAnimLib(playerid, animlib[])
{
    ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}

ProxDetector(playerid, color, string[], Float:max_range, Float:max_ratio = 1.6)
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
 
	#if defined foreach
    foreach (new i : Player) {
	#else
    for (new i = GetPlayerPoolSize(); i != -1; i--) {
	#endif
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
	"COL_WHITE"[4] "COL_BLUE"Дать выговор\n\
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
		
	status2 = (MapIsOn[playerid] == true) ?  (""COL_STATUS1"Включено") : (""COL_STATUS6"Выключено");
				
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
	
	if(PlayerInfo[playerid][pHouse] > 0)
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
		
	if(0 < PlayerInfo[playerid][pHunger] <=3600) hunger = ""COL_STATUS6"Голодание";
	if(3600 < PlayerInfo[playerid][pHunger] <=7200)  hunger = ""COL_STATUS5"Жутко голоден";
	if(7200 < PlayerInfo[playerid][pHunger] <=10800) hunger = ""COL_STATUS4"Нужно плотно поесть";
	if(10800 < PlayerInfo[playerid][pHunger] <=14400) hunger = ""COL_STATUS3"Нужно поесть";
	if(14400 < PlayerInfo[playerid][pHunger] <=18000) hunger = ""COL_STATUS2"Нужно немного перекусить";
	if(18000 < PlayerInfo[playerid][pHunger] <=25200) hunger = ""COL_STATUS1"Сыт";
	
	if(0 < PlayerInfo[playerid][pEndurance] <=3600) endurance = ""COL_STATUS6"Переутомление";
	if(3600 < PlayerInfo[playerid][pEndurance] <=7200)  endurance = ""COL_STATUS5"Недосыпание";
	if(7200 < PlayerInfo[playerid][pEndurance] <=10800) endurance = ""COL_STATUS4"Нужно поспать";
	if(10800 < PlayerInfo[playerid][pEndurance] <=14400) endurance = ""COL_STATUS3"Нужно отдохнуть";
	if(14400 < PlayerInfo[playerid][pEndurance] <=18000) endurance = ""COL_STATUS2"Нужно немного расслабиться";
	if(18000 < PlayerInfo[playerid][pEndurance] <=25200) endurance = ""COL_STATUS1"Полон сил";
				
	format(d35, sizeof(d35), D35, hunger, endurance, healths, money, carkey, house, org);
	format(d36, sizeof(d36), D36, battery);
	ShowPlayerDialog(playerid, DIALOG_ID_PLAYERINFODIALOG, D_S_T, d36, d35, "Выйти", "Назад");
	return true;
}

ShowPlayerVehicleDialog(playerid)
{
	new carid = GetAroundPlayerVehicleID(playerid, 4.0);
	GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
		
	static D37[] = 
				""COL_BLUE"Функция: \t"COL_WHITE"Состояние:"\
				"\n"COL_BLUE"Двигатель: \t%s"\
				"\n"COL_BLUE"Фары: \t%s"\
				"\n"COL_BLUE"Сигнализация: \t%s"\
				"\n"COL_BLUE"Двери: \t%s"\			
				"\n"COL_BLUE"Капот: \t%s"\
				"\n"COL_BLUE"Багажник: \t%s"\
				"\n"COL_BLUE"Поиск автомобиля по GPS: \t%s";
				
	new d37[42+26+21+29+22+22+25+40-14+21+22+25+27+19+19+24],
		d38[42-4+4+20+1],
		status1[21], status2[22], status3[25], status4[27], status5[19], status6[19], status7[24];
		
				
	static D38[] = ""COL_ORANGE"Состояние транспорта: "COL_WHITE"[ID:%d] %s";
		
	status1 = (engine) ?  (""COL_STATUS1"Заведен") : (""COL_STATUS6"Заглушен");
	status2 = (lights) ?  (""COL_STATUS1"Включены") : (""COL_STATUS6"Выключены");
	status3 = (alarm) ?  (""COL_STATUS1"Активирована") : (""COL_STATUS6"Отключена");
	status4 = (doors) ?  (""COL_STATUS6"Закрыты") : (""COL_STATUS1"Открыты");
	status5 = (bonnet) ?  (""COL_STATUS1"Открыт") : (""COL_STATUS6"Закрыт");
	status6 = (boot) ?  (""COL_STATUS1"Открыт") : (""COL_STATUS6"Закрыт");
	status7 = (objective) ?  (""COL_STATUS1"Активирован") : (""COL_STATUS6"Отключен");
					
	format(d37, sizeof(d37), D37, status1, status2, status3, status4, status5, status6, status7);
	format(d38, sizeof(d38), D38, carid, VehicleNames[GetVehicleModel(carid)-400]);
	ShowPlayerDialog(playerid, DIALOG_ID_VMENU, D_S_TH, d38, d37, "Выбрать", "Выход");
	return true;
}

SetPlayerPosCW(playerid, Float:x, Float:y, Float:z, Float:a, i, v)
{
	if(!IsPlayerBlackScreen[playerid])
	{	
		ShowFonForPlayer(playerid);
		
		IsPlayerBlackScreen[playerid] = true;
		
		TogglePlayerControllable(playerid, false);		
		SetTimerEx("TeleportCW", 500, 0, "iffffdd", playerid, x, y, z, a, i, v);
	}
    return 1;
}

ShowFonForPlayer(playerid) 
{ 
    if(!FonBox[playerid]) 
    { 
		TogglePlayerControllable(playerid, false);
		
		IsPlayerBlackScreen[playerid] = true;
		
        fon_PTD[playerid] = CreatePlayerTextDraw(playerid, -12.0000, -10.3555, "Box"); // пусто 
        PlayerTextDrawLetterSize(playerid, fon_PTD[playerid], 0.0000, 53.6333); 
        PlayerTextDrawTextSize(playerid, fon_PTD[playerid], 680.0000, 0.0000); 
        PlayerTextDrawUseBox(playerid, fon_PTD[playerid], 1); 
        PlayerTextDrawBoxColor(playerid, fon_PTD[playerid], 255); 

        FonBox[playerid] = 50; 
        FonTimer[playerid] = SetTimerEx("@_FonTimer", true, 50, "ii", playerid, 1); 
    } 
} 

HideFonForPlayer(playerid) 
{ 
    if(FonBox[playerid] > 0) 
    { 		
        FonBox[playerid] = 255; 
        FonTimer[playerid] = SetTimerEx("@_FonTimer", true, 50, "ii", playerid, 2); 
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
	if(VehInfo[vehicleid][vFuel] > 0)
	{
		static const
			fmt_str0[] = "%s вставляет ключ в замок зажигания (Заводит двигатель).",
			fmt_str1[] = "%s вытаскивает ключ из замка зажигания (Глушит двигатель).";
		
		const
			size = sizeof(fmt_str1) + (MAX_PLAYER_NAME+1-2);
		
		new string[size];
		
		if(!Engine[vehicleid])
		{
			SetVehicleParamsEx(vehicleid,true,lights,alarm,doors,bonnet,boot,objective);
			Engine[vehicleid] = true;
		}
		else
		{
			SetVehicleParamsEx(vehicleid,false,lights,alarm,doors,bonnet,boot,objective);
			Engine[vehicleid] = false;
		}
		 
		format(string, sizeof(string), (Engine[vehicleid]) ? (fmt_str0) : (fmt_str1), Name(playerid));
		ProxDetector(playerid,COLOR_PROX, string, 10.0);
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
	
	//new check [20];		format(check,sizeof(check),"%d", IdleTime[playerid]); 		GameTextForPlayer(playerid, check, 1000, 3);
	//printf("%d", loginkicktimer[playerid]);	
	
	if (PlayerInfo[playerid][pMoney] != GetPlayerMoney(playerid))
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
	}
	
	new Float:health;				
	if (PlayerInfo[playerid][pHP] != GetPlayerHealth(playerid, health))
	{
		SetPlayerHealth(playerid, PlayerInfo[playerid][pHP]);
	}
	
	if(PlayerInfo[playerid][pHP] < 0.0) PlayerInfo[playerid][pHP] = 1.0;
	
	SaveAccount(playerid);
	
	
	if(PlayerTimerIDTimer1Second == 4)
    {	
		if(PlayerInfo[playerid][pEndurance] > PlayerInfo[playerid][pEnduranceMax]) 
			PlayerInfo[playerid][pEndurance] = PlayerInfo[playerid][pEnduranceMax];
		
		if(PlayerInfo[playerid][pHunger] > SEVENHOURS) 
			PlayerInfo[playerid][pHunger] = SEVENHOURS;
			
		if(PlayerInfo[playerid][pHunger] > 0)
		{
			GiveHunger(playerid, -1);
		}
		
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
				PlayerTimerIDTimer60Second ++;
				if(PlayerTimerIDTimer60Second == 60)
				{				
					PlayerInfo[playerid][pHP] -= 1.0;
					PlayerTimerIDTimer60Second = 0;
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
			TextDrawSetString(TDEditor_TD[5], string);
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
			if(VHP < 300.0 && Engine[VID] == true)
			SendClientMessage(playerid, COLOR_RED,"Состояние транспорта на низком уровне. Необходим ремонт.");
		}
		
		if(!IsPlayerInAnyVehicle(playerid) && gPlayerLogged[playerid] != false)
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
	
	new string[11];
	
	format(string, sizeof(string), "%02d:%02d", hour, minute);
	TextDrawSetString(TDEditor_TD[4], string);
	
    return 1;
}  

forward Processor();
public Processor()
{	
	new Float:VHP;	
	foreach (new v : Vehicle) 
	{	
		if(VehInfo[v][vBuy] == VBUYTOCARKEY)
		SaveOneVeh(v);
		
		GetVehicleParamsEx(v,engine,lights,alarm,doors,bonnet,boot,objective);	
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
	
	SetTimer("Processor", PROCESSOR_UPDATE, false);
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
			for(new tds; tds <= 9; tds++)
				TextDrawShowForPlayer(i, TDEditor_Speed[tds]);

			format(string, sizeof(string), "%d", GetVehicleSpeed(vehicleid));
			TextDrawSetString(TDEditor_Speed[4], string);
			
			format(string, sizeof(string), "%d %%", VehInfo[vehicleid][vFuel]);
			TextDrawSetString(TDEditor_Speed[6],string);
		}
		
		if(VehInfo[vehicleid][vFuel] <= 100)				
			TextDrawSetString(TDEditor_Speed[9], "I_I_I_I_I_I_I_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 90)			
			TextDrawSetString(TDEditor_Speed[9], "I_I_I_I_I_I_I_I_I_I_I_I~w~_I");
		if(VehInfo[vehicleid][vFuel] <= 80)				
			TextDrawSetString(TDEditor_Speed[9], "I_I_I_I_I_I_I_I_I_I_I~w~_I_I");
		if(VehInfo[vehicleid][vFuel] <= 75)
			TextDrawSetString(TDEditor_Speed[9], "I_I_I_I_I_I_I_I_I_I~w~_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 70)
			TextDrawSetString(TDEditor_Speed[9], "I_I_I_I_I_I_I_I_I~w~_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 60)
			TextDrawSetString(TDEditor_Speed[9], "I_I_I_I_I_I_I_I~w~_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 50)
			TextDrawSetString(TDEditor_Speed[9], "I_I_I_I_I_I_I~w~_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 40)
			TextDrawSetString(TDEditor_Speed[9], "I_I_I_I_I_I~w~_I_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 30)
			TextDrawSetString(TDEditor_Speed[9], "I_I_I_I_I~w~_I_I_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 20)
			TextDrawSetString(TDEditor_Speed[9], "I_I_I_I~w~_I_I_I_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 15)
			TextDrawSetString(TDEditor_Speed[9], "I_I_I~w~_I_I_I_I_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 10)
			TextDrawSetString(TDEditor_Speed[9], "I_I~w~_I_I_I_I_I_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] <= 5)
			TextDrawSetString(TDEditor_Speed[9], "I~w~_I_I_I_I_I_I_I_I_I_I_I_I");
		if(VehInfo[vehicleid][vFuel] == 0)
			TextDrawSetString(TDEditor_Speed[9], "~w~I_I_I_I_I_I_I_I_I_I_I_I_I");
		
		if(GetVehicleSpeed(vehicleid) == 0.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~IIIIIIIIIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 5.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~I~b~IIIIIIIIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 10.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~II~b~IIIIIIIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 15.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~III~b~IIIIIIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 20.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIII~b~IIIIIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 25.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIII~b~IIIIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 30.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIII~b~IIIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 35.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIII~b~IIIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 40.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIII~b~IIIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 45.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIII~b~IIIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 50.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIII~b~IIIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 55.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIII~b~IIIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 60.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIII~b~IIIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 70.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIII~b~IIIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 80.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIIII~b~IIIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 90.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIIIII~b~IIIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 100.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIIIIII~b~IIIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 110.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIIIIIII~b~IIIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 120.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIII~b~IIIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 130.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIII~b~IIIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 140.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIII~b~IIIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 150.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIII~b~IIIIIII");
		if(GetVehicleSpeed(vehicleid) >= 160.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIIII~b~IIIIII");
		if(GetVehicleSpeed(vehicleid) >= 170.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIIIII~b~IIIII");
		if(GetVehicleSpeed(vehicleid) >= 180.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIIIIII~b~IIII");
		if(GetVehicleSpeed(vehicleid) >= 190.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIIIIIII~b~III");
		if(GetVehicleSpeed(vehicleid) >= 200.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIIIIIIII~b~II");
		if(GetVehicleSpeed(vehicleid) >= 210.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIIIIIIIII~b~I");
		if(GetVehicleSpeed(vehicleid) >= 220.0)				
			TextDrawSetString(TDEditor_Speed[8], "~b~~h~~h~~h~IIIIIIIIIIIIIIIIIIIIIIIIIIII");
		
		if(!VehInfo[vehicleid][vLock])			
			TextDrawSetString(TDEditor_Speed[7], "~g~doors");
		else 
			TextDrawSetString(TDEditor_Speed[7], "~r~doors");
		
		if(Engine[vehicleid])			
			TextDrawSetString(TDEditor_Speed[3], "~b~~h~~h~~h~engine");
		else 
			TextDrawSetString(TDEditor_Speed[3], "engine");
		

		
		if(GetVehicleSpeed(vehicleid) >= 110.0)
		{
			new Float:x,Float:y,Float:z;
			GetVehicleVelocity(vehicleid, x, y, z);
			SetVehicleVelocity(vehicleid, x*0.99, y*0.99, z*0.99);
		}
		
  		if(!IsPlayerInAnyVehicle(i))
		{
			for(new tds; tds <= 9; tds++)
			{
				TextDrawHideForPlayer(i, TDEditor_Speed[tds]);
			}
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
			if(Engine[v] == true)//если двигатель у проверяемой машины работает
			{				
				VehInfo[v][vFuel] -= 1;
				UpdateDataInt(v, "vehicles", "Fuel", VehInfo[v][vFuel]);
				
				
				if(VehInfo[v][vFuel] <= 0)	
				{
					VehInfo[v][vFuel] = 0;
					GetVehicleParamsEx(v,engine,lights,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(v,false,lights,alarm,doors,bonnet,boot,objective);
					Engine[v] = false;
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
        KillTimer( GetPVarInt(playerid,"_timer")),
		
        SetPVarInt(playerid, "Refill", 0),
		
        TogglePlayerControllable(playerid, 1);
		
		new str[130];
		
        format(str,sizeof(str), ""COL_BLUE" Спасибо за то, что вы заправились на нашей АЗС.\n Заполнено "COL_WHITE"%d %% "COL_BLUE"бензобака.\n\
		Оплачено: "COL_GREEN"%d$.", inputfuel[playerid], CENA_BENZ*inputfuel[playerid]);
		ShowPlayerDialog(playerid, DIALOG_ID_NONE, D_S_M,""COL_ORANGE"АЗС",str,"Принять","");
		return 1;
    }
    ++ VehInfo[vehicleid][vFuel];
	UpdateDataInt(vehicleid, "vehicles", "Fuel", VehInfo[vehicleid][vFuel]);
	
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
	return ApplyAnimation(playerid,"CARRY","crry_prtial", 4.0, 0, 0, 0, 0, 0, 0);
	
forward TogglePlayerControllablePublic(playerid);
public TogglePlayerControllablePublic(playerid)
	return TogglePlayerControllable(playerid, 1), ClearAnimations(playerid), DeletePVar(playerid, "IsTazed");


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
				
		SendClientMessage(playerid, COLOR_GREEN,"Вы закончили ремонт транспорта.");
				
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

forward SleepTimer(playerid);
public SleepTimer(playerid)
{
	if(PlayerInfo[playerid][pEndurance] >=  PlayerInfo[playerid][pEnduranceMax])
	{
		new string[25],
			chill = floatround(PlayerInfo[playerid][pEndurance] * 100 / PlayerInfo[playerid][pEnduranceMax], floatround_ceil);
		
		format(string,sizeof(string),FixText("~G~Уровень отдыха: %d %%"), chill); 
		GameTextForPlayer(playerid, string, 1000, 3);
		
		KillTimer(GetPVarInt(playerid,"SleepTimer"));	
		
		HideFonForPlayer(playerid);
				
		SendClientMessage(playerid, COLOR_GREEN,"Вы отдохнули.");
		
		DeletePVar(playerid,"Sleep");
		return 1;				
	}
	new string[25],
		chill = floatround(PlayerInfo[playerid][pEndurance] * 100 / PlayerInfo[playerid][pEnduranceMax], floatround_ceil);
		
	format(string,sizeof(string),FixText("~G~Уровень отдыха: %d %%"), chill); 
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
		
		//loginkicktimer[playerid] = SetTimerEx("OnLoginTimeout", SECONDS_TO_LOGIN * 1000, false, "d", playerid);
    }
    return 1;
}

forward OnLoginTimeout(playerid);
public OnLoginTimeout(playerid)
{	
	KillTimer(loginkicktimer[playerid]);
	ShowPlayerDialog(playerid, DIALOG_ID_NONE, D_S_M, ""COL_ORANGE"Авторизация", ""COL_BLUE"Вы были отключены от сервера из-за бездействия.", "", "");
	DelayedKick(playerid);
	return 1;
}

DelayedKick(playerid, time = 500)
{
	SetTimerEx("_KickPlayerDelayed", time, false, "d", playerid);
	return 1;
}

forward _KickPlayerDelayed(playerid);
public _KickPlayerDelayed(playerid)
{
	Kick(playerid);
	return 1;
}

forward HideFonAfterReg(playerid);
public HideFonAfterReg(playerid)
{	
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
    SetPlayerCameraPos(playerid, -2052.9094,-2517.8618,86.9391);
    SetPlayerCameraLookAt(playerid, -2074.1409,-2480.8386,73.3136);
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
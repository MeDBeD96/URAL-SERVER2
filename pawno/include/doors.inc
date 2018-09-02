/*
	Made by: Gigi_Falcone (http://forum.sa-mp.com/member.php?u=76822)
	forum.sa-mp.com
	11.01.2016
	Version: v0.1 Alpha
*/

#include <a_samp>
#include <streamer>

#define DS_MAX_DOORS   10
#define DS_DOOR_NONE    0
#define DS_DOOR_CLOSE   1
#define DS_DOOR_OPEN    2


#define DS_DEBUG

enum doors_data
{
	bool:ds_used,
	ds_streamerid,
	ds_areaid,
	ds_model,
	ds_state,//closed or open
	Float:ds_x,
	Float:ds_y,
	Float:ds_z,
	Float:ds_rx,
	Float:ds_ry,
	Float:ds_rz,
	//debug objects
	#if defined DS_DEBUG
	ds_debug1,
	ds_debug2,
	ds_debug3,
	ds_debug4
	#endif
}
static DoorsData[DS_MAX_DOORS + 1][doors_data];//slot 0 not used - invalid

//Returns ID from 1 to 100, not including 0
stock CreateDoor(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	//== Find Empty Slot
	static slot = 0;
	for(new i = 1; i < sizeof(DoorsData); i++)//Loop array to find empty spot
	{
	    if(DoorsData[i][ds_used] == false)//Check if slot is used
	    {
	        slot = i;
	        break;
	    }
	}
	if(!slot) return 0;//Doors could not be created! Max limit reached
	
	//== Find Coordinates For Area
	static Float:tx;
	static Float:ty;

	static Float:tAreaCoord[8];//x,y,x,y,...

	//bottom left
	tx = x;
	ty = y;
	GetPosInFrontOfPoint(tx,ty, rz + 180.0, 1.5);
	tAreaCoord[0] = tx;
	tAreaCoord[1] = ty;
	#if defined DS_DEBUG
	DoorsData[slot][ds_debug1] = CreateDynamicObject(1455,tx,ty,z,rx,ry,rz);
	#endif

	//top left
	tx = x;
	ty = y;
	GetPosInFrontOfPoint(tx,ty, rz, 1.5);
	tAreaCoord[2] = tx;
	tAreaCoord[3] = ty;
	#if defined DS_DEBUG
	DoorsData[slot][ds_debug2] = CreateDynamicObject(1455,tx,ty,z,rx,ry,rz);
	#endif
	//top right
	tx = x;
	ty = y;
	GetPosInFrontOfPoint(tx,ty, rz + 270.0, 1.5);
	GetPosInFrontOfPoint(tx,ty, rz, 1.5);
	tAreaCoord[4] = tx;
	tAreaCoord[5] = ty;
	#if defined DS_DEBUG
	DoorsData[slot][ds_debug3] = CreateDynamicObject(1455,tx,ty,z,rx,ry,rz);
	#endif
	//bottom right
	tx = x;
	ty = y;
	GetPosInFrontOfPoint(tx,ty, rz + 270.0, 1.5);
	GetPosInFrontOfPoint(tx,ty, rz + 180, 1.5);
	tAreaCoord[6] = tx;
	tAreaCoord[7] = ty;
	#if defined DS_DEBUG
	DoorsData[slot][ds_debug4] = CreateDynamicObject(1455,tx,ty,z,rx,ry,rz);
	#endif
	
	//== Set Variables
	DoorsData[slot][ds_used] = true;
	DoorsData[slot][ds_streamerid] = CreateDynamicObject(modelid,x,y,z,rx,ry,rz);
	DoorsData[slot][ds_areaid] = CreateDynamicPolygon(tAreaCoord);
	DoorsData[slot][ds_model] = modelid;
	DoorsData[slot][ds_state] = DS_DOOR_CLOSE;
	DoorsData[slot][ds_x] = x;
	DoorsData[slot][ds_y] = y;
	DoorsData[slot][ds_z] = z;
	DoorsData[slot][ds_rx] = rx;
	DoorsData[slot][ds_ry] = ry;
	DoorsData[slot][ds_rz] = rz;

	SendClientMessage(0,-1,"created door");
	return slot;
}


stock DestroyDoor(doorid)
{
	if(!DoorsData[doorid][ds_used]) return 0;//Door invalid
	DoorsData[doorid][ds_used] = false;
	if(IsValidDynamicObject(DoorsData[doorid][ds_streamerid])) DestroyDynamicObject(DoorsData[doorid][ds_streamerid]);
	DoorsData[doorid][ds_streamerid] = 0;
	if(IsValidDynamicArea(DoorsData[doorid][ds_areaid])) DestroyDynamicArea(DoorsData[doorid][ds_areaid]);
	DoorsData[doorid][ds_areaid] = 0;
	DoorsData[doorid][ds_model] = 0;
	DoorsData[doorid][ds_state] = DS_DOOR_NONE;
	DoorsData[doorid][ds_x] = 0.0;
	DoorsData[doorid][ds_y] = 0.0;
	DoorsData[doorid][ds_z] = 0.0;
	DoorsData[doorid][ds_rx] = 0.0;
	DoorsData[doorid][ds_ry] = 0.0;
	DoorsData[doorid][ds_rz] = 0.0;
	#if defined DS_DEBUG
	if(IsValidDynamicObject(DoorsData[doorid][ds_debug1])) DestroyDynamicObject(DoorsData[doorid][ds_debug1]);
	if(IsValidDynamicObject(DoorsData[doorid][ds_debug2])) DestroyDynamicObject(DoorsData[doorid][ds_debug2]);
	if(IsValidDynamicObject(DoorsData[doorid][ds_debug3])) DestroyDynamicObject(DoorsData[doorid][ds_debug3]);
	if(IsValidDynamicObject(DoorsData[doorid][ds_debug4])) DestroyDynamicObject(DoorsData[doorid][ds_debug4]);
	#endif
	return 1;
}

//Slow open/close speed: 0.01 to 0.001
stock MoveDoor(doorid, doorstate, Float:speed = 0.1)//open/close
{
	if(!DoorsData[doorid][ds_used]) return 0;//If door does not exist, return 0
	if(DoorsData[doorid][ds_state] == doorstate) return 0;//If door state is same, return 0
	switch(doorstate)
	{
	    case DS_DOOR_CLOSE://Close the door
	    {
	        DoorsData[doorid][ds_state] = DS_DOOR_CLOSE;
	        MoveDynamicObject(DoorsData[doorid][ds_streamerid],
	        DoorsData[doorid][ds_x],
	        DoorsData[doorid][ds_y],
	        DoorsData[doorid][ds_z] + 0.01,
	        speed,
	        -1000.0,
	        -1000.0,
	        DoorsData[doorid][ds_rz]);
	    }
	    case DS_DOOR_OPEN://Open the door
	    {
	        DoorsData[doorid][ds_state] = DS_DOOR_OPEN;
	        MoveDynamicObject(DoorsData[doorid][ds_streamerid],
	        DoorsData[doorid][ds_x],
	        DoorsData[doorid][ds_y],
	        DoorsData[doorid][ds_z] - 0.01,
	        speed,
	        -1000.0,
	        -1000.0,
	        DoorsData[doorid][ds_rz] - 90.0);
	    }
	    default: return 0;
	}
	return 1;
}

stock IsPlayerInDoorZone(playerid, doorid)//1 yes, 0 no
{
    if(!DoorsData[doorid][ds_used]) return 0;//If door does not exist, return 0
    if(IsPlayerInDynamicArea(playerid,DoorsData[doorid][ds_areaid])) return 1;
    else return 0;
}

stock IsPlayerInAnyDoorZone(playerid)//id yes, 0 no
{
	static doorid = 0;
	for(new i = 1; i < sizeof(DoorsData); i++)
	{
	    if(!DoorsData[i][ds_used]) continue;//dor does not exist
	    if(IsPlayerInDynamicArea(playerid,DoorsData[i][ds_areaid]))
	    {
	        doorid = i;
	        break;
	    }
	}
	return doorid;
}


//Input X & Y coordinates, angle & distance
//Return X & Y coordinates changed for the offset
stock GetPosInFrontOfPoint(&Float:OutputX, &Float:OutputY, Float:Angle, Float:Distance)
{
	if(!Distance) return 0;
	OutputX += floatmul(Distance, floatsin(-Angle, degrees));
	OutputY += floatmul(Distance, floatcos(-Angle, degrees));
	return 1;
}
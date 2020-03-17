class CfgPatches
{
	class RV_ReverseThrust
	{
		units[]={};
		requiredVersion=1.96;
		requiredAddons[]=
		{
			"cba_xeh"
		};
		name="Reverse Thrust";
		author="Jack Ost";
		version=2.0;
		versionStr="2.0";
		versionDesc="Reverse Thrust 2.0";
	};
};
class Cfg3DEN
{
	class Object
	{
		class AttributeCategories
		{
			class RV_Attributes
			{
				displayName = "Reverse Thrust";
				collapsed = 1;
				class Attributes
				{
					class RV_isReactorPlane
					{
						displayName = "$STR_RV_ReactorVehicle";
						tooltip = "$STR_RV_ReactorVehicle_Tooltip";
						property = "RV_isReactorPlane";
						control = "Checkbox";
						expression = "_this setVariable ['RV_ReactorMode',_value,true];";
						defaultValue = "(false)";
						condition = "objectVehicle";
						typeName = "BOOL";
					};
				};
			};
		};
	};
};
class RscText;
class RscReverseThrottle: RscText
{
	idc=2005;
	style=1;
	colorText[]=
	{
		"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])",
		"(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])",
		"(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])",
		"(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8])"
	};
	shadow=0;
	text="-10";
	x="0.0 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(profilenamespace getvariable [""IGUI_GRID_VEHICLE_X"",		(safezoneX + 0.5 * 			(			((safezoneW / safezoneH) min 1.2) / 40))])";
	y="3.3 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(profilenamespace getvariable [""IGUI_GRID_VEHICLE_Y"",		(safezoneY + 0.5 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25))])";
	w="1.4 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
	h="0.95 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
	sizeEx="0.8 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
};

#include "CfgEventHandlers.hpp"

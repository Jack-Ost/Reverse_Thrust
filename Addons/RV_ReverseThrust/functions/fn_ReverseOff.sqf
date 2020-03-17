/***************************
--	Reverse Thrust Script --
--	Version : 2.0		  --
--	Author : Jack Ost	  --
--	All rights reserved	  --
***************************/

//Initialisation variable véhicule
private _veh = vehicle player;

//Si le véhicule n'existe pas
if(isNull _veh) exitWith {false};

//Si le joueur n'est pas pilote
if(not ((driver (_veh)) isEqualTo player)) exitWith {false}; //currentPilot TODO

//Si le reverse n'est pas engagé
if(not (_veh getVariable ["RV_use",false])) exitWith {false};


{
    if (300 == ctrlIDD _x) then {
      ctrlDelete  (_x displayCtrl 10050);
      (_x displayCtrl 205) ctrlSetFade 0;
      (_x displayCtrl 205) ctrlCommit 0;
    };
} count (uiNamespace getVariable "IGUI_displays");

//On met à jour les variables
_veh setVariable ["RV_des",true,true];
_veh setVariable ["RV_use", false, false];

//Message prévenant la désactivation
hint localize "STR_RV_Reverse_disengaged";

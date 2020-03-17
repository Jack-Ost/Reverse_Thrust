/***************************
--	Reverse Thrust Script --
--	Version : 2.0		      --
--	Author : Jack Ost	    --
--	Licence : GNU GPLv3	  --
***************************/

_get_velocity = {
	private ["_vel"];

	_vel = _this select 0;
	_veloc = 0.278*_vel;
	_veloc;
};

//Initialisation variable véhicule
private _veh = vehicle player;

//Si le véhicule n'existe pas
if(isNull _veh) exitWith {false};

//Si le joueur n'est pas pilote
if(not ((currentPilot (_veh)) isEqualTo player)) exitWith {false};

//Si le reverse est déjà engagé
if(_veh getVariable ["RV_use",false]) exitWith {false};

//Vérification véhicule existant et véhicule de type aérien
if (not (_veh isKindOf "AIR")) exitWith {false};

//Condition moteur allumé ou éteint
if (not (isEngineOn _veh)) exitWith {hint localize "STR_RV_Engine_start"; false};

//Variable du mode de reverse
_pushback = (speed _veh) < 0.5;
//Si le pushback est désactivé
if (_pushback && not RV_Pushback) exitWith {false};
//Si le reverse en vol est désactivé
if (not _pushback && not RV_FlightReverse) exitWith {false};

//Initialisation Variable classname
_classn = typeOf _veh;
//Définition si avion hélice ou non
_isHeliPlane =  not (_veh getVariable ["RV_ReactorMode",false]);;
//Définition temps de simulation si avion hélice
_resolutionTimeDiv = 10;
if(_isHeliPlane) then {
	//Dénominateur division pour une seconde de simulation
	_resolutionTimeDiv = 30;
};
//Initialisation vitesse minimale d'utilisation sur réacteur en km/h
_dangerSpeed = 108; //getNumber (configFile >> "CfgVehicles" >> _classn >> "stallSpeed");
//Initialisation Variable de décelleration
_decel = 0;

//Si c'est un avion à réacteur, pas de pushback !
if (_pushback && not _isHeliPlane) exitWith {false};
//Condition throttle à 0 si avion à hélice
if (airplaneThrottle _veh != 0 && _isHeliPlane) exitWith {false};

//Message d'activation
hint localize "STR_RV_Activation";
//Initialisation Variable de désactivation
_veh setVariable ["RV_des",false,true];
//Initialisation variable script en utilisation
_veh setVariable ["RV_use", true, false];

//Condition vitesse nulle
if (_pushback) then {
//Pushback (ground reverse thrust)

	//Tableau avions déséquilibrés (Compatibilité)
	_planesArray = ["USAF_AC130U","LDL_C130J","USAF_A10","USAF_MC130"];
	//Besoin d'équilibrage
	_unbalanced = _classn in _planesArray;
	//Vitesse pushback en km/h
	_pushspeed = 5;

  //Appel de conversion vitesse en vélocité (int)
  _realVelocity = [-(_pushspeed)] call _get_velocity;

	{
	    if (300 == ctrlIDD _x) then {
				(_x displayCtrl 205) ctrlSetFade 1;
				(_x displayCtrl 205) ctrlCommit 0;
				_ctrl = _x ctrlCreate ["RscReverseThrottle", 10050];
	    };
	} count (uiNamespace getVariable "IGUI_displays");

  //On lance le script du reverse au sol
  [_veh,_realVelocity,_unbalanced] execVM "RV_ReverseThrust\functions\groundReverse.sqf";
} else {
//Reverse en vol

	{
			if (300 == ctrlIDD _x) then {
				(_x displayCtrl 205) ctrlSetFade 1;
				(_x displayCtrl 205) ctrlCommit 0;
				_ctrl = _x ctrlCreate ["RscReverseThrottle", 10050];
			};
	} count (uiNamespace getVariable "IGUI_displays");

	//On lance le script du reverse en vol
	[_veh,_isHeliPlane,_dangerSpeed,_resolutionTimeDiv] execVM "RV_ReverseThrust\functions\flightReverse.sqf";

};

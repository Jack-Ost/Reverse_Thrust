/***************************
--	Reverse Thrust Script --
--	Version : 2.0		      --
--	Author : Jack Ost	    --
--	Licence : GNU GPLv3	  --
***************************/

params ["_veh","_realVelocity","_unbalanced"];

//Démarrage progressif
for [{_i=1}, {_i < 100}, {_i=_i+1}] do {
  //Définition de la vitesse
  _veh setVelocityModelSpace [0, _realVelocity/(100-_i), 0];
  sleep 0.001;
};

//Enclenchement du reverse thrust
while {not (_veh getVariable ["RV_des",true]) && (airplaneThrottle _veh) == 0 && (isEngineOn _veh)} do {
  //Définition de la vitesse
  _veh setVelocityModelSpace [0, _realVelocity, 0];
  //Intervalle de simulation
  sleep 0.001;
  //Test avion déséquilibré
  if (_unbalanced) then {
    //Remise bonne position appareil
    _veh setvectorup [0,0,1];
  };
};

call compile preprocessFileLineNumbers 'RV_ReverseThrust\functions\fn_ReverseOff.sqf';

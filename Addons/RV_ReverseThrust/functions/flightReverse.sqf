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

params ["_veh","_isHeliPlane","_dangerSpeed","_resolutionTimeDiv"];

_decel = 0;

while {not (_veh getVariable ["RV_des",true]) && (isEngineOn _veh)} do {
  scopeName "while1";
  //Récupération vitesse de l'appareil (int)
  _realSp = speed _veh;
	//Récupération valeur du throttle
	_throttlevalue = airplaneThrottle _veh;
  //Vérification avion à hélices ou à réacteurs
  if (_isHeliPlane) then {
  //Avion hélices

    //Vérification vitesse positive
    if(_realSp <= 0 || _throttlevalue != 0) then {
      _veh setVariable ["RV_des",true,true];
      breakOut  "while1";
    } else {
			//Constante de décelleration basée sur une moyenne
			_decel = 20;
    };

  } else {
  //Avion réacteurs

    //Vérification vitesse suffisante
    if(_realSp<_dangerSpeed) then { breakOut  "while1"; };
    //Vérification activation après touché sol
    if((getPos _veh # 2) < 0.1 && _throttlevalue == 0) then {
        //Constante de décelleration basée sur le rvt du 787-800 au tg (int)
        _decel = 13;
    } else {
        //Constante de décelleration nulle (int)
        _decel=0;
    };
  };
  //Conversion vitesse en vélocité (velocity)
  _realVelocity = [-_decel/_resolutionTimeDiv] call _get_velocity;
	//Variable vélocité véhicule
	_velocity = velocityModelSpace _veh;
  //Définition de la vitesse
	_veh setVelocityModelSpace [(_velocity # 0), (_velocity # 1)+_realVelocity, (_velocity # 2)];
  //Intervalle de simulation
  sleep (1/_resolutionTimeDiv);
};


call compile preprocessFileLineNumbers 'RV_ReverseThrust\functions\fn_ReverseOff.sqf';

/***************************
--	Reverse Thrust Script --
--	Version : 2.0		  --
--	Author : Jack Ost	  --
--	All rights reserved	  --
***************************/

/*_get_realSpeed = {
	private ["_velx","_vely"];

	_velx = _this select 0;
	_vely = _this select 1;
	_speedX = round((_velx*3.5)+ (_velx/5) * 0.5);
	_speedY = round((_vely*3.5)+ (_vely/5) * 0.5);
	_X = sin(_dir)*_speedX;
	_Y = cos(_dir)*_speedY;
	_realSpeed = _X+_Y;
	_realSpeed;
};*/

_get_velocity = {
	private ["_vel"];

	_vel = _this select 0;
	_veloc = 0.278*_vel;
	_veloc;
};

params ["_veh","_isHeliPlane","_dangerSpeed","_resolutionTimeDiv"];

_decel = 0;
//_dir = direction _veh;

while {not (_veh getVariable ["RV_des",true]) && (isEngineOn _veh)} do {
  scopeName "while1";
  //Récupération vitesse de l'appareil (int)
  _realSp = speed _veh;//[(velocity _veh # 0), (velocity _veh # 1)] call _get_realSpeed;
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
  //Inclinaison de l'appareil
  //_objVector = vectorUp _veh;
	//Variable vélocité véhicule
	//_velocity = velocity _veh;
	_velocity = velocityModelSpace _veh;
  //Définition de la vitesse
  //_veh setVelocity [(_velocity # 0)+_realVelocity*(sin _dir) , (_velocity # 1)+_realVelocity*(cos _dir), (_velocity # 2)+_realVelocity*((_objVector # 0)*(-1))];
	_veh setVelocityModelSpace [(_velocity # 0), (_velocity # 1)+_realVelocity, (_velocity # 2)];
	//Direction de l'appareil
  //_dir = direction _veh;
  //Intervalle de simulation
  sleep (1/_resolutionTimeDiv);
};


call compile preprocessFileLineNumbers 'RV_ReverseThrust\functions\fn_ReverseOff.sqf';

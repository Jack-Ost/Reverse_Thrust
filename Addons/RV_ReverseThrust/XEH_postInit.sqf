
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

["Reverse Thrust", "RV_reverseOn_key", localize "STR_RV_Activation", {
    _this call compile preprocessFileLineNumbers 'RV_ReverseThrust\functions\fn_ReverseOn.sqf';
}, "", [DIK_PGUP, [true, false, false]]] call CBA_fnc_addKeybind;

["Reverse Thrust", "RV_reverseOff_key", localize "STR_RV_Deactivation", {
    _this call compile preprocessFileLineNumbers 'RV_ReverseThrust\functions\fn_ReverseOff.sqf';
}, "", [DIK_PGDN, [true, false, false]]] call CBA_fnc_addKeybind;

#include <amxmodx>
#include <amxmisc>

#pragma semicolon 1

const ADMIN_FLAG = ADMIN_BAN;

const TASK_MOAN = 6969;

const Float:NEXT_MOAN_TIME = 10.0;

new const szMoanMP3Sounds[][] = {
	"sound/moan/moan1.mp3", "sound/moan/moan2.mp3", "sound/moan/moan3.mp3"
};

new const szMoanWAVSounds[][] = {
	"sound/moan/moan1.wav", "sound/moan/moan2.wav", "sound/moan/moan3.wav"
};

#define ID_MOAN (TaskIndex - TASK_MOAN)

public plugin_init(){
	register_plugin("Admin Moan", "1.0", "Roccoxx");

	register_concmd("amx_moan", "ConcmdMoan", ADMIN_FLAG, "Marcar Jugador");
}

public plugin_precache(){
	for(new i; i < sizeof(szMoanMP3Sounds); i++) precache_generic(szMoanMP3Sounds[i]);
	for(new i; i < sizeof(szMoanWAVSounds); i++) precache_generic(szMoanWAVSounds[i]);
}

public client_disconnected(iId) remove_task(iId+TASK_MOAN);

public ConcmdMoan(const iId, const iLevel, const iCid){
	if((get_user_flags(iId) & iLevel) != iLevel) return PLUGIN_HANDLED;

	if(read_argc() < 3)
	{
		client_print(iId, print_console, "Uso: amx_moan <nombre> <modo>");
		return PLUGIN_HANDLED;
	}

	new szArg1[32], iTarget; read_argv(1, szArg1, charsmax(szArg1));

	iTarget = cmd_target(iId, szArg1, CMDTARGET_ALLOW_SELF);
		
	if(!iTarget){
		client_print(iId, print_console, "Jugador no encontrado");
		return PLUGIN_HANDLED;
	}

	new szArg2[4], iMode; read_argv(2, szArg2, charsmax(szArg2));

	iMode = str_to_num(szArg2);

	if(iMode == 1){
		client_cmd(iTarget, "MP3Volume 1");
		client_cmd(iTarget, "mp3 stop");
		client_cmd(iTarget, "mp3 play ^"%s^"", szMoanMP3Sounds[random_num(0, charsmax(szMoanMP3Sounds))]);

		remove_task(iTarget+TASK_MOAN); set_task_ex(NEXT_MOAN_TIME, "PlayMP3Moan", iTarget+TASK_MOAN, _, _, SetTask_Repeat);
	}
	else{
		iMode = 2;

		client_cmd(iTarget, "volume 1");
		client_cmd(iTarget, "mp3 stop");
		client_cmd(iTarget, "spk ^"%s^"", szMoanWAVSounds[random_num(0, charsmax(szMoanWAVSounds))]);
		remove_task(iTarget+TASK_MOAN); set_task_ex(NEXT_MOAN_TIME, "PlayWAVMoan", iTarget+TASK_MOAN, _, _, SetTask_Repeat);
	}
	
	return PLUGIN_HANDLED;
}

public PlayWAVMoan(const TaskIndex){
	client_cmd(ID_MOAN, "volume 1");
	client_cmd(ID_MOAN, "mp3 stop");
	client_cmd(ID_MOAN, "spk ^"%s^"", szMoanWAVSounds[random_num(0, charsmax(szMoanWAVSounds))]);
}

public PlayMP3Moan(const TaskIndex){
	client_cmd(ID_MOAN, "MP3Volume 1");
	client_cmd(ID_MOAN, "mp3 stop");
	client_cmd(ID_MOAN, "mp3 play ^"%s^"", szMoanMP3Sounds[random_num(0, charsmax(szMoanMP3Sounds))]);
}


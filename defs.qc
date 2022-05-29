/*
==============================================================================

			SOURCE FOR GLOBALVARS_T C STRUCTURE

==============================================================================
*/

//
// system globals
//
entity		self;
entity		other;
entity		world;
float		time;
float		frametime;

float		force_retouch;		// force all entities to touch triggers
								// next frame.  this is needed because
								// non-moving things don't normally scan
								// for triggers, and when a trigger is
								// created (like a teleport trigger), it
								// needs to catch everything.
								// decremented each frame, so set to 2
								// to guarantee everything is touched
string		mapname;

float		deathmatch;
float		coop;
float		teamplay;

float		serverflags;		// propagated from level to level, used to
								// keep track of completed episodes

float		total_secrets;
float		total_monsters;

float		found_secrets;		// number of secrets found
float		killed_monsters;	// number of monsters killed


// spawnparms are used to encode information about clients across server level changes
float		parm1, parm2, parm3, parm4, parm5, parm6, parm7, parm8, parm9, parm10, parm11, parm12, parm13, parm14, parm15, parm16;

// global variables set by built in functions
vector		v_forward, v_up, v_right;	// set by makevectors()
	
// set by traceline / tracebox
float		trace_allsolid;
float		trace_startsolid;
float		trace_fraction;
vector		trace_endpos;
vector		trace_plane_normal;
float		trace_plane_dist;
entity		trace_ent;
float		trace_inopen;
float		trace_inwater;

entity		msg_entity;				// destination of single entity writes

// required prog functions
void() 		main;						// only for testing

void()		StartFrame;

void() 		PlayerPreThink;
void() 		PlayerPostThink;

void()		ClientKill;
void()		ClientConnect;
void() 		PutClientInServer;		// call after setting the parm1... parms
void()		ClientDisconnect;

void()		SetNewParms;			// called when a client first connects to
									// a server. sets parms so they can be
									// saved off for restarts

void()		SetChangeParms;			// call to set parms for self so they can
									// be saved for a level transition


//================================================
void		end_sys_globals;		// flag for structure dumping
//================================================

/*
==============================================================================

			SOURCE FOR ENTVARS_T C STRUCTURE

==============================================================================
*/

//
// system fields (*** = do not set in prog code, maintained by C code)
//
.float		modelindex;		// *** model index in the precached list
.vector		absmin, absmax;	// *** origin + mins / maxs

.float		ltime;			// local time for entity
.float		movetype;
.float		solid;

.vector		origin;			// ***
.vector		oldorigin;		// ***
.vector		velocity;
.vector		angles;
.vector		avelocity;

.vector		punchangle;		// temp angle adjust from damage or recoil

.string		classname;		// spawn function
.string		model;
.float		frame;
.float		skin;
.float		effects;

.vector		mins, maxs;		// bounding box extents reletive to origin
.vector		size;			// maxs - mins

.void()		touch;
.void()		use;
.void()		think;
.void()		blocked;		// for doors or plats, called when can't push other

.float		nextthink;
.entity		groundentity;

// stats
.float		health;
.float		frags;
.float		weapon;			// one of the IT_SHOTGUN, etc flags
.string		weaponmodel;
.float		weaponframe;
.float		currentammo;
.float		ammo_shells, ammo_nails, ammo_rockets, ammo_cells;

.float		items;			// bit flags

.float		takedamage;
.entity		chain;
.float		deadflag;

.vector		view_ofs;			// add to origin to get eye point

.float		button0;		// fire
.float		button1;		// use
.float		button2;		// jump

.float		impulse;		// weapon changes

.float		fixangle;
.vector		v_angle;		// view / targeting angle for players
.float		idealpitch;		// calculated pitch angle for lookup up slopes


.string		netname;

.entity 	enemy;

.float		flags;

.float		colormap;
.float		team;

.float		max_health;

.float		teleport_time;	// don't back up

.float		armortype;		// save this fraction of incoming damage
.float		armorvalue;

.float		waterlevel;		// 0 = not in, 1 = feet, 2 = wast, 3 = eyes, 4 = entire bbox
.float		watertype;		// a contents value

.float		ideal_yaw;
.float		yaw_speed;

.entity		aiment;

.entity 	goalentity;		// a movetarget or an enemy

.float		spawnflags;

.string		target;
.string		targetname;

// damage is accumulated through a frame. and sent as one single
// message, so the super shotgun doesn't generate huge messages
.float		dmg_take;
.float		dmg_save;
.entity		dmg_inflictor;

.entity		owner;		// who launched a missile
.vector		movedir;	// mostly for doors, but also used for waterjump

.string		message;	// trigger messages

.float		sounds;		// either a cd track number or sound number

.string		noise, noise1, noise2, noise3;	// contains names of wavs to play

//================================================
void		end_sys_fields;			// flag for structure dumping
//================================================

/*
==============================================================================

				VARS NOT REFERENCED BY C CODE

==============================================================================
*/

// globals

float	gameover;		// set when a rule exits

string	nextmap;		// used by changelevel code in t_level.qc - 'mapname' is current map
string	inter_text;		// used by changelevel code in t_level.qc

nosave string	string_null;	// null string, nothing should be held here

entity	activator;		// the entity that activated a trigger or brush

entity	damage_attacker;	// set by T_Damage

float	framecount;
float	reset_flag;
float	startingserverflags;
nosave float	gamestarted;
nosave float	cleanUpClientShit;
nosave float	clients;
nosave float	clientsAlive;

float	skill;
float	coop_time;

// for balancing: total monster HP/ammo -HP/zombies/grenades in the level
float	monster_health;	
float	ammo_total;
float	num_zombies;
float	num_rockets;

float	trace_debug;

// moved from ai.qc or maybe combat.qc - used for target finding
float	enemy_vis, enemy_range;//, enemy_infront;
float	enemy_yaw();

// when a monster becomes angry at a player, that monster will be used
// as the sight target the next frame so that monsters near that one
// will wake up even if they wouldn't have noticed the player
entity	sight_entity;
float	sight_entity_time;

// moved from world.qc
entity	lastspawn, bodyqueue_head;

// moved from client.qc
float	intermission_running, intermission_exittime;
float	modelindex_eyes, modelindex_player;

float	icantsee;
float	isKex;	// running the quake rerelease

//================================================

// world fields
.string		wad;
.string 	map;
.float		worldtype;	// 0=medieval 1=metal 2=base

.string		killtarget;
.string		target2;
.string		target3;
.string		target4;
//.string		pretarget;		// to be fired before ... things
//.string		posttarget;		// to be fired after them

.float		alpha;

// lights
.float		style;
.float		oldstyle;
.float		switchshadstyle;	// was "shadowstyle" too clear and easy to type or something

// monster ai
.void()		th_stand;
.void()		th_walk;
.void()		th_run;
.void()		th_missile;
.void()		th_melee;
.void(entity attacker, float damage) th_pain;
.void()		th_die;
.float()	th_checkattack;
.entity		oldenemy;		// mad at this player before taking damage
.float 		attack_finished;
.float		pain_finished;
.float		search_time;
.float		attack_state;
.float 		pausetime;

// player only fields
.float		walkframe;
.float		invincible_time, invincible_sound, invincible_finished;
.float		invisible_time, invisible_sound, invisible_finished;
.float		super_time, super_sound, super_damage_finished;
.float		rad_time, radsuit_finished;
.float		nextmovesound;	// replaces swim_flag and fly_sound, both of which were timers
.float		show_hostile;	// set to time+0.2 whenever a client fires a
							// weapon or takes damage.  Used to alert
							// monsters that otherwise would let the player go
.float		jump_flag;		// player jump "flag"
.float		air_finished;	// when time > air_finished, start drowning
.float		bubble_count;	// keeps track of the number of bubbles
.float		healthtime;
.string		deathtype;		// keeps track of how the player died

// fog
.vector		fog_color, fog_color2;
.float		fog_density, fog_density2;


// object stuff
//.string		mdl;			// only used by items to hide until respawn time
.float		gravity;
.vector		mangle;			// angle at start

// doors/movers
.vector		dest, dest1, dest2;
.vector		pos1, pos2;		// top and bottom positions
//.vector		oldorigin;		// only used by secret door
.vector		finaldest;
.void()		think1;
.float		speed, speed2;
.float		wait;			// time from firing to restarting
.float		delay;			// time from activation to firing
.float		length, width, height;
.float t_length = length;	// preserve old func_door_secret maphacks
.float t_width = width;


.float		touch_time;
.float		lip;			
.float		state;
.float		dmg;			// damage done by door when hit
.entity		trigger_field;	// door's trigger entity
.string		noise4;

// triggers
.float		count;		// for counting triggers
.float		cnt;		// used on grunts, enforcers, dguards, and ogres for attack refire
						// reused on players for nailgun barrel cycling

// sounds
.float		distance;
.float		volume;

//.float	inpain;			// from zombie.qc, moved to .customflags
//.float	lefty;			// moved to .customflags
//.float	axhitme;		// moved to .customflags
//.float	zapped;			// moved to .customflags
.float		customflags;	// inpain, axehitme, zapped, etc, see constants.qc
.float		healamount;		// moved from items.qc - only used on health boxes
.float		dmgtime;		// moved from client.qc - used in drowning code & as a coop aggro timer
.entity		multidmg_chain;	// moved from combat.qc - for multidmg	
.float		multi_dmg;

.string		type;			// to make find()ing easier, and for tons of useful misc. classification
.entity		buddy;			// a common entity reference without the specific implications of 'owner' or 'enemy'
.float		strength;

.float		lifetime_finished;
.float		notrace;		// entity will be invisible to traceline2()
.vector		oldvelocity;	// necessary for getting projectiles to pass through .notrace entities
.entity		trueowner;		// now this is getting dumb

// OVERLOADS:
.float rand = healamount;	// for trigger_timer
.float svflags = jump_flag;	// for target_give and item_sigil
.vector fadecolor = fog_color;	// for func_void fadeout
.string	include = wad;		// for monsterjump filters
.string exclude = map;
.float light_lev = bubble_count;	// shuts up a stupid stupid warning
.vector rmovedir = finaldest;
.float version = worldtype;

//================================================

typedef enum
{
	true = 1,
	false = 0,
	TRUE = 1,
	FALSE = 0
} bool;

//================================================

#define printf(...) print(sprintf(__VA_ARGS__))
#define client_printf(client, ...) sprint(client, sprintf(__VA_ARGS__))

#define array_len(_a) (sizeof(_a) / sizeof((_a)[0]))

//================================================

/*FGD
@baseclass = Angle [ angle(integer) : "Direction" ]
@baseclass = Appearflags [
	spawnflags(Flags) =
	[
		256 : "Not on Easy" : 0
		512 : "Not on Normal" : 0
		1024 : "Not on Hard+" : 0
		2048 : "Not in Deathmatch" : 0
		4096 : "Only in Coop" : 0
		8192 : "Not in Coop" : 0
	]
]

@baseclass = Targetname [ targetname(target_source) : "Name" ]
@baseclass = Target [ 
	target(target_destination) : "Target" 
	target2(target_destination) : "Target" 
	target3(target_destination) : "Target" 
	target4(target_destination) : "Target" 
	killtarget(target_destination) : "Killtarget"
	delay(string) : "Delay before firing targets" : "0"
]

@baseclass = Deathtype [ deathtype(string) : "Obituary message" ]
@baseclass = Bounds [ mangle(string) : "Bounds size, centered (x y z)" ]

@baseclass = Phong [
	_phong(integer) : "Use phong smoothing" : 0
	_phong_angle(integer) : "Phong angle" : 88
]
*/
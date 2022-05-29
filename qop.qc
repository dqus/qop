int qop; // qop mode switch.
static int total_spots; // Total amount of monster spawn spots.

typedef struct
{
	string classname;		// monsters class name.
	void() spawn;			// spawn func.
	int hp_for_kill;		// how much hp player gains for killing such monster.
	int armor_for_kill;		// how much armor player gains for killing such monster.
//	bool boss_able;			// able to be boss.
} monster_t;

static monster_t monsters[] =
{
	{
		.classname = "monster_ogre",
		.spawn = monster_ogre,
		.hp_for_kill = 3,
		.armor_for_kill = 2
	},
	{
		.classname = "monster_demon1",
		.spawn = monster_demon1,
		.hp_for_kill = 4,
		.armor_for_kill = 4
	},
	{
		.classname = "monster_shambler",
		.spawn = monster_shambler,
		.hp_for_kill = 10,
		.armor_for_kill = 8
	},
	{
		.classname = "monster_knight",
		.spawn = monster_knight,
		.hp_for_kill = 1,
		.armor_for_kill = 1
	},
	{
		.classname = "monster_army",
		.spawn = monster_army,
		.hp_for_kill = 1,
		.armor_for_kill = 1
	},
	{
		.classname = "monster_wizard",
		.spawn = monster_wizard,
		.hp_for_kill = 2,
		.armor_for_kill = 2
	},
	{
		.classname = "monster_dog",
		.spawn = monster_dog,
		.hp_for_kill = 1,
		.armor_for_kill = 1
	},
	{
		.classname = "monster_zombie",
		.spawn = monster_zombie,
		.hp_for_kill = 1,
		.armor_for_kill = 1
	},
	{
		.classname = "monster_tarbaby",
		.spawn = monster_tarbaby,
		.hp_for_kill = 4,
		.armor_for_kill = 4
	},
	{
		.classname = "monster_hell_knight",
		.spawn = monster_hell_knight,
		.hp_for_kill = 4,
		.armor_for_kill = 3
	},
	{
		.classname = "monster_shalrath",
		.spawn = monster_shalrath,
		.hp_for_kill = 6,
		.armor_for_kill = 6
	},
	{
		.classname = "monster_enforcer",
		.spawn = monster_enforcer,
		.hp_for_kill = 2,
		.armor_for_kill = 1
	},
};

void qop_think(void)
{
	if (qop == 0 || total_spots == 0)
	{
		return; // qop mode disabled or map does not support it.
	}

	spawn_monsters();
}

static void spawn_monsters(void)
{
	// Precache all monsters at frame 1.
	if (framecount == 1)
	{
		precache_monsters();
	}
	// Check various conditions if we are ready for spawning monsters.
	if (time < 3 || framecount < 100 || monsters_alive_count() >= 10)
	{
		return;
	}
	// Attempt to spawn one monster.
	// We trying to do it few times in row since we can fail because spawn point is busy or something.
	for (int i = 0; i < 30; i++)
	{
		if (spawn_one_monster())
		{
			return;
		}
	}
}

static entity spawn_one_monster(void)
{
	int idx = 0;
	// Find random spawn point.
	entity spot = find_idx(classname, "info_monster_start", i_rnd(0, total_spots - 1));
	// Can't find.
	if (!spot)
	{
		return __NULL__;
	}
	// Randomly select monster.
	monster_t mon = monsters[i_rnd(0, array_len(monsters) - 1)];
	// Spawn monster.
	return spawn_one_monster_do(mon, spot);
}

static entity spawn_one_monster_do(monster_t mon, entity spot)
{
	entity oself = self; // Remember self.
	entity spawned = spawn();
	self = spawned; // Changed self.
	self.angles = spot.angles;
	self.origin = spot.origin;
	mon.spawn();
	self = oself; // Restore self.
	if (!spawned.solid)
	{
		return __NULL__; // Seems spawned entity was removed.
	}
	return spawned;
}

static void precache_monsters(void)
{
	for (int i = 0; i < array_len(monsters); i++)
	{
		safe_remove(spawn_one_monster_do(monsters[i], world));
	}
}

int monsters_alive_count(void)
{
	int count = 0;
	for (entity mon = nextent(world); mon != world; mon = nextent(mon))
	{
		if((mon.flags & FL_MONSTER) && mon.health > 0)
		{
			count++;
		}
	}
	return count;
}

bool qop_remove_monster_if_location_occupied(void)
{
	if (qop)
	{
		setorigin(self, self.origin);
		if (is_location_occupied(self, self.origin))
		{
			remove(self);
			return true;
		}
	}
	return false;
}

// Init body fading in qop mode.
void monster_init_fade(void)
{
	if (qop == 0)
	{
		return;
	}
	self.alpha = 1;
	self.think = monster_fade;
	self.nextthink = time + 2 + random() * 3;
}

static void monster_fade(void)
{
	self.alpha -= 0.025;
	if (self.alpha <= 0) {
		remove(self);
		return;
	}
	self.nextthink = time + 0.05;
}

void info_monster_start(void)
{
	total_spots++;
}

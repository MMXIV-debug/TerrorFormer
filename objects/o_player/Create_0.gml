// Stats ----------------------
hpMax = 10;
hp = hpMax


// Movimiento -----------------
	// Variales en X --------------
xSpeedMax = 5.5;
xSpeed = 0;
xAccel = 0.5;

	//Variables en Y ---------------
ySpeed = 0;
fallMax = 11;
grav = 0.5;

// Control --------------------
is_on_floor = 0; // Variable de control de si esta en el suelo
facing = 1;
jumpSpeed = 10;

// Ataque ---------------------
weaponSlots = ["Slash", "Bullet"]
current_weapon_index = 0;
weapon = weaponSlots[current_weapon_index];
atkCooldown = 12;
canAttack = 1;
doStep = true;
hsp = 0;
vsp = 0;
height = bbox_bottom - bbox_top;
halfHeight = height * 0.5;
halfWidth = (bbox_right - bbox_left) * 0.5;
//terrain = layer_tilemap_get_id(layer_get_id("Terrain"));

grav = 0.3;
maxFallSpeed = 10;
walkSpeed = 3;
jumpForce = -6;
canJump = 0;
jumpHoldTimer = 0;
grounded = false;
aimDir = 0;
left = 180;
right = 0;
facing = right;
isPlanted = false;
isShooting = false;

center_y = function()
{
	return y - (height * 0.5);
}

accel = 1.0;
decel = 1.0;


adjCamX = camera_get_view_x(view_camera[0]);
adjCamY = camera_get_view_y(view_camera[0]);
camZoom = 1;
camZoomFactor = 0.2;

canShoot = true;
keyShootHeld = false;
//shotInterval = 8;
//shotTimer = 0;

//roomManager = oRoomManager;

useMouse = true;
//mouseAimStartX = 0;
//mouseAimStartY = 0; 
//isMouseAiming = false;

roomBounds = noone;

hitPoints = 100;
//safetyInterval = 10
//safetyTimer = 0;

hit = false;
lastCheckpoint = noone;
disableInput = false;
respawnTimer = 0;
respawnInterval = 60;
isRespawning = false;

currentRegion = instance_place(x, y, oRegion);

//is_hit = function()
//{
//	if (shieldStrength > 0 || safetyTimer > 0) return false;
	
//	var bullet = instance_place(x, y, oBullet);
//	if (bullet && !bullet.isPlayerOwned)
//	{
//		bullet.deactivate();
//		hit = true;
//		hsp = 0;
//		//vsp = 0;
//		hitPoints-=bullet.damage;
//		if (hitPoints <= 0) die();
//		safetyTimer = safetyInterval;
//		audio_play_sound(take_hit, 10, false);
//		screen_shake(5, 1, 0.2);
//		return true;
//	}
	
//	var enemy = instance_place(x, y, oEnemy)
//	if (enemy)
//	{
//		hit = true;
//		hsp = 0;
//		//vsp = 0;
//		hitPoints-=enemy.damage;
//		if (hitPoints <= 0) die();
//		safetyTimer = safetyInterval;
//		audio_play_sound(take_hit, 10, false);
//		screen_shake(5, 1, 0.2);
//		return true;
//	}
//	return false;
//}

//die = function()
//{
//	visible = false;
//	disableInput = true;
//	doStep = false;
//	instance_create_layer(0, 0, "Transition", oFadeCheckpoint);
//	with(oCheckpoint) 
//	{
//		doQuickSave = false;
//		sprite_index = sCheckpointIdle;
//	}
//	instance_create_layer(x, y - 16, "Instances", oGlitchGib);
//	instance_create_layer(x, y - 16, "Instances", oGlitchGib);
//	instance_create_layer(x, y - 16, "Instances", oGlitchGib);
//	instance_create_layer(x, y - 16, "Instances", oGlitchGib);
//	instance_create_layer(x, y - 16, "Instances", oGlitchGib);
//	instance_create_layer(x, y - 16, "Instances", oGlitchGib);
//	instance_create_layer(x, y - 16, "Instances", oGlitchGib);
//	instance_create_layer(x, y - 16, "Instances", oGlitchGib);
//	instance_create_layer(x, y - 16, "Instances", oGlitchGib);
//}

//respawn = function()
//{
//	visible = true;
//	reset_hacks(self);
//	hitPoints = 100;
//	shieldCoolDownTimer = 0;
//	recoveryTimer = 0;
//	if (lastCheckpoint != noone)
//	{
//		x = lastCheckpoint.x;
//		y = lastCheckpoint.y;
//	}
//	with(oBounds) reset_room_bounds();
//	roomBounds = instance_place(x, y, oBounds);
//	doStep = true;
//	isRespawning = true;
//	respawnTimer = respawnInterval;
//}
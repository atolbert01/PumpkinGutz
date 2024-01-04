if (!doStep) exit;
if (isRespawning)
{
	if (respawnTimer > 0)
	{
		respawnTimer--;
	}
	else
	{
		isRespawning = false;
		disableInput = false;
		if (roomBounds != noone)
		{
			roomBounds.active = true;
		}
		//with (oBounds)
		//{
		//	unpause_actors();
		//}
		//with (oFadeCheckpoint)
		//{
		//	instance_destroy();
		//}
	}
}

var f1 = keyboard_check_pressed(vk_f1);
var f2 = keyboard_check_pressed(vk_f2);

//if (f1) oRoomManager.playSound = !oRoomManager.playSound;


var gpAim = !disableInput && (gamepad_button_check(0, gp_shoulderr) || gamepad_button_check(0, gp_shoulderl));
var keyAim = !disableInput && (mouse_check_button(mb_right) || keyboard_check(vk_shift) || keyboard_check(ord("C")) || gpAim);

var gpRight = !disableInput && (gamepad_axis_value(0, gp_axislh) > 0.3 || gamepad_button_check(0, gp_padr));
var keyRight = !disableInput && (keyboard_check(vk_right) || keyboard_check(ord("D")) || gpRight);

var gpLeft = !disableInput && (gamepad_axis_value(0, gp_axislh) < -0.3 || gamepad_button_check(0, gp_padl));
var keyLeft = !disableInput && (keyboard_check(vk_left) || keyboard_check(ord("A")) || gpLeft);

var gpDown = !disableInput && (gamepad_axis_value(0, gp_axislv) > 0.3 || gamepad_button_check(0, gp_padd));
var keyDown = !disableInput && (keyboard_check(vk_down) || keyboard_check(ord("S")) || gpDown);

var gpUp = !disableInput && (gamepad_axis_value(0, gp_axislv) < -0.3 || gamepad_button_check(0, gp_padu));
var keyUp = !disableInput && (keyboard_check(ord("W")) || keyboard_check(vk_up) || gpUp);

var gpJump = !disableInput && (gamepad_button_check_pressed(0, gp_face1));
var keyJump = !disableInput && (keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("Z")) || gpJump);

var gpJumpHeld = !disableInput && (gamepad_button_check(0, gp_face1));
var keyJumpHeld = !disableInput && (keyboard_check(vk_space) || keyboard_check(ord("Z")) || gpJumpHeld);

var gpJumpReleased = !disableInput && (gamepad_button_check_released(0, gp_face1));
var keyJumpReleased = !disableInput && (keyboard_check_released(vk_space) || keyboard_check_released(ord("Z")) || gpJumpReleased);

if (!disableInput && !keyAim)
{
	keyJump |= keyboard_check_pressed(ord("W"));
	keyJump |= keyboard_check_pressed(vk_up);
	keyJumpHeld |= keyboard_check(ord("W"));
	keyJumpHeld |= keyboard_check(vk_up);
	keyJumpReleased |= keyboard_check_released(ord("W"));
	keyJumpReleased |= keyboard_check_released(vk_up);
}

var gpShoot = !disableInput && (gamepad_button_check_pressed(0, gp_face3));
var keyShoot = !disableInput && (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(ord("X")) || gpShoot);
keyShootHeld = !disableInput && (mouse_check_button(mb_left) || keyboard_check(ord("X")) || gamepad_button_check(0, gp_face3));

var keyShootReleased = !disableInput && (mouse_check_button_released(mb_left) || keyboard_check_released(ord("X")) || gamepad_button_check_released(0, gp_face3));

var gpAny = !disableInput && (gpAim || gpRight || gpLeft || gpDown || gpUp || gpJump || gpJumpHeld || gpJumpReleased || gpShoot);
if (useMouse && gpAny) 
{
	useMouse = false;
}

if (!useMouse && !gpAny && (window_mouse_get_delta_x() != 0 || window_mouse_get_delta_y() != 0))
{
	useMouse = true;
}


grounded = false;
		
var move = keyRight - keyLeft;
if (move < 0) hsp = max(-walkSpeed, hsp - accel);
if (move > 0) hsp = min(walkSpeed, hsp + accel);
if (move == 0) 
{
	if (sign(hsp) < 0) hsp = min(0, hsp + decel);
	else if (sign(hsp) > 0) hsp = max(0, hsp - decel);
	else hsp = 0;
}
		
vsp += grav;
if (vsp >= maxFallSpeed) vsp = maxFallSpeed;


//var tile = tilemap_get_at_pixel(tilemap, x, y + 1);
//var tile = tilemap_get(tilemap, x, y + 1);

// Am I on the ground?
//if (tilemap_get_at_pixel(tilemap, x, y + 1) > 0)
//if (vertical_collision(tilemap, bounds, 1))
if (place_meeting(x, y + 1, oWall)) 
{
	canJump = 5;
	grounded = true;
}

// Am I on the ground?
if (grounded)
{
	isPlanted = false;
	if (keyAim) 
	{
		isPlanted = true;
	}
}
else 
{
	isPlanted = false;
	if (canJump > 0)
	{
		canJump -= 1;
	}
}

if (isPlanted)
{
	move = 0;
	hsp = 0;
}


if (canJump > 0 && keyJump) 
{
	vsp = jumpForce;
	//var roll = random_range(1, 6);
	//if (roll < 4) audio_play_sound(jump1, 10, false);
	//else audio_play_sound(jump2, 10, false);
}

// Are we going up, but have released jump? Then ease off and start descending
if (vsp < 0 && !keyJumpHeld) 
{
	vsp = max(vsp, (jumpForce/2));
}

if (keyJumpHeld) 
{
	jumpHoldTimer += 1;
}
else
{
	jumpHoldTimer = 0;
}
		
if (move > 0) 
{
	facing = right;
	image_xscale = 1;
}
if (move < 0) 
{
	facing = left;
	image_xscale = -1;
}
		

if (useMouse) 
{
	//aimDir = point_direction (hackerStone.x, hackerStone.y, oCursor.x, oCursor.y);
	//aimDir = point_direction (x + halfWidth, y + halfHeight, oCursor.x, oCursor.y);
}
else
{
	// Set facing direction
// Default to left and right if no direction held.
	aimDir = facing;
	if ((keyLeft && keyRight) || (keyUp && keyDown)) aimDir = aimDir; // Don't change the aimDir if inputs cancel each other
	else if (keyLeft)
	{
		aimDir = 180;
		if (keyUp) aimDir = 135;
		else if (!grounded && keyDown) aimDir = 225;
	}
	else if (keyRight)
	{
		aimDir = 0;
		if (keyUp) aimDir = 45;
		else if (!grounded && keyDown) aimDir = 315;
	}
	else if (keyUp) aimDir = 90;
	else if (!grounded && keyDown) aimDir = 270;
}

// Horizontal Collisions
if (place_meeting(x + hsp, y, oWall))
{
	var i = abs(hsp);
	while (!place_meeting(x + sign(hsp), y, oWall) && i > 0)
	{
		x += sign(hsp);
		//head.x += sign(hsp);
		i--;
	}
	hsp = 0;
}
x += hsp;
//head.x += hsp;

// Vertical Collisions
if (place_meeting(x, y + vsp, oWall))
{
	var i = abs(vsp);
	while (!place_meeting(x, y + sign(vsp), oWall) && i > 0)
	{
		y += sign(vsp);
		//head.y += sign(vsp);
		i--;
	}
	vsp = 0;
}
y += vsp;
//head.y += vsp;

// Am I on the ground?
if (place_meeting(x, y + 1, oWall)) 
{
	canJump = 5;
	grounded = true;
	if (keyJump || (keyJumpHeld && jumpHoldTimer < 10)) vsp = jumpForce;
}







if (instance_exists(oHead))
{
	var targetX = x;
	var targetY = bbox_top;
	head.x = lerp(head.x, targetX, 0.67);
	head.y = lerp(head.y, targetY, 0.5);
}


// Check if we got hit
//is_hit();

//if (safetyTimer > 0) 
//{
//	safetyTimer--;
//	hit = true;
//}

// Update animation state
if (grounded)
{
	if (hsp != 0)
	{
		//sprite_index = sPlayerRun;
		image_xscale = sign(hsp);
		head.image_xscale = image_xscale;
	}
	else
	{
		//sprite_index = sPlayerIdle;
	}
}
else
{
	//sprite_index = sPlayerJumpCrest;
	//if (vsp < -1) sprite_index = sPlayerJumpRise;
	//if (vsp > 0) sprite_index = sPlayerJumpFall;
}

// Update camera
var viewX = camera_get_view_x(view_camera[0]);
var viewY = camera_get_view_y(view_camera[0]);
var viewWidth = camera_get_view_width(view_camera[0]);
var viewHeight = camera_get_view_height(view_camera[0]);
var lerpX = 0.1;
var lerpY = 0.1;
var goToX = x - (viewWidth * 0.5);
var goToY = y - (viewHeight * 0.5);

// Mouse aim stuff
//if (useMouse && !isMouseAiming && mouse_check_button(mb_right))
//{
//	isMouseAiming = true;
//	mouseAimStartX = oCursor.x;
//	mouseAimStartY = oCursor.y;
//}
//else if (isMouseAiming && mouse_check_button(mb_right))
//{
//	var deltaX = clamp(oCursor.x - mouseAimStartX, -1, 1);
//	var deltaY = clamp(oCursor.y - mouseAimStartY, -1, 1);
	
//	goToX = x + ((deltaX) * 150) - (viewWidth * 0.5);
//	lerpX = 0.025;

//	if (isPlanted) 
//	{
//		goToY = y + ((deltaY) * 150) - (viewHeight * 0.5);
//		lerpY = 0.05;
//	}
//}
//else
{
	//isMouseAiming = false;
	goToX = x + ((keyRight - keyLeft) * 150) - (viewWidth * 0.5);
	lerpX = 0.025;

	if (isPlanted) 
	{
		goToY = y + ((keyDown - keyUp) * 150) - (viewHeight * 0.5);
		lerpY = 0.05;
	}

}
adjCamX = lerp(viewX, goToX, lerpX);
adjCamY = lerp(viewY, goToY, lerpY);


if (camZoom > 1)
{
	camZoom = lerp(camZoom, 1, camZoomFactor);
}


if (currentRegion != noone)
{	
	var lerpHeight = lerp(viewHeight, camZoom * oCamera.camHeight, camZoomFactor);
	var newHeight = clamp(lerpHeight, 0, room_height);
	var newWidth = newHeight * (oCamera.camWidth / oCamera.camHeight);
	camera_set_view_size(view_camera[0], round(newWidth), round(newHeight));

	var offsetX = adjCamX - (newWidth - viewWidth) * 0.5;
	var offsetY = adjCamY - (newHeight - viewHeight) * 0.5;
	
	adjCamX = clamp(offsetX, currentRegion.x, (currentRegion.x + currentRegion.width) - newWidth);
	adjCamY = clamp(offsetY, currentRegion.y, (currentRegion.y + currentRegion.height) - newHeight);
}
else
{
	var lerpHeight = lerp(viewHeight, camZoom * oCamera.camHeight, camZoomFactor);
	var newHeight = clamp(lerpHeight, 0, room_height);
	var newWidth = newHeight * (oCamera.camWidth / oCamera.camHeight);
	camera_set_view_size(view_camera[0], round(newWidth), round(newHeight));

	var offsetX = adjCamX - (newWidth - viewWidth) * 0.5;
	var offsetY = adjCamY - (newHeight - viewHeight) * 0.5;
	
	adjCamX = clamp(offsetX, 0, room_width - newWidth);
	adjCamY = clamp(offsetY, 0, room_height - newHeight);
}

camera_set_view_pos(view_camera[0], round(adjCamX), round(adjCamY));
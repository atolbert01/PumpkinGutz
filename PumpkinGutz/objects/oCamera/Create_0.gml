view_enabled = true;
view_visible[0] = true;

view_xport[0] = 0;
view_yport[0] = 0;
//view_wport[0] = 1024;
//view_hport[0] = 576;

view_wport[0] = 512;
view_hport[0] = 288;


view_camera[0] = camera_create_view(0,0, view_wport[0], view_hport[0], 0, noone, -1, -1, -1, -1);

camWidth = camera_get_view_width(view_camera[0]);
camHeight = camera_get_view_height(view_camera[0]);

display_set_gui_size(camWidth, camHeight);

camWindowScale = 2;
var xPos = (display_get_width() * 0.5) - (camWidth * 0.5);
var yPos = (display_get_height() * 0.5) - (camHeight * 0.5);
window_set_rectangle(xPos, yPos, camWidth * camWindowScale, camHeight * camWindowScale);

//show_debug_message(string(camWidth) + ", "+ string(camHeight));

surface_resize(application_surface, camWidth, camHeight);

// Parallax stuff
bgParallax1 = undefined;
bgParallax2 = undefined;

if (layer_exists("BgParallax1"))
{
	bgParallax1 = layer_get_id("BgParallax1");
}

if (layer_exists("BgParallax2"))
{
	bgParallax2 = layer_get_id("BgParallax2");
}
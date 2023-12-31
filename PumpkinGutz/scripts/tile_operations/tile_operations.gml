function horizontal_collision(tilemap, bounds, offset)
{	
	// top, mid, bottom
	// left, right
	xCheck = sign(offset) > 0 ? bounds.right : bounds.left;
	if (tilemap_get_at_pixel(tilemap, xCheck + offset, bounds.top) > 0) return true;
	if (tilemap_get_at_pixel(tilemap, xCheck + offset, bounds.midY) > 0) return true;
	if (tilemap_get_at_pixel(tilemap, xCheck + offset, bounds.bottom) > 0) return true;
	
	return false;
}

function vertical_collision(tilemap, bounds, offset)
{	
	// top, mid, bottom
	// left, right
	yCheck = sign(offset) > 0 ? bounds.bottom : bounds.top;
	if (tilemap_get_at_pixel(tilemap, bounds.left, yCheck + offset) > 0) return true;
	if (tilemap_get_at_pixel(tilemap, bounds.midX, yCheck + offset) > 0) return true;
	if (tilemap_get_at_pixel(tilemap, bounds.right, yCheck + offset) > 0) return true;
	
	return false;
}
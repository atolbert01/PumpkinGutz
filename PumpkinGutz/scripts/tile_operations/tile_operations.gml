enum DIR
{
	Left = 1,
	Right = 2,
	Up = 4,
	Down = 8,
}

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


function generate_terrain_walls(tilemap)
{
	var mapWidth = tilemap_get_width(tilemap);
	var mapHeight = tilemap_get_height(tilemap);
	visited[0, 0] = 0;
	
	// Destroy all walls
	with (oWall) { instance_destroy(); }
	
	for (var xx = 0; xx < mapWidth; xx++)
	{
		for (var yy = 0; yy < mapHeight; yy++)
		{
			var tile = tilemap_get(tilemap, xx, yy);
			if (tile > 0 && !visited[xx, yy]) // 0 is empty, -1 is an error.
			{
				visited[xx, yy] = 1;
				
				
				var xMin = xx;
				var xMax = xx;
				var yMin = yy;
				var yMax = yy;
				
				//var myNeighbors = oEditor.neighbors[xx, yy];
				
				var leftNeighbor = tilemap_get(tilemap, xx - 1, yy);
				var rightNeighbor = tilemap_get(tilemap, xx + 1, yy);
				var topNeighbor = tilemap_get(tilemap, xx, yy - 1);
				var bottomNeighbor = tilemap_get(tilemap, xx, yy + 1);
				
				
				if (leftNeighbor) // Do I have a left neighbor?
				{
					var result = walk_left(tilemap, myNeighbors, xx, yy);
					xMin = result;
				}
				
				if (rightNeighbor) // Do I have a right neighbor?
				{
					var result = walk_right(tilemap, myNeighbors, xx, yy, mapWidth);
					xMax = result;
				}
				
				if (topNeighbor) // Do I have an up neighbor?
				{
					var result = walk_up(tilemap, myNeighbors, xx, yy);
					yMin = result;
				}
				
				// Do I have a down neighbor? 
				// Also, add a check for edge cases. Don't walk down if I DO NOT have a right neighbor
				if (bottomNeighbor && !rightNeighbor)
				{
					var result = walk_down(tilemap, myNeighbors, xx, yy, mapHeight);
					yMax = result;
				}
				
				if (xMin > -1 && yMin > -1 && xMax < mapWidth && yMax < mapHeight)
				{
					var newWall = instance_create_layer(xMin * GRID_SIZE, yMin * GRID_SIZE, "Terrain", oWall);
					newWall.image_xscale += xMax - xMin;
					newWall.image_yscale += yMax - yMin;
				}
			}
		}
	}
	
	//show_debug_message("Walls Before: " + string(instance_number(oWall)));
	
	with (oWall)
	{
		var otherWall = instance_place(bbox_left, bbox_bottom, oWall);
		if (otherWall != noone)
		{
			if (otherWall.bbox_top - bbox_bottom < 1 && otherWall.bbox_left == bbox_left && otherWall.bbox_right == bbox_right)
			{
				var yScale = floor((otherWall.bbox_bottom - bbox_bottom) / GRID_SIZE);
				image_yscale += yScale;
				instance_destroy(otherWall);
			}
		}
		otherWall = instance_place(x, y, oWall);
		if (otherWall != noone)
		{
			if (otherWall.bbox_left == bbox_left && otherWall.bbox_right == bbox_right && otherWall.bbox_top == bbox_top && otherWall.bbox_bottom == bbox_bottom)
			{
				instance_destroy(otherWall);
			}
		}
	}
	
	//show_debug_message("Walls After: " + string(instance_number(oWall)));
}

function walk_left(tilemap, rightNeighbors, xx, yy)
{
	var xToCheck = xx - 1;
	var tile = tilemap_get(tilemap, xToCheck, yy);
	//var myNeighbors = oEditor.neighbors[xToCheck, yy];
	
	var leftNeighbor = tilemap_get(tilemap, xx - 1, yy);
	var rightNeighbor = tilemap_get(tilemap, xx + 1, yy);
	var topNeighbor = tilemap_get(tilemap, xx, yy - 1);
	var bottomNeighbor = tilemap_get(tilemap, xx, yy + 1);
	var hasNeighbors = leftNeighbor + rightNeighbor + topNeighbor + bottomNeighbor > 0;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	while (myNeighbors != 0 && tile > 0 && !oEditor.visited[xToCheck, yy] && xToCheck > -1)
	{
		if (myNeighbors & DIR.Right && (myNeighbors & DIR.Up == rightNeighbors & DIR.Up) && (myNeighbors & DIR.Down == rightNeighbors & DIR.Down))
		{
			oEditor.visited[xToCheck, yy] = 1; // We are only visited if we can be added to the current wall
			xToCheck -= 1;
			
			if (xToCheck < 0) break;
			
			rightNeighbors = myNeighbors;
			myNeighbors = oEditor.neighbors[xToCheck, yy];
			tile = tilemap_get(tilemap, xToCheck, yy);
		}
		else
		{
			break;
		}
	}
	return xToCheck + 1;
}

function walk_right(tilemap, leftNeighbors, xx, yy, mapWidth)
{
	var xToCheck = xx + 1;
	var tile = tilemap_get(tilemap, xToCheck, yy);
	var myNeighbors = oEditor.neighbors[xToCheck, yy];
	
	while (myNeighbors != 0 && tile > 0 && !oEditor.visited[xToCheck, yy] && xToCheck < mapWidth)
	{
		if (myNeighbors & DIR.Left && (myNeighbors & DIR.Up == leftNeighbors & DIR.Up) && (myNeighbors & DIR.Down == leftNeighbors & DIR.Down))
		{
			oEditor.visited[xToCheck, yy] = 1; // We are only visited if we can be added to the current wall
			xToCheck += 1;
			
			if (xToCheck >= mapWidth) break;
			
			leftNeighbors = myNeighbors;
			myNeighbors = oEditor.neighbors[xToCheck, yy];
			tile = tilemap_get(tilemap, xToCheck, yy);
		}
		else
		{
			break;
		}
	}
	return xToCheck - 1;
}

function walk_up (tilemap, bottomNeighbors, xx, yy)
{
	var yToCheck = yy - 1;
	var tile = tilemap_get(tilemap, xx, yToCheck);
	var myNeighbors = oEditor.neighbors[xx, yToCheck];
	
	while (myNeighbors != 0 && tile > 0 && !oEditor.visited[xx, yToCheck] && yToCheck > -1)
	{
		if (myNeighbors & DIR.Down && (myNeighbors & DIR.Left == bottomNeighbors & DIR.Left) && (myNeighbors & DIR.Right == bottomNeighbors & DIR.Right))
		{
			oEditor.visited[xx, yToCheck] = 1; // We are only visited if we can be added to the current wall
			yToCheck -= 1;
			
			if (yToCheck < 0) break;
			
			bottomNeighbors = myNeighbors;
			myNeighbors = oEditor.neighbors[xx, yToCheck];
			tile = tilemap_get(tilemap, xx, yToCheck);
		}
		else
		{
			break;
		}
	}
	return yToCheck + 1;
}

function walk_down(tilemap, topNeighbors, xx, yy, mapHeight)
{
	var yToCheck = yy + 1;
	var tile = tilemap_get(tilemap, xx, yToCheck);
	var myNeighbors = oEditor.neighbors[xx, yToCheck];
	
	while (myNeighbors != 0 && tile > 0 && !oEditor.visited[xx, yToCheck] && yToCheck < mapHeight)
	{
		if (myNeighbors & DIR.Up && (myNeighbors & DIR.Left == topNeighbors & DIR.Left) && (myNeighbors & DIR.Right == topNeighbors & DIR.Right))
		{
			oEditor.visited[xx, yToCheck] = 1; // We are only visited if we can be added to the current wall
			yToCheck += 1;
			
			if (yToCheck >= mapHeight) break;
			
			topNeighbors = myNeighbors;
			myNeighbors = oEditor.neighbors[xx, yToCheck];
			tile = tilemap_get(tilemap, xx, yToCheck);
		}
		else
		{
			break;
		}
	}
	return yToCheck - 1;
}
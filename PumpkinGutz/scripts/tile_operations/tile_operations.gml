function update_terrain_walls(tilemap)
{
	// Loop through tiles in FgTiles2
	// Find out if it has neighbors and where they are
	var gridSize = GRID_SIZE;
	var mapWidth = tilemap_get_width(tilemap);
	var mapHeight = tilemap_get_height(tilemap);
	
	if (!layer_exists("Collision")) layer_create(-1000, "Collision");
	
	for(var xx = 0; xx < mapWidth; xx++)
	{
		for (var yy = 0; yy < mapHeight; yy++)
		{
			oRoomManager.visited[xx, yy] = 0;
			oRoomManager.neighbors[xx, yy] = 0;
			
			var tile = tilemap_get(tilemap, xx, yy);
			if (tile > 0) // 0 is empty, -1 is an error.
			{
				var leftNeighbor = tilemap_get(tilemap, xx - 1, yy);
				var rightNeighbor = tilemap_get(tilemap, xx + 1, yy);
				var topNeighbor = tilemap_get(tilemap, xx, yy - 1);
				var bottomNeighbor = tilemap_get(tilemap, xx, yy + 1);
				
				var neighborFlags = 0b0000;
				
				if (leftNeighbor > 0) neighborFlags |= DIR.Left;
				if (rightNeighbor > 0) neighborFlags |= DIR.Right;
				if (topNeighbor > 0) neighborFlags |= DIR.Up;
				if (bottomNeighbor > 0) neighborFlags |= DIR.Down;	
				
				oRoomManager.neighbors[xx, yy] = neighborFlags;
			}
		}
	}
	
	
	
	// Destroy all walls
	with (oWall) { instance_destroy(); }
	
	for (var xx = 0; xx < mapWidth; xx++)
	{
		for (var yy = 0; yy < mapHeight; yy++)
		{
			var tile = tilemap_get(tilemap, xx, yy);
			if (tile > 0 && !oRoomManager.visited[xx, yy]) // 0 is empty, -1 is an error.
			{
				oRoomManager.visited[xx, yy] = 1;
				
				var xMin = xx;
				var xMax = xx;
				var yMin = yy;
				var yMax = yy;
				
				var myNeighbors = oRoomManager.neighbors[xx, yy];
				
				if (myNeighbors & DIR.Left) // Do I have a left neighbor?
				{
					var result = walk_left(tilemap, myNeighbors, xx, yy);
					xMin = result;
				}
				
				if (myNeighbors & DIR.Right) // Do I have a right neighbor?
				{
					var result = walk_right(tilemap, myNeighbors, xx, yy, mapWidth);
					xMax = result;
				}
				
				if (myNeighbors & DIR.Up) // Do I have an up neighbor?
				{
					var result = walk_up(tilemap, myNeighbors, xx, yy);
					yMin = result;
				}
				
				// Do I have a down neighbor? 
				// Also, add a check for edge cases. Don't walk down if I DO NOT have a right neighbor
				if (myNeighbors & DIR.Down && !(myNeighbors & DIR.Right))
				{
					var result = walk_down(tilemap, myNeighbors, xx, yy, mapHeight);
					yMax = result;
				}
				
				if (xMin > -1 && yMin > -1 && xMax < mapWidth && yMax < mapHeight)
				{
					var newWall = instance_create_layer(xMin * gridSize, yMin * gridSize, "Collision", oWall);
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
				var yScale = floor((otherWall.bbox_bottom - bbox_bottom) / gridSize);
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
	var myNeighbors = oRoomManager.neighbors[xToCheck, yy];
	
	while (myNeighbors != 0 && tile > 0 && !oRoomManager.visited[xToCheck, yy] && xToCheck > -1)
	{
		if (myNeighbors & DIR.Right && (myNeighbors & DIR.Up == rightNeighbors & DIR.Up) && (myNeighbors & DIR.Down == rightNeighbors & DIR.Down))
		{
			oRoomManager.visited[xToCheck, yy] = 1; // We are only visited if we can be added to the current wall
			xToCheck -= 1;
			
			if (xToCheck < 0) break;
			
			rightNeighbors = myNeighbors;
			myNeighbors = oRoomManager.neighbors[xToCheck, yy];
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
	var myNeighbors = oRoomManager.neighbors[xToCheck, yy];
	
	while (myNeighbors != 0 && tile > 0 && !oRoomManager.visited[xToCheck, yy] && xToCheck < mapWidth)
	{
		if (myNeighbors & DIR.Left && (myNeighbors & DIR.Up == leftNeighbors & DIR.Up) && (myNeighbors & DIR.Down == leftNeighbors & DIR.Down))
		{
			oRoomManager.visited[xToCheck, yy] = 1; // We are only visited if we can be added to the current wall
			xToCheck += 1;
			
			if (xToCheck >= mapWidth) break;
			
			leftNeighbors = myNeighbors;
			myNeighbors = oRoomManager.neighbors[xToCheck, yy];
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
	var myNeighbors = oRoomManager.neighbors[xx, yToCheck];
	
	while (myNeighbors != 0 && tile > 0 && !oRoomManager.visited[xx, yToCheck] && yToCheck > -1)
	{
		if (myNeighbors & DIR.Down && (myNeighbors & DIR.Left == bottomNeighbors & DIR.Left) && (myNeighbors & DIR.Right == bottomNeighbors & DIR.Right))
		{
			oRoomManager.visited[xx, yToCheck] = 1; // We are only visited if we can be added to the current wall
			yToCheck -= 1;
			
			if (yToCheck < 0) break;
			
			bottomNeighbors = myNeighbors;
			myNeighbors = oRoomManager.neighbors[xx, yToCheck];
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
	var myNeighbors = oRoomManager.neighbors[xx, yToCheck];
	
	while (myNeighbors != 0 && tile > 0 && !oRoomManager.visited[xx, yToCheck] && yToCheck < mapHeight)
	{
		if (myNeighbors & DIR.Up && (myNeighbors & DIR.Left == topNeighbors & DIR.Left) && (myNeighbors & DIR.Right == topNeighbors & DIR.Right))
		{
			oRoomManager.visited[xx, yToCheck] = 1; // We are only visited if we can be added to the current wall
			yToCheck += 1;
			
			if (yToCheck >= mapHeight) break;
			
			topNeighbors = myNeighbors;
			myNeighbors = oRoomManager.neighbors[xx, yToCheck];
			tile = tilemap_get(tilemap, xx, yToCheck);
		}
		else
		{
			break;
		}
	}
	return yToCheck - 1;
}

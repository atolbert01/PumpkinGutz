visited[0, 0] = 0;
neighbors[0, 0] = 0;
tilemap = layer_tilemap_get_id("Tiles");
update_terrain_walls(tilemap);
function c_tile_damage()
{
    if (invul_timer > 0 || dmgTileId == -1) return;

    var tm = dmgTileId;
    var tw = tilemap_get_tile_width(tm);
    var th = tilemap_get_tile_height(tm);

    var cx0 = max(0, floor(bbox_left / tw));
    var cx1 = min(tilemap_get_width(tm) - 1,  floor(bbox_right / tw));
    var cy0 = max(0, floor(bbox_top / th));
    var cy1 = min(tilemap_get_height(tm) - 1, floor(bbox_bottom / th));

    for (var i = cx0; i <= cx1; i++)
    {
        for (var j = cy0; j <= cy1; j++)
        {
            var idx = tile_get_index(tilemap_get(tm, i, j));
            if (idx == 0) continue;

            var hb = c_tile_hitbox(idx);
            if (!is_array(hb)) continue;

            var l = i * tw + hb[0];
            var t = j * th + hb[1];
            var r = i * tw + hb[2];
            var b = j * th + hb[3];

            if (bbox_right > l && bbox_left < r && bbox_bottom > t && bbox_top < b)
            {
                hp -= hb[4];
                invul_timer = hitInvul;
                ySpeed = -6;               // rebote hacia arriba
                xSpeed = -facing * 3;      // empujón hacia atrás
                return;
            }
        }
    }
}
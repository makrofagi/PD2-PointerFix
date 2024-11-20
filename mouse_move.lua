function MousePointerManager:_mouse_move(o, x, y)
    local speed_modifier = PointerFix.Settings.csens_mult

    local current_x, current_y = o:world_position()

    local delta_x = (x - current_x) * speed_modifier
    local delta_y = (y - current_y) * speed_modifier

    o:move(delta_x, delta_y)

    self._ws:feed_mouse_position(o:world_position())

    if self._mouse_callbacks[#self._mouse_callbacks] and self._mouse_callbacks[#self._mouse_callbacks].mouse_move then
        local new_x, new_y = o:world_position()
        self._mouse_callbacks[#self._mouse_callbacks].mouse_move(o, new_x, new_y, self._ws)
    end
end
extends Spatial

var _tween = null

var _degrees = {
	Vector3(-1, 0, 0): 270,
	Vector3(1, 0, 0): 90,
	Vector3(0, 0, -1): 180,
	Vector3(0, 0, 1): 0,
}

func move_towards(direction):
	if _tween != null and _tween.is_running():
		return false
	if _is_group_member_at("walls", translation + direction):
		return false
	var y_translation = Vector3(0, 0, 0)
	if _is_group_member_at("siege_towers", translation - Vector3(0, 1, 0)):
		var siege_tower = _get_group_member_at("siege_towers", translation - Vector3(0, 1, 0))
		if (
			_degrees[direction] != siege_tower.rotation_degrees.y and 
			_degrees[-direction] != siege_tower.rotation_degrees.y
		):
			return false
		if _degrees[-direction] == siege_tower.rotation_degrees.y:
			y_translation.y -= 1
	elif translation.y == 0.5:
		var stairs = _get_group_member_at("stairs", translation - Vector3(0, 0.5, 0))
		if stairs:
			if _degrees[direction] == stairs.rotation_degrees.y: 
				y_translation.y -= 0.5
			elif _degrees[-direction] == stairs.rotation_degrees.y:
				y_translation.y += 0.5
			else:
				return false
	elif translation.y == 1:
		if (
			not _is_group_member_at("walls", translation + direction - Vector3(0, 1, 0)) and 
			not _is_group_member_at("doors", translation + direction - Vector3(0, 1, 0)) and 
			not _is_group_member_at("siege_towers", translation + direction - Vector3(0, 1, 0)) and
			not _is_group_member_at("stairs", translation + direction - Vector3(0, 1, 0))
		):
			return false
		var siege_tower = _get_group_member_at("siege_towers", translation + direction - Vector3(0, 1, 0))
		if (
			siege_tower and
			_degrees[direction] != siege_tower.rotation_degrees.y and 
			_degrees[-direction] != siege_tower.rotation_degrees.y
		):
			return false
		var stairs = _get_group_member_at("stairs", translation + direction - Vector3(0, 1, 0))
		if stairs:
			if (
				_degrees[direction] != stairs.rotation_degrees.y and 
				_degrees[-direction] != stairs.rotation_degrees.y
			):
				return false
			y_translation.y -= 0.5
	if _is_group_member_at("doors", translation + direction):
		if not _is_group_member_at("rams", translation):
			return false
		_get_group_member_at("doors", translation + direction).queue_free()
	if _is_group_member_at("rams", translation + direction):
		var ram = _get_group_member_at("rams", translation + direction)
		var moved = ram.move_towards(direction)
		if not moved:
			return false
	if _is_group_member_at("siege_towers", translation + direction):
		if _is_group_member_at("rams", translation):
			return false
		var siege_tower = _get_group_member_at("siege_towers", translation + direction)
		var moved = siege_tower.move_towards(direction)
		if not moved:
			if (
				not _is_group_member_at("walls", translation + 2 * direction) or
				(_degrees[direction] != siege_tower.rotation_degrees.y and 
				_degrees[-direction] != siege_tower.rotation_degrees.y)
			):
				return false
			y_translation.y += 1
	if _is_group_member_at("stairs", translation + direction):
		var stairs = _get_group_member_at("stairs", translation + direction)
		if stairs:
			if _degrees[-direction] == stairs.rotation_degrees.y:
				y_translation.y += 0.5
			else:
				return false
	if has_node("Spatial/character-male-b/AnimationPlayer"):
		$"Spatial/character-male-b/AnimationPlayer".play("sprint")
	rotation_degrees.y = _degrees[direction]
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "translation", direction + y_translation, 0.25).as_relative()

func _get_group_member_at(group, translation):
	for ram in get_tree().get_nodes_in_group(group):
		if ram.translation == translation:
			return ram
	return null

func _is_group_member_at(group, translation):
	return _get_group_member_at(group, translation) != null

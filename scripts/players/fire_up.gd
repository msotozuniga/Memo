extends RigidBody2D





func _on_pick_area_body_entered(body):
	body.has_fire = true
	print("animation_disappear")
	queue_free()

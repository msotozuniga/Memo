extends RigidBody2D





func _on_pick_area_body_entered(body):
	body.has_electro= true
	body.magics_collected += 1
	body.magics.append(preload("res://scenes/p_related/elec_projectile.tscn"))
	print("animation_disappear")
	queue_free()

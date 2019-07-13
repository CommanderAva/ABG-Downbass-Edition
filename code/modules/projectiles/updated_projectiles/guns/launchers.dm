/obj/item/weapon/gun/launcher
	name = "launcher"
	desc = "A device that launches things."
	w_class = 4

	var/release_force = 0
	var/throw_distance = 10

/obj/item/weapon/gun/launcher/proc/update_release_force(obj/item/projectile)
	return 0

/*obj/item/weapon/gun/launcher/process_projectile(obj/item/projectile, mob/user, atom/target, var/target_zone, var/params=null, var/pointblank=0, var/reflex=0)
	update_release_force(projectile)
	projectile.loc = get_turf(user)
	projectile.throw_at(target, throw_distance, release_force, user)
	play_fire_sound(user,projectile)
	to_world("Proj/launcher process_projectile")
	return 1*/
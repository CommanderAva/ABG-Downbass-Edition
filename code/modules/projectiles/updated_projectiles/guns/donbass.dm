///////////////////////////// WEAPONS ///////////////////////////////////

////////////////////////////RIFLES - AK/////////////////////////////////

/obj/item/weapon/gun/rifle/ak74
	name = "Ak-74"
	desc = "The standart AK-74 assault rifle used in the post-soviet countries as a main small arms weapon. Uses 5.45x39mm rounds"
	icon_state = "ak74"
	type_of_casings = "bullet"
	item_state = "ak74"
	fire_sound = 'sound/weapons/gun_ak47.ogg'
	current_mag = /obj/item/ammo_magazine/ak74
	attachable_allowed = list(
						/obj/item/attachable/verticalgrip/ak74,
						/obj/item/attachable/stock/ak74,
						/obj/item/attachable/attached_gun/gp25
	)
	flags_gun_features = GUN_CAN_POINTBLANK
	starting_attachment_types = list(/obj/item/attachable/stock/ak74)
	pikantini = 0

/obj/item/weapon/gun/rifle/ak74/New()
	..()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 0, "under_y" = 16, "stock_x" = 0, "stock_y" = 0)
	if(prob(40))
		pikantini = 1
		desc = "The standart AK-74 assault rifle used in the post-soviet countries as a main small arms weapon. Uses 5.45x39mm rounds. This one has a custom-attached pikantini rail"


/obj/item/weapon/gun/rifle/ak74/set_gun_config_values()
	fire_delay = config.mhigh_fire_delay
	burst_amount = config.high_burst_value
	burst_delay = config.mlow_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult - config.low_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.high_hit_accuracy_mult
	scatter = config.med_scatter_value
	scatter_unwielded = config.max_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil_unwielded = config.high_recoil_value


//variant without ugl attachment
/obj/item/weapon/gun/rifle/ak74/stripped
	starting_attachment_types = list(/obj/item/attachable/stock/ak74)

/obj/item/weapon/gun/rifle/ak74/pikantini
	starting_attachment_types = list(/obj/item/attachable/stock/ak74)
	pikantini = 1
	desc = "The standart AK-74 assault rifle used in the post-soviet countries as a main small arms weapon. Uses 5.45x39mm rounds. This one has a custom-attached pikantini rail"

/obj/item/weapon/gun/rifle/ak74/romanian
	starting_attachment_types = list(/obj/item/attachable/verticalgrip/ak74, /obj/item/attachable/stock/ak74)

/obj/item/weapon/gun/rifle/ak74/gp
	starting_attachment_types = list(/obj/item/attachable/attached_gun/gp25, /obj/item/attachable/stock/ak74)

obj/item/weapon/gun/rifle/ak74/verb/ironsights()
	set name = "Use Iron Sights"
	set category = "Object"
	set src in usr
	set popup_menu = 0

	src.toggle_scope(usr, 1.2)


//////////////////////////// ATTACHMENTS //////////////////////////////

/obj/item/attachable/verticalgrip/ak74
	name = "wooden vertical grip"
	desc = "A wooden foregrip for AK-74. Probably stripped from a romaniam-manufactured Ak. Provides better accuracy, less recoil, and less scatter, especially during burst fire. \nHowever, it also increases weapon size and you kinda hate looking at this."
	wield_delay_mod = WIELD_DELAY_FAST
	size_mod = 1
	slot = "under"
	pixel_shift_x = 0
	icon = 'icons/Donbass/gun_attachables.dmi'
	icon_state = "ak74grip"
	item_state = "ak74grip"
	attach_icon = "ak74grip_a"
	flags_attach_features = NOFLAGS

/obj/item/attachable/verticalgrip/ak74/New()
	..()
	accuracy_mod = config.min_hit_accuracy_mult
	recoil_mod = -config.min_recoil_value
	scatter_mod = -config.min_scatter_value
	burst_scatter_mod = -2
	movement_acc_penalty_mod = 1
	accuracy_unwielded_mod = -config.min_hit_accuracy_mult
	scatter_unwielded_mod = config.min_scatter_value

/obj/item/attachable/attached_gun/gp25
	name = "GP-25 'Koster' underslung grenade launcher"
	desc = "A weapon-mounted, reloadable, one-shot grenade launcher for AK series assault rifles."
	icon_state = "ak74gp"
	attach_icon = "ak74gp_a"
	icon = 'icons/Donbass/gun_attachables.dmi'
	w_class = 4
	current_rounds = 0
	max_rounds = 1
	max_range = 20
	pixel_shift_x = 0
	pixel_shift_y = 0
	slot = "under"
	fire_sound = 'sound/weapons/gun_m92_attachable.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON
	var/list/loaded_grenades //list of grenade types loaded in the UGL

/obj/item/attachable/attached_gun/gp25/New()
	..()
	attachment_firing_delay = config.max_fire_delay * 3
	loaded_grenades = list()

/obj/item/attachable/attached_gun/gp25/examine(mob/user)
	..()
	if(current_rounds)
		to_chat(user, "It is loaded.")
	else
		to_chat(user, "It's empty.")

/obj/item/attachable/attached_gun/gp25/reload_attachment(obj/item/explosive/grenade/vog/G, mob/user)
	if(!istype(G))
		to_chat(user, "<span class='warning'>[src] doesn't accept that type of grenade.</span>")
		return
	if(!G.active) //can't load live grenades
		if(!G.underslug_launchable)
			to_chat(user, "<span class='warning'>[src] doesn't accept that type of grenade.</span>")
			return
		if(current_rounds >= max_rounds)
			to_chat(user, "<span class='warning'>[src] is full.</span>")
		else
			playsound(user, 'sound/weapons/gun_shotgun_shell_insert.ogg', 25, 1)
			current_rounds++
			loaded_grenades += G.type
			to_chat(user, "<span class='notice'>You load [G] in [src].</span>")
			user.temp_drop_inv_item(G)
			cdel(G)

/obj/item/attachable/attached_gun/gp25/fire_attachment(atom/target,obj/item/weapon/gun/gun,mob/living/user)
	set waitfor = 0
	var/nade_type = loaded_grenades[1]
	var/obj/item/explosive/grenade/frag/G = new nade_type (get_turf(gun))
	playsound(user.loc, fire_sound, 50, 1)
	message_admins("[key_name_admin(user)] fired an underslung grenade launcher (<A HREF='?_src_=holder;adminplayerobservejump=\ref[user]'>JMP</A>)")
	log_game("[key_name_admin(user)] used an underslung grenade launcher.")
	G.icon_state = "[G.icon_state]-projectile"
	G.loc = get_turf(user)
	G.throw_at(target, max_range, user)
	G.activate()
	current_rounds--

/obj/item/attachable/stock/ak74
	name = "wooden stock"
	desc = "A standard heavy wooden stock for Ak74."
	flags_attach_features = NOFLAGS
	icon = 'icons/Donbass/gun_attachables.dmi'
	icon_state = "ak74stock"
	attach_icon = "ak74stock_a"
	pixel_shift_x = 0
	pixel_shift_y = 0

/obj/item/attachable/stock/ak74/New()
	..()
	accuracy_mod = config.min_hit_accuracy_mult
	recoil_mod = -config.min_recoil_value
	scatter_mod = -config.min_scatter_value
	delay_mod = config.med_fire_delay
	movement_acc_penalty_mod = -1
	accuracy_unwielded_mod = config.min_hit_accuracy_mult
	recoil_unwielded_mod = -config.min_recoil_value
	scatter_unwielded_mod = -config.min_scatter_value

//////////////////////// GRENADES /////////////////////////////

/obj/item/explosive/grenade/vog
	name = "40x103mm 'VOG-25' grenade shell"
	desc = "Cannot be thrown as the usual grenade, by the way."
	icon_state = "40x103mmshell"
	//arm_sound = 'sound/weapons/gunshot/grenadelaunch.ogg'
	throw_speed = 1
	throw_range = 15
	underslug_launchable = TRUE
	dangerous = 1
	det_time = 5
	w_class = 1

/obj/item/explosive/grenade/vog/attack_self(mob/user)
	return

/obj/item/explosive/grenade/vog/prime()
	spawn(0)
		explosion(loc, -1, -1, 3)
		cdel(src)
	return

/obj/item/explosive/grenade/vog/vdg40
	name = "GRD-40 smoke grenade shell"
	desc = "Cannot be thrown as the usual grenade, by the way. Used to lay down a smoke cover"
	icon_state = "grd40"
	//arm_sound = 'sound/weapons/gunshot/grenadelaunch.ogg'
	throw_speed = 1
	throw_range = 15
	underslug_launchable = TRUE
	dangerous = 0
	det_time = 5
	var/datum/effect_system/smoke_spread/bad/smoke
	w_class = 1

/obj/item/explosive/grenade/vog/vdg40/attack_self(mob/user)
	return

/obj/item/explosive/grenade/vog/vdg40/New()
	..()
	smoke = new /datum/effect_system/smoke_spread/bad
	smoke.attach(src)

/obj/item/explosive/grenade/vog/vdg40/prime()
	playsound(src.loc, 'sound/effects/smoke.ogg', 25, 1, 4)
	smoke.set_up(3, 0, usr.loc, null, 6)
	smoke.start()
	cdel(src)

/obj/item/explosive/grenade/frag/rgd5
	name = "RGD-5 grenade"
	desc = "RGD-5 soviet offensive anti-personnel fragmentation grenade. You have 3-4 seconds to throw that hot potato elsewhere."
	icon_state = "rgd5grenade"
	item_state = "rgd5grenade"
	dangerous = 1
	w_class = 2
	underslug_launchable = FALSE
	New()
		det_time = rand(30,40)//Adds some risk to using this thing. Real fuse has this fluctuations in time
		..()

/obj/item/explosive/grenade/frag/rgd5/prime()
	spawn(0)
		explosion(loc, -1, -1, 4)
		cdel(src)
	return

/obj/item/explosive/grenade/frag/rgd5/flamer_fire_act()
	var/turf/T = loc
	cdel(src)
	explosion(T, -1, -1, 4)

/obj/item/explosive/grenade/frag/f1
	name = "F1 grenade"
	desc = "F1 soviet defensive anti-personnel fragmentation grenade. You have 3-4 seconds to throw that hot potato elsewhere. Be careful with it as it has a big area of explosion"
	icon_state = "f1grenade"
	item_state = "f1grenade"
	dangerous = 1
	w_class = 2
	underslug_launchable = FALSE
	New()
		det_time = rand(30,40)//Adds some risk to using this thing. Real fuse has this fluctuations in time
		..()

/obj/item/explosive/grenade/frag/f1/prime()
	spawn(0)
		explosion(loc, -1, -1, 6)
		cdel(src)
	return

/obj/item/explosive/grenade/frag/f1/flamer_fire_act()
	var/turf/T = loc
	cdel(src)
	explosion(T, -1, -1, 6)


/obj/item/explosive/grenade/smokebomb/rgd2
	name = "RGD-2X smoke grenade"
	desc = "Small RGD-2X soviet smoke grenade. Pull the braids on both ends of the grenade and it should ignite itself. Probably will start smoking in two seconds."
	icon_state = "rgd2"
	det_time = 25
	item_state = "rgd2"
	underslug_launchable = FALSE

	New()
		..()
		smoke = new /datum/effect_system/smoke_spread/bad
		smoke.attach(src)

	prime()
		playsound(src.loc, 'sound/effects/smoke.ogg', 25, 1, 4)
		smoke.set_up(3, 0, usr.loc, null, 6)
		smoke.start()
		cdel(src)
/////////////////// CLOTHING //////////////////////

/obj/item/clothing/head/helmet/h6b71
	name = "6B7-1 ballistic helmet"
	desc = "A standard 6B7-1 Helmet. Used in moderate amounts by both VSU and Novorussian forces."
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "6b71"
	sprite_sheet_id = 1
	armor = list(melee = 65, bullet = 35, laser = 0, energy = 35, bomb = 30, bio = 0, rad = 0)
	health = 5
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS


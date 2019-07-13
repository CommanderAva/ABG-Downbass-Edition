/obj/item/storage/webbing
	name = "webbing vest"
	desc = "For wearing as a vest and accessing loadout without taking off the backpack"
	icon_state = "webbing"
	w_class = 2
	flags_equip_slot = SLOT_WEBBING_VEST	//duh, no expl needed
	max_w_class = 2
	storage_slots = 4
	max_storage_space = null
	var/molle = 0
	var/molle_pouches = list()
	icon = 'icons/obj/webbing.dmi'
/*
/obj/item/storage/webbing/attack_hand(mob/user)
	if(!worn_accessible && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.back == src)
/*			if(user.drop_inv_item_on_ground(src))
				pickup(user)
				add_fingerprint(user)
				if(!user.put_in_active_hand(src))
					dropped(user)
*/
			to_chat(H, "<span class='notice'>You can't look in [src] while it's on your back.</span>")
			return
	..()
*/
/obj/item/storage/pouch/general/molle_small
	name = "Small MOLLE pouch"
	desc = "A small pouch for storing items. It's designed to be strapped on a clothing with a MOLLE system"
	w_class = 1
	storage_slots = 1
	icon_state = "pouch"
	icon = 'icons/obj/webbing.dmi'

/obj/item/storage/pouch/general/molle_medium
	name = "Small MOLLE pouch"
	desc = "A medium pouch for storing items. It's designed to be strapped on a clothing with a MOLLE system"
	w_class = 2
	icon_state = "pouch"
	storage_slots = 2
	icon = 'icons/obj/webbing.dmi'

/obj/item/storage/pouch/general/molle_magsmall
	name = "Magazine Small MOLLE pouch"
	desc = "A small pouch for storing magazines. It's designed to be strapped on a clothing with a MOLLE system"
	w_class = 1
	icon_state = "pouch"
	icon = 'icons/obj/webbing.dmi'
	storage_slots = 2
	can_hold = list(/obj/item/ammo_magazine/ak74
	)

/obj/item/storage/pouch/general/molle_magmedium
	name = "Magazine Medium MOLLE pouch"
	desc = "A medium pouch for storing magazines. It's designed to be strapped on a clothing with a MOLLE system"
	w_class = 2
	icon_state = "pouch"
	icon = 'icons/obj/webbing.dmi'
	storage_slots = 3
	can_hold = list(/obj/item/ammo_magazine/ak74
	)

/obj/item/storage/pouch/general/molle_grenade
	name = "Grenade MOLLE pouch"
	desc = "A small pouch for storing one grenade. It's designed to be strapped on a clothing with a MOLLE system"
	w_class = 1
	max_w_class = 2
	icon_state = "pouch"
	storage_slots = 1
	icon = 'icons/obj/webbing.dmi'

	can_hold = list(/obj/item/explosive/grenade/frag/f1,
					/obj/item/explosive/grenade/frag/rgd5,
					/obj/item/explosive/grenade/smokebomb/rgd2
	)

/obj/item/storage/pouch/general/molle_radio
	name = "Radio MOLLE pouch"
	desc = "A small pouch for storing a handheld radio. It's designed to be strapped on a clothing with a MOLLE system"
	w_class = 1
	icon_state = "pouch"
	storage_slots = 1
	icon = 'icons/obj/webbing.dmi'

/obj/item/storage/pouch/general/molle_vogsmall
	name = "Vog-25 Small MOLLE pouch"
	desc = "A small pouch for storing three Vog-25 grenades. It's designed to be strapped on a clothing with a MOLLE system"
	w_class = 2
	max_w_class = 1
	icon_state = "pouch"
	icon = 'icons/obj/webbing.dmi'
	storage_slots = 5
	can_hold = list(/obj/item/explosive/grenade/vog,
					/obj/item/explosive/grenade/vog/vdg40
	)

/obj/item/storage/pouch/general/molle_vogmedium //don't spawn this one, its OP
	name = "Vog-25 Small MOLLE pouch"
	desc = "A medium pouch for storing six Vog-25 grenades. It's designed to be strapped on a clothing with a MOLLE system"
	w_class = 3
	max_w_class = 1
	icon_state = "pouch"
	icon = 'icons/obj/webbing.dmi'
	storage_slots = 10
	can_hold = list(/obj/item/explosive/grenade/vog,
					/obj/item/explosive/grenade/vog/vdg40
	)


/obj/item/storage/webbing/mob_can_equip(M as mob, slot)
	if (!..())
		return 0

	if (!uniform_restricted)
		return 1

	if (!ishuman(M))
		return 0

	var/mob/living/carbon/human/H = M
	var/list/equipment = list(H.wear_suit, H.w_uniform, H.shoes, H.belt, H.gloves, H.glasses, H.head, H.wear_ear, H.wear_id, H.r_store, H.l_store, H.s_store, H.w_back_gun, H.w_webbing_vest)

	for (var/type in uniform_restricted)
		if (!(locate(type) in equipment))
			to_chat(H, "<span class='warning'>You must be wearing [initial(type:name)] to equip [name]!")
			return 0
	return 1

/obj/item/storage/webbing/equipped(mob/user, slot)
	if(slot == WEAR_WEBBING_VEST)
		mouse_opacity = 2 //so it's easier to click when properly equipped.
		if(use_sound)
			playsound(loc, use_sound, 15, 1, 6)
	..()

/obj/item/storage/webbing/dropped(mob/user)
	mouse_opacity = initial(mouse_opacity)
	..()


/obj/item/storage/webbing/molle1
	name = "MOLLE webbing vest"
	desc = "For wearing as a vest and accessing loadout without taking off the backpack. Has MOLLE loadout system"
	icon_state = "webbing_molle"
	w_class = 2
	flags_equip_slot = SLOT_WEBBING_VEST	//duh, no expl needed
	max_w_class = 2
	storage_slots = 6
	max_storage_space = null
	can_hold = list(
					/obj/item/storage/pouch/general/molle_small,
					/obj/item/storage/pouch/general/molle_medium,
					/obj/item/storage/pouch/general/molle_grenade,
					/obj/item/storage/pouch/general/molle_magsmall,
					/obj/item/storage/pouch/general/molle_magmedium,
					/obj/item/storage/pouch/general/molle_radio,
					/obj/item/storage/pouch/general/molle_vogsmall,
					/obj/item/storage/pouch/general/molle_vogmedium
					)
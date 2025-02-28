///var/atom/movable/lobby_image = new /atom/movable{icon = 'icons/misc/title.dmi'; icon_state = lobby_image_state; screen_loc = "1,1"; name = "Polaris"}

var/obj/effect/lobby_image = new /obj/effect/lobby_image

/obj/effect/lobby_image
	name = "CHOMPStation"
	desc = "How are you reading this?"
	screen_loc = "1,1"
	icon = 'icons/misc/loading.dmi' //VOREStation Add - Loading Screen
	icon_state = "loading(old)" //VOREStation Add - Loading Screen //CHOMPedit: let's keep the old one since the new one references vorestation

/obj/effect/lobby_image/Initialize()
	icon = using_map.lobby_icon
	var/known_icon_states = cached_icon_states(icon)
	for(var/lobby_screen in using_map.lobby_screens)
		if(!(lobby_screen in known_icon_states))
			error("Lobby screen '[lobby_screen]' did not exist in the icon set [icon].")
			using_map.lobby_screens -= lobby_screen

	if(using_map.lobby_screens.len)
		icon_state = pick(using_map.lobby_screens)
	else
		icon_state = known_icon_states[1]
	. = ..()

/mob/new_player
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled

/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	if(join_motd)
		to_chat(src, "<div class=\"motd\">[join_motd]</div>")

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	loc = null
	client.screen += lobby_image
	my_client = client
	sight |= SEE_TURFS
	player_list |= src

	created_for = ckey

	new_player_panel()
	spawn(40)
		if(client)
			handle_privacy_poll()
			client.playtitlemusic()

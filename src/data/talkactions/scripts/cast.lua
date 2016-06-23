function onSay(cid, words, param)
	local tmp = param:explode(" ")
	if not(tmp[1]) then
		return doPlayerSendCancel(cid, "Parameters needed")
	end
	
	if tmp[1] == "on" then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Cast has started.")
		doPlayerSetCastState(cid, true)
		doSavePlayer(cid)
	elseif getPlayerCast(cid).status == false then
		return doPlayerSendCancel(cid, "Your cast has to be running for this action.")
	elseif tmp[1] == "off" then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Cast has ended.")
		doPlayerSetCastState(cid, false)
		doSavePlayer(cid)
	elseif isInArray({"pass", "password", "p"}, tmp[1]) then
		if not(tmp[2]) then
			return doPlayerSendCancel(cid, "You need to set a password")
		end
		
		if tmp[2]:len() > 10 then
			return doPlayerSendCancel(cid, "The password is too long. (Max.: 10 letters)")
		end
		
		if tmp[2] == "off" then
			doPlayerSetCastPassword(cid, "")
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Cast password has been removed.")
		else
			doPlayerSetCastPassword(cid, tmp[2])
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Cast password was set to: " .. tmp[2])
		end
	elseif isInArray({"desc", "description", "d"}, tmp[1]) then
		local d = param:gsub(tmp[1]..(tmp[2] and " " or ""), "")
		
		if not(d) or d:len() == 0 then
			return doPlayerSendCancel(cid, "You need to specify a description.")
		end
		
		if d:len() > 50 then
			return doPlayerSendCancel(cid, "The description is too long. (Max.: 50 letters)")
		end
		
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Cast description was set to: ")
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, d)
		doPlayerSetCastDescription(cid, d)
	elseif tmp[1] == "ban" then
		if not(tmp[2]) then
			return doPlayerSendCancel(cid, "Specify a spectator that you want to ban.")
		end
		
		if doPlayerAddCastBan(cid, tmp[2]) then
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Spectator '" .. tmp[2] .. "' has been banned.")
		else
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Spectator '" .. tmp[2] .. "' could not be banned.")
		end
	elseif tmp[1] == "unban" then
		if not(tmp[2]) then
			return doPlayerSendCancel(cid, "Specify the person you want to unban.")
		end
		
		if doPlayerRemoveCastBan(cid, tmp[2]) then
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Spectator '" .. tmp[2] .. "' has been unbanned.")
		else
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Spectator '" .. tmp[2] .. "' could not be unbanned.")
		end
	elseif param == "bans" then
		local t = getCastBans(cid)
		local text = "Cast Bans:\n\n"
		for k, v in pairs(t) do
			text = text .. "*" .. v.name .. "\n"
		end 
		if text == "Cast Bans:\n\n" then
			text = text .. "No bans."
		end
		doShowTextDialog(cid, 5958, text)
	elseif tmp[1] == "mute" then
		if not(tmp[2]) then
			return doPlayerSendCancel(cid, "Specify a spectator that you want to mute.")
		end
		
		if doPlayerAddCastMute(cid, tmp[2]) then
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Spectator '" .. tmp[2] .. "' has been muted.")
		else
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Spectator '" .. tmp[2] .. "' could not be muted.")
		end
	elseif tmp[1] == "unmute" then
		if not(tmp[2]) then
			return doPlayerSendCancel(cid, "Specify the person you want to unmute.")
		end
		
		if doPlayerRemoveCastMute(cid, tmp[2]) then
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Spectator '" .. tmp[2] .. "' has been unmuted.")
		else
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Spectator '" .. tmp[2] .. "' could not be unmuted.")
		end
	elseif param == "mutes" then
		local t = getCastMutes(cid)
		local text = "Cast Mutes:\n\n"
		for k, v in pairs(t) do
			text = text .. "*" .. v.name .. "\n"
		end 
		if text == "Cast Bans:\n\n" then
			text = text .. "No mutes."
		end
		doShowTextDialog(cid, 5958, text)
	elseif param == "viewers" then
		local t = getCastViewers(cid)
		local text, count = "Cast Viewers:\n#Viewers: |COUNT|\n\n", 0
		for _,v in pairs(t) do
			count = count + 1
			text = text .. "*" .. v.name .."\n"
		end
		
		if text == "Cast Viewers:\n#Viewers: |COUNT|\n\n" then text = "Cast Viewers:\n\nNo viewers." end
		text = text:gsub("|COUNT|", count)
		doShowTextDialog(cid, 5958, text)
	elseif param == "status" then
		local t, c = getCastViewers(cid), getPlayerCast(cid)
		local count = 0
		for _,v in pairs(t) do count = count + 1 end
		
		doShowTextDialog(cid, 5958, "Cast Status:\n\n*Viewers:\n      " .. count .. "\n*Description:\n      "..(c.description == "" and "Not set" or c.description).."\n*Password:\n      " .. (c.password == "" and "Not set" or "Set - '"..c.password.."'"))
	elseif param == "update" then
		if getPlayerStorageValue(cid, 656544) > os.time() then
			return doPlayerSendCancel(cid, "You used this command lately. Wait: " .. (getPlayerStorageValue(cid, 656544)-os.time()) .. " sec.")
		end
		doSavePlayer(cid)
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "The cast settings have been updated.")
		doPlayerSetStorageValue(cid, 656544, os.time()+60)
	end
	return false
end
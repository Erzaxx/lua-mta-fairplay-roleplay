--[[
	The MIT License (MIT)

	Copyright (c) 2015 Socialz (+ soc-i-alz GitHub organization)

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]

local respawn = {
	x = 1179.41,
	y = -1323.2,
	z = 14.16,
	rotation = -90,
	interior = 0,
	dimension = 0
}

function respawnCharacter( player, causeOfRespawn )
	fadeCamera( player, false, 4.5 )
	
	if ( causeOfRespawn ) then
		--log it
	end
	
	setTimer( function( player )
		if ( isElement( player ) ) then
			spawnPlayer( player, respawn.x, respawn.y, respawn.z, respawn.rotation, getElementModel( player ), respawn.interior, respawn.dimension )
			setCameraTarget( player, player )
			setElementFrozen( player, false )
			fadeCamera( player, true, 2.25 )
		end
	end, 4500, 1, player )
end

function reviveCharacter( player )
	fadeCamera( player, false, 4.5 )

	setTimer( function( player )
		if ( isElement( player ) ) then
			local x, y, z = getElementPosition( player )
			
			spawnPlayer( player, x, y, z, getPedRotation( player ), getElementModel( player ), getElementInterior( player ), getElementDimension( player ) )
			setCameraTarget( player, player )
			setElementFrozen( player, false )
			fadeCamera( player, true, 2.25 )
		end
	end, 4500, 1, player )
end

addEventHandler( "onPlayerWasted", root,
	function( totalAmmo, killer, killerWeapon, bodypart, stealth )
		if ( exports.common:isOnDuty( source ) ) then
			reviveCharacter( source )
		else
			for _, player in ipairs( exports.common:getPriorityPlayers( ) ) do
				outputChatBox( exports.common:getPlayerName( source ) .. " died (" .. ( ( not killer or source == killer ) and "Suicide" or killerWeapon .. " by " .. exports.common:getPlayerName( killer ) ) .. ").", player, 230, 95, 95 )
			end
		end
	end
)

addEvent( "realism:respawn", true )
addEventHandler( "realism:respawn", root,
	function( details, option )
		if ( source ~= client ) or ( not details ) or ( not option ) then
			return
		end
		
		if ( option == 1 ) then
			respawnCharacter( client, details )
		elseif ( option == 2 ) then
			characterKill( exports.common:getCharacterID( client ), details )
		elseif ( option == 3 ) then
			exports.admin:createTicket( client, nil, details, 5 )
			exports.messages:createMessage( client, "Please wait for an administrator to respond to your ticket.", "wait-for-admin" )
			exports.security:modifyElementData( client, "player:waiting", details, true )
			outputChatBox( "You have opened a new ticket regarding your death. Please wait for an administrator.", client, 180, 230, 95 )
		end
	end
)

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		for _, player in ipairs( getElementsByType( "player" ) ) do
			if ( exports.common:isOnDuty( player ) ) and ( isPedDead( player ) ) then
				reviveCharacter( player )
			end
		end
	end
)

addEventHandler( "onResourceStop", root,
	function( resource )
		if ( getResourceName( resource ) == "admin" ) then
			for _, player in ipairs( getElementsByType( "player" ) ) do
				if ( getElementData( player, "player:waiting" ) ) then
					outputChatBox( "Because of technical reasons your ticket was closed. You can report again now. Your old message was outputted to the F8 console.", player, 230, 95, 95 )
					outputConsole( "Old admin assistance message:", player )
					outputConsole( getElementData( player, "player:waiting" ), player )
					removeElementData( player, "player:waiting" )
					triggerClientEvent( player, "realism:death_scene", player )
				end
			end
		end
	end
)
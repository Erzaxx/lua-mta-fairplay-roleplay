﻿--[[
	The MIT License (MIT)

	Copyright (c) 2014 Socialz (+ soc-i-alz GitHub organization)

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

local items = { }

local function getID( element )
	if ( getElementType( element ) == "player" ) then
		if ( exports.common:isPlayerPlaying( element ) ) then
			return exports.common:getCharacterID( element )
		end
	elseif ( getElementType( element ) == "vehicle" ) then
		return exports.common:getRealVehicleID( element )
	end

	return false
end

function getItems( element )
	return items[ element ] or { }
end

function load( element )
	local ownerID = getID( element )

	if ( ownerID ) then
		items[ element ] = { }
		
		local result = exports.database:query( "SELECT * FROM `inventory` WHERE `owner_id` = ?", ownerID )
		
		for _, item in ipairs( result ) do
			table.insert( items[ element ], { id = item.id, itemID = item.item_id, itemValue = item.item_value } )
		end
		
		if ( getElementType( element ) == "player" ) then
			loadWeapons( element )
			triggerClientEvent( element, "items:update", element, getItems( element ) )
		end
		
		return true
	end

	return false
end

function give( element, itemID, itemValue )
	local ownerID = getID( element )

	if ( ownerID ) then
		local id = exports.database:insert_id( "INSERT INTO `inventory` (`owner_id`, `item_id`, `item_value`) VALUES (?, ?, ?)", ownerID, itemID, itemValue )

		if ( id ) then
			table.insert( items[ element ], { id = id, itemID = itemID, itemValue = itemValue } )
			
			load( element )

			return true
		end
	end

	return false
end

function take( element, id )
	local ownerID = getID( element )

	if ( ownerID ) then
		local item, index = has( element, false, false, id )

		if ( item ) then
			if ( exports.database:execute( "DELETE FROM `inventory` WHERE `id` = ? AND `owner_id` = ?", id, ownerID ) ) then
				table.remove( items[ element ], index )
				
				load( element )
				
				return true
			end
		end
	end

	return false
end

function has( element, itemID, itemValue, id )
	for index, values in ipairs( getItems( element ) ) do
		if ( ( not id ) and ( values.itemID == itemID ) and ( ( not itemValue ) or ( tostring( values.itemValue ) == tostring( itemValue ) ) ) ) or ( ( id ) and ( values.id == id ) ) then
			return true, index, values
		end
	end

	return false
end

addEvent( "items:get", true )
addEventHandler( "items:get", root,
	function( )
		if ( source ~= client ) then
			return
		end

		load( client )

		triggerClientEvent( client, "items:update", client, getItems( client ) )
	end
)

addEventHandler( "onResourceStop", resourceRoot,
	function( )
		for _, player in ipairs( getElementsByType( "player" ) ) do
			takeAllWeapons( player )
		end
	end
)

addCommandHandler( "giveitem",
	function( player, cmd, targetPlayer, itemID, ... )
		if ( exports.common:isPlayerServerAdmin( player ) ) then
			local itemID = tonumber( itemID )
			
			if ( not targetPlayer ) or ( not itemID ) or ( ( itemID ) and ( itemID <= 0 ) ) then
				outputChatBox( "SYNTAX: /" .. cmd .. " [partial player name] [item id] <[value]>", player, 230, 180, 95 )
				return
			else
				if ( ... ) then
					value = table.concat( { ... }, " " )
				end
				
				local targetPlayer = exports.common:getPlayerFromPartialName( targetPlayer, player )
				
				if ( not targetPlayer ) then
					outputChatBox( "Could not find a player with that identifier.", player, 230, 95, 95 )
				else
					if ( getItemList( )[ itemID ] ) then
						if ( items[ targetPlayer ] ) then
							value = value or getItemValue( itemID )
							
							if ( give( targetPlayer, itemID, value ) ) then
								outputChatBox( "Gave " .. exports.common:getPlayerName( targetPlayer ) .. " item " .. getItemName( itemID ) .. " (" .. itemID .. ").", player, 95, 230, 95 )
								outputChatBox( "You were given a " .. getItemName( itemID ) .. " (" .. itemID .. ").", player, 95, 230, 95 )
							else
								outputChatBox( "Error occurred (0x0000FE).", player, 230, 95, 95 )
							end
						else
							outputChatBox( "That player doesn't have item data initialized yet.", player, 230, 95, 95 )
						end
					else
						outputChatBox( "Invalid item ID.", player, 230, 95, 95 )
					end
				end
			end
		end
	end
)

addCommandHandler( "takeitem",
	function( player, cmd, targetPlayer, itemID, value )
		if ( exports.common:isPlayerServerAdmin( player ) ) then
			local itemID = tonumber( itemID )
			
			if ( not targetPlayer ) or ( not itemID ) or ( ( itemID ) and ( itemID <= 0 ) ) or ( ( value ) and ( string.len( value ) < 2 ) ) then
				outputChatBox( "SYNTAX: /" .. cmd .. " [partial player name] [item id] <[value]>", player, 230, 180, 95 )
				return
			else
				local targetPlayer = exports.common:getPlayerFromPartialName( targetPlayer, player )

				if ( not targetPlayer ) then
					outputChatBox( "Could not find a player with that identifier.", player, 230, 95, 95 )
				else
					if ( getItemList( )[ itemID ] ) then
						if ( items[ targetPlayer ] ) then
							local item, index, values = has( targetPlayer, itemID, value )

							if ( item ) then
								if ( take( targetPlayer, values.id ) ) then
									local vehicle = getPedOccupiedVehicle( targetPlayer )
									
									if ( vehicle ) and ( getVehicleController( vehicle ) == targetPlayer ) and ( exports.vehicles:getVehicleRealID( vehicle ) == values.itemValue ) then
										exports.security:modifyElementData( vehicle, "vehicle:engine", false, true )
										setVehicleEngineState( vehicle, false )
									end
									
									outputChatBox( "Took " .. getItemName( itemID ) .. " from " .. exports.common:getPlayerName(targetPlayer) .. ".", player, 95, 230, 95 )
								else
									outputChatBox( "Error occurred (0x0000FF).", player, 230, 95, 95 )
								end
							else
								outputChatBox( "That player doesn't have an item.", player, 230, 95, 95 )
							end
						else
							outputChatBox( "That player doesn't have item data initialized yet.", player, 230, 95, 95 )
						end
					else
						outputChatBox( "Invalid item ID.", player, 230, 95, 95 )
					end
				end
			end
		end
	end
)
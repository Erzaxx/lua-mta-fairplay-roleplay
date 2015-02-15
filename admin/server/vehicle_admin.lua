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

addCommandHandler( { "createvehicle", "newvehicle", "createveh", "makeveh", "makevehicle", "makecar", "createcar" },
	function( player, cmd, modelID, ownerID, isBulletproof, modelsetID )
		if ( exports.common:isPlayerServerAdmin( player ) ) then
			modelID = tonumber( modelID )
			ownerID = tonumber( ownerID )
			modelsetID = tonumber( modelsetID )
			isBulletproof = isBulletproof == "1"

			if ( modelID ) and ( ownerID ) then
				if ( exports.common:isValidVehicleModelID( modelID ) ) then
					isFaction = ownerID < 0
					
					if ( not isFaction ) then
						local targetCharacter = exports.accounts:getCharacter( ownerID )
						
						if ( not targetCharacter ) then
							outputChatBox( "No such character found.", player, 230, 95, 95 )
							
							return
						end
					else
						local targetFaction = exports.factions:get( ownerID )
						
						if ( not targetFaction ) then
							outputChatBox( "No such faction found.", player, 230, 95, 95 )
							
							return
						else
							ownerID = exports.common:getFactionID( targetFaction )
						end
					end
					
					local x, y, z = exports.common:nextToPosition( player )
					local rotation = getPedRotation( player )
					local interior, dimension = getElementInterior( player ), getElementDimension( player )
					
					local vehicleID, vehicle = exports.vehicles:create( modelID, x, y, z, nil, nil, rotation, interior, dimension, nil, nil, ownerID, isFaction, nil, nil, isBulletproof )
					
					if ( vehicleID ) then
						outputChatBox( "You created a " .. getVehicleNameFromModel( modelID ) .. " with ID " .. vehicleID .. ".", player, 95, 230, 95 )
						
						if ( not vehicle ) then
							outputChatBox( "However, we were unable to spawn the vehicle, please try spawning it manually via /spawnvehicle.", player, 230, 95, 95 )
						end
					else
						outputChatBox( "Could not create a " .. getVehicleNameFromModel( modelID ) .. ". Please try again.", player, 230, 95, 95 )
					end
				else
					outputChatBox( "This vehicle ID is not valid.", player, 230, 95, 95 )
				end
			else
				outputChatBox( "SYNTAX: /" .. cmd .. " [model id] [owner id: negative=faction, positive=character] [bulletproof: 0/1]", player, 230, 180, 95 )
			end
		end
	end
)

addCommandHandler( { "deletevehicle", "removevehicle", "delvehicle", "delveh", "removeveh", "deleteveh" },
	function( player, cmd, vehicleID )
		if ( exports.common:isPlayerServerAdmin( player ) ) then
			local vehicleID = tonumber( vehicleID )
			
			if ( vehicleID ) then
				local vehicle = exports.vehicles:getVehicle( vehicleID )
				
				if ( vehicle ) then
					if ( exports.vehicles:delete( vehicle ) ) then
						outputChatBox( "You deleted a vehicle with ID " .. vehicleID .. ".", player, 95, 230, 95 )
					else
						outputChatBox( "Something went wrong when deleting the vehicle. Please retry.", player, 230, 95, 95 )
					end
				else
					outputChatBox( "Could not find a vehicle with that identifier.", player, 230, 95, 95 )
				end
			else
				outputChatBox( "SYNTAX: /" .. cmd .. " [vehicle id]", player, 230, 180, 95 )
			end
		end
	end
)
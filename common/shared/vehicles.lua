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

local vehicleIDs = {
	602, 545, 496, 517, 401, 410, 518, 600, 527, 436, 589, 580, 419, 439, 533, 549, 526, 491, 474, 445, 467, 604, 426, 507, 547, 585,
	405, 587, 409, 466, 550, 492, 566, 546, 540, 551, 421, 516, 529, 592, 553, 577, 488, 511, 497, 548, 563, 512, 476, 593, 447, 425, 519, 520, 460,
	417, 469, 487, 513, 581, 510, 509, 522, 481, 461, 462, 448, 521, 468, 463, 586, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 485, 552, 431, 
	438, 437, 574, 420, 525, 408, 416, 596, 433, 597, 427, 599, 490, 432, 528, 601, 407, 428, 544, 523, 470, 598, 499, 588, 609, 403, 498, 514, 524, 
	423, 532, 414, 578, 443, 486, 515, 406, 531, 573, 456, 455, 459, 543, 422, 583, 482, 478, 605, 554, 530, 418, 572, 582, 413, 440, 536, 575, 534, 
	567, 535, 576, 412, 402, 542, 603, 475, 449, 537, 538, 570, 441, 464, 501, 465, 564, 568, 557, 424, 471, 504, 495, 457, 539, 483, 508, 571, 500, 
	444, 556, 429, 411, 541, 559, 415, 561, 480, 560, 562, 506, 565, 451, 434, 558, 494, 555, 502, 477, 503, 579, 400, 404, 489, 505, 479, 442, 458, 
	606, 607, 610, 590, 569, 611, 584, 608, 435, 450, 591, 594
}

function getRealVehicleEngineState( vehicle )
	return getElementData( vehicle, "vehicle:engine" ) or false
end

function getRealVehicleID( vehicle )
	return ( isElement( vehicle ) and getElementData( vehicle, "vehicle:id" ) ) and tonumber( getElementData( vehicle, "vehicle:id" ) ) or false
end

function getValidVehicleModelIDs( )
	return vehicleIDs
end

local _getVehicleName = getVehicleName
function getVehicleName( vehicle, includeYear )
	if ( isElement( vehicle ) ) then
		local modelSetID = tonumber( getElementData( vehicle, "vehicle:model_set_id" ) )

		if ( modelSetID ) and ( modelSetID > 0 ) then
			local modelSet = exports.vehicles:getModelSet( modelSetID )

			if ( modelSet ) then
				return modelSet.make .. " " .. modelSet.model .. ( includeYear and " " .. modelSet.year or "" )
			end
		end

		return _getVehicleName( vehicle )
	end

	return false
end

function getVehicleOwner( vehicle, doNotAbsolutize )
	return ( isElement( vehicle ) and getElementData( vehicle, "vehicle:owner" ) ) and ( doNotAbsolutize and tonumber( getElementData( vehicle, "vehicle:owner" ) ) or math.abs( tonumber( getElementData( vehicle, "vehicle:owner" ) ) ) ) or false
end

function isFactionVehicle( vehicle )
	local ownerID = getVehicleOwner( vehicle, true )
	return ownerID and ownerID < 0 or false
end

function isValidVehicleModelID( vehicleID )
	for _, id in ipairs( vehicleIDs ) do
		if ( id == vehicleID ) then
			return true
		end
	end
	
	return false
end

function isVehicleBroken( vehicle )
	return getElementData( vehicle, "vehicle:broken" ) or false
end
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

local screenWidth, screenHeight = guiGetScreenSize( )
local accounts_login_view = {
	button = { },
	label = { },
	edit = { }
}

local minimumUsernameLength = 2
local maximumUsernameLength = 30

local minimumPasswordLength = 8
local maximumPasswordLength = 100

isBackgroundVisible = false

function showBackground( )
	if ( not isBackgroundVisible ) then
		return
	end
	
	dxDrawRectangle( 0, 0, screenWidth, screenHeight, tocolor( 0, 0, 0, 0.5 * 255 ), false )
	dxDrawRectangle( 0, 0, screenWidth, 75, tocolor( 0, 0, 0, 255 ), false )
	dxDrawRectangle( 0, screenHeight - 75, screenWidth, 75, tocolor( 0, 0, 0, 255 ), false )
end

function showLoginMenu( forceEnd )
	if ( isElement( accounts_login_view.window ) ) then
		destroyElement( accounts_login_view.window )
		
		--showCursor( false )
		--guiSetInputEnabled( false )
	end
	
	if ( forceEnd ) then
		return
	end
	
	if ( not isBackgroundVisible ) then
		isBackgroundVisible = true
		addEventHandler( "onClientRender", root, showBackground )
	end
	
	showCursor( true )
	guiSetInputEnabled( true )
	
	accounts_login_view.window = guiCreateWindow( ( screenWidth - 273 ) / 2, ( screenHeight - 310 ) / 2, 273, 310, "FairPlay Gaming", false )
	guiWindowSetSizable( accounts_login_view.window, false )
	guiSetAlpha( accounts_login_view.window, 0.8725 )

	accounts_login_view.label[ 1 ] = guiCreateLabel(18, 38, 238, 39, "Welcome to FairPlay Gaming. Please log in or register using the form below.", false, accounts_login_view.window )
	guiSetFont( accounts_login_view.label[ 1 ], "default-bold-small" )
	guiLabelSetHorizontalAlign( accounts_login_view.label[ 1 ], "left", true )
	
	accounts_login_view.label[ 2 ] = guiCreateLabel( 17, 87, 238, 14, "Username", false, accounts_login_view.window )
	guiSetFont( accounts_login_view.label[ 2 ], "default-bold-small" )
	
	accounts_login_view.label[ 3 ] = guiCreateLabel( 18, 150, 238, 14, "Password (min. " .. minimumPasswordLength .. ")", false, accounts_login_view.window )
	guiSetFont( accounts_login_view.label[ 3 ], "default-bold-small" )
	
	accounts_login_view.edit.username = guiCreateEdit( 17, 111, 239, 29, "", false, accounts_login_view.window )
	guiEditSetMaxLength( accounts_login_view.edit.username, maximumUsernameLength )
	
	accounts_login_view.edit.password = guiCreateEdit( 17, 174, 239, 29, "", false, accounts_login_view.window )
	guiSetEnabled( accounts_login_view.edit.password, false )
	guiEditSetMasked( accounts_login_view.edit.password, true )
	guiEditSetMaxLength( accounts_login_view.edit.password, maximumPasswordLength )
	
	accounts_login_view.button.login = guiCreateButton( 17, 221, 238, 31, "Log in", false, accounts_login_view.window )
	guiSetEnabled( accounts_login_view.button.login, false )
	
	accounts_login_view.button.register = guiCreateButton( 18, 262, 238, 31, "Register", false, accounts_login_view.window )
	guiSetEnabled( accounts_login_view.button.register, false )
	
	addEventHandler( "onClientGUIChanged", accounts_login_view.edit.username,
		function( )
			if ( guiGetText( accounts_login_view.edit.username ):len( ) >= minimumUsernameLength ) then
				guiSetEnabled( accounts_login_view.edit.password, true )
			else
				guiSetEnabled( accounts_login_view.edit.password, false )
			end
		end
	)
	
	addEventHandler( "onClientGUIChanged", accounts_login_view.edit.password,
		function( )
			if ( guiGetText( accounts_login_view.edit.password ):len( ) >= minimumPasswordLength ) then
				guiSetEnabled( accounts_login_view.button.login, true )
				guiSetEnabled( accounts_login_view.button.register, true )
			else
				guiSetEnabled( accounts_login_view.button.login, false )
				guiSetEnabled( accounts_login_view.button.register, false )
			end
		end
	)
	
	local function processLogin( )
		local username = guiGetText( accounts_login_view.edit.username )
		local password = guiGetText( accounts_login_view.edit.password )
		
		if ( username:len( ) >= minimumUsernameLength ) then
			if ( username:len( ) <= maximumUsernameLength ) then
				if ( not password:find( username ) ) then
					if ( password:len( ) >= minimumPasswordLength ) then
						if ( password:len( ) <= maximumPasswordLength ) then
							exports.messages:createMessage( "Logging in, please wait.", "login", nil, true )
							guiSetEnabled( accounts_login_view.window, false )
							
							triggerServerEvent( "accounts:login", localPlayer, username, password )
						end
					end
				end
			end
		end
		
		exports.messages:createMessage( "Username and/or password is incorrect.", "login" )
		guiSetEnabled( accounts_login_view.window, false )
	end
	addEventHandler( "onClientGUIClick", accounts_login_view.button.login, processLogin, false )
	
	local function triggerLogin( )
		if ( guiGetEnabled( accounts_login_view.button.login ) ) then
			processLogin( )
		end
	end
	addEventHandler( "onClientGUIAccepted", accounts_login_view.edit.username, triggerLogin )
	addEventHandler( "onClientGUIAccepted", accounts_login_view.edit.password, triggerLogin )
	
	function processRegister( )
		local username = guiGetText( accounts_login_view.edit.username )
		local password = guiGetText( accounts_login_view.edit.password )
		
		if ( username:len( ) >= minimumUsernameLength ) then
			if ( username:len( ) <= maximumUsernameLength ) then
				if ( not password:find( username ) ) then
					if ( password:len( ) >= minimumPasswordLength ) then
						if ( password:len( ) <= maximumPasswordLength ) then
							exports.messages:createMessage( "Registering account, please wait.", "login", nil, false )
							guiSetEnabled( accounts_login_view.window, false )
							
							triggerServerEvent( "accounts:register", localPlayer, username, password )
						else
							exports.messages:createMessage( "Password must be at most " .. maximumPasswordLength .. " characters long.", "login" )
							guiSetEnabled( accounts_login_view.window, false )
						end
					else
						exports.messages:createMessage( "Password must be at least " .. minimumPasswordLength .. " characters long.", "login" )
						guiSetEnabled( accounts_login_view.window, false )
					end
				else
					exports.messages:createMessage( "Your password must not contain your username.", "login" )
					guiSetEnabled( accounts_login_view.window, false )
				end
			else
				exports.messages:createMessage( "Username must be at most " .. maximumUsernameLength .. " characters long.", "login" )
				guiSetEnabled( accounts_login_view.window, false )
			end
		else
			exports.messages:createMessage( "Username must be at least " .. minimumUsernameLength .. " characters long.", "login" )
			guiSetEnabled( accounts_login_view.window, false )
		end
	end
	
	addEventHandler( "onClientGUIClick", accounts_login_view.button.register, processRegister, false )
end

addEventHandler( "onClientResourceStart", resourceRoot,
	function( )
		if ( not exports.common:isPlayerPlaying( localPlayer ) ) then
			for i = 1, getChatboxLayout( ).chat_lines do
				outputChatBox( "" )
			end
		end
		
		triggerServerEvent( "accounts:ready", localPlayer )
	end
)

addEvent( "accounts:showLogin", true )
addEventHandler( "accounts:showLogin", root,
	function( )
		showLoginMenu( )
	end
)

addEvent( "accounts:closeGUI", true )
addEventHandler( "accounts:closeGUI", root,
	function( )
		exports.messages:destroyMessage( "login" )
		showLoginMenu( true )
	end
)

function onLogin( )
	triggerEvent( "accounts:closeGUI", localPlayer )
	
	if ( isBackgroundVisible ) then
		isBackgroundVisible = false
		removeEventHandler( "onClientRender", root, showBackground )
	end
end
addEvent( "accounts:onLogin", true )
addEventHandler( "accounts:onLogin", root, onLogin )
addEvent( "accounts:onLogin.accounts", true )
addEventHandler( "accounts:onLogin.accounts", root, onLogin )

function onLogout( )
	exports.messages:destroyMessage( "login" )
	showLoginMenu( )
end
addEvent( "accounts:onLogout", true )
addEventHandler( "accounts:onLogout", root, onLogout )
addEvent( "accounts:onLogout.accounts", true )
addEventHandler( "accounts:onLogout.accounts", root, onLogout )

function onRegister( )
	showLoginMenu( )
	exports.messages:createMessage( "You have successfully registered an account! You may now log in with your account.", "login" )
	guiSetEnabled( accounts_login_view.window, false )
end
addEvent( "accounts:onRegister", true )
addEventHandler( "accounts:onRegister", root, onRegister )
addEvent( "accounts:onRegister.accounts", true )
addEventHandler( "accounts:onRegister.accounts", root, onRegister )

addEvent( "accounts:enableGUI", true )
addEventHandler( "accounts:enableGUI", root,
	function( )
		if ( isElement( accounts_login_view.window ) ) then
			guiSetEnabled( accounts_login_view.window, true )
		end
	end
)
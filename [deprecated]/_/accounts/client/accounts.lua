--[[
-- cool script
local loremIpsumWords = { 'lorem', 'ipsum', 'dolor', 'sit', 'amet', 'consectetur', 'adipiscing', 'elit', 'curabitur', 'vel', 'hendrerit', 'libero', 'eleifend', 'blandit', 'nunc', 'ornare', 'odio', 'ut', 'orci', 'gravida', 'imperdiet', 'nullam', 'purus', 'lacinia', 'a', 'pretium', 'quis', 'congue', 'praesent', 'sagittis', 'laoreet', 'auctor', 'mauris', 'non', 'velit', 'eros', 'dictum', 'proin', 'accumsan', 'sapien', 'nec', 'massa', 'volutpat', 'venenatis', 'sed', 'eu', 'molestie', 'lacus', 'quisque', 'porttitor', 'ligula', 'dui', 'mollis', 'tempus', 'at', 'magna', 'vestibulum', 'turpis', 'ac', 'diam', 'tincidunt', 'id', 'condimentum', 'enim', 'sodales', 'in', 'hac', 'habitasse', 'platea', 'dictumst', 'aenean', 'neque', 'fusce', 'augue', 'leo', 'eget', 'semper', 'mattis', 'tortor', 'scelerisque', 'nulla', 'interdum', 'tellus', 'malesuada', 'rhoncus', 'porta', 'sem', 'aliquet', 'et', 'nam', 'suspendisse', 'potenti', 'vivamus', 'luctus', 'fringilla', 'erat', 'donec', 'justo', 'vehicula', 'ultricies', 'varius', 'ante', 'primis', 'faucibus', 'ultrices', 'posuere', 'cubilia', 'curae', 'etiam', 'cursus', 'aliquam', 'quam', 'dapibus', 'nisl', 'feugiat', 'egestas', 'class', 'aptent', 'taciti', 'sociosqu', 'ad', 'litora', 'torquent', 'per', 'conubia', 'nostra', 'inceptos', 'himenaeos', 'phasellus', 'nibh', 'pulvinar', 'vitae', 'urna', 'iaculis', 'lobortis', 'nisi', 'viverra', 'arcu', 'morbi', 'pellentesque', 'metus', 'commodo', 'ut', 'facilisis', 'felis', 'tristique', 'ullamcorper', 'placerat', 'aenean', 'convallis', 'sollicitudin', 'integer', 'rutrum', 'duis', 'est', 'etiam', 'bibendum', 'donec', 'pharetra', 'vulputate', 'maecenas', 'mi', 'fermentum', 'consequat', 'suscipit', 'aliquam', 'habitant', 'senectus', 'netus', 'fames', 'quisque', 'euismod', 'curabitur', 'lectus', 'elementum', 'tempor', 'risus', 'cras' }
local tipBox = { string = "" }
local boxX, boxY = 50 * screenWidth / screenWidth, 50 * screenHeight / screenHeight
local boxPadding = 15
local lineHeight = dxGetFontHeight( 1, "default-bold" )
local minimumWidth = 350
local offsetWidth = 25

addEventHandler( "onClientRender", root,
	function( )
		tipBox.string = tipBox.string .. loremIpsumWords[ math.random( #loremIpsumWords ) ] .. " "
		
		if ( tipBox.string:len( ) > 2000 ) then
			tipBox.string = ""
		end
		
		local lines = 0
		local wordbreak = false
		local lineWidth = dxGetTextWidth( tipBox.string, 1, "default-bold" )
		
		while ( lineWidth + offsetWidth > minimumWidth ) do
			lineWidth = lineWidth - minimumWidth
			lines = lines + 1
			wordbreak = true
		end
		
		local boxWidth, boxHeight = minimumWidth + ( boxPadding * 3 ), ( lineHeight * ( lines + 1 ) ) + ( boxPadding * 2 )
		
		dxDrawRectangle( boxX, boxY, boxWidth, boxHeight, tocolor( 0, 0, 0, 185 ), true )
		
		local textX, textY = boxX + boxPadding, boxY + boxPadding
		local textWidth, textHeight = textX + minimumWidth + boxPadding, textY + lineHeight + boxPadding
		
		dxDrawText( tipBox.string, textX, textY, textWidth, textHeight, tocolor( 222, 222, 222, 255 ), 1, "default-bold", "left", "top", false, wordbreak, true )
	end
)
]]

accounts_login_view = {
	button = { },
	label = { },
	edit = { }
}

local screenWidth, screenHeight = guiGetScreenSize( )

local minimumUsernameLength = 2
local maximumUsernameLength = 30

local minimumPasswordLength = 8
local maximumPasswordLength = 100

function showLoginMenu( forceClose )
	if ( isElement( accounts_login_view.window ) ) then
		destroyElement( accounts_login_view.window )
		
		guiSetInputMode( "allow_binds" )
	end
	
	if ( forceClose ) then
		return
	end
	
	guiSetInputMode( "no_binds" )
	
	accounts_login_view.window = guiCreateWindow( ( screenWidth - 273 ) / 2, ( screenHeight - 310 ) / 2, 273, 310, "FairPlay Gaming", false )
	guiWindowSetSizable( accounts_login_view.window, false )
	guiSetAlpha( accounts_login_view.window, 0.8725 )

	accounts_login_view.label[ 1 ] = guiCreateLabel(18, 38, 238, 39, "Welcome to FairPlay Gaming. Please log in or register using the form below.", false, accounts_login_view.window )
	guiSetFont( accounts_login_view.label[ 1 ], "default-bold-small" )
	guiLabelSetHorizontalAlign( accounts_login_view.label[ 1 ], "left", true )
	
	accounts_login_view.label[ 2 ] = guiCreateLabel( 17, 87, 238, 14, "Username", false, accounts_login_view.window )
	guiSetFont( accounts_login_view.label[ 2 ], "default-bold-small" )
	
	accounts_login_view.label[ 3 ] = guiCreateLabel( 18, 150, 238, 14, "Password", false, accounts_login_view.window )
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
	
	function processLogin( )
		local username = guiGetText( accounts_login_view.edit.username )
		local password = guiGetText( accounts_login_view.edit.password )
		
		if ( username:len( ) >= minimumUsernameLength ) then
			if ( username:len( ) <= maximumUsernameLength ) then
				if ( not password:find( username ) ) then
					if ( password:len( ) >= minimumPasswordLength ) then
						if ( password:len( ) <= maximumPasswordLength ) then
							exports.messages:createMessage( "You have successfully logged in.", "login" )
						end
					end
				end
			end
		end
		
		exports.messages:createMessage( "Username and/or password is incorrect.", "login" )
		guiSetEnabled( accounts_login_view.window, false )
	end
	
	addEventHandler( "onClientGUIClick", accounts_login_view.button.login, processLogin, false )
	
	addEventHandler( "onClientKey", root,
		function( button, pressOrRelease )
			if ( button == "enter" ) and ( pressOrRelease ) and ( guiGetEnabled( accounts_login_view.button.login ) ) then
				processLogin( )
			end
		end
	)
	
	function processRegister( )
		local username = guiGetText( accounts_login_view.edit.username )
		local password = guiGetText( accounts_login_view.edit.password )
		
		if ( username:len( ) >= minimumUsernameLength ) then
			if ( username:len( ) <= maximumUsernameLength ) then
				if ( not password:find( username ) ) then
					if ( password:len( ) >= minimumPasswordLength ) then
						if ( password:len( ) <= maximumPasswordLength ) then
							exports.messages:createMessage( "Registering account, please wait.", "login", true )
							guiSetEnabled( accounts_login_view.window, false )
							
							local username, usernameKey = exports.security:encryptNetworkData( username )
							local password, passwordKey = exports.security:encryptNetworkData( password )
							
							triggerServerEvent( "accounts:register", localPlayer, exports.security:batchNetworkData( username ), exports.security:batchNetworkData( usernameKey ), exports.security:batchNetworkData( password ), exports.security:batchNetworkData( passwordKey ) )
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
		triggerServerEvent( "accounts:ready", localPlayer )
	end
)

addEvent( "accounts:showLogin", true )
addEventHandler( "accounts:showLogin", root,
	function( )
		showLoginMenu( )
	end
)

addEvent( "accounts:closeLogin", true )
addEventHandler( "accounts:closeLogin", root,
	function( )
		showLoginMenu( true )
		destroyMessage( "login" )
	end
)

addEvent( "accounts:onLogin", true )
addEventHandler( "accounts:onLogin", root,
	function( )
		triggerEvent( "accounts:closeLogin", localPlayer )
	end
)

addEvent( "accounts:onRegister", true )
addEventHandler( "accounts:onRegister", root,
	function( )
		showLoginMenu( )
		exports.messages:createMessage( "You have successfully registered an account! You may now log in with your account.", "login" )
		guiSetEnabled( accounts_login_view.window, false )
	end
)

addEvent( "accounts:onRegisterError", true )
addEventHandler( "accounts:onRegisterError", root,
	function( errorCode )
		if ( errorCode == -1 ) then
			exports.messages:createMessage( "Hmm... something went wrong. Please try again.", "login" )
		end
	end
)

addEvent( "accounts:enableGUI", true )
addEventHandler( "accounts:enableGUI", root,
	function( )
		if ( isElement( accounts_login_view.window ) ) then
			guiSetEnabled( accounts_login_view.window, true )
		end
	end
)
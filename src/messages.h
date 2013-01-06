// messages
#define SERVMESSGREETING	@"^3*** ^1This server is powered by ^7GSC ^1for Mac OSX! For more info visit - (^7http:^1/^1/damagestudios.net/GSC^1) ^3***"
#define CONFIG_HEADER1		@"// Created by Game Server Configulator (Call of Duty) | (c) 2003-2006 P-Edge media\n©2006-2007 Damage Studios - http://damagestudios.net/GSC/\n"
#define CONFIG_HEADER2          @"// For more info visit damagestudios.net/GSC/\n\n"

// OSX console messages
#define CONSOLEGREET            @"Game Server Configulator (Call of Duty) greets those who are playing Call of Duty!"
#define UNZIPNOTFOUND           @"/usr/bin/unzip is not found!"
#define UDP_NOREPLY             @"No UDP socket reply!"
#define UDP_NOCONNECT           @"No UDP connection!"

// about window
#define ABO_VERS		@"version "
#define COPYRIGHT_TEXT	@"\nCopyright 2003-2006 P-Edge media.\nCopyright 2006-2007 Damage Studios."
#define GSC_TITLE		@"Game Server Configulator\n(Call of Duty)"
#define ABO_EXPIRY_DATE         @"This version will expire %@."

// general window
#define GEN_LAUNCHING		@"Launching the server..."
#define GEN_RUNNING		@"The server is running."
#define GEN_NOTRUNNING		@"The server is not running."
#define GEN_READYLAUNCH		@"The server is ready for launch."
#define GEN_NOVALIDFOLDER	@"No valid game folder in preferences."
#define GEN_SERVMESSERR		@"Please enter messages here or disable server messages!"

// server management window
#define MAN_WAITMESSAGE		@"[Waiting to send first message.]"
#define MAN_WAITFORSTART	@"Please wait while the game starts..."
#define MAN_SELECTMAP		@"select a map..."
#define MAN_GOINGDOWN		@"The server is going down..."
#define MAN_MAPCHANGING		@"Changing the current map..."
#define MAN_PLAYERKICKED	@"Kicked: %@"
#define MAN_AUTOKICKED          @"AUTOKICKED: %@"
#define MAN_PLAYERBANNED        @"BANNED: %@"
#define MAN_MESSAGESENT		@"A message was sent by the admin."
#define MAN_KICKEDPL            @"------- KICKED!"
#define MAN_AUTOKICKEDPL        @"--- AUTOKICKED!"

// weapons window
#define WEA_SELECTONE           @"You must enable at least one weapon for the USA, the British, the Russian and the German. Players will not be able to join if you use these settings!"

// map window
#define MAP_INROTATION		@"Maps in rotation (%d)"
#define MAP_AVAILABLE		@"Available maps (%d)"

// prefs window
#define PRF_GAMEFOLDER1		@"Call of Duty game folder:"
#define PRF_GAMEFOLDER2		@"Call of Duty is not here:"

// alerts
#define ALE_OKBUTTON		@"OK"
#define	ALE_YESBUTTON		@"Yes"
#define	ALE_NOBUTTON		@"No"
#define ALE_QUITBUTTON		@"Quit"
#define ALE_CANCELBUTTON	@"Cancel"
#define ALE_ONLINEHELP		@"Online help"
#define ALE_UPDATENOW		@"Update now"

#define ALE_CANNOTLAUNCH1	@"Cannot launch the server"
#define ALE_CANNOTLAUNCH2	@"The game is already running. Please quit the game first."
#define ALE_CANNOTLAUNCH3	@"The server configuration file could not be saved."
#define ALE_CANNOTLAUNCH4	@"The game parameters file could not be saved."

#define ALE_EXPIRED1		@"This version has expired"
#define ALE_EXPIRED2		@"Please update to the latest version."
#define ALE_NOUPDATECHECK1	@"Could not check for updates"
#define ALE_NOUPDATECHECK2	@"The software server is not responding."
#define ALE_ILLCHECKLATER	@"I'll try later"
#define ALE_NOUPDATEFOUND1	@"No updates found"
#define ALE_NOUPDATEFOUND2	@"You already have the latest version (%@) of %@."
#define ALE_NEWVERSFOUND1	@"Software update found"
#define ALE_NEWVERSFOUND2	@"Would you like to download version %@?"

#define ALE_SAVECHANGES1	@"Server configuration changed"
#define ALE_SAVECHANGES2	@"Would you like to save your changes?"

#define ALE_CANNOTADDIP1        @"This IP address can not be banned"
#define ALE_CANNOTADDIP2        @"Please consult our online help."
#define ALE_CANNOTADDIP3        @"This IP address is already banned."

#define ALE_OLDFILEVERS1        @"This file was saved with an older GSC version"
#define ALE_OLDFILEVERS2        @"Missing settings will be set to current values."
#define ALE_CANNOTOPENFILE1     @"Cannot open this file"
#define ALE_CANNOTOPENFILE2     @"You cannot open a file while the server is running."
#define ALE_FILEDAMAGED1        @"This file is damaged"
#define ALE_FILEDAMAGED2        @"The file cannot be opened."

#define ALE_BANTHISPLAYER1      @"This IP (%@) will be banned"
#define ALE_BANTHISPLAYER2      @"The player is named: %@\nClick OK to ban this player immediately."

#define ALE_RCONPASS1           @"Your rcon password is too short"
#define ALE_RCONPASS2           @"Please us a password of more than 6 characters."

#define ALE_PLAYERSCNNCT1	@"There are players connected"
#define ALE_PLAYERSCNNCT2	@"Are you sure you want to kill the server?"

// in game messages
#define GAM_USERKICKED		@"say ---- The admin is kicking %@..."
#define GAM_AUTOKICKED          @"say ---- %@ is AUTO-KICKED because %@ is a banned IP address."
#define GAM_USERBANNED          @"say ---- %@ is BANNED from this server by the admin and will be kicked within 30 seconds."

#define GAM_LEADPLAYER1		@"say ---- %@ is in the lead with %d kills!!"
#define GAM_LEADPLAYER2		@"say ---- %@ are leading with %d kills."
#define GAM_LASTPLAYER1		@"say ---- %@ is last with %d kills..."
#define GAM_LASTPLAYER2		@"say ---- %@ are behind with %d kills..."
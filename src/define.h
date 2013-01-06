// prefs
#define preferences	[NSUserDefaults standardUserDefaults]
#define GSC_APPNAME	[[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleName"]
#define GSC_VERSION	[[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleVersion"]
#define VERSIONDICTKEY	@"gsccod"
#define EMPTYWNDWTITLE  @"GSC Call of Duty"
#define EXPIRYYEAR      2007
#define EXPIRYMONTH     03
#define EXPIRYDAY       31
#define EXPIRYDATETXT   @"on the 31st of March 2007"
#define MAXBANLISTSIZE  999
#define MAXAUTOGENPLYR  16

// files and directories
#define APPICONIMAGE    @"gsccod_app.icns"
#define CONFIGFILENAME 	@"/main/gsccod.cfg"
#define GAMEAPPNAME	@"/Call of Duty MP"
#define APPEXTENSION    @".app"
#define APPEXEPATH      @"/Contents/MacOSClassic"
#define PARAMFILENAME 	@"/MacCoDParms.txt"
#define GAMEPARAMETERS 	@"exec gsccod.cfg\nmap_rotate\n"
#define CONFIGFILENAME 	@"/main/gsccod.cfg"
#define OPENCOMMAND	@"/usr/bin/open"
#define DEF_GAMEAPPPATH	@"/Applications/Call of Duty"
#define BASEDIRNAME	@"/Main"
#define UNZIP_PATH	@"/usr/bin/unzip"
#define SAVE_EXTENSION  @".gsccod"
#define OPEN_EXTENSION  @"gsccod"
#define DEFAULT_FNAME   @"Untitled Server.gsccod"
#define AUTOSTARTNAME   @"autostart.gsccod"

// server runtime settings
#define LAUNCHWAITTIME	5
#define POLLWAITTIME	5
#define HEARTBEATTIME   28800
#define MAXSTARTPOLLS	10
#define RUNPOLLWAITTIME 30
#define STATUSLINELEN   79

// help URL's
#define HELP_SAVE_FILES_URL     @"http://damagestudios.net/GSC/"
#define HELP_QUIT_FIRST_URL     @"http://damagestudios.net/GSC/"
#define PAYPAL_DONATE_URL       @"http://damagestudios.net/software/"
#define ONLINE_MANUAL_URL       @"http://damagestudios.net/GSC/"
#define HELP_ADDIP_URL          @"http://damagestudios.net/GSC/"
#define HELP_CANTOPENFILE_URL   @"http://damagestudios.net/GSC/"
#define HELP_OLDFILEVER_URL     @"http://damagestudios.net/GSC/"
#define HELP_FILEDAMAGED_URL    @"http://damagestudios.net/GSC/"
#define HELP_RCONPASS_URL       @"http://damagestudios.net/GSC/"

// internal URL's
#define VERSION_CHECK_URL   @"http://damagestudios.net/applications/gsc/versioncheck.xml"
#define DOWNLOAD_NEW_URL    @"http://damagestudios.net/?dl=GSC_CoD.dmg"
#define GSC_SERV_SIGNON         @"http://damagestudios.net/GSC/"
#define GSC_SERV_SIGNOFF        @"http://damagestudios.net/GSC/"
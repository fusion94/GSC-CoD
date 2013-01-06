/* LaunchController */

#import <Cocoa/Cocoa.h>

@interface LaunchController : NSWindowController
{
    // *** needed for server config file
    // general tab items
    IBOutlet id serverName;
    IBOutlet id serverLocation;
    IBOutlet id serverMotd;
    IBOutlet id adminName;
    IBOutlet id adminEmail;
    IBOutlet id adminWebsite;
    
    // automation tab
    IBOutlet id servMessEnabled;
    IBOutlet id servMessTime;
    IBOutlet id servMessWait;
    IBOutlet id servMessText;
    IBOutlet id leadMessEnabled;
    
    IBOutlet id enableAutoKick;
    IBOutlet id bannedListString;

    // network tab items
    IBOutlet id setNetPort;
    IBOutlet id masterServer1;
    IBOutlet id masterServer2;
    IBOutlet id setMaxPing;
    IBOutlet id setMaxPlayers;
    IBOutlet id setMaxPrivPlayers;
    IBOutlet id setMinPing;
    IBOutlet id setRconPass;
    IBOutlet id setServerPass;
    IBOutlet id setPrivatePass;
    IBOutlet id allowVotes;
    IBOutlet id allowAnonymous;
    IBOutlet id allowDownload;
    IBOutlet id enableServerLog;
    IBOutlet id serverLogFile;
    IBOutlet id pureServer;
    IBOutlet id enablePunkBuster;
    IBOutlet id showInGSCServerList;

    // server tab items

    // game tab items
    IBOutlet id dm_scoreLimit;
    IBOutlet id dm_timeLimit;
    IBOutlet id tdm_scoreLimit;
    IBOutlet id tdm_timeLimit;
    IBOutlet id sd_scoreLimit;
    IBOutlet id sd_timeLimit;
    IBOutlet id sd_roundLength;
    IBOutlet id sd_roundLimit;
    IBOutlet id sd_gracePeriod;
    IBOutlet id bel_scoreLimit;
    IBOutlet id bel_timeLimit;
    IBOutlet id bel_alivePoint;
    IBOutlet id ret_scoreLimit;
    IBOutlet id ret_timeLimit;
    IBOutlet id ret_roundLength;
    IBOutlet id ret_roundLimit;
    IBOutlet id ret_gracePeriod;
    IBOutlet id hq_scoreLimit;
    IBOutlet id hq_Timelimit;
    
    IBOutlet id showAvatars;
    IBOutlet id showCarrier;
    
    IBOutlet id forceRespawn;
    IBOutlet id setForceBalance;
    IBOutlet id setAllowCheating;
    IBOutlet id enableKillCam;
    IBOutlet id friendlyFire;
    IBOutlet id setSpectateOwn;
    IBOutlet id allowFreeSpectate;
    
    // Weapons tab items
    IBOutlet id weaponBar;
    IBOutlet id weaponBren;
    IBOutlet id weaponEnfield;
    IBOutlet id weaponFg42;
    IBOutlet id weaponKar98k;
    IBOutlet id weaponKar98Sniper;
    IBOutlet id weaponM1Carbine;
    IBOutlet id weaponM1Garand;
    IBOutlet id weaponMp40;
    IBOutlet id weaponMp44;
    IBOutlet id weaponNagant;
    IBOutlet id weaponNagantSniper;
    IBOutlet id weaponPanzerfaust;
    IBOutlet id weaponPpsh;
    IBOutlet id weaponSpingfield;
    IBOutlet id weaponSten;
    IBOutlet id weaponThompson;

    // maps tab items
    IBOutlet id gameType;
    IBOutlet id mapRotation;
    IBOutlet id mapsList;

    // **** other
    IBOutlet id serverDedicated;
    IBOutlet id gameFolder;
    IBOutlet id launchButton;
    IBOutlet id spinner;
    IBOutlet id statusMessage;
    IBOutlet id launchMenuItem;
    IBOutlet id mainWindow;
    
    IBOutlet id fileNewMenuItem;
    IBOutlet id fileOpenMenuItem;
    IBOutlet id quitMenuItem;
    IBOutlet id prefsMenuItem;
    IBOutlet id checkUpdateMenuItem;

    // management window
    IBOutlet id managementWindow;
    IBOutlet id manServerName;
    IBOutlet id manServerStatus;
    IBOutlet id manCurrentMap;
    IBOutlet id manCurrentPlayers;
    IBOutlet id noOfPlayers;
    IBOutlet id playerTable;
    IBOutlet id rconCommandText;
    IBOutlet id currentServMess;
    IBOutlet id mapSelector;
    IBOutlet id mapSelectorButton;
    IBOutlet id killServerButton;
    
    // controller connections
    IBOutlet id mainController;
    IBOutlet id docController;

    NSMutableArray *playerArray;
    BOOL talkingFlag;
    
    BOOL banListChanged;
}
- (IBAction)launchGame:(id)sender;
- (void)launchGameInit;
- (void)launchGameThread;

- (IBAction)manKickPlayer:(id)sender;
- (IBAction)manBanPlayer:(id)sender;
- (void)autoKickPlayers;
- (BOOL)gameProcessRuns;
- (void)pollServer;
- (NSString *)cleanPlayerName:(NSString *)name;
- (NSString *)talkToServer:(NSString *)command reply:(BOOL)wantReply;

- (void)showManagementWindow;
- (void)hideManagementWindow;

- (IBAction)quitGame:(id)sender;
- (IBAction)rconCommand:(id)sender;
- (IBAction)changeMap:(id)sender;
- (IBAction)changeMapButtonControl:(id)sender;

- (void)gscServerSignOn;
- (void)gscServerSignOff;

@end

#import <Cocoa/Cocoa.h>
#import <LaunchController.h>

@interface DocController : NSObject
{    
    // general tab items
    IBOutlet id serverName;
    IBOutlet id serverLocation;
    IBOutlet id serverMotd;
    IBOutlet id adminName;
    IBOutlet id adminEmail;
    IBOutlet id adminWebsite;
    IBOutlet id gameFolder;
    IBOutlet id gameFolderText;
    IBOutlet id serverDedicated;
    
    // automation tab items
    IBOutlet id ipAddress1;
    IBOutlet id ipAddress2;
    IBOutlet id ipAddress3;
    IBOutlet id ipAddress4;
    IBOutlet id addIPButton;
    IBOutlet id removeIPButton;
    IBOutlet id bannedList;
    IBOutlet id bannedListString;
    IBOutlet id enableAutoKick;
    
    IBOutlet id enableServMess;
    IBOutlet id servMessTime;
    IBOutlet id servMessWait;
    IBOutlet id servMessText;
    
    IBOutlet id leadMessEnabled;
    
    // network tab items
    IBOutlet id masterServer1;
    IBOutlet id masterServer2;
    IBOutlet id setMaxPing;
    IBOutlet id setMaxPlayers;
    IBOutlet id setMaxPrivPlayers;
    IBOutlet id setMinPing;
    IBOutlet id setNetPort;
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

    // maps tab items
    IBOutlet id addButton;
    IBOutlet id downButton;
    IBOutlet id gameType;
    IBOutlet id removeButton;
    IBOutlet id upButton;
    IBOutlet id availableMaps;
    IBOutlet id selectedMaps;
    IBOutlet id defaultButton;
    IBOutlet id rotationTitle;
    IBOutlet id availableTitle;
    IBOutlet id mapRotation;
    IBOutlet id mapsList;
    
    // weapons tab items
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
    IBOutlet id weaponSpingfieldBRIT;
    IBOutlet id weaponSten;
    IBOutlet id weaponThompson;
    
    IBOutlet id weaponText;
    
    // preferences items
    IBOutlet id autoUpdateCheck;

    //other
    IBOutlet id spinner;
    IBOutlet id launchButton;
    IBOutlet id launchMenuItem;
    IBOutlet id statusMessage;
    IBOutlet id serverNameLabel;
    IBOutlet id prefsPanel;
    IBOutlet id mainWindow;
    IBOutlet id managementWindow;
    
    // controller connections
    IBOutlet id mainController;
    IBOutlet id launchController;
    
    NSMutableArray *availableMapArray;
    NSMutableArray *selectedMapArray;
    
    NSMutableArray *banListArray;

    NSMutableString *currentFileName;
    BOOL serverEdited;

    // ****** used to set current state ******
    // general tab items
    NSMutableString *c_serverName;
    NSMutableString *c_serverLocation;
    NSMutableString *c_serverMotd;
    NSMutableString *c_adminName;
    NSMutableString *c_adminEmail;
    NSMutableString *c_adminWebsite;
    NSMutableString *c_servMessText;
    int c_servMessTime;
    int c_servMessWait;

    // network tab items
    NSMutableString *c_masterServer1;
    NSMutableString *c_masterServer2;
    NSMutableString *c_masterServer3;
    int c_setMaxPing;
    int c_setMaxPlayers;
    int c_setMaxPrivPlayers;
    int c_setMinPing;
    int c_setNetPort;
    NSMutableString *c_setRconPass;
    NSMutableString *c_setServerPass;
    NSMutableString *c_setPrivatePass;
    NSMutableString *c_serverLogFile;

    // game tab items
    int c_dm_scoreLimit;
    int c_dm_timeLimit;
    int c_tdm_scoreLimit;
    int c_tdm_timeLimit;
    int c_sd_scoreLimit;
    int c_sd_timeLimit;
    int c_sd_roundLength;
    int c_sd_roundLimit;
    int c_sd_gracePeriod;
    int c_bel_scoreLimit;
    int c_bel_timeLimit;
    int c_bel_alivePoint;
    int c_ret_scoreLimit;
    int c_ret_timeLimit;
    int c_ret_roundLength;
    int c_ret_roundLimit;
    int c_ret_gracePeriod;
    int c_hq_scoreLimit;
    int c_hq_Timelimit;
    
    // maps tab items
    NSMutableArray *mapZipList;
    
    // other
    BOOL appLaunchFinished;
    BOOL autoStartFile;
}
- (IBAction)addMap:(id)sender;
- (IBAction)moveMapDown:(id)sender;
- (IBAction)moveMapUp:(id)sender;
- (IBAction)removeMap:(id)sender;
- (IBAction)selectGameType:(id)sender;
- (IBAction)browseForGameFolder:(id)sender;

- (IBAction)defaultMaps:(id)sender;
- (IBAction)setNetworkDefaults:(id)sender;
- (IBAction)setWeaponDefaults:(id)sender;
- (IBAction)setGameDefaults:(id)sender;

- (IBAction)selectAllWeapons:(id)sender;
- (IBAction)selectNoWeapons:(id)sender;

- (IBAction)addIP:(id)sender;
- (IBAction)removeIP:(id)sender;

- (IBAction)documentEdited:(id)sender;
- (IBAction)setServMessEnabled:(id)sender;
- (IBAction)setServLogEnabled:(id)sender;
- (IBAction)setAutoKickEnabled:(id)sender;

- (void)getMapsFromDisk;
- (void)initMapArrays;
- (void)refreshSelectedTableTitle;
- (void)refreshAvailableTableTitle;
- (void)setDefaultRotation;
- (void)netWorkDefaults;
- (void)weaponDefaults;
- (void)gameDefaults;
- (void)generalDefaults;
- (void)defaultMapArray: (NSMutableArray *)aMapArray;
- (void)defaultAvailableMapArray: (NSMutableArray *)aMapArray;
- (BOOL)checkCurrentGameFolder;

- (void)setBanListString;
- (void)getBanlistFromBanlistString;

- (IBAction)checkForUpdate:(id)sender;
- (void)checkForUpdate;

- (IBAction)saveFile:(id)sender;
- (IBAction)saveAsFile:(id)sender;
- (IBAction)loadFile:(id)sender;
- (IBAction)newFile:(id)sender;

- (IBAction)showPrefs:(id)sender;

- (void)saveServerConfig:(BOOL)saveAs;
- (void)loadServerConfig:(NSString *)filename;

- (BOOL)checkDocumentEdited;
- (void)setDocumentCurrentState;
- (void)checkForChangedDocument;

- (void)checkSelectedWeapons;
- (IBAction)selectWeapon:(id)sender;
@end

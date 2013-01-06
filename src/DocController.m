#import "DocController.h"
#import "LaunchController.h"
#import "MainController.h"
#import "define.h"
#import "messages.h"

@implementation DocController

- (IBAction)addMap:(id)sender
// this method adds the selected map + gametype to the rotation
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableArray *oneSelectedMap = [[NSMutableArray alloc] init];
    NSArray *gameTypes = [[NSArray alloc] init];
    gameTypes = [@"xx DM TDM SD BEL RE HQ" componentsSeparatedByString:@" "]; // xx is here to start at 1 instead of 0
    
    if ([selectedMapArray count] < 50) {
        [oneSelectedMap addObject: [gameTypes objectAtIndex:[[gameType selectedItem] tag]]];
        [oneSelectedMap addObject: [availableMaps titleOfSelectedItem]];
        [selectedMapArray addObject: oneSelectedMap]; // add the map to the array
        serverEdited = YES;
    } else {
        NSBeep();
    }
    [self refreshSelectedTableTitle];
    
    [pool release];
}

- (IBAction)removeMap:(id)sender
// this method removes a map from the rotation
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    int n = [selectedMaps numberOfSelectedRows]; // number of selected rows

    if (n>0) { // something was selected
        NSEnumerator *e = [selectedMaps selectedRowEnumerator];
        NSNumber *cur;
        int counter=0;

        serverEdited = YES;

        while (cur = (NSNumber *)[e nextObject]) { // traverse the selection
            if ([selectedMapArray count] >1) {
                [selectedMapArray removeObjectAtIndex: ([cur intValue]-counter)]; // remove the map
                 counter++;
            } else {
                NSBeep(); // you have to have 1 map left
            }
        }
    }
    [self refreshSelectedTableTitle];
    
    [pool release];
}

- (IBAction)moveMapDown:(id)sender
// this method moves a map down in rotation
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    int n = [selectedMaps numberOfSelectedRows]; // number of selected rows

    if (n>0) { // something was selected
        NSEnumerator *e = [selectedMaps selectedRowEnumerator];
        NSNumber *cur;
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        int insertSpace;

        cur = (NSNumber *)[e nextObject]; // pick the first selected row
        int last = [cur intValue] + n;

        if (([cur intValue] + n) != [selectedMapArray count]) { // if we're not already at the bottom
            insertSpace = ([cur intValue]);
            [temp addObject:[[selectedMapArray objectAtIndex: ([cur intValue] + n)] objectAtIndex:0]];
            [temp addObject:[[selectedMapArray objectAtIndex: ([cur intValue] + n)] objectAtIndex:1]];
            [selectedMapArray removeObjectAtIndex: ([cur intValue] + n)]; // remove the map below the selection
            [selectedMapArray insertObject:temp atIndex:insertSpace]; // insert the temp above the selection

            // move the selection down as well
            [selectedMaps selectRow:([cur intValue] + n) byExtendingSelection:YES];
            [selectedMaps deselectRow:[cur intValue]];

            serverEdited = YES;
        }
        
        // scroll the view down to the selection
       if (last < [selectedMapArray count] ) {
            [selectedMaps scrollRowToVisible:last];
        }
    }

    [self refreshSelectedTableTitle];
    
    [pool release];
}

- (IBAction)moveMapUp:(id)sender
// this method moves a map up in the rotation
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    int n = [selectedMaps numberOfSelectedRows]; // number of selected rows

    if (n>0) { // something was selected
        NSEnumerator *e = [selectedMaps selectedRowEnumerator];
        NSNumber *cur;
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        int insertSpace;

        cur = (NSNumber *)[e nextObject]; // pick the first selected row
        int first = [cur intValue];

        if ([cur intValue] != 0) { // if we're not already at the top
            insertSpace = ([cur intValue] + n - 1);
            //temp = [selectedMapArray objectAtIndex: ([cur intValue]-1)];
            [temp addObject:[[selectedMapArray objectAtIndex: ([cur intValue] -1)] objectAtIndex:0]];
            [temp addObject:[[selectedMapArray objectAtIndex: ([cur intValue] -1)] objectAtIndex:1]];
            [selectedMapArray removeObjectAtIndex: ([cur intValue]-1)]; // remove the map above the selection
            [selectedMapArray insertObject:temp atIndex:insertSpace]; // insert the temp below the selection

            // move the selection up as well
            [selectedMaps selectRow:([cur intValue] -1) byExtendingSelection:YES];
            [selectedMaps deselectRow:insertSpace];

            serverEdited = YES;
        }
        
        // scroll the view up to the selection
        if (first >= 1) {
            first--;
        }
        [selectedMaps scrollRowToVisible:first];
    }
    
    [self refreshSelectedTableTitle];
    
    [pool release];
}

- (IBAction)selectGameType:(id)sender
// this method is called when the user selects a gametype
{
    [self defaultAvailableMapArray: availableMapArray]; // set correct maps for this gameType
    [availableMaps addItemsWithTitles:mapZipList]; // add the mapnames from ziplist
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView
// just returns the number of items we have for both tables
{
    if (tableView == bannedList) {
        return [banListArray count];
    }
    
    if (tableView == selectedMaps) {
        return [selectedMapArray count];
    } else {
        return 0;
    }
}

// connect the tableview to the correct array for both tables
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    NSString *column = [tableColumn identifier];
    
    if (tableView == bannedList) {
        return [banListArray objectAtIndex:row];
    }
    
    if (tableView == selectedMaps) {
        return [[selectedMapArray objectAtIndex:row] objectAtIndex:[column intValue]];
    } else {
        return 0;
    }
    
    [pool release];
}

- (IBAction)defaultMaps:(id)sender
// this method sets map rotation to defaults
{
    [self setDefaultRotation];
}

- (void)refreshSelectedTableTitle
// modify the column title for selected maps and modify the rotation string
// and scroll the window to the selection
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    NSString *title = [NSString stringWithFormat:MAP_INROTATION, [selectedMapArray count]];
    [rotationTitle setStringValue: title];
    [selectedMaps reloadData];

    // set removebutton
    if ([selectedMapArray count] > 1) {
        [removeButton setEnabled : YES];
    } else {
        [removeButton setEnabled : NO];
    }

    // set removebutton
    if ([selectedMapArray count] < 50) {
        [addButton setEnabled : YES];
    } else {
        [addButton setEnabled : NO];
    }

    // put the maprotation in the maprotationstring
    NSMutableString *rotationString = [[NSMutableString alloc] init];
    NSMutableString *listString = [[NSMutableString alloc] init];
    NSEnumerator *e = [selectedMapArray objectEnumerator];
    NSNumber *cur;
    int counter=0;

    while (cur = (NSNumber *)[e nextObject]) { // traverse the maprotation
        [rotationString appendString:@"gametype "];
        [rotationString appendString: [[[selectedMapArray objectAtIndex:counter] objectAtIndex:0] lowercaseString]];
        [rotationString appendString:@" "];
        [rotationString appendString:@"map "];
        [rotationString appendString:[[selectedMapArray objectAtIndex:counter] objectAtIndex:1]]; // add the mapname to the string
        [listString appendString:[[selectedMapArray objectAtIndex:counter] objectAtIndex:1]]; // add the mapname to the list
        [rotationString appendString:@" "]; // trailing space
        [listString appendString:@" "]; // trailing space
        counter++;
    }
    
    // remove last trailing spaces
    [rotationString setString:[rotationString substringWithRange:NSMakeRange(0, [rotationString length]-1)]];
    [listString setString:[listString substringWithRange:NSMakeRange(0, [listString length]-1)]];
    
    // set strings in text boxes
    [mapRotation setStringValue:rotationString];
    [mapsList setStringValue:listString];
    
    [pool release];
}

- (void)refreshAvailableTableTitle
// modify the column title for available maps
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    NSString *title = [NSString stringWithFormat:MAP_AVAILABLE, [availableMapArray count]];
    [availableTitle setStringValue: title];
    
    [pool release];
}

- (IBAction)setNetworkDefaults:(id)sender
{
    [self netWorkDefaults];
}

- (IBAction)setWeaponDefaults:(id)sender
{
    [self weaponDefaults];
}

- (IBAction)setGameDefaults:(id)sender
{
    [self gameDefaults];
}

- (void)setDefaultRotation
{
    [selectedMapArray removeAllObjects]; // clear the maplist
    [self defaultMapArray: selectedMapArray]; // set default maps

    [self refreshSelectedTableTitle];
    serverEdited = YES;
}

- (IBAction)showPrefs:(id)sender
{
    [prefsPanel center];
    [prefsPanel makeKeyAndOrderFront:sender];
}

- (void)netWorkDefaults
{
    [setNetPort setDoubleValue:28960];
    [masterServer1 setStringValue:@"codmaster.activision.com"];
    [masterServer2 setStringValue:@""];
    [setRconPass setStringValue:@"DoNotEnterUntilAuthorized"];
    [setServerPass setStringValue:@""];
    [setPrivatePass setStringValue:@""];
    [enableServerLog setState:NSOffState];
    [serverLogFile setStringValue:@"gscserver.log"];
    [serverLogFile setEnabled:NO];
    [enablePunkBuster setState:NSOnState];

    [setMaxPlayers setIntValue:8];
    [setMaxPrivPlayers setIntValue:2];
    [setMinPing setIntValue:0];
    [setMaxPing setIntValue:0];
    [allowVotes setState:NSOnState];
    [allowAnonymous setState:NSOffState];
    [allowDownload setState:NSOffState];
    [pureServer setState:NSOffState];
    [showInGSCServerList setState:NSOnState];
}

- (void)weaponDefaults
{
    [weaponBar setState:NSOnState];
    [weaponBren setState:NSOnState];
    [weaponEnfield setState:NSOnState];
    [weaponFg42 setState:NSOnState];
    [weaponKar98k setState:NSOnState];
    [weaponKar98Sniper setState:NSOnState];
    [weaponM1Carbine setState:NSOnState];
    [weaponM1Garand setState:NSOnState];
    [weaponMp40 setState:NSOnState];
    [weaponMp44 setState:NSOnState];
    [weaponNagant setState:NSOnState];
    [weaponNagantSniper setState:NSOnState];
    [weaponPanzerfaust setState:NSOnState];
    [weaponPpsh setState:NSOnState];
    [weaponSpingfield setState:NSOnState];
    [weaponSten setState:NSOnState];
    [weaponThompson setState:NSOnState];
}

- (void)gameDefaults
{
    [dm_scoreLimit setIntValue:50];
    [dm_timeLimit setIntValue:15];
    [tdm_scoreLimit setIntValue:50];
    [tdm_timeLimit setIntValue:20];
    [sd_scoreLimit setIntValue:8];
    [sd_timeLimit setIntValue:0];
    [sd_roundLength setIntValue:4];
    [sd_roundLimit setIntValue:0];
    [sd_gracePeriod setIntValue:15];
    [bel_scoreLimit setIntValue:50];
    [bel_timeLimit setIntValue:30];
    [bel_alivePoint setIntValue:10];
    [ret_scoreLimit setIntValue:500];
    [ret_timeLimit setIntValue:0];
    [ret_roundLength setIntValue:4];
    [ret_roundLimit setIntValue:0];
    [ret_gracePeriod setIntValue:15];
    [hq_scoreLimit setIntValue:250];
    [hq_Timelimit setIntValue:0];
    
    [showAvatars setState:NSOnState];
    [showCarrier setState:NSOnState];
    
    [forceRespawn setState:NSOffState];
    [setForceBalance setState:NSOnState];
    [setAllowCheating setState:NSOffState];
    [enableKillCam setState:NSOnState];
    [friendlyFire selectItemAtIndex:2];
    [setSpectateOwn setState:NSOffState];
    [allowFreeSpectate setState:NSOffState];    
}

- (void)generalDefaults
{
    [serverName setStringValue:@"Mac OSX-CoD server"];
    [serverNameLabel setStringValue:[serverName stringValue]];
    [serverLocation setStringValue:@"Netherlands, Europe"];
    [serverMotd setStringValue:@"Welcome to Mac OSX-CoD server! Please behave or be kicked."];
    [adminName setStringValue:@"Sgt. Feiss"];
    [adminEmail setStringValue:@"sgtf@feiss.org"];
    [adminWebsite setStringValue:@"www.feiss.org"];
    [enableServMess setState:NSOnState];
    [servMessTime setIntValue:2];
    [servMessWait setIntValue:5];
    [servMessText setStringValue:@"Welcome to the Mac OSX Call of Duty server.\nPlease respect our rules, available from: www.codrules.org\nThe admin is always right!\nDownload custom maps from www.callofduty.com."];
    [servMessTime setEnabled:YES];
    [servMessWait setEnabled:YES];
    [servMessText setEnabled:YES];
    [leadMessEnabled setState:NSOnState];
    [serverDedicated setState:NO];
    
    [enableAutoKick setState:NSOnState];
    [banListArray removeAllObjects];
    [self setBanListString];
    [bannedList reloadData];
    // set buttons
    [addIPButton setEnabled:YES];
    [removeIPButton setEnabled:NO];
    
    [ipAddress1 setIntValue:0];
    [ipAddress2 setIntValue:0];
    [ipAddress3 setIntValue:0];
    [ipAddress4 setIntValue:0];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
// initialise all when the app launched
{
    autoStartFile=NO;
    appLaunchFinished=NO;
    
    // console greeting
    NSLog(CONSOLEGREET);
    
    // initialize the spinners
    [spinner setStyle:NSProgressIndicatorSpinningStyle];
    [spinner setDisplayedWhenStopped:NO];
    [spinner stopAnimation:self]; // stop the progress indicator

    [self initMapArrays];
    banListArray = [[NSMutableArray alloc] init];

    // get preferences from prefs file
    if ([preferences objectForKey:@"gameAppPath"] == nil) {
        [gameFolder setStringValue:DEF_GAMEAPPPATH];
    } else {
        [gameFolder setStringValue:[preferences objectForKey:@"gameAppPath"]]; // get the game app folder
    }
    
    if ([preferences objectForKey:@"autoUpdateCheck"] == nil) {
        [autoUpdateCheck setState: NSOnState];
        [preferences setObject:@"1" forKey:@"autoUpdateCheck"];
    } else {
        [autoUpdateCheck setState:[[preferences objectForKey:@"autoUpdateCheck"] isEqualToString:@"1"]];
    }
    
    if ([preferences objectForKey:@"serverID"] == nil) {
        [preferences setObject:@"" forKey:@"serverID"]; // put a blank one in user prefs
    }
    
    [self setDefaultRotation];

    currentFileName = [[NSMutableString alloc] init];
    c_serverName = [[NSMutableString alloc] init];
    c_serverLocation = [[NSMutableString alloc] init];
    c_serverMotd = [[NSMutableString alloc] init];
    c_adminName = [[NSMutableString alloc] init];
    c_adminEmail = [[NSMutableString alloc] init];
    c_adminWebsite = [[NSMutableString alloc] init];
    c_setRconPass = [[NSMutableString alloc] init];
    c_setServerPass = [[NSMutableString alloc] init];
    c_setPrivatePass = [[NSMutableString alloc] init];
    c_servMessText = [[NSMutableString alloc] init];
    c_masterServer1 = [[NSMutableString alloc] init];
    c_masterServer2 = [[NSMutableString alloc] init];
    c_serverLogFile = [[NSMutableString alloc] init];
    
    serverEdited = NO;
    [self setDocumentCurrentState];

    // get window positions from prefs
    [mainWindow setFrameUsingName:@"winMain"];
    [managementWindow setFrameUsingName:@"winManagement"];
    
    // check if this version has expired
    NSCalendarDate *myDate = [NSCalendarDate dateWithYear:EXPIRYYEAR month:EXPIRYMONTH day:EXPIRYDAY hour:23 minute:59 second:59 timeZone:[NSTimeZone localTimeZone]];
    NSTimeInterval interval = [myDate timeIntervalSinceNow];

    if (interval < 0) { // this version has expired
        int button = NSRunAlertPanel(ALE_EXPIRED1, ALE_EXPIRED2, ALE_UPDATENOW, ALE_QUITBUTTON, nil);
        if (button == NSOKButton) {
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:DOWNLOAD_NEW_URL]];
        }
        // terminate the application
        [NSApp terminate:nil];
    }
    
    // check if there is a newer version
    if ([autoUpdateCheck state]) {
        [self checkForUpdate];
    }
    
    // if we have a filename in the title, we'll open that file now.
    if ([[mainWindow title] isEqualToString:EMPTYWNDWTITLE]) {
        //NSLog(@"Niks openen! %@", [mainWindow title]);
    } else {
        //NSLog(@"Wel openen! %@", [mainWindow title]);
        [self loadServerConfig:[mainWindow title]];
    }
    
    [mainController updateApplicationBadge:0]; // remove the application icon badge
    
    if ([self checkCurrentGameFolder]) { // check if current gamefolder is OK
        if (autoStartFile) { // if an Autostart file was opened, start auto-launch thread.
            autoStartFile=NO;
            NSLog(@"Auto-launching now.");
            [launchController launchGameInit];
        }
    }
    
    //NSLog(@"FINISHED LAUNCH");
    appLaunchFinished=YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification
// stuff to do before the app is quit
{
    [self checkForChangedDocument];

    // save window positions in prefs
    [mainWindow saveFrameUsingName:@"winMain"];
    [managementWindow saveFrameUsingName:@"winManagement"];

    // remove the params config and server config files
    NSMutableString *parameterFilePath = [[NSMutableString alloc] initWithString:[[gameFolder stringValue] stringByAppendingString: PARAMFILENAME]]; // set the params filename
    NSMutableString *configFilePath = [[NSMutableString alloc] initWithString:[[gameFolder stringValue] stringByAppendingString: CONFIGFILENAME]]; // set the config filename

    NSFileManager * manager = [NSFileManager defaultManager];
    [manager removeFileAtPath:parameterFilePath handler:nil]; // remove paramfile
    [manager removeFileAtPath:configFilePath handler:nil]; // remove configfile
    
    [mainController updateApplicationBadge:0]; // remove the application icon badge
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
// stuff to do when the user double clicks on a server config or drags a server config file onto the dock icon
{           
    if (appLaunchFinished) {   
        [self loadServerConfig:filename];
    } else { // launch is not finished yet, we'll set the filename in the window title
        // (quick and dirty) so it will be opened as soon as the app has finished launching.
        // NSLog(@"NOT FINISHED LAUNCHING");
        [mainWindow setTitle:filename];
    }
    return YES;
}

- (IBAction)checkForUpdate:(id)sender
    // check for online updates
{
    [self checkForUpdate];
}

- (void)checkForUpdate
    // check for online updates at startup
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    NSString *currVersionNumber = GSC_VERSION; // the version of this app
    // NSLog(@"Checking for updates...");
    
    // get the version info from the web
    NSDictionary *productVersionDict = [NSDictionary dictionaryWithContentsOfURL:
        [NSURL URLWithString:VERSION_CHECK_URL]];
    NSString *latestVersionNumber = [productVersionDict valueForKey:VERSIONDICTKEY];
    
    if (latestVersionNumber != nil) { // an xml file could be found
        if(![latestVersionNumber isEqualToString: currVersionNumber]) { // there is a new version
            int button = NSRunAlertPanel(ALE_NEWVERSFOUND1, [NSString stringWithFormat: ALE_NEWVERSFOUND2, latestVersionNumber], ALE_YESBUTTON, ALE_NOBUTTON, nil);
            if (button == NSOKButton) {
                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:DOWNLOAD_NEW_URL]];
            }
        }
    }
    
    [pool release];
}

- (IBAction)addIP:(id)sender
    // this method adds the entered IP to the banlist
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    NSMutableString *banIPString = [[NSMutableString alloc] init];
    
    //check if IP address numbers are valid and put them in a string. The IP is first put in a string
    //and then separated again for this reason: when an illegal value is entered, eg. 350 and the user
    //does not tab along to the next field in immediately clicks the Add button, the intValue returns
    //zero (0) but the string formatter uses the entered number anyway. This means the numbers must be
    //put in a string first, and then analysed for illegal values.
    [banIPString setString:[NSString stringWithFormat:@"%d.%d.%d.%d", [ipAddress1 intValue], [ipAddress2 intValue], [ipAddress3 intValue], [ipAddress4 intValue]]];
    
    NSArray * ipComponents = [banIPString componentsSeparatedByString:@"."];
    
    if (([[ipComponents objectAtIndex:0] intValue] < 0) || ([[ipComponents objectAtIndex:0] intValue]> 255) ||
        ([[ipComponents objectAtIndex:1] intValue] < 0) || ([[ipComponents objectAtIndex:1] intValue]> 255) ||
        ([[ipComponents objectAtIndex:2] intValue] < 0) || ([[ipComponents objectAtIndex:2] intValue]> 255) ||
        ([[ipComponents objectAtIndex:3] intValue] < 0) || ([[ipComponents objectAtIndex:3] intValue]> 255)) {
        [banIPString setString:@"0.0.0.0"];
    } 
    
    // NSLog(@"Banned: %@", banIPString);
    
    if ([banListArray count] < MAXBANLISTSIZE) { // is there still room?
        if ([banIPString isEqualToString:@"127.0.0.1"] ||
            [banIPString isEqualToString:@"0.0.0.0"] ||
            [banIPString isEqualToString:@"255.255.255.255"] ) {
            NSBeep();
            int button = NSRunAlertPanel(ALE_CANNOTADDIP1, ALE_CANNOTADDIP2, ALE_OKBUTTON, ALE_ONLINEHELP, nil);
            if (button == NSCancelButton) {
                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:HELP_ADDIP_URL]];
            }
        } else { // we are going to add the IP
                 // check if it already exists
            NSEnumerator *e = [banListArray objectEnumerator];
            NSNumber *cur;
            int counter=0;
            BOOL found=NO;
            
            while ((cur = (NSNumber *)[e nextObject]) && (!found)) { // traverse the list until found or end
                if ([[banListArray objectAtIndex:counter++] isEqualToString:banIPString]) { // found it
                    found = YES;
                }
            }
            
            if (!found) { // if not found add it to the list
                [banListArray addObject: banIPString]; // add the IP to the array
                serverEdited = YES;
                [self setBanListString];
                
                // display list
                [bannedList reloadData];
                [bannedList selectRow:([banListArray count]-1) byExtendingSelection:NO];
                [bannedList scrollRowToVisible:[banListArray count]-1];
                // set buttons
                [addIPButton setEnabled:([banListArray count] < MAXBANLISTSIZE)];
                [removeIPButton setEnabled:([banListArray count] > 0)];
            } else { // IP was already found in current list
                NSBeep();
                int button = NSRunAlertPanel(ALE_CANNOTADDIP3, ALE_CANNOTADDIP2, ALE_OKBUTTON, ALE_ONLINEHELP, nil);
                if (button == NSCancelButton) {
                    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:HELP_ADDIP_URL]];
                }
            }
        }
    } else { // banlist is full
        NSBeep();
    }
    
    [pool release];
}

- (IBAction)removeIP:(id)sender
    // this method removes the entered IP from the banlist
{
    int n = [bannedList numberOfSelectedRows]; // number of selected rows
    
    if (n>0) { // something was selected
        NSEnumerator *e = [bannedList selectedRowEnumerator];
        NSNumber *cur;
        int counter=0;
        
        while (cur = (NSNumber *)[e nextObject]) { // traverse the selection
            if ([banListArray count] >0) {
                [banListArray removeObjectAtIndex: ([cur intValue]-counter)]; // remove the map
                counter++;
            } else {
                NSBeep(); // cannot remove
            }
        }
        
        serverEdited = YES;
        [self setBanListString];
        
        // display list
        [bannedList reloadData];
        [bannedList selectRow:([banListArray count]-1) byExtendingSelection:NO];
        [bannedList scrollRowToVisible:[banListArray count]-1];
    }
    
    // set buttons
    [removeIPButton setEnabled:([banListArray count] > 0)];
}

- (void)setBanListString
    // this method puts the BanList array in a string
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    if ([banListArray count] > 0) {
        NSMutableString *tempString = [[NSMutableString alloc] init];
        NSEnumerator *e = [banListArray objectEnumerator];
        NSNumber *cur;
        int counter=0;
        
        while (cur = (NSNumber *)[e nextObject]) { // traverse the selection
            [tempString appendString:[banListArray objectAtIndex:counter++]]; // add the IP address to the string
            [tempString appendString:@" "];
        }
        
        [bannedListString setStringValue:[tempString substringToIndex:[tempString length]-1]];; // set the string
    } else {
        [bannedListString setStringValue:@""]; // set the string (empty)
    }
    
    [pool release];
}

- (void)getBanlistFromBanlistString
    // this method puts the items from the banlistString into the banist
{
    // NSLog(@"Getting banlist from string...");
    
    [banListArray removeAllObjects];
    [banListArray addObjectsFromArray:[[bannedListString stringValue] componentsSeparatedByString:@" "]];
    
    serverEdited = YES;
    [self setBanListString];
    
    // display list
    [bannedList reloadData];
    [bannedList selectRow:([banListArray count]-1) byExtendingSelection:NO];
    [bannedList scrollRowToVisible:[banListArray count]-1];
    // set buttons
    [addIPButton setEnabled:([banListArray count] < MAXBANLISTSIZE)];
    [removeIPButton setEnabled:([banListArray count] > 0)];
}

- (void)initMapArrays
{
    // initialize the map arrays
    availableMapArray = [[NSMutableArray alloc] init];
    selectedMapArray = [[NSMutableArray alloc] init];
    mapZipList = [[NSMutableArray alloc] init];
}

- (void)getMapsFromDisk
// gets the map names from the game folder
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    [self defaultAvailableMapArray: availableMapArray]; // set default available maps
    [mapZipList removeAllObjects]; // clear the ziplist
    
    NSFileManager * manager = [NSFileManager defaultManager];

    // set up the task launcher
    NSString * mapDirName = BASEDIRNAME; // maps directory
    NSMutableString * openCommand = [[NSMutableString alloc] init];

    if ([manager fileExistsAtPath:UNZIP_PATH]) { // if unzip exists
        [openCommand setString:UNZIP_PATH];
    } else { // use the bundled unzip command
        NSLog(UNZIPNOTFOUND);
        NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
        [openCommand setString: [thisBundle pathForResource:@"unzip" ofType:@""]];
    }
    
    NSString * currentFolder = [gameFolder stringValue]; // current gameFolder
    NSString * completeMapsPath = [currentFolder stringByAppendingString : mapDirName]; // game folder path including maps directory
    NSMutableArray * arguments = [NSMutableArray array]; // set the arguments array
    [arguments addObject:@"-Z"];
    [arguments addObject:@"-1"];

    // get the file list from the current directory
    NSArray * fileList = [manager directoryContentsAtPath:completeMapsPath];

    // traverse the file list and look for map files
    NSEnumerator * e = [fileList objectEnumerator];
    id cur;
    int counter=0;
    
    while (cur = [e nextObject]) { // start traversing the file list
        NSString * currentFile = [fileList objectAtIndex:counter];
        counter++;
        // skip the fucking pak files and othe rubbish
        if ((([[currentFile lowercaseString] hasSuffix:@".pk3"]) &&
             (![[currentFile lowercaseString] hasPrefix:@"pak"]) &&
             (![[currentFile lowercaseString] hasPrefix:@"localized"])) || 
             ([[currentFile lowercaseString] hasPrefix:@"paka"])) {

            [arguments addObject: currentFile]; // the file that will be unzipped
            // NSLog(@"Unzipping: %@", currentFile);

            // unzip the current file
            NSTask * unzip = [[NSTask alloc] init]; // set up a task to launch
            NSPipe * fromPipe = [NSPipe pipe]; // set up output pipe
            NSFileHandle * handle = [fromPipe fileHandleForReading]; // connect a file handle to the pipe

            [unzip setCurrentDirectoryPath: completeMapsPath]; // set the task options
            [unzip setLaunchPath: openCommand];
            [unzip setArguments: arguments];
            [unzip setStandardOutput: fromPipe]; // set the stdout pipe
            [unzip launch]; // launch the unzip command

            NSString * allTheText = [[NSString alloc] initWithData:[handle readDataToEndOfFile] encoding:NSASCIIStringEncoding]; // put the outputdata into an ASCII string
            
            // analyse the outputdata string line by line
            NSString * thisLine; // this holds the current line
            NSEnumerator *lines = [[allTheText componentsSeparatedByString:@"\n"] objectEnumerator];
            
            while (thisLine = [lines nextObject]) { // traverse the lines
               // NSLog(@"Line: %@", thisLine);
                if ([[thisLine lowercaseString] hasSuffix:@".bsp"]) { // is it a mapfile?
                    NSArray * mapFileName = [thisLine componentsSeparatedByString:@"/"]; // chop up the line
                    // is it in /maps/mp?
                    if ([[[mapFileName objectAtIndex:0] lowercaseString] isEqualToString:@"maps"]) {
                        if ([[[mapFileName objectAtIndex:1] lowercaseString] isEqualToString:@"mp"]) {
                           // NSLog(@"Adding map: %@", [mapFileName objectAtIndex:2]);
                            NSString * mapName = [mapFileName objectAtIndex:2];
                            [mapZipList addObject: [mapName substringToIndex:[mapName length]-4]]; // put mapname in the list without .bsp extension
                        }
                    }
                }
            }
            
            [availableMaps addItemsWithTitles:mapZipList];

            [unzip release]; // release the unzip task from memory
            [allTheText release]; // release the stdout text

            [arguments removeObjectAtIndex:2]; // remove the file name from arguments           
        }
    }

    [self refreshAvailableTableTitle];
    
    [pool release];
}

- (void)defaultMapArray: (NSMutableArray *)aMapArray
// set the default map rotation
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    NSArray *gameTypes = [[NSArray alloc] init];
    NSArray *mapList = [[NSArray alloc] init];

    gameTypes = [@"DM TDM HQ SD BEL RE DM" componentsSeparatedByString:@" "];
    mapList = [@"mp_bocage mp_carentan mp_dawnville mp_harbor mp_neuville mp_powcamp mp_rocket" componentsSeparatedByString:@" "];

    int count = [mapList count];
    int c = 0;
    
    while (c < count) {
        NSMutableArray *oneSelectedMap = [[NSMutableArray alloc] init];
        [oneSelectedMap addObject:[gameTypes objectAtIndex:c]];
        [oneSelectedMap addObject:[mapList objectAtIndex:c]];
        [aMapArray addObject:oneSelectedMap];
        [oneSelectedMap release];
        c++;
    }
    
    [pool release];
}

- (void)defaultAvailableMapArray: (NSMutableArray *)aMapArray
// set the available map list for this gametype
{
    NSArray *mapList = [[NSArray alloc] init];
    
    // 1=DM, 2=TDM, 3=SD, 4=BEL, 5=RE, 6=HQ
    switch ([[gameType selectedItem] tag]) {
        case 2 :
        case 4 :
        case 5 :
        case 6 :
        case 1 : mapList = [@"mp_bocage mp_brecourt mp_carentan mp_chateau mp_dawnville mp_depot mp_harbor mp_hurtgen mp_neuville mp_pavlov mp_powcamp mp_railyard mp_rocket mp_ship mp_tigertown" componentsSeparatedByString:@" "];
            break;
        case 3 : mapList = [@"mp_bocage mp_brecourt mp_carentan mp_dawnville mp_depot mp_harbor mp_hurtgen mp_neuville mp_pavlov mp_powcamp mp_railyard mp_rocket mp_tigertown" componentsSeparatedByString:@" "];
            break;
    }
    
    [aMapArray removeAllObjects];
    [aMapArray addObjectsFromArray:mapList];
    
    [availableMaps removeAllItems];
    [availableMaps addItemsWithTitles:mapList];
    
    [self refreshAvailableTableTitle];
}

- (IBAction)browseForGameFolder:(id)sender
// browse dialog to find the game
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    // set up the file manager
    NSArray * fileTypes = nil;
    NSOpenPanel * panel = [NSOpenPanel openPanel];

    // set up the options for the "file-open" panel
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES]; // user must select a directory
    [panel setAllowsMultipleSelection:NO]; // user can only select one

    NSString * currentFolder = [gameFolder stringValue]; // remember current directory

    // open the "file open" panel
    int result = [panel runModalForDirectory:[gameFolder stringValue]
                                        file:nil
                                       types:fileTypes];
    // check what the user has done
    if (result == NSOKButton) { // the user hits the OK button
        NSArray * filesToOpen = [panel filenames]; // array of chosen files
        NSString * gameFolderPath = [filesToOpen objectAtIndex:0]; // chosen folder
        [gameFolder setStringValue: gameFolderPath]; // set the current game folder.
        [preferences setObject:[gameFolder stringValue] forKey:@"gameAppPath"]; // put it in user prefs
    } else { // the user hits the cancel button
        [gameFolder setStringValue: currentFolder]; // put original path back
    }

    // check if current folder contains the game
    [self checkCurrentGameFolder];
    
    [pool release];
}

- (BOOL)checkCurrentGameFolder
// checks if game folder is valid
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    NSString * gameAppName = GAMEAPPNAME; // game app file

    BOOL correctFolder = NO;
    NSString * currentFolder = [gameFolder stringValue]; // remember current directory
    
    // game folder path including filename
    NSMutableString * completeGamePath = [[NSMutableString alloc] initWithString: [currentFolder stringByAppendingString : gameAppName]];
    [completeGamePath appendString:APPEXTENSION];
    [completeGamePath appendString:APPEXEPATH];
    [completeGamePath appendString:gameAppName];
    
    //NSLog(@"path: %@", completeGamePath);
    
    NSFileManager * manager = [NSFileManager defaultManager];

    // check if game app exists and is correct file type and creator
    correctFolder = ([manager fileExistsAtPath: completeGamePath]);
  
    /*
    if (correctFolder) {
        NSDictionary * attributesDic = [manager fileAttributesAtPath: completeGamePath
                                                        traverseLink:YES];
        correctFolder = (([attributesDic fileHFSTypeCode] == 'APPL') && // check if it is an application
                         ([attributesDic fileHFSCreatorCode] == 'CoDs')); // check if it is real
    }*/

    // set texts and buttons according to the correctness of the chosen directory
    if (correctFolder) { // check if the correct folder was chosen
        [gameFolderText setStringValue : PRF_GAMEFOLDER1];
        [gameFolderText setTextColor : [NSColor blackColor]];
        [launchButton setEnabled : YES];
        [launchMenuItem setEnabled : YES];
        [statusMessage setStringValue:GEN_READYLAUNCH]; // set statusmessage
        [statusMessage setTextColor : [NSColor blackColor]];

        // set the map list editor buttons
        [addButton setEnabled : YES];
        [downButton setEnabled : YES];
        [gameType setEnabled : YES];
        [removeButton setEnabled : YES];
        [upButton setEnabled : YES];
        [defaultButton setEnabled : YES];

        [self getMapsFromDisk]; // read maps for this directory
    } else { // the game app cannot be found
        [gameFolderText setStringValue : PRF_GAMEFOLDER2];
        [gameFolderText setTextColor : [NSColor redColor]];
        [launchButton setEnabled : NO];
        [launchMenuItem setEnabled : NO];
        [statusMessage setStringValue:GEN_NOVALIDFOLDER]; // set statusmessage
        [statusMessage setTextColor : [NSColor redColor]];

        // set the map list editor buttons
        [addButton setEnabled : NO];
        [downButton setEnabled : NO];
        [gameType setEnabled : NO];
        [removeButton setEnabled : NO];
        [upButton setEnabled : NO];
        [defaultButton setEnabled : NO];

        [availableMapArray removeAllObjects]; // clear the maplist
        [self refreshAvailableTableTitle];
        
        NSBeep();
    }
	
	return correctFolder;
    
    [pool release];
}

- (IBAction)saveFile:(id)sender
{
    [self saveServerConfig:NO];
}

- (IBAction)saveAsFile:(id)sender
{
    [self saveServerConfig:YES];
}

- (IBAction)loadFile:(id)sender
{
    [self loadServerConfig:@""];
}

- (void)loadServerConfig:(NSString *)filename
// this method opens a file open dialog unless a filename has already been given
{ 
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    //NSLog(@"Opening filename: %@", filename);
    
    // check if the server is currently running
    if ([[statusMessage stringValue] isEqualToString:GEN_RUNNING]) {
        NSBeep();
        int button = NSRunAlertPanel(ALE_CANNOTOPENFILE1, ALE_CANNOTOPENFILE2, ALE_OKBUTTON, ALE_ONLINEHELP, nil);
        if (button == NSCancelButton) {
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:HELP_CANTOPENFILE_URL]];
        }
    } else { // we can now open the file
        [self checkForChangedDocument]; // ask to save if something has been edited
        NSMutableString *selectedFile = [[NSMutableString alloc] init];
        
        if ([filename isEqualToString:@""]) { // if we have to filename yet
            // set up the file manager
            NSArray * fileTypes = [OPEN_EXTENSION componentsSeparatedByString:@" "];
            NSOpenPanel * panel = [NSOpenPanel openPanel];
            
            // set up the options for the "file-open" panel
            [panel setCanChooseFiles:YES]; // user must select a file
            [panel setCanChooseDirectories:NO];
            [panel setAllowsMultipleSelection:NO]; // user can only select one
            
            // open the "file open" panel
            int result = [panel runModalForDirectory:[currentFileName stringByDeletingLastPathComponent] file:nil types:fileTypes];
            // int result = [panel beginSheetForDirectory:[currentFileName stringByDeletingLastPathComponent] file:nil types:fileTypes modalForWindow:mainWindow modalDelegate:self didEndSelector: contextInfo:NULL];
            
            // check what the user has done
            if (result == NSOKButton) { // the user hits the OK button
                NSArray * filesToOpen = [panel filenames]; // array of chosen files
                [selectedFile setString:[filesToOpen objectAtIndex:0]]; // chosen file
            } else {
                [selectedFile setString:@""]; // just in case, empty the string
            }
        } else {
            [selectedFile setString:filename]; // get the filename from the parameter
        }
        
        NSFileManager * manager = [NSFileManager defaultManager];
        BOOL fileExists=NO;
        BOOL isDir=NO;
        
        fileExists=[manager fileExistsAtPath:selectedFile isDirectory:&isDir];
        
        if (fileExists && !isDir && ![selectedFile isEqualToString:@""]) { // if the file exists and is no directory, we're gonna open it.
            // open the file and read the dictionary
            NSDictionary *serverDict = [[NSDictionary alloc] initWithContentsOfFile: selectedFile];
            
            if (serverDict == nil) { // the file is damaged
                NSBeep();
                int button = NSRunAlertPanel(ALE_FILEDAMAGED1, ALE_FILEDAMAGED2, ALE_CANCELBUTTON, ALE_ONLINEHELP, nil);
                if (button == NSCancelButton) {
                    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:HELP_FILEDAMAGED_URL]];
                }
            } else { // the dictionary plist is OK, let's read stuff
                [currentFileName setString:selectedFile];
                
                // general tab items
                [serverName setStringValue:[serverDict objectForKey:@"serverName"]];
                [serverNameLabel setStringValue:[serverName stringValue]];
                [serverLocation setStringValue:[serverDict objectForKey:@"serverLocation"]];
                [serverMotd setStringValue:[serverDict objectForKey:@"serverMotd"]];
                [adminName setStringValue:[serverDict objectForKey:@"adminName"]];
                [adminEmail setStringValue:[serverDict objectForKey:@"adminEmail"]];
                [adminWebsite setStringValue:[serverDict objectForKey:@"adminWebsite"]];
                [serverDedicated setState:[[serverDict objectForKey:@"serverDedicated"] isEqualToString:@"1"]];
                
                // automation items
                [servMessTime setStringValue:[serverDict objectForKey:@"servMessTime"]];
                [servMessWait setStringValue:[serverDict objectForKey:@"servMessWait"]];
                [servMessText setStringValue:[serverDict objectForKey:@"servMessText"]];
                [enableServMess setState:[[serverDict objectForKey:@"enableServMess"] isEqualToString:@"1"]];
                [leadMessEnabled setState:[[serverDict objectForKey:@"leadMessEnabled"] isEqualToString:@"1"]];
                
                [enableAutoKick setState:[[serverDict objectForKey:@"enableAutoKick"] isEqualToString:@"1"]];
                [banListArray setArray:[serverDict objectForKey:@"banList"]];
                [self setBanListString];
                [bannedList reloadData];

                // network tab items
                [setNetPort setStringValue:[serverDict objectForKey:@"setNetPort"]];
                [masterServer1 setStringValue:[serverDict objectForKey:@"masterServer1"]];
                [masterServer2 setStringValue:[serverDict objectForKey:@"masterServer2"]];
                [setMaxPing setStringValue:[serverDict objectForKey:@"setMaxPing"]];
                [setMaxPlayers setStringValue:[serverDict objectForKey:@"setMaxPlayers"]];
                [setMaxPlayers setStringValue:[serverDict objectForKey:@"setMaxPrivPlayers"]];
                [setMinPing setStringValue:[serverDict objectForKey:@"setMinPing"]];
                [setRconPass setStringValue:[serverDict objectForKey:@"setRconPass"]];
                [setServerPass setStringValue:[serverDict objectForKey:@"setServerPass"]];
                [setPrivatePass setStringValue:[serverDict objectForKey:@"setPrivatePass"]];
                [allowVotes setState:[[serverDict objectForKey:@"allowVotes"] isEqualToString:@"1"]];
                [allowDownload setState:[[serverDict objectForKey:@"allowDownload"] isEqualToString:@"1"]];
                [allowAnonymous setState:[[serverDict objectForKey:@"allowAnonymous"] isEqualToString:@"1"]];
                [enableServerLog setState:[[serverDict objectForKey:@"enableServerLog"] isEqualToString:@"1"]];
                [serverLogFile setStringValue:[serverDict objectForKey:@"serverLogFile"]];
                [pureServer setState:[[serverDict objectForKey:@"pureServer"] isEqualToString:@"1"]];
                [enablePunkBuster setState:[[serverDict objectForKey:@"enablePunkBuster"] isEqualToString:@"1"]];
                [showInGSCServerList setState:[[serverDict objectForKey:@"showInGSCServerList"] isEqualToString:@"1"]];
                
                // game tab items
                [dm_scoreLimit setStringValue:[serverDict objectForKey:@"dm_scoreLimit"]];
                [dm_timeLimit setStringValue:[serverDict objectForKey:@"dm_timeLimit"]];
                [tdm_scoreLimit setStringValue:[serverDict objectForKey:@"tdm_scoreLimit"]];
                [tdm_timeLimit setStringValue:[serverDict objectForKey:@"tdm_timeLimit"]];
                [sd_scoreLimit setStringValue:[serverDict objectForKey:@"sd_scoreLimit"]];
                [sd_timeLimit setStringValue:[serverDict objectForKey:@"sd_timeLimit"]];
                [sd_roundLength setStringValue:[serverDict objectForKey:@"sd_roundLength"]];
                [sd_roundLimit setStringValue:[serverDict objectForKey:@"sd_roundLimit"]];
                [sd_gracePeriod setStringValue:[serverDict objectForKey:@"sd_gracePeriod"]];
                [bel_scoreLimit setStringValue:[serverDict objectForKey:@"bel_scoreLimit"]];
                [bel_timeLimit setStringValue:[serverDict objectForKey:@"bel_timeLimit"]];
                [bel_alivePoint setStringValue:[serverDict objectForKey:@"bel_alivePoint"]];
                [ret_scoreLimit setStringValue:[serverDict objectForKey:@"ret_scoreLimit"]];
                [ret_timeLimit setStringValue:[serverDict objectForKey:@"ret_timeLimit"]];
                [ret_roundLimit setStringValue:[serverDict objectForKey:@"ret_roundLimit"]];
                [ret_roundLength setStringValue:[serverDict objectForKey:@"ret_roundLength"]];
                [ret_gracePeriod setStringValue:[serverDict objectForKey:@"ret_gracePeriod"]];
                [hq_scoreLimit setStringValue:[serverDict objectForKey:@"hq_scoreLimit"]];
                [hq_Timelimit setStringValue:[serverDict objectForKey:@"hq_Timelimit"]];
            
                [showAvatars setState:[[serverDict objectForKey:@"showAvatars"] isEqualToString:@"1"]];
                [showCarrier setState:[[serverDict objectForKey:@"showCarrier"] isEqualToString:@"1"]];
            
                [forceRespawn setState:[[serverDict objectForKey:@"forceRespawn"] isEqualToString:@"1"]];
                [setForceBalance setState:[[serverDict objectForKey:@"setForceBalance"] isEqualToString:@"1"]];
                [setAllowCheating setState:[[serverDict objectForKey:@"setAllowCheating"] isEqualToString:@"1"]];
                [enableKillCam setState:[[serverDict objectForKey:@"enableKillCam"] isEqualToString:@"1"]];
                [friendlyFire selectItemAtIndex:([[serverDict objectForKey:@"friendlyFire"] intValue] - 1)];
                [setSpectateOwn setState:[[serverDict objectForKey:@"setSpectateOwn"] isEqualToString:@"1"]];
                [allowFreeSpectate setState:[[serverDict objectForKey:@"allowFreeSpectate"] isEqualToString:@"1"]]; 
            
                // weapon tab items
                [weaponBar setState:[[serverDict objectForKey:@"weaponBar"] isEqualToString:@"1"]];
                [weaponBren setState:[[serverDict objectForKey:@"weaponBren"] isEqualToString:@"1"]];
                [weaponEnfield setState:[[serverDict objectForKey:@"weaponEnfield"] isEqualToString:@"1"]];
                [weaponFg42 setState:[[serverDict objectForKey:@"weaponFg42"] isEqualToString:@"1"]];
                [weaponKar98k setState:[[serverDict objectForKey:@"weaponKar98k"] isEqualToString:@"1"]];
                [weaponKar98Sniper setState:[[serverDict objectForKey:@"weaponKar98Sniper"] isEqualToString:@"1"]];
                [weaponM1Carbine setState:[[serverDict objectForKey:@"weaponM1Carbine"] isEqualToString:@"1"]];
                [weaponM1Garand setState:[[serverDict objectForKey:@"weaponM1Garand"] isEqualToString:@"1"]];
                [weaponMp40 setState:[[serverDict objectForKey:@"weaponMp40"] isEqualToString:@"1"]];
                [weaponMp44 setState:[[serverDict objectForKey:@"weaponMp44"] isEqualToString:@"1"]];
                [weaponNagant setState:[[serverDict objectForKey:@"weaponNagant"] isEqualToString:@"1"]];
                [weaponNagantSniper setState:[[serverDict objectForKey:@"weaponNagantSniper"] isEqualToString:@"1"]];
                [weaponPanzerfaust setState:[[serverDict objectForKey:@"weaponPanzerfaust"] isEqualToString:@"1"]];
                [weaponPpsh setState:[[serverDict objectForKey:@"weaponPpsh"] isEqualToString:@"1"]];
                [weaponSpingfield setState:[[serverDict objectForKey:@"weaponSpingfield"] isEqualToString:@"1"]];
                [weaponSten setState:[[serverDict objectForKey:@"weaponSten"] isEqualToString:@"1"]];
                [weaponThompson setState:[[serverDict objectForKey:@"weaponThompson"] isEqualToString:@"1"]];

                // maps tab items
                [selectedMapArray setArray:[serverDict objectForKey:@"selectedMaps"]];
                [self refreshSelectedTableTitle];

                serverEdited = NO;
                [self setDocumentCurrentState];
                
                [mainWindow setTitleWithRepresentedFilename:selectedFile]; // set window title
                
                // check if we need to auto-start
                autoStartFile=([[selectedFile lowercaseString] rangeOfString:AUTOSTARTNAME].location!=NSNotFound);
                
                // check if file was saved with another GSC version
                if (![[serverDict objectForKey:@"gscversion"] isEqualToString:GSC_VERSION]) {
                    // NSLog(@"OLD file version");
                    [showInGSCServerList setState:NSOnState];
                    serverEdited = YES;
                    NSBeep();
                    int button = NSRunAlertPanel(ALE_OLDFILEVERS1, ALE_OLDFILEVERS2, ALE_OKBUTTON, ALE_ONLINEHELP, nil);
                    if (button == NSCancelButton) {
                        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:HELP_OLDFILEVER_URL]];
                    }
                }
                
                // check if the rconpass isn't too short
                [mainController checkRconPass:self];
            }
        }
    }
    
    [pool release];
}

- (IBAction)newFile:(id)sender
{
    [self checkForChangedDocument]; // ask to save if something has been edited
    
    [self setDefaultRotation];
    
    [self netWorkDefaults];
    [self weaponDefaults];
    [self gameDefaults];
    [self generalDefaults];

    [self setDocumentCurrentState];
    [currentFileName setString:@""];
    serverEdited = NO;
    
    [mainWindow setTitle:EMPTYWNDWTITLE];
}

- (void)saveServerConfig:(BOOL)saveAs;
// this saves the current server config
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    int actionSelection=0; // 0=do nothing, 1=save in new file, 2=save in current file
    NSSavePanel * panel = [NSSavePanel savePanel]; // set up the file manager
    NSMutableString *filePath = [[NSMutableString alloc] init];
    
    if (saveAs || ([currentFileName length] == 0)) { // user wants to "save as"
        // set up the options for the "file-save" panel
        [panel setCanSelectHiddenExtension:NO];

        // open the "file save" panel
        int result = [panel runModalForDirectory:[currentFileName stringByDeletingLastPathComponent] file:DEFAULT_FNAME];
        if (result == NSOKButton) { // the user has chosen to save the file
            actionSelection=1; // save in new file
            [filePath setString:[panel filename]]; // set the filename to save to
            if (![filePath hasSuffix:SAVE_EXTENSION]) { // if there is no extension
                [filePath appendString:SAVE_EXTENSION]; // append extension
            }
        } else {
            actionSelection=0; // do nothing
            [filePath setString:@"/"];
        }
    } else {
        actionSelection=2; // save in current file
        filePath = currentFileName;
    }

    // start saving the file
    if (actionSelection != 0 ) { // user wants to save
        [currentFileName setString:filePath];
        // create a dictionary of all the current game server settings
        NSMutableDictionary *configDict = [[NSMutableDictionary alloc] init];
        
        // version information
        [configDict setObject:GSC_VERSION forKey:@"gscversion"];

        // general tab items
        [configDict setObject:[serverName stringValue] forKey:@"serverName"];
        [configDict setObject:[serverLocation stringValue] forKey:@"serverLocation"];
        [configDict setObject:[serverMotd stringValue] forKey:@"serverMotd"];
        [configDict setObject:[adminName stringValue] forKey:@"adminName"];
        [configDict setObject:[adminEmail stringValue] forKey:@"adminEmail"];
        [configDict setObject:[adminWebsite stringValue] forKey:@"adminWebsite"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [serverDedicated state]] forKey:@"serverDedicated"];
        
        // automation items
        [configDict setObject:[servMessTime stringValue] forKey:@"servMessTime"];
        [configDict setObject:[servMessWait stringValue] forKey:@"servMessWait"];
        [configDict setObject:[servMessText stringValue] forKey:@"servMessText"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [enableServMess state]] forKey:@"enableServMess"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [leadMessEnabled state]] forKey:@"leadMessEnabled"];
        
        [configDict setObject:[NSString stringWithFormat:@"%d", [enableAutoKick state]] forKey:@"enableAutoKick"];   
        [configDict setObject:banListArray forKey:@"banList"];

        // network tab items
        [configDict setObject:[masterServer1 stringValue] forKey:@"masterServer1"];
        [configDict setObject:[masterServer2 stringValue] forKey:@"masterServer2"];
        [configDict setObject:[setNetPort stringValue] forKey:@"setNetPort"];
        [configDict setObject:[setMinPing stringValue] forKey:@"setMinPing"];
        [configDict setObject:[setMaxPing stringValue] forKey:@"setMaxPing"];
        [configDict setObject:[setMaxPlayers stringValue] forKey:@"setMaxPlayers"];
        [configDict setObject:[setMaxPlayers stringValue] forKey:@"setMaxPrivPlayers"];
        [configDict setObject:[setRconPass stringValue] forKey:@"setRconPass"];
        [configDict setObject:[setServerPass stringValue] forKey:@"setServerPass"];
        [configDict setObject:[setPrivatePass stringValue] forKey:@"setPrivatePass"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [allowVotes state]] forKey:@"allowVotes"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [allowDownload state]] forKey:@"allowDownload"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [allowAnonymous state]] forKey:@"allowAnonymous"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [enableServerLog state]] forKey:@"enableServerLog"];
        [configDict setObject:[serverLogFile stringValue] forKey:@"serverLogFile"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [pureServer state]] forKey:@"pureServer"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [enablePunkBuster state]] forKey:@"enablePunkBuster"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [showInGSCServerList state]] forKey:@"showInGSCServerList"];

        // game tab items
        [configDict setObject:[dm_scoreLimit stringValue] forKey:@"dm_scoreLimit"];
        [configDict setObject:[dm_timeLimit stringValue] forKey:@"dm_timeLimit"];
        [configDict setObject:[tdm_scoreLimit stringValue] forKey:@"tdm_scoreLimit"];
        [configDict setObject:[tdm_timeLimit stringValue] forKey:@"tdm_timeLimit"];
        [configDict setObject:[sd_scoreLimit stringValue] forKey:@"sd_scoreLimit"];
        [configDict setObject:[sd_timeLimit stringValue] forKey:@"sd_timeLimit"];
        [configDict setObject:[sd_roundLength stringValue] forKey:@"sd_roundLength"];
        [configDict setObject:[sd_roundLimit stringValue] forKey:@"sd_roundLimit"];
        [configDict setObject:[sd_gracePeriod stringValue] forKey:@"sd_gracePeriod"];
        [configDict setObject:[bel_scoreLimit stringValue] forKey:@"bel_scoreLimit"];
        [configDict setObject:[bel_timeLimit stringValue] forKey:@"bel_timeLimit"];
        [configDict setObject:[bel_alivePoint stringValue] forKey:@"bel_alivePoint"];
        [configDict setObject:[ret_scoreLimit stringValue] forKey:@"ret_scoreLimit"];
        [configDict setObject:[ret_timeLimit stringValue] forKey:@"ret_timeLimit"];
        [configDict setObject:[ret_roundLimit stringValue] forKey:@"ret_roundLimit"];
        [configDict setObject:[ret_roundLength stringValue] forKey:@"ret_roundLength"];
        [configDict setObject:[ret_gracePeriod stringValue] forKey:@"ret_gracePeriod"];
        [configDict setObject:[hq_scoreLimit stringValue] forKey:@"hq_scoreLimit"];
        [configDict setObject:[hq_Timelimit  stringValue] forKey:@"hq_Timelimit"];
        
        [configDict setObject:[NSString stringWithFormat:@"%d", [showAvatars state]] forKey:@"showAvatars"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [showCarrier state]] forKey:@"showCarrier"];
        
        [configDict setObject:[NSString stringWithFormat:@"%d", [forceRespawn state]] forKey:@"forceRespawn"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [setForceBalance state]] forKey:@"setForceBalance"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [setAllowCheating state]] forKey:@"setAllowCheating"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [enableKillCam state]] forKey:@"enableKillCam"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [[friendlyFire selectedItem] tag]] forKey:@"friendlyFire"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [setSpectateOwn state]] forKey:@"setSpectateOwn"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [allowFreeSpectate state]] forKey:@"allowFreeSpectate"];
        
        // weapon tab items
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponBar state]] forKey:@"weaponBar"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponBren state]] forKey:@"weaponBren"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponEnfield state]] forKey:@"weaponEnfield"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponFg42 state]] forKey:@"weaponFg42"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponKar98k state]] forKey:@"weaponKar98k"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponKar98Sniper state]] forKey:@"weaponKar98Sniper"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponM1Carbine state]] forKey:@"weaponM1Carbine"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponM1Garand state]] forKey:@"weaponM1Garand"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponMp40 state]] forKey:@"weaponMp40"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponMp44 state]] forKey:@"weaponMp44"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponNagant state]] forKey:@"weaponNagant"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponNagantSniper state]] forKey:@"weaponNagantSniper"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponPanzerfaust state]] forKey:@"weaponPanzerfaust"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponPpsh state]] forKey:@"weaponPpsh"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponSpingfield state]] forKey:@"weaponSpingfield"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponSten state]] forKey:@"weaponSten"];
        [configDict setObject:[NSString stringWithFormat:@"%d", [weaponThompson state]] forKey:@"weaponThompson"];

        // maps tab items
        [configDict setObject:selectedMapArray forKey:@"selectedMaps"];

        if (![configDict writeToFile:filePath atomically:YES]) { // write the dictionary to file
            NSBeep(); // file did not save!
//            NSLog(@"Could not save settings file!");
        } else { // save is successful
            serverEdited = NO;
            [self setDocumentCurrentState];
        }
        
        [configDict release];
    }
    
    [pool release];
}

- (IBAction)setServMessEnabled:(id)sender
// this method responds when the user enables server messages
{
    serverEdited = YES;
    if ([enableServMess intValue] == 1) {
        [servMessTime setEnabled:YES];
        [servMessWait setEnabled:YES];
        [servMessText setEnabled:YES];
    } else {
        [servMessTime setEnabled:NO];
        [servMessWait setEnabled:NO];
        [servMessText setEnabled:NO];
    }
}

- (IBAction)setServLogEnabled:(id)sender
// this method responds when the user enables server logging
{
    serverEdited = YES;
    if ([enableServerLog intValue] == 1) {
        [serverLogFile setEnabled:YES];
    } else {
        [serverLogFile setEnabled:NO];
    }
}

- (IBAction)setAutoKickEnabled:(id)sender
    // this method responds when the user enables auto kick
{
    serverEdited = YES;
    if ([enableAutoKick intValue] == 1) {
        [addIPButton setEnabled:([banListArray count] < MAXBANLISTSIZE)];
        [removeIPButton setEnabled:([banListArray count] > 0)];
        [ipAddress1 setEnabled:YES];
        [ipAddress2 setEnabled:YES];
        [ipAddress3 setEnabled:YES];
        [ipAddress4 setEnabled:YES];
    } else {
        [addIPButton setEnabled:NO];
        [removeIPButton setEnabled:NO];
        [ipAddress1 setEnabled:NO];
        [ipAddress2 setEnabled:NO];
        [ipAddress3 setEnabled:NO];
        [ipAddress4 setEnabled:NO];
    }
}

- (IBAction)documentEdited:(id)sender
// this is called by all items that can trigger it
{
    serverEdited = YES;
}

- (BOOL)checkDocumentEdited
// check if document has been edited by user
{
    // general tab items
    if (![c_serverName isEqualToString:[serverName stringValue]]) {serverEdited=YES;}
    if (![c_serverLocation isEqualToString:[serverLocation stringValue]]) {serverEdited=YES;}
    if (![c_serverMotd isEqualToString:[serverMotd stringValue]]) {serverEdited=YES;}
    if (![c_adminName isEqualToString:[adminName stringValue]]) {serverEdited=YES;}
    if (![c_adminEmail isEqualToString:[adminEmail stringValue]]) {serverEdited=YES;}
    if (![c_adminWebsite isEqualToString:[adminWebsite stringValue]]) {serverEdited=YES;}
    if (c_servMessTime != [servMessTime intValue]) {serverEdited=YES;}
    if (c_servMessWait != [servMessWait intValue]) {serverEdited=YES;}  
    if (![c_servMessText isEqualToString:[servMessText stringValue]]) {serverEdited=YES;}

    // network tab items
    if (![c_masterServer1 isEqualToString:[masterServer1 stringValue]]) {serverEdited=YES;}
    if (![c_masterServer2 isEqualToString:[masterServer2 stringValue]]) {serverEdited=YES;}
    if (c_setMaxPing != [setMaxPing intValue]) {serverEdited=YES;}
    if (c_setMaxPlayers != [setMaxPlayers intValue]) {serverEdited=YES;}
    if (c_setMaxPrivPlayers != [setMaxPrivPlayers intValue]) {serverEdited=YES;}
    if (c_setMinPing != [setMinPing intValue]) {serverEdited=YES;}
    if (c_setNetPort != [setNetPort intValue]) {serverEdited=YES;}
    if (![c_setRconPass isEqualToString:[setRconPass stringValue]]) {serverEdited=YES;}
    if (![c_setServerPass isEqualToString:[setServerPass stringValue]]) {serverEdited=YES;}
    if (![c_setPrivatePass isEqualToString:[setPrivatePass stringValue]]) {serverEdited=YES;}

    // server tab items

    // game tab items
    if (c_dm_scoreLimit != [dm_scoreLimit intValue]) {serverEdited=YES;}
    if (c_dm_timeLimit != [dm_timeLimit intValue]) {serverEdited=YES;}
    if (c_tdm_scoreLimit != [tdm_scoreLimit intValue]) {serverEdited=YES;}
    if (c_tdm_timeLimit != [tdm_timeLimit intValue]) {serverEdited=YES;}
    if (c_sd_scoreLimit != [sd_scoreLimit intValue]) {serverEdited=YES;}
    if (c_sd_timeLimit != [sd_timeLimit intValue]) {serverEdited=YES;}
    if (c_sd_roundLength != [sd_roundLength intValue]) {serverEdited=YES;}
    if (c_sd_roundLimit != [sd_roundLimit intValue]) {serverEdited=YES;}
    if (c_sd_gracePeriod != [sd_gracePeriod intValue]) {serverEdited=YES;}
    if (c_bel_scoreLimit != [bel_scoreLimit intValue]) {serverEdited=YES;}
    if (c_bel_timeLimit != [bel_timeLimit intValue]) {serverEdited=YES;}
    if (c_bel_alivePoint != [bel_alivePoint intValue]) {serverEdited=YES;}
    if (c_ret_scoreLimit != [ret_scoreLimit intValue]) {serverEdited=YES;}
    if (c_ret_timeLimit != [ret_timeLimit intValue]) {serverEdited=YES;}
    if (c_ret_roundLength != [ret_roundLength intValue]) {serverEdited=YES;}
    if (c_ret_roundLimit != [ret_roundLimit intValue]) {serverEdited=YES;}
    if (c_ret_gracePeriod != [ret_gracePeriod intValue]) {serverEdited=YES;}
    if (c_hq_scoreLimit != [hq_scoreLimit intValue]) {serverEdited=YES;}
    if (c_hq_Timelimit != [hq_Timelimit intValue]) {serverEdited=YES;}
    
    if (serverEdited) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setDocumentCurrentState
// save current state to see if changed later on
{
    // general tab items
    [c_serverName setString:[serverName stringValue]];
    [c_serverLocation setString:[serverLocation stringValue]];
    [c_serverMotd setString:[serverMotd stringValue]];
    [c_adminName setString:[adminName stringValue]];
    [c_adminEmail setString:[adminEmail stringValue]];
    [c_adminWebsite setString:[adminWebsite stringValue]];
    c_servMessTime = [servMessTime intValue];
    c_servMessWait = [servMessWait intValue];
    [c_servMessText setString:[servMessText stringValue]];

    // network tab items
    [c_masterServer1 setString:[masterServer1 stringValue]];
    [c_masterServer2 setString:[masterServer2 stringValue]];
    c_setMaxPing = [setMaxPing intValue];
    c_setMaxPlayers = [setMaxPlayers intValue];
    c_setMaxPrivPlayers = [setMaxPrivPlayers intValue];
    c_setMinPing = [setMinPing intValue];
    c_setNetPort = [setNetPort intValue];
    [c_setRconPass setString:[setRconPass stringValue]];
    [c_setServerPass setString:[setServerPass stringValue]];
    [c_setPrivatePass setString:[setPrivatePass stringValue]];
    [c_serverLogFile setString:[serverLogFile stringValue]];

    // game tab items
    c_dm_scoreLimit = [dm_scoreLimit intValue];
    c_dm_timeLimit = [dm_timeLimit intValue];
    c_tdm_scoreLimit = [tdm_scoreLimit intValue];
    c_tdm_timeLimit = [tdm_timeLimit intValue];
    c_sd_scoreLimit = [sd_scoreLimit  intValue];
    c_sd_timeLimit = [sd_timeLimit intValue];
    c_sd_roundLength = [sd_roundLength intValue];
    c_sd_roundLimit = [sd_roundLimit intValue];
    c_sd_gracePeriod = [sd_gracePeriod intValue];
    c_bel_scoreLimit = [bel_scoreLimit intValue];
    c_bel_timeLimit = [bel_timeLimit intValue];
    c_bel_alivePoint = [bel_alivePoint intValue];
    c_ret_scoreLimit = [ret_scoreLimit intValue];
    c_ret_timeLimit = [ret_timeLimit intValue];
    c_ret_roundLength = [ret_roundLength intValue];
    c_ret_roundLimit = [ret_roundLimit intValue];
    c_ret_gracePeriod = [ret_gracePeriod intValue];
    c_hq_scoreLimit = [hq_scoreLimit intValue];
    c_hq_Timelimit = [hq_Timelimit intValue];
}

- (void) checkForChangedDocument
// this method checks if the document was changed by the user
{
    // check if document changed
    if ([self checkDocumentEdited]) {
        NSBeep();
        int button = NSRunAlertPanel(ALE_SAVECHANGES1, ALE_SAVECHANGES2, ALE_YESBUTTON, ALE_NOBUTTON, nil);
        if (button == NSOKButton) { // yes, save it
            [self saveServerConfig:NO]; // do a save
        }
    }
}

- (IBAction)selectAllWeapons:(id)sender
{
    [weaponBar setState:NSOnState];
    [weaponBren setState:NSOnState];
    [weaponEnfield setState:NSOnState];
    [weaponFg42 setState:NSOnState];
    [weaponKar98k setState:NSOnState];
    [weaponKar98Sniper setState:NSOnState];
    [weaponM1Carbine setState:NSOnState];
    [weaponM1Garand setState:NSOnState];
    [weaponMp40 setState:NSOnState];
    [weaponMp44 setState:NSOnState];
    [weaponNagant setState:NSOnState];
    [weaponNagantSniper setState:NSOnState];
    [weaponPanzerfaust setState:NSOnState];
    [weaponPpsh setState:NSOnState];
    [weaponSpingfield setState:NSOnState];
    [weaponSpingfieldBRIT setState:NSOnState];
    [weaponSten setState:NSOnState];
    [weaponThompson setState:NSOnState];
    
    serverEdited = YES;
    [self checkSelectedWeapons];
}

- (IBAction)selectNoWeapons:(id)sender
{
    [weaponBar setState:NSOffState];
    [weaponBren setState:NSOffState];
    [weaponEnfield setState:NSOffState];
    [weaponFg42 setState:NSOffState];
    [weaponKar98k setState:NSOffState];
    [weaponKar98Sniper setState:NSOffState];
    [weaponM1Carbine setState:NSOffState];
    [weaponM1Garand setState:NSOffState];
    [weaponMp40 setState:NSOffState];
    [weaponMp44 setState:NSOffState];
    [weaponNagant setState:NSOffState];
    [weaponNagantSniper setState:NSOffState];
    [weaponPanzerfaust setState:NSOffState];
    [weaponPpsh setState:NSOffState];
    [weaponSpingfield setState:NSOffState];
    [weaponSpingfieldBRIT setState:NSOffState];
    [weaponSten setState:NSOffState];
    [weaponThompson setState:NSOffState];
    
    serverEdited = YES;
    [self checkSelectedWeapons];
}

- (IBAction)selectWeapon:(id)sender
{
    switch ([sender tag]) {
        case 99:
            [weaponSpingfieldBRIT setState:[weaponSpingfield state]];
            break;
        case 66:
            [weaponSpingfield setState:[weaponSpingfieldBRIT state]];
            break;
    }

    serverEdited = YES;
    [self checkSelectedWeapons];
}

- (void)checkSelectedWeapons
// this method checks if at least ONE weapon is selected per armytype
{
    BOOL oneUSASelected = ([weaponBar state] || [weaponM1Carbine state] || [weaponM1Garand state] || [weaponSpingfield state] || [weaponThompson state]);
    BOOL oneBRITSelected = ([weaponBren state] || [weaponEnfield state] || [weaponSpingfieldBRIT state] || [weaponSten state]);
    BOOL oneGERMANSelected = ([weaponKar98k state] || [weaponKar98Sniper state] || [weaponMp40 state] || [weaponMp44 state]);
    BOOL oneRUSSelected = ([weaponNagant state] || [weaponNagantSniper state] || [weaponPpsh state]);
    
    NSMutableString *message = [[NSMutableString alloc] init];
    
    [message setString:WEA_SELECTONE];
    
  //  if (!oneUSASelected) { [message appendString:
    
    if (oneUSASelected && oneBRITSelected && oneGERMANSelected && oneRUSSelected) {
        [weaponText setStringValue:@""];
    } else {
        [weaponText setStringValue:message];
    }
}

@end

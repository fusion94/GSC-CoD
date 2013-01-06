#import "LaunchController.h"
#import "MainController.h"
#import "DocController.h"
#import "PracticalSocket.h"
#import "define.h"
#import "messages.h"
#include <iostream> // For cout and cerr

@implementation LaunchController

- (void)awakeFromNib
{
    // hier moet een thread komen die op de YES gaat wachten
    // wait until the game has had enough time to launch
   // [NSThread sleepUntilDate:[[NSDate date] addTimeInterval:2]];
   // NSLog(@"Ik ben wakker");
}

- (IBAction)launchGame:(id)sender
{
    [self launchGameInit];
}

- (void)launchGameInit
// This method writes the config files and launches the game.
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    BOOL configSaved = NO; // check if config can be saved
    BOOL paramsSaved = NO; // check if parameters can be saved
    talkingFlag = NO;
    banListChanged = NO; // no-one is banned (yet)
    playerArray = [[NSMutableArray alloc] init];
    
    srand(time(NULL)); // set the randomizer
    [mainController checkServMess:self]; // correct the current server messages
    
    // set up the "change map" selection list
    [mapSelector removeAllItems];
    [mapSelector addItemWithTitle: MAN_SELECTMAP];
    [mapSelector addItemsWithTitles:[[mapsList stringValue] componentsSeparatedByString:@" "]];
    [mapSelectorButton setEnabled: NO];
    
    // set menu items
    [fileNewMenuItem setEnabled : NO];
    [fileOpenMenuItem setEnabled : NO];
    [quitMenuItem setEnabled: NO];
    [prefsMenuItem setEnabled: NO];
    [checkUpdateMenuItem setEnabled: NO];
    
    [killServerButton setEnabled:YES]; // disable the kill button

    if ([self gameProcessRuns]) { // the game already is running
        NSBeep();
        int button = NSRunAlertPanel(ALE_CANNOTLAUNCH1, ALE_CANNOTLAUNCH2, ALE_OKBUTTON, ALE_ONLINEHELP, nil);
        if (button == NSCancelButton) { // they chose for online help
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:HELP_QUIT_FIRST_URL]];
        }
    } else { // game is not yet running, let's launch
        // creating and writing the game parameters file
        NSMutableString *paramFilePath = [[NSMutableString alloc] initWithString:[[gameFolder stringValue] stringByAppendingString: PARAMFILENAME]]; // set the filename

        NSMutableString *paramFileContents = [[NSMutableString alloc] init];

        // see if it's a dedicated server
        if ([serverDedicated intValue] == 1) {
            [paramFileContents appendString:@"set dedicated 2\n"];
        } else {
            //[paramFileContents appendString:@"set dedicated 0\n"];
        }
        
        [paramFileContents appendString: GAMEPARAMETERS];

        if (![paramFileContents writeToFile:paramFilePath atomically:YES]) { // write the file
            NSBeep();
            int button = NSRunAlertPanel(ALE_CANNOTLAUNCH1, ALE_CANNOTLAUNCH4, ALE_OKBUTTON, ALE_ONLINEHELP, nil);
            if (button == NSCancelButton) { // they chose for online help
                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:HELP_SAVE_FILES_URL]];
            }
        } else { // save is successful
            paramsSaved = YES;
        }

        [paramFilePath release];
        [paramFileContents release];
    }

    // creating and writing the server cfg file
    if (paramsSaved) {
        NSMutableString *filePath = [[NSMutableString alloc] initWithString:[[gameFolder stringValue] stringByAppendingString: CONFIGFILENAME]]; // set the filename

        NSMutableString *fileContents = [[NSMutableString alloc] init];
        
        // hard coded items
        [fileContents appendString:CONFIG_HEADER1];
        [fileContents appendString:CONFIG_HEADER2];
        [fileContents appendString:@"seta sv_timeout 300\n"];
        [fileContents appendString:@"seta sv_fps 20\n"];

        // general tab items
        [fileContents appendString:[NSString stringWithFormat:@"set sv_hostname \"%@\"\n", [serverName stringValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_motd \"%@\"\n", [serverMotd stringValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"sets .Admin \"%@\"\n", [adminName stringValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"sets .Email \"%@\"\n", [adminEmail stringValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"sets .Website \"%@\"\n", [adminWebsite stringValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"sets .Location \"%@\"\n", [serverLocation stringValue]]];
		if ([serverDedicated intValue] == 1) {
            [fileContents appendString:@"set dedicated \"2\"\n"];
		}

        // network tab items
        [fileContents appendString:[NSString stringWithFormat:@"set net_port \"%d\"\n", [setNetPort intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set sv_master1 \"%@\"\n", [masterServer1 stringValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set sv_master2 \"%@\"\n", [masterServer2 stringValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set rconPassword \"%@\"\n", [setRconPass stringValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set g_password \"%@\"\n", [setServerPass stringValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set sv_privatePassword \"%@\"\n", [setPrivatePass stringValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set sv_maxclients \"%d\"\n", [setMaxPlayers intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set sv_privateClients \"%d\"\n", [setMaxPrivPlayers intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set sv_maxPing \"%d\"\n", [setMaxPing intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set sv_minPing \"%d\"\n", [setMinPing intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set g_allowVote \"%d\"\n", [allowVotes intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_vote \"%d\"\n", [allowVotes intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set sv_allowDownload \"%d\"\n", [allowDownload intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set sv_allowAnonymous \"%d\"\n", [allowAnonymous intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set logfile \"%d\"\n", [enableServerLog intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set g_log \"%@\"\n", [serverLogFile stringValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set sv_pure \"%d\"\n", [pureServer intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set sv_punkbuster \"%d\"\n", [enablePunkBuster intValue]]];

        // game tab items
        [fileContents appendString:[NSString stringWithFormat:@"set scr_dm_scorelimit \"%d\"\n", [dm_scoreLimit intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_dm_timelimit \"%d\"\n", [dm_timeLimit intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_tdm_scorelimit \"%d\"\n", [tdm_scoreLimit intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_tdm_timelimit \"%d\"\n", [tdm_timeLimit intValue]]];
        
        [fileContents appendString:[NSString stringWithFormat:@"set scr_sd_scorelimit \"%d\"\n", [sd_scoreLimit intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_sd_timelimit \"%d\"\n", [sd_timeLimit intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_sd_roundlength \"%d\"\n", [sd_roundLength intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_sd_roundlimit \"%d\"\n", [sd_roundLimit intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_sd_graceperiod \"%d\"\n", [sd_gracePeriod intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_bel_scorelimit \"%d\"\n", [bel_scoreLimit intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_bel_timelimit \"%d\"\n", [bel_timeLimit intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_bel_alivepointtime \"%d\"\n", [bel_alivePoint intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_re_scorelimit \"%d\"\n", [ret_scoreLimit intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_re_timelimit \"%d\"\n", [ret_timeLimit intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_re_roundlength \"%d\"\n", [ret_roundLength intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_re_roundlimit \"%d\"\n", [ret_roundLimit intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_re_graceperiod \"%d\"\n", [ret_gracePeriod intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_hq_scorelimit \"%d\"\n", [hq_scoreLimit intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_hq_timelimit \"%d\"\n", [hq_Timelimit intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_re_showcarrier \"%d\"\n", [showCarrier intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_drawfriend \"%d\"\n", [showAvatars intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_forcerespawn \"%d\"\n", [forceRespawn intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_spectateenemy \"%d\"\n", [setSpectateOwn intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"seta scr_teambalance \"%d\"\n", [setForceBalance intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"seta g_allowvote \"%d\"\n", [allowVotes intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set sv_cheats \"%d\"\n", [setAllowCheating intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_killcam \"%d\"\n", [enableKillCam intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_freelook \"%d\"\n", [allowFreeSpectate intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_friendlyfire \"%d\"\n", [[friendlyFire selectedItem] tag]]];
        
        // weapons tab items
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_bar \"%d\"\n", [weaponBar intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_bren \"%d\"\n", [weaponBren intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_enfield \"%d\"\n", [weaponEnfield intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_fg42 \"%d\"\n", [weaponFg42 intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_kar98k \"%d\"\n", [weaponKar98k intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_kar98ksniper \"%d\"\n", [weaponKar98Sniper intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_m1carbine \"%d\"\n", [weaponM1Carbine intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_m1garand \"%d\"\n", [weaponM1Garand intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_mp40 \"%d\"\n", [weaponMp40 intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_mp44 \"%d\"\n", [weaponMp44 intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_nagant \"%d\"\n", [weaponNagant intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_nagantsniper \"%d\"\n", [weaponNagantSniper intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_panzerfaust \"%d\"\n", [weaponPanzerfaust intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_ppsh \"%d\"\n", [weaponPpsh intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_springfield \"%d\"\n", [weaponSpingfield intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_sten \"%d\"\n", [weaponSten intValue]]];
        [fileContents appendString:[NSString stringWithFormat:@"set scr_allow_thompson \"%d\"\n", [weaponThompson intValue]]];

        // maps tab items
        [fileContents appendString:[NSString stringWithFormat:@"set sv_mapRotation \"%@\"\n", [mapRotation stringValue]]];
        
     //   NSArray *firstMapName = [[mapRotation stringValue] componentsSeparatedByString:@" "];
       // [fileContents appendString:[NSString stringWithFormat:@"set sv_mapRotationCurrentMap \"%@\"\n", [firstMapName objectAtIndex:3]]];

        // write the file
        if (![fileContents writeToFile:filePath atomically:YES]) {
            NSBeep();
            int button = NSRunAlertPanel(ALE_CANNOTLAUNCH1, ALE_CANNOTLAUNCH3, ALE_OKBUTTON, ALE_ONLINEHELP, nil);
            if (button == NSCancelButton) { // they chose for online help
                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString: HELP_SAVE_FILES_URL]];
            }
        } else { // save is successful
            configSaved = YES;
        }

        [filePath release];
        [fileContents release];
    }

    if (configSaved && paramsSaved) { // both files are OKAY! launch the server
        // set up the task launcher
        NSMutableString * gameAppName = [[NSMutableString alloc] initWithString:GAMEAPPNAME]; // game app file
        [gameAppName appendString:APPEXTENSION];
        NSString * openCommand = OPENCOMMAND; // open command
        double launchWaitTime = LAUNCHWAITTIME; // wait time to let the game launch

        NSString * currentFolder = [gameFolder stringValue]; // current gameFolder
        
        // game folder path including filename
        NSString * completeGamePath = [[NSMutableString alloc] initWithString: [currentFolder stringByAppendingString : gameAppName]];
        
        NSMutableArray * arguments = [NSMutableArray array]; // set the arguments
        [arguments addObject:completeGamePath];
        
        //NSLog(@"path: %@", completeGamePath);
        
        // here we are going to submit this server (signon) to the main GSC Server list
        if ([showInGSCServerList state]) {
            [self gscServerSignOn];
        }

        NSTask * myTask = [[NSTask alloc] init]; // set up to launch
        [myTask setCurrentDirectoryPath: currentFolder];
        [myTask setLaunchPath: openCommand];
        [myTask setArguments: arguments];

        // launch the game
//        NSLog(@"------------- LAUNCH-------------");
        [spinner startAnimation:self]; // start the progress indicator (spinner)
        [statusMessage setStringValue:GEN_LAUNCHING]; // set statusmessage
        [launchButton setEnabled: NO]; // disable the launch button
        [launchMenuItem setEnabled : NO]; // disable the launch menu item
        [serverDedicated setEnabled : NO]; // disable the dedicated switch
        [myTask launch]; // launches the game
        [myTask waitUntilExit]; // waits until open command has finished

        // wait until the game has had enough time to launch
        [NSThread sleepUntilDate:[[NSDate date] addTimeInterval:launchWaitTime]];

        // start the polling thread
        [NSThread detachNewThreadSelector:@selector(launchGameThread) toTarget:self withObject:nil];

        // release stuff
        [myTask release];
    }
    
    [pool release];
}

- (void)launchGameThread
// This method does a looped check if the game runs, and polls the server for info.
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    // the polling starts here
    int pollCounter = 0;
    BOOL gameHasLaunched = NO;
    BOOL gameHasTerminated = NO;

 //   NSLog(@"-------------POLLS FOR START-------------");
    // start polling until game has launched
    while ((!gameHasLaunched) && (pollCounter < MAXSTARTPOLLS)) {
        pollCounter++;
        [NSThread sleepUntilDate:[[NSDate date] addTimeInterval:POLLWAITTIME]];
        if ([self gameProcessRuns]) {
            gameHasLaunched = YES;
        }
    }

    if (gameHasLaunched) { // the game is running, now poll until terminate
 //       NSLog(@"-------------RUNNING & POLLING FOR EXIT-------------");
        [statusMessage setStringValue:GEN_RUNNING]; // set statusmessage
        [spinner stopAnimation:self]; // stop the progress indicator

        [manServerName setStringValue:[serverName stringValue]]; // set servername
        [manServerStatus setStringValue:[statusMessage stringValue]]; // set statusmessage
        [self showManagementWindow]; // open the management window

        // start polling until game has terminated
        NSDate *pollDate = [NSDate dateWithTimeIntervalSinceNow: RUNPOLLWAITTIME];
        NSDate *messageDate = [NSDate dateWithTimeIntervalSinceNow: ([servMessTime intValue] * 60)];
        NSDate *messageLineDate = [NSDate dateWithTimeIntervalSinceNow: ([servMessTime intValue] * 60)];
        NSDate *heartBeatDate = [NSDate dateWithTimeIntervalSinceNow: HEARTBEATTIME];

        [currentServMess setStringValue:MAN_WAITMESSAGE];
        // settings for the server messages
        NSMutableArray *servMessLines = [[servMessText stringValue] componentsSeparatedByString:@"\n"]; // message lines
        [servMessLines addObject:SERVMESSGREETING];
        NSMutableString *currentLine = [[NSMutableString alloc] init];
        NSEnumerator *e = [servMessLines objectEnumerator];
        NSNumber *cur;
        unsigned int c=0;
        NSMutableString *lineCommand = [[NSMutableString alloc] init];
        NSMutableString *serverResponse = [[NSMutableString alloc] init];
        
        while (!gameHasTerminated) {
            // sleep for a second
            [NSThread sleepUntilDate:[[NSDate date] addTimeInterval:1]];

            if ([self gameProcessRuns]) { // while the game still runs
                if ([pollDate timeIntervalSinceDate:[NSDate date]] < 0) { // is it time to poll?
                  //  NSLog(@"POLLING NOW!");
                    [self pollServer];
                    pollDate = [[NSDate date] addTimeInterval: RUNPOLLWAITTIME];
                    
                    // autokick if necessary
                    if ([enableAutoKick intValue] == 1) {
                        [self autoKickPlayers]; // auto kick players
                    }
                    
                    // do leading player message if necessary
                    if (([leadMessEnabled state]) && ([playerArray count] > 0)) {
                        // NSLog(@"Checking lead player...");
                        // check if not everyone has the same score
                        unsigned int lead;
                        int bestScore = [[[playerArray objectAtIndex:0] objectAtIndex:2] intValue];
                        BOOL otherScoresFound = NO;
                        for (lead = 0; lead < [playerArray count]; lead++) {
                            if ([[[playerArray objectAtIndex:lead] objectAtIndex:2] intValue] != bestScore) {
                                otherScoresFound = YES;
                            }
                        }
                        
                        // if other scores are found, find the best and worst player(s)
                        if (otherScoresFound) {
                            //NSLog(@"Other scores found!");
                            // find best player(s)
                            NSMutableString *bestPlayer = [[NSMutableString alloc] init];
                            [bestPlayer setString:[[playerArray objectAtIndex:0] objectAtIndex:3]];
                            int playerCount = 1;
                            for (lead = 1; lead < [playerArray count]; lead++) {
                                if ([[[playerArray objectAtIndex:lead] objectAtIndex:2] intValue] == bestScore) {
                                    [bestPlayer appendString:@" & "]; // append the name
                                    [bestPlayer appendString:[[playerArray objectAtIndex:lead] objectAtIndex:3]];
                                    playerCount++;
                                }
                            }
                            if ((playerCount == 3) || (playerCount == 2)) { // 2 or 3 best
                                //NSLog(@"Messaging...");
                                [self talkToServer:[NSString stringWithFormat:GAM_LEADPLAYER2, bestPlayer, bestScore] reply:YES];
                            } else {
                                if (playerCount == 1) { // the leader
                                                        //NSLog(GAM_LEADPLAYER1, bestPlayer, bestScore);
                                    [self talkToServer:[NSString stringWithFormat:GAM_LEADPLAYER1, bestPlayer, bestScore] reply:YES];
                                }
                            }
                            
                            // find worst player(s)
                            NSMutableString *worstPlayer = [[NSMutableString alloc] init];
                            [worstPlayer setString:[[playerArray objectAtIndex:[playerArray count]-1] objectAtIndex:3]];
                            int worstScore = [[[playerArray objectAtIndex:[playerArray count]-1] objectAtIndex:2] intValue];
                            playerCount = 1;
                            for (lead = 0; lead < [playerArray count]-1; lead++) {
                                if ([[[playerArray objectAtIndex:lead] objectAtIndex:2] intValue] == worstScore) {
                                    [worstPlayer appendString:@" & "]; // append the name
                                    [worstPlayer appendString:[[playerArray objectAtIndex:lead] objectAtIndex:3]];
                                    playerCount++;
                                }
                            }
                            if ((playerCount == 3) || (playerCount == 2)) { // 2 or 3 worst
                                //NSLog(@"Messaging...");
                                [self talkToServer:[NSString stringWithFormat:GAM_LASTPLAYER2, worstPlayer, worstScore] reply:YES];
                            } else {
                                if (playerCount == 1) { // the worst!
                                    //NSLog(@"Messaging...");
                                    [self talkToServer:[NSString stringWithFormat:GAM_LASTPLAYER1, worstPlayer, worstScore] reply:YES];
                                }
                            }
                        } // otherScoresFound=NO, the scores are TIED!
                    }
                }
                
                // do server messages if necessary
                if ([servMessEnabled state]) {
                    if ([messageDate timeIntervalSinceDate:[NSDate date]] < 0) {
                        if ([messageLineDate timeIntervalSinceDate:[NSDate date]] < 0) {
                            if (cur = (NSNumber *)[e nextObject]) { // next line
                                [currentLine setString:[servMessLines objectAtIndex:c++]];
                        //        NSLog(@"line: %@", currentLine);
                                if ([currentLine length] > 0) {
                                    if (![currentLine isEqualToString:SERVMESSGREETING]) {
                                        [currentServMess setStringValue: currentLine];
                                    }
                                    // SEND THE LINE HERE
                                    [lineCommand setString:@"say "];
                                    [lineCommand appendString: currentLine];

                                    // send the command
                                    [serverResponse setString:[self talkToServer:lineCommand reply:YES]];
                                    messageLineDate = [messageLineDate addTimeInterval: [servMessWait intValue]]; // set a new time
                                }
                            } else { // no more lines
                                // set new message times
                                messageDate = [[NSDate date] addTimeInterval: ([servMessTime intValue] * 60)];
                                messageLineDate = [[NSDate date] addTimeInterval: ([servMessTime intValue] * 60)];
                                // reset the message enumerator
                                c=0;
                                e = [servMessLines objectEnumerator];
                            }
                        }
                    }
                }
                
                // send a heartbeat to the GSC server if necessary
                if ([heartBeatDate timeIntervalSinceDate:[NSDate date]] < 0) {
                    [self gscServerSignOn];
                    heartBeatDate = [[NSDate date] addTimeInterval: HEARTBEATTIME];
                }
            } else {  // the process is gone
                gameHasTerminated = YES;
            }
        }
    }

    // the game app has terminated
//    NSLog(@"-------------TERMINATED-------------");
    [self hideManagementWindow]; // close the management window
    
    [spinner stopAnimation:self]; // stop the progress indicator
    [launchButton setEnabled: YES]; // enable the launch button
    [launchMenuItem setEnabled : YES]; // enable the launch menu item
    [serverDedicated setEnabled : YES]; // enable the dedicated switch
    
    // set menu items
    [fileNewMenuItem setEnabled : YES];
    [fileOpenMenuItem setEnabled : YES];
    [quitMenuItem setEnabled: YES];
    [prefsMenuItem setEnabled: YES];
    [checkUpdateMenuItem setEnabled: YES];

    // remove the params config and server config files
    NSMutableString *parameterFilePath = [[NSMutableString alloc] initWithString:[[gameFolder stringValue] stringByAppendingString: PARAMFILENAME]]; // set the params filename
    NSMutableString *configFilePath = [[NSMutableString alloc] initWithString:[[gameFolder stringValue] stringByAppendingString: CONFIGFILENAME]]; // set the config filename

    NSFileManager * manager = [NSFileManager defaultManager];
    [manager removeFileAtPath:parameterFilePath handler:nil]; // remove paramfile
    [manager removeFileAtPath:configFilePath handler:nil]; // remove configfile
    
    // here we are going to submit this server (signoff) to the main GSC Server list
    if ([showInGSCServerList state]) {
        [self gscServerSignOff];
    }

    [statusMessage setStringValue:GEN_NOTRUNNING]; // set statusmessage
    
    if (banListChanged) {
        [docController getBanlistFromBanlistString]; // save the new banliststring if there was a ban
    }
    
    [mainController updateApplicationBadge:0]; // remove the player count in the dock icon
    
    [pool release];
}

- (BOOL)gameProcessRuns
// checks the process list to check if game is running
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableString * gameAppName = [[NSMutableString alloc] initWithString:GAMEAPPNAME]; // game app file
    [gameAppName appendString:APPEXTENSION];
    
    // fill the array dictionary with list of running applications
    NSArray * appArray=[[NSWorkspace sharedWorkspace] launchedApplications];
    NSString * currentFolder = [gameFolder stringValue]; // current gameFolder
    NSString * completeGamePath = [currentFolder stringByAppendingString : gameAppName]; // game folder path including filename
    
    NSEnumerator * appEnumerator = [appArray objectEnumerator];
    NSDictionary * dict;
    NSEnumerator * dictEnumerator;
    id appDict;
    unsigned counter = 0;
    BOOL gameIsRunning = NO;

    // traverse array to find our gameAppName
    while (appDict = [appEnumerator nextObject]) {
        dict = [appArray objectAtIndex:counter];
        dictEnumerator = [dict keyEnumerator];

        NSString * test = [[dict objectForKey:@"NSApplicationPath"] description];
        
        if ([test isEqualToString:completeGamePath]) {
            gameIsRunning = YES; // the game app is running
        }
        counter++;
    }
    
    [pool release];
    return gameIsRunning;
}

- (IBAction)manKickPlayer:(id)sender
// This method kicks the selected player from the server
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    int n = [playerTable numberOfSelectedRows]; // number of selected rows

    if (n == 1) { // a player was selected
        NSEnumerator *e = [playerTable selectedRowEnumerator];
        NSNumber *cur;

        while (cur = (NSNumber *)[e nextObject]) { // traverse the selection
            NSMutableArray *aPlayer = [playerArray objectAtIndex:[cur intValue]];
            int playerNumber = [[aPlayer objectAtIndex:0] intValue];
            NSString *clientNumber = [NSString stringWithFormat:@"%d", playerNumber];
            NSMutableString *kickCommand = [[NSMutableString alloc] initWithString:@"clientkick "];
            [kickCommand appendString:clientNumber];

//            NSLog(@"kick: %@", kickCommand);

            // send the kick command
            // send the kick command
            [self talkToServer:[NSString stringWithFormat:GAM_USERKICKED, [aPlayer objectAtIndex:3]] reply:YES]; // tell the players
            [self talkToServer:kickCommand reply:YES];
            
            //NSMutableString *serverResponse = [self talkToServer:kickCommand reply:YES];
            //NSLog(@"response: %@", serverResponse);
            
            // do not remove players from the list because auto-kick may be using the list right now! instead, alter the name
            [aPlayer replaceObjectAtIndex:3 withObject:MAN_KICKEDPL];
            // wait a second for dramatic effect
            [NSThread sleepUntilDate:[[NSDate date] addTimeInterval:0.5]];
            [playerTable reloadData];
            
            [self pollServer];

            [kickCommand release];
        }
    }
    
    [pool release];
}

- (IBAction)manBanPlayer:(id)sender
    // this method bans the selected player(s) from the server.
{   
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    int n = [playerTable numberOfSelectedRows]; // number of selected rows
    
    if (n == 1) { // one or more players were selected
        NSEnumerator *e = [playerTable selectedRowEnumerator];
        NSNumber *cur;
        
        while (cur = (NSNumber *)[e nextObject]) { // traverse the selection
            NSArray *aPlayer = [playerArray objectAtIndex:[cur intValue]];
            NSString *currentIP = [[NSString alloc] initWithString:[[playerArray objectAtIndex:[cur intValue]] objectAtIndex:4]];
            NSMutableString *currentBanList = [[NSMutableString alloc] initWithString:[bannedListString stringValue]];
            
            if (![currentIP isEqualToString:@"IP Error"]) {
                NSBeep();
                int button = NSRunAlertPanel([NSString stringWithFormat:ALE_BANTHISPLAYER1, currentIP], [NSString stringWithFormat:ALE_BANTHISPLAYER2, [aPlayer objectAtIndex:3]], ALE_OKBUTTON, ALE_CANCELBUTTON, nil);
                if (button == NSOKButton) { // yes, save it
                    banListChanged = YES;
                    [self talkToServer:[NSString stringWithFormat:GAM_USERBANNED, [aPlayer objectAtIndex:3]] reply:YES]; // tell the players
                    [manServerStatus setStringValue: [NSString stringWithFormat: MAN_PLAYERBANNED, [aPlayer objectAtIndex:3]]]; // set statusmessage
                    [manServerStatus setTextColor: [NSColor blueColor]]; // set color
                    
                    //NSLog(@"Banlist before: %@", [bannedListString stringValue]);
                    if ([currentBanList length] > 0) {
                        [currentBanList appendString:@" "]; // only append a space if the string is not empty
                    }
                    [currentBanList appendString:currentIP];
                    [bannedListString setStringValue:currentBanList];
                    //NSLog(@"Banlist after: %@", [bannedListString stringValue]);
                }
            } else {
                // Ip error, or it is a bot
                //NSLog (@"IP error!");
            }
        }
    }
    
    [pool release];
}

- (void)autoKickPlayers
    // this method auto kicks all players that are in the banlist (by IP)
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    NSEnumerator *e = [playerArray objectEnumerator];
    NSNumber *cur;
    unsigned int c=0;
    
    // put the banned string into an array
    NSArray *bannedIPs = [[bannedListString stringValue] componentsSeparatedByString:@" "];
    
    while (cur = (NSNumber *)[e nextObject]) { // traverse the playerlist
        NSString *currentIP = [[NSString alloc] initWithString:[[playerArray objectAtIndex:c] objectAtIndex:4]];
        //NSLog(@"Player IP: %@", currentIP);
        
        NSEnumerator *f = [bannedIPs objectEnumerator];
        NSNumber *thisone;
        unsigned int d=0;
        
        while (thisone= (NSNumber *)[f nextObject]) { // traverse the banned IP list
            // NSLog(@"current IP: %@, list IP: %@", currentIP, [bannedIPs objectAtIndex:d]);
            if ([[bannedIPs objectAtIndex:d] isEqualToString:currentIP]) { // is the IP banned?
                NSMutableArray *aPlayer = [playerArray objectAtIndex:c];
                NSMutableString *kickCommand = [[NSMutableString alloc] initWithString:@"clientkick "];
                [kickCommand appendString:[NSString stringWithFormat:@"%d", [[aPlayer objectAtIndex:0] intValue]]];
                
                //NSLog(@"Autokick: %@", kickCommand);
                
                // send the kick command
                [manServerStatus setStringValue: [NSString stringWithFormat: MAN_AUTOKICKED, [aPlayer objectAtIndex:3]]]; // set statusmessage
                [manServerStatus setTextColor: [NSColor blueColor]]; // set color
                [self talkToServer:[NSString stringWithFormat:GAM_AUTOKICKED, [aPlayer objectAtIndex:3], currentIP] reply:YES]; // tell the players
                [self talkToServer:kickCommand reply:YES];
                
                // do not remove players from the list because auto-kick may be using the list right now! instead, alter the name
                [aPlayer replaceObjectAtIndex:3 withObject:MAN_AUTOKICKEDPL];
                [playerTable reloadData];
            }
            d++;
        }
        c++;
    }
    
    [pool release];
}

- (IBAction)changeMap:(id)sender
    // changes current map
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableString *mapCommand = [[NSMutableString alloc] initWithString:@"map "];
    [mapCommand appendString:[mapSelector titleOfSelectedItem]];
    [self talkToServer:mapCommand reply:YES]; // do it
    
    [pool release];
}

- (IBAction)changeMapButtonControl:(id)sender
    // disables and enables "change map" button
{
    if ([mapSelector indexOfSelectedItem] >= 1) { // skip the first item
        [mapSelectorButton setEnabled: YES];
    } else {
        [mapSelectorButton setEnabled: NO];
    }
}

- (IBAction)rconCommand:(id)sender
// This method sends an rconcommand to the server
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableString *currentCommand = [[NSMutableString alloc] initWithString:[rconCommandText stringValue]];

    //NSLog(@"rcon: %@", currentCommand);

    if ([currentCommand length] > 0) {
        if ([currentCommand hasPrefix:@"/"]) { // it is an rcon command
            // send the command minus the "/"
            [self talkToServer:[currentCommand substringWithRange:NSMakeRange(1, [currentCommand length]-1)] reply:YES];
            [self pollServer];
        } else { // they are chatting
            // say the line
            NSMutableString *talkCommand = [[NSMutableString alloc] initWithString:@"say "];
            [talkCommand appendString:[rconCommandText stringValue]];
            [self talkToServer:talkCommand reply:YES];
        }
    }

    [pool release];
}

-(void)pollServer
// This method polls the server and extracts the necessary info
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];

    // request statusinfo from server
    NSMutableString *serverResponse = [self talkToServer:@"status" reply:YES];
        
    // analyze the output lines and look for map filename and map name
    NSArray *rxLines = [serverResponse componentsSeparatedByString:@"\n"]; // output lines
    if ([rxLines count] > 0 ) { // there are output lines
        NSEnumerator *e = [rxLines objectEnumerator];
        NSNumber *cur;
        unsigned int c=0;
        [playerArray removeAllObjects]; // clear the player list

        while (cur = (NSNumber *)[e nextObject]) { // traverse the lines
            NSString * currentLine = [rxLines objectAtIndex:c++];
            int lineLen = 0; // for correcting shorter lines
            //NSLog(@"line %d: %@", c, currentLine);

            if (c == 2) { // get the current map
                NSArray *mapNameLine = [currentLine componentsSeparatedByString:@": "];
                [manCurrentMap setStringValue:[mapNameLine objectAtIndex:1]];
            }
            
            if ((c > 4) && (c < ([rxLines count]-1))) { // only take middle lines
                NSMutableArray *aPlayer = [[NSMutableArray alloc] init];
                //num
                [aPlayer addObject:[currentLine substringWithRange:NSMakeRange(0, 3)]];
                //ping
                [aPlayer addObject:[currentLine substringWithRange:NSMakeRange(10, 4)]];
                //score
                [aPlayer addObject:[currentLine substringWithRange:NSMakeRange(4, 5)]];
                //name
                lineLen = (STATUSLINELEN-[currentLine length]-1); // this corrects names longer than 15 chars
                [aPlayer addObject:[currentLine substringWithRange:NSMakeRange(22, (15-lineLen))]]; // player name
                //[aPlayer addObject:[self cleanPlayerName:[currentLine substringWithRange:NSMakeRange(22, ([currentLine length]-22))]]];
                
                // The Player IP is found by reading the line backwards until a colon was found.
                // Left of the colon is the IP, right of the colon is the Port number.
                NSMutableString *playerIP = [[NSMutableString alloc] initWithString:@"0.0.0.0"];
                int c = [currentLine length];
                int colonpos = 0;
                BOOL found = NO;
                while ((!found) && (c-- > 15)) {
                    if ([currentLine characterAtIndex: c] == ':') {
                        found = YES;
                        colonpos = c;
                        //NSLog(@"Found \':\' in player name at: %d", c);
                    }
                }
                
                if (found) { // player IP can be found
                    // read backwards until a space and then we're at the beginning of the IP string
                    c = colonpos;
                    found = NO;
                    while ((!found) && (c-- > 15)) {
                        if ([currentLine characterAtIndex: c] == ' ') {
                            found = YES;
                            //NSLog(@"Found \' \' in player name at: %d", c);
                            [playerIP setString:[currentLine substringWithRange:NSMakeRange(c+1, colonpos-c-1)]];
                            //NSLog(@"Player IP: %@", playerIP);
                        }
                    }
                } else {
                    [playerIP setString:@"IP Error"];
                }
                
                [aPlayer addObject:playerIP]; // add player IP.
                
                // insert player at correct position, sorted by score
                unsigned int s;
                BOOL added = NO;
                for (s = 0; s < [playerArray count]; s++) {
                    if ([[[playerArray objectAtIndex:s] objectAtIndex:2] intValue] <= [[aPlayer objectAtIndex:2] intValue]) {
                        [playerArray insertObject:aPlayer atIndex:(s)];
                        NSLog(@"loop add: %@", [aPlayer objectAtIndex:3]);
                        added = YES;
                        break; // kill the loop
                    }
                }
                if (!added) { // if it has not been added yet by the sortloop
                    [playerArray addObject:aPlayer]; // add player to the list
                    //NSLog(@"appended: %@", [aPlayer objectAtIndex:3]);
                }
                
                [aPlayer release];
            }
        }
        
        /************************************************************************
         random player generator for testing purposes BEGIN
        *************************************************************************
        int i;
        double rndnum=rand() / (double)RAND_MAX * MAXAUTOGENPLYR;
        
        for (i=0; i<rndnum; i++) {
            NSMutableArray *aPlayer = [[NSMutableArray alloc] init];
            [aPlayer addObject:[NSString stringWithFormat:@"%d", i+65]];
            [aPlayer addObject:@"---"];
            double rnd=rand() / (double)RAND_MAX * 25;
            [aPlayer addObject:[NSString stringWithFormat:@"%d", (int) rnd]];
            [aPlayer addObject:[NSString stringWithFormat:@"Autogen %d", i+100]];
            [aPlayer addObject:@"IP Error"];
            [playerArray addObject:aPlayer];
        }
        /************************************************************************
            random player generator for testing purposes END
            *************************************************************************/
        
        
        
        [playerTable reloadData];
        NSString *playerCount = [NSString stringWithFormat:@"%d", [playerArray count]];
        [noOfPlayers setStringValue:playerCount];
        [mainController updateApplicationBadge:[playerArray count]];
    }
    
    [pool release];
}

- (NSString *)cleanPlayerName:(NSString *)name
// this method cleans the player name (eg. remove colors etc)
{
    NSMutableString *cleanName = [[NSMutableString alloc] init];
    [cleanName setString:name];
    
    [cleanName replaceOccurrencesOfString:@"^1" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [cleanName length])];
    [cleanName replaceOccurrencesOfString:@"^2" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [cleanName length])];
    [cleanName replaceOccurrencesOfString:@"^3" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [cleanName length])];
    [cleanName replaceOccurrencesOfString:@"^4" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [cleanName length])];
    [cleanName replaceOccurrencesOfString:@"^5" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [cleanName length])];
    [cleanName replaceOccurrencesOfString:@"^6" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [cleanName length])];
    [cleanName replaceOccurrencesOfString:@"^7" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [cleanName length])];
    [cleanName replaceOccurrencesOfString:@"^8" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [cleanName length])];
    [cleanName replaceOccurrencesOfString:@"^9" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [cleanName length])];
    [cleanName replaceOccurrencesOfString:@"^0" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [cleanName length])];
    
    // player name is max 15 chars
    return cleanName;
}

- (NSString *)talkToServer:(NSString *)command reply:(BOOL)wantReply
// this method makes a UDP socket to the server and talks to it
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];

    if (!talkingFlag) { // make sure we are not already doing this
//        NSLog(@"Talking...");
        talkingFlag = YES;
        using namespace std;
        const int ECHOMAX = 2048; // Longest string to echo
        string servAddress = "localhost"; // Server address
        unsigned short echoServPort = [setNetPort intValue]; // server port

        // set the string for the rcon command
        NSMutableString *rconString = [[NSMutableString alloc] initWithString:@"\xFF\xFF\xFF\xFF\x02rcon "];
        [rconString appendString:[setRconPass stringValue]];
        [rconString appendString:@" "];
        [rconString appendString:command];
        [rconString appendString:@"\n"];

        const char *echoString = [rconString cString]; // put it in a C-string
        int echoStringLen = strlen(echoString);  // Length of string to echo
        NSMutableString *rxString = [[NSMutableString alloc] init]; // the receive string

        try {
            UDPSocket sock;

            // Send the string to the server
            sock.sendTo(echoString, echoStringLen, servAddress, echoServPort);

            if (wantReply) {
                // Receive a response
                char echoBuffer[ECHOMAX + 1]; // Buffer for echoed string + \0
                int respStringLen = sock.recv(echoBuffer, ECHOMAX); // Length of received response
                if (respStringLen == 0) {
                    NSLog(UDP_NOREPLY);
                }

                echoBuffer[respStringLen] = '\0'; // Terminate the string.
                [rxString setString:[NSString stringWithCString:echoBuffer]]; // put it in a NSString
            } else {
                [rxString setString:UDP_NOREPLY];
            }

        // Destructor closes the socket
        } catch (SocketException &e) {
            cerr << e.what() << endl;
            NSLog(UDP_NOCONNECT);
        }

        // wait a second to prevent another connection to interfere
        [NSThread sleepUntilDate:[[NSDate date] addTimeInterval:1]];
        
        talkingFlag = NO;
        return rxString;
    } else {
       // NSLog(@"Cannot talk now...");
        return @" "; // return an empty string
    }
    
    [pool release];
}

- (void)showManagementWindow
// this method shows the management window and closes the mainwindow
{
    [managementWindow orderFront:self];
    [mainWindow orderOut:self];
}

- (void)hideManagementWindow
// this method hides the management window and shows the mainwindow
{
    [mainWindow orderFront:self];
    [noOfPlayers setStringValue:MAN_WAITFORSTART];
    [manCurrentMap setStringValue:MAN_WAITFORSTART];
    [managementWindow orderOut:self];
}

- (IBAction)quitGame:(id)sender
{
    if ([noOfPlayers intValue] != 0) {
        NSBeep();
        int button = NSRunAlertPanel(ALE_PLAYERSCNNCT1, ALE_PLAYERSCNNCT2, ALE_CANCELBUTTON, ALE_OKBUTTON, nil);
        
        if (button == NSCancelButton) { // they chose for OK
            [killServerButton setEnabled:NO]; // disable the kill button
            [manServerStatus setStringValue: MAN_GOINGDOWN]; // set statusmessage
            [self talkToServer:@"quit" reply:NO];
        }
    } else { // there are no players, just quit
        [killServerButton setEnabled:NO]; // disable the kill button
        [manServerStatus setStringValue: MAN_GOINGDOWN]; // set statusmessage
        [self talkToServer:@"quit" reply:NO];
    }
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView
// just returns the number of items we have for table
{
    return [playerArray count];
}

// connect the tableview to the correct array
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
    NSString *column = [tableColumn identifier];
    if ([playerArray count] > 0) {
        return [[playerArray objectAtIndex:row] objectAtIndex:[column intValue]];
    } else {
        return 0;
    }
}

- (void)gscServerSignOn
    // signs our game on to the GSC main serverlist
{
    NSMutableString *signOnString = [[NSMutableString alloc] init];
    [signOnString setString:[NSString stringWithFormat:GSC_SERV_SIGNON, [preferences objectForKey:@"serverID"], [serverName stringValue], [adminName stringValue], VERSIONDICTKEY, [serverLocation stringValue], [setNetPort intValue]]];
    NSString * escapedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)signOnString, NULL, NULL, kCFStringEncodingISOLatin1);
    //NSLog(@"Signing on at the main GSC server...\n%@", escapedString);
    
    // connect to the web and get the XML reply
    NSDictionary *mainServerReply = [NSDictionary dictionaryWithContentsOfURL: [NSURL URLWithString:escapedString]];
    NSString *success = [mainServerReply valueForKey:@"success"];
    NSString *srvid = [mainServerReply valueForKey:@"id"];
    
    if (success == nil) { // no xml file could be found
    //NSLog(@"No connection with the main GSC server for signing on!");
    } else { // we have a reply
        // NSLog(@"Reply: %@", mainServerReply);
        if ([success isEqualToString:@"yes"]) { // the submit was successful
            [preferences setObject:srvid forKey:@"serverID"]; // put it in user prefs
            //NSLog(@"GSC main server submit was succesful, server ID = %@.", srvid);
        } else { // we have a non-succesful submit
            [preferences setObject:@"" forKey:@"serverID"]; // empty the serverID in user prefs
            //NSLog(@"GSC main server submit has failed!");
        }
    }
}

- (void)gscServerSignOff
    // signs our game off in the GSC main serverlist
{
    NSMutableString *signOnString = [[NSMutableString alloc] init];
    [signOnString setString:[NSString stringWithFormat:GSC_SERV_SIGNOFF, [preferences objectForKey:@"serverID"], [serverName stringValue], [adminName stringValue], VERSIONDICTKEY, [serverLocation stringValue], [setNetPort intValue]]];
    NSString * escapedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)signOnString, NULL, NULL, kCFStringEncodingISOLatin1);
    //NSLog(@"Signing off at the main GSC server...\n%@", escapedString);
    
    // connect to the web and get the XML reply
    NSDictionary *mainServerReply = [NSDictionary dictionaryWithContentsOfURL: [NSURL URLWithString:escapedString]];
    NSString *success = [mainServerReply valueForKey:@"success"];
    
    if (success == nil) { // no xml file could be found
        // NSLog(@"No connection with the main GSC server for signing off!");
    } else { // we have a reply
             // NSLog(@"Reply: %@", mainServerReply);
        if ([success isEqualToString:@"yes"]) { // the submit was successful
                                                // NSLog(@"GSC main server submit was succesful, server ID = %@.", [mainServerReply valueForKey:@"id"]);
        } else { // we have a non-succesful submit
            [preferences setObject:@"" forKey:@"serverID"]; // empty the serverID in user prefs
                                                            // NSLog(@"GSC main server submit has failed!");
        }
    }
}

@end

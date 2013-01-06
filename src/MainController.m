#import "MainController.h"
#import "define.h"
#import "messages.h"

@implementation MainController

- (IBAction)paypalDonate:(id)sender
{
    // launch the URL for donating through paypal
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:PAYPAL_DONATE_URL]];
}

- (IBAction)launchHelpURL:(id)sender
{
    // launch the URL for the online manual
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:ONLINE_MANUAL_URL]];
}

- (IBAction)showAboutBox:(id)sender
{
    NSString *currVersionNumber = GSC_VERSION; // the version of this app
    NSMutableString * versionText = [[NSMutableString alloc] initWithString:ABO_VERS];
    [versionText appendString:currVersionNumber];
    [versionText appendString:COPYRIGHT_TEXT];
    [versionString setStringValue:versionText];
    [titleString setStringValue:GSC_TITLE];
    [expiryString setStringValue:[NSString stringWithFormat:ABO_EXPIRY_DATE, EXPIRYDATETXT]];
    
    [aboutBox center];
    [aboutBox makeKeyAndOrderFront:sender];
}

- (void)updateApplicationBadge:(int)number
    // this method displays a badge in the application's dock icon with the number in it.
    // use zero to remove the badge, numbers over 40 will generate ">40" icon
{
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    NSImage *appImage, *newAppImage, *badge;
    NSSize newAppImageSize;
    
    // Grab the unmodified application image.
    appImage = [[NSImage alloc] initWithContentsOfFile:[thisBundle pathForResource:APPICONIMAGE ofType:@""]];
    
    // create the new image
    newAppImageSize = NSMakeSize(128, 128);
    newAppImage = [[NSImage alloc] initWithSize:newAppImageSize];
    
    // Draw into the new image (the badged image)
    [newAppImage lockFocus];
    
    // First draw the unmodified app image.
    [appImage drawInRect:NSMakeRect(0, 0, newAppImageSize.width, newAppImageSize.height)
                fromRect:NSMakeRect(0, 0, [appImage size].width, [appImage size].height)
               operation:NSCompositeCopy fraction:1.0];
    
    // Now draw the badge if the number is higher than 0.
    if (number > 0) {
        if (number <= 40) {
            badge = [[NSImage alloc] initWithContentsOfFile:[thisBundle pathForResource:[NSString stringWithFormat:@"badge%d.gif", number] ofType:@""]];
        } else {
            badge = [[NSImage alloc] initWithContentsOfFile:[thisBundle pathForResource:@"badge_over_40.gif" ofType:@""]];
        }
        [badge drawInRect:NSMakeRect(78, 4, 47, 48) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    }
    
    [newAppImage unlockFocus];
    
    // Set the new icon: a badged icon.
    [NSApp setApplicationIconImage:newAppImage];
    [newAppImage release];
}

- (IBAction)checkForUpdate:(id)sender
    // check for online updates
{
    NSString *currAppName = GSC_APPNAME; // the name of this app
    NSString *currVersionNumber = GSC_VERSION; // the version of this app
    
    // get the version info from the web
    NSDictionary *productVersionDict = [NSDictionary dictionaryWithContentsOfURL:
        [NSURL URLWithString:VERSION_CHECK_URL]];
    NSString *latestVersionNumber = [productVersionDict valueForKey:VERSIONDICTKEY];
    
    if (latestVersionNumber == nil) { // no xml file could be found
        NSBeep();
        NSRunAlertPanel(ALE_NOUPDATECHECK1, ALE_NOUPDATECHECK2, ALE_ILLCHECKLATER, nil, nil);
    } else {
        if([latestVersionNumber isEqualToString: currVersionNumber]) { // software is up to date
            NSRunAlertPanel(ALE_NOUPDATEFOUND1, [NSString stringWithFormat: ALE_NOUPDATEFOUND2, currVersionNumber, currAppName], ALE_OKBUTTON, nil, nil);
        } else { // tell user to download a new version
            int button = NSRunAlertPanel(ALE_NEWVERSFOUND1, [NSString stringWithFormat: ALE_NEWVERSFOUND2, latestVersionNumber], ALE_YESBUTTON, ALE_NOBUTTON, nil);
            if (button == NSOKButton) {
                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:DOWNLOAD_NEW_URL]];
            }
        }
    }
}

- (IBAction)setSliderBars:(id)sender
// this method sets the sliders when a textbox is edited, and checks if textbox value is valid
{
    // network tab items
    if ([[setMaxPlayers stringValue] length] == 0) { [setMaxPlayers setIntValue:8]; }
    if ([[setMaxPrivPlayers stringValue] length] == 0) { [setMaxPrivPlayers setIntValue:2]; }
    if ([[setMinPing stringValue] length] == 0) { [setMinPing setIntValue:0]; }
    if ([[setMaxPing stringValue] length] == 0) { [setMaxPing setIntValue:0]; }
    if ([[setNetPort stringValue] length] == 0) { [setNetPort setStringValue:@"28960"]; }

    // server tab items

    // game tab items
    if ([[dm_scoreLimit stringValue] length] == 0) { [dm_scoreLimit setIntValue:0]; }
    if ([[dm_timeLimit stringValue] length] == 0) { [dm_timeLimit setIntValue:0]; }
    if ([[tdm_scoreLimit stringValue] length] == 0) { [tdm_scoreLimit setIntValue:0]; }
    if ([[tdm_timeLimit stringValue] length] == 0) { [tdm_timeLimit setIntValue:0]; }
    if ([[sd_scoreLimit stringValue] length] == 0) { [sd_scoreLimit setIntValue:0]; }
    if ([[sd_timeLimit stringValue] length] == 0) { [sd_timeLimit setIntValue:0]; }
    if ([[sd_roundLength stringValue] length] == 0) { [sd_roundLength setIntValue:0]; }
    if ([[sd_roundLimit stringValue] length] == 0) { [sd_roundLimit setIntValue:0]; }
    if ([[sd_gracePeriod stringValue] length] == 0) { [sd_gracePeriod setIntValue:0]; }
    if ([[bel_scoreLimit stringValue] length] == 0) { [bel_scoreLimit setIntValue:0]; }
    if ([[bel_timeLimit stringValue] length] == 0) { [bel_timeLimit setIntValue:0]; }
    if ([[bel_alivePoint stringValue] length] == 0) { [bel_alivePoint setIntValue:0]; }
    if ([[ret_scoreLimit stringValue] length] == 0) { [ret_scoreLimit setIntValue:0]; }
    if ([[ret_timeLimit stringValue] length] == 0) { [ret_timeLimit setIntValue:0]; }
    if ([[ret_roundLength stringValue] length] == 0) { [ret_roundLength setIntValue:0]; }
    if ([[ret_roundLimit stringValue] length] == 0) { [ret_roundLimit setIntValue:0]; }
    if ([[ret_gracePeriod stringValue] length] == 0) { [ret_gracePeriod setIntValue:0]; }
    if ([[hq_scoreLimit stringValue] length] == 0) { [hq_scoreLimit setIntValue:0]; }
    if ([[hq_Timelimit stringValue] length] == 0) { [hq_Timelimit setIntValue:0]; }
}

- (IBAction)checkServMess:(id)sender
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    if ([[servMessTime stringValue] length] == 0) { [servMessTime setStringValue:@"10"]; }
    if ([[servMessWait stringValue] length] == 0) { [servMessWait setStringValue:@"2"]; }
    if ([[servMessText stringValue] length] == 0) { [servMessText setStringValue:GEN_SERVMESSERR]; }

    NSArray *servMessLines = [[servMessText stringValue] componentsSeparatedByString:@"\n"]; // message lines
    if ([servMessLines count] > 0 ) { // there are lines
        NSMutableString *newServMess = [[NSMutableString alloc] init];
        NSMutableString *currentLine = [[NSMutableString alloc] init];
        NSEnumerator *e = [servMessLines objectEnumerator];
        NSNumber *cur;
        unsigned int c=0;
        unsigned int d=0;

        while (cur = (NSNumber *)[e nextObject]) { // traverse the lines
            [currentLine setString:[servMessLines objectAtIndex:c++]];
            if ([currentLine length] > 0) { // there is something in the line
                d = [currentLine replaceOccurrencesOfString:@"://" withString:@":/ /" options:NSLiteralSearch range:NSMakeRange(0, [currentLine length])];
                d+= [currentLine replaceOccurrencesOfString:@"Û" withString:@"EUR" options:NSLiteralSearch range:NSMakeRange(0, [currentLine length])];
                d+= [currentLine replaceOccurrencesOfString:@"£" withString:@"GBP" options:NSLiteralSearch range:NSMakeRange(0, [currentLine length])];
                d+= [currentLine replaceOccurrencesOfString:@"©" withString:@"(C)" options:NSLiteralSearch range:NSMakeRange(0, [currentLine length])];
                d+= [currentLine replaceOccurrencesOfString:@"¨" withString:@"(R)" options:NSLiteralSearch range:NSMakeRange(0, [currentLine length])];
                d+= [currentLine replaceOccurrencesOfString:@"ª" withString:@"(TM)" options:NSLiteralSearch range:NSMakeRange(0, [currentLine length])];
                [currentLine appendString:@"\n"];
                [newServMess appendString:currentLine];
            } else { // it is an empty line
                d++;
            }
        }
//        NSLog(@"changed: %d", d);
        [servMessText setStringValue:newServMess];
        [pool release];
    }
}

- (IBAction)checkRconPass:(id)sender
    // checks if rconpass is shorter than 6 characters
{
    if ([[setRconPass stringValue] length] < 6) {
        NSBeep();
        int button = NSRunAlertPanel(ALE_RCONPASS1, ALE_RCONPASS2, ALE_OKBUTTON, ALE_ONLINEHELP, nil);
        if (button == NSCancelButton) {
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:HELP_RCONPASS_URL]];
        }
    }
}

@end
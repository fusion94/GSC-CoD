/* MainController */

#import <Cocoa/Cocoa.h>

@interface MainController : NSObject
{
    IBOutlet id aboutBox;
    IBOutlet id versionString;
    IBOutlet id titleString;
    IBOutlet id expiryString;

    // general tab items
    IBOutlet id servMessTime;
    IBOutlet id servMessWait;
    IBOutlet id servMessText;
    
    // network tab items
    IBOutlet id setMaxPing;
    IBOutlet id setMaxPlayers;
    IBOutlet id setMaxPrivPlayers;
    IBOutlet id setMinPing;
    IBOutlet id setNetPort;
    IBOutlet id setRconPass;

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
}

- (IBAction)paypalDonate:(id)sender;
- (IBAction)launchHelpURL:(id)sender;
- (void)updateApplicationBadge:(int)number;
- (IBAction)checkForUpdate:(id)sender;
- (IBAction)showAboutBox:(id)sender;
- (IBAction)setSliderBars:(id)sender;
- (IBAction)checkServMess:(id)sender;
- (IBAction)checkRconPass:(id)sender;
@end

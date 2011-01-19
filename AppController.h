//
//  AppController.h
//  Wiisentry
//

#import <Cocoa/Cocoa.h>
#import <WiiRemote/WiiRemote.h>
#import <WiiRemote/WiiRemoteDiscovery.h>
#import "PhidgetsController.h"

@interface AppController : NSObject{

	WiiRemoteDiscovery *discovery;
	WiiRemote* wii;
	int x1, x2, x3, y1, y2, y3, z1, z2, z3;
	int x0, y0, z0;
	float pX, pY;
	
	IBOutlet NSTextField* WiimoteX;
	IBOutlet NSTextField* WiimoteY;
	IBOutlet NSTextField* WiimoteZ;
	PhidgetsController * phidgets;
	IBOutlet NSSlider *slider1;
	IBOutlet NSSlider *slider2;
	IBOutlet NSSlider *slider3;
	
	bool r1, r2;
	int enableWiimote;
}

- (IBAction)doDiscovery:(id)sender;
- (IBAction)wiimoteState:(id)sender;
- (IBAction)motor:(id)sender;
- (void) ready:(NSTimer *) timer;
@end

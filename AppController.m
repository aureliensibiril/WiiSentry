//
//  AppController.m
//  Wiisentry
//
//

#import "AppController.h"


@implementation AppController

-(void)awakeFromNib{
	
	phidgets = [[PhidgetsController alloc] init];
	discovery = [[WiiRemoteDiscovery alloc] init];
	[discovery setDelegate:self];
	pX= 0.0;
	pY= 0.0;
	r1 = TRUE;
	r2 = TRUE;
	enableWiimote = 1;

}

- (void) ready:(NSTimer *) timer
{
		r1 = TRUE;
	
}

- (IBAction)wiimoteState:(id)sender{

	if (enableWiimote) {
		[sender setAttributedTitle:@"Enable"];
		enableWiimote = 0;
	}
	else {
		[sender setAttributedTitle:@"Disable"];
		enableWiimote = 1;
	}
}


- (IBAction)doDiscovery:(id)sender
{	
	[discovery start];
}

- (IBAction)motor:(id)sender
{	
	[phidgets moveServo:sender];
}

#pragma mark -
#pragma mark WiiRemoteDiscovery delegates

- (void) WiiRemoteDiscoveryError:(int)code {
		
}

- (void) willStartWiimoteConnections {

}

- (void) WiiRemoteDiscovered:(WiiRemote*)wiimote {
	
	wii = [wiimote retain];
	[wiimote setDelegate:self];
	
	NSLog(@"\n===== Connected to WiiRemote =====\n");
	
	[wiimote setLEDEnabled1:YES enabled2:NO enabled3:NO enabled4:NO];
	
	[wiimote setMotionSensorEnabled:YES];

}

#pragma mark -
#pragma mark WiiRemote delegates

- (void) accelerationChanged:(WiiAccelerationSensorType) type accX:(unsigned short) accX accY:(unsigned short) accY accZ:(unsigned short) accZ{
		
	WiiAccCalibData data = [wii accCalibData:WiiRemoteAccelerationSensor];
	x0 = data.accX_zero;
	x3 = data.accX_1g;
	y0 = data.accY_zero;
	y2 = data.accY_1g;
	z0 = data.accZ_zero;
	z1 = data.accZ_1g;

	double ax = (double)(accX - x0) / (x3 - x0);
	double ay = (double)(accY - y0) / (y2 - y0);
	double az = (double)(accZ - z0) / (z1 - z0) * (-1.0);
	
	[WiimoteX setStringValue: [NSString stringWithFormat:@"%.2f", ax]];	
	[WiimoteY setStringValue: [NSString stringWithFormat:@"%.2f", ay]];	
	[WiimoteZ setStringValue: [NSString stringWithFormat:@"%.2f", az]];	

	if(enableWiimote == 1){
		
		//if(r1){
		
	if((MAX(ax, pX) - MIN(ax, pX)) > 0.15)
	{
		float move = 0;
		if(ax > 0.0){
			move = 138 + (30 * ax);
			[phidgets moveServo:1 Value:move];

		}
		else if(ax < 0.0){
			move = 138 - (30 * ABS(ax));
			[phidgets moveServo:1 Value:move];

		}
		
		pX = ax;
	}
	else {
			//pX = ax;
	}
		//}

	
	if((MAX(ay, pY) - MIN(ay, pY)) > 0.15)
	{
		float move = 0;
		if(ay > 0.0){
			move = 105 - (25 * ay);
			[phidgets moveServo:0 Value:move];
		}
		else if(ay < 0.0){
			move = 105 + (25 * ABS(ay));
			[phidgets moveServo:0 Value:move];
		}
		
		
		pY = ay;
	}
	else {
			//pX = ax;
	}
	
	}
}

- (void) pressureChanged:(WiiPressureSensorType) type pressureTR:(float) bPressureTR pressureBR:(float) bPressureBR 
			  pressureTL:(float) bPressureTL pressureBL:(float) bPressureBL{
	NSLog(@"%@",[NSString stringWithFormat:@"%.2fkg", bPressureBL]);
}

- (void) wiiRemoteDisconnected:(IOBluetoothDevice*) device
{
	
}

- (void) buttonChanged:(WiiButtonType)type isPressed:(BOOL)isPressed{
	
	
	if (type == WiiRemoteAButton){
		[phidgets moveServo:2 Value:132.0];
		
	}else if (type == WiiRemoteBButton){
		[phidgets moveServo:2 Value:100.0];

	}
	else if (type == WiiRemoteMinusButton){
		[phidgets basicSetup];
	}
		
}



@end

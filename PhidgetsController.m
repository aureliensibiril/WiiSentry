//
//  PhidgetsController.m
//  Wiisentry
//

#import "PhidgetsController.h"

CPhidgetAdvancedServoHandle servo;

@implementation PhidgetsController

int gotAttach(CPhidgetHandle phid, void *context) {
	[(id)context phidgetAdded];
	return 0;
}

int gotDetach(CPhidgetHandle phid, void *context) {
	[(id)context phidgetRemoved];
	return 0;
}

int gotPositionChange(CPhidgetAdvancedServoHandle phid, void *context, int index, double position) {
	[(id)context positionChange:index:position];
	return 0;
}

int gotCurrentChange(CPhidgetAdvancedServoHandle phid, void *context, int index, double current) {
	[(id)context currentChange:index:current];
	return 0;
}

int gotVelocityChange(CPhidgetAdvancedServoHandle phid, void *context, int index, double velocity) {
	[(id)context velocityChange:index:velocity];
	return 0;
}

- (id) init
{
	if (self = [super init]){
		
		int serial = -1;
		
		CPhidget_enableLogging(PHIDGET_LOG_VERBOSE, NULL);
		
		CPhidgetAdvancedServo_create(&servo);
		
		CPhidget_set_OnAttach_Handler((CPhidgetHandle)servo, gotAttach, self);
		CPhidget_set_OnDetach_Handler((CPhidgetHandle)servo, gotDetach, self);
		CPhidgetAdvancedServo_set_OnPositionChange_Handler(servo, gotPositionChange, self);
		CPhidgetAdvancedServo_set_OnVelocityChange_Handler(servo, gotVelocityChange, self);
		CPhidgetAdvancedServo_set_OnCurrentChange_Handler(servo, gotCurrentChange, self);
		
		CPhidget_open((CPhidgetHandle)servo, serial);
		
		
		NSLog(@"Phidgets init !");
		
	}
	
	return self;
}

- (void)phidgetAdded
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"Ok add");
	int serial, version;
	int numMotors;
	const char *name;
	CPhidget_DeviceID devid;
	
	double posn;
	double min = 0;
	double max = 0;
	
	CPhidget_getSerialNumber((CPhidgetHandle)servo, &serial);
	CPhidget_getDeviceVersion((CPhidgetHandle)servo, &version);
	CPhidget_getDeviceName((CPhidgetHandle)servo, &name);
	CPhidget_getDeviceID((CPhidgetHandle)servo, &devid);
	CPhidgetAdvancedServo_getMotorCount(servo,&numMotors);
	
		//CPhidgetAdvancedServo_setEngaged(servo,0,PTRUE);
	/*double velocite, velociteLimite, velocitemax, velocitemin;
	CPhidgetAdvancedServo_getVelocityLimit(servo,0,&velociteLimite);	
	CPhidgetAdvancedServo_getVelocity(servo,0,&velocite);	
	CPhidgetAdvancedServo_getVelocityMax(servo,0,&velocitemax);	
	CPhidgetAdvancedServo_getVelocityMin(servo,0,&velocitemin);	
		//NSLog(@"motor 0 : velociteLimite : %f | velocite : %f | max : %f | min : %f", velociteLimite, velocite, velocitemax, velocitemin);
*/
	CPhidgetAdvancedServo_getPosition(servo,0,&posn);
		
		CPhidgetAdvancedServo_getPositionMax(servo, 0, &max);
		CPhidgetAdvancedServo_getPositionMin(servo, 0, &min);
		
		NSLog(@"slider 1 : max : %f | min : %f | current : %f", max, min, posn);

	
	
	CPhidgetAdvancedServo_getPosition(servo,1,&posn);
		
		CPhidgetAdvancedServo_getPositionMax(servo, 1, &max);
		CPhidgetAdvancedServo_getPositionMin(servo, 1, &min);
		
		NSLog(@"slider 2 : max : %f | min : %f | current : %f", max, min, posn);

		
	
	
	CPhidgetAdvancedServo_getPosition(servo,2,&posn);
		
		CPhidgetAdvancedServo_getPositionMax(servo, 2, &max);
		CPhidgetAdvancedServo_getPositionMin(servo, 2, &min);

		NSLog(@"slider 2 : max : %f | min : %f | current : %f", max, min, posn);

	
	[pool release];
}

-(void)basicSetup
{
	CPhidgetAdvancedServo_setEngaged(servo,0,PTRUE);
	CPhidgetAdvancedServo_setEngaged(servo,1,PTRUE);
	CPhidgetAdvancedServo_setEngaged(servo,2,PTRUE);

	CPhidgetAdvancedServo_setPosition(servo, 0, 105.0);
	CPhidgetAdvancedServo_setPosition(servo, 1, 138.0);
	CPhidgetAdvancedServo_setPosition(servo, 2, 132.0);

}

- (void)positionChange:(int)Index:(double)value
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int stopped;
	CPhidgetAdvancedServo_getStopped(servo, Index, &stopped);
	[pool release];
}

- (void)velocityChange:(int)Index:(double)Value
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int stopped;
	CPhidgetAdvancedServo_getStopped(servo, Index, &stopped);
	[pool release];
}

- (void)currentChange:(int)Index:(double)Value
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[pool release];
}

- (IBAction)moveServo:(id)sender
{
	if([sender tag] < 8)
	{
		CPhidgetAdvancedServo_setPosition(servo, [sender tag], [sender floatValue]);
		NSLog(@"servo %d : %f", [sender tag], [sender floatValue]);
	}
}

- (IBAction)moveServo:(int) num Value:(float)value
{
	if(num < 8)
	{
			//int state = PFALSE;
			//CPhidgetAdvancedServo_getEngaged(servo,num,&state);
			//if(state == PFALSE){
			CPhidgetAdvancedServo_setPosition(servo, num, value);
			NSLog(@"servo %d : %f", num, value);
			
			//}	
		
	}
}


- (void)phidgetRemoved
{
}


@end

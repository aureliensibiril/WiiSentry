//
//  PhidgetsController.h
//  Wiisentry
//


#import <Cocoa/Cocoa.h>
#include <Phidget21/phidget21.h>

@interface PhidgetsController : NSObject {
    IBOutlet NSMatrix *servos;
	IBOutlet NSMatrix *servoFields;
    IBOutlet NSMatrix *engageBoxes;

}

- (void)phidgetAdded;
- (void)phidgetRemoved;
- (IBAction)moveServo:(id)sender;
- (IBAction)moveServo:(int) num Value:(float)value;
- (void)positionChange:(int)Index:(double)Value;
- (void)velocityChange:(int)Index:(double)Value;
- (void)currentChange:(int)Index:(double)Value;

@end

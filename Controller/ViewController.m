//
//  ViewController.m
//  Controller
//
//  Created by Jay Versluis on 14/04/2016.
//  Copyright © 2016 Pinkstone Pictures LLC. All rights reserved.
//

#import "ViewController.h"
@import GameController;

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) GCController *mainController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // don't fall asleep while our app is running
    [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
    
    // notifications for controller (dis)connect
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(controllerWasConnected:) name:GCControllerDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(controllerWasDisconnected:) name:GCControllerDidDisconnectNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)controllerWasConnected:(NSNotification *)notification {
    
    // a controller was connected
    GCController *controller = (GCController *)notification.object;
    NSString *status = [NSString stringWithFormat:@"Controller connected\nName: %@\n", controller.vendorName];
    self.statusLabel.text = status;
    
    self.mainController = controller;
    [self reactToInput];
    
}

- (void)controllerWasDisconnected:(NSNotification *)notification {
    
    // a controller was disconnected
    GCController *controller = (GCController *)notification.object;
    NSString *status = [NSString stringWithFormat:@"Controller disconnected:\n%@", controller.vendorName];
    self.statusLabel.text = status;
    
    self.mainController = nil;
}

- (void)reactToInput {
    
    // register block for input change detection
    GCExtendedGamepad *profile = self.mainController.extendedGamepad;
    profile.valueChangedHandler = ^(GCExtendedGamepad *gamepad, GCControllerElement *element)
    {
        // left trigger
        if (gamepad.leftTrigger == element && gamepad.leftTrigger.isPressed) {
            self.navigationItem.title = @"Left Trigger";
        }
        
        // right trigger
        if (gamepad.rightTrigger == element && gamepad.rightTrigger.isPressed) {
            self.navigationItem.title = @"Right Trigger";
        }
        
        // left shoulder button
        if (gamepad.leftShoulder == element && gamepad.leftShoulder.isPressed) {
            self.navigationItem.title = @"Left Shoulder Button";
        }
        
        // right shoulder button
        if (gamepad.rightShoulder == element && gamepad.rightShoulder.isPressed) {
            self.navigationItem.title = @"Right Shoulder Button";
        }
        
        // A button
        if (gamepad.buttonA == element && gamepad.buttonA.isPressed) {
            self.navigationItem.title = @"A Button";
        }
        
        // B button
        if (gamepad.buttonB == element && gamepad.buttonB.isPressed) {
            self.navigationItem.title = @"B Button";
        }
        
        // X button
        if (gamepad.buttonX == element && gamepad.buttonX.isPressed) {
            self.navigationItem.title = @"X Button";
        }
        
        // Y button
        if (gamepad.buttonY == element && gamepad.buttonY.isPressed) {
            self.navigationItem.title = @"Y Button";
        }
        
        // d-pad
        if (gamepad.dpad == element) {
            if (gamepad.dpad.up.isPressed) {
                self.navigationItem.title = @"D-Pad Up";
            }
            if (gamepad.dpad.down.isPressed) {
                self.navigationItem.title = @"D-Pad Down";
            }
            if (gamepad.dpad.left.isPressed) {
                self.navigationItem.title = @"D-Pad Left";
            }
            if (gamepad.dpad.right.isPressed) {
                self.navigationItem.title = @"D-Pad Right";
            }
        }
        
        // left stick
        if (gamepad.leftThumbstick == element) {
            if (gamepad.leftThumbstick.up.isPressed) {
                self.navigationItem.title = @"Left Stick Up";
            }
            if (gamepad.leftThumbstick.down.isPressed) {
                self.navigationItem.title = @"Left Stick Down";
            }
            if (gamepad.leftThumbstick.left.isPressed) {
                self.navigationItem.title = @"Left Stick Left";
            }
            if (gamepad.leftThumbstick.right.isPressed) {
                self.navigationItem.title = @"Left Stick Right";
            }
        }
        
        // right stick
        if (gamepad.rightThumbstick == element) {
            if (gamepad.rightThumbstick.up.isPressed) {
                self.navigationItem.title = @"Right Stick Up";
            }
            if (gamepad.rightThumbstick.down.isPressed) {
                self.navigationItem.title = @"Right Stick Down";
            }
            if (gamepad.rightThumbstick.left.isPressed) {
                self.navigationItem.title = @"Right Stick Left";
            }
            if (gamepad.rightThumbstick.right.isPressed) {
                self.navigationItem.title = @"Right Stick Right";
            }
        }
        
    };
    
    self.mainController.controllerPausedHandler = ^(GCController *controller){
        self.navigationItem.title = @"Pause Button";
    };
}

@end

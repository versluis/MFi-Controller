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
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) GCController *mainController;
@property (strong, nonatomic) UIViewController *pausedViewController;
@property BOOL currentlyPaused;
@end

@implementation ViewController

- (UIViewController *)pausedViewController {
    
    if (!_pausedViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _pausedViewController = [storyboard instantiateViewControllerWithIdentifier:@"PausedScreen"];
    }
    return _pausedViewController;
}

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
            [self displayMessage:@"Left Trigger"];
        }
        
        // right trigger
        if (gamepad.rightTrigger == element && gamepad.rightTrigger.isPressed) {
            [self displayMessage:@"Right Trigger"];
        }
        
        // left shoulder button
        if (gamepad.leftShoulder == element && gamepad.leftShoulder.isPressed) {
            [self displayMessage:@"Left Shoulder Button"];
        }
        
        // right shoulder button
        if (gamepad.rightShoulder == element && gamepad.rightShoulder.isPressed) {
            [self displayMessage:@"Right Shoulder Button"];
        }
        
        // A button
        if (gamepad.buttonA == element && gamepad.buttonA.isPressed) {
            [self displayMessage:@"A Button"];
        }
        
        // B button
        if (gamepad.buttonB == element && gamepad.buttonB.isPressed) {
            [self displayMessage:@"B Button"];
        }
        
        // X button
        if (gamepad.buttonX == element && gamepad.buttonX.isPressed) {
            [self displayMessage:@"X Button"];
        }
        
        // Y button
        if (gamepad.buttonY == element && gamepad.buttonY.isPressed) {
            [self displayMessage:@"Y Button"];
        }
        
        // d-pad
        if (gamepad.dpad == element) {
            if (gamepad.dpad.up.isPressed) {
                [self displayMessage:@"D-Pad Up"];
            }
            if (gamepad.dpad.down.isPressed) {
                [self displayMessage:@"D-Pad Down"];
            }
            if (gamepad.dpad.left.isPressed) {
                [self displayMessage:@"D-Pad Left"];
            }
            if (gamepad.dpad.right.isPressed) {
                [self displayMessage:@"D-Pad Right"];
            }
        }
        
        // left stick
        if (gamepad.leftThumbstick == element) {
            if (gamepad.leftThumbstick.up.isPressed) {
                [self displayMessage:@"Left Stick Up"];
            }
            if (gamepad.leftThumbstick.down.isPressed) {
                [self displayMessage:@"Left Stick Down"];
            }
            if (gamepad.leftThumbstick.left.isPressed) {
                [self displayMessage:@"Left Stick Left"];
            }
            if (gamepad.leftThumbstick.right.isPressed) {
                [self displayMessage:@"Left Stick Right"];
            }
        }
        
        // right stick
        if (gamepad.rightThumbstick == element) {
            if (gamepad.rightThumbstick.up.isPressed) {
                [self displayMessage:@"Right Stick Up"];
            }
            if (gamepad.rightThumbstick.down.isPressed) {
                [self displayMessage:@"Right Stick Down"];
            }
            if (gamepad.rightThumbstick.left.isPressed) {
                [self displayMessage:@"Right Stick Left"];
            }
            if (gamepad.rightThumbstick.right.isPressed) {
                [self displayMessage:@"Right Stick Right"];
            }
        }
        
    };
    
    // we need a weak self here for in-block access
    __weak typeof(self) weakSelf = self;
    
    self.mainController.controllerPausedHandler = ^(GCController *controller){
        
        // check if we're currently paused or not
        // then bring up or remove the paused view controller
        if (weakSelf.currentlyPaused) {
            
            weakSelf.currentlyPaused = NO;
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
        } else {
            
            weakSelf.currentlyPaused = YES;
            [weakSelf presentViewController:weakSelf.pausedViewController animated:YES completion:nil];
        }
        
    };
}

- (void)displayMessage:(NSString *)message {
    
    // update message label
    self.navigationItem.title = message;

}








@end

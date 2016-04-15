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
@property (strong, nonatomic) UIImageView *crabView;
@property (strong, nonatomic) GCController *mainController;
@property (strong, nonatomic) UIViewController *pausedViewController;
@property BOOL currentlyPaused;
@property int screenX;
@property int screenY;
@end

@implementation ViewController

- (UIViewController *)pausedViewController {
    
    if (!_pausedViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _pausedViewController = [storyboard instantiateViewControllerWithIdentifier:@"PausedScreen"];
    }
    return _pausedViewController;
}

- (UIImageView *)crabView {
    
    if (!_crabView) {
        _crabView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"crab"]];
        _crabView.contentMode = UIViewContentModeRedraw;
        _crabView.frame = CGRectMake(0, 0, 80, 80);
        [self.view addSubview:_crabView];
    }
    return _crabView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // don't fall asleep while our app is running
    [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
    
    // notifications for controller (dis)connect
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(controllerWasConnected:) name:GCControllerDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(controllerWasDisconnected:) name:GCControllerDidDisconnectNotification object:nil];
    
    // detect screen size and position crab
    [self detectScreenSize];
    [self updatePosition:CGPointMake(0, 0)];
    
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
        NSString *message = @"";
        CGPoint position = CGPointMake(0, 0);
        
        // left trigger
        if (gamepad.leftTrigger == element && gamepad.leftTrigger.isPressed) {
            message = @"Left Trigger";
        }
        
        // right trigger
        if (gamepad.rightTrigger == element && gamepad.rightTrigger.isPressed) {
            message = @"Right Trigger";
        }
        
        // left shoulder button
        if (gamepad.leftShoulder == element && gamepad.leftShoulder.isPressed) {
            message = @"Left Shoulder Button";
        }
        
        // right shoulder button
        if (gamepad.rightShoulder == element && gamepad.rightShoulder.isPressed) {
            message = @"Right Shoulder Button";
        }
        
        // A button
        if (gamepad.buttonA == element && gamepad.buttonA.isPressed) {
            message = @"A Button";
        }
        
        // B button
        if (gamepad.buttonB == element && gamepad.buttonB.isPressed) {
            message = @"B Button";
        }
        
        // X button
        if (gamepad.buttonX == element && gamepad.buttonX.isPressed) {
            message = @"X Button";
        }
        
        // Y button
        if (gamepad.buttonY == element && gamepad.buttonY.isPressed) {
            message = @"Y Button";
        }
        
        // d-pad
        if (gamepad.dpad == element) {
            if (gamepad.dpad.up.isPressed) {
                message = @"D-Pad Up";
            }
            if (gamepad.dpad.down.isPressed) {
                message = @"D-Pad Down";
            }
            if (gamepad.dpad.left.isPressed) {
                message = @"D-Pad Left";
            }
            if (gamepad.dpad.right.isPressed) {
                message = @"D-Pad Right";
            }
        }
        
        // left stick
        if (gamepad.leftThumbstick == element) {
            if (gamepad.leftThumbstick.up.isPressed) {
                message = [NSString stringWithFormat:@"Left Stick %f", gamepad.leftThumbstick.yAxis.value];
            }
            if (gamepad.leftThumbstick.down.isPressed) {
                message = [NSString stringWithFormat:@"Left Stick %f", gamepad.leftThumbstick.yAxis.value];
            }
            if (gamepad.leftThumbstick.left.isPressed) {
                message = [NSString stringWithFormat:@"Left Stick %f", gamepad.leftThumbstick.xAxis.value];
            }
            if (gamepad.leftThumbstick.right.isPressed) {
                message = [NSString stringWithFormat:@"Left Stick %f", gamepad.leftThumbstick.xAxis.value];
            }
            position = CGPointMake(gamepad.leftThumbstick.xAxis.value, gamepad.leftThumbstick.yAxis.value);
        }
        
        // right stick
        if (gamepad.rightThumbstick == element) {
            if (gamepad.rightThumbstick.up.isPressed) {
                message = [NSString stringWithFormat:@"Right Stick %f", gamepad.rightThumbstick.yAxis.value];
            }
            if (gamepad.rightThumbstick.down.isPressed) {
                message = [NSString stringWithFormat:@"Right Stick %f", gamepad.rightThumbstick.yAxis.value];
            }
            if (gamepad.rightThumbstick.left.isPressed) {
                message = [NSString stringWithFormat:@"Right Stick %f", gamepad.rightThumbstick.xAxis.value];
            }
            if (gamepad.rightThumbstick.right.isPressed) {
                message = [NSString stringWithFormat:@"Right Stick %f", gamepad.rightThumbstick.xAxis.value];
            }
            position = CGPointMake(gamepad.rightThumbstick.xAxis.value, gamepad.rightThumbstick.yAxis.value);
        }
        
        [self displayMessage:message];
        [self updatePosition:position];
        
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

- (void)updatePosition:(CGPoint)position {
    
    // move crab to desired position
    CGPoint newPosition = CGPointMake((self.screenX * position.x) + (self.screenX), (self.screenY * -position.y) + (self.screenY));
    self.crabView.center = newPosition;
    
}
    

- (void)detectScreenSize {
    
    // run at startup to determine screen size
    // screenX and screenY represent coordinates for the center position
    self.screenX = [UIScreen mainScreen].bounds.size.width / 2;
    self.screenY = [UIScreen mainScreen].bounds.size.height / 2;
}








@end

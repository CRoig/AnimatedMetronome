//
//  ViewController.m
//  AnimatedMetronome
//
//  Created by Carles Roig (ATIC) on 05/03/14.
//  Copyright (c) 2014 Carles Roig (ATIC). All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize MetroBarView, MetroBarWght, MetroBarBar, direction, currOffset, currTempo, touching, countEnabled, initialPoint, currPoint, maxTempo, minTempo, tempoLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Set initial values
    touching = NO;      //Not touching
    countEnabled = NO;  //Animation stop
    currOffset = 0.0;   //Center position
    currTempo = 100.0;  //Initial tempo
    direction = 1;      //Right movement
    
    minTempo = 60;      //Min tempo
    maxTempo = 180;     //Max tempo
    
    //Inlcude the back part of the metronome to the view (background)
    UIImageView *BodyImage = [[UIImageView alloc] initWithFrame: CGRectMake(84, 74, 600, 750)];
    [BodyImage setImage:[UIImage imageNamed:@"MetronomeBody.png"]];
    [self.view addSubview:(UIView *) BodyImage];
    
    //MetroBarView (the complete bar of the metronomet composed by the actual bar and the metronome weight)
    MetroBarView = [[UIView alloc] initWithFrame:CGRectMake(334, 320, 100, 560)];
    MetroBarView.layer.anchorPoint = CGPointMake(0.5, 1.0); //Update anchorPoint to define the rotation point.
    
    //Bar of the metronome
    MetroBarBar = [[UIImageView alloc] initWithFrame: CGRectMake(30, 0, 40, 560)];
    [MetroBarBar setImage:[UIImage imageNamed:@"MetronomeBar.png"]];
    [MetroBarView addSubview:(UIView *) MetroBarBar];

    //Weight of the metronome
    MetroBarWght = [[UIImageView alloc] initWithFrame: CGRectMake(0, 230, 100, 100)];
    [MetroBarWght setImage:[UIImage imageNamed:@"MetronomeBodyWeight.png"]];
    [MetroBarView addSubview:(UIView *) MetroBarWght];
    
    //Include the bar to the view (second layer)
    [self.view addSubview:MetroBarView];

    //Inlcude the back part of the metronome to the view (front)
    UIImageView *BaseImage = [[UIImageView alloc] initWithFrame: CGRectMake(84, 546, 600, 278)];
    [BaseImage setImage:[UIImage imageNamed:@"MetronomeBase.png"]];
    [self.view addSubview:(UIView *) BaseImage];
    
    //Define the scheduledMethod (update the bar position)
    [NSTimer scheduledTimerWithTimeInterval:0.05                           // The routine will be repeated every 50 ms.
									 target:self
								   selector:@selector(ActualizarUI:)       // NTimer will call ActualizarUI every 50 ms.
								   userInfo:nil
									repeats:YES];
}

- (void) ActualizarUI: (NSTimer *) timer{
    if (!touching && countEnabled) {
        //Defining a oscilation angle of 120º (2pi/3 radians), the increasing angle each 50ms is:
        // 0.05*(2*pi/3)/(60/tempo) = tempo*pi/1800
        
        // The current angle is checked before updating for avoiding metastable situations specially when the tempo is changed close to the edges.
        if (currOffset + direction*(currTempo*M_PI/1800) >= (M_PI/3) || currOffset + direction*(currTempo*M_PI/1800) <= -(M_PI/3)) {
            //When the bar is about to excess the borders (120º), the direction is changed.
            direction = direction * -1;
        }
        currOffset = currOffset + direction*(currTempo*M_PI/1800);
        
        CGAffineTransform swingTransform = CGAffineTransformIdentity;
        swingTransform = CGAffineTransformRotate(swingTransform, currOffset);
        
        [UIView beginAnimations:@"metronome" context: MetroBarView];
        [UIView setAnimationDuration: 0.05];
        
        MetroBarView.transform = swingTransform;
        
        [UIView commitAnimations];

    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    touching = YES;
    initialPoint = [[touches anyObject] locationInView:self.view];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    currPoint = [[touches anyObject] locationInView:self.view];
    
    //Check if the movement will cause the weight to be outside the bar. In this case, 510 pixels will be the lowest position allowed, and 50 pixels the highest
    if (MetroBarWght.center.y + (currPoint.y - initialPoint.y) <= 510 && MetroBarWght.center.y + (currPoint.y - initialPoint.y) >= 50){
        MetroBarWght.center = CGPointMake(MetroBarWght.center.x, MetroBarWght.center.y + (currPoint.y - initialPoint.y));
        currTempo = MetroBarWght.center.y*(maxTempo-minTempo)/460 + minTempo - (maxTempo-minTempo)*50/460; //460 = lowestPos - highestPos = 510 - 50
        tempoLabel.text = [NSString stringWithFormat:@"Current: %d bpm", (int) currTempo];
        
    }
    initialPoint = currPoint;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    touching = NO;
}

- (IBAction) StartStop:(id)sender{
    countEnabled = !countEnabled;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

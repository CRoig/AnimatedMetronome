//
//  ViewController.h
//  AnimatedMetronome
//
//  Created by Carles Roig (ATIC) on 05/03/14.
//  Copyright (c) 2014 Carles Roig (ATIC). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    
    //Interface elements
    UILabel     *tempoLabel;
    UIView      *MetroBarView;
    UIImageView *MetroBarBar;
    UIImageView *MetroBarWght;
    
    //Animation parameters
    int         direction;
    float       currOffset;
    float       currTempo;
    
    //Control paramters
    BOOL        touching;
    BOOL        countEnabled;
    
    //Touch event parameters
    CGPoint     initialPoint;
    CGPoint     currPoint;
    
    //Customizable paramters
    float       maxTempo;
    float       minTempo;

}

@property (strong, nonatomic) UIView      *MetroBarView;
@property (strong, nonatomic) UIImageView *MetroBarBar;
@property (strong, nonatomic) UIImageView *MetroBarWght;

@property (strong, nonatomic) IBOutlet UILabel *tempoLabel;

@property                     int         direction;
@property                     float       currOffset;
@property                     float       currTempo;

@property                     BOOL        touching;
@property                     BOOL        countEnabled;

@property                     CGPoint     initialPoint;
@property                     CGPoint     currPoint;

@property                     float       maxTempo;
@property                     float       minTempo;

- (IBAction) StartStop:(id)sender;

@end

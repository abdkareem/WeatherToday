//
//  AllWeatherPropertiesViewController.h
//  Weather Today
//
//  Created by Taiyaba Sultana on 5/24/16.
//  Copyright © 2016 Abdul Kareem. All rights reserved.
//

#import "ViewController.h"

@interface AllWeatherPropertiesViewController : ViewController


//tip: go to connections inspector and look at referencing outlets to find which UI component is associated with which IBOutlet

@property (weak, nonatomic) IBOutlet UITextField *maxTempF;
@property (weak, nonatomic) IBOutlet UITextField *minTempF;
@property (weak, nonatomic) IBOutlet UITextField *tempF;
@property (weak, nonatomic) IBOutlet UITextField *humidityF;
@property (weak, nonatomic) IBOutlet UITextField *atmPressureF;
@property (weak, nonatomic) IBOutlet UITextField *weatherF;
@property (weak, nonatomic) IBOutlet UITextField *cloudCoverageF;
@property (weak, nonatomic) IBOutlet UITextField *rainF;
@property (weak, nonatomic) IBOutlet UITextField *windSpeedF;
@property (weak, nonatomic) IBOutlet UITextField *windDirectionF;

@property (weak, nonatomic) IBOutlet UILabel *cityName;

@end

//
//  ViewController.m
//  Weather Today
//
//  Created by Taiyaba Sultana on 5/2/16.
//  Copyright © 2016 Abdul Kareem. All rights reserved.
//

#import "ViewController.h"
#import "AllWeatherPropertiesViewController.h"

@interface ViewController () {
    
    NSDictionary *citiesList;
    //primary api url string. All parameters are appended to it.
    NSMutableString *apiURLString;
    NSArray *rowsValuesHolder;
    id vari;
    NSArray *moreWeatherProperties;

}

@property (weak, nonatomic) IBOutlet UIPickerView *chooseCity;

//Update Note: Label named temp is used for Weather
@property (weak, nonatomic) IBOutlet UITextField *temp;

//Update Note: Label named maxTemp is used for Temperature
@property (weak, nonatomic) IBOutlet UITextField *maxTemp;

//Update Note: Label named minTemp is used for Humidity
@property (weak, nonatomic) IBOutlet UITextField *minTemp;
//@property (weak, nonatomic) NSMutableString * apiURLString;

@property (weak, nonatomic) IBOutlet UILabel *noteLabel;



- (void)setCitiesList;
- (void)setApiUrl: (NSNumber*)cityId;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setCitiesList];
    self.chooseCity.dataSource = self;
    self.chooseCity.delegate = self;
    //moreWeatherProperties = @[@"Cloud Percentage", @"Wind Direction", @"Wind Speed", @"Temperature Max", @"Temperature Min"];
    moreWeatherProperties = [NSArray alloc];
    //[moreWeatherProperties initWithObjects:vari[@"weather"][0][@"description"], nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//setting data in array for picker view
//dictionary literal syntax and other @ http://rypress.com/tutorials/objective-c/data-types/nsdictionary
- (void)setCitiesList {
    citiesList = @{
                   //Cities can also be stored in NSArray and api calls can be made using city names
                   //inorder to elminate conflicts arising due to same city names, using unique city ids
                   @"Beijing" : [NSNumber numberWithInt:1816670],
                   @"Bangalore" : [NSNumber numberWithInt:1277333],
                   @"Chicago" : [NSNumber numberWithInt:4915963],
                   @"Dubai" : [NSNumber numberWithInt:292223],
                   @"England" : [NSNumber numberWithInt:6269131],
                   @"Fremont" : [NSNumber numberWithInt:5350734],
                   @"HoChi Minh" : [NSNumber numberWithInt:1580578],
                   @"Hyderabad" : [NSNumber numberWithInt:1269843],
                   @"Istanbul" : [NSNumber numberWithInt:745044],
                   @"Riyadh" : [NSNumber numberWithInt:108410],
                   @"San Francisco" : [NSNumber numberWithInt:5391959],
                   @"Santa Clara" : [NSNumber numberWithInt:5393015],
                   @"San Jose" : [NSNumber numberWithInt:5392171],
                   @"Sydney" : [NSNumber numberWithInt:6619279],
                   @"Sweden" : [NSNumber numberWithInt:2661886],
                   @"Tokyo" : [NSNumber numberWithInt:1850147],
                   };
}

/***********PickerViewDataSource Delegates Protocol*******************/

//setting the number of components in picker view
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

//setting the number of rows in picker view's component(s)
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [citiesList count];
}
/***********************END************************/


/***************PickerViewDelegate Protocol********************/

//setting the rows for the picker
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    rowsValuesHolder = [citiesList allKeys];
    return rowsValuesHolder[row];
}

//identifying the row selected using picker delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //NSLog(@"Selected row is %@", citiesList[row]);
    rowsValuesHolder = [citiesList allValues];
    [self setApiUrl: rowsValuesHolder[row]];
}
/***********************END************************/

//setting api url string
-(void)setApiUrl: (NSNumber*)cityId {
    apiURLString = [NSMutableString stringWithString:@"http://api.openweathermap.org/data/2.5/weather?id="];
    [apiURLString appendFormat:@"%@", cityId];
    //[apiURLString appendString:cityName];
    //appending app id
    [apiURLString appendString:@"&appid=594c02ebb0b04deddc5df03301a4eb44"];
    [apiURLString appendString:@"&type=accurate&units=imperial"];
    NSLog(@"not just the url %@", apiURLString);
    [self makeApiCall:apiURLString];
}

//calling  the weather api @openweather.org
-(void)makeApiCall: (NSMutableString *)apiURLStringPar{
    //NSURL—An object that contains a URL. more on:
// https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSURLSession_class/#//apple_ref/doc/uid/TP40013435-CH1-SW2
    NSURL *urlContainingApiCall = [NSURL URLWithString:apiURLStringPar];
    //prepare url session
    NSURLSession *mySession = [NSURLSession sharedSession];
    //when a method asks for completion handler, it asks for a block of code that is executed once method operation is completed
    //delete the completion handler and put braces for the block i.e. {} and remove the return type
    [[mySession dataTaskWithURL:urlContainingApiCall completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Network error encountered %@",error);
            return;
        }
        //check if http responds with error code
        //use http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html for better understanding
        //Sucess codes with 2xx and error with 4xx and 5xx or anything else. more on http://www.w3.org/Protocols/HTTP/HTRESP.html
        //info on NSHTTPURLResponse https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSHTTPURLResponse_Class/#//apple_ref/occ/instm/NSHTTPURLResponse/initWithURL:statusCode:HTTPVersion:headerFields:
        //also refer to NSURLResponse class for its property statusCode
        NSHTTPURLResponse *pointerToDetStatusCode = (NSHTTPURLResponse *) response; //type casting ?
        if (pointerToDetStatusCode.statusCode < 200 || pointerToDetStatusCode.statusCode >= 300) {
            NSLog(@"HTTP error status code %ld", (long)pointerToDetStatusCode.statusCode);
            return;
        }
        NSError *parseError;
        vari = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!vari) {
            NSLog(@"Parse error %@", parseError);
        }
        NSLog(@"\nThe weather today is: %@",vari[@"weather"][0][@"description"]);
        NSLog(@"\nTemp is: %@",vari[@"main"][@"temp"]);
        NSLog(@"\nHumidty is: %@",vari[@"main"][@"humidity"]);
        NSLog(@"\nJSON response is: %@",vari);
        
        //moreWeatherProperties = [NSArray arrayWithObjects:vari[@"weather"][0][@"description"], vari[@"main"][@"temp"], nil];
        //NSLog(@"This is what I want : %@",moreWeatherProperties[0]);
        //pull main thread and put the data on UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /*******WARNING. Don't go with label names. Comments indicate recent updates*************/
            
            //temp label now displays weather description
            self.temp.text = [NSString stringWithFormat:@"%@",vari[@"weather"][0][@"description"]];
            //maxTemp label now displays temp
            self.maxTemp.text = [NSString stringWithFormat:@"%@",vari[@"main"][@"temp"]];
            self.minTemp.text = [NSString stringWithFormat:@"%@", vari[@"main"][@"humidity"]];
        });
        
    }]resume];
    
}
- (IBAction)moreProperties:(id)sender {
    
    UIStoryboard *refToStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    /******** Old Code Start **************
    //UIViewController *pointerToMoreValuesVC = [refToStoryBoard instantiateViewControllerWithIdentifier:@"MorePropertiesVC"];
    //pointerToMoreValuesVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //[self presentViewController:pointerToMoreValuesVC animated:YES completion:nil];
    
    self.maxTempField.userInteractionEnabled = YES;
    self.maxTempField.text = [NSString stringWithFormat:@"%@",vari[@"main"][@"temp_max"]];
    NSLog(@"Max Temp %@", vari[@"main"][@"temp_max"]);
    
    self.atmosphericPressureField.userInteractionEnabled = YES;
    self.atmosphericPressureField.text = [NSString stringWithFormat:@"%@", vari[@"main"][@"pressure"]];
    
    self.windSpeedField.userInteractionEnabled = YES;
    self.windSpeedField.text = [NSString stringWithFormat:@"%@", vari[@"wind"][@"speed"]];
    
    NSLog(@"Speeed of the wind %@", vari[@"wind"][@"speed"]);
    ******** Old Code End *************/
    
    AllWeatherPropertiesViewController *pointerToAllWeatherPropertiesVC = [refToStoryBoard instantiateViewControllerWithIdentifier:@"AllWeatherPropertiesVC"];
    pointerToAllWeatherPropertiesVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:pointerToAllWeatherPropertiesVC animated:YES completion:nil];
    
    pointerToAllWeatherPropertiesVC.maxTempF.text = [NSString stringWithFormat:@"%@", vari[@"main"][@"temp_max"]];
    pointerToAllWeatherPropertiesVC.minTempF.text = [NSString stringWithFormat:@"%@", vari[@"main"][@"temp_min"]];
    pointerToAllWeatherPropertiesVC.tempF.text = [NSString stringWithFormat:@"%@", vari[@"main"][@"temp"]];
    pointerToAllWeatherPropertiesVC.humidityF.text = [NSString stringWithFormat:@"%@", vari[@"main"][@"humidity"]];
    pointerToAllWeatherPropertiesVC.atmPressureF.text = [NSString stringWithFormat:@"%@", vari[@"main"][@"pressure"]];
    pointerToAllWeatherPropertiesVC.weatherF.text = [NSString stringWithFormat:@"%@", vari[@"weather"][0][@"description"]];
    pointerToAllWeatherPropertiesVC.cloudCoverageF.text = [NSString stringWithFormat:@"%@", vari[@"clouds"][@"all"]];
    pointerToAllWeatherPropertiesVC.windSpeedF.text = [NSString stringWithFormat:@"%@", vari[@"wind"][@"speed"]];
    pointerToAllWeatherPropertiesVC.windDirectionF.text = [NSString stringWithFormat:@"%@", vari[@"wind"][@"deg"]];
    pointerToAllWeatherPropertiesVC.cityName.text = [NSString stringWithFormat:@"%@", vari[@"name"]];
                        
    
}


//Weather properties to be used in table view when more button is clicked: Cloud percentage, ground level, pressure, sea level, Wind speed and direction(degree).

- (IBAction)goBackToMainScreen:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*********************UITableViewDataSource protocol***************

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [moreWeatherProperties count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableIdent = @"Table Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdent];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdent];
    }
    
    cell.textLabel.text = moreWeatherProperties[indexPath.row];
    NSLog(@"Does this worl %@", cell);
    //[moreWeatherProperties objectAtIndex:indexPath.row];
    return cell;
}
 
 ****************************************************************/


//found something intresting http://stackoverflow.com/jobs/115035/interested-in-building-an-ios-apps-compucom-inc?med=clc&ref=small-sidebar-tag-themed-ios

/*
 {
 base = "cmc stations";
 clouds =     {
 all = 0;
 };
 cod = 200;
 coord =     {
 lat = "25.26";
 lon = "55.3";
 };
 dt = 1464022800;
 id = 292223;
 main =     {
 humidity = 74;
 pressure = 1004;
 temp = 86;
 "temp_max" = 86;
 "temp_min" = 86;
 };
 name = Dubai;
 sys =     {
 country = AE;
 id = 7100;
 message = "0.0036";
 sunrise = 1463967022;
 sunset = 1464015669;
 type = 1;
 };
 weather =     (
 {
 description = "clear sky";
 icon = 01n;
 id = 800;
 main = Clear;
 }
 );
 wind =     {
 deg = 250;
 speed = "6.93";
 };
 }
 */

@end

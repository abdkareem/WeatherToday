//
//  ViewController.m
//  Weather Today
//
//  Created by Taiyaba Sultana on 5/2/16.
//  Copyright © 2016 Abdul Kareem. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSMutableArray *citiesList;
    //primary api url string. everything is appended to it.
    NSMutableString *apiURLString;
}
@property (weak, nonatomic) IBOutlet UIPickerView *chooseCity;

@property (weak, nonatomic) IBOutlet UITextField *temp;
@property (weak, nonatomic) IBOutlet UITextField *maxTemp;

@property (weak, nonatomic) IBOutlet UITextField *minTemp;

- (void)setCitiesList;
- (void)setApiUrl: (NSString*)cityName;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setCitiesList];
    self.chooseCity.dataSource = self;
    self.chooseCity.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//setting data in array for picker view
- (void)setCitiesList {
    citiesList = [NSMutableArray arrayWithObjects:@"London", @"San Francisco", @"Hyderabad", @"Fremont", @"Dubai", @"Berlin", @"Sydney", @"Tokyo", nil];
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
    return citiesList[row];
}

//identifying the row selected using picker delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"Selected row is %@", citiesList[row]);
    [self setApiUrl: citiesList[row]];
}
/***********************END************************/

//setting api url string
-(void)setApiUrl: (NSString*)cityName {
    apiURLString = [NSMutableString stringWithString:@"http://api.openweathermap.org/data/2.5/weather?q="];
    [apiURLString appendString:cityName];
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
            NSLog(@"HTTP error status code %ld", pointerToDetStatusCode.statusCode);
            return;
        }
        NSError *parseError;
        id vari = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!vari) {
            NSLog(@"Parse error %@", parseError);
        }
        NSLog(@"\nThe temp is: %@",vari[@"main"][@"temp"]);
        NSLog(@"\nJSON response is: %@",vari);
        //pull main thread and put the data on UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.temp.text = [NSString stringWithFormat:@"%@",vari[@"main"][@"temp"]];
            self.maxTemp.text = [NSString stringWithFormat:@"%@",vari[@"main"][@"temp_max"]];
            self.minTemp.text = [NSString stringWithFormat:@"%@", vari[@"main"][@"temp_min"]];
        });
    }]resume];
}
 
 
@end

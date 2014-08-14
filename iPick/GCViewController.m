//
//  GCViewController.m
//  iPick
//
//  Created by Thomas Crawford on 3/6/14.
//  Copyright (c) 2014 Thomas Crawford. All rights reserved.
//

#import "GCViewController.h"

@interface GCViewController ()

@property (nonatomic,weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,weak) IBOutlet UIPickerView *myPickerView;
@property (nonatomic, weak) IBOutlet UITextField *myTextField;
@property (nonatomic,strong) NSMutableArray *flavorsArray;
@property (nonatomic,strong) NSArray *animalsArray;

@end

@implementation GCViewController

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)addButtonPressed:(id)sender {
    [_flavorsArray addObject:_myTextField.text];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentPath = [documentsDirectory stringByAppendingString:@"flavors.plist"];
    [_flavorsArray writeToFile:documentPath atomically:YES];
    [_myPickerView reloadComponent:0];
}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_flavorsArray count];
    } else if (component == 1) {
        return [_animalsArray count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [_flavorsArray objectAtIndex:row];
    } else if (component == 1) {
        return [_animalsArray objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *myString = @"Selected: ";
    myString = [myString stringByAppendingFormat:@"%@ %@",[_flavorsArray objectAtIndex:[pickerView selectedRowInComponent:0]],[_animalsArray objectAtIndex:[pickerView selectedRowInComponent:1]]];
    NSLog(@"%@",myString);
}

- (IBAction)datePickerChanged:(id)sender {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM dd, yyyy"];

    NSLog(@"Date: %@",[format stringFromDate: _datePicker.date]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_datePicker setDate:[NSDate date]];
    
    
// V implements the PList
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"flavors" ofType:@"plist"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentPath = [documentsDirectory stringByAppendingString:@"flavors.plist"];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath]) {
        NSLog(@"Will copy file");
        NSError *error = nil;
        [[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:documentPath error:&error]; }

    _flavorsArray = [[NSMutableArray alloc] initWithContentsOfFile:documentPath];
    
// ^ implements the PList
    
   
    
//  _flavorsArray = [[NSArray alloc] initWithObjects:@"Vanilla",@"Chocolate",@"Strawberry",@"Superman", @"Rocky Road", nil];
    _animalsArray = [[NSArray alloc] initWithObjects:@"Dog",@"Cat",@"Turtle",@"Horse",@"Elephant",@"Gold Fish",@"Gorilla", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

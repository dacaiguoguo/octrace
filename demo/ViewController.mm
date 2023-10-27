//
//  ViewController.m
//  demo
//
//  Created by 吴昕 on 27/06/2017.
//  Copyright © 2017 ChinaNetCenter. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewController.h"
#import "OCTraceTest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }] resume];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)onButton:(UIButton *)button {
    self.label.text = @"hello!";
    [[OCTraceTest shareInstance] test];


}


@end

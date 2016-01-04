//
//  ViewController.m
//  STAPI_Demo
//
//  Created by SenseTime on 12/29/15.
//  Copyright © 2015 SenseTime. All rights reserved.
//

#import "ViewController.h"
#import "FaceDetectionViewController.h"
#import "FaceVerifyViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableViewSTAPI;

@property (nonatomic, strong) NSArray *arraySTFunctions;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"STAPI_Demo" ;
    
    self.arraySTFunctions = @[@"Face Detection",@"Face Verify",@"Face Search"];

}

#pragma mark - 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = self.arraySTFunctions[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arraySTFunctions.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
            
        case 0:{
            FaceDetectionViewController *faceDetectionVC = [[FaceDetectionViewController alloc]init];
            [self.navigationController pushViewController:faceDetectionVC animated:YES];
        }
            break;
        case 1: {
            FaceVerifyViewController *faceDetectionVC = [[[NSBundle mainBundle]loadNibNamed:@"FaceVerifyViewController" owner:nil options:nil]firstObject];
            [self.navigationController pushViewController:faceDetectionVC animated:YES];
        }
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

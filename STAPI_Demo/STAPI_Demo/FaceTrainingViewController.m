//
//  FaceTrainingViewController.m
//  STAPI_Demo
//
//  Created by SenseTime on 16/1/4.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "FaceTrainingViewController.h"

#import "STAPI.h"
#import "STImage.h"
#import "STPerson.h"
#import "STFaceSet.h"
#import "STGroup.h"
#import "MyAPIKey.h"
#import "STCommon.h"
#import "ImageFace.h"

@interface FaceTrainingViewController ()
{
    UIImageView *_imageFaceSet;
    UIActivityIndicatorView *_indicator;
}

@property (nonatomic, strong) STAPI *lfAPI;

@end

@implementation FaceTrainingViewController

#pragma mark
#pragma mark memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark
#pragma mark view life

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.lfAPI = [[STAPI alloc] init ] ;
    self.lfAPI.bDebug = YES ;
    [self.lfAPI start_apiid:MyApiID apisecret:MyApiSecret] ;
    
    _imageFaceSet = [[UIImageView alloc] init];
    _imageFaceSet.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _imageFaceSet.image = [UIImage imageNamed:@"face_set.jpg"];
    _imageFaceSet.contentMode = UIViewContentModeScaleAspectFit;
    _imageFaceSet.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_imageFaceSet];
    
    UIButton *btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStart.frame = CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height-90, 80, 80);
    btnStart.alpha = 0.5;
    btnStart.backgroundColor = [UIColor blueColor];
    btnStart.layer.cornerRadius = 40;
    btnStart.layer.borderWidth = 8;
    btnStart.titleLabel.font = [UIFont systemFontOfSize:18];
    btnStart.layer.borderColor = [UIColor whiteColor].CGColor;
    [btnStart setTitle:@"开始" forState:UIControlStateNormal];
    [btnStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnStart addTarget:self action:@selector(onStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnStart];
    
    _indicator = [[UIActivityIndicatorView alloc] init];
    _indicator.backgroundColor = [UIColor clearColor];
    _indicator.frame = CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height/2-25, 50, 50);
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_indicator];
}


#pragma mark
#pragma mark button event

- (void)onStart
{
    [_indicator startAnimating];
    
    if ( self.lfAPI.error )
    {
        NSLog(@"返回状态: %@\n HTTPStatusCode: %d\n 异常: %@",
              self.lfAPI.status,
              self.lfAPI.httpStatusCode,
              [self.lfAPI.error description]);
        
        [_indicator stopAnimating];
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        
        STImage *stImage = [self.lfAPI face_detection_image:_imageFaceSet.image] ;
        
        //clean sets: if more than 5 sets creation will be failed
        NSDictionary *dictSets = [self.lfAPI info_list_facesets];
        NSArray *arrSets = dictSets[@"facesets"];
        if (arrSets.count > 0)
        {
            for (int i = 0; i <arrSets.count; i++)
            {
                NSString *strSet_id = arrSets[i][@"faceset_id"];
                [self.lfAPI faceset_delete_facesetid:strSet_id];
            }
        }

        //clean groups: if more than 3 groups creation will be failed
        NSDictionary *dictGroups = [self.lfAPI info_list_groups];
        NSArray *arrGroups = dictGroups[@"groups"];
        if (arrGroups.count > 0)
        {
            for (int i = 0; i <arrGroups.count; i++)
            {
                NSString *strGroup_id = arrGroups[i][@"group_id"];
                [self.lfAPI group_delete_groupid:strGroup_id];
            }
        }

        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self.lfAPI.error)
            {
                NSLog(@"返回状态: %@\n HTTPStatusCode: %d\n 异常: %@",
                      self.lfAPI.status,
                      self.lfAPI.httpStatusCode,
                      [self.lfAPI.error description]);
            }
            else
            {
                if ([self.lfAPI.status isEqualToString:STATUS_OK] &&
                    stImage.arrFaces.count > 0)
                {
                    //all kind of ids will be send into training interface
                    NSString *strIds, *strSetIds, *strPersonIds, *strGroupIds;

                    for (int i=0; i<stImage.arrFaces.count; i++)
                    {
                        //faceIds
                        ImageFace *face = [[ImageFace alloc] initWithDict:[stImage.arrFaces objectAtIndex:i] landmarksType:21];
                        
                        if (!strIds)
                        {
                            strIds = face.strFaceID;
                        }
                        else
                        {
                            strIds = [strIds stringByAppendingString:[NSString stringWithFormat:@",%@",face.strFaceID]];
                        }
                        
                        //setIds
                        STFaceSet *set = [self.lfAPI faceset_create_name:[NSString stringWithFormat:@"set%d",i] faceids:face.strFaceID userdata:@"set"];
                        if (set && set.strFaceSetID && set.iFaceCount >0)
                        {
                            if (!strSetIds)
                            {
                                strSetIds = set.strFaceSetID;
                            }
                            else
                            {
                                strSetIds = [strSetIds stringByAppendingString:[NSString stringWithFormat:@",%@",set.strFaceSetID]];
                            }
                        }
                        
                        //personIds
                        STPerson *person = [self.lfAPI person_create_name:[NSString stringWithFormat:@"person%d",i] faceids:face.strFaceID userdata:@"person"];
                        if (person && person.strPersonID && person.iFaceCount > 0)
                        {
                            if (!strPersonIds)
                            {
                                strPersonIds = person.strPersonID;
                            }
                            else
                            {
                                strPersonIds = [strPersonIds stringByAppendingString:[NSString stringWithFormat:@",%@",person.strPersonID]];
                            }
                        }
                        
                        //groupIds
                        STGroup *group = [self.lfAPI group_create_groupname:[NSString stringWithFormat:@"group%d",i] personids:person.strPersonID userdata:@"group"];
                        if (group && group.strGroupID && group.iPersonCount > 0)
                        {
                            if (!strGroupIds)
                            {
                                strGroupIds = group.strGroupID;
                            }
                            else
                            {
                                strGroupIds = [strGroupIds stringByAppendingString:[NSString stringWithFormat:@",%@",group.strGroupID]];
                            }
                        }
                    }
                    
                    //training
                    if (strIds && strSetIds && strPersonIds && strGroupIds)
                    {
                        BOOL bTraining = [self.lfAPI face_training_faceids:strIds personids:strPersonIds facesetids:strSetIds groupids:strGroupIds];
                        
                        if (bTraining)
                        {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"训练成功"
                                                                           message:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:@"确定"
                                                                 otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        else
                        {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"训练失败"
                                                                           message:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:@"确定"
                                                                 otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }
                    else if (!strIds)
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"图片错误"
                                                                       message:nil
                                                                      delegate:self
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    else if (!strSetIds)
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"创建set失败"
                                                                       message:nil
                                                                      delegate:self
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    else if (!strPersonIds)
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"创建person失败"
                                                                       message:nil
                                                                      delegate:self
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    else if (!strGroupIds)
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"创建组失败"
                                                                       message:nil
                                                                      delegate:self
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                    [_indicator stopAnimating];
                }
            }
        });
    } );
}

@end

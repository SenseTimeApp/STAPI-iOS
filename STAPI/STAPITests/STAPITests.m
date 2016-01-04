
//
//  STAPITests.m
//  STAPITests
//
//  Created by SenseTime on 16/01/04.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STAPI.h"
#import "STCommon.h"
#import "STImage.h"
#import "STGroup.h"
#import "STFaceSet.h"
#import "STPerson.h"

#error define my API key as following :
#define MyApiID 		@"********************************"
#define MyApiSecret 	@"********************************"

@implementation NSBundle (MyAppTests)

+ (NSBundle *)testBundle {
    // return the bundle which contains our test code
    return [NSBundle bundleWithIdentifier:@"com.SenseTime.STAPITests"];
}

@end


@interface STAPITests : XCTestCase

@property (nonatomic, strong) STAPI *stApi;
@property (nonatomic, strong) STPerson *personJay;
@end

@implementation STAPITests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    if ( self.stApi != nil )
        return ;
    
    self.stApi = [[STAPI alloc] init];
    [self.stApi start_apiid:MyApiID
                  apisecret:MyApiSecret] ;
    //    self.stApi.bDebug = YES ;
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test1_info {
    
    STAPI *myLFApi = [[STAPI alloc] init];
    [myLFApi start_apiid:@"test" apisecret:@"test"] ;
    NSDictionary *dictResult = [myLFApi info_api] ;
    XCTAssert ( [myLFApi.status isEqualToString:STATUS_UNAUTHORIZED]) ;
    
    
    dictResult = [self.stApi info_api] ;
    //    NSLog( @"self.stApi info_api: %@", dictResult) ;
    XCTAssert ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    
}

- (void)test2_face_detection_image {
    //    /face/detection	用于提供图片，进行人脸检测以及人脸分析
    
    NSString *strImagePath = [[NSBundle testBundle] pathForResource:@"face1" ofType:@"jpg"];
    UIImage *imageFace = [UIImage imageWithContentsOfFile:strImagePath];
    //    UIImage *imageFace = [UIImage imageNamed:@"face1.jpg"] ;
    STImage *stImage = [self.stApi face_detection_image: imageFace ];
    
    //    NSLog( @"face_detection_image: %@", stImage) ;
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage ) ;
    XCTAssertNotNil ( stImage.strImageID) ;
    XCTAssert       ( [stImage.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"face_id"] ) ;
    XCTAssert       (  stImage.arrFaces[0][@"eye_dist"] > 0 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"bottom"] > stImage.arrFaces[0][@"rect"][@"top"]   ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"left"]   < stImage.arrFaces[0][@"rect"][@"right"] ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"] count] == 21 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0] count] == 2 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][0] floatValue] >= 0 )     ; // x of Point 0
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][1] floatValue] >= 0 )     ; // y of Point 0
    
    stImage = [self.stApi face_detection_image: imageFace
                                  landmarks106: YES
                                    attributes: YES
                                      emotions: YES
                                   auto_rotate: NO
                                     user_data: @"MyFaceDetection" ];
    
    //    NSLog( @"face_detection_image: %@", stImage) ;
    XCTAssert ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssert ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage ) ;
    XCTAssertNotNil ( stImage.strImageID) ;
    XCTAssert       ( [stImage.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"face_id"] ) ;
    XCTAssert       (  stImage.arrFaces[0][@"eye_dist"] > 0 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"bottom"] > stImage.arrFaces[0][@"rect"][@"top"]   ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"left"]   < stImage.arrFaces[0][@"rect"][@"right"] ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"] count] == 21 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0] count] == 2 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][0] floatValue] >= 0 )     ; // x of Point 0
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][1] floatValue] >= 0 )     ; // y of Point 0
    
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks106"] count] == 106 ) ;
    
    XCTAssert       ( stImage.arrFaces[0][@"attributes"]                    ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"age"] >=0        ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"attributes"][@"gender"] intValue]< 50     ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"attributes"][@"eyeglass"] intValue] < 50   ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"attractive"] >=0 ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"sunglass"] >=0   ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"smile"] >=0      ) ;
    
    XCTAssert       ( stImage.arrFaces[0][@"emotions"]                    ) ;
    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"angry"] >=0 ) ;
    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"calm"] >=0 ) ;
    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"disgust"] >=0 ) ;
    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"happy"] >=0 ) ;
    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"sad"] >=0 ) ;
    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"surprised"] >=0 ) ;
    
}

- (void)test2_face_detection_url {
    //    /face/detection	用于提供图片URL，进行人脸检测以及人脸分析
    
    NSString *strUrl = @"http://images.missyuan.com/attachments/day_080127/20080127_05b8ca77b0d5a1a4aae3CslCIEfqu5Gz.jpg";
    STImage *stImage = [self.stApi face_detection_url: strUrl ];
    
    //    NSLog( @"face_detection_image: %@", stImage) ;
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage ) ;
    XCTAssertNotNil ( stImage.strImageID) ;
    XCTAssert       ( [stImage.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"face_id"] ) ;
    XCTAssert       (  stImage.arrFaces[0][@"eye_dist"] > 0 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"bottom"] > stImage.arrFaces[0][@"rect"][@"top"]   ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"left"]   < stImage.arrFaces[0][@"rect"][@"right"] ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"] count] == 21 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0] count] == 2 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][0] floatValue] >= 0 )     ; // x of Point 0
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][1] floatValue] >= 0 )     ; // y of Point 0
    
    stImage = [self.stApi face_detection_url: strUrl
                                landmarks106: YES
                                  attributes: YES
                                    emotions: YES
                                 auto_rotate: NO
                                   user_data: @"MyFaceDetection" ];
    
    //    NSLog( @"face_detection_image: %@", stImage) ;
    XCTAssert ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssert ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage ) ;
    XCTAssertNotNil ( stImage.strImageID) ;
    XCTAssert       ( [stImage.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"face_id"] ) ;
    XCTAssert       (  stImage.arrFaces[0][@"eye_dist"] > 0 ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"bottom"] > stImage.arrFaces[0][@"rect"][@"top"]   ) ;
    XCTAssert       (  stImage.arrFaces[0][@"rect"][@"left"]   < stImage.arrFaces[0][@"rect"][@"right"] ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"] count] == 21 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0] count] == 2 ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][0] floatValue] >= 0 )     ; // x of Point 0
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks21"][0][1] floatValue] >= 0 )     ; // y of Point 0
    
    XCTAssert       ( [stImage.arrFaces[0][@"landmarks106"] count] == 106 ) ;
    
    XCTAssert       ( stImage.arrFaces[0][@"attributes"]                    ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"age"] >=0        ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"attributes"][@"gender"] intValue]< 50     ) ;
    XCTAssert       ( [stImage.arrFaces[0][@"attributes"][@"eyeglass"] intValue] < 50   ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"attractive"] >=0 ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"sunglass"] >=0   ) ;
    XCTAssert       ( stImage.arrFaces[0][@"attributes"][@"smile"] >=0      ) ;
    
    XCTAssert       ( stImage.arrFaces[0][@"emotions"]                    ) ;
    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"angry"] >=0 ) ;
    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"calm"] >=0 ) ;
    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"disgust"] >=0 ) ;
    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"happy"] >=0 ) ;
    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"sad"] >=0 ) ;
    XCTAssert       ( stImage.arrFaces[0][@"emotions"][@"surprised"] >=0 ) ;
    
}

- (void)test2_face_verification{
    //    /face/verification	将一张人脸与一个人（或者一张脸）进行对比，来判断是否为同一个人
    NSString *strImagePath1 = [[NSBundle testBundle] pathForResource:@"face1" ofType:@"jpg"];
    UIImage *imageface1 = [UIImage imageWithContentsOfFile:strImagePath1];
    STImage *stImage1 = [self.stApi face_detection_image: imageface1 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage1 ) ;
    XCTAssert       ( [stImage1.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage1.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID1 = stImage1.arrFaces[0][@"face_id"] ;
    
    NSString *strImagePath2 = [[NSBundle testBundle] pathForResource:@"face2" ofType:@"jpg"];
    UIImage *imageface2 = [UIImage imageWithContentsOfFile:strImagePath2];
    STImage *stImage2 = [self.stApi face_detection_image: imageface2 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage2 ) ;
    XCTAssert       ( [stImage2.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage2.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID2 = stImage2.arrFaces[0][@"face_id"] ;
    
    float fScoreSame = [self.stApi face_verification_faceid:strFaceID1 face2id:strFaceID2] ;
    //    NSLog(@"face verify Same : %f", fScoreSame ) ;
    XCTAssert( fScoreSame > 0.7 ) ;
    
    NSString *strImagePath3 = [[NSBundle testBundle] pathForResource:@"face3" ofType:@"jpg"];
    UIImage *imageFace3 = [UIImage imageWithContentsOfFile:strImagePath3];
    STImage *stImage3 = [self.stApi face_detection_image: imageFace3 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage3 ) ;
    XCTAssert       ( [stImage3.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage3.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID3 = stImage3.arrFaces[0][@"face_id"] ;
    
    float fScoreDiff = [self.stApi face_verification_faceid:strFaceID1 face2id:strFaceID3] ;
    //    NSLog(@"face verify Diff : %f", fScoreDiff ) ;
    XCTAssert( fScoreDiff < 0.5 ) ;
    
}

- (void)test3_FaceSet {
    
    NSDictionary *dictFaceset = [self.stApi info_list_facesets];
    NSArray *arr = dictFaceset[@"facesets"];
    
    if (arr.count > 0) {
        for (int i = 0; i <arr.count; i++) {
            NSString *strFaceset_id = arr[i][@"faceset_id"];
            [self.stApi faceset_delete_facesetid:strFaceset_id];
        }
        
    }
    
    //create FaceSet with 1 face
    NSString *strImagePath1 = [[NSBundle testBundle] pathForResource:@"face1" ofType:@"jpg"];
    UIImage *imageFace1 = [UIImage imageWithContentsOfFile:strImagePath1];
    STImage *stImage1 = [self.stApi face_detection_image: imageFace1 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage1 ) ;
    XCTAssert       ( [stImage1.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage1.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID1 = stImage1.arrFaces[0][@"face_id"] ;
    
    STFaceSet *stFaceSet = [self.stApi faceset_create_name:@"test_faceset" faceids:strFaceID1 userdata:@"sensetime_search"];
    
    XCTAssertNotNil(stFaceSet);
    [self.stApi faceset_delete_facesetid:stFaceSet.strFaceSetID];
    
    //create FaceSet with 2 faces
    NSString *strImagePath2 = [[NSBundle testBundle] pathForResource:@"face2" ofType:@"jpg"];
    UIImage *imageFace2 = [UIImage imageWithContentsOfFile:strImagePath2];
    STImage *stImage2 = [self.stApi face_detection_image: imageFace2 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage2 ) ;
    XCTAssert       ( [stImage2.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage2.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID2 = stImage2.arrFaces[0][@"face_id"] ;
    
    NSString *strFaceids = [NSString stringWithFormat:@"%@,%@",strFaceID1,strFaceID2];
    STFaceSet *stFaceSet2 = [self.stApi faceset_create_name:@"test_faceset" faceids:strFaceids userdata:@"sensetime_search"];
    XCTAssertNotNil(stFaceSet2);
    XCTAssertTrue(stFaceSet2.iFaceCount == 2);
    
    [self.stApi faceset_delete_facesetid:stFaceSet2.strFaceSetID];
    
    NSDictionary *dictFaceset3 = [self.stApi info_list_facesets];
    NSArray *arr2 = dictFaceset3[@"facesets"];
    
    XCTAssertTrue(arr2.count == 0);
}


//    /face/search	在众多人脸中搜索出与目标人脸最为相似的一张或者多张人脸
- (void)test3_face_search{
    
    NSDictionary *dictFaceset = [self.stApi info_list_facesets];
    NSArray *arr = dictFaceset[@"facesets"];
    
    if (arr.count > 0) {
        for (int i = 0; i <arr.count; i++) {
            NSString *strFaceset_id = arr[i][@"faceset_id"];
            [self.stApi faceset_delete_facesetid:strFaceset_id];
        }
        
    }
    
    
    NSMutableString * muStringFaceids = [NSMutableString string];
    
    NSString *strImagePath1 = [[NSBundle testBundle] pathForResource:@"face1" ofType:@"jpg"];
    UIImage *imageFace1 = [UIImage imageWithContentsOfFile:strImagePath1];
    STImage *stImage1 = [self.stApi face_detection_image: imageFace1 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage1 ) ;
    XCTAssert       ( [stImage1.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage1.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID1 = stImage1.arrFaces[0][@"face_id"] ;
    //    [muStringFaceids appendFormat:@"%@",strFaceID1];
    
    NSString *strImagePath2 = [[NSBundle testBundle] pathForResource:@"face2" ofType:@"jpg"];
    UIImage *imageFace2 = [UIImage imageWithContentsOfFile:strImagePath2];
    STImage *stImage2 = [self.stApi face_detection_image: imageFace2 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage2 ) ;
    XCTAssert       ( [stImage2.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage2.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID2 = stImage2.arrFaces[0][@"face_id"] ;
    [muStringFaceids appendFormat:@"%@",strFaceID2];
    
    
    NSString *strImagePath3 = [[NSBundle testBundle] pathForResource:@"face3" ofType:@"jpg"];
    UIImage *imageFace3 = [UIImage imageWithContentsOfFile:strImagePath3];
    STImage *stImage3 = [self.stApi face_detection_image: imageFace3 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage3 ) ;
    XCTAssert       ( [stImage3.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage3.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID3 = stImage3.arrFaces[0][@"face_id"] ;
    [muStringFaceids appendFormat:@",%@",strFaceID3];
    
    
    
    //create FaceSet
    STFaceSet *stFaceSet = [self.stApi faceset_create_name:@"sensetime_search" faceids:muStringFaceids userdata:@"sensetime_search"];
    XCTAssertNotNil(stFaceSet);
    XCTAssertTrue(stFaceSet.iFaceCount == 2);
    
    // search
    NSDictionary *dict = [self.stApi face_search_faceid:strFaceID1 facesetid:stFaceSet.strFaceSetID topnum:1];
    XCTAssertNotNil(dict);
    //    NSLog(@"search dict = %@",dict);
    
    //delete stPerson
    BOOL bDel = [self.stApi faceset_delete_facesetid:stFaceSet.strFaceSetID];
    
    XCTAssert(bDel == 1);
    
}

- (void)test4_person {
    
    //    NSLog(@"test_person = %@",[self.stApi info_list_persons]);
    sleep(1);
    
    NSMutableString * muStringFaceids = [NSMutableString string];
    
    NSString *strImagePath1 = [[NSBundle testBundle] pathForResource:@"face1" ofType:@"jpg"];
    UIImage *imageFace1 = [UIImage imageWithContentsOfFile:strImagePath1];
    STImage *stImage1 = [self.stApi face_detection_image: imageFace1 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage1 ) ;
    XCTAssert       ( [stImage1.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage1.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID1 = stImage1.arrFaces[0][@"face_id"] ;
    [muStringFaceids appendFormat:@"%@",strFaceID1];
    
    NSString *strImagePath2 = [[NSBundle testBundle] pathForResource:@"face2" ofType:@"jpg"];
    UIImage *imageFace2 = [UIImage imageWithContentsOfFile:strImagePath2];
    STImage *stImage2 = [self.stApi face_detection_image: imageFace2 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage2 ) ;
    XCTAssert       ( [stImage2.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage2.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID2 = stImage2.arrFaces[0][@"face_id"] ;
    [muStringFaceids appendFormat:@",%@",strFaceID2];
    
    
    STPerson *stPerson = [self.stApi person_create_name:@"person_Jay" faceids:muStringFaceids userdata:nil];
    XCTAssertNotNil(stPerson);
    XCTAssertNotNil(stPerson.strPersonID);
    XCTAssertTrue (2 == stPerson.iFaceCount);
    
    //    NSLog(@"%@",stPerson);
    
    self.personJay = stPerson;
    
}


- (void)test5_group {
    
    NSDictionary *dictGroups = [self.stApi info_list_groups];
    NSArray *arr = dictGroups[@"groups"];
    
    if (arr.count > 0) {
        for (int i = 0; i <arr.count; i++) {
            NSString *strGroup_id = arr[i][@"group_id"];
            [self.stApi group_delete_groupid:strGroup_id];
        }
        
    }
    
    if (! self.personJay ) {
        [self test4_person];
    }
    
    // create group
    STGroup *stGroup = [self.stApi group_create_groupname:@"sensetime_group" personids:self.personJay.strPersonID userdata:nil];
    //    NSLog(@"  %@",self.stApi.status);
    XCTAssertNotNil(stGroup);
    XCTAssert   ( stGroup.iPersonCount == 1);
    BOOL bDel = [self.stApi group_delete_groupid:stGroup.strGroupID];
    XCTAssertTrue( bDel);
    
    
}

//    /face/identification	将一个目标人脸与某个组中的所有人进行对比，找出几个与该人脸最相似的人
- (void)test5_Idenfitication {
    
    
    NSString *strImagePath1 = [[NSBundle testBundle] pathForResource:@"face1" ofType:@"jpg"];
    UIImage *imageFace1 = [UIImage imageWithContentsOfFile:strImagePath1];
    STImage *stImage1 = [self.stApi face_detection_image: imageFace1 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage1 ) ;
    XCTAssert       ( [stImage1.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage1.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID1 = stImage1.arrFaces[0][@"face_id"] ;
    
    
    NSString *strImagePath2 = [[NSBundle testBundle] pathForResource:@"face3" ofType:@"jpg"];
    UIImage *imageFace2 = [UIImage imageWithContentsOfFile:strImagePath2];
    STImage *stImage2 = [self.stApi face_detection_image: imageFace2 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage2 ) ;
    XCTAssert       ( [stImage2.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage2.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID2 = stImage2.arrFaces[0][@"face_id"] ;
    
    
    NSDictionary *dictGroups = [self.stApi info_list_groups];
    NSArray *arr = dictGroups[@"groups"];
    
    if (arr.count > 0) {
        for (int i = 0; i <arr.count; i++) {
            NSString *strGroup_id = arr[i][@"group_id"];
            [self.stApi group_delete_groupid:strGroup_id];
        }
        
    }
    
    if (! self.personJay ) {
        [self test4_person];
    }
    
    // create group
    STGroup *stGroup = [self.stApi group_create_groupname:@"sensetime_group" personids:self.personJay.strPersonID userdata:nil];
    //    NSLog(@"  %@",self.stApi.status);
    XCTAssertNotNil(stGroup);
    XCTAssert   ( stGroup.iPersonCount == 1);
    
    
    //相似（或同一个）
    NSDictionary *dictIndenfity1 = [self.stApi face_identification_faceid:strFaceID1 groupid:stGroup.strGroupID topnum:1];
    XCTAssertNotNil(dictIndenfity1);
    //    NSLog(@"Indenfity dict = %@",dictIndenfity1);
    XCTAssert ([dictIndenfity1[@"candidates"] count] > 0);
    
    //不相似
    NSDictionary *dictIndenfity2 = [self.stApi face_identification_faceid:strFaceID2 groupid:stGroup.strGroupID topnum:1];
    XCTAssertNotNil(dictIndenfity2);
    //    NSLog(@"Indenfity dict = %@",dictIndenfity2);
    XCTAssert ([dictIndenfity2[@"candidates"] count] == 0);
    
    //    XCTAssert(dictIndenfity[@"confidence"]
    
    
    BOOL bDel = [self.stApi group_delete_groupid:stGroup.strGroupID];
    XCTAssertTrue( bDel);
    
    
}
//    /face/training	可以对人脸、人、人脸集合、组进行训练，提取其中的人脸信息
- (void)test6_training {
    
}
//    /face/grouping	将一堆人脸根据其之间的相似度进行分类，同一个人的人脸为一类



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

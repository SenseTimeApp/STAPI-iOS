//
//  STAPITests.m
//  STAPITests
//
//  Created by SenseTime on 15/12/22.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STAPI.h"
#import "STCommon.h"
#import "STImage.h"

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
    
    STAPI *mySTApi = [[STAPI alloc] init];
    [mySTApi start_apiid:@"test" apisecret:@"test"] ;
    NSDictionary *dictResult = [mySTApi info_api] ;
    XCTAssert ( [mySTApi.status isEqualToString:STATUS_UNAUTHORIZED]) ;

    
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
}

- (void)test2_face_verification{
    //    /face/verification	将一张人脸与一个人（或者一张脸）进行对比，来判断是否为同一个人
    NSString *strImagePath1 = [[NSBundle testBundle] pathForResource:@"face1" ofType:@"jpg"];
    UIImage *imageFace1 = [UIImage imageWithContentsOfFile:strImagePath1];
    STImage *stImage1 = [self.stApi face_detection_image: imageFace1 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage1 ) ;
    XCTAssert       ( [stImage1.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage1.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID1 = stImage1.arrFaces[0][@"face_id"] ;

    NSString *strImagePath2 = [[NSBundle testBundle] pathForResource:@"face2" ofType:@"jpg"];
    UIImage *imageFace2 = [UIImage imageWithContentsOfFile:strImagePath2];
    STImage *stImage2 = [self.stApi face_detection_image: imageFace2 ];
    XCTAssert       ( [self.stApi.status isEqualToString:STATUS_OK]) ;
    XCTAssertNotNil ( stImage2 ) ;
    XCTAssert       ( [stImage2.arrFaces count] == 1 ) ;
    XCTAssert       (  stImage2.arrFaces[0][@"face_id"] ) ;
    NSString *strFaceID2 = stImage2.arrFaces[0][@"face_id"] ;
    
    float fScoreSame = [self.stApi face_verification_faceid:strFaceID1 face2id:strFaceID2] ;
    NSLog(@"face verify Same : %f", fScoreSame ) ;
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
    NSLog(@"face verify Diff : %f", fScoreDiff ) ;
    XCTAssert( fScoreDiff < 0.5 ) ;
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

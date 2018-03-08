//
//  CanvasViewController.h
//  MNA
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

//#import "PdfReaderViewController.h"

@protocol CanvasDelegate <NSObject>
@optional
-(void)ResetCanvas:(NSString*)str;
-(void)SaveCanvaswithNewsid:(NSInteger)newsId JsonString:(NSString*)jsonString AnnotationId:(NSNumber*)anoatationId DrawImage:(UIImage*)image  FileName:(NSString*)fileName;
-(void)DeleteCanvas:(NSString*)anotationId NewsPaperId:(NSInteger)newsPaperId FileName:(NSString*)fileName;
-(void)CancelCanvas:(NSInteger)tagId NewsPaperId:(NSString*)newsPaperId;
@end

@interface CanvasViewController : UIViewController<UIActionSheetDelegate>{
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    
}

@property(weak,nonatomic) id<CanvasDelegate> delegate;
@property (nonatomic,retain) NSString *userId;
@property (nonatomic, assign) float minZoomScale1;
@property (nonatomic, assign) CGFloat zoomScale;
@property (nonatomic, assign) NSUInteger *page;
@property (nonatomic, retain) NSManagedObject * mangeAnnotationObj;
@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic,retain) NSString *imageName;

+(NSNumber *)getAnnotationId:(NSNumber *) newspaperId;





//@property (retain,nonatomic) PdfReaderViewController *pdfReader;
@property (retain, nonatomic) IBOutlet UIImageView *mainImage;
@property (retain, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic,retain) NSNumber *annotationId;
@property (nonatomic,retain) NSNumber *lastAnnotationId;
@property (nonatomic,retain) NSNumber *newspaperId;

@property (nonatomic,retain) NSString *CanvasFilename;
//@property (nonatomic,retain) NSString *Title;
@property (nonatomic,retain) NSString *NotesDatetime;



- (IBAction)dismissView:(id)sender;

- (IBAction)pencilPressed:(id)sender;
- (IBAction)eraserPressed:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)delete1:(id)sender;

- (BOOL)getCommentImage:(NSNumber *) annotationId;

@end

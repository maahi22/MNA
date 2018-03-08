//
//  PdfReaderViewController.h
//  MNA
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

#import <FastPdfKit/FastPdfKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CanvasViewController.h"
#import "CommentViewController.h"
#import <CoreData/CoreData.h>


@protocol PdfReaderDelegate <NSObject>
-(void)Pdf_ResetCanvas:(NSString*)selDictionary;
-(void)Pdf_SaveCanvas:(NSInteger)newspaperId  JsonString:(NSString*)jsonString  Draw:(UIImage*)drawImage FileName:(NSString*)fileName;
-(void)Pdf_DeleteCanvas:(NSString*)anotationId NewsPaperId:(NSInteger)newsPaperId  FileName:(NSString*)fileName;


-(void)Pdf_SaveComment:(NSString*)JsonString  saveCommentText:(NSString*)CommentText NewspaperId :(NSInteger)newspaperId;
-(void)Pdf_DeleteComment :(NSUInteger)NewspaperId AnnotationId:(NSUInteger)anotationId;
@end


@interface PdfReaderViewController : ReaderViewController<MFDocumentViewControllerDelegate,UIPopoverControllerDelegate,UIScrollViewDelegate,MFDocumentOverlayDataSource,MFMailComposeViewControllerDelegate,UIAlertViewDelegate, CanvasDelegate,CommentDelegate>{
    
    BOOL blActivateComment;
    BOOL blActivateCanvas;
    BOOL isToolBarVisible;
    BOOL blAddPushpin;
    BOOL blUpdated;
    
    NSString *TagText;
    BOOL isApprovedjob;
    BOOL isFirsttime;
    int counter;
    
}

@property(weak,nonatomic) id<PdfReaderDelegate> pdfdelegate;
@property (nonatomic, retain) NSMutableArray *mangeObjectArray;
@property (nonatomic, retain) NSManagedObject * mangeAnnotationObject;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, assign) NSUInteger *page;
@property (nonatomic, assign) NSInteger *currentAnnotationId;
@property (nonatomic, assign) NSInteger currentPinTag;
@property (nonatomic, assign) NSString* imageFileName;
@property (nonatomic, assign) BOOL dismisSts;


@property (nonatomic, retain) UIPopoverController *popoverController1;
@property (nonatomic, retain) NSMutableDictionary *JobInfo;
@property (nonatomic, retain) NSMutableDictionary *ZoomInfo;

@property (nonatomic, retain) UIImageView *thumbnailView;

@property (nonatomic, retain) NSString *TagText;
@property (nonatomic, retain)  NSString *RvKey;
@property (nonatomic, retain) NSMutableArray *SelectedRvKeys;
@property (nonatomic, retain) UIToolbar *ToolBar1;

@property (nonatomic, assign) BOOL blAddPushpin;
@property (nonatomic, assign) BOOL blAddPushPin;
@property (nonatomic, assign) float minZoomScale;

@property (nonatomic, assign) CGRect proofCropBox;
@property (nonatomic, assign) float xAxispadding;
@property (nonatomic, assign) float yAxispadding;
@property (nonatomic, retain) NSNumber *newspaperId;
@property (nonatomic, retain) NSURL *fileURL;
@property (nonatomic, retain) NSString *fileName;


@property (nonatomic,retain) NSArray *glyphBoxes;
@property (nonatomic,retain) NSMutableArray *selectedArea;

-(void)addPushPin:(CGPoint) point  PushPinImage:(NSString *) image;
-(void)addPushPin:(CGPoint) point Page:(int) pdfFrame PushPinImage:(NSString *) image;
-(void)addPushPin:(CGPoint) point Tag:(int)tagValue PushPinImage:(NSString *) image;
-(void)deletePushPin:(NSNumber *) annotationId;


-(void)ShowCommentPopup:(CGPoint) touchedPoint AnnotationId:(NSNumber *) annotationId;
-(void)ShowCommentCanvas:(CGPoint) touchedPoint AnnotationId:(NSNumber *) annotationId;
-(void)addPushPin:(CGPoint) point Tag:(int) tagValue PushPinImage:(NSString *) image CommentType:(NSString *)commentType;

//For Search
@property (nonatomic, retain) NSString *searchStr;
@property (nonatomic, retain) MFDocumentManager *documentManagerSearch ;
-(void)callOverlay;

@end

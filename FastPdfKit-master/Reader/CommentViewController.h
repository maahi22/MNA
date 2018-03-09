//
//  CommentViewController.h
//  MNA
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@protocol CommentDelegate <NSObject>
@optional
-(void)SaveComment:(NSString*)JsonString  CommentText:(NSString*)CommentText NewspaperId :(NSInteger)newsId AnnotationId:(NSNumber*)anoatationId;
-(void)DeleteComment:(NSInteger)NewspaperId AnnotationId:(NSNumber*)anoatationId;
@end

@interface CommentViewController : UIViewController<UIActionSheetDelegate>{
    CGPoint point;
    
    UIToolbar *toolBarComments;
    BOOL blDeletePushpin;
    BOOL isRevision;
    
}

@property(weak,nonatomic) id<CommentDelegate> delegate;

@property (nonatomic,retain) NSString *userId;
@property (nonatomic, assign) float minZoomScale1;
@property (nonatomic, assign) CGFloat zoomScale;
@property (nonatomic, assign) NSUInteger *page;
@property (nonatomic, retain) NSManagedObject * mangeAnnotationObj;
+(NSNumber *)getAnnotationId:(NSNumber *) newspaperId;

@property (nonatomic,retain) NSString* Comments;
@property (nonatomic,retain) NSString* NotesDatetime;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSNumber *annotationId;
@property (nonatomic,retain) NSNumber *lastAnnotationId;
@property (nonatomic,retain) NSNumber *newspaperId;
@property (nonatomic, retain) NSString *PushPinId;
@property (nonatomic,retain) NSNumber *updateAnnId;

- (IBAction)dismissView:(id)sender;

- (BOOL)getComments:(NSString *) pushPinId PosX:(int) x PosY:(int) y;
- (BOOL)getComments:(NSString *) pushPinId;

@property (nonatomic, retain) IBOutlet UIToolbar *toolBarComments;
@property (retain, nonatomic) IBOutlet UIButton *btnApply;
@property (retain, nonatomic) IBOutlet UIButton *btnDelete;
@property (nonatomic, retain) IBOutlet UILabel *lblcreationDate;
@property (nonatomic, retain) IBOutlet UITextView *textViewComment;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, retain) IBOutlet UILabel *textTitle;

@property (nonatomic,assign) BOOL blDeletePushpin;
@property (nonatomic,assign) BOOL isRevision;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Popover:(UIPopoverController **)pop;

@end

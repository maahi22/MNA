//
//  CommentsPopupView.h
//  MNA
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdfReaderViewController.h"

@protocol CommentsDelegate <NSObject>
-(void)SaveComment:(NSString*)JsonString  CommentText:(NSString*)CommentText NewspaperId :(NSString*)String;
-(void)DeleteComment:(NSString*)NewspaperId;
@end

@interface CommentsPopupView : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    
    //PdfReaderViewController *pdfReader;
    UITextView *textViewComment;
    CGPoint point;
    UINavigationBar *navigationBar;
    UILabel *lblcreationDate;
    NSString *Comments;
    NSString *Title;
    NSString *NotesDatetime;
    UILabel *textTitle;
    UIWebView* webViewPDFLink;
    //int iRevisionCounter;
    UIToolbar *toolBarComments;
    BOOL blDeletePushpin;
    BOOL isRevision;
}
@property(weak,nonatomic) id<CommentsDelegate> delegate;


- (IBAction)btnCommentDone:(id)sender;
- (IBAction)btnCommentDelete:(id)sender;
- (BOOL)getComments:(NSString *) pushPinId PosX:(int) x PosY:(int) y;
- (BOOL)getComments:(NSString *) pushPinId;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBarComments;
@property (retain, nonatomic) IBOutlet UIButton *btnApply;
@property (retain, nonatomic) IBOutlet UIButton *btnDelete;

@property (nonatomic, retain) IBOutlet UITextView *textViewComment;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UILabel *lblcreationDate;

@property (nonatomic,retain) NSString *Comments;
@property (nonatomic,retain) NSString *Title;
@property (nonatomic,retain) NSString *NotesDatetime;

@property (nonatomic,retain) NSNumber *annotationId;
@property (nonatomic, retain) IBOutlet UILabel *textTitle;
@property (nonatomic,retain) IBOutlet UIWebView* webViewPDFLink;
//@property (retain) PdfReaderViewController *pdfReader;

@property (nonatomic,assign) BOOL blDeletePushpin;
@property (nonatomic,assign) BOOL isRevision;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Popover:(UIPopoverController **)pop;

@end

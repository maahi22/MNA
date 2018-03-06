//
//  CommentsPopupView.m
//  MNA
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

#import "CommentsPopupView.h"

@interface CommentsPopupView ()

@end

@implementation CommentsPopupView
@synthesize btnApply;
@synthesize btnDelete;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Popover:(UIPopoverController **)pop{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    textViewComment.text=Comments ;
    [textViewComment becomeFirstResponder];
 //   textTitle.text = del.UserId;
    lblcreationDate.text=self.NotesDatetime;
    textViewComment.layer.cornerRadius=6.0;
    textViewComment.layer.borderWidth=.15;
    textViewComment.clipsToBounds=YES;
    [btnDelete setHidden:isRevision];
    [btnApply setHidden:isRevision];
    
    textViewComment.text = @"hi whats wrong going on";
    textTitle.text =  @"hi whats wrong going on";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.toolbarHidden=NO;
    self.navigationController.toolbar.barStyle=UIBarStyleBlackTranslucent;
    self.navigationItem.title=Title;
}

- (IBAction)btnCommentDone:(id)sender
{
    
    NSLog(@"btnCommentDone");
    
    
    /*if (!del.isInternetActive) {
        if (self.pdfReader.popoverController1.popoverVisible) {
            [self.pdfReader.popoverController1 dismissPopoverAnimated:YES];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection" message:@"This application requires a WiFi or cellular network to connect to the server. Please ensure that you have an active connection and/or Airplane mode is turned off." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        //        [del.activityIndicator stopAnimating];
    }
    else{
        
        del = (TBLITEAppDelegate *) [UIApplication sharedApplication].delegate;
        //NSLog(@"%@ ---%@",self.textViewComment.text,del.PushPinId);
        NSLog(@"page:%d",self.pdfReader.page);
        if ( self.textViewComment.text!=nil && ![textViewComment.text isEqualToString:@""] ) {
            
            NSDateFormatter *formatter;
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"];
            NSDate *date=[formatter dateFromString:lblcreationDate.text];
            NSTimeInterval ti=[date timeIntervalSince1970];
            NSLog(@"date:%qi",(long long)ti);
            
            if (self.pdfReader.minZoomScale<1.0) {
                self.pdfReader.minZoomScale=1;
            }
            
            float zmScale=self.pdfReader.minZoomScale*self.pdfReader.zoomScale;
            if (zmScale<1.0) {
                zmScale=1;
            }
            float x1=point.x/zmScale;
            float y1=point.y/zmScale;
            
            NSNumber *annotationId=[CommonHelper getAnnotationId:self.pdfReader.newspaperId];
            if (self.annotationId!=nil) {
                annotationId=self.annotationId;
                
            }
            NSString *strComment=[self.textViewComment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            strComment=[strComment stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            
            NSString *annotation=[NSString stringWithFormat:@"{\"UserId\":\"%@\",\"NewspaperId\":%@,\"Annotation\":[{\"id\":%@,\"type\":\"text\",\"PointX\":%f,\"PointY\":%f,\"createdOn\":%qi,\"pageNumber\":%d,\"annotationText\":\"%@\",\"imageName\":\"\",\"borderThickness\":0,\"drawingType \": \"p\",\"lineColor\":0,\"height \":0,\"width\":0,\"lineThickness \":0,\"xInMinus\" : false,\"yInMinus\":false}]}",del.UserId,self.pdfReader.newspaperId,annotationId,x1,y1,(long long)ti,self.pdfReader.page,strComment];
            
            [CommonHelper saveAnnotations:annotation];
            //[CommonHelper saveAnnotations:[NSNumber numberWithInt:0] Point:point PageNumber:self.pdfReader.page AnnotationText:self.textViewComment.text NewsPaperId:[NSNumber numberWithInt:2]];
            
            //NSLog(@"x1");
            
            if (self.annotationId==nil) {
                
                [self.pdfReader addPushPin:point Tag:[annotationId integerValue] PushPinImage:@"ppbtn.png"];
            }
            
            self.annotationId=nil;
            if (self.pdfReader.popoverController1.popoverVisible) {
                [self.pdfReader.popoverController1 dismissPopoverAnimated:YES];
            }
            del.PushPinId=nil;
        }
        else    {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please insert your comments and click Apply." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            [alert  release];
        }
    }*/
}

- (IBAction)btnCommentDelete:(id)sender {
   
    NSLog(@"btnCommentDelete");
    
    /* if (!del.isInternetActive) {
        if (self.pdfReader.popoverController1.popoverVisible) {
            [self.pdfReader.popoverController1 dismissPopoverAnimated:YES];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection" message:@"This application requires a WiFi or cellular network to connect to the server. Please ensure that you have an active connection and/or Airplane mode is turned off." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        //        [del.activityIndicator stopAnimating];
    }
    else{
        if (self.annotationId!=nil) {
            UIAlertView* alert =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Deleting this pushpin will also delete the comment. You cannot undo this operation." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil ];
            [alert show];
            
            
        }
    }*/
    
}

//---overloaded function fires when pushpin are dragged
- (BOOL)getComments:(NSString*) pushPinId PosX:(int) x PosY:(int) y{
   /* IProofData *prdata=[del.Annotations  objectForKey:pushPinId];
    if (prdata!=nil) {
        self.Comments=prdata.Notes;
        self.NotesDatetime=[CommonHelper getDateFromEpochDate:prdata.creationDate];
        self.Title=prdata.userName;
        del.PushPinId=pushPinId;
        self.isRevision =NO;
        return YES;
    }*/
    return NO;
}

- (BOOL)getComments:(NSNumber *) annotationId{
    /*if (del.Annotations !=nil && [del.Annotations count]>0) {
        for (NSDictionary *pushpinObj in del.Annotations) {
            if(annotationId !=nil && [[pushpinObj objectForKey:@"id"] isEqualToNumber:annotationId]){
                self.Comments= [[pushpinObj objectForKey:@"annotationText"] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                self.NotesDatetime=[CommonHelper getDateFromEpochDate:[NSString stringWithFormat:@"%@",[pushpinObj objectForKey:@"createdOn"]]];
                self.annotationId=annotationId;
                //self.Title=prData.userName;
                //self.NotesDatetime=[CommonHelper ];
                return YES;
            }
        }
    }*/
    return NO;
}

#pragma delete pushpin
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex   {
    /*if (buttonIndex==1) {
        if (del.Annotations !=nil && [del.Annotations count]>0) {
            if ([CommonHelper deleteAnnotation:self.annotationId NewsPaperId:self.pdfReader.newspaperId]) {
                [self.pdfReader deletePushPin:self.annotationId];
                if (self.pdfReader.popoverController1.popoverVisible) {
                    [self.pdfReader.popoverController1 dismissPopoverAnimated:YES];
                }
                self.textViewComment.text=@"";
                self.annotationId=nil;
            }
        }
    }*/
}


@end

//
//  CommentViewController.m
//  MNA
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

#import "CommentViewController.h"
#import "IProofData.h"



@interface CommentViewController ()

@end

@implementation CommentViewController

@synthesize newspaperId;
@synthesize annotationId;
@synthesize btnApply;
@synthesize btnDelete;
@synthesize textViewComment;
@synthesize lblcreationDate;
@synthesize textTitle,isRevision,Comments,userId;
@synthesize PushPinId;


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
    
    textViewComment.text = Comments ;
    [textViewComment becomeFirstResponder];
    textTitle.text = self.userId;
    lblcreationDate.text=self.NotesDatetime;
    textViewComment.layer.cornerRadius=6.0;
    textViewComment.layer.borderWidth=.15;
    textViewComment.clipsToBounds=YES;
    [btnDelete setHidden:isRevision];
    [btnApply setHidden:isRevision];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.view.superview.bounds = CGRectMake(0, 0, 278, 175);
    
    self.navigationController.toolbarHidden=NO;
    self.navigationController.toolbar.barStyle=UIBarStyleBlackTranslucent;
    //self.navigationItem.title=Title;
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


- (IBAction)dismissView:(id)sender {
    NSLog(@"dismissView Comment");
    [self dismissModalViewControllerAnimated:true];
}


- (IBAction)btnCommentDone:(id)sender {
    
    if ([textViewComment.text isEqualToString: @""]){
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please insert your comments and click Apply." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }else{
        
        NSDateFormatter *formatter;
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"];
        NSDate *date=[formatter dateFromString:lblcreationDate.text];
        NSTimeInterval ti=[date timeIntervalSince1970];
        NSLog(@"date:%qi",(long long)ti);
        
        if (self.minZoomScale1<1.0) {
            self.minZoomScale1=1;
        }
        
        float zmScale=self.minZoomScale1*self.zoomScale;
        if (zmScale<1.0) {
            zmScale=1;
        }
        float x1=self.point.x/zmScale;
        float y1=self.point.y/zmScale;
        
        
        NSNumber *annId=[self getAnnotationId:self.newspaperId];
        if (self.annotationId != nil && [self.annotationId integerValue] != 0) {
            annId = self.annotationId;
        }else{
            self.annotationId = annId;
        }
        
        
        NSString *strComment=[self.textViewComment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        strComment=[strComment stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        
        NSString *annotationJson=[NSString stringWithFormat:@"{\"UserId\":\"%@\",\"NewspaperId\":%@,\"Annotation\":[{\"id\":%@,\"type\":\"text\",\"PointX\":%f,\"PointY\":%f,\"createdOn\":%qi,\"pageNumber\":%d,\"annotationText\":\"%@\",\"imageName\":\"\",\"borderThickness\":0,\"drawingType \": \"p\",\"lineColor\":0,\"height \":0,\"width\":0,\"lineThickness \":0,\"xInMinus\" : false,\"yInMinus\":false}]}",self.userId,self.newspaperId,annId,x1,y1,(long long)ti,self.page,strComment];
        
        [self.delegate SaveComment:annotationJson CommentText:strComment NewspaperId:[self.newspaperId integerValue] AnnotationId:annId];
        
        
        
        [self dismissModalViewControllerAnimated:true];
    }
    
    
}


- (IBAction)btnCommentDelete:(id)sender {
    
    if (self.annotationId!=nil) {
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Deleting this pushpin will also delete the comment. You cannot undo this operation." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil ];
        [alert show];
    }
    
}

-(NSNumber *)getAnnotationId:(NSNumber *) newspaperId {
    
    if (self.mangeAnnotationObj == nil) {
        return [NSNumber numberWithInt:1];
    }
    
    if (self.mangeAnnotationObj == nil && self.annotationId > 0) {
        NSInteger *value = self.annotationId.intValue;
        return [NSNumber numberWithInt:value+1];
    }
    
    
    NSString * jsonStr = [self.mangeAnnotationObj valueForKey:@"annotationObject"];
    NSArray *dictAnnotation = [self JsonStringToArray:jsonStr];
    
    NSNumber *annotationId=nil;
    if (dictAnnotation !=nil && dictAnnotation.count>0) {
        annotationId=[NSNumber numberWithInt:dictAnnotation.count+1];
        for (NSDictionary *annotationObj in dictAnnotation) {
            if ([[annotationObj objectForKey:@"id"] isEqualToNumber:annotationId]) {
                annotationId=[NSNumber numberWithInt:dictAnnotation.count+2];
            }
        }
        
        
        if (annotationId == 0) {
            NSDictionary *annObj = dictAnnotation.lastObject;
            annotationId = [NSNumber numberWithInt:[[annObj objectForKey:@"id"] integerValue] + 1];
            
        }
        
    }else{
        annotationId=[NSNumber numberWithInt:1];
    }
    
    return annotationId;
}



- (NSDictionary*)jsonStrToDictionart:(NSString*)jsonStr{
    if ([jsonStr isEqualToString:@""]){
        return nil;
    }
    
    
    NSError *err = nil;
    NSArray *arr =
    [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                    options:NSJSONReadingMutableContainers
                                      error:&err];
    // access the dictionaries
    NSMutableDictionary *jsonResponse = arr[0];
    for (NSMutableDictionary *dictionary in arr) {
        // do something using dictionary
    }
    return jsonResponse;
    
}

- (NSArray*)JsonStringToArray:(NSString*)JsonString{
    if ([JsonString isEqualToString:@""]){
        return nil;
    }
    
    NSData* data = [JsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *values = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];  // if you are expecting  the JSON string to be in form of array else use NSDictionary instead
    
    return values;
}


//---overloaded function fires when pushpin are dragged
- (BOOL)getComments:(NSString*) pushPinId PosX:(int) x PosY:(int) y{

  /*  if (self.mangeAnnotationObj != nil) {
        
        NSString * jsonStr = [self.mangeAnnotationObj valueForKey:@"annotationObject"];
        NSArray *dictAnnotation = [self JsonStringToArray:jsonStr];
        
        if (dictAnnotation !=nil && dictAnnotation.count>0) {
            
            IProofData *prdata=[dictAnnotation[0] objectForKey:pushPinId];
            
            if (prdata!=nil) {
                self.Comments=prdata.Notes;
                self.NotesDatetime=[self getDateFromEpochDate:prdata.creationDate];
                self.title=prdata.userName;
                self.PushPinId=pushPinId;
                self.isRevision =NO;
                return YES;
            }
            
        }
    }*/
    
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
    
    if (self.mangeAnnotationObj != nil && annotationId != nil) {
        
        NSString * jsonStr = [self.mangeAnnotationObj valueForKey:@"annotationObject"];
        NSArray *dictAnnotation = [self JsonStringToArray:jsonStr];
        
        if (dictAnnotation !=nil && dictAnnotation.count>0) {

            for (NSDictionary *pushpinObj in dictAnnotation) {
                if ([[pushpinObj objectForKey:@"id"] isEqualToNumber:annotationId]) {
                    self.Comments= [[pushpinObj objectForKey:@"annotationText"] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                    self.NotesDatetime=[self getDateFromEpochDate:[NSString stringWithFormat:@"%@",[pushpinObj objectForKey:@"createdOn"]]];
                    self.annotationId=annotationId;
                    return YES;
                    
                }
            }
            
        }
    }
    
    
    
    
    
    
   /* if (del.Annotations !=nil && [del.Annotations count]>0) {
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
    if (buttonIndex==1) {
        if (self.annotationId !=nil ){//}&& [self.annotationId count]>0) {
           
            
            [self.delegate DeleteComment:self.newspaperId AnnotationId:self.annotationId];
            
            
           /* if ([CommonHelper deleteAnnotation:self.annotationId NewsPaperId:self.pdfReader.newspaperId]) {
                [self.pdfReader deletePushPin:self.annotationId];
                if (self.pdfReader.popoverController1.popoverVisible) {
                    [self.pdfReader.popoverController1 dismissPopoverAnimated:YES];
                }
                self.textViewComment.text=@"";
                self.annotationId=nil;
            }*/
        }
    }
}



- (NSString *) getDateFromEpochDate:(NSString *)epochdate{
    // Set epochTime as number of MILLISECONDS since 1970
    NSString *epochTime = [NSString stringWithFormat:@"%@",epochdate];
    NSTimeInterval seconds;
    
    if ([epochdate length]==13) {
        // (Step 1) Convert epoch time to SECONDS since 1970
        seconds = [epochTime doubleValue]/1000;
    }else{
        seconds = [epochTime doubleValue];
    }
    
    
    //NSLog (@"Epoch time %@ equates to %qi seconds since 1970", epochTime, (long long) seconds);
    
    // (Step 2) Create NSDate object
    NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    //NSLog (@"Epoch time %@ equates to UTC %@", epochTime, epochNSDate);
    
    // (Step 3) Use NSDateFormatter to display epochNSDate in local time zone
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"];
    //NSLog (@"Epoch time %@ equates to %@", epochTime, [dateFormatter stringFromDate:epochNSDate]);
    return [dateFormatter stringFromDate:epochNSDate];
}






@end

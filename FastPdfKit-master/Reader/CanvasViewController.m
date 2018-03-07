//
//  CanvasViewController.m
//  MNA
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

#import "CanvasViewController.h"

@interface CanvasViewController ()

@end

@implementation CanvasViewController
//@synthesize pdfReader;
@synthesize newspaperId;
@synthesize annotationId;
@synthesize tagId;
BOOL dataExist ;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)getApplicationDirectoryPath{
   /* NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@",[paths objectAtIndex:0]];
    return documentsDirectory;*/
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 1.0;
    opacity = 1.0;
    
    dataExist = NO;
    if (self.mangeAnnotationObj != nil) {
        dataExist = YES;
        NSString * jsonStr = [self.mangeAnnotationObj valueForKey:@"annotationObject"];
        NSArray *dictAnnotation = [self JsonStringToArray:jsonStr];
        
        
        if (dictAnnotation !=nil && dictAnnotation.count>0) {
            
            for (NSDictionary *annotationObj in dictAnnotation) {
                if ([[annotationObj objectForKey:@"id"] isEqualToNumber:self.annotationId]) {
                    self.CanvasFilename = [annotationObj objectForKey:@"imageName"];
                
                }
            }
            
        }
        
    }
    
    
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@/CanvasImage/%@",[self getApplicationDirectoryPath],self.CanvasFilename]);
    [self.tempDrawImage setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/CanvasImage/%@",[self getApplicationDirectoryPath],self.CanvasFilename]]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.superview.bounds = CGRectMake(0, 0, 540, 500);
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
    //[self.pdfReader dismissModalViewControllerAnimated:YES];
    if (!dataExist){
        [self.delegate CancelCanvas:self.tagId NewsPaperId:self.newspaperId];
    }
    [self dismissModalViewControllerAnimated:true];
}



- (IBAction)pencilPressed:(id)sender {
     NSLog(@"pencilPressed Canvas");
    
    UIButton * PressedButton = (UIButton*)sender;
    
    switch(PressedButton.tag)
    {
        case 0:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            brush=1.0;
            break;
        case 1:
            red = 105.0/255.0;
            green = 105.0/255.0;
            blue = 105.0/255.0;
            break;
        case 2:
            red = 255.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 3:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 255.0/255.0;
            break;
        case 4:
            red = 102.0/255.0;
            green = 204.0/255.0;
            blue = 0.0/255.0;
            break;
        case 5:
            red = 102.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            break;
        case 6:
            red = 51.0/255.0;
            green = 204.0/255.0;
            blue = 255.0/255.0;
            break;
        case 7:
            red = 160.0/255.0;
            green = 82.0/255.0;
            blue = 45.0/255.0;
            break;
        case 8:
            red = 255.0/255.0;
            green = 102.0/255.0;
            blue = 0.0/255.0;
            break;
        case 9:
            red = 255.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            break;
    }
}

- (IBAction)eraserPressed:(id)sender {
    
    NSLog(@"eraserPressed Canvas");
    
    red = 255.0/255.0;
    green = 255.0/255.0;
    blue = 255.0/255.0;
    brush = 100.0;
    opacity = 1.0;
}

- (IBAction)reset:(id)sender {
    
    NSLog(@"reset Canvas");
    [self.delegate ResetCanvas:@"Hi"];
    self.mainImage.image = nil;
    
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
    
    
    
    /* NSError *error = nil;
     NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
     NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
     options:kNilOptions
     error:&error];*/
    
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
    //NSDictionary *dictAnnotation =  [self jsonStrToDictionart:jsonStr];

    
    
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


- (IBAction)save:(id)sender {
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%d_%@.png",self.userId,self.newspaperId,self.page,self.annotationId];
   // NSString *imgPath=[NSString stringWithFormat:@"%@/%@",[CommonHelper getApplicationDirectoryPath],fileName];
    
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"];
    //NSDate *date=[formatter dateFromString:lblcreationDate.text];
    NSTimeInterval ti=[[NSDate date] timeIntervalSince1970];
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
    
   // NSString *fileName2 = [NSString stringWithFormat:@"%@_%@_%d_%@.png",self.userId,self.newspaperId,self.page,annotationId];
    
    
    NSString *annotationJson=[NSString stringWithFormat:@"{\"UserId\":\"%@\",\"NewspaperId\":%@,\"Annotation\":[{\"id\":%@,\"type\":\"image\",\"PointX\":%f,\"PointY\":%f,\"createdOn\":%qi,\"pageNumber\":%d,\"annotationText\":\"\",\"imageName\":\"%@\",\"borderThickness\":0,\"drawingType \": \"p\",\"lineColor\":0,\"height \":0,\"width\":0,\"lineThickness \":0,\"xInMinus\" : false,\"yInMinus\":false}]}",self.userId,self.newspaperId,annId,x1,y1,(long long)ti,self.page,fileName];
    
   
    UIGraphicsBeginImageContextWithOptions(self.mainImage.bounds.size, NO, 0.0);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    [self.delegate SaveCanvaswithNewsid:[self.newspaperId integerValue] JsonString:annotationJson AnnotationId:annId DrawImage:SaveImage  FileName:fileName];
    
    [self dismissModalViewControllerAnimated:true];
    NSLog(@"save Canvas");
  /*
   if (!del.isInternetActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection" message:@"This application requires a WiFi or cellular network to connect to the server. Please ensure that you have an active connection and/or Airplane mode is turned off." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        //        [del.activityIndicator stopAnimating];
    }
    else{
        UIGraphicsBeginImageContextWithOptions(self.mainImage.bounds.size, NO, 0.0);
        [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
        UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *data=UIImagePNGRepresentation(SaveImage);
        NSData *imgData=UIImageJPEGRepresentation(SaveImage, 1.0);
        NSNumber *annotationId=[CommonHelper getAnnotationId:self.pdfReader.newspaperId];
        if (self.annotationId!=nil) {
            annotationId=self.annotationId;
            
        }
        NSString *fileName = [NSString stringWithFormat:@"%@_%@_%d_%@.png",del.UserId,self.pdfReader.newspaperId,self.pdfReader.page,annotationId];
        NSString *imgPath=[NSString stringWithFormat:@"%@/%@",[CommonHelper getApplicationDirectoryPath],fileName];//[del.LocalPath stringByAppendingFormat:@"/%@",fileName];
        [data writeToFile:imgPath atomically:YES];
        NSLog(@"%@",del.BaseURL);
        NSString *strUrl=[NSString stringWithFormat:@"%@fileupload.php",del.BaseURL];
        NSURL *url=[NSURL URLWithString:strUrl];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        [request setUseKeychainPersistence:YES];
        
        
        [request addPostValue:fileName forKey:@"name"];
        
        // Upload an image
        NSData *imageData = data;//UIImageJPEGRepresentation(SaveImage,1.0);
        [request setData:imageData withFileName:fileName andContentType:@"image/png" forKey:@"userfile"];
        
        [request setDelegate:self];
        [request startSynchronous];
        NSLog(@"%@",request.responseString);
        
        NSDateFormatter *formatter;
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"];
        //NSDate *date=[formatter dateFromString:lblcreationDate.text];
        NSTimeInterval ti=[[NSDate date] timeIntervalSince1970];
        NSLog(@"date:%qi",(long long)ti);
        
        if (self.pdfReader.minZoomScale<1.0) {
            self.pdfReader.minZoomScale=1;
        }
        
        float zmScale=self.pdfReader.minZoomScale*self.pdfReader.zoomScale;
        if (zmScale<1.0) {
            zmScale=1;
        }
        float x1=self.point.x/zmScale;
        float y1=self.point.y/zmScale;
        
        
        
        NSString *annotation=[NSString stringWithFormat:@"{\"UserId\":\"%@\",\"NewspaperId\":%@,\"Annotation\":[{\"id\":%@,\"type\":\"image\",\"PointX\":%f,\"PointY\":%f,\"createdOn\":%qi,\"pageNumber\":%d,\"annotationText\":\"\",\"imageName\":\"%@\",\"borderThickness\":0,\"drawingType \": \"p\",\"lineColor\":0,\"height \":0,\"width\":0,\"lineThickness \":0,\"xInMinus\" : false,\"yInMinus\":false}]}",del.UserId,self.pdfReader.newspaperId,annotationId,x1,y1,(long long)ti,self.pdfReader.page,fileName];
        
        [CommonHelper saveAnnotations:annotation];
        if (self.annotationId==nil) {
            [self.pdfReader addPushPin:self.point Tag:[annotationId integerValue] PushPinImage:@"ppbtn.png" CommentType:@"image"];
        }
        
        [self.pdfReader dismissModalViewControllerAnimated:YES];
    }*/
}

- (IBAction)delete1:(id)sender {
    
    if (self.annotationId!=nil) {
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Deleting this pushpin will also delete the comment. You cannot undo this operation." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil ];
        [alert show];
        
    }
    
      NSLog(@"delete1 Canvas");
    
    
   /* if (!del.isInternetActive) {
        
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



- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved.Please try again"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image was successfully saved in photoalbum"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}

- (BOOL)getCommentImage:(NSNumber *) annotationId{
    NSLog(@"getCommentImage Canvas");
    
   /* del=(TBLITEAppDelegate*)[UIApplication sharedApplication].delegate;
    if (del.Annotations !=nil && [del.Annotations count]>0) {
        for (NSDictionary *pushpinObj in del.Annotations) {
            if(annotationId !=nil && [[pushpinObj objectForKey:@"id"] isEqualToNumber:annotationId]){
                self.CanvasFilename= [[pushpinObj objectForKey:@"imageName"] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
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

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft|| toInterfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

#pragma delete pushpin
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex   {
    if (buttonIndex==1) {
        
        if (self.annotationId !=nil &&  [self.annotationId integerValue] != 0){//}&& [del.Annotations count]>0) {
            [self.delegate DeleteCanvas:self.annotationId NewsPaperId:[self.newspaperId integerValue]];
            
            /*if ([CommonHelper deleteAnnotation:self.annotationId NewsPaperId:self.pdfReader.newspaperId]) {
                [self.pdfReader deletePushPin:self.annotationId];
                [self.pdfReader dismissModalViewControllerAnimated:YES];
                
                NSString *fileName = [NSString stringWithFormat:@"%@_%@_%d_%@.png",del.UserId,self.pdfReader.newspaperId,self.pdfReader.page,self.annotationId];
                NSString *imgPath=[NSString stringWithFormat:@"%@/%@",[CommonHelper getApplicationDirectoryPath],fileName];
                NSString *strUrl=[NSString stringWithFormat:@"%@webservice_ios2.php?method=deleteFile&encode=json",del.BaseURL];
                NSString *jsonRequest=[NSString stringWithFormat:@"{\"FileName\":\"%@\"}",fileName];
                NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
                
                ASIHTTPRequest *request1 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl]];
                [request1 addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
                [request1 addRequestHeader:@"Content-Type" value:@"application/json"];
                [request1 appendPostData:requestData];
                //Customise our user agent, for no real reason
                [request1 addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
                // Start the request
                [request1 startSynchronous];
                NSString *result=[request1 responseString];
                
                if ([result isEqualToString:@"Success"]) {
                    
                }
                if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
                    NSError *error=nil;
                    [[NSFileManager defaultManager] removeItemAtPath:imgPath error:&error];
                    if (error!=nil) {
                        NSLog(@"%@",[error localizedDescription]);
                    }
                }
                self.annotationId=nil;
            }*/
        }
    }
}





@end

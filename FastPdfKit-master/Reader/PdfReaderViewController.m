//
//  PdfReaderViewController.m
//  MNA
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

#import "PdfReaderViewController.h"
#import "CanvasViewController.h"
#import "OverlayManager.h"
#import <FastPdfKit/MFDocumentOverlayDataSource.h>
#import "OverlayManager.h"
#import <FastPdfKit/FPKGlyphBox.h>


@interface PdfReaderViewController ()

@end




@implementation PdfReaderViewController

@synthesize popoverController1=_popoverController1;
@synthesize JobInfo=_JobInfo;
@synthesize TagText;
@synthesize RvKey;
@synthesize SelectedRvKeys;
@synthesize ToolBar1=_ToolBar1;
@synthesize minZoomScale=_minZoomScale;
@synthesize proofCropBox=_proofCropBox;
@synthesize yAxispadding=_yAxispadding;
@synthesize xAxispadding=_xAxispadding;
@synthesize ZoomInfo=_ZoomInfo;
@synthesize newspaperId=_newspaperId;
@synthesize fileURL=_fileURL;
@synthesize fileName=_fileName;
@synthesize glyphBoxes;
@synthesize selectedArea;
@synthesize currentPinTag;
@synthesize dismisSts;
@synthesize searchStr;

@synthesize  updateAnnotationId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
    self.dismisSts = NO;
    blActivateComment=NO;
    isToolBarVisible=NO;
    self.blAddPushpin=NO;
    
  //  del = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.SelectedRvKeys=[[NSMutableArray alloc] init];
    self.ZoomInfo=[[NSMutableDictionary alloc] init];
    //--------------//
    isFirsttime=YES;
    [self startSelectedArea:self.page];
    self.selectedArea=[[NSMutableArray alloc] init];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPressForNote:)];
    longPress.minimumPressDuration = 1.0;
    [self.view addGestureRecognizer:longPress];
   
}

-(void)callOverlay{
    if (searchStr.length >0){
        // We are adding an image overlay on the first page on the bottom left corner
        OverlayManager *ovManager = [[OverlayManager alloc] init];
        ovManager.documentManager = self.documentManagerSearch;
        ovManager.searchKeyword = searchStr;
       // [self addOverlayDataSource:ovManager];
        
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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


-(void)prepareToolbar {
    [super prepareToolbar];
    NSMutableArray *toolbarItems = [self.rollawayToolbar.items mutableCopy];

    [toolbarItems removeObjectAtIndex:1];
    [toolbarItems removeObjectAtIndex:1];
    [toolbarItems removeObjectAtIndex:1];
    [toolbarItems removeObjectAtIndex:1];
    //[toolbarItems removeObjectAtIndex:2];
    
    //[toolbarItems removeObjectAtIndex:3];
    //[toolbarItems removeObjectAtIndex:3];
    //[toolbarItems removeObjectAtIndex:4];
    [toolbarItems removeObjectAtIndex:5];
    //    [toolbarItems removeObjectAtIndex:7];
    //    [toolbarItems removeObjectAtIndex:7];
    UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pushpin"]  style:UIBarButtonItemStylePlain target:self action:@selector(ActivePuspin:)];
    btn.tintColor = [UIColor whiteColor];
    [toolbarItems insertObject:btn atIndex:1];
    
    btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Sticky"]  style:UIBarButtonItemStylePlain target:self action:@selector(ActiveCanvas:)];
    btn.tintColor = [UIColor whiteColor];
    [toolbarItems insertObject:btn atIndex:2];
    
    
    btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Email"]  style:UIBarButtonItemStylePlain target:self action:@selector(EmailClicked:)];
    btn.tintColor = [UIColor whiteColor];
    [toolbarItems insertObject:btn atIndex:3];
    
    
    
    //print button
    //    UIImage *imageH = [UIImage imageNamed:@"Reader-Button-H"];
    //    UIImage *imageN = [UIImage imageNamed:@"Reader-Button-N"];
    //
    //    UIImage *buttonH = [imageH stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    //    UIImage *buttonN = [imageN stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIButton *printButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    printButton.frame = CGRectMake(0, 0, 40, 40);
    [printButton setImage:[UIImage imageNamed:@"Reader-Print"] forState:UIControlStateNormal];
    [printButton addTarget:self action:@selector(ActivePDFPrint:) forControlEvents:UIControlEventTouchUpInside];
    //    [printButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
    //    [printButton setBackgroundImage:buttonN forState:UIControlStateNormal];
    printButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    printButton.exclusiveTouch = YES;
    //btn=[[UIBarButtonItem alloc] initWithCustomView:printButton];
    
    btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Reader-Print"]  style:UIBarButtonItemStylePlain target:self action:@selector(ActivePDFPrint1:)];
    btn.tintColor = [UIColor whiteColor];
    [toolbarItems insertObject:btn atIndex:8];
    
    [self.rollawayToolbar setItems:[toolbarItems copy] animated:YES];
    
   
}


-(void) ActivePuspin:(id)sender{
    if(self.popoverController1.popoverVisible)
        [self.popoverController1 dismissPopoverAnimated:YES];
    blActivateComment=YES;
    blActivateCanvas=YES;
    
    [self hideToolbar];
    [self hideThumbnails];
}

-(void) ActiveCanvas:(id)sender{
    if(self.popoverController1.popoverVisible)
        [self.popoverController1 dismissPopoverAnimated:YES];
    blActivateCanvas=YES;
    blActivateComment=NO;
    
    [self hideToolbar];
    [self hideThumbnails];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [self EmailPdf];
    }
}

-(void) EmailClicked:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"This facsimile/e-mail message contain CONFIDENTIAL,  PRIVILEGED or SECURE material of the National Assembly of Mauritius. Any unauthorized use, disclosure or distribution is prohibited. Are you sure you want to share." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
    
}

-(NSString *)getApplicationDirectoryPath2{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@",[paths objectAtIndex:0]];
    return documentsDirectory;
}


-(void) EmailPdf{
    if([MFMailComposeViewController canSendMail]){
        
        NSLog(@"%@",self.fileURL);
        NSString *urlstring = [[self.fileURL absoluteString]  stringByReplacingOccurrencesOfString:@".pdf" withString:@".json"];
        NSString *jsonFileName = [urlstring lastPathComponent];
        NSString *jsonFilePath = [NSString stringWithFormat:@"%@/pdffiles/%@",[self getApplicationDirectoryPath2],jsonFileName];
        
        NSError *error = nil;
       //SBJSON *parser=[[SBJSON alloc] init];
        
        NSString *jsonFileContent = [NSString stringWithContentsOfFile:jsonFilePath encoding:NSUTF8StringEncoding error:&error];
        //    NSLog(@"%@",error);
     //   NSArray *jsonArray = [parser objectWithString:jsonFileContent error:nil];
        //    NSLog(@"%@",[jsonArray objectAtIndex:4]);
      
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        NSString *emailSubject = [NSString localizedStringWithFormat:@""];
        [controller setSubject:emailSubject];
        
        NSString *path = [self.fileURL absoluteString];
        NSURL *pdfURL = [NSURL URLWithString:path];
        NSData *pdfData = [NSData dataWithContentsOfURL:pdfURL];
        [controller addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@.pdf" , self.fileName]];
        
        //[controller setToRecipients:[NSArray arrayWithObject:[NSString stringWithString:@"YourEmail@me.com"]]];
        //[controller setMessageBody:@"Custom messgae Here..." isHTML:NO];
        
        [self presentModalViewController:controller animated:YES];
        controller.mailComposeDelegate = self;
       
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please configure your email first." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}



-(void)ActivePDFPrint:(UIButton *)button{
    Class printInteractionController = NSClassFromString(@"UIPrintInteractionController");
    
    if ((printInteractionController != nil) && [printInteractionController isPrintingAvailable])
    {
        // Document file URL
        
        UIPrintInteractionController *printInteraction = [printInteractionController sharedPrintController];
        
        if ([printInteractionController canPrintURL:self.fileURL] == YES) // Check first
        {
            UIPrintInfo *printInfo = [NSClassFromString(@"UIPrintInfo") printInfo];
            
            printInfo.duplex = UIPrintInfoDuplexLongEdge;
            printInfo.outputType = UIPrintInfoOutputGeneral;
            printInfo.jobName = self.fileName;
            
            printInteraction.printInfo = printInfo;
            printInteraction.printingItem = self.fileURL;
            printInteraction.showsPageRange = YES;
            
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
            {
                
                [printInteraction presentFromRect:button.bounds inView:button animated:YES completionHandler:
                 ^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
                 {
                     //#ifdef DEBUG
                     if ((completed == NO) && (error != nil)) NSLog(@"%@", error);
                     //#endif
                 }
                 ];
            }
            
        }
    }
    
    
}

-(void)ActivePDFPrint1:(id)sender{
    
    if(self.popoverController1.popoverVisible)
        [self.popoverController1 dismissPopoverAnimated:YES];    Class printInteractionController = NSClassFromString(@"UIPrintInteractionController");
    
    if ((printInteractionController != nil) && [printInteractionController isPrintingAvailable])
    {
        // Document file URL
        
        UIPrintInteractionController *printInteraction = [printInteractionController sharedPrintController];
        
        if ([printInteractionController canPrintURL:self.fileURL] == YES) // Check first
        {
            UIPrintInfo *printInfo = [NSClassFromString(@"UIPrintInfo") printInfo];
            
            printInfo.duplex = UIPrintInfoDuplexLongEdge;
            printInfo.outputType = UIPrintInfoOutputGeneral;
            printInfo.jobName = self.fileName;
            
            printInteraction.printInfo = printInfo;
            printInteraction.printingItem = self.fileURL;
            printInteraction.showsPageRange = YES;
            
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
            {
                [printInteraction presentFromBarButtonItem:sender animated:YES
                                         completionHandler: ^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
                 {
                     //#ifdef DEBUG
                     if ((completed == NO) && (error != nil)) NSLog(@"%@", error);
                     //#endif
                 }];
                
            }
            
        }
    }
}


//---Show comments popoverup---
-(void)ShowCommentPopup:(CGPoint) touchedPoint AnnotationId:(NSNumber *) annotationId{
    
    [self.popoverController1 dismissPopoverAnimated:YES];
    
    CommentViewController *commentView=[[CommentViewController alloc] init];
    commentView.delegate = self;
    if (annotationId!=nil) {
      
        commentView.annotationId = annotationId;
        self.updateAnnotationId = [annotationId integerValue];
        commentView.updateAnnId = annotationId;
    }else{
        commentView.annotationId = [NSNumber numberWithUnsignedInteger: self.currentAnnotationId];
        self.updateAnnotationId = 0;
        commentView.updateAnnId = 0;
    }
    self.dismisSts = YES;
    //customisation
    commentView.point=touchedPoint;
    commentView.page = self.page;
    commentView.userId = self.userId;
    commentView.minZoomScale1 = self.minZoomScale;
    commentView.zoomScale = self.zoomScale;
    commentView.newspaperId = self.newspaperId;
    commentView.mangeAnnotationObj = self.mangeAnnotationObject;
    //commentView.annotationId = [NSNumber numberWithUnsignedInteger: self.currentAnnotationId];
    //End
    
    if (self.mangeAnnotationObject != nil){
        
        NSString * jsonStr = [self.mangeAnnotationObject valueForKey:@"annotationObject"];
        NSArray *dictAnnotation = [self JsonStringToArray:jsonStr];
        if (dictAnnotation !=nil && dictAnnotation.count>0 && self.currentAnnotationId != nil) {
            for (NSDictionary *annotationObj in dictAnnotation) {
                if ([[annotationObj objectForKey:@"id"] integerValue] == self.currentAnnotationId) {
                    dismisSts = NO;
                }
            }
        }
    }
    
    commentView.point=touchedPoint;
    commentView.blDeletePushpin=YES;
    if ( ![commentView getComments:annotationId] ) {
        NSDateFormatter *formatter;
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"];
        commentView.NotesDatetime = [formatter stringFromDate:[NSDate date]];
        commentView.blDeletePushpin=NO;
    }

    CGRect myrect = commentView.view.frame;
    //create a popover controller
    self.popoverController1 = [[UIPopoverController alloc]
                               initWithContentViewController:commentView];
    [self.popoverController1 setPopoverContentSize:myrect.size animated:YES];
    if (annotationId!=nil) {
        
    }else{
        self.popoverController1.delegate=self;
        commentView.textViewComment.editable=YES;
    }
    
    myrect.size.width = 0;
    myrect.size.height = 0;
    myrect.origin.x =  self.zoomOffset.x>=touchedPoint.x?self.zoomOffset.x-touchedPoint.x:touchedPoint.x -self.zoomOffset.x;
    myrect.origin.y=self.zoomOffset.y>=touchedPoint.y?self.zoomOffset.y-touchedPoint.y:touchedPoint.y -self.zoomOffset.y;
    [self.popoverController1 presentPopoverFromRect:myrect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
    
}



//---show comment canvas---
-(void)ShowCommentCanvas:(CGPoint) touchedPoint AnnotationId:(NSNumber *) annotationId{
    
    CanvasViewController *canvas=[[CanvasViewController alloc] init];
    canvas.delegate = self;
    if (annotationId!=nil) {
        [canvas getCommentImage:annotationId];
        canvas.annotationId = annotationId;
        self.updateAnnotationId = [annotationId integerValue];
        canvas.updateAnnId = annotationId;
    }else{
        canvas.annotationId = [NSNumber numberWithUnsignedInteger: self.currentAnnotationId];
        self.updateAnnotationId = 0;
        canvas.updateAnnId = 0;
    }
    
    //customisation
    canvas.tagId = self.currentPinTag;
    canvas.point=touchedPoint;
    canvas.page = self.page;
    canvas.userId = self.userId;
    canvas.minZoomScale1 = self.minZoomScale;
    canvas.zoomScale = self.zoomScale;
    canvas.newspaperId = self.newspaperId;
    canvas.mangeAnnotationObj = self.mangeAnnotationObject;
    
    
    canvas.CanvasFilename = self.mangeAnnotationObject;
    //End
    
    //CGRect myrect = canvas.view.frame;
    canvas.view.superview.frame = CGRectMake(0, 0, 500, 500);//it's important to do this after
    canvas.view.superview.center = self.view.center;
    [canvas setModalPresentationStyle:UIModalPresentationFormSheet];
    [canvas setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:canvas animated:YES];
}

-(void)addPushPin:(CGPoint) point  PushPinImage:(NSString *) image{
    for (id v in self.view.subviews) {//self view
        if ([v isKindOfClass:[UIScrollView class]]) {//scrollview in self
            //[(UIScrollView*)v setAutoresizingMask:UIViewAutoresizingNone];
            for (id vw in [v subviews]) {//FPKDetailView
                NSLog(@"%@",vw);
                for (id vwx in [vw subviews]) {//FPKIntermediateView
                    NSLog(@"%@",vwx);
                    for (id vwxy in [vwx subviews]) {//MFScrollDetailView
                        NSLog(@"%@",vwxy);
                        
                        for (id vwxyz in [vwxy subviews]) {//UIView
                            NSLog(@"%@",vwxyz);
                            if (![vwxyz isKindOfClass:[UIImageView class]]) {
                                float x=0;
                                float y=0;
                                float minZmScale=1;
                                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                                [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
                                [btn addTarget:self action:@selector(showComment:) forControlEvents:UIControlEventTouchUpInside];
                                [btn addTarget:self action:@selector(dragPushPin:) forControlEvents:UIControlEventTouchDragOutside];
                                btn.tag=1;
                                if (self.currentAnnotationId > 0){//Add
                                    btn.tag = self.currentAnnotationId;
                                }
                                
                                
                                
                                if (![image isEqualToString:@"ppbtn"]) {
                                    minZmScale=self.minZoomScale;
                                    if (self.minZoomScale<1.0)
                                    {
                                        minZmScale=1;
                                    }
                                    float x2=(point.x)*minZmScale;
                                    btn.frame=CGRectMake( x2-12, 0, 30, 30);
                                    [UIView setAnimationDuration:0.6];
                                }
                                else{
                                    minZmScale=self.zoomScale;
                                    
                                    x = (point.x)/minZmScale-12;// self.zoomOffset.x>=point.x?self.zoomOffset.x-point.x:point.x -self.zoomOffset.x;
                                    y= (point.y)/minZmScale-30;//self.zoomOffset.y>=point.y?self.zoomOffset.y-point.y:point.y -self.zoomOffset.y;
                                    btn.frame=CGRectMake(x, 0, 30, 30);
                                    [UIView setAnimationDuration:0.3];
                                }
                                
                                
                                [UIView beginAnimations:nil context:nil];
                                //[UIView setAnimationDuration:0.3];
                                CGAffineTransform transform =![image isEqualToString:@"ppbtn"]? CGAffineTransformMakeTranslation(0, (point.y)*minZmScale-30):CGAffineTransformMakeTranslation(0, y);
                                [btn setTransform:transform];
                                [UIView commitAnimations];
                                // animate
                                self.currentPinTag = btn.tag;
                                [vwxyz addSubview:btn];
                                
                            }
                        }
                    }
                }
            }
        }
    }
}

-(void)addPushPin:(CGPoint) point Tag:(int) tagValue PushPinImage:(NSString *) image{
    for (id v in self.view.subviews) {//self view
        if ([v isKindOfClass:[UIScrollView class]]) {//scrollview in self
            //[(UIScrollView*)v setAutoresizingMask:UIViewAutoresizingNone];
            for (id vw in [v subviews]) {//FPKDetailView
                NSLog(@"%@",vw);
                for (id vwx in [vw subviews]) {//FPKIntermediateView
                    NSLog(@"%@",vwx);
                    for (id vwxy in [vwx subviews]) {//MFScrollDetailView
                        NSLog(@"%@",vwxy);
                        
                        for (id vwxyz in [vwxy subviews]) {//UIView
                            NSLog(@"%@",vwxyz);
                            if (![vwxyz isKindOfClass:[UIImageView class]]) {
                                float x=0;
                                float y=0;
                                
                                float minZmScale=1;
                                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                                [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
                                [btn addTarget:self action:@selector(showComment:) forControlEvents:UIControlEventTouchUpInside];
                                btn.tag=tagValue;
                                
                                if (![image isEqualToString:@"ppbtn"]) {
                                    minZmScale=self.minZoomScale;
                                    btn.frame=CGRectMake((point.x)*minZmScale-12, 0, 30, 30);
                                    [UIView setAnimationDuration:0.6];
                                }
                                else{
                                    minZmScale=self.zoomScale;
                                    
                                    x = (point.x)/minZmScale-12;// self.zoomOffset.x>=point.x?self.zoomOffset.x-point.x:point.x -self.zoomOffset.x;
                                    y= (point.y)/minZmScale-30;//self.zoomOffset.y>=point.y?self.zoomOffset.y-point.y:point.y -self.zoomOffset.y;
                                    btn.frame=CGRectMake(x, 0, 30, 30);
                                    [UIView setAnimationDuration:0.3];
                                }
                                
                                
                                [UIView beginAnimations:nil context:nil];
                                //[UIView setAnimationDuration:0.3];
                                CGAffineTransform transform =![image isEqualToString:@"ppbtn"]? CGAffineTransformMakeTranslation(0, (point.y)*minZmScale-30):CGAffineTransformMakeTranslation(0, y);
                                [btn setTransform:transform];
                                [UIView commitAnimations];
                                // animate
                                self.currentPinTag = btn.tag;
                                [vwxyz addSubview:btn];
                            }
                        }
                    }
                }
            }
        }
    }
}

-(void)addPushPin:(CGPoint) point Tag:(int) tagValue PushPinImage:(NSString *) image CommentType:(NSString *)commentType{
    for (id v in self.view.subviews) {//self view
        if ([v isKindOfClass:[UIScrollView class]]) {//scrollview in self
            //[(UIScrollView*)v setAutoresizingMask:UIViewAutoresizingNone];
            for (id vw in [v subviews]) {//FPKDetailView
                NSLog(@"%@",vw);
                for (id vwx in [vw subviews]) {//FPKIntermediateView
                    NSLog(@"%@",vwx);
                    for (id vwxy in [vwx subviews]) {//MFScrollDetailView
                        NSLog(@"%@",vwxy);
                        
                        for (id vwxyz in [vwxy subviews]) {//UIView
                            NSLog(@"%@",vwxyz);
                            if (![vwxyz isKindOfClass:[UIImageView class]]) {
                                float x=0;
                                float y=0;
                                
                                float minZmScale=1;
                                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                                [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
                                if ([[commentType lowercaseString] isEqualToString:@"image"]) {
                                    [btn addTarget:self action:@selector(showCanvas:) forControlEvents:UIControlEventTouchUpInside];
                                }
                                else{
                                    [btn addTarget:self action:@selector(showComment:) forControlEvents:UIControlEventTouchUpInside];
                                }
                                
                                btn.tag=tagValue;
                                
                                if (![image isEqualToString:@"ppbtn"]) {
                                    minZmScale=self.minZoomScale;
                                    btn.frame=CGRectMake((point.x)*minZmScale-12, 0, 30, 30);
                                    [UIView setAnimationDuration:0.6];
                                }
                                else{
                                    minZmScale=self.zoomScale;
                                    
                                    x = (point.x)/minZmScale-12;// self.zoomOffset.x>=point.x?self.zoomOffset.x-point.x:point.x -self.zoomOffset.x;
                                    y= (point.y)/minZmScale-30;//self.zoomOffset.y>=point.y?self.zoomOffset.y-point.y:point.y -self.zoomOffset.y;
                                    btn.frame=CGRectMake(x, 0, 30, 30);
                                    [UIView setAnimationDuration:0.3];
                                }
                                
                                
                                [UIView beginAnimations:nil context:nil];
                                //[UIView setAnimationDuration:0.3];
                                CGAffineTransform transform =![image isEqualToString:@"ppbtn"]? CGAffineTransformMakeTranslation(0, (point.y)*minZmScale-30):CGAffineTransformMakeTranslation(0, y);
                                [btn setTransform:transform];
                                [UIView commitAnimations];
                                // animate
                                self.currentPinTag = btn.tag;
                                [vwxyz addSubview:btn];
                            }
                        }
                    }
                }
            }
        }
    }
}



-(void)showComment:(id) sender{
    if(self.popoverController1.popoverVisible)
        [self.popoverController1 dismissPopoverAnimated:YES];
    UIButton *btn=(UIButton *)sender;
    NSInteger annotationId=[btn tag];
    CGRect btnFrame=[btn frame];
    
    
    CGRect newFrame=CGRectMake((btnFrame.origin.x * self.zoomScale)+12* self.zoomScale , (btnFrame.origin.y * self.zoomScale)+30* self.zoomScale, btnFrame.size.width, btnFrame.size.height);
    CGPoint point=newFrame.origin;
    [self ShowCommentPopup:point AnnotationId:[NSNumber numberWithInteger:annotationId]];
    
}

-(void)showCanvas:(id) sender{
    if(self.popoverController1.popoverVisible)
        [self.popoverController1 dismissPopoverAnimated:YES];
    UIButton *btn=(UIButton *)sender;
    NSInteger annotationId=[btn tag];
    CGRect btnFrame=[btn frame];
    
    
    CGRect newFrame=CGRectMake((btnFrame.origin.x * self.zoomScale)+12* self.zoomScale , (btnFrame.origin.y * self.zoomScale)+30* self.zoomScale, btnFrame.size.width, btnFrame.size.height);
    CGPoint point=newFrame.origin;
    [self ShowCommentCanvas:point AnnotationId:[NSNumber numberWithInteger:annotationId]];
    
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    /*if ([[popoverController contentViewController] isKindOfClass:[CommentsPopupView class]]) {
        CommentsPopupView *commentView = (CommentsPopupView *)[popoverController contentViewController];
        NSLog(@"%@",commentView.textViewComment.text);
        if (commentView.textViewComment.text ==nil || [[commentView.textViewComment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            commentView =nil;
            return YES;
            commentView.annotationId=nil;
        }
        return NO;
    }*/
    
    return YES;
}

-(void)documentViewController:(MFDocumentViewController *)dvc didGoToPage:(NSUInteger)page{
    
    self.page = page;
    
    NSLog(@"%d",page);
    NSLog(@"Zoom : %.0f%%",self.zoomScale);
     [self updatePageNumberLabelWithPage:page];// Added
    
    
    for (id v in self.view.subviews) {//self view
        if ([v isKindOfClass:[UIScrollView class]]) {//scrollview in self
            for (id vw in [v subviews]) {//FPKDetailView
                NSLog(@"%@",vw);
                for (id vwx in [vw subviews]) {//FPKIntermediateView
                    NSLog(@"%@",vwx);
                    for (id vwxy in [vwx subviews]) {//MFScrollDetailView
                        NSLog(@"%@",vwxy);
                        
                        for (id vwxyz in [vwxy subviews]) {//UIView
                            NSLog(@"%@",vwxyz);
                            if (![vwxyz isKindOfClass:[UIImageView class]]) {
                                
                                for (id a in [vwxyz subviews]) {
                                    NSLog(@"%@",a);
                                    if ([a isKindOfClass:[UIButton class]]) {
                                        [a removeFromSuperview];
                                        
                                        
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    if (self.mangeAnnotationObject != nil) {
        NSString * jsonStr = [self.mangeAnnotationObject valueForKey:@"annotationObject"];
        NSDictionary* dict = [self jsonStrToDictionart:jsonStr];
        NSArray* pinArray = [self JsonStringToArray:jsonStr];
        
        if (pinArray != nil && [pinArray count]>0){
            
            for (NSDictionary *pushpinObj in pinArray) {
                if ([[pushpinObj objectForKey:@"pageNumber"] integerValue]==page) {
                    CGPoint point=CGPointMake([[pushpinObj objectForKey:@"PointX"] floatValue]*self.minZoomScale, [[pushpinObj objectForKey:@"PointY"] floatValue]*self.minZoomScale);
                    [self addPushPin:point Tag:[[pushpinObj objectForKey:@"id"] intValue]  PushPinImage:@"ppbtn" CommentType:[pushpinObj objectForKey:@"type"]];
                }
            }
            
        }
    }
}

-(NSDictionary*)jsonStrToDictionart:(NSString*)jsonStr{
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

- (NSDictionary *) json_StringToDictionary2 :(NSString*)jsonStr{
    NSError *error;
    NSData *objectData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&error];
    return (!json ? nil : json);
}




-(NSArray*)JsonStringToArray:(NSString*)JsonString{
    if ([JsonString isEqualToString:@""]){
        return nil;
    }
    
    NSData* data = [JsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *values = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];  // if you are expecting  the JSON string to be in form of array else use NSDictionary instead

    return values;
}


-(void)documentViewController:(MFDocumentViewController *)dvc didFocusOnPage:(NSUInteger)page{
   
    self.page = page;
 
    
    if (isFirsttime) {
       
        if (self.mangeAnnotationObject != nil) {
            NSString * jsonStr = [self.mangeAnnotationObject valueForKey:@"annotationObject"];
            NSArray* pinArray = [self JsonStringToArray:jsonStr];
            
            if (pinArray != nil && [pinArray count]>0){
                
                for (NSDictionary *pushpinObj in pinArray) {
                    if ([[pushpinObj objectForKey:@"pageNumber"] integerValue]==page) {
                        CGPoint point=CGPointMake([[pushpinObj objectForKey:@"PointX"] floatValue]*self.minZoomScale, [[pushpinObj objectForKey:@"PointY"] floatValue]*self.minZoomScale);
                        [self addPushPin:point Tag:[[pushpinObj objectForKey:@"id"] intValue]  PushPinImage:@"ppbtn" CommentType:[pushpinObj objectForKey:@"type"]];
                    }
                }
                
            }
            
            
            
        }
        
       
    }
    
    isFirsttime=NO;
    
}


-(void) documentViewController:(MFDocumentViewController *)dvc didReceiveTapOnPage:(NSUInteger)page atPoint:(CGPoint)point {
    
    
    if(self.waitingForTextInput) {
        
        self.waitingForTextInput = false ;
        
        TextDisplayViewController *controller = self.textDisplayViewController;
        controller.delegate = self;
        [controller updateWithTextOfPage:page];
        [self presentModalViewController:controller animated:YES];
        
    }
}

-(void) documentViewController:(MFDocumentViewController *)dvc didReceiveTapAtPoint:(CGPoint)point {
    
    if ((blActivateComment || blActivateCanvas) && isToolBarVisible) {
        float zmScale=self.minZoomScale*self.zoomScale;
        float x1=point.x/zmScale;
        float y1=point.y/zmScale;

        if (self.yAxispadding>0 && y1>self.yAxispadding && y1<self.proofCropBox.size.height+self.yAxispadding) {
           
            if (blActivateComment) {
                [self ShowCommentPopup:point AnnotationId:nil];
            }
            else{
                [self ShowCommentCanvas:point AnnotationId:nil];
            }
            
        }
        else if (self.xAxispadding>0 && x1>self.xAxispadding && x1<self.proofCropBox.size.width+self.xAxispadding){
           
            if (blActivateComment) {
                [self ShowCommentPopup:point AnnotationId:nil];
            }
            else{
                [self ShowCommentCanvas:point AnnotationId:nil];
            }
        }
        else if (self.xAxispadding==0 && self.yAxispadding==0){
            
            if (blActivateComment) {
                [self ShowCommentPopup:point AnnotationId:nil];
            }
            else{
                [self ShowCommentCanvas:point AnnotationId:nil];
            }
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"You cannot place pushpins outside the active area of the artwork. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            [alert show];
            
        }
        blActivateCanvas=NO;
        blActivateComment=NO;
        isToolBarVisible=NO;
    }
    else{
        if (!isToolBarVisible) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            
            [self showToolbar];
            [self showThumbnails];
            
            isToolBarVisible=YES;
        }
        else{
            isToolBarVisible=NO;
            [self hideToolbar];
            [self hideThumbnails];
        }
    }
}
/*
 -(NSArray *)documentViewController:(MFDocumentViewController *)dvc overlayViewsForPage:(NSUInteger)page{
 NSArray * tempSearchResults = [[NSArray alloc] init];
 return tempSearchResults;
 }
 
 -(NSArray *)documentViewController:(MFDocumentViewController *)dvc drawablesForPage:(NSUInteger)page{
 NSString *searchKeyword=@"Explanatory";
 NSMutableArray * tempSearchResults = [[NSMutableArray alloc] init];
 if (searchKeyword != nil)
 {
 for (int a=0; a<[self.document numberOfPages]; a++)
 {
 [tempSearchResults addObjectsFromArray:[self.document searchResultOnPage:a forSearchTerms:searchKeyword ignoreCase:YES]];
 }
 
 NSLog(@"Search '%@' - %d results",searchKeyword,[tempSearchResults count]);
 }
 return [tempSearchResults mutableCopy];
 }
 */


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (UIView *vw in [self.view subviews]) {
        if ([vw isKindOfClass:[UIImageView class]]) {
            //[(UIImageView *)vw setImage:[UIImage imageNamed:@"icon-new.png"]];
            vw.hidden=YES;
        }
    }
    //[self addOverlayDataSource:<#(id<MFDocumentOverlayDataSource>)#>];
}

-(void)handleLongPressForNote:(UILongPressGestureRecognizer*)longPress {
    if (longPress.state == UIGestureRecognizerStateChanged) {
        CGPoint pointPDF = [self calculateRealPDFPoint:longPress];
        
        if ([self calculateSelectedArea:pointPDF page:[self page]])
        {
            for (NSValue * tmpValue in self.selectedArea) {
                UIView *selectedView = [[UIView alloc] initWithFrame:[tmpValue CGRectValue]];
                selectedView.backgroundColor=[UIColor yellowColor];
                [self.view addSubview:selectedView ];
            }
        }
        if (self.selectedArea.count>0) {
            NSLog(@"hi");
        }
    }else if (longPress.state == UIGestureRecognizerStateRecognized)
    {
        
    }
}



-(CGPoint) calculateRealPDFPoint:(UILongPressGestureRecognizer*)longPress {
    
    CGPoint pointOnPage = [longPress locationInView:[self view]];
    CGPoint pointOnPDF = [self convertPoint:pointOnPage fromOverlayToPage:[self page]];
    return pointOnPDF;
}


- (void) startSelectedArea:(NSInteger)page {
    
    self.glyphBoxes = [self.document glyphBoxesForPage:page];
}


- (BOOL) calculateSelectedArea:(CGPoint) point page:(NSInteger)page {
    
    CGRect tmpRect = CGRectZero;
    self.glyphBoxes = [self.document glyphBoxesForPage:page];
    for (FPKGlyphBox * glyphBox in self.glyphBoxes) {
        CGRect glyphBoxRect = glyphBox.box;
        if (CGRectContainsPoint(glyphBoxRect, point)) {
            tmpRect = glyphBoxRect;
        }
    }
    
    if (!CGRectIsEmpty(tmpRect)) {
        CGFloat valueOriginY = tmpRect.origin.y;
        
        for (FPKGlyphBox * glyphBox in self.glyphBoxes) {
            CGRect glyphBoxRect = glyphBox.box;
            CGFloat originY = glyphBoxRect.origin.y;
            if (valueOriginY == originY) {
                tmpRect = CGRectUnion(glyphBoxRect, tmpRect);
            }
        }
    }
    
    
    if (!CGRectIsEmpty(tmpRect)) {
        BOOL setted = NO;
        for (NSUInteger cpt = 0; cpt < [self.selectedArea count]; cpt++) {
            NSValue * tmpValue = [self.selectedArea objectAtIndex:cpt];
            CGRect rectValue = [tmpValue CGRectValue];
            CGFloat valueOriginY = rectValue.origin.y;
            CGFloat originY = tmpRect.origin.y;
            if (valueOriginY == originY) {
                setted = YES;
            }
        }
        if (!setted) {
            [self.selectedArea addObject:[NSValue valueWithCGRect:tmpRect]];
        }
    }
    
    return YES;
    
}

-(IBAction)actionText:(id)sender {
    TextDisplayViewController *controller = self.textDisplayViewController;
    controller.delegate = self;
    [controller updateWithTextOfPage:self.page];
    [self presentModalViewController:controller animated:YES];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}



//Delete pin on bases of AnnotationId
-(void)deletePushPin:(NSNumber *) annotationId{
    for (id v in self.view.subviews) {//self view
        if ([v isKindOfClass:[UIScrollView class]]) {//scrollview in self
            //[(UIScrollView*)v setAutoresizingMask:UIViewAutoresizingNone];
            for (id vw in [v subviews]) {//FPKDetailView
                for (id vwx in [vw subviews]) {//FPKIntermediateView
                    for (id vwxy in [vwx subviews]) {//MFScrollDetailView
                        for (id vwxyz in [vwxy subviews]) {//UIView
                            if (![vwxyz isKindOfClass:[UIImageView class]]) {
                                for (id a in [vwxyz subviews]) {
                                    if ([a isKindOfClass:[UIButton class]]) {
                                        if ([(UIButton *)a tag] ==[annotationId integerValue] ) {
                                            [a removeFromSuperview];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


//DELETE Pin With Tag id
-(void)deletePinByTag:(NSInteger) tagId {
    for (id v in self.view.subviews) {//self view
        if ([v isKindOfClass:[UIScrollView class]]) {//scrollview in self
            //[(UIScrollView*)v setAutoresizingMask:UIViewAutoresizingNone];
            for (id vw in [v subviews]) {//FPKDetailView
                for (id vwx in [vw subviews]) {//FPKIntermediateView
                    for (id vwxy in [vwx subviews]) {//MFScrollDetailView
                        for (id vwxyz in [vwxy subviews]) {//UIView
                            if (![vwxyz isKindOfClass:[UIImageView class]]) {
                                for (id a in [vwxyz subviews]) {
                                    if ([a isKindOfClass:[UIButton class]]) {
                                        if ([(UIButton *)a tag] == tagId  ) {
                                            [a removeFromSuperview];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}







//popover delegate
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
   NSLog(@"popoverControllerDidDismissPopover");
    if (self.dismisSts) {
        [self deletePinByTag:self.currentPinTag];
        self.dismisSts = NO;
    }
}



//Canvas delegate mehod
-(void)ResetCanvas:(NSString*)str{
    NSLog(@"ResetCanvas pdf reader");
}


-(void)SaveCanvaswithNewsid:(NSInteger )newsId JsonString:(NSString *)jsonString AnnotationId:(NSNumber*)anoatationId  DrawImage:(UIImage*)image FileName:(NSString *)fileName{
    self.dismisSts = NO;
    
    if (self.updateAnnotationId >0){
        self.updateAnnotationId = 0;
    }else{
       self.currentAnnotationId = [anoatationId integerValue] + 1;
    }
    
    
    //Add push pin
    NSDictionary *dictAnn = [self json_StringToDictionary2:jsonString];
    NSArray* pinArray = [dictAnn objectForKey:@"Annotation"];
    if ( [pinArray count]>0){
        for (NSDictionary *pushpinObj in pinArray) {
            if ([[pushpinObj objectForKey:@"pageNumber"] integerValue]== self.page) {
                CGPoint point=CGPointMake([[pushpinObj objectForKey:@"PointX"] floatValue]*self.minZoomScale, [[pushpinObj objectForKey:@"PointY"] floatValue]*self.minZoomScale);
                [self addPushPin:point Tag:[[pushpinObj objectForKey:@"id"] intValue]  PushPinImage:@"ppbtn" CommentType:[pushpinObj objectForKey:@"type"]];
            }
        }
    }
    //ENDED
    
    [self.pdfdelegate  Pdf_SaveCanvas:newsId JsonString:jsonString Draw:image FileName:fileName];
}



-(void)DeleteCanvas:(NSString *)anotationId NewsPaperId:(NSInteger)newsPaperId FileName:(NSString *)fileName{
    self.dismisSts = NO;
    NSLog(@"DeleteCanvas pdf reader  %i  %@ fileName %@",newsPaperId,anotationId ,fileName );
    [self.pdfdelegate Pdf_DeleteCanvas:anotationId NewsPaperId:newsPaperId FileName:fileName];
    
    
    NSNumber *annId = [NSNumber numberWithInt:[anotationId intValue]];
    [self deletePushPin:annId];
}

-(void)CancelCanvas:(NSInteger )tagId NewsPaperId:(NSString *)newsPaperId{
    self.dismisSts = NO;
    NSLog(@"CancelCanvas pdf tagId  %li",tagId);
    [self deletePinByTag:tagId];
}



//CommentDelgate Method
-(void)SaveComment:(NSString*)JsonString  CommentText:(NSString*)CommentText NewspaperId :(NSInteger)newsId AnnotationId:(NSNumber*)anoatationId{
    self.dismisSts = NO;
    if (self.updateAnnotationId >0){
        self.updateAnnotationId = 0;
    }else{
        self.currentAnnotationId = [anoatationId integerValue] + 1;
    }
    
    //Add push pin
    NSDictionary *dictAnn = [self json_StringToDictionary2:JsonString];
    NSArray* pinArray = [dictAnn objectForKey:@"Annotation"];
    if ( [pinArray count]>0){
        for (NSDictionary *pushpinObj in pinArray) {
            if ([[pushpinObj objectForKey:@"pageNumber"] integerValue]== self.page) {
                CGPoint point=CGPointMake([[pushpinObj objectForKey:@"PointX"] floatValue]*self.minZoomScale, [[pushpinObj objectForKey:@"PointY"] floatValue]*self.minZoomScale);
                [self addPushPin:point Tag:[[pushpinObj objectForKey:@"id"] intValue]  PushPinImage:@"ppbtn" CommentType:[pushpinObj objectForKey:@"type"]];
            }
        }
    }
    //ENDED
    
    [self.pdfdelegate Pdf_SaveComment:JsonString saveCommentText:CommentText NewspaperId:newsId];
}

-(void)DeleteComment:(NSInteger)NewspaperId AnnotationId:(NSNumber*)anoatationId{
    self.dismisSts = NO;
    [self.pdfdelegate Pdf_DeleteComment:NewspaperId AnnotationId:[anoatationId integerValue]];
   
    NSNumber *annId = [NSNumber numberWithInt:[anoatationId intValue]];
    [self deletePushPin:annId];
}


-(void)updateMangeObjectData:(NSManagedObject*)mangeObj{
    
    if (mangeObj != nil){
        self.mangeAnnotationObject = mangeObj;
        
    }else{
        self.mangeAnnotationObject = nil;
    }
    
}


@end

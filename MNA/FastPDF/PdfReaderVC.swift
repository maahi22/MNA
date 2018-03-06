//
//  PdfReaderVC.swift
//  MNA
//
//  Created by Apple on 01/02/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

import UIKit
import MessageUI
import  CoreData



class PdfReaderVC: ReaderViewController {

    var fileName:String = ""
    var fileURL:NSURL = NSURL()
    
    
    var  proofCropBox:CGRect?
    var glyphBoxes:NSArray = NSArray()
    var selectedArea:NSMutableArray = NSMutableArray()
    var newspaperId:NSNumber = 0
    var page:UInt = 0
    
    var popoverController1:UIPopoverPresentationController?
    var minZoomScale:CGFloat = 0.0
    
    var blActivateComment:Bool = false
    var blActivateCanvas:Bool = false
    var isToolBarVisible:Bool = false
    
    var xAxispadding:CGFloat = 0.0
    var yAxispadding:CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        page = 1
        
        
        
        print(self.document.glyphBoxes(forPage: UInt(page)))
        
        
       // isFirsttime=YES;
        self.startSelectedArea(self.page)
        self.selectedArea = NSMutableArray()
       
        /*let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)*/
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressForNote(_:)))
        longGesture.minimumPressDuration = 1.0
        self.view.addGestureRecognizer(longGesture)

        
        
        self.prepareToolbar()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        for vw in self.view.subviews {
            if vw.isKind(of: UIImageView.self) {
                vw.isHidden = true
                }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
     override func prepareToolbar() {
        super.prepareToolbar()
        
        var toolbarItems =  self.rollawayToolbar.items
       // print(toolbarItems)
        
        toolbarItems?.remove(at: 1)
        toolbarItems?.remove(at: 1)
        toolbarItems?.remove(at: 1)
        toolbarItems?.remove(at: 1)
        toolbarItems?.remove(at: 5)
        
        let barButtonItem0:UIBarButtonItem = toolbarItems![0] 
        let barButtonItem1 = UIBarButtonItem(image: UIImage(named: "pushpin"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(ActivePuspin))
        let barButtonItem2 = UIBarButtonItem(image: UIImage(named: "Sticky"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(ActiveCanvas))
        let barButtonItem3 = UIBarButtonItem(image: UIImage(named: "Email"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(EmailClicked))

        
        let button = UIButton(type:.system)
        button.frame = CGRect(x: 0, y: 2, width: 70, height: 40)
        button.setImage(UIImage(named: "Reader-Print"), for: .normal)
        button.addTarget(self, action: #selector(ActivePDFPrint), for: .touchUpInside)
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        
        
      /*  btn = UIBarButtonItem(image: UIImage(named: "email"),
        style: .plain,
        target: self,
        action: #selector(EmailClicked))*/
        
        
        
        // Adding button to navigation bar (rightBarButtonItem or leftBarButtonItem)
     //   self.navigationItem.rightBarButtonItems = [barButtonItem1,barButtonItem2,barButtonItem3,barButton]
   
        toolbarItems?.insert(barButtonItem0, at: 0)
        toolbarItems?.insert(barButtonItem1, at: 1)
        toolbarItems?.insert(barButtonItem2, at: 2)
        toolbarItems?.insert(barButtonItem3, at: 3)
        toolbarItems?.insert(barButton, at: 8)
    
        self.rollawayToolbar.setItems(toolbarItems, animated: true)
   
    
    }
    
    
    
    
    // Private action
    //@objc fileprivate func EmailClicked(sender:UIBarButtonItem) { // body method here }
    
    
    // Private action
    @objc  func ActivePuspin(){
        // body method here
        
        
        blActivateComment = true
        blActivateCanvas = true
        self.hideToolbar()
        self.hideThumbnails()
        
    }
            
            
        // Private action
    @objc  func ActiveCanvas(sender:UIBarButtonItem){
        // body method here
        
        }
                
            
    
    @objc func normalTap(_ sender: UIGestureRecognizer){
        print("Normal tap")
    }
    
    
    
    
    @objc func handleLongPressForNote(_ sender: UILongPressGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
           
            print("UIGestureRecognizerStateEnded")
            //Do Whatever You want on End of Gesture
       
        
        
        
        
        }else if sender.state == .began {
           
            print("UIGestureRecognizerStateBegan.")
           
       
            let  pointPDF = self.calculateRealPDFPoint(sender)
        
            if self.calculateSelectedArea(pointPDF, Page:self.page){
                
                for  tmpValue in self.selectedArea {
                    
                    let selectedView:UIView = UIView.init(frame: (tmpValue as! UIView).frame)
                    selectedView.backgroundColor = .yellow
                    self.view.addSubview(selectedView)
        
                }
            }
        
        }
    }


    
    @objc func calculateRealPDFPoint(_ longPress:UILongPressGestureRecognizer) -> CGPoint{
        let pointOnPage = longPress.location(in: self.view)
     //Mad   let pointOnPDF = self.convert(pointOnPage, fromOverlayToPage: UInt(self.page))
        return pointOnPage
    }
    
    
    @objc func calculateSelectedArea(_ point:CGPoint, Page:UInt)  -> Bool{
    
        var tmpRect = CGRect()
        if  (self.document.glyphBoxes(forPage: UInt(Page)) != nil){
            self.glyphBoxes = self.document.glyphBoxes(forPage: UInt(Page)) as! NSArray
        }

        if (self.glyphBoxes.count) > 0 {
            
            for glyphBox in self.glyphBoxes{
                
                let glyphBoxRect = (glyphBox as AnyObject).box
                if glyphBoxRect!.contains(point){
                    tmpRect = glyphBoxRect!
                }
            }
        }
        
        if !self.CheckEmpity(tmpRect){
           
            let valueOriginY:CGFloat = tmpRect.origin.y
           
            if self.glyphBoxes.count > 0 {
                for glyphBox in self.glyphBoxes {
                    let glyphBoxRect :CGRect =  (glyphBox as AnyObject).box
                    let originY = glyphBoxRect.origin.y
                    if valueOriginY == originY {
                        tmpRect = glyphBoxRect.union(tmpRect);
                    }
                }
            }
            
            
        }
        
        if !self.CheckEmpity(tmpRect){
            var setted = false
            
            if self.selectedArea.count > 0 {
                for i in 0...(self.selectedArea.count-1){
                    
                    let tmpValue = self.selectedArea[i]
                    let rectValue:CGRect = (tmpValue as AnyObject).cgRectValue
                    let valueOriginY = rectValue.origin.y
                    let originY:CGFloat = tmpRect.origin.y
                    
                    if valueOriginY == originY {
                        setted = true
                    }
                    
                }
            }
            
            
        }
        

    
     return true
    }
    
    func CheckEmpity(_ frm:CGRect) ->Bool{
        
        let empity:CGRect? = nil
        if frm == empity{
            return true
        }else{
            return false
        }
        
    }
    
    
    func startSelectedArea(_ page:UInt){
        if self.document != nil {
         //   self.glyphBoxes = self.document.glyphBoxes(forPage: UInt(page)) as! NSArray
        }
    }
    
    
    @objc  func EmailClicked(){
        
        let alertController = UIAlertController(title: "Alert!", message: "This facsimile/e-mail message contain CONFIDENTIAL,  PRIVILEGED or SECURE material of the National Assembly of Mauritius. Any unauthorized use, disclosure or distribution is prohibited. Are you sure you want to share.", preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.EmailPdf()
        }
        
        let NoAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            
        }
        alertController.addAction(yesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
        
        
            
    }
    
    
    
    func EmailPdf(){
        if MFMailComposeViewController.canSendMail() {
            
            UINavigationBar.appearance().barTintColor = UIColor.red
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.setToRecipients([""])
            composeVC.setSubject("")
            composeVC.setMessageBody("", isHTML: false)
            // Present the view controller modally.
            

            /*let dateformater = DateFormatter()
            dateformater.dateFormat = "dd-MM-YYYY hh:mm"
            dateformater.timeZone = DefaultDataManager.AppTimeZone() as TimeZone!
            let now = DefaultDataManager.AppCurrentTime()
            var   attachFileName = ""
            if let title = (self.detailProjectManageobj as! Projects).title , let ref = (self.detailProjectManageobj as! Projects).reference {
                attachFileName = "\(title) \(ref) \(dateformater.string(from: now as Date)).pdf"
            }*/
            
            
            let urlstring = (self.fileURL.absoluteString)?.replacingOccurrences(of: ".pdf", with: ".json")
            let jsonFileName = URL(fileURLWithPath: urlstring!).lastPathComponent
            let jsonFilePath = "\(CommonHelper.getApplicationDirectoryPath)pdffiles/\(jsonFileName)"
            
            let jsonFileContent = try? String(contentsOfFile: jsonFilePath, encoding: String.Encoding.utf8)
            
           // let jsonArray:NSArray = []
           /* if let data = try? JSONSerialization.data(withJSONObject: jsonFileContent, options: .prettyPrinted),
                let data = String(data: data, encoding: .utf8) {
             
                //print(str)
            }*/
            
            let data = jsonFileContent?.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data!, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                    
                    
                    
                    
                    let path = self.fileURL.absoluteString
                    let pdfURL = NSURL.fileURL(withPath: path!)
                    
                    
                    // Data object to fetch weather data
                    do {
                        let data = try NSData(contentsOf: pdfURL, options: NSData.ReadingOptions())
                        //  print(weatherData)
                        
                        composeVC.addAttachmentData(data as Data, mimeType: "application/pdf", fileName: "\(jsonArray[4]).pdf")
                        
                        
                    } catch {
                        print(error)
                    }
                    
                    
                    
                    
                    
                    
                    
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            
            

            
            
            
            
            
            /*if let data = NSData(contentsOfFile: pdfURL) {
                //Does not print. Nil?
                composeVC.addAttachmentData(data as Data, mimeType: "application/pdf", fileName: "\(jsonArray[4]).pdf"")
            }*/
            
            //************* Attached projectImage
            
            
            self.present(composeVC, animated: true, completion: nil)
            
        }else{
            
            let alert = UIAlertController(title: "Alert", message: "Please configure mail", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            print("Mail services are not available")
            return
            
        }
    }
    
    
    
    
    @objc func ActivePDFPrint(){
        
        let printController = UIPrintInteractionController.shared
        // 2
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = self.fileName
        printController.printInfo = printInfo
        printController.printingItem = self.fileURL
        printController.showsPageRange = true
        // 3
        /* let formatter = UIMarkupTextPrintFormatter(markupText: "Hi My name jhon")
         formatter.contentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
         printController.printFormatter = formatter*/
        
        // 4
        printController.present(animated: true, completionHandler: nil)
        
    }
    
    
    
    func ActivePDFPrint1 (){
    
       // UINavigationBar.appearance().barTintColor = UIColor.hexStringToUIColor(hex: MyDunia_colorPrimary)
      //  let data = UIImagePNGRepresentation(ImageFile) as NSData?
        // 1
        let printController = UIPrintInteractionController.shared
        // 2
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = self.fileName
        printController.printInfo = printInfo
        printController.printingItem = self.fileURL
        printController.showsPageRange = true
        // 3
        /* let formatter = UIMarkupTextPrintFormatter(markupText: "Hi My name jhon")
         formatter.contentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
         printController.printFormatter = formatter*/
        
        // 4
        printController.present(animated: true, completionHandler: nil)
        
    }

    
    
    //---Show comments popoverup---
    func ShowCommentPopup(_ touchedPoint:CGPoint ,annotationId:Int){
        
        let storyboard = UIStoryboard(name: "Comments", bundle: nil)
        //dlet commentView = storyboard.instantiateViewController(withIdentifier: "CommentsPopupView") as! CommentsPopupView
        guard let commentView = storyboard.instantiateInitialViewController() as? CommentsPopupView else { return  }
        commentView.pdfReader = self
        commentView.point = touchedPoint
        commentView.blDeletePushpin = true
        
        
        if  !commentView.getComments(annotationId){
           
            let dateFormat = DateFormatter()
            //dateFormat.timeZone = NSTimeZone(abbreviation: "IST")! as TimeZone
            dateFormat.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
            commentView.NotesDatetime = dateFormat.string(from: Date())
            commentView.blDeletePushpin = false
        }
        
        
        var myrect:CGRect = commentView.view.frame
        
        //create a popover controller
        self.popoverController1 = UIPopoverPresentationController.init(presentedViewController: commentView, presenting: commentView)
      //  self.popoverController1?.preferredContentSize = myrect.size
      //  popover.sourceView = self.view
       // popover.sourceRect = CGRectMake(100,100,0,0)
        
        if (annotationId != 0) {
            
        }
        else{
            self.popoverController1?.delegate = self
            commentView.textViewComment.isEditable = true
        }
        
        myrect.size.width = 0//500//0
        myrect.size.height = 0//500//0
        myrect.origin.x =  self.zoomOffset().x >= touchedPoint.x ?self.zoomOffset().x - touchedPoint.x:touchedPoint.x - self.zoomOffset().x
        myrect.origin.y = self.zoomOffset().y >= touchedPoint.y ? self.zoomOffset().y - touchedPoint.y:touchedPoint.y - self.zoomOffset().y

        
        commentView.popoverPresentationController?.sourceRect = myrect
        commentView.popoverPresentationController?.sourceView = self.view
        commentView.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)

        self.present(commentView, animated: true, completion: nil)
        
       // self.present(commentView, animated: true, completion: nil)

       // self.presentViewController(self.popoverController1, animated: true, completion: nil)
        
       /* self.popoverController1.presentpop
        presentPopoverFromRect(myrect, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        */
    
    }
    
    
    
    
    
    func ShowCommentCanvas(_ touchedPoint:CGPoint , annotationId:Int){//} , btn:UIBarButtonItem){
        
        let storyboard = UIStoryboard(name: "Canvas", bundle: nil)
        let canvas = storyboard.instantiateViewController(withIdentifier: "CanvasVC") as! CanvasVC
        
        if annotationId == 0 {
           // VC.getCommentImage(NSNumber(annotationId))
        }
        
        
       // canvas.point = touchedPoint
        //canvas.pdfReader = self
        canvas.view.superview?.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        canvas.view.superview?.center = self.view.center
        canvas.modalTransitionStyle = .flipHorizontal
        self.present(canvas, animated: true) {
            
        }
        
      /*  canvas.modalPresentationStyle = .popover
        canvas.preferredContentSize = CGSize(width: (500), height: 260)
        present(canvas, animated: true, completion: nil)
        
        popoverController1 = canvas.popoverPresentationController
        popoverController1?.permittedArrowDirections = .up
        popoverController1?.delegate = self
        popoverController1?.barButtonItem = btn*/
    }
    
    
    
    
 
    
    
    //Override delegate method of pdf
    override func documentViewController(_ dvc: MFDocumentViewController!, didFocusOnPage page: UInt) {
        //featch annotation
        //Getting Annotation List
        let annotationsList:[NSManagedObject] = DBHelper.fetchRequestForAnnotation("Annotations",FilterExpression: "(newspaper_Id == \(self.newspaperId))")
        if annotationsList.count > 0 {
            for pushpinObj in annotationsList{
                
                let pust = pushpinObj as NSManagedObject
                let pageNo:UInt = pust.value(forKey: "pageNumber") as! UInt
                
               
                if  pageNo == page{
                    
                    let xVal:CGFloat = pust.value(forKey: "PointX") as! CGFloat
                    let yVal:CGFloat = pust.value(forKey: "PointY") as! CGFloat
                    
                    let point = CGPoint(x: xVal ,y: yVal )
                    let tag = pust.value(forKey: "id") as! Int
                    let comment = pust.value(forKey: "type") as! String
                    self.addPushPin(point, Tag: tag, PushPinImage: "ppbtn.png", CommentType: comment)
                    
                }
                
            }
        }
        
        //Go
    }
    
    
    
    override func documentViewController(_ dvc: MFDocumentViewController!, didReceiveTapAt point: CGPoint) {
        
        if ((blActivateComment || blActivateCanvas) && isToolBarVisible) {
            
            let a:CGFloat = CGFloat(self.zoomScale())
            let b:CGFloat = self.minZoomScale <= 0 ? 1 : self.minZoomScale
            let zmScale:CGFloat = (a * b)
            let x1:CGFloat = point.x / zmScale
            let y1:CGFloat = point.y / zmScale
            
            if ((self.yAxispadding > 0) && (y1 > self.yAxispadding) && (y1 < ((self.proofCropBox?.size.height)! + self.yAxispadding))  ) {
                
                if blActivateComment {
                    self.ShowCommentPopup(point,annotationId:0)
                }else{
                    self.ShowCommentCanvas(point, annotationId:0)
                }
                
            }
            else if ((self.xAxispadding > 0) && (x1 > self.xAxispadding) && (x1 < ((self.proofCropBox?.size.width)! + self.xAxispadding)) ){
                
                if (blActivateComment) {
                    self.ShowCommentPopup(point,annotationId:0)
                }else{
                    self.ShowCommentCanvas(point, annotationId:0)
                }
            }  else if ( (self.xAxispadding == 0) && (self.yAxispadding == 0) ){
                
                if (blActivateComment) {
                     self.ShowCommentPopup(point,annotationId:0)
                }else{
                    self.ShowCommentCanvas(point, annotationId:0)
                }
            }
            else{
                let alert = UIAlertController(title: "Alert!", message: "You cannot place pushpins outside the active are of the artwork. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
            blActivateCanvas = false
            blActivateComment = false
            isToolBarVisible = false
            
            
            
        }else{
            if !isToolBarVisible {
                self.showToolbar()
                self.showThumbnails()
                isToolBarVisible = true
            
            }else{
                
                isToolBarVisible = false
                self.hideToolbar()
                self.hideThumbnails()
                
            }
        }
        
    }
    
    
    override func documentViewController(_ dvc: MFDocumentViewController!, didReceiveTapOnPage page: UInt, at point: CGPoint) {
        
        // if waitingForTextInput {
        //  waitingForTextInput = false
        let controller:TextDisplayViewController  = self.textDisplayViewController
        
        
        
       // let controller:TextDisplayViewController = TextDisplayViewController.init(nibName: "TextDisplayView", bundle: Bundle(for: type(of: self)))//[[TextDisplayViewController alloc]initWithNibName:@"TextDisplayView" bundle:[NSBundle bundleForClass:[self class]]];
       // controller.documentManager = self.document;
        
        controller.delegate = self
        controller.update(withTextOfPage: page)
      /*  self.present(controller, animated: true) {
            
        }*/
        //  }
        
    }
    
    override func documentViewController(_ dvc: MFDocumentViewController!, didGoToPage page: UInt) {
        
        for v in self.view.subviews{
            
            if v.isKind(of: UIScrollView.self) {//scrollview in self
                
                for vw in v.subviews{//FPKDetailView
                    
                    for vwx in vw.subviews{//FPKIntermediateView
                        
                        for vwxy in vwx.subviews{//MFScrollDetailView
                            
                            for vwxyz in vwxy.subviews{//UIView
                                
                                if !vwxyz.isKind(of: UIImageView.self) {
                                    
                                    for a in vwxyz.subviews{
                                        
                                        if a.isKind(of: UIButton.self) {
                                            a.removeFromSuperview()
                                        }
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
        //ADD PUSH RED PIN
        //Getting Annotation List
        let annotationsList:[NSManagedObject] = DBHelper.fetchRequestForAnnotation("Annotations",FilterExpression: "(newspaper_Id == \(self.newspaperId))")
        if annotationsList.count > 0 {
            for pushpinObj in annotationsList{
                let pust = pushpinObj as NSManagedObject
                let pageNo:UInt = pust.value(forKey: "pageNumber") as! UInt
                if  pageNo == page{
                    let point = CGPoint(x: (pust.value(forKey: "PointX") as! CGFloat) ,y : (pust.value(forKey: "PointY") as! CGFloat) )
                    let tag = pust.value(forKey: "id") as! Int
                    let comment = pust.value(forKey: "type") as! String
                    self.addPushPin(point, Tag: tag, PushPinImage: "ppbtn.png", CommentType: comment)
                }
            }
        }
        
    }
    


    func addPushPin(_ point:CGPoint, Tag:Int , PushPinImage:String, CommentType:String){
        
        for v in self.view.subviews{
            
            if v.isKind(of: UIScrollView.self) {//scrollview in self
                
                for vw in v.subviews{//FPKDetailView
                    
                    for vwx in vw.subviews{//FPKIntermediateView
                        
                        for vwxy in vwx.subviews{//MFScrollDetailView
                            
                            for vwxyz in vwxy.subviews{//UIView
                                
                                if !vwxyz.isKind(of: UIImageView.self) {
                                    
                                    var x = 0.0
                                    var y = 0.0
                                    var minZmScale:Float = 0.0
                                    
                                    
                                    
                                    let image = UIImage(named: PushPinImage) as UIImage?
                                    let btn   = UIButton(type: UIButtonType.custom) as UIButton
                                    btn.tag = Tag
                                    btn.setImage(image, for: .normal)
                                    if CommentType.lowercased() == "image"{
                                        
                                        btn.addTarget(self, action: #selector(showCanvas) , for: .touchUpInside)
                                    }else{
                                        
                                        btn.addTarget(self, action: #selector(showComment), for: .touchUpInside)
                                    }
                                    
                                    if PushPinImage == "ppbtn.png"{
                                        minZmScale = Float(self.minZoomScale)
                                        let  x1 = CGFloat(CGFloat(point.x) * CGFloat(minZmScale - 12))
                                        btn.frame = CGRect(x: x1, y: 0.0, width: 30.0, height: 30.0)
                                        
                                    }else{
                                        minZmScale = self.zoomScale()
                                      let  x1 = CGFloat((point.x) / CGFloat(minZmScale - 12))
                                      //let  y1 = (point.y) / minZmScale - 30
                                        btn.frame = CGRect(x: x1, y: 0.0, width: 30.0, height: 30.0)
                                        
                                    }
                                    
                                    
                                    
                                    vwxyz.addSubview(btn)
                                    
                                    
                                    
                                    
                                   
                                    /*[UIView beginAnimations:nil context:nil];
                                     //[UIView setAnimationDuration:0.3];
                                     CGAffineTransform transform =![image isEqualToString:@"ppbtn.png"]? CGAffineTransformMakeTranslation(0, (point.y)*minZmScale-30):CGAffineTransformMakeTranslation(0, y);
                                     [btn setTransform:transform];
                                     [UIView commitAnimations];
                                     // animate
                                     [vwxyz addSubview:btn]*/
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
        
    }


    
    @objc func showCanvas(sender:UIButton){
       print("showCanvas")
    }


    @objc func showComment(sender:UIButton){
        print("showComment")
    }
    
}



extension  PdfReaderVC:UIPopoverPresentationControllerDelegate{
    
}




extension PdfReaderVC:MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // print(error)
        controller.dismiss(animated: true, completion: nil)
    }
}



extension MFMailComposeViewController {
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = true
        navigationBar.isOpaque = true
      //  navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: navigationColorCode)
      //  navigationBar.tintColor = UIColor.hexStringToUIColor(hex: navigationColorCode)
    }
}

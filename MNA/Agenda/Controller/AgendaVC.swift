//
//  AgendaVC.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

//https://stackoverflow.com/questions/26305707/how-to-pause-resume-cancel-my-download-request-in-alamofire

import UIKit
import CoreData
import Alamofire
import AlamofireSwiftyJSON



class AgendaVC: UIViewController, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var progressBarView: UIProgressView!
    
    @IBOutlet weak var doneView: UIView!
    
    var openPdfPath = ""
    var arrJsonData:NSArray = []
    // var pdfUrl = ""
    var currentTab = ""
    var popover: UIPopoverController? = nil
    var uploadId = 0
    var deletefileName = ""
    var request: Alamofire.Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.scrollView.isScrollEnabled = false
        
        datePicker.backgroundColor = .white
        datePicker.tintColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector:#selector(AgendaVC.reloadContentOnActive), name:
            NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.navigationController?.navigationBar.isHidden = false
        //self.navigationItem.hidesBackButton = true
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        /* let fileManager = FileManager.default
         let pdfUrl = Bundle.main.resourceURL!.appendingPathComponent("Testing.pdf").path
         
         
         var   viewer: PDFKBasicPDFViewer = segue.destination as! PDFKBasicPDFViewer
         //Load the document (pdfUrl represents the path on the phone of the pdf document you wish to load)
         var document: PDFKDocument = PDFKDocument(contentsOfFile: pdfUrl, password: nil)
         viewer.loadDocument(document)*/
        
    }
    
    
    //Laoding HTML With changes
    func loadData (){
        let appPath = CommonHelper.getApplicationDirectoryPath()
        let urlString = "\(appPath)/template/NA_main.html"
        
        if  urlString != nil {
            activityIndicator.startAnimating()
            
            let page = pageContent()
            let url = NSURL (string: urlString)
            let requestObj = URLRequest(url: url! as URL)
            webview.loadHTMLString(page, baseURL: url as! URL)
            
        }
    }
    
    
    func pageContent() ->String{
        let strCatchPath = CommonHelper.getApplicationDirectoryPath()
        let strPath = "\(strCatchPath)/template/NA_main.html"
        var strContent = try? String(contentsOfFile: strPath, encoding: String.Encoding.utf8)
        strContent = strContent?.replacingOccurrences(of: "remoteUrl", with: "\(RemoteURL)")
        return strContent!
    }
    
    
    @objc func reloadContentOnActive(notifier:NSNotification){
        
        if self.currentTab != ""{
            
            let arrCurrentTab = self.currentTab.components(separatedBy: "@@@") as! NSArray
            
            if arrCurrentTab.count > 1{
                if (arrCurrentTab[2] as! Int) == 0 {
                    
                    let stVal = arrCurrentTab[1]
                    let str = "getAgenda('\(stVal)');"
                    self.webview.stringByEvaluatingJavaScript(from: str)
                }else{
                    let stVal1 = arrCurrentTab[1]
                    let stVal2 = arrCurrentTab[2]
                    let stVal3 = arrCurrentTab[3]
                    let stVal4 = arrCurrentTab[4]
                    
                    
                    let strparam = "showSelection('\(stVal1)',\(stVal2),'\(stVal3)','\(stVal4)');"
                    self.webview.stringByEvaluatingJavaScript(from: strparam)
                }
            }
        }
    }
    //Ending
    
    @IBAction func btnToolbarMyLibraryClicked(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "Library", bundle: nil)
        let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LibraryVC") as! LibraryVC
        navigationController?.pushViewController(ViewController,  animated: false)
        /*self.present(ViewController, animated: true, completion: {
         
         })*/
        
    }
    
    @IBAction func btnToolbarLogOutClicked(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Logout!", message: "Are you sure you wish to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            DefaultDataManager.removeUserName()
            DefaultDataManager.removePassword()
            
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            //let navController = UINavigationController(rootViewController: ViewController)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.navController = UINavigationController(rootViewController: ViewController)
            appDelegate.window?.rootViewController = appDelegate.navController
            
        }
        
        let NoAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            
        }
        alertController.addAction(yesAction)
        alertController.addAction(NoAction)
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func btnToolbarSearchClicked(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "Search", bundle: nil)
        let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        navigationController?.pushViewController(ViewController,  animated: true)
        /*self.present(ViewController, animated: true, completion: {
            
        })*/
        
        //self.readPdf()
        
    }
    
    @IBAction func btnToolbarAlertClicked(_ sender: UIBarButtonItem) {
        
        let mainStoryBoard = UIStoryboard(name: "Alert", bundle: nil)
        let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "AlertVC") as! AlertVC
        // navigationController?.pushViewController(ViewController,  animated: true)
        
        ViewController.modalPresentationStyle = .popover
        ViewController.preferredContentSize = CGSize(width: (self.view.frame.size.width - 200), height: 400)
        
        present(ViewController, animated: true, completion: nil)
        
        let popController = ViewController.popoverPresentationController
        popController?.permittedArrowDirections = .up
        popController?.delegate = self
        popController?.barButtonItem = sender
    }
    
    @IBAction func btnToolbarNoticeClicked(_ sender: UIBarButtonItem) {
        
        let mainStoryBoard = UIStoryboard(name: "Notice", bundle: nil)
        let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "NoticeVC") as! NoticeVC
        if sender.tag == 10 {
           ViewController.urlString = "http://www.govmu.org/English/Pages/default.aspx"
        }
        else if sender.tag == 11{
           ViewController.urlString = "http://parliamenttv.govmu.org/"
        }
        
        //navigationController?.pushViewController(ViewController,  animated: true)
        self.present(ViewController, animated: true, completion: {
            
        })
        
    }
    
    @IBAction func btnSettingClicked(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let ViewController = storyboard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        
        ViewController.modalPresentationStyle = .popover
        ViewController.preferredContentSize = CGSize(width: (500), height: 260)
        present(ViewController, animated: true, completion: nil)
        
        let popController = ViewController.popoverPresentationController
        popController?.permittedArrowDirections = .up
        popController?.delegate = self
        popController?.barButtonItem = sender
        
        
    }
    
    
    func readPdf(_ fileNme:String){
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let   filePath = documentsDirectory.appendingPathComponent("pdffiles/\(fileNme).pdf")
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: filePath){
            
            DispatchQueue.main.async(execute: { () -> Void  in
                self.activityIndicator.stopAnimating()
            })
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openPDFWithNewsPaperid(self.openPdfPath, fileName: fileNme, NewspaperId: self.uploadId)
            
            
        }else{
            print("  NOT exist.")
        }
        
        
        
    }
    
    
    func makeCalender(_ date:Date){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let timeZone = NSTimeZone.init(name: "GMT")
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        var   comps = gregorianCalendar.components(in: timeZone as TimeZone!, from: date as Date)
        comps.day = 1
        let  startDate = dateFormat.string(from: gregorianCalendar.date(from: comps)!) as String
        comps.day = 0
        comps.month = comps.month! + 1
        let endDate = dateFormat.string(from: gregorianCalendar.date(from: comps)!) as String
        let makeCalender = "makeCalendar1('\(startDate)','\(endDate)');"
        
        self.webview.stringByEvaluatingJavaScript(from: makeCalender)
    }
    
    
    
    func showPicker(){
        
        if datePicker.isHidden {
            datePicker.isHidden = false
            doneView.isHidden = false
            //>>>
            datePicker.datePickerMode = .dateAndTime
          //  datePicker.locale = Locale(identifier: "en_GB")

        }
        
    }
    
    @IBAction func pickerDonePressed(_ sender: Any) {
        self.makeCalender(datePicker.date)
        
        datePicker.isHidden = true
        doneView.isHidden = true
    }
    
    
    @IBAction func cancelDatePicker(_ sender: Any) {
        datePicker.isHidden = true
        doneView.isHidden = true
        
    }
    
    
}



extension  AgendaVC: UIWebViewDelegate{
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        if let urlStr = request.url {
            let str = "\(urlStr)" as String
            var   strUrl =  str.removingPercentEncoding
            
            if strUrl?.range(of:"_TAGSEL_") != nil {
                print("exists")
                let arraySeprate = strUrl?.components(separatedBy: "_TAGSEL_") as! NSArray
                if  arraySeprate.count > 1 {
                    self.currentTab = arraySeprate[1] as! String
                }
            }
            
            if strUrl?.range(of:"_PDF_") != nil {
                print("_PDF_")
                
                let arrUrl = strUrl?.components(separatedBy: "@@@") as! NSArray
                
                let uploadId = arrUrl[1] as! String
                let orderName = arrUrl[2] as! String
                let orderDate = arrUrl[3] as! String
                let pdfUrl = arrUrl[4] as! String
                let pdfTitle = arrUrl[5] as! String
                
                let fileServerPathurl:NSURL = NSURL (string: pdfUrl)!
                /*DispatchQueue.main.async(execute: { () -> Void  in
                    self.activityIndicator.startAnimating()
                })*/
                
                let destfileName = (fileServerPathurl as URL).deletingPathExtension().lastPathComponent
                let documentsUrl: URL = CommonHelper.getDocDirPath()
                let destinationFileUrl =  documentsUrl.appendingPathComponent("pdffiles/\(destfileName).pdf")
                
                self.arrJsonData = [uploadId,pdfUrl,orderName,orderDate, pdfTitle]
                self.uploadId = Int(uploadId)!
                self.downloadFile(fileServerPathurl as URL, destinationFileUrl: destinationFileUrl as URL, pdfID: uploadId)
                
                return false
            }
            
            if strUrl?.range(of:"library") != nil {
                let mainStoryBoard = UIStoryboard(name: "Library", bundle: nil)
                let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LibraryVC") as! LibraryVC
                navigationController?.pushViewController(ViewController,  animated: true)
                return false
            }
            
            
            if strUrl?.range(of:"_OP_") != nil {
                let arrUrl = strUrl?.components(separatedBy: "@@@") as! NSArray
                
                if arrUrl.count > 0{
                    let   lastComponent = arrUrl[1] as! String
                    
                    let mainStoryBoard = UIStoryboard(name: "OP", bundle: nil)
                    let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "OPVC") as! OPVC
                    ViewController.selectedDate = lastComponent
                    navigationController?.pushViewController(ViewController,  animated: false)
                    
                    return false
                }
            }
            
            if strUrl?.range(of:"_Detail_") != nil {
                let arrUrl = strUrl?.components(separatedBy: "@@@") as! NSArray
                
                if arrUrl.count > 0{
                    let   lastComponent = arrUrl[1] as! String
                    let mainStoryBoard = UIStoryboard(name: "Detail", bundle: nil)
                    let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                    ViewController.PubCode = lastComponent;
                    ViewController.PubName = arrUrl[2] as! String
                    ViewController.PubYear = arrUrl[3] as! String
                    ViewController.PubMonth = arrUrl[4] as! String
                    navigationController?.pushViewController(ViewController,  animated: false)
                    
                    
                    return false
                }
                
            }
            
            // on year click
            /*  if strUrl?.range(of:"_Detail_2") != nil {
             let arrUrl = strUrl?.components(separatedBy: "@@@") as! NSArray
             
             if arrUrl.count > 0{
             let   lastComponent = arrUrl[1] as! String
             let mainStoryBoard = UIStoryboard(name: "Detail", bundle: nil)
             let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
             ViewController.PubCode = lastComponent;
             ViewController.PubName = arrUrl[2] as! String
             ViewController.PubYear = arrUrl[3] as! String
             // ViewController.PubMonth = arrUrl[4] as! String
             navigationController?.pushViewController(ViewController,  animated: false)
             
             
             return false
             }
             
             }*/
            //END
            
            let arrUrl = strUrl?.components(separatedBy: "@@@") as! NSArray
            if arrUrl.count > 1{
                let   lastComponent = arrUrl[1] as! String
                if lastComponent == "settings" {
                    
                    let mainStoryBoard = UIStoryboard(name: "Settings", bundle: nil)
                    let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
                    //navigationController?.pushViewController(ViewController,  animated: true)
                    self.present(ViewController, animated: true, completion: {
                        
                    })
                }
                
                if lastComponent == "pause" {
                    
                    self.request?.suspend()
                    
                    let alert = UIAlertController(title: "Alert", message: "Do you want to stop download?", preferredStyle: UIAlertControllerStyle.alert)
                    let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        
                        DownloadHelper.deleteFileFromDocDirName(self.deletefileName)
                        let script = "$('#upProgress').css('display','none');$('.downloadBox').hide();$('.DownloadPercent').text('');"
                        self.webview.stringByEvaluatingJavaScript(from:script )
                        self.request?.cancel()
                        
                    }
                    
                    let NoAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                        self.request?.resume()
                    }
                    alert.addAction(yesAction)
                    alert.addAction(NoAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                if lastComponent == "showcalender" {
                    self.showPicker()
                }
                
                if lastComponent == "refresh" {
                    let date = Date()
                    self.makeCalender(date)
                }
                
                
                if lastComponent == "nointernet" {
                    
                    let alert = UIAlertController(title: "No internet connection", message: "This application requires a WiFi or cellular network to connect to the server. Please ensure that you have an active connection and/or Airplane mode is turned off.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                return false
            }
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    func downloadFile(_ fileServerPathurl :URL ,destinationFileUrl:URL , pdfID:String ){
        
        let fileManger = FileManager.default
        
        var  destinationPath = CommonHelper.getApplicationDirectoryPath()
        var filename =  (fileServerPathurl as URL).deletingPathExtension().lastPathComponent//pdfID
        self.openPdfPath = "\(destinationPath)/pdffiles/\(filename).pdf"
        self.deletefileName = filename
        
        let pdfFile = "\(destinationPath)/pdffiles/\(filename).pdf"
        
        if !fileManger.fileExists (atPath:pdfFile){
            
            let fileURL:NSURL = URL(string: self.openPdfPath) as! NSURL
            var error : NSError?
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self.arrJsonData, options: .prettyPrinted)
                let jsonString =  String(bytes: jsonData, encoding: String.Encoding.utf8)
                let jsonFileName:String = filename
                //writing
                do {
                    
                    let documentsUrl: URL = CommonHelper.getDocDirPath()
                    let writePathFileUrl =  documentsUrl.appendingPathComponent("pdffiles/\(filename).json")
                    try jsonString?.write(to: writePathFileUrl as URL, atomically: false, encoding: .utf8)
                }
                catch {
                    
                    /* error handling here */
                    print("Write  failed:  \(error)")
                    
                }
                
                
            } catch {
                
                print("JSON serialization failed:  \(error)")
                
            }
       //     print(arrJsonData)
            
            //********** Download Start
            let scriptStr = "$('#upProgress').css('display','inline'); $('.downloadBox').show();$('.DownloadName').text('\(arrJsonData[2])')"
            self.webview.stringByEvaluatingJavaScript(from:scriptStr )
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                return (destinationFileUrl as URL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            self.request =  Alamofire.download("\(fileServerPathurl)", to:destination)
                .downloadProgress { (progress) in
                    //self.progressLabel.text = (String)(progress.fractionCompleted)
                    
                    let percent  = (String)(progress.fractionCompleted)
                    let scriptStr2 = "updateProgress(\(progress.fractionCompleted),1.0);"
                    
                    self.webview.stringByEvaluatingJavaScript(from:scriptStr2 )
                }
                .responseData { (data) in
                    //self.progressLabel.text = "Completed!"
                    DispatchQueue.main.async(execute: { () -> Void  in
                        self.activityIndicator.stopAnimating()
                        self.readPdf("\(filename)")
                        
                        self.webview.stringByEvaluatingJavaScript(from:"hideProgress();")
                    })
                    print("Agenda Successfully Download file \(filename)")
            }
            //********** Download ENDED
            
            
            
            //DOWNLOAD Strat
            /*MNAConnectionHelper.DownloadFiles(url: fileServerPathurl as URL, to: destinationFileUrl as URL,NewspaperId:self.uploadId , completion: { (status) in
                
                DispatchQueue.main.async(execute: { () -> Void  in
                    self.activityIndicator.stopAnimating()
                    let script = "$('#upProgress').css('display','none');$('.downloadBox').hide();"
                    self.webview.stringByEvaluatingJavaScript(from:script )
                    self.readPdf("\(filename)")
                })
                
                print("Successfully Download file \(destinationFileUrl)")
            })//END
            */
        } else {
            print("file already exist")
            
            //Open DOWNLOAD Strat
            
            
            
            DispatchQueue.main.async(execute: { () -> Void  in
                self.activityIndicator.stopAnimating()
            })
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openPDFWithNewsPaperid(pdfFile, fileName: filename, NewspaperId: self.uploadId)
            
           /* let fileName1 = "\(filename)"
            let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let   filePath = documentsDirectory.appendingPathComponent("pdffiles/\(fileName1).pdf")
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: filePath){
                
                DispatchQueue.main.async(execute: { () -> Void  in
                    self.activityIndicator.stopAnimating()
                })
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.openPDFWithNewsPaperid(filePath, fileName: fileName1, NewspaperId: self.uploadId)
                
            }else{
                print("  NOT exist. filePath")
            }*/
            //END
            
        }
        
    }
    
}


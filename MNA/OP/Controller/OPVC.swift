//
//  OPVC.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireSwiftyJSON


class OPVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var progressBarView: UIProgressView!
    
    var selectedDate:String?
    var agendaId = 0
    var arrJsonData:NSArray = []
    var openPdfPath = ""
    var deletefileName = ""
    var request: Alamofire.Request?

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appPath = CommonHelper.getApplicationDirectoryPath()
        let urlString = "\(appPath)/template/orderpaper.html"
        
        if  urlString != nil {
            
            let page = pageContent()
            activityIndicator.startAnimating()
            let url = NSURL (string: urlString)
            let requestObj = URLRequest(url: url! as URL)
            webview.loadHTMLString(page, baseURL: url as! URL)//loadRequest(requestObj)
        }
        
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
    }
    
    
    
    func pageContent() ->String{
        
        var StrDate = ""
        var dateStr = Date()
        let dateFormat = DateFormatter()
        dateFormat.timeZone = NSTimeZone(abbreviation: "IST")! as TimeZone
        dateFormat.dateFormat = "EEEE, MMM d yyyy"
        let dateFormat2 = DateFormatter()
        dateFormat2.dateFormat = "yyyy-MM-dd"
        
        
        if let dateValue = selectedDate {
            let dArray = dateValue.components(separatedBy: " ")
            let dStr = "\(dArray[0]), \(dArray[1]) \(dArray[2]) \(dArray[3])"
            dateStr = dateFormat.date(from: dStr)!//date(from:"Mon Feb 05 2018 11:30:00 GMT+0530")!
            StrDate = dateFormat2.string(from: dateStr)
        } else {
            print("Doesn’t contain a number")
        }
        
        
        
        let strCatchPath = CommonHelper.getApplicationDirectoryPath()
        let strPath = "\(strCatchPath)/template/orderpaper.html"
        var strContent = try? String(contentsOfFile: strPath, encoding: String.Encoding.utf8)
        strContent = strContent?.replacingOccurrences(of: "selectedDate", with: "\(StrDate)")
        strContent = strContent?.replacingOccurrences(of: "remoteUrl", with: "\(RemoteURL)")
        return strContent!
    }
    
    @IBAction func backClicked(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            // self.dismiss(animated: true, completion: nil)
            //self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.popViewController(animated: false)
        })
    }
    
}


extension  OPVC: UIWebViewDelegate{
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        if let urlStr = request.url {
            let str = "\(urlStr)" as String
            var   strUrl =  str.removingPercentEncoding
            
            let arraySeprate = strUrl?.components(separatedBy: "@@@") as! NSArray
            
            if strUrl?.range(of:"_PDF_") != nil {
                
                let agendaID = arraySeprate[1] as! String
                let pdf = arraySeprate[2] as! String
                let pdfUrl = pdf.replacingOccurrences(of: "<br/>", with: "")
                let orderName:String = "Agenda"
                let orderDate = arraySeprate[4] as! String
                let pdfTitle = arraySeprate[3] as! String
                
                self.arrJsonData = [agendaID,pdfUrl,orderName,orderDate,pdfTitle]
                if pdfUrl != ""{
                    self.agendaId = Int(agendaID)!
                    self.checkAndUpdatePDFWithURL(pdfUrl)
                    return true
                }
                return false
            }
            
            
            
            
            if arraySeprate.count > 1 {
                let val = arraySeprate[1] as! String
                
                if val == "nointernet"{
                    
                    let alert = UIAlertController(title: "No internet connection", message: "This application requires a WiFi or cellular network to connect to the server. Please ensure that you have an active connection and/or Airplane mode is turned off.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                //**********        Stop Downloading
                if val == "pause" {
                  self.request?.suspend()
                    
                    let alert = UIAlertController(title: "Alert", message: "Do you want to stop download?", preferredStyle: UIAlertControllerStyle.alert)
                    let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        
                        DownloadHelper.deleteFileFromDocDirName(self.deletefileName)
                        let script = "$('#upProgress').css('display','none');$('.downloadBox').hide();"
                        self.webview.stringByEvaluatingJavaScript(from:script )
                        self.request?.cancel()
                    }
                    
                    let NoAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                        self.request?.resume()
                    }
                    
                    alert.addAction(yesAction)
                    alert.addAction(NoAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    return false
                }
                //**********        ENDED
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
    
    
    
    
    
    //Extra methods
    func checkAndUpdatePDFWithURL(_ pdfUrl:String){
        
        let remoteFileUrl = NSURL.fileURL(withPath: pdfUrl)
        let fileName = remoteFileUrl.lastPathComponent
        let destinationPath = CommonHelper.getApplicationDirectoryPath()
        
        let  filePath = "\(destinationPath)/pdffiles/\(fileName).pdf"
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath){
            
            var fileSize : UInt64
            do {
                
                let attr = try fileManager.attributesOfItem(atPath: openPdfPath)
                fileSize = attr[FileAttributeKey.size] as! UInt64
                
                //if you convert to NSDictionary, you can get file size old way as well.
                let dict = attr as NSDictionary
                fileSize = dict.fileSize()
                
                
                let updatedDate :Date = (attr[FileAttributeKey.modificationDate] as? Date)!
                let last_modified:Date = Date()
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "EEE, d MMM yyyy HH:mm:ss z"
                // let sdate = dateFormat.dateFromString
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                
                
                if updatedDate < last_modified{
                    //Download pdf
                    let url = NSURL (string: pdfUrl)
                    self.downloadFile(pdfUrl,DownloadUrl:url! ,IsReplaced: true)
                }else{
                    let filename = NSURL.fileURL(withPath: pdfUrl).lastPathComponent
                    //Download pdf
                    let url = NSURL (string: pdfUrl)
                    self.downloadFile(pdfUrl,DownloadUrl:url! ,IsReplaced: false)
                }
                
                
            } catch {
                print("Error: \(error)")
            }
        }else{
            let url = NSURL (string: pdfUrl)
            self.downloadFile(pdfUrl,DownloadUrl:url! ,IsReplaced: true)
            
        }
    }
    
    
    
    
    func  downloadFile (_ fileUrl:String ,DownloadUrl:NSURL, IsReplaced : Bool){//},showProgressBar:Bool ,IsReplaced : Bool){
        
        let  isreplaced = IsReplaced
        
        let destinationPath = CommonHelper.getApplicationDirectoryPath()
        let fileName =  URL(fileURLWithPath: fileUrl).deletingPathExtension().lastPathComponent
        self.openPdfPath   = "\(destinationPath)/pdffiles/\(fileName).pdf"
        self.deletefileName = fileName
        
        
        if isreplaced {
            
            DispatchQueue.main.async(execute: { () -> Void  in
                self.activityIndicator.isHidden = true
                self.view.bringSubview(toFront: self.activityIndicator)
                self.activityIndicator.startAnimating()
            })
            
            let destinationpdfFile = "\(destinationPath)/pdffiles/\(fileName).pdf"
            let destfileURL :NSURL = NSURL.fileURL(withPath: destinationpdfFile) as NSURL
            
            
//*********Download .json file
            var error : NSError?
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self.arrJsonData, options: .prettyPrinted)
                let jsonString =  String(bytes: jsonData, encoding: String.Encoding.utf8)
                let jsonFileName:String = fileName
                //writing
                do {
                    // let writePath = "\(destinationPath)/pdffiles/\(filename).json"
                    // let jsonUrl = URL(string: writePath)! as NSURL
                    let documentsUrl: URL = CommonHelper.getDocDirPath()
                    let writePathFileUrl =  documentsUrl.appendingPathComponent("pdffiles/\(fileName).json")
                    try jsonString?.write(to: writePathFileUrl as URL, atomically: false, encoding: .utf8)
                }
                catch {
                    
                    /* error handling here */
                    print("Write  failed:  \(error)")
                    
                }
                
            } catch {
                
                print("JSON serialization failed:  \(error)")
                
            }
//**********ENDED
            
            
            //********** Download Start
           let scriptStr = "$('#upProgress').css('display','inline'); $('.downloadBox').show();$('.DownloadName').text('Agenda')"
            self.webview.stringByEvaluatingJavaScript(from:scriptStr )
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                return (destfileURL as URL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
          self.request =  Alamofire.download("\(DownloadUrl)", to:destination)
                .downloadProgress { (progress) in
                    //self.progressLabel.text = (String)(progress.fractionCompleted)
               
                    let percent  = (String)(progress.fractionCompleted)
                  let scriptStr2 = "updateProgress(\(progress.fractionCompleted),1.0);"
                    //"$('#upProgress').css('display','inline'); $('.downloadBox').show();$('.DownloadName').text('Agenda')"
                    //"$('#upProgress').css('display','inline'); $('.downloadBox').show();$('.DownloadName').text('\(percent)')"
                self.webview.stringByEvaluatingJavaScript(from:scriptStr2 )
                }
                .responseData { (data) in
                    //self.progressLabel.text = "Completed!"
                    DispatchQueue.main.async(execute: { () -> Void  in
                        self.activityIndicator.stopAnimating()
                        self.readPdf(fileName)
                        
                        self.webview.stringByEvaluatingJavaScript(from:"hideProgress();")
                    })
                    print("Successfully Download file \(destfileURL)")
            }
            //********** Download ENDED

            
           /* MNAConnectionHelper.DownloadFiles(url: DownloadUrl as URL, to: fileURL as URL,NewspaperId: self.agendaId, completion: { (status) in
                DispatchQueue.main.async(execute: { () -> Void  in
                    self.activityIndicator.stopAnimating()
                    self.readPdf(fileName)
                })
                print("Successfully Download file \(fileURL)")
            })*/
            
            
            
            
        }else{
            
            DispatchQueue.main.async(execute: { () -> Void  in
                self.activityIndicator.startAnimating()
            })
            
            self.webview.stringByEvaluatingJavaScript(from: "hideProgress();")
            //Getting Annotation List
            let annotationsList:[NSManagedObject] = DBHelper.fetchRequestForAnnotation("Annotations",FilterExpression: "(newspaper_Id == \(self.agendaId))")
            if annotationsList.count > 0 {
                
                CommonHelper.fetchServerAnnotation(self.agendaId, completion: { (status) in
                    
                    
                })
                
            }else{
                CommonHelper.fetchServerAnnotation(self.agendaId, completion: { (status) in
                    
                    
                })
            }
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openPDFWithNewsPaperid(self.openPdfPath, fileName: fileName, NewspaperId: self.agendaId)
        }
        
    }
    
    
    
    //Reading PDF
    func readPdf(_ fileName:String){
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let   filePath = documentsDirectory.appendingPathComponent("pdffiles/\(fileName).pdf")
        let fileManager = FileManager.default
        //getting Annotation List
        
        //ENDED
        if fileManager.fileExists(atPath: filePath){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openPDFWithNewsPaperid(self.openPdfPath, fileName: fileName, NewspaperId: self.agendaId)
            
        }else{
            print("  NOT exist.")
        }
        
    }
    
    func fetchCommentImage(){
        
    }
    
    func updateProgress(_ timer:Timer){
        
        
        
    }
    
}



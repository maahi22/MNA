//
//  DetailViewController.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireSwiftyJSON


class DetailViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var progressBarView: UIProgressView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var PubCode :String = ""
    var PubName :String = ""
    var PubYear :String = ""
    var PubMonth :String = ""
    var uploadId = 0
    var arrJsonData:NSArray = []
    var openPdfPath = ""
    var deletefileName = ""
    var request: Alamofire.Request?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.loadData()
        
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

    func loadData(){
        
        let appPath = CommonHelper.getApplicationDirectoryPath()
        let urlString = "\(appPath)/template/NA_Detail.html"
        
        if  urlString != nil {
            
            activityIndicator.startAnimating()
            
            let page = pageContent()
            let url = NSURL (string: urlString)
            webview.loadHTMLString(page, baseURL: url! as URL)
            
            
           
        
        }
    }
    
    func pageContent() ->String{
        
        let strCatchPath = CommonHelper.getApplicationDirectoryPath()
        let strPath = "\(strCatchPath)/template/NA_Detail.html"
        
        var strContent = try? String(contentsOfFile: strPath, encoding: String.Encoding.utf8)
        strContent = strContent?.replacingOccurrences(of: "remoteUrl", with: "\(RemoteURL)")
        strContent = strContent?.replacingOccurrences(of: "MNAPubCode", with: "\(PubCode)")
        strContent = strContent?.replacingOccurrences(of: "MNAPubName", with: "\(PubName)")
        strContent = strContent?.replacingOccurrences(of: "MNAPubYear", with: "\(PubYear)")
        strContent = strContent?.replacingOccurrences(of: "MNAPubMonth", with: "\(PubMonth)")
        
        return strContent!
    }
    
    
    
    
    @IBAction func backClicked(_ sender: Any) {
        DispatchQueue.main.async(execute: {
           // self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: false)
        })
    }
}


extension  DetailViewController: UIWebViewDelegate{
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        
    }
    
  
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if let urlStr = request.url {
            let str = "\(urlStr)" as String
            var   strUrl =  str.removingPercentEncoding
            let arraySeprate = strUrl?.components(separatedBy: "@@@") as! NSArray
            
            if strUrl?.range(of:"_PDF_") != nil {
                
                let uploadId = arraySeprate[1] as! String
                let orderName = arraySeprate[2] as! String
                let pdfUrl = arraySeprate[4] as! String
                
                let orderDate = arraySeprate[3] as! String
                let pdfTitle = arraySeprate[5] as! String
                
                
                self.arrJsonData = [uploadId,pdfUrl,orderName,orderDate, pdfTitle]
                self.uploadId = Int(uploadId)!
                
                if pdfUrl != ""{
                     let url = NSURL (string: pdfUrl)
                    self.downloadFile(pdfUrl ,DownloadUrl:url!,showProgressBar:true )
                    return true
                }
                
                
            }
            
            
            
            if  arraySeprate.count > 1 {
                
                let str1 = arraySeprate[1] as! String
                
                if str1 == "nointernet" {
                    let alert = UIAlertController(title: "No internet connection", message: "This application requires a WiFi or cellular network to connect to the server. Please ensure that you have an active connection and/or Airplane mode is turned off.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                if str1 == "pause" {
                    self.request?.suspend()
                    
                    let alert = UIAlertController(title: "Alert", message: "Do you want to stop download?", preferredStyle: UIAlertControllerStyle.alert)
                    let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        
                        self.request?.cancel()
                        DownloadHelper.deleteFileFromDocDirName(self.deletefileName)
                        
                        let script = "$('#upProgress').css('display','none');$('.downloadBox').hide();$('.DownloadPercent').text('')"
                        self.webview.stringByEvaluatingJavaScript(from:script )
                        
                    }
                    
                    let NoAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                        self.request?.resume()
                    }
                    alert.addAction(yesAction)
                    alert.addAction(NoAction)
                    self.present(alert, animated: true, completion: nil)
                    return false
                }
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
    func downloadFile (_ fileUrl:String ,DownloadUrl:NSURL, showProgressBar:Bool ){
        
        let destinationPath = CommonHelper.getApplicationDirectoryPath()
        let fileName =  URL(fileURLWithPath: fileUrl).deletingPathExtension().lastPathComponent
        //let fileUrl :NSURL = NSURL.url//fileURL(withPath: fileUrl) as NSURL
        
        self.openPdfPath   = "\(destinationPath)/pdffiles/\(fileName).pdf"
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: openPdfPath){
            
            DispatchQueue.main.async(execute: { () -> Void  in
                self.activityIndicator.startAnimating()
            })
            let path = "\(destinationPath)/pdffiles/\(fileName).pdf"
            let pathUrl :NSURL = NSURL.fileURL(withPath: path) as NSURL
            
            
            //*********Download .json file
           // var error : NSError?
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self.arrJsonData, options: .prettyPrinted)
                let jsonString =  String(bytes: jsonData, encoding: String.Encoding.utf8)
                let jsonFileName:String = fileName
                self.deletefileName = fileName
                
                //writing
                do {
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
            let scriptStr = "$('#upProgress').css('display','inline'); $('.downloadBox').show();$('.DownloadName').text('\(arrJsonData[2])')"
            self.webview.stringByEvaluatingJavaScript(from:scriptStr )
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                return (pathUrl as URL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            self.request =  Alamofire.download("\(DownloadUrl)", to:destination)
                .downloadProgress { (progress) in
                   // let percent  = (String)(progress.fractionCompleted)
                    let scriptStr2 = "updateProgress(\(progress.fractionCompleted),1.0);"
                    self.webview.stringByEvaluatingJavaScript(from:scriptStr2 )
                }
                .responseData { (data) in
                    //self.progressLabel.text = "Completed!"
                    DispatchQueue.main.async(execute: { () -> Void  in
                        self.activityIndicator.stopAnimating()
                        self.readPdf("\(fileName)")
                        
                        self.webview.stringByEvaluatingJavaScript(from:"hideProgress();")
                    })
                    print("Successfully Download file \(pathUrl)")
            }
            //********** Download ENDED
            
            
            
            
            /*MNAConnectionHelper.DownloadFiles(url: DownloadUrl as URL, to: pathUrl as URL,NewspaperId: self.uploadId, completion: { (status) in
                DispatchQueue.main.async(execute: { () -> Void  in
                    self.activityIndicator.stopAnimating()
                    self.readPdf("\(fileName)")
                })
                print("Successfully Download file \(pathUrl)")
            })*/
            
        }else{
            
            //Getting annotation
            let annotationsList:[NSManagedObject] = DBHelper.fetchRequestForAnnotation("Annotations",FilterExpression: "(newspaper_Id == \(self.uploadId))")
            if annotationsList.count > 0 {
                
                CommonHelper.fetchServerAnnotation(self.uploadId, completion: { (status) in
                    
                    
                })
                
            }else{
                CommonHelper.fetchServerAnnotation(self.uploadId, completion: { (status) in
                    
                    
                })
            }
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openPDFWithNewsPaperid(self.openPdfPath, fileName: fileName, NewspaperId: self.uploadId)
        }
        
    }
    
    func readPdf(_ fileName :String){
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let   filePath = documentsDirectory.appendingPathComponent("pdffiles/\(fileName).pdf")
        let fileManager = FileManager.default
        
        
        if fileManager.fileExists(atPath: filePath){
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openPDFWithNewsPaperid(self.openPdfPath, fileName: fileName, NewspaperId: self.uploadId)
        
        }else{
            print("  NOT exist.")
        }
    }
    
    func fetchCommentImage(){
        
    }
    
}

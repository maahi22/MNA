//
//  LibraryVC.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

import UIKit
import Reachability
import CoreData

class LibraryVC: UIViewController {

    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var progressBarView: UIProgressView!

    
    
    var agendaId = 0
    var selectedDate = Date()
    var openPdfPath = ""
    var arrJsonData = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.loadLibarary()
        

    }

    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
       
        
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
    
    func loadLibarary(){
       
        let appPath = CommonHelper.getApplicationDirectoryPath()
        let urlString = "\(appPath)/template/orderpaper.html"
        
        if  urlString != nil {
            
            let page = pageContent()
            activityIndicator.startAnimating()
            let url = NSURL (string: urlString)
           // let requestObj = URLRequest(url: url! as URL)
            webview.loadHTMLString(page, baseURL: url as! URL)
        }
    }
    
    func pageContent() ->String{
       
       // var strContent = ""
        
        
        let fileManger = FileManager.default
        let strCatchPath = CommonHelper.getApplicationDirectoryPath()
        let jsonFilePath = "\(strCatchPath)/pdffiles"
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let dirFiles = try FileManager.default.contentsOfDirectory(atPath: jsonFilePath) as NSArray
            let predicate:NSPredicate = NSPredicate.init(format: "self ENDSWITH '.json'")
            let  jsonFiles :NSArray = dirFiles.filtered(using: predicate) as NSArray
            
            var allFiles:NSMutableArray = NSMutableArray()
            
            for val in jsonFiles {
                let documentsUrl: URL = CommonHelper.getDocDirPath()
                let completeFileName = documentsUrl.appendingPathComponent("pdffiles/\(val)")//"\(CommonHelper.getDocDirPath)/pdffiles/\(val)"
                allFiles.add(completeFileName)
            }
            
            var  jsonFilesString = ""
            if allFiles.count > 0 {
                jsonFilesString = allFiles.componentsJoined(by: "@@@")
            }
            
            let strPath = "\(strCatchPath)/template/NA_Detail.html"
            var strContent = try? String(contentsOfFile: strPath, encoding: String.Encoding.utf8)
            strContent = strContent?.replacingOccurrences(of: "jsonFilesList", with: "\(jsonFilesString)")
            strContent = strContent?.replacingOccurrences(of: "remoteUrl", with: "\(RemoteURL)")
           
            return strContent!
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        return ""
    }
    
    
    
    
    @IBAction func backClicked(_ sender: Any) {
       /* DispatchQueue.main.async(execute: {
            self.dismiss(animated: true, completion: nil)
            
        })*/
        self.navigationController?.popViewController(animated: false)
    }
    
    
    
}


extension  LibraryVC: UIWebViewDelegate{//,PdfReaderDelegate{
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        
    }
    
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        if let urlStr = request.url {
           
            let str = "\(urlStr)" as String
            let   strUrl =  str.removingPercentEncoding
            let arraySeprate:NSArray = strUrl?.components(separatedBy: "@@@") as! NSArray
            
            if strUrl?.range(of:"_PDFREMOVE_") != nil {
                print("exists _PDFREMOVE_  Count-- \(arraySeprate.count)")
                
                if  arraySeprate.count > 0 {
                    
                    let lastComponent:String = arraySeprate[1] as! String
                    let filename = URL(fileURLWithPath: lastComponent).deletingPathExtension().lastPathComponent

                   // let filename = lastComponent.stringbyde
                    
                    let documentsUrl: URL = CommonHelper.getDocDirPath()
                    let pdfPath = documentsUrl.appendingPathComponent("pdffiles/\(filename).pdf")
                    let jsonPath = documentsUrl.appendingPathComponent("pdffiles/\(filename).json") 
               
                
                    self.DelteFile(pdfPath, JsonUrlPath: jsonPath ,  Filename: filename)
                    return false
                    
                   /* let fileManger = FileManager.default
                    do {
                        let pdf:String = pdfPath.path

                        if fileManger.fileExists(atPath: pdf){//isExecutableFile(atPath: pdfPath){
                            //let urlPath:NSURL = NSURL.fileURL(withPathComponents: [pdfPath])
                            try  fileManger.removeItem(atPath: pdf)
                        }
                    
                    let json:String = jsonPath.path
                    
                        if fileManger.fileExists(atPath: json){
                            //let urlPath:NSURL = NSURL.fileURL(withPathComponents: [jsonPath])
                            
                            try  fileManger.removeItem(atPath: json)
                        }
                    } catch {
                        print("Could not clear temp folder: \(error)")
                    }*/
                    
                }
           
            
            
            } else  if  arraySeprate.count > 1 {
                
                
                var ID = 0
                if let ides = (arraySeprate[1] as? NSString)?.intValue {
                    ID = Int(ides)
                }
                
                
                let pdfPath = arraySeprate[2] as! String
                let pdfUrl = pdfPath.replacingOccurrences(of: "<br/>", with: "")

                if pdfUrl != "" {
                    
                    self.agendaId = ID
                    
                    let annotation = DBHelper.fetchRequestForAnnotation("Annotations", FilterExpression: "(newspaper_Id == \(self.agendaId))")
                    
                    if annotation.count  > 0 {
                        
                    }else{
                        CommonHelper.fetchServerAnnotation(self.agendaId, completion: { (status) in
                            
                            
                        })
                        
                        
                        
                    }
                    let url = NSURL (string: pdfUrl)
                    self.checkAndUpdatePDFWithURL(pdfUrl,DownloadUrl:url! )
                    return true
                }
            
            }
            
            
            
            return true
        }
        
        
        
        return true
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        DispatchQueue.main.async(execute: {
            self.activityIndicator.stopAnimating()
        })
        
        self.webview.stringByEvaluatingJavaScript(from: "loadLibrary()")
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        DispatchQueue.main.async(execute: {
            self.activityIndicator.stopAnimating()
            
        })
    }
    
    
    
    
    
    //Extra methods
    
    func DelteFile (_ pdfUrlPath:URL ,JsonUrlPath:URL , Filename:String ){
        
        ////////
        let fileManger = FileManager.default
        do {
            
            //Delete pdf file
            let filePath = pdfUrlPath.path
            if fileManger.fileExists(atPath: filePath){
                try  fileManger.removeItem(atPath: filePath)
            }else{
                print("Not Exist ")
            }
            
            //Delete json file
            let filePath2 = JsonUrlPath.path
            if fileManger.fileExists(atPath: filePath2){
                try  fileManger.removeItem(atPath: filePath2)
            }else{
                print("Not Exist ")
            }
            
        } catch {
            print("Could not clear temp folder: \(error)")
        }
        // self.loadLibarary()
        
        
        
        /////////
        /*let alert = UIAlertController(title: "Delete", message: "Do you want to delete? \(Filename)?", preferredStyle: UIAlertControllerStyle.alert)
        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            
            let fileManger = FileManager.default
            do {
                
//Delete pdf file
                let filePath = pdfUrlPath.path
                if fileManger.fileExists(atPath: filePath){
                    try  fileManger.removeItem(atPath: filePath)
                }else{
                    print("Not Exist ")
                }
                
//Delete json file
                let filePath2 = JsonUrlPath.path
                if fileManger.fileExists(atPath: filePath2){
                    try  fileManger.removeItem(atPath: filePath2)
                }else{
                    print("Not Exist ")
                }
                
            } catch {
                print("Could not clear temp folder: \(error)")
            }
            
        }
        
        let NoAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            self.loadLibarary()
        }
        alert.addAction(yesAction)
        alert.addAction(NoAction)
        self.present(alert, animated: true, completion: nil)
        
        */
    }
    
    
    
  
    
    func  downloadFile (_ fileUrl:String ,DownloadUrl:NSURL){
        
        self.view.bringSubview(toFront: self.activityIndicator)
        self.activityIndicator.startAnimating()
        DispatchQueue.main.async(execute: { () -> Void  in
            self.view.bringSubview(toFront: self.activityIndicator)
            self.activityIndicator.startAnimating()
        })
        
        let destinationPath = CommonHelper.getApplicationDirectoryPath()
        let fileName =  URL(fileURLWithPath: fileUrl).deletingPathExtension().lastPathComponent
        self.openPdfPath   = "\(destinationPath)/pdffiles/\(fileName).pdf"
        
        let path = "\(destinationPath)/pdffiles/\(fileName).pdf"
        let pathUrl :NSURL = NSURL.fileURL(withPath: path) as NSURL
        
        MNAConnectionHelper.DownloadFiles(url: DownloadUrl as URL, to: pathUrl as URL,NewspaperId: self.agendaId, completion: { (status) in
            DispatchQueue.main.async(execute: { () -> Void  in
                DispatchQueue.main.async(execute: { () -> Void  in
                    self.activityIndicator.stopAnimating()
                })
                self.readPdf(fileName)
            })
            print("Successfully Download file \(pathUrl)")
        })
        
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
    
    
    
    
    
    func checkAndUpdatePDFWithURL(_ pdfUrl:String , DownloadUrl:NSURL){
        
        let fileManger = FileManager.default
        let destinationPath = CommonHelper.getApplicationDirectoryPath()
        let fileName =  URL(fileURLWithPath: pdfUrl).deletingPathExtension().lastPathComponent
        self.openPdfPath   = "\(destinationPath)/pdffiles/\(fileName).pdf"
        
        
        let reachability = Reachability()!
        if !reachability.isReachable {
            
            if fileManger.fileExists (atPath:self.openPdfPath){
                let filename2 = NSURL.fileURL(withPath: pdfUrl).lastPathComponent
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.openPDFWithNewsPaperid(self.openPdfPath, fileName: filename2, NewspaperId: self.agendaId)
                
            }
            return
        }
        
        
        
        
        
        

    
        

        var fileSize : UInt64
        
        do {
            //return [FileAttributeKey : Any]
            let attr = try fileManger.attributesOfItem(atPath: openPdfPath)
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
            
            let userId = DefaultDataManager.getUserName()
            

            if updatedDate < last_modified && userId != ""{
                let url = NSURL (string: pdfUrl)
                self.downloadFile(pdfUrl, DownloadUrl:url!)
                //open pdf
               
                
                return
            }else{
               let filename = NSURL.fileURL(withPath: pdfUrl).lastPathComponent
                //open pdf
                
                if fileManger.fileExists (atPath:self.openPdfPath){

                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.openPDFWithNewsPaperid(self.openPdfPath, fileName: filename, NewspaperId: self.agendaId)
                    return
                    
                }else{
                    let url = NSURL (string: pdfUrl)
                    self.downloadFile(pdfUrl, DownloadUrl:url!)
                }
                
               
                
            }
            
        } catch {
            print("Error: \(error)")
        }
        

        
        //Failed
      /*  let filenameN = NSURL.fileURL(withPath: pdfUrl).lastPathComponent
        let destinationPathN = CommonHelper.getApplicationDirectoryPath()
        self.openPdfPath = "\(destinationPathN)/pdffiles/\(filenameN)"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.openPDFWithNewsPaperid(self.openPdfPath, fileName: filenameN, NewspaperId: self.agendaId)
        *///DONE
       // self.openPDFView(self.openPdfPath, fileName: filenameN, NewspaperId: self.agendaId)
    }
    
    
    
   /* func openPDFView(_ filePath :String, fileName:String , NewspaperId:Int){
        let fileMgr = FileManager.default
        
        let documentName = "\(NewspaperId)"
        // let documentUrl = NSURL.fileURL(withPath: filePath)
        
        let path:URL = CommonHelper.getDocumentsDirectory()
        /** Set thumbnails path */
        let thumbnailsPath = path.appendingPathComponent("\(documentName)")
        
        /** Get document from the App Bundle */
        let documentUrl:URL = NSURL.fileURL(withPath: filePath)
        
        /** Instancing the documentManager */
        let documentManager:MFDocumentManager = MFDocumentManager.init(fileUrl: documentUrl as URL!)
        
        var i:Int32 = 0
        var cropBox :CGRect = CGRect(x: 0.0, y: 20.0, width: 0.0, height: 0.0)
        documentManager.getCropbox(&cropBox, andRotation: &i, forPageNumber: 1, withBuffer: false)
        
        if documentManager != nil {
            
            let pdfViewController:PdfReaderViewController = PdfReaderViewController.init(documentManager: documentManager)
           
           // pdfViewController.pdFdelegate = self
            pdfViewController.proofCropBox = cropBox
            pdfViewController.newspaperId = NewspaperId as NSNumber
            pdfViewController.fileURL = (documentUrl as NSURL) as URL!
            pdfViewController.fileName = documentName
            
            /** Set resources folder on the manager */
            documentManager.resourceFolder = thumbnailsPath.path//"\(thumbnailsPath)" //String(contentsOf: thumbnailsPath)
            
            /** Set document id for thumbnail generation */
            pdfViewController.documentId = documentName
            pdfViewController.setMode(UInt(MFDocumentModeOverflow.rawValue))
            
            /** Present the pdf on screen in a modal view */
            self.navigationController?.pushViewController(pdfViewController, animated: false)
            
    }
    
    
    }*/
    
}

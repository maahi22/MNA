//
//  SearchVC.swift
//  MNA
//
//  Created by Maahi on 06/01/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

import UIKit
import CoreData
import  Reachability
import Alamofire
import AlamofireSwiftyJSON



class SearchVC: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var progressBarView: UIProgressView!
    @IBOutlet weak var doneView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var datediv = ""
    var fromDate:Date = Date()
    var toDate:Date = Date()
    var openPdfPath = ""
    var searchKeyword = ""
    var pageno = 0
    var arrJsonData:NSArray = []
    var uploadId = 0
    var deletefileName = ""
    var request: Alamofire.Request?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appPath = CommonHelper.getApplicationDirectoryPath()
        let urlString = "\(appPath)/template/searchgroup.html"
        
        if  urlString != nil {
            activityIndicator.startAnimating()
            let url = NSURL (string: urlString)
            let requestObj = URLRequest(url: url! as URL)
            webview.loadRequest(requestObj)
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
   
    
    
    
    
    
    
    func setDateDiv(_ date:Date){
       
        var isValidDate = false
        if datediv == "FromBox" {
            self.fromDate = date
            isValidDate = true
            
        }else if datediv == "ToBox" {
            self.toDate = date
            isValidDate = true
        
        }
        
        
        if isValidDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let date = dateFormatter.string(from: datePicker.date)

            let setDateDiv = "$('.\(datediv)').html('\(date)');"
            self.webview.stringByEvaluatingJavaScript(from: setDateDiv)
            
            
        }
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
    
        self.setDateDiv(datePicker.date)
        datePicker.isHidden = true
        doneView.isHidden = true
        
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
    
        datePicker.isHidden = true
        doneView.isHidden = true
    
    }
    
    
    
    func showPicker(){
        if datePicker.isHidden {
            datePicker.isHidden = false
            doneView.isHidden = false
            //>>>
            datePicker.datePickerMode = .date
        }
        
    }

    
    
    
    
    
    
    
    
    
    
    
    func openSerachPdf(_ arrUrl:NSArray, UploadId:String){
        
        let pdfUrl = arrUrl[2] as! String
        let orderName = arrUrl[7]
        let orderDate = arrUrl [5]
        let pdfTitle = arrUrl [6]
        self.arrJsonData = [ UploadId, pdfUrl, orderName, orderDate, pdfTitle]
        self.uploadId = Int(UploadId)!
        
        if pdfUrl != "" {
            self.downloadFile(pdfUrl,showProgressBar: true )
        }
        
    }
    
    
    func downloadFile(_ fileUrl:String , showProgressBar:Bool){
        
        let destinationPath = CommonHelper.getApplicationDirectoryPath()
        let filename = URL(fileURLWithPath: self.openPdfPath).lastPathComponent
        let fileNameWithoutExtension = URL(fileURLWithPath: self.openPdfPath).deletingPathExtension().lastPathComponent
        
        let fileMgr = FileManager.default
        self.openPdfPath = "\(destinationPath)/pdffiles/\(filename)"
        if  fileMgr.fileExists(atPath: openPdfPath) {

        self.deletefileName = filename
            
            
        //Check netconncetion
            let reachability = Reachability()!
            if !reachability.isReachable {
                let alert = UIAlertController(title: "Alert", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                DispatchQueue.main.async(execute: {  () -> Void  in
                    self.activityIndicator.stopAnimating()
                })
                return
            }
        //Done
    
            let fileURL:NSURL = URL(string: self.openPdfPath) as! NSURL
            
            //*********Download .json file
            //var error : NSError?
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self.arrJsonData, options: .prettyPrinted)
                let jsonString =  String(bytes: jsonData, encoding: String.Encoding.utf8)
                let jsonFileName:String = fileNameWithoutExtension
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
            //**********ENDED
            
            
            //Download files
            let fileServerPathurl = NSURL.fileURL(withPath: fileUrl)
            let documentsUrl: URL = CommonHelper.getDocDirPath()
            let destinationFileUrl =  documentsUrl.appendingPathComponent("pdffiles/\(uploadId).pdf")
            
            
            
            //********** Download Start
            let scriptStr = "$('#upProgress').css('display','inline'); $('.downloadBox').show();$('.DownloadName').text('Agenda')"
            self.webview.stringByEvaluatingJavaScript(from:scriptStr )
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                return (destinationFileUrl as URL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            self.request =  Alamofire.download("\(fileServerPathurl)", to:destination)
                .downloadProgress { (progress) in
                    
                    let percent  = (String)(progress.fractionCompleted)
                    let scriptStr2 = "updateProgress(\(progress.fractionCompleted),1.0);"
                    self.webview.stringByEvaluatingJavaScript(from:scriptStr2 )
                }
                .responseData { (data) in
                    
                    DispatchQueue.main.async(execute: { () -> Void  in
                        self.activityIndicator.stopAnimating()
                        self.readPdf("\(filename)")
                        
                        self.webview.stringByEvaluatingJavaScript(from:"hideProgress();")
                    })
                    print("Successfully Download file \(destinationFileUrl)")
            }
            //********** Download ENDED
            
            
            
            /*MNAConnectionHelper.DownloadFiles(url: fileServerPathurl as URL, to: destinationFileUrl as URL,NewspaperId: self.uploadId, completion: { (status) in
                DispatchQueue.main.async(execute: { () -> Void  in
                    self.activityIndicator.stopAnimating()
                    self.readPdf()
                })
                print("Successfully Download file \(destinationFileUrl)")
            })*/
        
            
            
            let  displaySearchResult = "$('#upProgress').css('display','inline'); $('.downloadBox').show();$('.DownloadName').text('\(arrJsonData[2])');"
            self.webview.stringByEvaluatingJavaScript(from: displaySearchResult)
            
        }else{
            
            //getting Annotation
            let annotationsList:[NSManagedObject] = DBHelper.fetchRequestForAnnotation("Annotations",FilterExpression: "(newspaper_Id == \(self.uploadId))")
            if annotationsList.count > 0 {
                
                CommonHelper.fetchServerAnnotation(self.uploadId, completion: { (status) in
                    
                    
                })
                
            }else{
                CommonHelper.fetchServerAnnotation(self.uploadId, completion: { (status) in
                    
                    
                })
            }
            
            
            //open pdf
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openPDF(self.openPdfPath, fileName: filename, NewspaperId: self.uploadId, PageNo:self.pageno, searchStr:self.searchKeyword)
        }
        
    }
    
    
    
    
    
    func readPdf(_ fileName:String){
        self.webview.stringByEvaluatingJavaScript(from: "hideProgress();")
   
        let annotations = DBHelper.fetchRequestForEntityForName("Annotations", FilterExpression: "(newspaper_Id == \(self.uploadId))", SortBy: "", Ascending: true, Limit: 0)
        
        if annotations.count > 0 {
            
        }else{
            
        }
    
        //getting annotations
    
        let annotationsList:[NSManagedObject] = DBHelper.fetchRequestForAnnotation("Annotations",FilterExpression: "(newspaper_Id == \(self.uploadId))")
        if annotationsList.count > 0 {
           
            CommonHelper.fetchServerAnnotation(self.uploadId, completion: { (status) in
                
                
            })
            
        }else{
            CommonHelper.fetchServerAnnotation(self.uploadId, completion: { (status) in
                
                
            })
        }
        
        
        
        self.fetchCommentImage(annotations)
        
        let  fileName = URL(fileURLWithPath: self.openPdfPath).deletingPathExtension().lastPathComponent
        //open pdf
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.openPDF(self.openPdfPath, fileName: fileName, NewspaperId: self.uploadId, PageNo:self.pageno, searchStr:self.searchKeyword)
        
        
        
    }
    
    
    
    func fetchCommentImage(_ anotation : [NSManagedObject]){
        
        
        
        
        
        
    }
    
    
    
    
    @IBAction func backClicked(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.dismiss(animated: true, completion: nil)
            //self.navigationController?.popToRootViewController(animated: true)
        })
    }
}


extension  SearchVC: UIWebViewDelegate{
    
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        if let urlStr = request.url {
            let str = "\(urlStr)" as String
            var   strUrl =  str.removingPercentEncoding
            let arrUrl = strUrl?.components(separatedBy: "@@@") as! NSArray
            
            if arrUrl.count > 1{
                
                if (arrUrl[1] as! String) == "FromBox" {
                    datediv = "FromBox"
                    self.showPicker()
                }else  if (arrUrl[1] as! String) == "ToBox" {
                    datediv = "ToBox"
                    self.showPicker()
                }else  if (arrUrl[1] as! String) == "search" {
                    
                    let strURL = (arrUrl[2] as! String)
                    self.getSearchResult(strURL)
                    
                    
                }else  if (arrUrl[1] as! String) == "error" {
                    
                    let alert = UIAlertController(title: "Error", message: "Please type a search term in the search text box", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }else  if (arrUrl[1] as! String) == "openpdf" {
                    let str = (arrUrl[3] as! String)
                 let   uploadId = str.removingPercentEncoding as! String
                    
                    self.pageno = arrUrl[4] as! Int
                    self.openSerachPdf(arrUrl, UploadId: uploadId)
                    
                }
                
                
                
                
                if (arrUrl[1] as! String) == "pause" {

                    self.request?.suspend()
                    let alert = UIAlertController(title: "Alert", message: "Do you want to stop download?", preferredStyle: UIAlertControllerStyle.alert)
                    let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        
                        self.request?.cancel()
                        
                        DownloadHelper.deleteFileFromDocDirName(self.deletefileName)
                        let script = "$('#upProgress').css('display','none');$('.downloadBox').hide();"
                        self.webview.stringByEvaluatingJavaScript(from:script )
                        
                    }
                    
                    let NoAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                        self.request?.resume()
                    }
                    alert.addAction(yesAction)
                    alert.addAction(NoAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                
                return false
                
            }
            
            
           return true
        }
        
        
        
        
        return true
    }
    
    
    
    
    
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    
    
    
    func getSearchResult(_ strURL:String){
        

        //let  url = URL(string:strURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
        
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
       // if let escapedString = strURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
        //do something with escaped string
        
        // let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        //  if  let escapedString = strURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){

        
        
        let fullNameArr = strURL.components(separatedBy: "searchStr")
        
        let urlStr    = fullNameArr[0]
        let searchString = fullNameArr[1]
        
       // var address = "American Tourister, Abids Road, Bogulkunta, Hyderabad, Andhra Pradesh, India"
        let escapedAddress:String = searchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlpath = "\(urlStr)searchStr\(escapedAddress)"

        print("\(urlpath)")
        let url = NSURL (string: urlpath)
        
     //let tourl = NSURL.fileURL(withPath: urlpath)
        
       /* Alamofire.request(.GET, urlpath, parameters: nil, encoding: .URL).responseString(completionHandler: {
            (request: NSURLRequest, response: HTTPURLResponse, responseBody: String?, error: NSError?) -> Void in
            
            // Convert the response to NSData to handle with SwiftyJSON
            if let data = (responseBody as NSString).dataUsingEncoding(NSUTF8StringEncoding) {
                let json = JSON(data: data)
                println(json)
            }
        })*/

        
        /*Alamofire.request(
            URL(string: urlpath)!,
            method: .get,
            parameters: ["": ""])
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    
                    return
                }
                
                guard let value = response.result.value as? [String: Any],
                    let rows = value["rows"] as? [[String: Any]] else {
                        print("Malformed data received from fetchAllRooms service  ")
                        
                        return
                }
                
                print(response)
                
        }*/

        
        
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
           
            guard let data2 = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let newData = data {
                let string = String(data: newData, encoding: String.Encoding.utf8)
                print(string) //JSONSerialization
           
                guard let JSONString = string else {
                    return // or break, continue, throw
                }
            
                print(JSONString.count)
               if (JSONString.count) < 7{
                
                DispatchQueue.main.async(execute: {  () -> Void  in
                    let alert = UIAlertController(title: "Alert", message: "No result found !", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                })
                
                    
                }else{
                
                 DispatchQueue.main.async(execute: {  () -> Void  in
                    let searchUrl:NSArray = strURL.components(separatedBy: "&") as NSArray
                    let str:String = searchUrl[searchUrl.count - 1] as! String
                    self.searchKeyword = (str.components(separatedBy: "=") as NSArray)[1] as! String
                    let path = CommonHelper.getLocalPath()
                    var localPath:String = "\(path)/search.json"
                    
                    do {
                        let documentsUrl: URL = CommonHelper.getDocDirPath()
                        let writePathFileUrl =  documentsUrl.appendingPathComponent("/search.json")
                        try JSONString.write(to:writePathFileUrl, atomically: false, encoding: .utf8)

                        let  displaySearchResult = "search('\(localPath)')"
                        self.webview.stringByEvaluatingJavaScript(from: displaySearchResult)
                    }
                    catch {
                        print("Write  failed:  \(error)")
                    }
                    
                })
                
                }
                
            }
            
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
               // let JSONString = String(data: data, encoding: .utf8)
               // print("responseString = \(String(describing: JSONString))")
           
            guard let JSONString = String(data: data2, encoding: .utf8) else {
                print("String is nil or empty.")
                return // or break, continue, throw
            }

        }
            task.resume()
        
    }
    
    
    
    
    
    
}

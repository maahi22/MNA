//
//  NoticeVC.swift
//  MNA
//
//  Created by Apple on 29/12/17.
//  Copyright © 2017 KTeck. All rights reserved.
//

import UIKit
import AEXML
//import RTWebService
//import Alamofire


class NoticeVC: UIViewController , NSURLConnectionDelegate, XMLParserDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var barbtnRewind: UIBarButtonItem!
    @IBOutlet weak var barbtnForwad: UIBarButtonItem!
    
    var urlString:String = ""
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callLogin()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        self.barbtnRewind.isEnabled = false
        self.barbtnForwad.isEnabled = false
        
        //let urlString = "http://www.govmu.org/English/Pages/default.aspx"//"http://mauritiusassembly.govmu.org/English/Pages/Ipad_Notices.aspx"//"http://mauritiusassembly.gov.mu/English/Pages/Ipad_Notices.aspx"
        
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func refreshView(_ sender: Any) {
        
        self.webview.reload()
        
    }
    
    @IBAction func RewindBackward(_ sender: Any) {
        if self.webview.canGoBack {
            self.webview.goBack()
        }
        
    }
    
    @IBAction func FastForwad(_ sender: Any) {
        if self.webview.canGoForward {
            self.webview.goForward()
        }
    }
    
    @IBAction func cancelCross(_ sender: Any) {
        
        self.webview.stopLoading()
        
    }
    
    
    
  
    
    
    func callLogin(){
    
     /*   let soapPayload = RTPayload(parameter: ["IPAddress" : "202.123.27.106"], parameterEncoding: .defaultUrl)
        let req1 = RTRequest.init(requestUrl: "http://202.123.27.106/mnaservices2/webservice/webservice.php?userLogin",
                                  requestMethod: .get,
                                  header: ["language":"en",
                                           "Content-Type": "text/xml"],
                                  payload: soapPayload)
        
        RTWebService.soapCall(request: req1) { (response) in
            print("actual output ------------------------")
            switch response {
            case .success(let res):
                print("response value")
                print(res)
            case .failure(let error):
                print("error value")
                print(error)
                
            }
        }*/
        
        
        
        
      /*  var lobj_Request = NSMutableURLRequest(URL: NSURL(string: URLString)!)
        var session = URLSession.sharedSession()
        var err: NSError?
        var user = nameTextField.text
        var pass = passTextField.text
        lobj_Request.HTTPMethod = "POST"
        lobj_Request.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
        lobj_Request.addValue(hostString, forHTTPHeaderField: "Host")
        lobj_Request.addValue("application/soap+xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        lobj_Request.addValue(String(soapMessage.characters.count), forHTTPHeaderField: "Content-Length")
        lobj_Request.addValue(SOAP_ACTION, forHTTPHeaderField: "SOAPAction")
        var task = session.dataTaskWithRequest(lobj_Request, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
            
            
            
        })
        task.resume()
        */
        
    }
    
    func calledSoap(){
        
        
       /* let xml = String(format:"<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><Giris xmlns=''><strUserName>%@</strUserName><strPassword>%@</strPassword><TC>%@</TC><Pass>%@</Pass><DeviceID>%@</DeviceID></Giris></soap12:Body></soap12:Envelope>","strusername","strpassword","tc","pass","deviceid")
        let soapMessage = xml
        let msgLength = String(describing: soapMessage.characters.count)
        let url = URL(string: "link")
        var request = URLRequest(url: url!)
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        request.httpMethod = "POST"
        request.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        let session = URLSession.shared
        let task =  session.dataTask(with: request) { (data, resp, error) in
            guard error == nil && data != nil else{
                print("Error--:",error!)
                return
            }
            
            let _ : Void = NSMutableData.initialize()
            print(self.mutableData)
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            self.mutableData.append(data!)
            let dtStrng_giris = self.jsoncreate_giris(xml: dataString! as String)
            
             print("dtStrng_giris \(dtStrng_giris)")
            
            if let jsonlist = self.convertToDictionary_giris (text: dtStrng_giris) as? [AnyObject]{
                for i in jsonlist as! [[String: AnyObject]]{
                    let id = i["ID"] as! String
                     print("IDSS \(id)")
                }
            }
            
        }; task.resume()
        
        
        */
        
        
      /*  let soapMessage = String(format: "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><Login xmlns='http://tempuri.org/'><username>%@</username><password>%@</password></Login></soap:Body></soap:Envelope>","Name","Pass")
        
        let urlString = ""
        let url = NSURL(string: urlString)
        let theRequest = NSMutableURLRequest(url: url! as URL)
        let msgLength = soapMessage.count
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
       /* let connection = NSURLConnection(request: theRequest as URLRequest as URLRequest, delegate: self, startImmediately: true)
        connection!.start()
        
        if ((connection ) != nil) {
            var mutableData : Void = NSMutableData.initialize()
        }*/
        
        let task = URLSession.shared.dataTask(with: theRequest) { Data, response, error in
            
            guard let _: Data = Data, let _: URLResponse = response, error == nil else {
                let dict : [Any] = []
                
                return
            }
            
            let responseStrInISOLatin = String(data: Data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                print("could not convert data to UTF-8 format")
                
                let dict : [Any] = []
                
                return
            }
            do {
                let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                
                print(responseJSONDict)
                
            } catch {
                print(error)
                
            }
            
        }
        task.resume()
        
        */
        
        
        
      /*  // create XML Document
        let soapRequest = AEXMLDocument()
        let attributes = ["xmlns:xsi" : "http://www.w3.org/2001/XMLSchema-instance", "xmlns:xsd" : "http://www.w3.org/2001/XMLSchema"]
        let envelope = soapRequest.addChild(name: "soap:Envelope", attributes: attributes)
        let header = envelope.addChild(name: "soap:Header")
        let body = envelope.addChild(name: "soap:Body")
        header.addChild(name: "m:Trans", value: "234", attributes: ["xmlns:m" : "http://www.w3schools.com/transaction/", "soap:mustUnderstand" : "1"])
        let getStockPrice = body.addChild(name: "m:GetStockPrice")
        getStockPrice.addChild(name: "m:StockName", value: "AAPL")
        
        // prints the same XML structure as original
        print(soapRequest.xml)
        
        
  */
        
        
        
      /*  let soapRequest = AEXMLDocument()
      //  let soapRequest = AEXMLDocument(xml: 1.0, encoding: "utf-8", options: "no")
        let attributes = ["xmlns:xsi" : "http://www.w3.org/2001/XMLSchema-instance", "xmlns:xsd" : "http://www.w3.org/2001/XMLSchema", "xmlns:soap": "http://schemas.xmlsoap.org/soap/envelope/"]
       // let envelope = soapRequest.addChild("soap:Envelope", attributes: attributes)
        let envelope = soapRequest.addChild(name: "soap:Envelope", attributes: attributes)
        let header = envelope.addChild(name: "soap:Header")
        let body = envelope.addChild(name: "soap:Body")
        
        //let body = envelope.addChild("soap:Body")
        let getClasses = body.addChild("GetClasses", attributes: ["xmlns" : "http://clients.mindbodyonline.com/api/0_5"])
        let request = getClasses.addChild("Request")
        //Source Credentials
        let sourceCredentials = request.addChild("SourceCredentials")
        
        sourceCredentials.addChild("SourceName").value = "MarkJacksonCrossfit"
        sourceCredentials.addChild("Password").value = "SA0qUvKP6ndeb8mDdGaZJRFnS7g="
        let siteIds = sourceCredentials.addChild("SiteIDs")
        siteIds.addChild("int").value = "-99"
        
        
        //User Credentials
        let userCredentials = request.addChild("UserCredentials")
        userCredentials.addChild("Username").value = "Siteowner"
        userCredentials.addChild("Password").value = "apitest1234"
        let userSiteIds = userCredentials.addChild("SiteIDs")
        userSiteIds.addChild("int").value = "-99"
        
        //Fields
        let fields = request.addChild("Fields")
        fields.addChild("string").value = "Classes.Resource"
        
        
        //XMLDetail
        request.addChild("XMLDetail").value = "Basic"
        
        //PageSize
        request.addChild("PageSize").value = "10"
        
        //CurrentPageIndex
        request.addChild("CurrentPageIndex").value = "0"
        
        //        println(soapRequest.xmlString)
        let reqData : NSData = soapRequest.xmlString.dataUsingEncoding(NSUTF8StringEncoding)!
        let urlRequest : NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: "https://api.mindbodyonline.com/0_5/ClassService.asmx")! as URL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("api.mindbodyonline.com", forHTTPHeaderField: "Host")
        urlRequest.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("length", forHTTPHeaderField: "Content-Length")
        urlRequest.setValue("http://clients.mindbodyonline.com/api/0_5/GetClasses", forHTTPHeaderField: "SOAPAction")
        urlRequest.httpBody = reqData as Data
        urlRequest.timeoutInterval = 10
        
        print(urlRequest.allHTTPHeaderFields!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest as URLRequest, queue: OperationQueue.mainQueue, completionHandler: { (response, data: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                var resData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var xmlError : NSError?
                if let xmlDoc = AEXMLDocument(xmlData: data!, error: &xmlError){
                    let getClassesResult = xmlDoc.rootElement["soap:Body"]["GetClassesResponse"]["GetClassesResult"]
                    let classes = getClassesResult["Classes"]
                    for child in classes.children {
                        println(child.name)
                    }
                }
            }else{
                println(error)
            }
        })
        
        */
    }
    
    
    
    
    
    
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: URLResponse!) {
        mutableData.length = 0;
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        mutableData.append(data! as Data)
        
    }
    
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        let response = NSString(data: (mutableData as Data), encoding: String.Encoding.utf8.rawValue)
        
        let xmlParser = XMLParser(data: mutableData as Data)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
    }
    
    
    // NSXMLParserDelegate
    
    
    
    func parser(parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject])
        // if use swift languge you must change attributes to [NSObject : AnyObject]
        
    {
        currentElementName = elementName as NSString
        
    }
    
    
    func parser(parser: XMLParser, foundCharacters string: String?) {
      //  if currentElementName == "LoginResult" {
            print(string)
            
       // }
        
        
    }

    
    
    
}






extension  NoticeVC:UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        DispatchQueue.main.async(execute: { [weak self] () -> Void  in
            guard let strongSelf = self else { return }
            
            
            if strongSelf.webview.canGoBack {
                strongSelf.barbtnRewind.isEnabled = true
            }else{
                strongSelf.barbtnRewind.isEnabled = false
            }
            
            if strongSelf.webview.canGoForward {
                strongSelf.barbtnForwad.isEnabled = true
            }else{
                strongSelf.barbtnForwad.isEnabled = false
            }
            
        })
    }
    
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityIndicator.stopAnimating()
    }
    
}

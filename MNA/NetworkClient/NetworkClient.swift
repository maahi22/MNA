//
//  NetworkClient.swift
//  Created by Amit Pant on 27/07/17.
//

import UIKit

public final class NetworkClient{
    
    private struct Keys{
        static let status = "status"
        static let message = "message"
        static let data = "data"
    }
    
    //MARK: Instance Properties
    internal let baseURL:URL
    //internal let fmmsURL:URL
    internal let session = URLSession.shared
    
    //MARK: Class Constructors
    /*public static let shared:NetworkClient = {
        let file = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: file)!
        let urlString = dictionary["Service_URL"] as! String//live_service_url
        let url = URL(string: urlString)!
        return NetworkClient(baseURL: url)
    }()*/
    public static let shared:NetworkClient = {
        let file = Bundle.main.path(forResource: "ServerEnvironments", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: file)!
        let urlString = dictionary["auth_url"] as! String//live_service_url
        let url = URL(string: urlString)!
        return NetworkClient(baseURL: url)
    }()
    
    // MARK: - Class Constructors
    public static let sharedFMMSClient: NetworkClient = {
        let file = Bundle.main.path(forResource: "ServerEnvironments", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: file)!
        let urlString = dictionary["fmms_url"] as! String
        let url = URL(string: urlString)!
        return NetworkClient(baseURL: url)
    }()
    
    public init(baseURL:URL){
        self.baseURL = baseURL
    }
    

    func callAPIWithData(apiname: String,
                         requestType:HttpRequestType,
                         params: [String:Any]?,
                         headers: [String:String]?,
                         success _success: @escaping(Data,HTTPURLResponse)-> Void,
                         failure _failure: @escaping(NetworkError)-> Void) {
        let success: (Data, HTTPURLResponse)-> Void = { data, response in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                _success(data, response)
            }
        }
        
        let failure: (NetworkError) -> Void = { error in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                _failure(error)
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        var request = URLRequest(url: baseURL)
        
        guard let relativeURL = URL(string: apiname, relativeTo: baseURL) else{return}
        request  = URLRequest(url: relativeURL)
        request.setValue("application/json;", forHTTPHeaderField: "Content-Type")
        
        if let headers = headers {
            headers.forEach({ (arg) in
                request.setValue(arg.value, forHTTPHeaderField: arg.key)
            })
        }
        
        if let params = params {
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: params , options: [])
            print("\(params)")
        }
        request.httpMethod = requestType.rawValue
        print(request)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse,
                let data = data
                else{
                    if let error = error{
                        failure(NetworkError(error: error))
                    }
                    else{
                        failure(NetworkError(response: response))
                    }
                    return
            }
                success(data,httpResponse)
            
        }
        task.resume()
    }
    

    func callAPIWithFormData(apiname: String,
                          requestType:HttpRequestType,
                             params: [String:Any]?,
                             success _success: @escaping(Data)-> Void,
                             failure _failure: @escaping(NetworkError)-> Void)
    {
        
        let success: (Data)-> Void = { data in
            
            DispatchQueue.main.async {
                _success(data)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        
        let failure: (NetworkError) -> Void = { error in
            DispatchQueue.main.async {
                _failure(error)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        guard let relativeURL = URL(string: apiname, relativeTo: baseURL) else{return}
        var request  = URLRequest(url: relativeURL)
        
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = requestType.rawValue
        if let params = params {
            var paramString = ""
            for (key, value) in params {
                let escapedKey = key.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                let escapedValue = (value as AnyObject).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                if let escapedKey = escapedKey , let escapedValue = escapedValue{
                  paramString += "\(escapedKey)=\(escapedValue)&"
                }
            }
            request.httpBody = paramString.data(using: .utf8, allowLossyConversion: true)
        }
       
        print(request)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode.isSuccessHTTPCode,
                let data = data
                else{
                    if let error = error{
                        failure(NetworkError(error: error))
                    }
                    else{
                        failure(NetworkError(response: response))
                    }
                    return
            }
            success(data)
        }
        task.resume()
        
    }
    
    
    func uploadImageWithData(apiname: String,
                             params: [String:Any]?,
                             imageData:Data,
                             filename: String,
                             success _success: @escaping(Data)-> Void,
                             failure _failure: @escaping(NetworkError)-> Void)
    {
        
        let success: (Data)-> Void = { data in
            
            DispatchQueue.main.async {
                _success(data)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        
        let failure: (NetworkError) -> Void = { error in
            DispatchQueue.main.async {
                _failure(error)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        guard let relativeURL = URL(string: apiname, relativeTo: baseURL) else{return}
        var request  = URLRequest(url: relativeURL)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBody(parameters: params,
                                      boundary: boundary,
                                      data:imageData,
                                      mimeType: "image/jpg",
                                      filename: filename)
        
        print(request)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode.isSuccessHTTPCode,
                let data = data
                else{
                    if let error = error{
                        failure(NetworkError(error: error))
                    }
                    else{
                        failure(NetworkError(response: response))
                    }
                    return
            }
            success(data)
        }
        task.resume()
        
    }
    
    
    private func createBody(parameters: [String: Any]?,
                            boundary: String,
                            data: Data,
                            mimeType: String,
                            filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        if let parameters = parameters {
            for (key, value) in parameters {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    private func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }

    private func getErrorMessage(code:String)->String{
        switch code {
        case "0000":
            return "SUCCESS"
        case "0001":
            return "Unexpected database error"
        case "0002":
            return "Unexpected request state"
        case "0003":
            return "Bad request such as one or more parameters missing or incorrect"
        case "0004":
            return "Given code or token mismatch"
        case "0005":
            return "Activation code maximum attempt exceed"
        case "0006":
            return "Customer should wait till previous activation code expires"
        case "0007":
            return "Send sms to the given phone failed"
        case "0008":
            return "Internal communication error"
        case "0009":
            return "Wrong password"
        case "0010":
            return "User not found"
        case "0011":
            return "Session does not exist"
        case "0012":
            return "Password should be in hex form"
        case "0013":
            return "Login attempt for un-validated user name"
        case "0014":
            return "Customer already exist"
        case "0015":
            return "Security question or answer is not found"
        case "0016":
            return "Not allowed"
        case "0017":
            return "User account locked, contact admin."
            
        default:
            return "Unknown Error"
        }
    }
    
    func getError(data:Data, completion:(_:String)->Void)   {
        do{
            let serverErrorResponse = try JSONDecoder().decode(ServerErrorResponse.self, from: data)
            let message = getErrorMessage(code: serverErrorResponse.ReasonCode)
            completion(message)
            
        }catch let error{
            completion(error.localizedDescription)
        }
    }
}

enum Result<T> {
    case Success(T)
    case Error(String)
}
enum HttpRequestType:String {
    case POST, GET, PUT
}



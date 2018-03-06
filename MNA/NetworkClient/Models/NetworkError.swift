//
//  NetworkError.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 01/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import Foundation

public enum NetworkError:Error{
    case notAuthenticated
    case forbidden
    case notfound
    case internalServerError
    case networkProblem(Error)
    case unknown(HTTPURLResponse?)
    case userCancelled
    
    public init(error:Error){
        self = .networkProblem(error)
    }
    
    public init(response: URLResponse?){
        guard let response = response as? HTTPURLResponse else {
            self = .unknown(nil)
            return
        }
        switch response.statusCode {
        case NetworkError.notAuthenticated.statusCode: self = .notAuthenticated
        case NetworkError.forbidden.statusCode: self = .forbidden
        case NetworkError.notfound.statusCode: self = .notfound
        default: self = .unknown(response)
        }
    }
    
    public var isAuthError: Bool{
        switch self {
        case .notAuthenticated: return true
        default: return false
        }
    }
    
    public var statusCode: Int{
        switch self {
        case .notAuthenticated: return 401
        case .forbidden: return 403
        case .notfound: return 404
        case .networkProblem(_): return 10001
        case .unknown(_): return 10002
        case .userCancelled: return 99999
        case .internalServerError: return 500
        }
    }
    
    
}

//MARK: - Equatable
extension NetworkError:Equatable{
    public static func ==(lhs: NetworkError, rhs:NetworkError) -> Bool{
        return lhs.statusCode == rhs.statusCode
    }
}

struct ServerErrorResponse:Decodable{
    let ReasonCode : String
    let ReasonDesc:String
    let ErrorType:String
}


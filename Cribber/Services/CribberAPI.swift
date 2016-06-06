//
//  CribberAPI.swift
//  Cribber
//
//  Created by Tim Ross on 20/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import HTTPStatusCodes
import Parse

typealias ResponseBlock = (json: JSON?, error: NSError?) -> Void

class CribberAPI {
    
#if DEBUG
    let baseURLString = "http://localhost:3000/api"
#elseif TEST
    let baseURLString = "http://staging.cribber.com/api"
#else
    let baseURLString = "https://app.cribber.com/api"
#endif
    let apiVersion = 1
    
    let requestManager: Manager
    
    var authenticationManager: AuthenticationManager {
        return AuthenticationManager.sharedInstance
    }
    
    var parse: PFInstallation {
        return PFInstallation.currentInstallation()
    }
    
    var defaultHTTPHeaders: [String: String] {
        var headers = [
            "Accept": "application/vnd.tenfour-v\(apiVersion)+json",
            "Accept-Encoding": "gzip"
        ]
        if let authToken = authenticationManager.authToken {
            headers["Authorization"] = "Token token=\(authToken)"
        }
        if let deviceToken = parse.deviceToken {
            headers["Device"] = "Token token=\(deviceToken)"
        }
        return headers
    }
    
    convenience init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let manager = Alamofire.Manager(configuration: configuration)
        self.init(requestManager: manager)
    }
    
    init(requestManager: Manager) {
        self.requestManager = requestManager
    }
    
    // MARK: Public API methods
    
    func authenticate(phoneNumber: PhoneNumber, response: ResponseBlock) {
        let parameters = [
            "country_code": phoneNumber.prefix, "phone_number": phoneNumber.number
        ]
        performRequest(.POST, path: "/auth", parameters: parameters, response: response)
    }
    
    func verify(phoneNumber: PhoneNumber, code: String, response: ResponseBlock) {
        let parameters: [String: AnyObject] = [
            "country_code": phoneNumber.prefix, "phone_number": phoneNumber.number, "code": code
        ]
        performRequest(.POST, path: "/auth/verify", parameters: parameters, response: response)
    }
    
    func fetchFeed(response: ResponseBlock) {
        performRequest(.GET, path: "/feed", parameters: nil, response: response)
    }
    
    func acceptInvitation(remoteID: NSNumber, response: ResponseBlock) {
        performRequest(.POST, path: "/invitations/\(remoteID)", parameters: nil, response: response)
    }
    
    // MARK: Private helper methods
    
    private func performRequest(method: Alamofire.Method, path: String, parameters: [String: AnyObject]?, response: ResponseBlock) {
        //Log.Debug("Perform request", message: "\(method.rawValue) \(path) {\(parameters?.description)}")
        
        print(defaultHTTPHeaders)
        print((baseURLString + path))
        print(parameters)
        
        requestManager.request(method, (baseURLString + path), parameters: parameters, headers: defaultHTTPHeaders)
            .responseJSON { (_, httpResponse, result) in
                switch result {
                case .Success(let json):
                    let res = self.buildResponse(httpResponse, jsonObject: json, error: nil)
                    response(json: res.json, error: res.error)
                case .Failure(_, let error):
                    let res = self.buildResponse(httpResponse, jsonObject: nil, error: error as NSError?)
                    response(json: res.json, error: res.error)
                }
        }
    }
    
    private func buildResponse(httpResponse: NSHTTPURLResponse?, jsonObject: AnyObject?, error: NSError?) -> (json: JSON?, error: NSError?) {
        if error != nil {
            Log.Error("Network", error: error)
            let errorResponse = genericNetworkError()
            return (json: nil, error: errorResponse)
        } else {
            let json = JSON(jsonObject!)
            let statusCode = HTTPStatusCode(HTTPResponse: httpResponse)!
            if statusCode.isSuccess {
                return (json: json, error: nil)
            } else {
                let errorResponse = ErrorResponse(code: statusCode, json: json)
                checkForUnauthorizedResponse(statusCode)
                return (json: json, error: errorResponse.error)
            }
        }
    }
    
    private func checkForUnauthorizedResponse(statusCode: HTTPStatusCode) {
        if statusCode == HTTPStatusCode.Unauthorized {
            authenticationManager.signout()
        }
    }
    
    private func genericNetworkError() -> NSError? {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("NetworkErrorMessage", comment: "")
        ]
        return NSError(domain: Constants.CribberErrorDomain, code: 1000, userInfo: userInfo)
    }
}

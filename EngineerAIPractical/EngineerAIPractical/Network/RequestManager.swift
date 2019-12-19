//
//  RequestManager.swift
//  EngineerAIPractical
//
//  Created by PCQ111 on 19/12/19.
//  Copyright © 2019 PCQ111. All rights reserved.
//

import Foundation
import Alamofire

let BASEURL : String = "https://hn.algolia.com/api"

struct API {
    
    static func getHits(page: Int) -> String {
        return BASEURL+"/v1/search_by_date?tags=story&page=\(page)"
    }
    
}

struct HttpRequest {
    
    var url : String
    var method : HTTPMethod
    var headers : HTTPHeaders
    var parameters : [String:Any]
    
}

class RequestManager {
    
    static public func requestWithGET(with url:String, completion : @escaping (_ status : Bool, _ resultData : Data, _ message : String) -> Void) {
        let req = self.createBody(url: url, method: .get, parameter: [:], headers: self.basicHeader)
        self.sendRequest(request: req) { (status, responseData, message) in
            completion(status,responseData,message)
        }
    }
    
    static private func createBody(url: String, method: HTTPMethod, parameter: [String:Any], headers: HTTPHeaders) -> HttpRequest {
        let request = HttpRequest(url: url, method: method, headers: headers, parameters: parameter)
        return request
    }
    
    static private var basicHeader : [String:String] {
        let headers = ["Content-Type" : "application/json",
                       "Accept"       :  "application/json"]
        return headers
    }
    
    static private func sendRequest(request: HttpRequest, completion : @escaping (_ status : Bool, _ result : Data, _ message : String) -> Void) {
        Alamofire.request(request.url, method: request.method, parameters: request.parameters, encoding: URLEncoding.default, headers: request.headers).responseData { (response) in
            DispatchQueue.main.async {
                switch response.result{
                case .success:
                    completion(true, response.result.value ?? Data(), "")
                case .failure:
                    completion(false, Data(), response.result.error?.localizedDescription ?? "")
                }
            }
        }
    }
    
}

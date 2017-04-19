//
//  APIRequest.swift
//  APIKitSampler
//
//  Created by 横山 祥平 on 2017/04/19.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit
import APIKit

struct APIRequest: BaseAPI {
    typealias Response = ResponseObject
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/message/1"
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let dictionary = object as? [String: AnyObject],
            let object = ResponseObject() else {
                throw NSError()
        }
        
        return object
    }
}

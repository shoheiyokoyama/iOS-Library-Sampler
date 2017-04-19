//
//  BaseAPI.swift
//  APIKitSampler
//
//  Created by 横山 祥平 on 2017/04/19.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit
import APIKit

protocol BaseAPI: Request {
    
}

extension BaseAPI {
    var baseURL: URL {
        return URL(string: "http://35.187.198.109:8080")!
    }
}

//
//  ResponseObject.swift
//  APIKitSampler
//
//  Created by 横山 祥平 on 2017/04/19.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit
import Himotoki

struct ResponseObject: Decodable {
    let channelID: String
    let imageURL: String
    
    static func decode(_ e: Extractor) throws -> ResponseObject {
        return try ResponseObject(
            channelID: e <| "channel_id",
            imageURL: e <| "image_url"
        )
    }
}

//
//  ViewController.swift
//  APIKitSampler
//
//  Created by 横山 祥平 on 2017/04/12.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit
import APIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = APIRequest()
        Session.send(request) { result in
            switch result {
            case .success(let object):
                print("\(object)")
                
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
}


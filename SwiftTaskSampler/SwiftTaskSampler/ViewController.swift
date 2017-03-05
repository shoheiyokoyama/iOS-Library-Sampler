//
//  ViewController.swift
//  SwiftTaskSampler
//
//  Created by 横山祥平 on 2017/03/04.
//  Copyright © 2017年 Shohei. All rights reserved.
//

import UIKit
import SwiftTask

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        taskTest()
    }

   
    func taskTest() {
        let task = Task<Void, String, Error> { progress, fulfill, reject, configure in
            fulfill("OK")
        }
        .then { string -> Bool in
            print(string)
            return true
        }
        .then { bool -> Int in
            print(bool)
            return 1
        }
        .then { int -> Void in
            print(int)
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            //task.resume()
        }
    }
}


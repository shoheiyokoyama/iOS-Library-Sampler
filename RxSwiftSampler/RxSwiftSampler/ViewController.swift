//
//  ViewController.swift
//  RxSwiftSampler
//
//  Created by Shohei Yokoyama on 2017/04/09.
//  Copyright © 2017年 Shohei. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let disposeBug = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        test()
    }

    
    func test() {
        let number = Variable<Int>(0)
        
        number.asObservable()
            .map { $0 }
            .subscribe(onNext: { numner in
                print(number)
            })
            .addDisposableTo(disposeBug)
    }
}


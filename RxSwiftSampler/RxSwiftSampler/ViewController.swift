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
    
    let numberSubject = PublishSubject<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //obserbeCold()
        //obserbeHot()
        convertHot()
    }
}

//MARK: - Hot and Cold
extension ViewController {
    
    func obserbeCold() {
        
        let observable = numberSubject.asObservable()
            .map { _ in
                print("Change subject")
        }
        
        observable
            .subscribe(onNext: {
                print("subscribe1")
            })
            .addDisposableTo(disposeBug)
        
        observable
            .subscribe(onNext: { number in
                print("subscribe2")
            })
            .addDisposableTo(disposeBug)
        
        // stream count is two
        numberSubject.onNext(1)
        /*
         Change subject
         subscribe1
         Change subject
         subscribe2
         */
        numberSubject.onNext(2)
        /*
         Change subject
         subscribe1
         Change subject
         subscribe2
         */
    }
    
    func obserbeHot() {
        let observable = numberSubject.asObservable()
            .map { _ in
                print("Change subject")
            }
            .shareReplay(1)
        
        observable
            .subscribe(onNext: {
                print("subscribe1")
            })
            .addDisposableTo(disposeBug)
        
        observable
            .subscribe(onNext: { number in
                print("subscribe2")
            })
            .addDisposableTo(disposeBug)
        
        
        // stream count is one
        numberSubject.onNext(1)
        /*
         Change subject
         subscribe1
         subscribe2
         */
        numberSubject.onNext(2)
        /*
         Change subject
         subscribe1
         subscribe2
         */
    }
    
    func convertHot() {
        let observable = numberSubject.asObservable()
            .map { _ in
                print("Change subject")
            }
            .publish()
        
        numberSubject.onNext(1)
        //ConnectableObservableはconnectを呼ぶまで動作しない
        observable.connect()//Hot Observerに変換完了
        
        /*
         ConnectableObservable
         subscribeしているObserverが複数いたとしても、全てのObserver間で共有の計算リソースが割り当てられ、同時に値を通知する
         
         - multicast
         - publish
         - replay(buffersize: )
         - replayAll
         */
        
    }
    
    func observeShare() {
        let observable = numberSubject.asObservable()
            .map { _ in
                print("Change subject")
            }
            .share()//publish + refCount
            //refCount: 最初にsubscribeされた時点で内部的にconnectを呼び出す
        
        observable
            .subscribe(onNext: { number in
                print("subscribe")
            })
            .addDisposableTo(disposeBug)
        
        numberSubject.onNext(1)
        //Change subject
        //subscribe
    }
    
    //TODO: - shareReplay, shareReplayLatestWhileConnected, driver
    func observeShareReplay() {
        let observable = numberSubject.asObservable()
            .observeOn(<#T##scheduler: ImmediateSchedulerType##ImmediateSchedulerType#>)
            .map { _ in
                print("Change subject")
            }
            .shareReplay(1)//publish + refCount + replay
        //obserbeする前に値が発行されていた場合に、1キャッシュしているのでsubscribeした時に値が来るようになる(要検討
        
    }
    
    func observeShareReplayLatestWhileConnected() {
        let observable = numberSubject.asObservable()
            .map { _ in
                print("Change subject")
            }
            .shareReplayLatestWhileConnected()//publish + refCount + replay
        /*
         - same as driver
         - subscribe(connect)中ではないと最後の値が取れない
         */
    }
}



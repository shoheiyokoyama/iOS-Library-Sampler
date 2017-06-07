//
//  ViewController.swift
//  RxSwiftSampler
//
//  Created by Shohei Yokoyama on 2017/04/09.
//  Copyright © 2017年 Shohei. All rights reserved.
//

// http://cocoadocs.org/docsets/RxSwift/2.6.0/RxSwift/

import UIKit
import RxSwift

class ViewController: UIViewController {
    let disposeBug = DisposeBag()
    
    let numberSubject = PublishSubject<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //obserbeCold()
        //obserbeHot()
        //convertHot()
        observeSubject()
    }
}

// MARK: - Subject
// https://medium.com/vinelab-tech/rxswift-subject-types-264c780e2865
// reactive x subject
// https://www.google.co.jp/search?q=reactivex+subject&oq=reactivex+subject&aqs=chrome..69i57j0j69i60.4394j0j4&sourceid=chrome&ie=UTF-8
//http://cocoadocs.org/docsets/RxSwift/2.6.0/RxSwift/Subjects.html

extension ViewController {
    func observeSubject() {
        
        // it emits only new items to its subscriber.
        // element added to the subject before subscription will be not emitted.
        let publishSubject = PublishSubject<String>()
        
        publishSubject.onNext("before subscription: PublishSubject") // not emit
        
        publishSubject
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBug)
        
        publishSubject.onNext("after subscription: PublishSubject")
        
        
        // it will receive the most recent element in the sequence
        let behaviorSubject = BehaviorSubject<String>(value: "Initial value")
        
        // If send element before subscription, behaviorSubject receive this element only when subscription.
        //behaviorSubject.onNext("before subscription: BehaviorSubject")
        
        behaviorSubject
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBug)
        
        behaviorSubject.onNext("after subscription: BehaviorSubject")
        
        let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
        replaySubject.onNext("1 before subscription: ReplaySubject")
        replaySubject.onNext("2 before subscription: ReplaySubject")
        
        replaySubject
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBug)
        
        replaySubject.onNext("after subscription: ReplaySubject")
        
        //TODO: - Variable
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
            .disposed(by: disposeBug)
        
        observable
            .subscribe(onNext: { number in
                print("subscribe2")
            })
            .disposed(by: disposeBug)
        
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
            .disposed(by: disposeBug)
        
        
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
            .disposed(by: disposeBug)
        
        numberSubject.onNext(1)
        //Change subject
        //subscribe
    }
    
    //TODO: - shareReplay, shareReplayLatestWhileConnected, driver
    func observeShareReplay() {
        let observable = numberSubject.asObservable()
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



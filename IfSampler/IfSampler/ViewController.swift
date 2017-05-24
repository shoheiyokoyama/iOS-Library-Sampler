//
//  ViewController.swift
//  IfSampler
//
//  Created by 横山 祥平 on 2017/05/24.
//  Copyright © 2017年 shoheiyokoyama. All rights reserved.
//

import UIKit
import lf
import AVFoundation

final class ViewController: UIViewController {

    @IBOutlet weak var contentview: UIView!
    let rtmpConnection = RTMPConnection()
    lazy var rtmpStream: RTMPStream = RTMPStream(connection: self.rtmpConnection)
    lazy var lfView: GLLFView = GLLFView(frame: self.contentview.frame)
    
    var currentPosition: AVCaptureDevicePosition = .back
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layoutSubviews()
        view.setNeedsLayout()

        rtmpStream.syncOrientation = true
        rtmpStream.captureSettings = [
            "sessionPreset": AVCaptureSessionPreset1280x720,
            "continuousAutofocus": true,
            "continuousExposure": true,
        ]
        rtmpStream.videoSettings = [
            "width": 1280,
            "height": 720,
        ]
        rtmpStream.audioSettings = [
            "sampleRate": 44_100
        ]
        
        lfView.videoGravity = AVLayerVideoGravityResize
        contentview.addSubview(lfView)
        
        //rtmpStream.attachCamera(DeviceUtil.device(withPosition: currentPosition)) { error in
        //    print(error)
        //}
        
        rtmpStream.captureSettings["fps"] = 15
        
        let videoBitrate: CGFloat = 320
        rtmpStream.videoSettings["bitrate"] = videoBitrate * 1024
        let audioBitrate: CGFloat = 64
        rtmpStream.audioSettings["bitrate"] = audioBitrate * 1024
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rtmpStream.removeObserver(self, forKeyPath: "currentFPS")
        rtmpStream.close()
        rtmpStream.dispose()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rtmpStream.attachAudio(AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)) { error in
            print(error)
        }
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: currentPosition)) { error in
            print(error)
        }
        rtmpStream.addObserver(self, forKeyPath: "currentFPS", options: NSKeyValueObservingOptions.new, context: nil)
        lfView.attachStream(rtmpStream)
    }
    
    @IBAction func tap(_ sender: UIButton) {
        if (sender.isSelected) {
            //UIApplication.shared.isIdleTimerDisabled = false
            rtmpConnection.close()
            rtmpConnection.removeEventListener(Event.RTMP_STATUS, selector:#selector(ViewController.rtmpStatusHandler(_:)), observer: self)
            sender.setTitle("●", for: UIControlState())
        } else {
            //UIApplication.shared.isIdleTimerDisabled = true
            rtmpConnection.addEventListener(Event.RTMP_STATUS, selector:#selector(ViewController.rtmpStatusHandler(_:)), observer: self)
            rtmpConnection.connect("rtmp://inst12.tk/hls")
            sender.setTitle("■", for: UIControlState())
        }
        sender.isSelected = !sender.isSelected
    }
    
    func rtmpStatusHandler(_ notification:Notification) {
        let e:Event = Event.from(notification)
        if let data:ASObject = e.data as? ASObject , let code:String = data["code"] as? String, let description: String = data["description"] as? String  {
            print(description)
            switch code {
            case RTMPConnection.Code.connectSuccess.rawValue:
                rtmpStream.publish("test")
            // sharedObject!.connect(rtmpConnection)
            default:
                break
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("\(rtmpStream.currentFPS)")
    }
}


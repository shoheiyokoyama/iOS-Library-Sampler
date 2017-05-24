//
//  SampleViewController.swift
//  IfSampler
//
//  Created by 横山 祥平 on 2017/05/24.
//  Copyright © 2017年 shoheiyokoyama. All rights reserved.
//

import UIKit
import lf
import AVFoundation
import VideoToolbox

class SampleViewController: UIViewController {

    @IBOutlet weak var lfView: GLLFView!
    let rtmpConnection = RTMPConnection()
    lazy var rtmpStream: RTMPStream = RTMPStream(connection: self.rtmpConnection)
    
    @IBAction func tapButton(_ sender: UIButton) {
        if (sender.isSelected) {
            UIApplication.shared.isIdleTimerDisabled = false
            rtmpConnection.close()
            rtmpConnection.removeEventListener(Event.RTMP_STATUS, selector:#selector(ViewController.rtmpStatusHandler(_:)), observer: self)
            sender.setTitle("●", for: UIControlState())
        } else {
            UIApplication.shared.isIdleTimerDisabled = true
            rtmpConnection.addEventListener(Event.RTMP_STATUS, selector:#selector(ViewController.rtmpStatusHandler(_:)), observer: self)
            rtmpConnection.connect("rtmp://inst12.tk/hls")
            sender.setTitle("■", for: UIControlState())
        }
        sender.isSelected = !sender.isSelected
    }
    
    var currentPosition: AVCaptureDevicePosition = .back
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setPreferredSampleRate(44_100)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setMode(AVAudioSessionModeDefault)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
        }
        
        rtmpStream.syncOrientation = true
        rtmpStream.captureSettings = [
            "sessionPreset": AVCaptureSessionPreset1280x720,
            "continuousAutofocus": true,
            "continuousExposure": true,
        ]
        rtmpStream.videoSettings = [
            "width": 1280,
            "height": 720,
            //"profileLevel": kVTProfileLevel_H264_Baseline_5_0,
        ]
        rtmpStream.audioSettings = [
            "sampleRate": 44_100
        ]
        
        rtmpStream.captureSettings["fps"] = 15

        rtmpStream.videoSettings["bitrate"] = RTMPStream.defaultVideoBitrate
        rtmpStream.audioSettings["bitrate"] = RTMPStream.defaultAudioBitrate
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

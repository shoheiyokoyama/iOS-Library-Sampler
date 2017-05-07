//
//  ViewController.swift
//  JTSImageViewControllerSampler
//
//  Created by 横山 祥平 on 2017/04/26.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit
import JTSImageViewController

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tapButton(_ sender: Any) {
        
        let info = JTSImageInfo()
        info.image = imageView.image
        info.referenceView = imageView.superview
        info.referenceRect = imageView.frame
        info.referenceContentMode = imageView.contentMode
        
        let viewer = JTSImageViewController(imageInfo: info, mode: JTSImageViewControllerMode.image, backgroundStyle: JTSImageViewControllerBackgroundOptions.blurred)
        viewer?.show(from: self, transition: JTSImageViewControllerTransition.fromOriginalPosition)
    }
}


//
//  ViewController.swift
//  LACircleChartView
//
//  Created by LakeR on 07/07/2015.
//  Copyright (c) 2015 LakeR. All rights reserved.
//

import UIKit
import LACircleChartView

class ViewController: UIViewController {
    

    @IBOutlet weak var circle1: LACircleView!
    @IBOutlet weak var circle2: LACircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.circle1.drawStroke()
            self.circle2.drawStroke()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func percentChanged(sender: UISlider) {
        self.circle1.progress = CGFloat(sender.value)
        self.circle2.progress = CGFloat(sender.value)
    }
    
    @IBAction func circleOfPercentChanged(sender: UISlider) {
        self.circle1.percentOfCircle = CGFloat(sender.value)
        self.circle2.percentOfCircle = CGFloat(sender.value)
    }

}


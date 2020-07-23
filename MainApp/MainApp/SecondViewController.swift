//
//  SecondViewController.swift
//  MainApp
//
//  Created by Sepehr on 7/23/20.
//  Copyright © 2020 Sepehr. All rights reserved.
//

import Foundation
import Analytics
import UIKit

class SecondViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.shared.trackCustomEvent(SpecificAnalyticsEvent.screenViewed(screenViewed: "SecondViewController"))
    }
}

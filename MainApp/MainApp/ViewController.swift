//
//  ViewController.swift
//  MainApp
//
//  Created by Mohsen on 7/20/20.
//  Copyright © 2020 Mohsen. All rights reserved.
//

import UIKit
import Analytics

class ViewController: UIViewController {
    
    @IBOutlet private weak var stopButton : UIButton!
    @IBOutlet private weak var registerButton : UIButton!
    @IBOutlet private weak var startButton : UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.shared.trackCustomEvent(SpecificAnalyticsEvent.screenViewed(screenViewed: "HomeViewController"))
        stopButton.addTarget(self, action: #selector(goNext(_:)), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerBtn), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(sessionStart(_:)), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(screenTapped(_:)))
        tapGesture.numberOfTouchesRequired = 1
            view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func screenTapped (_ sender : UITapGestureRecognizer){
        let location = sender.location(in: view)
        AnalyticsManager.shared.trackCustomEvent(SpecificAnalyticsEvent.screenTapped(location: Float(location.x)))
    }
    
    @objc private func registerBtn(_ sender: UIButton) {
        AnalyticsManager.shared.trackCustomEvent(SpecificAnalyticsEvent.buttonTapped(buttonSelected: sender.titleLabel?.text ?? ""))
    }
    
    @objc private func goNext(_ sender: UIButton) {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let controller : SecondViewController = sb.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
            let navigationController: UINavigationController? = (UIApplication.shared.windows[0].rootViewController as! UINavigationController)
            navigationController?.pushViewController(controller, animated: true)
            self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func sessionStart(_ sender: UIButton) {
        //AnalyticsManager.shared.appDidLaunch()
    }
}




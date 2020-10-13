//
//  LaunchScreenViewController.swift
//  medicalDiary
//
//  Created by Marko Lazic on 2020-10-12.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Api.shared.checkAvailability() {error, morning, evening in
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let error = error {
                if error == APIError.Unauthorized {
                    let vc: LoginViewController = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.action = .Redirect
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
                let vc: UITabBarController = storyboard.instantiateViewController(withIdentifier: "mainVC") as! UITabBarController
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }
        // Do any additional setup after loading the view.
    }
}

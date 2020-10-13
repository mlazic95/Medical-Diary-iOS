//
//  LoginViewController.swift
//  medicalDiary
//
//  Created by Marko Lazic on 2020-10-08.
//

import UIKit
import AuthenticationServices

enum LoginAction {
    case Dissmiss
    case Redirect
}

class LoginViewController: UIViewController, ASAuthorizationControllerDelegate {

    @IBOutlet weak var loginStackView: UIStackView!
    public var action: LoginAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSignInAppleButton()
    }
    
    func setUpSignInAppleButton() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        authorizationButton.cornerRadius = 10
        //Add button on some view or stack
        self.loginStackView.addArrangedSubview(authorizationButton)
        self.loginStackView.isHidden = false
    }
    

    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
        
            
        let userIdentifier = appleIDCredential.user
        let fullName = appleIDCredential.fullName
        let email = appleIDCredential.email
        Api.shared.login(params: ["appleId": userIdentifier]) { success in
            if success {
                switch self.action {
                case .Dissmiss, .none:
                    self.dismiss(animated: true, completion: nil)
                case .Redirect:
                    let pvc = UIApplication.shared.windows.first!.rootViewController
                    self.dismiss(animated: true) {
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc: UITabBarController = storyboard.instantiateViewController(withIdentifier: "mainVC") as! UITabBarController
                        vc.modalPresentationStyle = .fullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        pvc?.present(vc, animated: false, completion: nil)
                    }
                }
            } else {
                print("Login failed")
            }
        }
        print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    }
}

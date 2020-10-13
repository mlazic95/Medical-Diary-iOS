//
//  SettingsTableViewController.swift
//  medicalDiary
//
//  Created by Marko Lazic on 2020-10-12.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                Api.shared.interceptor.removeToken()
                openLoginView()
            default:
                break
            }
        default:
            break
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    private func openLoginView() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: LoginViewController = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.action = .Dissmiss
        self.present(vc, animated: true, completion: nil)
    }

}

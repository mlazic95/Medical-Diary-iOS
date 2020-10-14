//
//  ViewController.swift
//  MedDiary
//
//  Created by Marko Lazic on 2020-10-05.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var morningButton: UIButton!
    @IBOutlet weak var eveningButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var welcomeLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        welcomeLabel.text = "Welcome " + (UserDataSource.shared.getUser()?.fullName ?? "") + "!"
        refreshView()
    }
    
    func refreshView() {
        activityIndicator.startAnimating()
        self.morningButton.isHidden = true
        self.eveningButton.isHidden = true
        Api.shared.checkAvailability() { (error, morning, evening) in
            self.activityIndicator.stopAnimating()
            if morning {
                self.morningButton.isHidden = false
                self.refreshButton.isHidden = true
                self.label.isHidden = true
            } else if evening {
                self.eveningButton.isHidden = false
                self.refreshButton.isHidden = true
                self.label.isHidden = true
            } else {
                self.morningButton.isHidden = true
                self.eveningButton.isHidden = true
                self.refreshButton.isHidden = false
                self.label.isHidden = false
            }
        }
    }

    @IBAction func startMorningPressed(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: QuestionsViewController = storyboard.instantiateViewController(withIdentifier: "questionsVC") as! QuestionsViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.questionsType = .Morning
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func startEveningPressed(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: QuestionsViewController = storyboard.instantiateViewController(withIdentifier: "questionsVC") as! QuestionsViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.questionsType = .Evening
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        refreshView()
    }
}



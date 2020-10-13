//
//  QuestionsViewController.swift
//  MedDiary
//
//  Created by Marko Lazic on 2020-10-05.
//

import UIKit

class QuestionsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var questionsType: QuestionsType!
    var questions: [Question]!
    var questionIndex = 0
    var input: [String: Any] = [String:Any]()
    var numberInput = Array(0...24)
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var numberPicker: UIPickerView!
    @IBOutlet weak var questionSwitch: UISwitch!
    @IBOutlet weak var spectrumSlider: UISlider!
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questions = Questions.getQuestionList(type: self.questionsType)
        numberPicker.dataSource = self
        numberPicker.delegate = self
        nextQuestion()
    }
    
    func nextQuestion() {
        spectrumSlider.isHidden = true
        textView.isHidden = true
        questionSwitch.isHidden = true
        numberPicker.isHidden = true
        
        if questionIndex == questions.count - 1 {
            nextButton.setTitle("Finish", for: .normal)
        }
        
        let currentQuestion = questions[questionIndex]
        questionTitle.text = currentQuestion.title
        
        switch currentQuestion.inputType {
        case .Boolean:
            questionSwitch.isHidden = false
        case .Spectral:
            spectrumSlider.isHidden = false
        case.Textual:
            textView.isHidden = false
        case.Numerical:
            numberPicker.isHidden = false
        }
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        let currentQuestion = questions[questionIndex]
        switch currentQuestion.inputType {
        case .Boolean:
            input[currentQuestion.key] = questionSwitch.isOn
            questionSwitch.setOn(false, animated: false)
        case .Spectral:
            input[currentQuestion.key] = Int(spectrumSlider.value)
            spectrumSlider.setValue(0, animated: false)
        case.Textual:
            input[currentQuestion.key] = textView.text
        case.Numerical:
            input[currentQuestion.key] = Int(numberPicker.selectedRow(inComponent: 0))
        }
        
        questionIndex+=1
        if questionIndex == questions.count {
            Api.shared.postInput(params: self.input, type: self.questionsType){ (success) in
                self.dismiss(animated: true) {
                    if success {
                        Util.showPopup(title: "Input successfully sent!", desc: "Thanks for your coorperation", textColor: .black, color1: .green, color2: .cyan)
                    } else {
                        Util.showPopup(title: "Something went wrong!", desc: "Please try again", textColor: .white, color1: .red, color2: .purple)
                    }
                }
            }
        } else {
            nextQuestion()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberInput.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberInput[row])"
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if questionIndex == 0 {
            self.dismiss(animated: true, completion: nil)
        } else {
            questionIndex -= 1
            nextQuestion()
        }
        
    }
    
}

extension QuestionsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

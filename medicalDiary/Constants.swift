//
//  Constants.swift
//  MedDiary
//
//  Created by Marko Lazic on 2020-10-05.
//

import Foundation
import UIKit


struct Questions {
    static let q1 = Question(title: "Sleep duration", inputType: .Numerical, key: "sleepDuration")
    static let q2 = Question(title: "Sleep quality", inputType: .Spectral, key: "sleepQuality")
    static let q3 = Question(title: "Overall feeling", inputType: .Spectral, key: "overallFeeling")
    static let q4 = Question(title: "Stress level", inputType: .Spectral, key: "stressLevel")
    static let q5 = Question(title: "Work intensity", inputType: .Spectral, key: "workIntensity")
    static let q6 = Question(title: "Training intensity", inputType: .Spectral, key: "trainingIntensity")
    static let q7 = Question(title: "Sick", inputType: .Boolean, key: "sick")
    static let q8 = Question(title: "Strange syndrome", inputType: .Boolean, key: "strangeSyndrome")
    static let q9 = Question(title: "Anxiety level", inputType: .Spectral, key: "anxietyLevel")
    static let q10 = Question(title: "Notes", inputType: .Textual, key: "notes")
    
    static let morningQuestions: [Question] = [q1, q2, q3, q4, q7, q8, q10]
    static let eveningQuestions: [Question] = [q3, q4, q5, q6, q7, q8, q9, q10]
    
    
    static func getQuestionList(type: QuestionsType) -> [Question] {
        if type == .Evening {
            return eveningQuestions
        } else {
            return morningQuestions
        }
    }
}

enum Data {
    case OverallFeeling
    case SleepQuality
    case SleepDuration
    case TrainingIntensity
    case WorkIntensity
    case StressLevel
    case AnxietyLevel
}

enum Period {
    case Day
    case Month
    case Year
}

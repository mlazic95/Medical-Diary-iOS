//
//  EveningInput.swift
//  medicalDiary
//
//  Created by Marko Lazic on 2020-10-07.
//

import Foundation

struct EveningInput: Codable {
    let overallFeeling: Int
    let strangeSyndrome: Bool
    let sick: Bool
    let notes: String
    let date: String
    let trainingIntensity: Int
    let workIntensity: Int
    let stressLevel: Int
    let anxietyLevel: Int
}

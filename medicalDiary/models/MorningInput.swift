//
//  MorningInput.swift
//  medicalDiary
//
//  Created by Marko Lazic on 2020-10-07.
//

import Foundation


struct MorningInput: Codable {
    let overallFeeling: Int
    let strangeSyndrome: Bool
    let sleepQuality: Int
    let sleepDuration: Int
    let stressLevel: Int
    let sick: Bool
    let notes: String
    let date: String
}

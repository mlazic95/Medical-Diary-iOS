//
//  Questions.swift
//  MedDiary
//
//  Created by Marko Lazic on 2020-10-05.
//

import Foundation

enum InputType {
    case Numerical
    case Spectral
    case Textual
    case Boolean
}

enum QuestionsType {
    case Morning
    case Evening
}

struct Question {
    let title: String
    let inputType: InputType
    let key: String
}

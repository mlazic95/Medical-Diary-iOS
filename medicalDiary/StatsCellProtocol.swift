//
//  StatsCellProtocol.swift
//  medicalDiary
//
//  Created by Marko Lazic on 2020-10-07.
//

import Foundation

protocol StatsCellDelegate {
    func cellPressed(dataType: Data, label: String)
}

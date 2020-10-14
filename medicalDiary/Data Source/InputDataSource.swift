//
//  InputDataSource.swift
//  medicalDiary
//
//  Created by Marko Lazic on 2020-10-07.
//

import Foundation


class InputDataSource {
    
    static let shared = InputDataSource()

    private var morningInputs: [MorningInput] = [MorningInput]()
    private var eveningInputs: [EveningInput] = [EveningInput]()
    private var isFetching =  false
    
    private init() {}
    
    public func fetchInput(completion: @escaping () -> Void ) {
        if isFetching {
            completion()
            return
        }
        self.isFetching = true
        Api.shared.getAllInput() { (morning, evening) in
            self.morningInputs = morning
            self.eveningInputs = evening
            self.isFetching = false
            completion()
        }
    }
    
    public func getMorningInputs() -> [MorningInput] {
        return morningInputs
    }
    
    public func getEveningInputs() -> [EveningInput] {
        return eveningInputs
    }
    
    public func getLastMorningInput() -> MorningInput? {
        return morningInputs.last
    }
}

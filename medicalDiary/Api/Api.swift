//
//  Api.swift
//  MedDiary
//
//  Created by Marko Lazic on 2020-10-05.
//

import Foundation
import Alamofire


struct Api {
    
    public static let shared = Api()
    public let interceptor: RequestInterceptor

    
    private init() {
        self.interceptor = RequestInterceptor()
    }
    
    func postInput(params: [String: Any], type: QuestionsType, completion: @escaping (Bool) -> Void) {
        switch type {
        case .Evening:
            postInput(url: ProcessInfo.processInfo.environment["base_url"]! + "eveningInput", params: params, completion: completion)
        case .Morning:
            postInput(url: ProcessInfo.processInfo.environment["base_url"]! + "morningInput", params: params, completion: completion)
        }
    }
    
    func checkAvailability(completion: @escaping (APIError?, Bool, Bool) -> Void) {
        AF.request(ProcessInfo.processInfo.environment["base_url"]! + "checkAvailability", method: .get, encoding: JSONEncoding.default, headers: .default, interceptor: self.interceptor).responseJSON { (response) in
            switch response.result {
            case .success(_):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:AnyObject]
                    completion(nil, json["morning"] as! Bool,json["evening"] as! Bool)
                }
                catch {
                    completion(APIError.Default, false, false)
                }
            case .failure(_):
                if response.response?.statusCode == 403 {
                    completion(APIError.Unauthorized, false, false)
                } else {
                    completion(APIError.Default, false, false)
                }
            }
        }
    }
    
    func getMorningInput(completion: @escaping ([MorningInput])-> Void) {
        let url = ProcessInfo.processInfo.environment["base_url"]! + "morningInput"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: .default, interceptor: self.interceptor).responseJSON { (response) in
            switch response.result {
            case .success(_):
                do {
                    let dict = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [[String: Any]]
                    let json = try JSONSerialization.data(withJSONObject: dict)
                    let inputs = try JSONDecoder().decode([MorningInput].self, from: json)
                    completion(inputs)
                }
                catch let error {
                    completion([])
                    print(error.localizedDescription)
                }
            case .failure(let error):
                completion([])
                print(error)
            }
        }
    }
    
    func getEveningInput(completion: @escaping ([EveningInput])-> Void) {
        let url = ProcessInfo.processInfo.environment["base_url"]! + "eveningInput"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: .default, interceptor: self.interceptor).responseJSON { (response) in
            switch response.result {
            case .success(_):
                do {
                    let dict = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [[String: Any]]
                    let json = try JSONSerialization.data(withJSONObject: dict)
                    let inputs = try JSONDecoder().decode([EveningInput].self, from: json)
                    completion(inputs)
                }
                catch let error {
                    completion([])
                    print(error.localizedDescription)
                }
            case .failure(let error):
                completion([])
                print(error)
            }
        }
    }
    
    func getAllInput(completion: @escaping ([MorningInput], [EveningInput])-> Void) {
        let url = ProcessInfo.processInfo.environment["base_url"]! + "allInput"
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: .default, interceptor: self.interceptor).responseJSON { (response) in
            switch response.result {
            case .success(_):
                do {
                    let dict = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String: [[String: Any]]]
                    let eveningDict = dict["eveningInputs"]!
                    let morningDict = dict["morningInputs"]!
                    let eveningJson = try JSONSerialization.data(withJSONObject: eveningDict)
                    let eveningInputs = try JSONDecoder().decode([EveningInput].self, from: eveningJson)
                    let morningJson = try JSONSerialization.data(withJSONObject: morningDict)
                    let morningInputs = try JSONDecoder().decode([MorningInput].self, from: morningJson)
                    completion(morningInputs, eveningInputs)
                }
                catch let error {
                    completion([], [])
                    print(error.localizedDescription)
                }
            case .failure(let error):
                completion([], [])
                print(error)
            }
        }
    }
    
    func login(params: [String: Any], completion: @escaping (Bool)-> Void) {
        AF.request(ProcessInfo.processInfo.environment["base_url"]! + "login", method: .post, parameters: params, encoding: JSONEncoding.default, headers: .default).responseJSON { (response) in
            switch response.result {
            case .success(_):
                do {
                    let dict = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String: String]
                    if let jwt = dict["jwt"] {
                        self.interceptor.setAccessToken(token: jwt)
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                } catch {
                    completion(false)
                }
            case .failure(let error):
                completion(false)
                print(error.localizedDescription)
            }
        }
    }
    
    func refreshToken(completion: @escaping (Bool)-> Void) {
        AF.request(ProcessInfo.processInfo.environment["base_url"]! + "refresh", method: .post, encoding: JSONEncoding.default, headers: .default, interceptor: self.interceptor).responseJSON { (response) in
            switch response.result {
            case .success(_):
                do {
                    let dict = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String: String]
                    if let jwt = dict["jwt"] {
                        self.interceptor.setAccessToken(token: jwt)
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                } catch {
                    completion(false)
                }
            case .failure(let error):
                completion(false)
                print(error.localizedDescription)
            }
        }
    }
    
    private func postInput(url: String, params: [String: Any], completion: @escaping (Bool)-> Void) {
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: .default, interceptor: self.interceptor).responseJSON { (response) in
            switch response.result {
            case .success(_):
                completion(true)
            case .failure(let error):
                completion(false)
                print(error)
            }
        }
    }
}

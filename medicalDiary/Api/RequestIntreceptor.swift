//
//  Session.swift
//  medicalDiary
//
//  Created by Marko Lazic on 2020-10-09.
//

import Foundation
import Alamofire
import KeychainAccess
import JWTDecode

final class RequestInterceptor: Alamofire.RequestInterceptor {

    typealias JWT = String
    private let keychain = Keychain(service: "com.self.medDiary")
    private var accessToken: JWT? {
        set {
            keychain["jwt"] = newValue
        }
        get {
            let jwt = keychain["jwt"]
            return jwt
        }
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        if let accessToken = self.accessToken {
            if !Util.urlIsEnding(url: urlRequest.description, ending: "refresh") {
                Api.shared.refreshToken() { success in}
            }
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        return completion(.doNotRetryWithError(error))
    }
    
    func getAccessToken() -> JWT? {
        return self.accessToken
    }
    
    func setAccessToken(token: JWT) {
        self.accessToken = token
    }
    
    func removeToken(){
        self.accessToken = nil
    }
}

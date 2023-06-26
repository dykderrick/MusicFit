//
//  NetworkManager.swift
//  MusicFit
//
//  Created by Derrick Ding on 6/25/23.
//

import Foundation
import Alamofire

actor NetworkManager: GlobalActor {
    static let shared = NetworkManager()
    
    private init() { }
    
    private let maxWaitTime = 15.0
    
    func request(baseURL: String, route: String, method: HTTPMethod , parameters: [String: Any]?, headers: HTTPHeaders) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                baseURL + route,
                method: method,
                parameters: parameters,
                encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                headers: headers,
                requestModifier: { $0.timeoutInterval = self.maxWaitTime }
            )
            .responseData { response in
                switch(response.result) {
                case let .success(data):
                    continuation.resume(returning: data)
                    
                case let .failure(error):
                    continuation.resume(throwing: self.handleError(of: error))
                    
                }
            }
        }
    }
    
    private func handleError(of error: AFError) -> Error {
        if let underlyingError = error.underlyingError {
            let nserror = underlyingError as NSError
            let code = nserror.code
            if code == NSURLErrorNotConnectedToInternet ||
                code == NSURLErrorTimedOut ||
                code == NSURLErrorInternationalRoamingOff ||
                code == NSURLErrorDataNotAllowed ||
                code == NSURLErrorCannotFindHost ||
                code == NSURLErrorCannotConnectToHost ||
                code == NSURLErrorNetworkConnectionLost
            {
                var userInfo = nserror.userInfo
                userInfo[NSLocalizedDescriptionKey] = "Unable to connect to the server"
                let currentError = NSError(
                    domain: nserror.domain,
                    code: code,
                    userInfo: userInfo
                )
                return currentError
            }
        }
        return error
    }
}

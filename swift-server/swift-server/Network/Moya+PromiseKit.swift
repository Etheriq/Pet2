//
//  Moya+PromiseKit.swift
//  swift-server
//
//  Created by Yuriy T on 08.03.2018.
//  Copyright © 2018 Yuriy T. All rights reserved.
//

import Moya
import PromiseKit

extension MoyaProvider {
    func request(_ target: Target, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none) -> Promise<Response> {
        
        return Promise { seal in
            request(target, callbackQueue: callbackQueue, progress: progress) { result in
                guard let response = result.value else {
                    return seal.reject(NetworkErrors.ResponseUnvailable)
                }
                
                switch response.statusCode {
                case 200...399:
                    seal.fulfill(response)
                case 400:
                    let errorResponse = try? response.map(ErrorResponse.self, atKeyPath: "error")
                    seal.reject(NetworkErrors.NetworkError400(withMessage: errorResponse?.message, andResponseError: errorResponse))
                case 401:
                    let errorResponse = try? response.map(ErrorResponse.self, atKeyPath: "error")
                    seal.reject(NetworkErrors.NetworkError401(withMessage: errorResponse?.message, andResponseError: errorResponse))
                case 403:
                    let errorResponse = try? response.map(ErrorResponse.self, atKeyPath: "error")
                    seal.reject(NetworkErrors.NetworkError403(withMessage: errorResponse?.message, andResponseError: errorResponse))
                case 404:
                    let errorResponse = try? response.map(ErrorResponse.self, atKeyPath: "error")
                    seal.reject(NetworkErrors.NetworkError404(withMessage: errorResponse?.message, andResponseError: errorResponse))
                case 405...499:
                    let errorResponse = try? response.map(ErrorResponse.self, atKeyPath: "error")
                    seal.reject(NetworkErrors.NetworkError(withCode: errorResponse?.statusCode, andWithMessage: errorResponse?.message, andResponseError: errorResponse))
                case 500...599:
                    let errorResponse = try? response.map(ErrorResponse.self, atKeyPath: "error")
                    seal.reject(NetworkErrors.NetworkError500(withMessage: errorResponse?.message, andResponseError: errorResponse))
                default:
                    seal.reject(NetworkErrors.ResponseUnvailable)
                }
                
//                switch result {
//                case .success(let val):
//                    seal.fulfill(val)
//                case .failure(let error):
//
//                    let statusCode = error.response?.statusCode
//                    let message = error.errorDescription
//                    seal.reject(NetworkErrors.NetworkNotMappableError(withCode: statusCode, andWithMessage: message))
//                }
            }
        }
    }
}

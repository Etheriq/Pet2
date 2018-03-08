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
//        let pending = Promise<Response>.pending()
//        request(target, callbackQueue: callbackQueue, progress: progress) { result in
//            switch result {
//            case .success(let val):
//                pending.resolver.fulfill(val)
//            case .failure(let error):
//                pending.resolver.reject(error)
//            }
//        }
//
//        return pending.promise
        
        return Promise { seal in
            request(target, callbackQueue: callbackQueue, progress: progress) { result in
                switch result {
                case .success(let val):
                    seal.fulfill(val)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}

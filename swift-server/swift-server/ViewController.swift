//
//  ViewController.swift
//  swift-server
//
//  Created by Yuriy T on 07.03.2018.
//  Copyright © 2018 Yuriy T. All rights reserved.
//

import UIKit
import Moya
import PromiseKit

class ViewController: UIViewController {

    private func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            
            return prettyData
        } catch {
            return data // fallback to original data if it can't be serialized.
        }
    }
    
    lazy var network: MoyaProvider<Network> = MoyaProvider<Network>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Actions
    @IBAction func getUserAction(_ sender: UIButton) {
        network.request(.getUser)
            .then { response -> Promise<User> in
                let user = try? response.map(User.self, atKeyPath: "user")
                
                return Promise { seal in
                    guard let user = user else {
                        return seal.reject(NetworkErrors.MappingError)
                    }
                    seal.fulfill(user)
                }
            }
            .done { user in
                // save user
                debugPrint("Received user ID is \(user.id)")
            }
            .catch { error in
                debugPrint("error")
        }
    }
    
    @IBAction func updateUser(_ sender: UIButton) {
        
        let user = User()
        user.id = 432
        user.name = "Yuriy"
        user.email = "qwe@wq.ew"
        
        network.request(.updateUser(user: user))
            .then { response -> Promise<User> in
                let user = try? response.map(User.self, atKeyPath: "user")
                
                return Promise { seal in
                    guard let user = user else {
                        return seal.reject(NetworkErrors.MappingError)
                    }
                    seal.fulfill(user)
                }
            }.done { user in
                // save user
                debugPrint("Received user ID is \(user.id)")
            }.catch { error in
                debugPrint("error")
        }
    }
    
    @IBAction func getDreamsForPageAction(_ sender: UIButton) {
        
        network.request(.getDreamsFromPage(page: 2, limit: 14))
            .then { response -> Promise<[Dream]> in
                let dreams = try? response.map([Dream].self, atKeyPath: "dreams")
                
                return Promise { seal in
                    guard let dreams = dreams else {
                        return seal.reject(NetworkErrors.MappingError)
                    }
                    seal.fulfill(dreams)
                }
            }.done { dreams in
                // do something with [Dream]
                
                debugPrint("Received \(dreams.count) dreams")
            }.catch { error in
                guard let networkError = error as? NetworkErrors else {
                    debugPrint("unknown error")
                    return
                }
                self.handleError(error: networkError)
        }
        
    }
    
    @IBAction func createDream(_ sender: UIButton) {
        
        let dream = Dream()
        dream.name = "createDream"
        let wh1 = WorkHelp()
        wh1.name = "wh1"
        let wh2 = WorkHelp()
        wh2.name = "wh2"
        dream.workHelps.append(wh1)
        dream.workHelps.append(wh2)
        let location = Location()
        location.state = "zxc"
        location.city = "lkj"
        dream.location = location
        
        network.request(.createDream(dream: dream))
            .then { response -> Promise<Dream> in
                let responseDream = try? response.map(Dream.self, atKeyPath: "dream")
                
                return Promise { seal in
                    guard let dream = responseDream else {
                        return seal.reject(NetworkErrors.MappingError)
                    }
                    seal.fulfill(dream)
                }
            }
            .done { dream in
                debugPrint("created Dream with ID: \(dream.id)")
            }
            .catch {error in
                guard let networkError = error as? NetworkErrors else {
                    debugPrint("unknown error")
                    return
                }
                self.handleError(error: networkError)
        }
    }
    
    @IBAction func checkErrorsAction(_ sender: UIButton) {
        
        network.request(.checkError)
            .catch { error in
                guard let networkError = error as? NetworkErrors else {
                    debugPrint("unknown error")
                    return
                }
                self.handleError(error: networkError)
        }
        
    }
    
    private func handleError(error: NetworkErrors) {
        switch error {
        case .MappingError:
            debugPrint("mapping error")
        case .ResponseUnvailable:
            debugPrint("response error")
        case .NetworkError(let statusCode, let message):
            debugPrint("network error code: \(statusCode ?? -1) message: \(message ?? "empty")")
        case .NetworkError400(let message):
            debugPrint("network error 400 message: \(message ?? "empty")")
        case .NetworkError401(let message):
            debugPrint("network error 401 message: \(message ?? "empty")")
        case .NetworkError403(let message):
            debugPrint("network error 403 message: \(message ?? "empty")")
        case .NetworkError404(let message):
            debugPrint("network error 404 message: \(message ?? "empty")")
        case .NetworkError500(let message):
            debugPrint("network error 500 message: \(message ?? "empty")")
        }
    }
}

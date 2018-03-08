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
            }
            .done { user in
                // save user
                debugPrint("Received user ID is \(user.id)")
            }
            .catch { error in
                debugPrint("error")
        }
    }
    
    @IBAction func getDreamsForPageAction(_ sender: UIButton) {
    }
    
    @IBAction func createDream(_ sender: UIButton) {
    }
}

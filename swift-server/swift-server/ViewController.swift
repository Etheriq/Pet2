//
//  ViewController.swift
//  swift-server
//
//  Created by Yuriy T on 07.03.2018.
//  Copyright © 2018 Yuriy T. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {

    lazy var network: MoyaProvider<Network> = MoyaProvider<Network>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Actions
    @IBAction func getUserAction(_ sender: UIButton) {
        
        
//        network.request(.getUser).then { response -> User? in
//                debugPrint("dsa")
//
//            guard let res = response as? Response else { return nil }
//
//            let user = try? res.map(User.self, atKeyPath: "user")
//
//            return user
//
//            }.catch {
//                debugPrint("error")
//        }
        
        
        network.request(.getUser) { result in
            if case let .success(response) = result {
                let user = try? response.map(User.self, atKeyPath: "user")
                
//                debugPrint("user = \(user?.description ?? "map failed")")
            }
        }
        
        
    }
    
    @IBAction func updateUser(_ sender: UIButton) {
        
        let user = User()
        user.id = 432
        user.name = "Yuriy"
        user.email = "qwe@wq.ew"
        
        network.request(.updateUser(user: user)) { result in
            if case let .success(response) = result {
                let user = try? response.map(User.self, atKeyPath: "user")
                
//                debugPrint("user = \(user?.description ?? "map failed")")
            }
        }
    }
    
    @IBAction func getDreamsForPageAction(_ sender: Any) {
    }
    
    @IBAction func createDream(_ sender: UIButton) {
    }
}

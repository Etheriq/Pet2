//
//  Moya+BaseUrl.swift
//  swift-server
//
//  Created by Yuriy T on 08.03.2018.
//  Copyright © 2018 Yuriy T. All rights reserved.
//

import Moya

extension TargetType {
    public var baseURL: URL {
        return URL(string: "http://swift.local/app_dev.php/api")!
    }
}

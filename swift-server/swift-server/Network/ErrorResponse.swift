//
//  ErrorResponse.swift
//  swift-server
//
//  Created by Yuriy T on 10.03.2018.
//  Copyright © 2018 Yuriy T. All rights reserved.
//

import Foundation

final class ErrorResponse: Decodable {
    var statusCode: Int?
    var message: String?
    
    func description() -> String {
        return "StatusCode: \(statusCode ?? 0) Message: \(message ?? "unknow")\n"
    }
    
    enum ReceivedKeys: String, CodingKey {
        case message
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: ReceivedKeys.self)
        
        message = try? values.decode(String.self, forKey: .message)
    }
}

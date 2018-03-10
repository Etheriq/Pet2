//
//  WorkHelp.swift
//  swift-server
//
//  Created by Yuriy T on 07.03.2018.
//  Copyright © 2018 Yuriy T. All rights reserved.
//

import RealmSwift

final class WorkHelp: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    enum SendedKeys: String, CodingKey {
        case name
    }
    
    enum ReceivedKeys: String, CodingKey {
        case id
        case name
    }
}

// from object to JSON
extension WorkHelp: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SendedKeys.self)
        
        try container.encode(name, forKey: .name)
    }
}

// from JSON to object
extension WorkHelp: Decodable {
    convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: ReceivedKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
    }
}

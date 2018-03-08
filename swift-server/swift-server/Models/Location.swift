//
//  Location.swift
//  swift-server
//
//  Created by Yuriy T on 07.03.2018.
//  Copyright © 2018 Yuriy T. All rights reserved.
//

import RealmSwift

final class Location: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var city: String = ""
    @objc dynamic var state: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    enum SendedKeys: String, CodingKey {
        case city
        case state
    }
    
    enum InverseKeys: String, CodingKey {
        case id
        case city
        case state
    }
}

// from object to JSON
extension Location: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SendedKeys.self)
        
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
    }
}

// from JSON to object
extension Location: Decodable {
    convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: InverseKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        city = try values.decode(String.self, forKey: .city)
        state = try values.decode(String.self, forKey: .state)
    }
}

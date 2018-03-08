//
//  Location.swift
//  swift-server
//
//  Created by Yuriy T on 07.03.2018.
//  Copyright © 2018 Yuriy T. All rights reserved.
//

import RealmSwift

final class Location: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var state: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case city
        case state
    }
    
    enum InverseKeys: String, CodingKey {
        case city
        case state
    }
}

// from JSON
extension Location: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
    }
}

// to JSON
extension Location: Decodable {
    convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: InverseKeys.self)
        
        self.city = try values.decode(String.self, forKey: .city)
        self.state = try values.decode(String.self, forKey: .state)
    }
}

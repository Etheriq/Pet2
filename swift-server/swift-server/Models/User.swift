//
//  User.swift
//  swift-server
//
//  Created by Yuriy T on 07.03.2018.
//  Copyright © 2018 Yuriy T. All rights reserved.
//

import RealmSwift

final class User: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    
    let dreams = List<Dream>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // keys in sended json
    enum CodingKeys: String, CodingKey {
        case name = "fullName"
        case email
    }
    
    // keys in received json
    enum InverseKeys: String, CodingKey {
        case name
        case email
        case id
    }
}

// from object to JSON
extension User: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
    }
}

// from JSON to object
extension User: Decodable {
    convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: InverseKeys.self)
        
        self.name = try values.decode(String.self, forKey: .name)
        self.email = try values.decode(String.self, forKey: .email)
        self.id = try values.decode(Int.self, forKey: .id)
    }
}

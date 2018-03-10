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
    
    enum SendedKeys: String, CodingKey {
        case name = "fullName"
        case email
    }
    
    enum ReceivedKeys: String, CodingKey {
        case id
        case name
        case email
        case dreams
    }
}

// from object to JSON
extension User: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SendedKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
    }
}

// from JSON to object
extension User: Decodable {
    convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: ReceivedKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        email = try values.decode(String.self, forKey: .email)
        
        
        let dreamsDecodedO = try? values.decode([Dream].self, forKey: .dreams)
        if let dreamsDecoded = dreamsDecodedO {
            dreams.removeAll()
            _ = dreamsDecoded.flatMap { dreams.append($0) }
        }
        
//        for dreamDecoded in dreamsDecoded {
//            dreams.append(dreamDecoded)
//        }
    }
}

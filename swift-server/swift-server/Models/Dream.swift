//
//  Dream.swift
//  swift-server
//
//  Created by Yuriy T on 07.03.2018.
//  Copyright © 2018 Yuriy T. All rights reserved.
//

import RealmSwift

final class Dream: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var location: Location?
    
    let workHelps = List<WorkHelp>()
    let owner = LinkingObjects(fromType: User.self, property: "dreams")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location
    }
    
    enum InverseKeys: String, CodingKey {
        case name
        case location
    }
}

// from JSON
extension Dream: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(location, forKey: .location)
    }
}

// to JSON
extension Dream: Decodable {
    convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: InverseKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        location = try values.decode(Location.self, forKey: .location)
    }
}

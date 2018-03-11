//
//  Dream.swift
//  swift-server
//
//  Created by Yuriy T on 07.03.2018.
//  Copyright © 2018 Yuriy T. All rights reserved.
//

import RealmSwift

final class Dream: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var createdAt: Date?
    @objc dynamic var location: Location?
    
    var workHelps = List<WorkHelp>()
    let owner = LinkingObjects(fromType: User.self, property: "dreams")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    enum SendedKeys: String, CodingKey {
        case name
        case location
        case createdAt
        case workHelp = "work_help"
    }
    
    enum ReceivedKeys: String, CodingKey {
        case id
        case name
        case location
        case workHelp
        case createdAt
    }
}

// from object to JSON
extension Dream: Encodable {
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: SendedKeys.self)
        try container.encode(name, forKey: .name)
        try? container.encode(location, forKey: .location)
        try? container.encode(createdAt, forKey: .createdAt)
        
        var workHelpsArray: [WorkHelp] = []
        for wh in workHelps {
            workHelpsArray.append(wh)
        }
        try? container.encode(workHelpsArray, forKey: .workHelp)
    }
}

// from JSON to object
extension Dream: Decodable {
    convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: ReceivedKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        location = try? values.decode(Location.self, forKey: .location)
        
        let createdAtString = try? values.decode(String.self, forKey: .createdAt)
        if let createdString = createdAtString {
            createdAt = DateFormatter.iso8601Full.date(from: createdString)
        }
        
        let whO = try? values.decode([WorkHelp].self, forKey: .workHelp)
        if let wh = whO {
            workHelps.removeAll()
            _ = wh.flatMap { workHelps.append($0) }
        }
    }
}

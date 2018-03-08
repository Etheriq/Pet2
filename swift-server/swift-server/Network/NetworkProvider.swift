//
//  NetworkProvider.swift
//  swift-server
//
//  Created by Yuriy T on 07.03.2018.
//  Copyright © 2018 Yuriy T. All rights reserved.
//

import Moya

enum Network {
    case getUser
    case updateUser(user: User)
    case getDreamsFromPage(page: Int?)
    case createDream(dream: Dream)
}

extension Network: TargetType {
    public var method: Method {
        switch self {
        case .getUser, .getDreamsFromPage(_):
            return .get
        case .updateUser(_):
            return .post
        case .createDream(_):
            return .put
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getUser, .getDreamsFromPage(_):
            return .requestPlain
        case .updateUser(let user):
            return .requestJSONEncodable(UserRequest(user: user))
        case .createDream(let dream):
            return .requestJSONEncodable(CreateDreamRequest(dreamRequest: dream))
        }
    }
    
    public var headers: [String : String]? {
        return [:]
    }
    
    public var path: String {
        switch self {
        case .getUser, .updateUser(_):
            return "/user"
        case .getDreamsFromPage(let page):
            return "/dreams?page=\(page ?? 1)"
        case .createDream(_):
            return "/dream"
        }
    }
}
private struct UserRequest: Encodable {
    var user: User
}

private struct CreateDreamRequest: Encodable {
    var dreamRequest: Dream
    
    enum CodingKeys: String, CodingKey {
        case dreamRequest = "dream"
    }
}

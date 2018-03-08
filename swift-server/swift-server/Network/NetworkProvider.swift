//
//  NetworkProvider.swift
//  swift-server
//
//  Created by Yuriy T on 07.03.2018.
//  Copyright © 2018 Yuriy T. All rights reserved.
//

import Moya

enum NetworkErrors: Error {
    case MappingError
    case NetworkError(withCode: Int?, andWithMessage: String?)
}

enum Network {
    case getUser
    case updateUser(user: User)
    case getDreamsFromPage(page: Int?, limit: Int?)
    case createDream(dream: Dream)
}

extension Network: TargetType {
    public var method: Method {
        switch self {
        case .getUser, .getDreamsFromPage(_, _):
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
        case .getUser:
            return .requestPlain
        case .getDreamsFromPage(let page, let limit):
            let params = ["page": page ?? 1, "limit": limit ?? 10]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
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
        case .getDreamsFromPage(_, _):
            return "/dreams"
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

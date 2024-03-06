//
//  MDLUser.swift
//  RoomExpence
//
//  Created by MQF-6 on 28/02/24.
//

import Foundation

struct UserModel : Codable {
    
    let email : String?
    let name : String?
    let profile_pic : String?
    let userId : String
    var isSelected: Bool?

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case name = "name"
        case userId = "userId"
        case profile_pic = "profile_pic"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        userId = try values.decodeIfPresent(String.self, forKey: .userId) ?? ""
    }
    
    init(email: String? = nil, name: String? = nil, userId: String, profile_pic: String? = "") {
        self.email = email
        self.name = name
        self.userId = userId
        self.profile_pic = profile_pic
    }
     
}

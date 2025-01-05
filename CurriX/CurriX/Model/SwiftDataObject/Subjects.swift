//
//  Subjects.swift
//  CurriX
//
//  Created by 黄承暄 on 3/10/24.
//

import Foundation
import SwiftData

@Model
final class Subject: Codable {
//    @Attribute(.unique)
    var code: String
    var desc: String
    
    init(code: String, desc: String) {
        self.code = code
        self.desc = desc
    }
    
    // Making Subject Codable
    enum CodingKeys: String, CodingKey {
        case code
        case desc
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(desc, forKey: .desc)
    }
    
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decode(String.self, forKey: .code)
        desc = try values.decode(String.self, forKey: .desc)
    }
}

class AllSubjects {
    // Make class a singleton
    static var shared = AllSubjects()
    
    func obtainSubjects() async throws {
        try await downloadAllSubjects()
    }
    
    // Properties
    var initialized: Bool = false
    var subjects: [Subject] = []
}

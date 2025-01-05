//
//  FieldName.swift
//  CurriX
//
//  Created by Welkin Y on 3/8/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(FieldName.self, from: jsonData)

import Foundation

import Foundation

// MARK: - FieldName
struct FieldName: Codable {
    var sccLovResp: SccLovResp

    enum CodingKeys: String, CodingKey {
        case sccLovResp = "scc_lov_resp"
    }
    
    // MARK: - SccLovResp
    struct SccLovResp: Codable {
        var lovs: Lovs
        var xmlns: String

        enum CodingKeys: String, CodingKey {
            case lovs
            case xmlns = "@xmlns"
        }
    }

    // MARK: - Lovs
    struct Lovs: Codable {
        var lov: Lov
    }

    // MARK: - Lov
    struct Lov: Codable {
        var values: Values
        var name: String

        enum CodingKeys: String, CodingKey {
            case values
            case name = "@name"
        }
    }

    // MARK: - Values
    struct Values: Codable {
        var value: [Value]
    }

    // MARK: - Value
    struct Value: Codable {
        var code, desc: String
    }
}



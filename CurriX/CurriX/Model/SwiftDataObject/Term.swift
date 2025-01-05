//
//  Term.swift
//  CurriX
//
//  Created by 黄承暄 on 3/10/24.
//

import Foundation
import SwiftData

@Model
final class Term: Codable {
//    @Attribute(.unique) // Can cause mysterious bug lol：https://discussions.apple.com/thread/255322087?sortBy=best
    let termNumber: String
    let termString: String

    init(code: String, desc: String) {
        self.termNumber = code
        self.termString = desc
    }
    
    // Making Term Codable
    enum CodingKeys: String, CodingKey {
        case termNumber
        case termString
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(termNumber, forKey: .termNumber)
        try container.encode(termString, forKey: .termString)
    }
    
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        termNumber = try values.decode(String.self, forKey: .termNumber)
        termString = try values.decode(String.self, forKey: .termString)
    }
}

class AllTerms {
    // Make class a singleton
    static var shared = AllTerms()

    func obtainTerms() async throws {
        try await downloadAllTerms()
    }
    
    static func obtainTerm(termNumber: String) -> Term? {
        for term in shared.terms {
            if term.termNumber == termNumber {
                return term
            }
        }
        return nil
    }
    
    // Properties
    var initialized: Bool = false
    var terms: [Term] = []
}

let canChooseTerms: [Term] = [
    Term(code: "1830", desc: "2023 Spring Term"),
    Term(code: "1860", desc: "2023 Fall Term"),
    Term(code: "1870", desc: "2024 Spring Term"),
    Term(code: "1900", desc: "2024 Fall Term")
]

//
//  LifeSpanParser.swift
//  CatApp
//
//  Created by Bruges on 17/10/2025.
//

import Foundation

struct LifeSpanParser {
    static func higher(from text: String?) -> Int? {
        guard let t = text else { return nil }
        let parts = t.components(separatedBy: CharacterSet(charactersIn: "-–"))
        if parts.count >= 2, let val = Int(parts[1].trimmingCharacters(in: .whitespaces)) {
            return val
        }
        if let val = Int(parts[0].trimmingCharacters(in: .whitespaces)) {
            return val
        }
        return nil
    }
}


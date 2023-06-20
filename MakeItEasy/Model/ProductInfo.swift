//
//  ProductInfo.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-19.
//

import Foundation

struct ProductInfo: Codable, Hashable {
    let brand: String
    let sources: [String]
}

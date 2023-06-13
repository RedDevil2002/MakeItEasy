//
//  DownloadManager.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import Foundation
import OSLog

struct Product: Decodable, Hashable {
    let itemID: String
    let brand: String
    let imageLinks: [String]
}

class DownloadManager: ObservableObject {
    private let logger = Logger(subsystem: "com.devil.red.MakeItEasy", category: "DownloadManager")
    @Published private(set) var allProducts: [Product] = []
    
    init() {
        Task {
            await parseProductObjectFile(forResource: "products", withExtension: "json")
        }
    }
    
    func parseProductObjectFile(forResource name: String, withExtension ext: String) async {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: name, withExtension: ext) else { return }
        guard let data = try? Data(contentsOf: fileURL) else { return }
        guard let parsedObjects = try? JSONDecoder().decode([Product].self, from: data) else { return }
        allProducts = parsedObjects
    }
}

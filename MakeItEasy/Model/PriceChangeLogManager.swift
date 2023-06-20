//
//  ChangeTagManager.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//
import Foundation
import Combine
import OSLog

class PriceChangeLogManager: ObservableObject {
    private let logger: Logger = Logger(subsystem: "com.devil.red.MakeItEasy", category: "PriceChangeLogManager")
    private var cancellables: Set<AnyCancellable> = []
    
    var document = Scanner()
//    @Published var scannedProducts: [Product?] = []
        
    func parseProductObjectFile(forResource name: String, withExtension ext: String) async {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: name, withExtension: ext) else { return }
        guard let data = try? Data(contentsOf: fileURL) else { return }
        guard let products = try? JSONDecoder().decode([Product].self, from: data) else { return }
        
        for product in products {
            if let productInfo = try? JSONEncoder().encode(ProductInfo(brand: product.brand, sources: product.sources)) {
                UserDefaults.standard.set(productInfo, forKey: product.itemID.uppercased())
            }
        }
        UserDefaults.standard.set(true, forKey: "LoadingComplete")
    }
    
    init() {
        
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
}

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
    private let logger = Logger(subsystem: "com.devil.red.MakeItEasy", category: "PriceChangeLogManager")
    private var cancellables: Set<AnyCancellable> = []
    
    var document = Scanner()
    @Published var scannedProducts: [Product?] = []
    @Published var productCatalogue: [String: Product] = [:]
        
    func parseProductObjectFile(forResource name: String, withExtension ext: String) async {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: name, withExtension: ext) else { return }
        guard let data = try? Data(contentsOf: fileURL) else { return }
        guard let products = try? JSONDecoder().decode([Product].self, from: data) else { return }
        Task {
            for product in products {
                productCatalogue[product.itemID] = product
            }
        }
    }
    
    init() {
        Task {
            await parseProductObjectFile(forResource: "products", withExtension: "json")
        }
        document.scannedItemIDs.publisher
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
            .sink { scannedItemID in
                self.logger.debug("ScannedProducts append \(scannedItemID)")
                self.scannedProducts.append(self.productCatalogue[scannedItemID, default: Product(itemID: scannedItemID, brand: "No Brand", imageLinks: [])])                
            }
            .store(in: &cancellables)
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
}

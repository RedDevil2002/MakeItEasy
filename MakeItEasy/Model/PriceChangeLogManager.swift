//
//  ChangeTagManager.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//
import Foundation
import OSLog
import CoreData

class PriceChangeLogManager: ObservableObject {
    private let logger: Logger = Logger(subsystem: "com.devil.red.MakeItEasy", category: "PriceChangeLogManager")
    var document = Scanner()
        
    func parseProductObjectFile(forResource name: String, withExtension ext: String) async {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: name, withExtension: ext) else { return }
        guard let data = try? Data(contentsOf: fileURL) else { return }
        guard let products = try? JSONDecoder().decode([ProductInfo].self, from: data) else { return }
        
        var iterator = products.makeIterator()
        let encoder = JSONEncoder()
        
        await PersistenceController.shared.container.performBackgroundTask { context in
            let batchInsert = NSBatchInsertRequest(entity: Product.entity()) { (object: NSManagedObject) in
                guard let nextProduct = iterator.next() else { return true }
                if let product = object as? Product {
                    // save itemID in upper case
                    product.itemID = nextProduct.itemID.uppercased()
                    product.brand = nextProduct.brand
                    product.sources = try? encoder.encode(nextProduct.sources)
                }
                return false
            }
            do {
                try context.execute(batchInsert)
            } catch {
                self.logger.debug("Error executing product batch insert")
            }
            UserDefaults.standard.set(true, forKey: "LoadingComplete")
        }
    }
}

//
//  ChangeTagManager.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//
import Foundation
import OSLog
import CoreData

class ProductInfoParser: ObservableObject {
    private let logger: Logger = Logger(subsystem: "com.devil.red.MakeItEasy", category: "PriceChangeLogManager")
    let total = 3933
    
    @Published var currentItem = 0
    
    func parseProductObjectFile(forResource name: String, withExtension ext: String) async {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: name, withExtension: ext) else { return }
        guard let data = try? Data(contentsOf: fileURL) else { return }
        guard let products = try? JSONDecoder().decode([ProductInfo].self, from: data) else { return }
        
        var iterator = products.makeIterator()
        let encoder = JSONEncoder()
        
        await PersistenceController.shared.container.performBackgroundTask { context in
            let insertRequest = NSBatchInsertRequest(entity: Product.entity()) { (object: NSManagedObject) in
                guard let nextProduct = iterator.next() else { return true }
                if let product = object as? Product {
                    // save itemID in upper case
                    product.itemID = nextProduct.itemID.uppercased()
                    product.brand = nextProduct.brand
                    product.sources = try? encoder.encode(nextProduct.sources)
                }
                self.currentItem += 1
                return false
            }
            insertRequest.resultType = .objectIDs
            let batchInsert = try? context.execute(insertRequest) as? NSBatchInsertResult
            guard let insertResult = batchInsert?.result as? [NSManagedObjectID] else { return }
            let createdObjects: [AnyHashable: Any] = [NSInsertedObjectsKey: insertResult]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: createdObjects, into: [PersistenceController.shared.container.viewContext])
            UserDefaults.standard.set(true, forKey: "LoadingComplete")
        }
    }
}

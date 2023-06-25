//
//  ChangeTagManager.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//
import Foundation
import OSLog
import CoreData
import Combine

class ProductInfoParser: ObservableObject {
    private let logger: Logger = Logger(subsystem: "com.devil.red.MakeItEasy", category: "PriceChangeLogManager")
    @Published var currentItem = 0
    @Published var currentImage = 0
    
    var downloadStatusPublisher: AnyPublisher<Int, Never> {
        $currentItem
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var downloadStatusPublisherForImages: AnyPublisher<Int, Never> {
        $currentImage
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    func parseProductObjectFileForImages(forResource name: String, withExtension ext: String) async {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: name, withExtension: ext) else { return }
        guard let data = try? Data(contentsOf: fileURL) else { return }
        guard let products = try? JSONDecoder().decode([ProductInfo].self, from: data) else { return }
        
        var iterator = products.flatMap({ productInfo in
            let itemID = productInfo.itemID
            return productInfo.sources.map{ (itemID, $0) }
        }).makeIterator()
        
        DispatchQueue.main.async {
            self.currentImage = 0
        }
        
        await Persistence.shared.container.performBackgroundTask { context in
            let insertRequest = NSBatchInsertRequest(entity: Product.entity()) { (object: NSManagedObject) in
                guard let (itemID, source) = iterator.next() else { return true }
                if let productImage = object as? ProductImage {
                    // save itemID in upper case
                    productImage.itemID = itemID
                    productImage.source = source
                }
                DispatchQueue.main.async { [weak self] in
                    self?.currentImage += 1
                }
                return false
            }
            insertRequest.resultType = .objectIDs
            let batchInsert = try? context.execute(insertRequest) as? NSBatchInsertResult
            guard let insertResult = batchInsert?.result as? [NSManagedObjectID] else { return }
            let createdObjects: [AnyHashable: Any] = [NSInsertedObjectsKey: insertResult]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: createdObjects, into: [Persistence.shared.container.viewContext])
            UserDefaults.standard.set(true, forKey: "LoadingComplete")
        }
        
    }
    
    func parseProductObjectFile(forResource name: String, withExtension ext: String) async {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: name, withExtension: ext) else { return }
        guard let data = try? Data(contentsOf: fileURL) else { return }
        guard let products = try? JSONDecoder().decode([ProductInfo].self, from: data) else { return }
        
        var iterator = products.makeIterator()
        DispatchQueue.main.async {
            self.currentItem = 0
        }
        
        await Persistence.shared.container.performBackgroundTask { context in
            let insertRequest = NSBatchInsertRequest(entity: Product.entity()) { (object: NSManagedObject) in
                guard let nextProduct = iterator.next() else { return true }
                if let product = object as? Product {
                    // save itemID in upper case
                    product.itemID = nextProduct.itemID.uppercased()
                    product.brand = nextProduct.brand
                }
                DispatchQueue.main.async { [weak self] in
                    self?.currentItem += 1
                }
                return false
            }
            insertRequest.resultType = .objectIDs
            let batchInsert = try? context.execute(insertRequest) as? NSBatchInsertResult
            guard let insertResult = batchInsert?.result as? [NSManagedObjectID] else { return }
            let createdObjects: [AnyHashable: Any] = [NSInsertedObjectsKey: insertResult]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: createdObjects, into: [Persistence.shared.container.viewContext])
            UserDefaults.standard.set(true, forKey: "LoadingComplete")
        }
    }
}

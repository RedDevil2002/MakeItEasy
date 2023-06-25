//
//  Persistence.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import CoreData

struct Persistence {
    static let shared = Persistence()

    static var preview: Persistence = {
        let result = Persistence(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let productImage = ProductImage(context: viewContext)
            productImage.itemID = "\(i)"
            productImage.source = "https://www.softmoc.com/items/images/585_XX3.jpg"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "MakeItEasy")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
}

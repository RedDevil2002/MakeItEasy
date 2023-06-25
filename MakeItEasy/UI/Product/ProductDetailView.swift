//
//  ProductDetailView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI
import CoreData

struct ProductDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var product: Product
    @State private var itemID: String = ""
    
    @FetchRequest(entity: ProductImage.entity(), sortDescriptors: [])
    private var images: FetchedResults<ProductImage>
    
    init(product: Product) {
        self.product = product
        self.itemID = (product.itemID).unwrapped.uppercased()
    }
    
    var body: some View {
        List {
            ForEach(images, id: \.self) { image in
                VStack {
                    AsyncImage(url: URL(string: image.source.unwrapped)) { image in
                        image
                            .resizable()
                            .cornerRadius(15.0)
                            .scaledToFit()
                            .frame(width: 350, height: 350)
                    } placeholder: {
                        ProgressView()
                    }
                }
                .contextMenu {
                    Button {
                        
                    } label: {
                        Text(image.source?.lowercased() ?? "")
                    }
                }
            }
        }
        .task {
            self.images.nsPredicate = NSPredicate(format: "itemID = %@", itemID)
        }
        .tabViewStyle(.page)
        
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let product = Product(context: Persistence.preview.container.viewContext)
        product.itemID = "585"
        product.brand = "blundstone"
        let productImage = ProductImage(context: Persistence.preview.container.viewContext)
        productImage.source = "https://www.softmoc.com/items/images/585_XX3.jpg"
        productImage.itemID = "585"
        return ProductDetailView(product: product)
    }
}

//
//  ProductView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct ProductView: View {
    // ViewContext passed down from the MakeItEasyApp file as an Environment Variable
    @Environment(\.managedObjectContext) var viewContext
    
    @ObservedObject var product: Product
    @FetchRequest(entity: ProductImage.entity(), sortDescriptors: [])
    private var images: FetchedResults<ProductImage>
    
    var body: some View {
        VStack {
            NavigationLink {
                ProductDetailView(product: product)
                    .environment(\.managedObjectContext, viewContext)
            } label: {
                RoundedRectangle(cornerRadius: 15)
            }
            Text("\(product.images?.count ?? 0)")
            HStack {
                Spacer()
                Text(product.itemID.unwrapped.uppercased())
                    .bold()
                    .foregroundColor(.primary)
                Spacer()
            }
//            .onAppear {
//                images.nsPredicate = NSPredicate(format: "itemID = %@", product.itemID.unwrapped)
//            }
        }
        .frame(height: 400)
        .onLongPressGesture {
            product.completed.toggle()
            try? viewContext.save()
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    
    static var previews: some View {
        let product = Product(context: Persistence.preview.container.viewContext)
        product.itemID = "585"
        product.brand = "blundstone"
        let productImage = ProductImage(context: Persistence.preview.container.viewContext)
        productImage.source = "https://www.softmoc.com/items/images/585_XX3.jpg"
        productImage.itemID = "585"
        return ProductView(product: product)
    }
    
}

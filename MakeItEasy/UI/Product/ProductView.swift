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
    var bestDescriptionLink: String? {
        if let data = product.sources, let sources = try? JSONDecoder().decode([String].self, from: data) {
            return sources.map{ $0.uppercased() }.filter{ $0.contains(product.itemID.unwrapped.uppercased) }.first
        }
        return nil
    }
    var body: some View {
        VStack {
            NavigationLink {
                ProductDetailView(product: product)
            } label: {
                if let link = bestDescriptionLink {
                    AsyncImage(url: URL(string: link)) { image in
                        image
                            .resizable()
                            .cornerRadius(15.0)
                            .scaledToFit()
                            .padding()
                    } placeholder: {
                        ProgressView()
                            .scaledToFit()
                            .padding()
                    }
                }
            }
            HStack {
                Spacer()
                Text(product.itemID.unwrapped.uppercased())
                    .bold()
                    .foregroundColor(.primary)
                Spacer()
            }
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
        let product = Product(context: PersistenceController.preview.container.viewContext)
        product.itemID = "585"
        product.brand = "blundstone"
        product.sources = nil
        return ProductView(product: product)
    }
}

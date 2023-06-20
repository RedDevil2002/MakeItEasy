//
//  ProductView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct ProductView: View {
    @ObservedObject var product: Product
    
    var bestDescriptionLink: String? {
        if let data = product.sources, let sources = try? JSONDecoder().decode([String].self, from: data) {
            return sources.first
        }
        return nil
    }
    
    var body: some View {
        NavigationLink {
            ProductDetailView(product: product)
        } label: {
            VStack {
                if let link = bestDescriptionLink {
                    AsyncImage(url: URL(string: link)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .padding()
                    } placeholder: {
                        ProgressView()
                            .scaledToFit()
                    }
                }
            }
            .frame(width: 350, height: 350)
            .overlay(alignment: .bottom) {
                Text(product.itemID.unwrapped.uppercased()).bold()
            }
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

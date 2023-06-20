//
//  ProductDetailView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct ProductDetailView: View {
    @ObservedObject var product: Product
    
    var sources: [String] {
        if let data = product.sources, let sources = try? JSONDecoder().decode([String].self, from: data) {
            return sources
        }
        return []
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
//                TextField("", text: product.itemID)
                Spacer()
            }
            TabView {
                ForEach(sources, id: \.self) { link in
                    VStack {
                        AsyncImage(url: URL(string: link)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 350)
                        } placeholder: {
                            ProgressView()
                        }
                        Text(link)
                    }
                }
            }
        }
        .tabViewStyle(.page)
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let product = Product(context: PersistenceController.preview.container.viewContext)
        product.itemID = "585"
        product.brand = "blundstone"
        product.sources = nil
        return ProductDetailView(product: product)
    }
}

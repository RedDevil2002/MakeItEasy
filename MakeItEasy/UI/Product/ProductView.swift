//
//  ProductView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct ProductView: View {
    let product: Product?
    
    var imageLinks: [String] {
        guard let imageLinks = product?.imageLinks else { return [] }
        return imageLinks
            .filter { !$0.hasSuffix(".gif") }
            .sorted { x, y in
                if x.hasSuffix("X.jpg") {
                    return true
                } else if y.hasSuffix("X.jpg") {
                    return false
                } else {
                    return x < y
                }
            }
    }
    
    var bestDescriptionLink: String? {
        if let link = imageLinks.first {
            return link
        }
        return nil
    }
    
    var body: some View {
        NavigationLink {
            if let product {
                ProductDetailView(itemID: product.itemID,imageLinks: imageLinks)
            } else {
                EmptyView()
            }
        } label: {
            if let link = bestDescriptionLink {
                AsyncImage(url: URL(string: link)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                        .padding()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 350, height: 350)
            }
        }

    }
}

struct ProductView_Previews: PreviewProvider {
    
    static var previews: some View {
        ProductView(product: Product(itemID: "531", brand: "Birkenstock", imageLinks: ["A", "B", "C"]))
    }
}

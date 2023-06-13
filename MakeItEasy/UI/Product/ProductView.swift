//
//  ProductView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct ProductView: View {
    let product: Product
    
    var bestDescriptionLink: String? {
        let imageLinks = product.imageLinks
        if let link = imageLinks.first(where: { $0.hasSuffix("XXX.jpg")}) {
            return link
        }
        
        if let link = imageLinks.first {
            return link
        }
        return nil
    }
    
    var body: some View {
        NavigationLink {
            ProductDetailView(product: product)
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

//
//  ProductDetailView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    
    var imageLinks: [String] {
        product.imageLinks
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
    
    var body: some View {
        TabView {
            ForEach(imageLinks, id: \.self) { link in
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
        .tabViewStyle(.page)
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: Product(itemID: "531", brand: "Birkenstock", imageLinks: ["A", "B", "C"]))
    }
}

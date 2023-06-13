//
//  ProductListView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct ProductListView: View {
    let products: [Product]
    var body: some View {
        NavigationView {
            List {
                ForEach(products, id: \.self) { productObject in
                    Section {
                        ProductView(product: productObject)
                            .padding()
                            .frame(width: 400, height: 400)
                    } header: {
                        Text(productObject.brand).bold()
                            .accessibilityLabel(Text("Brand"))
                    } footer: {
                        Text("\(productObject.itemID)").bold()
                            .accessibilityLabel(Text("Item ID"))
                    }
                }
//                .onDelete { products.remove(atOffsets: $0) }
            }
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(products: [
            Product(itemID: "531", brand: "Birkenstock", imageLinks: ["A", "B", "C"]),
            Product(itemID: "5313", brand: "Birkenstock", imageLinks: ["A", "B", "google.com"])
        ])
    }
}

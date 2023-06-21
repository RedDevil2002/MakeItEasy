//
//  ProductDetailView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct ProductDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var product: Product
    @State private var itemID: String
    
    init(product: Product) {
        self.product = product
        self.itemID = product.itemID.unwrapped
    }
    
    var sources: [String] {
        if let data = product.sources, let sources = try? JSONDecoder().decode([String].self, from: data) {
            return sources.map{ $0.uppercased() }.filter{ $0.contains(product.itemID.unwrapped.uppercased) }
        }
        return []
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                TextField("", text: $itemID)
                    .onChange(of: itemID) { newValue in
                        self.product.itemID = newValue
                        try? viewContext.save()
                    }
                    .multilineTextAlignment(.center)
                Spacer()
            }
            TabView {
                ForEach(sources, id: \.self) { link in
                    VStack {
                        AsyncImage(url: URL(string: link)) { image in
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
                            Text(link.lowercased())
                        }
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

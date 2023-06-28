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
    
    @State private var showProductDetailView = false
    
    var body: some View {
        VStack {
            if let xxx = product.xxx, let uiImage = UIImage(data: xxx) {
                Image(uiImage: uiImage)
                    .resizable()
                    .cornerRadius(25.0)
                    .padding()
                    .frame(height: 400)
                    .onTapGesture(count: 2) {
                        showProductDetailView.toggle()
                    }
                    .onTapGesture {
                        withAnimation {
                            product.completed.toggle()
                        }
                        try? viewContext.save()
                    }
                    .overlay(alignment: .center, content: {
                        Image(systemName: "checkmark.diamond.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(product.completed ? .green : .clear)
                            .padding()
                            .disabled(true)
                            .allowsTightening(false)
                    })
                    .background {
                        RoundedRectangle(cornerRadius: 25.0)
                            .strokeBorder(product.completed ? .green: .red, lineWidth: 10.0)
                    }
            } else {
                ProgressView()
                    .scaledToFit()
            }
            HStack {
                Spacer()
                Text(product.itemID.unwrapped.uppercased())
                    .bold()
                    .foregroundColor(.primary)
                Spacer()
            }
        }
        .sheet(isPresented: $showProductDetailView, content: {
            let productDetailViewModel = ProductDetailViewModel(product: product)
            ProductDetailView(viewModel: productDetailViewModel)
                .environment(\.managedObjectContext, viewContext)
        })
//        VStack {
//            NavigationLink {
//                let productDetailViewModel = ProductDetailViewModel(product: product)
//                ProductDetailView(viewModel: productDetailViewModel)
//                    .environment(\.managedObjectContext, viewContext)
//            } label: {
//            }
//        }
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
        return ProductView(product: product)
    }
    
}

////
////  ProductListView.swift
////  MakeItEasy
////
////  Created by Brian Seo on 2023-06-13.
////
//
//import SwiftUI
//
//struct ProductListView: View {
//    @StateObject var downloadManager: DownloadManager
//    @State private var products: [Product] = []
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(products, id: \.self) { productObject in
//                    Section {
//                        ProductView(product: productObject)
//                            .padding()
//                            .frame(width: 400, height: 400)
//                    } header: {
//                        Text(productObject.brand).bold()
//                            .accessibilityLabel(Text("Brand"))
//                    } footer: {
//                        Text("\(productObject.itemID)").bold()
//                            .accessibilityLabel(Text("Item ID"))
//                    }
//                }
//                .onReceive(downloadManager.parsedProductsPublisher) { updatedProducts in
//                    self.products = updatedProducts
//                }
////                .onDelete { products.remove(atOffsets: $0) }
//            }
//        }
//    }
//}
//
//struct ProductListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let downloadManager = DownloadManager()
//        ProductListView(downloadManager: downloadManager)
//    }
//}

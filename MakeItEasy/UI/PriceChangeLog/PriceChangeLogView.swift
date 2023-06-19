//
//  PriceChangeLogView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct PriceChangeLogView: View {
    @StateObject var priceChangeLogManager = PriceChangeLogManager()
    @StateObject var scanner = Scanner()
    @State private var showDocumentScannerView = false
    @State private var products: [Product?] = []
    
    var body: some View {
        List {
            ForEach(products, id: \.self) { product in
                Section {
                    NavigationLink {
                        ProductDetailView(itemID: (product?.itemID).unwrapped, imageLinks: product?.imageLinks ?? [])
                    } label: {
                        ProductView(product: product)
                            .padding()
                            .frame(width: 400, height: 400)
                    }
                } header: {
                    Text((product?.brand).unwrapped).bold()
                        .accessibilityLabel(Text("Brand"))
                } footer: {
                    Text((product?.itemID).unwrapped).bold()
                        .accessibilityLabel(Text("Item ID"))
                }
            }
        }
        .navigationTitle(Text("\(self.products.count)"))
        .refreshable {
            Task {
                self.products = scanner.scannedItemIDs.map{ priceChangeLogManager.productCatalogue[$0] ?? Product(itemID: $0, brand: "No Brand", imageLinks: []) }
            }
        }
        .overlay(alignment: .bottom) {
            ScanButton()
                .sheet(isPresented: $showDocumentScannerView) {
                    ScanViewController()
                        .environmentObject(scanner)
                }
            
        }
    }
    
    private func ScanButton() -> some View {
        Button {
            showDocumentScannerView.toggle()
        } label: {
            UI.Constant.ScanButton()
            
        }
    }
}

extension Optional<String> {
    var unwrapped: String {
        return self ?? ""
    }
}

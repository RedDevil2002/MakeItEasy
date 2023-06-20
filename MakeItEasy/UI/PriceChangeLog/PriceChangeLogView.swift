//
//  PriceChangeLogView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct PriceChangeLogView: View {
    @Environment(\.managedObjectContext) var viewContext
    @StateObject var priceChangeLogManager = PriceChangeLogManager()
    
    @StateObject var scanner = Scanner()
    @State private var showDocumentScannerView = false
    
    @SectionedFetchRequest<Optional<String>, Product>(
        sectionIdentifier: \.brand,
        sortDescriptors: [SortDescriptor(\.brand)]
    )
    private var products: SectionedFetchResults<Optional<String>, Product>
    
    var body: some View {
        List(products) { section in
            Section(header: Text(section.id.unwrapped)) {
                ForEach(section) { product in
                    ProductView(product: product)
                        .frame(width: 400, height: 400)
                }
            }
            .headerProminence(.increased)
            .
        }
        .task {
            // if product informations are not loaded, load it
            self.load()
        }
        .navigationTitle(Text("\(self.products.count)"))
        .overlay(alignment: .bottom) {
            ScanButton()
                .sheet(isPresented: $showDocumentScannerView) {
                    ScanViewController()
                        .environmentObject(scanner)
                }
        }
    }
        
    private func load() {
        let loadingComplete = UserDefaults.standard.bool(forKey: "LoadingComplete")
        if !loadingComplete {
            Task {
                await priceChangeLogManager.parseProductObjectFile(forResource: "productInfos", withExtension: "json")
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

extension String {
    var brand: String {
        return UserDefaults.standard.string(forKey: self) ?? "No Brand"
    }
}

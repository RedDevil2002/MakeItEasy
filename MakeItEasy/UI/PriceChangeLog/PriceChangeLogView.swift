//
//  PriceChangeLogView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI
import Combine

struct PriceChangeLogView: View {
    // ViewContext passed down from the MakeItEasyApp file as an Environment Variable
    @Environment(\.managedObjectContext) var viewContext
    @SectionedFetchRequest<Optional<String>, Product>(
        sectionIdentifier: \.brand,
        sortDescriptors: [SortDescriptor(\.brand)]
    )
    private var products: SectionedFetchResults<Optional<String>, Product>
    
    @StateObject var scanner = Scanner()
    @State private var showDocumentScannerView = false
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                ForEach(products) { section in
                    Section(header: Text(section.id.unwrapped).bold().font(.title2)) {
                        ForEach(section) { product in
                            ProductView(product: product)
                        }
                    }
                    .headerProminence(.increased)
                }
            }
        }
        .refreshable {
            let levenshtein = Levenshtein()
            await levenshtein.getAllItems()
            products.nsPredicate = NSPredicate(format: "itemID in %@", scanner.scannedItemIDs.compactMap{ levenshtein.closestString(to: $0,in: levenshtein.items)} )
        }
        .navigationTitle(Text("Price Change Log"))
        .overlay(alignment: .bottom) {
            ScanButton()
                .sheet(isPresented: $showDocumentScannerView) {
                    ScanViewController()
                        .environmentObject(scanner)
                }
        }
    }

    // ScanButton, when clicked on, shows the document scanner
    private func ScanButton() -> some View {
        Button {
            showDocumentScannerView.toggle()
        } label: {
            UI.Constant.ScanButton()
        }
    }
}

// return self ?? ""
extension Optional<String> {
    var unwrapped: String {
        return self ?? ""
    }
}


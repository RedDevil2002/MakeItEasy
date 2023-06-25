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
        sortDescriptors: [SortDescriptor(\.brand)],
        predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "itemID = %@", "*&^(*@^(@(*#&!)(*&"),
            NSPredicate(format: "completed == NO")
        ])
    )
    private var products: SectionedFetchResults<Optional<String>, Product>
    @StateObject var levenshtein = Levenshtein()
    
    @StateObject var scanner = Scanner()
    @State private var showDocumentScannerView = false
    @State private var loading = false
    
    @State private var current = 0
    
    var body: some View {
        VStack {
            if loading {
                CircularProgress(progress: Double(current) / Double(scanner.scannedItemIDs.count))
            }
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    ForEach(products) { section in
                        Section(header: Text(section.id.unwrapped).bold().font(.title2)) {
                            ForEach(section) { product in
                                ProductView(product: product)
                                    .environment(\.managedObjectContext, viewContext)
                            }
                        }
                        .headerProminence(.increased)
                    }
                }
            }
            ScanButton()
                .sheet(isPresented: $showDocumentScannerView, onDismiss: {
                    self.loading = true
                }, content: {
                    ScanViewController()
                        .environmentObject(scanner)
                })
                .padding(.bottom)
        }
        .onChange(of: scanner.scannedItemIDs, perform: { newItems in
            DispatchQueue.global().async {
                self.current = 0
                let updatedItems = newItems.compactMap{
                    DispatchQueue.main.async {
                        current += 1
                    }
                    return levenshtein.closestString(to: $0, in: levenshtein.items)
                }
                DispatchQueue.main.async {
                    self.products.nsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                        NSPredicate(format: "itemID in %@", updatedItems),
                        NSPredicate(format: "completed == NO")
                    ])
                    self.loading = false
                }
            }
        })
        .task {
            await levenshtein.getAllItems()
        }
        .navigationTitle(Text("Easy Price Change Log"))
    }
    
    // ScanButton, when clicked on, shows the document scanner
    private func ScanButton() -> some View {
        Button {
            showDocumentScannerView.toggle()
        } label: {
            Constant.UI.ScanButton(levenshtein.isDoneLoadingAllItems ? .primary: .red)
        }
        .disabled(!levenshtein.isDoneLoadingAllItems)
    }
}

// return self ?? ""
extension Optional<String> {
    var unwrapped: String {
        return self ?? ""
    }
}


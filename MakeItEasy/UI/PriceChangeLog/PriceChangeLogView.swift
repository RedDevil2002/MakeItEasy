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
    @State private var viewModels: [ProductViewModel] = []
    
    @State private var brands = [String]()
//    ["Absolute Canada", "adidas", "Baffin", "Bench", "Birkenstock", "Blondo Canada", "Blowfish Malibu", "Blundstone", "Bogs", "Champs", "Clarks", "Co-Lab", "Columbia", "Converse", "Cougar", "Crocs", "Dr Martens", "Duray", "Fjallraven", "Fraas", "Glerups", "Gredico- NHL", "HEYDUDE", "Hot Sox", "Hunter", "JanSport", "Josef Seibel", "K Bell", "K-SWISS", "Kamik", "Keds", "Keen", "Lacoste", "Mephisto", "Merrell", "Moneysworth & Best", "Olang", "OOFOS", "Puma", "Reebok", "Reef", "Roemers", "Romika", "Roots", "Royal Canadian", "Skechers", "Skechers Work", "Sof Sole", "SoftMoc", "SoftMoc Gift Card", "SoftMoc Shoe Care", "Sorel", "Sperry", "Steve Madden", "Superga", "Teva", "Timberland", "UGG", "Vans", "Vionic", "Volant James"]
    
    var body: some View {
        List {
            ForEach(brands, id: \.self) { brand in
                Section {
                    ForEach(viewModels.filter{ $0.brand == brand }, id: \.itemID) { viewModel in
                        ProductView()
                            .environmentObject(viewModel)
                            .tag(viewModel.itemID)
                    }
                } header: {
                    Text(brand)
                }
            }
        }
        .task {
            // if product informations are not loaded, load it
            self.load()
        }
        .refreshable {
            viewModels = scanner.scannedItemIDs.map{ ProductViewModel(itemID: $0.lowercased()) }
            let uniqueBrands = Set(viewModels.map{ $0.brand })
            brands = Array(uniqueBrands).sorted()
        }
        .navigationTitle(Text("\(self.viewModels.count)"))
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

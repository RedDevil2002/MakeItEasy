//
//  ScanDocumentView.swift
//  Price Change List
//
//  Created by Brian Seo on 2023-06-01.
//

import SwiftUI
import VisionKit
import UIKit

struct DocumentView: View {
    @StateObject var document = Scanner()
    @State private var showDocumentScannerView = false
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Text("scannedItemIDs Count = \(document.scannedItemIDs.count)")
                ForEach(document.scannedItemIDs, id: \.self) { itemID in
                    Text(itemID)
                }
            }
        }
        .overlay(alignment: .bottom) {
            ScanButton()
                .sheet(isPresented: $showDocumentScannerView) {
                    ScanViewController()
                        .environmentObject(document)
                        
                }
        }
    }
    
    private func ScanButton() -> some View {
        Button {
            showDocumentScannerView.toggle()
        } label: {
            UI.Constant.ScanButton(.primary)
            
        }
    }
}

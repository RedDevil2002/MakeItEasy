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
    @StateObject var viewModel: DocumentViewModel = DocumentViewModel()
    @State private var showDocumentScannerView = false
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ScannedImageView(scannedImage: $viewModel.scannedImage)
                ForEach(viewModel.itemIDs, id: \.self) { itemID in
                    Text(itemID)
                }
            }
        }
        .overlay(alignment: .bottom) {
            ScanButton()
                .sheet(isPresented: $showDocumentScannerView) {
                    ScanViewController()
                        .environmentObject(viewModel)
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

// SubViews of Document View
extension DocumentView {
    struct ScannedImageView: View {
        @Binding var scannedImage: UIImage?
        var body: some View {
            if let scannedImage {
                Image(uiImage: scannedImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "doc.plaintext.fill")
            }
        }
    }
}

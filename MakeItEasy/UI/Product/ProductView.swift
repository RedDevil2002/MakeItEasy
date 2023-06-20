//
//  ProductView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct ProductView: View {
    @EnvironmentObject var viewModel: ProductViewModel
    
    var bestDescriptionLink: String? {
        if let link = viewModel.sources.first {
            return link
        }
        return nil
    }
    
    var body: some View {
        NavigationLink {
            ProductDetailView()
                .environmentObject(viewModel)
        } label: {
            VStack {
                if let link = bestDescriptionLink {
                    AsyncImage(url: URL(string: link)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .padding()
                    } placeholder: {
                        ProgressView()
                            .scaledToFit()
                    }
                }
            }
            .frame(width: 350, height: 350)
            .overlay(alignment: .bottom) {
                Text(viewModel.itemID.uppercased()).bold()
            }
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel: ProductViewModel = ProductViewModel(itemID: "585")
        ProductView()
            .environmentObject(viewModel)
    }
}

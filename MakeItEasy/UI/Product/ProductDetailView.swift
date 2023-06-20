//
//  ProductDetailView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var viewModel: ProductViewModel
    
    @State private var sources: [String] = []
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                TextField("", text: $viewModel.itemID)
                Spacer()
            }
            TabView {
                ForEach(sources, id: \.self) { link in
                    VStack {
                        AsyncImage(url: URL(string: link)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 350)
                        } placeholder: {
                            ProgressView()
                        }
                        Text(link)
                    }
                }
            }
            .onReceive(viewModel.$itemID) { newItemID in
                print(newItemID, viewModel.sources)
                sources = viewModel.sources
            }
        }
        .tabViewStyle(.page)
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel: ProductViewModel = ProductViewModel(itemID: "585")
        ProductDetailView()
            .environmentObject(viewModel)
    }
}

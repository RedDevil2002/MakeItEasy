//
//  ProductDetailView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct ProductDetailView: View {
    let itemID: String
    let imageLinks: [String]
    
    var body: some View {
        VStack {
            TabView {
                ForEach(imageLinks, id: \.self) { link in
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
            Text(itemID)
        }
        .tabViewStyle(.page)
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(itemID: "531", imageLinks: ["A", "B", "C"])
    }
}

//
//  ContentView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var downloadManager = DownloadManager()
    
    var body: some View {
        Group {
            TabView {
                DocumentView()
                    .tabItem {
                        Image(systemName: "doc.viewfinder.fill")
                            .renderingMode(.template)
                            
                    }
                ProductListView(products: downloadManager.allProducts)
                    .tabItem {
                        Image(systemName: "doc.circle.fill")
                            .renderingMode(.template)
                            
                    }
            }
            .foregroundColor(.primary)
            .tint(.primary)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

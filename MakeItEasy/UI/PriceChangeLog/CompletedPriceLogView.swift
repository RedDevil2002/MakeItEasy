//
//  CompletedPriceLogView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-20.
//

import SwiftUI
import CoreData

struct CompletedPriceLogView: View {
    // ViewContext passed down from the MakeItEasyApp file as an Environment Variable
    @Environment(\.managedObjectContext) var viewContext
    
    @SectionedFetchRequest<Optional<String>, Product>(
        sectionIdentifier: \.brand,
        sortDescriptors: [SortDescriptor(\.brand)]
    )
    private var products: SectionedFetchResults<Optional<String>, Product>
    
    var body: some View {
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
        .navigationTitle(Text("Completed"))
    }
}

struct CompletedPriceLogView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedPriceLogView()
    }
}

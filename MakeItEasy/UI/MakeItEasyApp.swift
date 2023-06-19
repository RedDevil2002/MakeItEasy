//
//  MakeItEasyApp.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

@main
struct MakeItEasyApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PriceChangeLogView()
            }
        }
    }
}

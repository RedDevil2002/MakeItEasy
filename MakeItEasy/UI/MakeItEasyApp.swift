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
            TabView {
                NavigationView {
                    PriceChangeLogView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
                .tabItem {
                    Label {
                        Text("Price Change Log")
                    } icon: {
                        Image(systemName: "tag.circle.fill")
                    }
                }
                
                SettingView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Label {
                            Text("Setting")
                        } icon: {
                            Image(systemName: "gear.circle.fill")
                        }
                    }
            }
        }
    }
}

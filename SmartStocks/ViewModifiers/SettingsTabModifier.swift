//
//  SettingsTabModifier.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-07.
//

import SwiftUI

struct SettingsTabModifier: ViewModifier {
    func body(content: Content) -> some View {
        TabView {
            content
                .tabItem {
                    Label("Watchlist", systemImage: "chart.line.uptrend.xyaxis.circle")
                }
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

extension View {
    func settingsTab() -> some View {
        modifier(SettingsTabModifier())
    }
}

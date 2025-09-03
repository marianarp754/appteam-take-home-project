//
//  ContentView.swift
//  Harvard Art Museum
//
//  Created by Mariana Rodriguez-Pacheco on 8/31/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var exhibitions: [Exhibition]
    @Query private var objects: [Object]
    @State private var vm: ArtViewModel? = nil
    var body: some View {
        NavigationStack {
            TabView {
                ExhibitionView()
                    .tabItem {
                        Label("Browse", systemImage: "photo.artframe")
                    }
                FavoritesView()
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Exhibition.self, Object.self], inMemory: true)
}

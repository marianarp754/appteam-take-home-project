//
//  SearchView.swift
//  Harvard Art Museum
//
//  Created by Mariana Rodriguez-Pacheco on 9/3/25.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var exhibitions: [Exhibition]
    @Query private var objects: [Object]
    @State private var searchText: String = ""
    
    private var filteredExhibitions: [Exhibition] {
        if searchText.isEmpty { return [] }
        return exhibitions.filter { $0.title.contains(searchText) }
    }
    
    private var filteredObjects: [Object] {
        if searchText.isEmpty { return [] }
        return objects.filter { $0.title.contains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if !filteredExhibitions.isEmpty {
                    Section("Exhibitions") {
                        ForEach(filteredExhibitions, id: \.id) { exhibition in
                            NavigationLink(destination: ArtView(exhibition: exhibition)) {
                                Text(exhibition.title)
                            }
                        }
                    }
                }
                if !filteredObjects.isEmpty {
                    Section("Artworks") {
                        ForEach(filteredObjects, id: \.id) { object in
                            NavigationLink(destination: ObjectView(object: object)) {
                                Text(object.title)
                            }
                        }
                    }
                }
                if filteredExhibitions.isEmpty && filteredObjects.isEmpty {
                    Text("No results found")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("Search")
        .searchable(text: $searchText, prompt: "Search for an artwork")
    }
}

#Preview {
    SearchView()
        .modelContainer(for: [Exhibition.self, Object.self], inMemory: true)
}

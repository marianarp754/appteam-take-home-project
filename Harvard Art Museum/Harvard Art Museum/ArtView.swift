//
//  ArtView.swift
//  Harvard Art Museum
//
//  Created by Mariana Rodriguez-Pacheco on 9/2/25.
//

import SwiftUI
import SwiftData

struct ArtView: View {
    let exhibition: Exhibition
    @Environment(\.modelContext) private var modelContext
    @State private var vm: ArtViewModel? = nil
    @Query private var objects: [Object]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(exhibition.title)
                        .font(.title)
                        .bold()
                    Text(exhibition.exhibitionDescription ?? "")
                        .lineLimit(3)
                        .foregroundStyle(.secondary)
                    ForEach(objects, id: \.id) { object in
                        NavigationLink(destination: ObjectView(object: object)) {
                            HStack() {
                                if let urlString = object.primaryimageurl,
                                   let url = URL(string: urlString) {
                                    AsyncImage(url: url) { image in
                                        image.resizable().cornerRadius(10)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 100, height: 100)
                                }
                                VStack(alignment: .leading) {
                                    Text(object.title)
                                        .font(.title3)
                                        .bold()
                                    Text("\(object.people?.first?.name ?? "Unknown"), \(object.datebegin)")
                                        .foregroundStyle(.secondary)
                                    Text(object.objectDescription ?? "")
                                        .lineLimit(4)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .task {
            if vm == nil {
                vm = ArtViewModel(service: ArtService(), context: modelContext)
                await vm?.getAllObjects(exhibitionID: exhibition.id)
                try? modelContext.save()
            }
        }
    }
}

#Preview {
    let mockExhibition = Exhibition(
        id: 1,
        title: "Dog",
        exhibitionDescription: "A description of a dog.",
        begindate: "2024-01-01",
        enddate: "2024-06-01",
        primaryimageurl: "https://hips.hearstapps.com/hmg-prod/images/dog-puppy-on-garden-royalty-free-image-1586966191.jpg?crop=0.752xw:1.00xh;0.175xw,0&resize=1200:*",
        objects: []
    )
    ArtView(exhibition: mockExhibition)
        .modelContainer(for: [Exhibition.self, Object.self], inMemory: true)
}

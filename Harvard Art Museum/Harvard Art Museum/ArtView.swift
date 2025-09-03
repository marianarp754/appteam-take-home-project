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
    @Query private var allObjects: [Object]
    private var objects: [Object] {
        allObjects.filter { $0.exhibitionID == exhibition.id }
    }
    
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
                                ZStack(alignment: .topTrailing) {
                                    if let urlString = object.primaryimageurl,
                                       let url = URL(string: urlString) {
                                        AsyncImage(url: url) { image in
                                            image.resizable().cornerRadius(10)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 100, height: 100)
                                    }
                                    Button(action: {
                                        object.isFavorited.toggle()
                                        try? modelContext.save()
                                    }) {
                                        Image(systemName: object.isFavorited ? "heart.fill" : "heart")
                                            .font(.caption)
                                            .padding(5)
                                            .background(Color.white)
                                            .foregroundColor(.red)
                                            .clipShape(Circle())
                                    }
                                    .offset(x: -10, y: 10)
                                }
                                VStack(alignment: .leading) {
                                    Text(object.title)
                                        .foregroundStyle(.black)
                                        .font(.title3)
                                        .bold()
                                    Text("\(object.people?.first?.name ?? "Unknown"), \(object.datebegin)")
                                        .foregroundStyle(.gray)
                                    Text(object.objectDescription ?? "")
                                        .lineLimit(4)
                                        .foregroundStyle(.gray)
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

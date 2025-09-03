//
//  ObjectView.swift
//  Harvard Art Museum
//
//  Created by Mariana Rodriguez-Pacheco on 9/2/25.
//

import SwiftUI
import SwiftData

struct ObjectView: View {
    let object: Object
    @Environment(\.modelContext) private var modelContext
    @State private var vm: ArtViewModel? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            if let urlString = object.primaryimageurl,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable().cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 250)
            }
            HStack {
                Text(object.title)
                    .font(.title)
                    .bold()
                Spacer()
                Image(systemName: "heart")
            }
            Text("Artist(s):")
                .bold()
            if let people = object.people {
                ForEach(people, id: \.id) { person in
                    Text("• \(person.name ?? "Unknown") (\(person.displaydate ?? "Uknown"))")
                }
            }
            Text("Date: ").bold() + Text("\(object.datebegin ?? 0)")
            Text("Medium: ").bold() + Text("\(object.medium ?? "Unknown")")
            Text("Dimensions: ").bold() + Text("\(object.dimensions ?? "Unknown")")
            Text("Description: ").bold() + Text("\(object.objectDescription ?? "No description")")
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding()
        .task {
            if vm == nil {
                vm = ArtViewModel(service: ArtService(), context: modelContext)
            }
        }
    }
}

#Preview {
    let mockObject = Object(
        id: 1,
        title: "Dog",
        primaryimageurl: "https://hips.hearstapps.com/hmg-prod/images/dog-puppy-on-garden-royalty-free-image-1586966191.jpg?crop=0.752xw:1.00xh;0.175xw,0&resize=1200:*",
        people: [Person(id: 2, name: "Mariana", displaydate: "2004-present")],
        objectDescription: "A description of a dog.",
        exhibitionID: 1,
        datebegin: 2020,
        medium: "Photograph",
        dimensions: "4x4",
    )
    ObjectView(object: mockObject)
        .modelContainer(for: [Exhibition.self, Object.self], inMemory: true)
}

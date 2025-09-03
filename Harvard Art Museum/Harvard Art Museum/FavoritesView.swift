//
//  FavoritesView.swift
//  Harvard Art Museum
//
//  Created by Mariana Rodriguez-Pacheco on 9/3/25.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Object> { $0.isFavorited == true }) private var objects: [Object]
    @Query private var exhibitions: [Exhibition]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if objects.isEmpty {
                    VStack {
                        Spacer()
                        Text("You have no favorited artworks.")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
                else {
                    VStack(alignment: .leading) {
                        ForEach(objects, id: \.id) { object in
                            VStack(alignment: .leading) {
                                if let exhibition = exhibitions.first(where: { $0.id == object.exhibitionID }) {
                                    Text(exhibition.title)
                                        .font(.title2)
                                        .bold()
                                        .padding(.bottom, 5)
                                }
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
                                            Text("\(object.people?.first?.name ?? "Unknown"), \(object.datebegin ?? 0)")
                                                .foregroundStyle(.gray)
                                            Text(object.objectDescription ?? "")
                                                .lineLimit(4)
                                                .foregroundStyle(.gray)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.bottom, 10)
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
        .padding()
    }
}

#Preview {
    FavoritesView()
        .modelContainer(for: [Exhibition.self, Object.self], inMemory: true)
}

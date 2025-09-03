//
//  ExhibitionView.swift
//  Harvard Art Museum
//
//  Created by Mariana Rodriguez-Pacheco on 9/3/25.
//

import SwiftUI
import SwiftData

struct ExhibitionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var exhibitions: [Exhibition]
    @Query private var objects: [Object]
    @State private var vm: ArtViewModel? = nil
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(exhibitions, id: \.id) { exhibition in
                    NavigationLink(destination: ArtView(exhibition: exhibition)) {
                        VStack(alignment: .leading) {
                            if let urlString = exhibition.primaryimageurl,
                               let url = URL(string: urlString) {
                                AsyncImage(url: url) { image in
                                    image.resizable().cornerRadius(10)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(height: 150)
                            }
                            HStack {
                                Text(exhibition.title)
                                    .foregroundStyle(.black)
                                    .font(.title2)
                                    .lineLimit(1)
                                    .bold()
                                Spacer()
                                Text("\(formatDate(dateString: exhibition.begindate)) - \(formatDate(dateString: exhibition.enddate))")
                                    .foregroundStyle(.grey)
                                    .bold()
                            }
                            Text(exhibition.exhibitionDescription ?? "")
                                .foregroundStyle(.grey)
                                .lineLimit(3)
                        }
                    }
                }
            }
            .navigationTitle("Browse")
        }
        .padding()
        .task {
            if vm == nil {
                vm = ArtViewModel(service: ArtService(), context: modelContext)
                await vm?.getAllExhibitions()
                try? modelContext.save()
            }
        }
    }
    func formatDate(dateString: String?) -> String {
        guard let dateString = dateString else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            return date.formatted(.dateTime.month().day())
        }
        return ""
    }
}

#Preview {
    ExhibitionView()
}

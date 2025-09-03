//
//  Service.swift
//  Harvard Art Museum
//
//  Created by Mariana Rodriguez-Pacheco on 8/31/25.
//

import Foundation

class ArtService {
    private let apiKey = "41b28788-b331-431d-a370-1c571f2ce66d"
    private let baseURL = "https://api.harvardartmuseums.org"
    
    func getExhibitions(page: Int = 1, size: Int = 10) async throws -> [Exhibition] {
        let urlString = "\(baseURL)/exhibition?apikey=\(apiKey)&size=\(size)&page=\(page)&hasimage=1"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(ExhibitionAPIResponse.self, from: data)
        var exhibitions: [Exhibition] = []
        for record in response.records {
            let objects = try? await getObjects(exhibitionID: record.id)
            let exhibition = Exhibition (
                id: record.id,
                title: record.title,
                exhibitionDescription: record.description,
                begindate: record.begindate,
                enddate: record.enddate,
                primaryimageurl: record.primaryimageurl,
                objects: objects
            )
            exhibitions.append(exhibition)
        }
        return exhibitions
    }
    
    func getObjects(page: Int = 1, size: Int = 10, exhibitionID: Int) async throws -> [Object] {
        let urlString = "\(baseURL)/object?apikey=\(apiKey)&size=\(size)&page=\(page)&exhibition=\(exhibitionID)&hasimage=1"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(ObjectAPIResponse.self, from: data)
        var objects: [Object] = []
        for record in response.records {
            let info = try? await getObject(objectID: record.id)
            let object = Object (
                id: record.id,
                title: record.title,
                primaryimageurl: record.primaryimageurl,
                people: record.people,
                objectDescription: info?.description,
                exhibitionID: exhibitionID,
                datebegin: info?.datebegin,
                medium: info?.medium,
                dimensions: info?.dimensions,
            )
            objects.append(object)
        }
        return objects
    }
    
    func getObject(objectID: Int) async throws -> ObjectInfo {
        let urlString = "\(baseURL)/object/\(objectID)?apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(ObjectInfo.self, from: data)
        return response
    }
}

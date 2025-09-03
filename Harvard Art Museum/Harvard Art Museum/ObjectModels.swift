//
//  ArtObjectModels.swift
//  Harvard Art Museum
//
//  Created by Mariana Rodriguez-Pacheco on 8/31/25.
//

import Foundation
import SwiftData

@Model
final class Object {
    var id: Int
    var title: String
    var primaryimageurl: String?
    var people: [Person]?
    var objectDescription: String?
    var exhibitionID: Int
    var datebegin: Int?
    var medium: String?
    var dimensions: String?
    var isFavorited: Bool
    
    init(id: Int, title: String, primaryimageurl: String?, people: [Person]?, objectDescription: String?, exhibitionID: Int, datebegin: Int?, medium: String?, dimensions: String?) {
        self.id = id
        self.title = title
        self.primaryimageurl = primaryimageurl
        self.people = people
        self.objectDescription = objectDescription
        self.exhibitionID = exhibitionID
        self.datebegin = datebegin
        self.medium = medium
        self.dimensions = dimensions
        self.isFavorited = false
    }
}

struct ObjectAPIResponse: Codable {
    let info: Info
    let records: [ObjectResponse]
}

struct Info: Codable {
    let totalrecords: Int
    let page: Int
}

struct Person: Codable {
    let id: Int
    let name: String?
    let displaydate: String?
}

struct ObjectResponse: Codable {
    let id: Int
    let title: String
    let dated: String?
    let primaryimageurl: String?
    let people: [Person]?
    let description: String?
}

struct ObjectInfo: Codable {
    let datebegin: Int
    let medium: String
    let dimensions: String
    let description: String?
}

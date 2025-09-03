//
//  ExhibitionModels.swift
//  Harvard Art Museum
//
//  Created by Mariana Rodriguez-Pacheco on 9/2/25.
//

import Foundation
import SwiftData

@Model
final class Exhibition {
    var id: Int
    var title: String
    var exhibitionDescription: String?
    var begindate: String?
    var enddate: String?
    var primaryimageurl: String?
    var objects: [Object]?
    
    init(id: Int, title: String, exhibitionDescription: String?, begindate: String?, enddate: String?, primaryimageurl: String?, objects: [Object]?) {
        self.id = id
        self.title = title
        self.exhibitionDescription = exhibitionDescription
        self.begindate = begindate
        self.enddate = enddate
        self.primaryimageurl = primaryimageurl
        self.objects = objects
    }
}

struct ExhibitionAPIResponse: Codable {
    let info: Info
    let records: [ExhibitionResponse]
}

struct ExhibitionResponse: Codable {
    var id: Int
    var title: String
    var description: String?
    var begindate: String?
    var enddate: String?
    var primaryimageurl: String?
}

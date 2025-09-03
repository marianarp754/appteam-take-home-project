//
//  ViewModel.swift
//  Harvard Art Museum
//
//  Created by Mariana Rodriguez-Pacheco on 8/31/25.
//

import Foundation
import SwiftData

@Observable
class ArtViewModel: ObservableObject {
    var allObjects: [Object] = []
    var allExhibitions: [Exhibition] = []
    var oneObject: ObjectInfo?
    var errorMessage: String? = nil
    let service: ArtService
    let context: ModelContext
    
    required init(service: ArtService, context: ModelContext) {
        self.service = service
        self.context = context
    }
    
    func getAllExhibitions() async {
        do {
            allExhibitions = try await service.getExhibitions()
            let existingExhibitions = try context.fetch(FetchDescriptor<Exhibition>())
            for exhibition in allExhibitions {
                if !existingExhibitions.contains(where: { $0.id == exhibition.id }) {
                    context.insert(exhibition)
                }
            }
            try context.save()
            errorMessage = nil
        } catch {
            errorMessage = "Failed to fetch exhibitions: \(error)"
        }
    }
    
    func getAllObjects(exhibitionID: Int) async {
        do {
            allObjects = try await service.getObjects(exhibitionID: exhibitionID)
            if let exhibitionIndex = allExhibitions.firstIndex(where: { $0.id == exhibitionID }) {
                allExhibitions[exhibitionIndex].objects = allObjects
            }
            let existingObjects = try context.fetch(FetchDescriptor<Object>())
            for object in allObjects {
                if !existingObjects.contains(where: { $0.id == object.id }) {
                    context.insert(object)
                }
            }
            try context.save()
            errorMessage = nil
        } catch {
            errorMessage = "Failed to fetch objects: \(error)"
        }
    }
}

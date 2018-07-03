//
//  SelfiStore.swift
//  selfiegram
//
//  Created by Yevgeniy Skroznikov on 7/3/18.
//  Copyright © 2018 Yevgeniy Skroznikov. All rights reserved.
//

import Foundation
import UIKit.UIImage

// Selfie class to hold the image data

class Selfie : Codable {
    let created : Date
    let id : UUID
    var title = "New Selfie!"
    
    var image : UIImage? {
        get
        {
            return SelfieStore.shared.getImage(id: self.id)
        }
        set
        {
            try? SelfieStore.shared.setImage(id: self.id, image: newValue)
        }
    }
    
    init(title: String){
        self.title = title
        self.created = Date()
        self.id = UUID()
    }
}

enum SelfieStoreError : Error {
    case cannotSaveImage(UIImage?)
}

final class SelfieStore{
    static let shared = SelfieStore()
    private var imageCache : [UUID : UIImage] = [:]
    
    var documentsFolder : URL {
        return FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!
    }
    
    func getImage(id: UUID) -> UIImage? {
        // id - unique id of the image
        // returns the found image if there is one
        // will be cached into memory for future use
        if let image = imageCache[id] {
            return image
        }
        
        let imageURL = documentsFolder.appendingPathComponent("\(id.uuidString)-image.jpg")
        
        guard let imageData = try? Data(contentsOf: imageURL) else {
            return nil
        }
        
        guard let image = UIImage(data: imageData) else {
            return nil
        }
        
        imageCache[id] = image
        
        return image
    }
    
    func setImage(id: UUID, image: UIImage?) throws {
        // saves image to disk with an associated id
        let fileName = "\(id.uuidString)-image.jpg"
        let destinationURL = documentsFolder.appendingPathComponent(fileName)
        
        if let image = image {
            guard let data = UIImageJPEGRepresentation(image, 0.9) else {
                throw SelfieStoreError.cannotSaveImage(image)
            }
            
            try data.write(to: destinationURL)
        }
        else {
            try FileManager.default.removeItem(at: destinationURL)
        }
        
        imageCache[id] = image
    }
    
    func listSelfies() throws -> [Selfie] {
        // returns an array of Selfies
        let contents = try FileManager.default.contentsOfDirectory(at: self.documentsFolder, includingPropertiesForKeys: nil)
        
        return try contents.filter{ $0.pathExtension == "json"}
            .map{ try Data(contentsOf: $0) }
            .map{ try JSONDecoder().decode(Selfie.self, from: $0) }
        
    }
    
    func delete(selfie: Selfie) throws {
        // deletes a selfie from the store
        try delete(id: selfie.id)
    }
    
    func delete(id: UUID) throws {
        let selfieDataFileName = "\(id.uuidString).json"
        let imageFileName = "\(id.uuidString)-image.jpg"
        let selfieDataURL = self.documentsFolder.appendingPathComponent(selfieDataFileName)
        let imageURL = self.documentsFolder.appendingPathComponent(imageFileName)
        
        if FileManager.default.fileExists(atPath: selfieDataURL.path) {
            try FileManager.default.removeItem(at: selfieDataURL)
        }
        
        if FileManager.default.fileExists(atPath: imageURL.path) {
            try FileManager.default.removeItem(at: imageURL)
        }
        
        imageCache[id] = nil
    }
    
    func load(id: UUID) -> Selfie? {
        let image
    }
    
    func save(selfie: Selfie) throws {
        // attempts to save the selfie to disk
        // throws an error if not possible
        throw SelfieStoreError.cannotSaveImage(nil)
    }
}


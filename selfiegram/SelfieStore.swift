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
    
    /*
    var image : UIImage?{
        get{
            //return SelfieStore
        }
        set{
            
        }
    }*/

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
    
    func getImage(id: UUID) -> UIImage? {
        // id - unique id of the image
        // returns the found image if there is one
        // will be cached into memory for future use
        return nil
    }
    
    func setImage(id: UUID, image: UIImage?) throws {
        // saves image to disk with an associated id
        throw SelfieStoreError.cannotSaveImage(image)
    }
    
    func listSelfies() throws -> [Selfie] {
        // returns an array of Selfies
        return []
    }
    
    func delete(selfie: Selfie) throws {
        // deletes a selfie from the store
        throw SelfieStoreError.cannotSaveImage(nil)
    }
    
    func load(id: UUID) throws -> Selfie? {
        return nil
    }
    
    func save(selfie: Selfie) throws {
        // attempts to save the selfie to disk
        // throws an error if not possible
        throw SelfieStoreError.cannotSaveImage(nil)
    }
}


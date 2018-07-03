//
//  SelfieStoreTests.swift
//  selfiegramTests
//
//  Created by Yevgeniy Skroznikov on 7/3/18.
//  Copyright © 2018 Yevgeniy Skroznikov. All rights reserved.
//

import XCTest

@testable import selfiegram
import UIKit

class SelfieStoreTests: XCTestCase {
    
    func createImage(text: String) -> UIImage {
        // creates an image and returns that image
        UIGraphicsBeginImageContext(CGSize(width: 100, height: 100))
        defer {
            UIGraphicsEndImageContext()
        }
        
        // create a label
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.font = UIFont.systemFont(ofSize: 50)
        label.text = text
        label.drawHierarchy(in: label.frame, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func testCreatingSelfie() {
        let selfieTitle = "Creation Test Selfie"
        // create new selfie
        let newSelfie = Selfie(title: selfieTitle)
        
        // try to save the file
        try? SelfieStore.shared.save(selfie: newSelfie)
        
        // get all selfies
        let allSelfies = try! SelfieStore.shared.listSelfies()
        
        // try to find the selfie we created
        guard let theSelfie = allSelfies.first(where: {$0.id == newSelfie.id}) else {
            XCTFail("Selfies should contain the image we created.")
            return
        }
        
        XCTAssertEqual(selfieTitle, theSelfie.title)
    }
    
    func testSavingImage() throws {
        let selfieTitle = "Saving Test Selfie"
        let newSelfie = Selfie(title: selfieTitle)
        
        newSelfie.image = createImage(text: selfieTitle)
        try SelfieStore.shared.save(selfie: newSelfie)
        
        let loadedImage = SelfieStore.shared.getImage(id: newSelfie.id)
        
        XCTAssertNotNil(loadedImage, "The image should be loaded.")
    }
    
    func testLoadingSelfie() throws {
        let selfieTitle = "Loading Test Selfie"
        let newSelfie = Selfie(title: selfieTitle)
        try SelfieStore.shared.save(selfie: newSelfie)
        
        let loadedSelfie = SelfieStore.shared.load(id: newSelfie.id)
        XCTAssertNotNil(loadedSelfie, "The selfie should not be nil.")
        XCTAssertEqual(loadedSelfie?.id, newSelfie.id, "The selfies should have the same id.")
        XCTAssertEqual(loadedSelfie?.title, newSelfie.title, "The selfies should have the same title.")
        XCTAssertEqual(loadedSelfie?.created, newSelfie.created, "The selfies should have the same creation date.")
    }
    
    func testDeletingSelfie() throws {
        let selfieTitle = "Deleting Test Selfie"
        let newSelfie = Selfie(title: selfieTitle)
        try SelfieStore.shared.save(selfie: newSelfie)
        
        let allSelfies = try SelfieStore.shared.listSelfies()
        try SelfieStore.shared.delete(selfie: newSelfie)
        let selfiestAfterDelete = try SelfieStore.shared.listSelfies()
        let loadedSelfie = SelfieStore.shared.load(id: newSelfie.id)
        XCTAssertEqual(allSelfies.count - 1, selfiestAfterDelete.count, "Should be one less selfie after delete.")
        XCTAssertNil(loadedSelfie, "Loading selfie after delete should return nil")
    }
}

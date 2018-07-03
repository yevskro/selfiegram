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
        let newSelfie = Selfie(title: selfieTitle)
        
        do{
            try SelfieStore.shared.save(selfie: newSelfie)
        } catch SelfieStoreError.cannotSaveImage(nil) {
            XCTFail("Could not save image.")
        } catch {
            XCTFail("Unknown error.")
        }
        
        let allSelfies = try! SelfieStore.shared.listSelfies()
        
        guard let theSelfie = allSelfies.first(where: {$0.id == newSelfie.id}) else {
            XCTFail("Selfies should contain the image we created.")
            return
        }
        
        XCTAssertEqual(selfieTitle, theSelfie.title)
    }
}

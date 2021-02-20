//
//  ImageProcessor.swift
//  CyperPunkMatrix
//
//  Created by Muhammad Abed on 06/02/2021.
//  Copyright © 2021 Trax. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ImageProcessor {
    
    let image : UIImage
    
    init(image : UIImage) {
        
        self.image = image
    }
    
    
    func getText( completionHandler : @escaping ([String]?) -> Void ) {
        
        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: self.image.cgImage!)

        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completionHandler(nil)
                return
            }
            let recognizedStrings = observations.compactMap { observation in
                // Return the string of the top VNRecognizedText instance.
                return observation.topCandidates(1).first?.string
            }
            
            print(recognizedStrings)
            completionHandler(recognizedStrings)
        }

        do {
            try requestHandler.perform([request])
        } catch {
            completionHandler(nil)
            print("Unable to perform the requests: \(error).")
        }
    }
  

}

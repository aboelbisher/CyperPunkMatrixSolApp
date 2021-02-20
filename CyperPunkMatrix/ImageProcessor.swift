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

  func getTextStam( completionHandler : @escaping ([CyperMatrixNode]?) -> Void ) {

    // Create a new image-request handler.
    let requestHandler = VNImageRequestHandler(cgImage: self.image.cgImage!)

    // Create a new request to recognize text.
    let request = VNRecognizeTextRequest { (request, error) in
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            completionHandler(nil)
            return
        }


      var cyperMatrixNodes = [CyperMatrixNode]()
      for observation in observations {

        guard let candidate = observation.topCandidates(1).first else { return }

        // Find the bounding-box observation for the string range.
        let stringRange = candidate.string.startIndex..<candidate.string.endIndex
        let boxObservation = try? candidate.boundingBox(for: stringRange)




        // Get the normalized CGRect value.
        let boundingBox = boxObservation?.boundingBox ?? .zero

        let newBounding = CGRect(x: boundingBox.origin.x * self.image.size.width,
                                 y: boundingBox.origin.y * self.image.size.height,
                                 width: boundingBox.width * self.image.size.width,
                                 height: boundingBox.height * self.image.size.height)


//        let node = CyperMatrixNode(string: candidate.string,
//                                   realLocation: VNImageRectForNormalizedRect(boundingBox,
//                                                                              Int(self.image.size.width * self.image.scale),
//                                                                              Int(self.image.size.height * self.image.scale)))
        let node = CyperMatrixNode(string: candidate.string,
                                   realLocation:newBounding)

        cyperMatrixNodes.append(node)

      }


      completionHandler(cyperMatrixNodes)

    }

    do {
        try requestHandler.perform([request])
    } catch {
        completionHandler(nil)
        print("Unable to perform the requests: \(error).")
    }
}


  func getMatrixText( completionHandler : @escaping ([CyperMatrixNode]?) -> Void ) {

      // Create a new image-request handler.
      let requestHandler = VNImageRequestHandler(cgImage: self.image.cgImage!)


    

      // Create a new request to recognize text.
      let request = VNRecognizeTextRequest { (request, error) in
          guard let observations = request.results as? [VNRecognizedTextObservation] else {
              completionHandler(nil)
              return
          }




        var cyperMatrixNodes = [CyperMatrixNode]()
        for obsertvation in observations {
          guard let candidate = obsertvation.topCandidates(1).first else {
            continue
          }
          let charsArr = candidate.string.split(separator: " ").map {String($0)}


//          for i in 0 ..< candidate.string.count {
//
//            let index = candidate.string.startIndex
//            let bla = candidate.string[i]
//
//
//          }

//          var index = candidate.string.index(candidate.string.startIndex, offsetBy: <#T##String.IndexDistance#>)
          var index = 0

          for char in charsArr {
            let startIndex = candidate.string.index(candidate.string.startIndex, offsetBy: index)
            let offsetAdd = min(index + 3, candidate.string.count)
            let endIndex = candidate.string.index(candidate.string.startIndex, offsetBy: offsetAdd)
            let range : Range = startIndex..<endIndex

            do {
              if let location = try candidate.boundingBox(for: range) {

                let imageBoundingBox = VNImageRectForNormalizedRect(location.boundingBox,
                                                                    Int(self.image.size.width * self.image.scale),
                                                                    Int(self.image.size.height * self.image.scale))
                let cyperMatrixNode = CyperMatrixNode(string: char, realLocation: imageBoundingBox)
                cyperMatrixNodes.append(cyperMatrixNode)
              }
            } catch let err {
              print(err)
            }
            index += 3
          }

        }

        completionHandler(cyperMatrixNodes)


//            let recognizedStrings = observations.compactMap { observation in
//                // Return the string of the top VNRecognizedText instance.
//                return observation.topCandidates(1).first?.string
//            }
//
//
//            print(recognizedStrings)
//            completionHandler(recognizedStrings)
      }

      do {
          try requestHandler.perform([request])
      } catch {
          completionHandler(nil)
          print("Unable to perform the requests: \(error).")
      }
  }

}


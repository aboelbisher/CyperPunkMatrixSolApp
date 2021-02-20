//
//  ImageDraw.swift
//  CyperPunkMatrix
//
//  Created by Muhammad Elrazek on 20/02/2021.
//  Copyright © 2021 Trax. All rights reserved.
//

import Foundation
import UIKit

class ImageDraw {

  static func getDrawedImage(image : UIImage, sequence : [CyperMatrixNode], invertUp :  Bool = true) -> UIImage {

    var newSeq = [CGRect]()

    if (invertUp) {
      for val in sequence {
        var newVal = val.realLocation
        newVal.origin.y = (image.size.height - (val.realLocation.origin.y + val.realLocation.height))
        newSeq.append(newVal)
      }
    } else {
      newSeq = sequence.map {$0.realLocation}
    }

    UIGraphicsBeginImageContext(image.size)

    image.draw(at: CGPoint.zero)
    let context = UIGraphicsGetCurrentContext()!

    for i in 0 ..< newSeq.count {
      let val = newSeq[i]
      // Draw a transparent green Circle
      context.setStrokeColor(UIColor.green.cgColor)
      context.setAlpha(0.5)
      context.setLineWidth(10.0)
      context.addEllipse(in: val)
      context.drawPath(using: .stroke)

      UIGraphicsPushContext(context)
      let fontSize = CGFloat(130)
        let font = UIFont.systemFont(ofSize: fontSize)
      let string = NSAttributedString(string: "\(i)", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : UIColor.white])
      string.draw(at: CGPoint(x: val.origin.x + val.width / 2   , y: val.origin.y + val.height / 2 ))
      UIGraphicsPopContext()

    }

    let myImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return myImage!

  }
}

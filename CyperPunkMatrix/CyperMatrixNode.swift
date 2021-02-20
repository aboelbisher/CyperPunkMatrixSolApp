//
//  CyperMatrixNode.swift
//  CyperPunkMatrix
//
//  Created by Muhammad Elrazek on 20/02/2021.
//  Copyright © 2021 Trax. All rights reserved.
//

import UIKit
import Vision

struct CyperMatrixNode {
  var string : String
  let realLocation : CGRect
}


extension Array where Element == CyperMatrixNode {

  func print(width : Int) {

    var counter = 0
    var line = ""

    for node in self {
      line.append("\(node.string) ")
      counter += 1
      if (counter == width) {
        Swift.print(line)
        line = ""
      }
    }
  }
}


extension Array where Element == [CyperMatrixNode] {



  func getString() -> String {
    var finalStr = ""
    for row in self {
      var line = ""
      for node in row {
        line += "\(node.string) "
      }
      finalStr += "\(line)\n"
    }
    return finalStr

  }
}


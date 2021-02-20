//
//  TextToMatrix.swift
//  CyperPunkMatrix
//
//  Created by Muhammad Abed on 06/02/2021.
//  Copyright © 2021 Trax. All rights reserved.
//

import Foundation


class TextToMatrix {
    
    static func getMatrix(fromText : [String], width : Int, lineDelimeter : Character = " ") -> [[String]] {
        
        let matrix = fromText.map { (str) -> [String] in
            
            str.split(separator: lineDelimeter).map {String($0)}
        }
        
        var newLine = [String]()
        var retValue = [[String]]()
        for line in matrix {
            for char in line {
                newLine.append(char)
                if (newLine.count == width) {
                    retValue.append(newLine)
                    newLine.removeAll()
                }
            }
        }
        return retValue
        
    }

  static func getMatrix(fromArr : [CyperMatrixNode], width : Int, lineDelimeter : Character = " ") -> [[CyperMatrixNode]] {

      var newLine = [CyperMatrixNode]()
      var retValue = [[CyperMatrixNode]]()
      for line in fromArr {
        newLine.append(line)
        if (newLine.count == width) {
          retValue.append(newLine)
          newLine.removeAll()
        }
      }
      return retValue

  }

    
    static func getSequence(fromText : [String], lineDelimeter : Character = " ") -> [[String]] {
        
        return fromText.map { (str) -> [String] in
            str.split(separator: lineDelimeter).map {String($0)}
        }
    }
    
    
    
    
}

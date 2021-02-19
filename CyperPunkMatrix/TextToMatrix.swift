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
        
//        var isLegalMatrix = false
//
//        var dic = [Int : Int]() //[lineCount : numberOfOccurences]
//
//        for val in matrix {
//            let count = val.count
//            if let _dicCount = dic[count] {
//                dic[count] = _dicCount + 1
//            } else {
//                dic[count] = 1
//            }
//        }
//
//        if (dic.keys.count > 1) { // error in matrix
//
//            var maxOccurences = 0
//
//            for (_, numberOfOccurences) in dic {
//                if numberOfOccurences > maxOccurences {
//                    maxOccurences = numberOfOccurences
//                }
//            }
//            // matrix lines should be maxOccurences
//            var newMatrix = [[String]]()
//            var count = 0
//            var newLine = [String]()
//            for line in matrix {
//                for char in line {
//                    count += 1
//                    newLine.append(char)
//                    if count % maxOccurences == 0 {
//                        if (newLine.count > 0) {
//                            newMatrix.append(newLine)
//                            newLine.removeAll()
//                        }
//                    }
//                }
//            }
//            return newMatrix
//        } else {
//
//            return matrix
//        }
    }
    
    static func getSequence(fromText : [String], lineDelimeter : Character = " ") -> [[String]] {
        
        return fromText.map { (str) -> [String] in
            str.split(separator: lineDelimeter).map {String($0)}
        }
    }
    
    
    
    
}

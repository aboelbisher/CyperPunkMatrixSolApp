//
//  CyperMatrixSol.swift
//  CyperPunkMatrix
//
//  Created by Muhammad Abed on 06/02/2021.
//  Copyright © 2021 Trax. All rights reserved.
//

import Foundation


class CyperMatrixSol {

  private let matrix : [[String]]
  private let goalSequences : [[String]]
  private let bufferSize : Int

  private let VISITED = "-1"

  private var maxSequenceIndexes : [Int] = []
  private var maxSequence : [String] = []
  private var maxSequenceWeight = -1

  init (matrix : [[String]], sequences : [[String]], bufferSize : Int) {

      self.matrix = matrix
      self.goalSequences = sequences
      self.bufferSize = bufferSize
  }

  func solve() -> ([String], [Int]) {

    checkAllPossible(matrix: matrix,
                     isRow: true, index: 0, iteration: 0, maxIterations: bufferSize, sequenceIndexes: [], sequence: [])

    return (maxSequence, maxSequenceIndexes)
  }


  private func evaluateSequence(sequence : [String]) -> Int {

    var weight = 0
    var counts = [Int : Bool]()
    var seqDic = [[String] : Int]() //[sequence : weight]
    for i in 0 ..< goalSequences.count {
      let seq = goalSequences[i]
      counts[seq.count] = true
      seqDic[seq] = i + 1
    }

    for cnt in counts.keys {

      var startWord = Array(sequence.prefix(cnt))
      weight += getWeightAndRemove(dic: &seqDic, seq: startWord)
      var startIndex = 1
      var endIndex = cnt
      while endIndex < sequence.count && seqDic.count > 0 {
        startWord.removeFirst()
        startWord.append(sequence[endIndex])
        weight += getWeightAndRemove(dic: &seqDic, seq: startWord)
        startIndex += 1
        endIndex += 1
      }
    }

    return weight
  }

  private func getWeightAndRemove(dic : inout [[String] : Int], seq : [String]) -> Int {

    if let _value = dic[seq] {
      dic.removeValue(forKey: seq)
      return _value
    }
    return 0
  }


  func checkAllPossible(matrix : [[String]], isRow : Bool, index : Int, iteration : Int, maxIterations : Int, sequenceIndexes : [Int], sequence : [String]) {
    if (iteration == maxIterations) {
      let seqWeight = evaluateSequence(sequence: sequence)
      if (seqWeight > maxSequenceWeight) {
        maxSequenceWeight = seqWeight
        maxSequence = sequence
        maxSequenceIndexes = sequenceIndexes
      }
      return
    }

    let width = matrix[0].count
    let height = matrix.count

    for i in 0 ..< (isRow ? width : height) {

      var value = ""
      var newMatrix = matrix
      if (isRow) {
        value = matrix[index][i]
        newMatrix[index][i] = VISITED
      } else {
        value = matrix[i][index]
        newMatrix[i][index] = VISITED
      }
      if (value == VISITED) {continue}
      var newSequence = sequence
      newSequence.append(value)
      var newSequenceIndexes = sequenceIndexes
      newSequenceIndexes.append(i)
      checkAllPossible(matrix: newMatrix, isRow: !isRow, index: i,
                       iteration: iteration + 1, maxIterations: maxIterations, sequenceIndexes: newSequenceIndexes, sequence : newSequence)
    }
  }
}

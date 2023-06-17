//
//  Equation.swift
//  SuperBMathTest
//
//  Created by Zachary Gomez on 6/13/23.
//

import Foundation

enum Operator {
    
    case plus
    case minus
    
}

struct SimpleEquation {
    
    enum Constants {
        
        static let maxOperandValue: Int = 20
        
    }
    
    var op: Operator
    var operands: [Int] = {  [Int.random(in: (0...Constants.maxOperandValue)),
                              Int.random(in: (0...Constants.maxOperandValue))] }()
    
    init(op: Operator = .plus) {
        self.op = op
    }
    
}

extension SimpleEquation {
    
    var answer: Int { operands.reduce(0, +) }
    
}

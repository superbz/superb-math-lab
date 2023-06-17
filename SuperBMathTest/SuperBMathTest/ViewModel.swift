//
//  ViewModel.swift
//  SuperBMathTest
//
//  Created by Zachary Gomez on 6/13/23.
//

import Foundation

class ViewModel {
    
    enum Constants {
        
        static let totalNumberOfEquations: Int = Int.random(in: 3...10)
        
    }
    
    private let equations: [SimpleEquation]
    
    let numberOfEquations: Int = Constants.totalNumberOfEquations
    var currentIndex: Int = 0
    var correctAnswers: Int = 0
    
    init(equations: [SimpleEquation]) {
        self.equations = equations
        print(equations)
    }
    
}

extension ViewModel {
    
    var currentEquation: SimpleEquation? {
        guard currentIndex >= 0 && currentIndex < equations.count else { return nil }
        
        return equations[currentIndex]
    }
    
    var isComplete: Bool {
        currentEquation == nil
    }
    
    var count: Int {
        equations.count
    }
    
    func correctSolution() {
        defer { currentIndex += 1 }
        
        correctAnswers += 1
    }
    
    func wrongSolution() {
        currentIndex += 1
    }
    
    func check(answer: String?) -> Bool {
        guard let answerString = answer,
              let answer = Int(answerString),
              let equationAnswer = currentEquation?.answer else { return false }
        
        return answer == equationAnswer
    }
    
}

//
//  ViewController.swift
//  SuperBMathTest
//
//  Created by Zachary Gomez on 6/13/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var operandOne: UILabel!
    @IBOutlet weak var operandTwo: UILabel!
    
    @IBOutlet weak var answerBox: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var viewModel: ViewModel? {
        didSet {
            self.load(equation: viewModel?.currentEquation)
        }
    }
    
    var randomEquations: [SimpleEquation] {
        (1...ViewModel.Constants.totalNumberOfEquations).map { _ in SimpleEquation() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModel(equations: randomEquations)
        
        answerBox.keyboardType = .numberPad
        answerBox.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        updateProgress()
    }
    
}

// MARK: Action Handlers

extension ViewController {
    
    @IBAction func checkAnswer(_ sender: Any) {
        guard let viewModel else { return }
        
        handleResults(isCorrect: viewModel.check(answer: answerBox.text))
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard answerBox.text != "" else { submitButton.isEnabled = false; return }
        
        submitButton.isEnabled = true
    }
    
}

extension ViewController {
    
    private func handleResults(isCorrect: Bool) {
        guard let viewModel else { return }
        
        reportSolution(isCorrect: isCorrect)
        
        guard let equation = viewModel.currentEquation else {
            showAlert()
            return
        }
        
        showResult(equation: equation, isCorrect: isCorrect)
    }
    
    private func reportSolution(isCorrect: Bool) {
        guard isCorrect else { viewModel?.wrongSolution(); return }
        
        viewModel?.correctSolution()
    }
    
    private func showAlert() {
        guard let viewModel else { return }
        
        let alert = UIAlertController(title: "📝 Results",
                                      message: viewModel.endGameMessage,
                                      preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.viewModel = ViewModel(equations: self.randomEquations)
        })
        
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showResult(equation: SimpleEquation, isCorrect: Bool) {
        guard let viewModel else { return }
        
        let title = (isCorrect ? " Correct" : "Wrong") + " Answer"
        let alert = UIAlertController(title: title,
                                      message: viewModel.report,
                                      preferredStyle: .actionSheet)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.load(equation: equation)
        })
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func load(equation: SimpleEquation?) {
        guard let equation else { return }
        
        updateProgress()
        
        operandOne.text = "\(equation.operands[0])"
        operandTwo.text = "\(equation.operands[1])"
        answerBox.text = ""
        submitButton.isEnabled = false
    }
    
    private func updateProgress() {
        guard let viewModel else { return }
        
        progressLabel.text = "\(viewModel.currentIndex + 1) / \(viewModel.count)"
    }
    
}

extension ViewController {
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
}

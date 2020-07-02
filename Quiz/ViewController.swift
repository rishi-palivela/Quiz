//
//  ViewController.swift
//  Quiz
//
//  Created by Rishi Palivela on 02/07/20.
//  Copyright © 2020 StarDust. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    @IBOutlet weak var labelEnd: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var optionButtons: [UIButton]!
    
    var CorrectAnswer = String()
    var questions: [Question]!
    var questionOrder: [Int]!  // [1, 5, 7, 3, 9, 2]
    var currentOrderIdx = -1
    var score = 0.0 {
        didSet {
            scoreLabel.text = String(format: "Score: %.2f", score)
        }
    }
    
    var currentQuestionIdx: Int {
        questionOrder[currentOrderIdx]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let url = Bundle.main.url(forResource: "Questions", withExtension: "json")!
            let data = try Data(contentsOf: url)
            questions = try JSONDecoder().decode([Question].self, from: data)
            
            print("Loaded \(questions.count) Questions")
            
            questionOrder = Array(0..<questions.count).shuffled() // { _ in Int(arc4random()) % self.questions.count }
            print(questionOrder)
        } catch {
            fatalError("Unable to read JSON")
        }
        
        optionButtons = [option1, option2, option3, option4]
        
        hide()
        nextQuestion()
        
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byWordWrapping
    }
    
    func nextQuestion(){
        currentOrderIdx += 1
        
        guard currentOrderIdx < questionOrder.count else {
            showScore()
            return
        }
        
        let question = questions[currentQuestionIdx]
        
        questionLabel.text = question.question
        option1.setTitle(question.options[0], for: .normal)
        option2.setTitle(question.options[1], for: .normal)
        option3.setTitle(question.options[2], for: .normal)
        option4.setTitle(question.options[3], for: .normal)
        
    }
    
    func showScore() {
        let alert = UIAlertController(title: "Quiz Completed",
                                      message: String(format: "You have scored %.2f out of %.2f", score, Float(questions.count)),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            self.disableOptions()
        })
        
        self.present(alert, animated: true)
    }
    
    func hide(){
        labelEnd.isHidden = true
        nextButton.isHidden = true
    }
    
    func unHide(){
        labelEnd.isHidden = false
        
        nextButton.isHidden = false
    }
    
    func disableOptions() {
        for option in optionButtons {
            option.isEnabled = false
        }
    }
    
    func showOptions() {
        for option in optionButtons {
            option.backgroundColor = .systemOrange
        }
    }
    
    func showAnswer(correct: Int, selected: Int) {
        for i in 0..<optionButtons.count {
            if i == correct {
                optionButtons[i].backgroundColor = .systemGreen
            } else if i == selected {
                optionButtons[i].backgroundColor = .systemRed
            } else {
                optionButtons[i].backgroundColor = .lightGray
            }
        }
    }
    
    @IBAction func optionTapped(_ sender: UIButton) {
        let question = questions[currentQuestionIdx]
        let selectedOption = question.options.firstIndex(of: sender.titleLabel!.text!)!
        
        if selectedOption == question.correctAns {
            labelEnd.text = "You are Correct"
            score += 1
        } else {
            labelEnd.text = "You are Wrong"
            score -= 1.0/3.0
        }
        
        unHide()
        showAnswer(correct: question.correctAns, selected: selectedOption)
    }
    
    
    @IBAction func Next(_ sender: Any) {
        nextQuestion()
        hide()
        showOptions()
    }
    
}


//
//  ViewController.swift
//  Hangman
//
//  Created by Venkata on 1/19/24.
//

import UIKit

class ViewController: UIViewController {
    var currentAnswer: UITextField!
    var guessWord: UILabel!
    var failed: UILabel!
    
    var words = [String]()
    var newWord = String()
    
    var word = "Pick a Word" {
        didSet {
            guessWord.text = "\(word)"
        }
    }
    var fail = 7 {
        didSet {
            failed.text = "Attempts Left: \(fail)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        // Guess Word Label
        failed = UILabel()
        failed.translatesAutoresizingMaskIntoConstraints = false
        failed.textAlignment = .center
        failed.text = "Attempts Left: \(fail)"  // Dynamically display the word
        failed.layer.borderWidth = 2
        failed.layer.borderColor = UIColor.black.cgColor
        failed.font = UIFont.systemFont(ofSize: 12)
        failed.textColor = UIColor.red
        view.addSubview(failed)
        
        // Guess Word Label
        guessWord = UILabel()
        guessWord.translatesAutoresizingMaskIntoConstraints = false
        guessWord.textAlignment = .center
        guessWord.text = word  // Dynamically display the word
        guessWord.layer.borderWidth = 2
        guessWord.layer.borderColor = UIColor.black.cgColor
        guessWord.font = UIFont.systemFont(ofSize: 36)
        guessWord.textColor = UIColor.red
        view.addSubview(guessWord)
        
        // Current Answer TextField
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Guess Letter"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 24)
        currentAnswer.layer.borderWidth = 2
        currentAnswer.layer.borderColor = UIColor.black.cgColor
        currentAnswer.textColor = UIColor.red
        view.addSubview(currentAnswer)
        
        // new word Button
        let newWord = UIButton(type: .system)
        newWord.translatesAutoresizingMaskIntoConstraints = false
        newWord.setTitle("Pick new Word", for: .normal)
        newWord.addTarget(self, action: #selector(loadWord), for: .touchUpInside)
        view.addSubview(newWord)
        
        // Submit Button
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        // Clear Button
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        // Constraints
        NSLayoutConstraint.activate([
            
            failed.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            failed.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            failed.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            failed.heightAnchor.constraint(equalToConstant: 25),
            
            guessWord.topAnchor.constraint(equalTo: failed.bottomAnchor, constant: 20),
            guessWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guessWord.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            currentAnswer.topAnchor.constraint(equalTo: guessWord.bottomAnchor, constant: 20),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            newWord.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 20),
            newWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newWord.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            submit.topAnchor.constraint(equalTo: newWord.bottomAnchor, constant: 20),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            submit.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -300),
            clear.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -300)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text?.lowercased() else { return }
        var guessArray = Array(String(guessWord.text!))
        let wordArray = Array(String(newWord))

        if !wordArray.contains(answerText) {
            fail -= 1
            if fail < 0 {
                fail = 0
            }
        }
        for (i, letter) in wordArray.enumerated() {
            if String(letter) == String(answerText) {
                guessArray[i] = letter
            }
        }
        var p = ""
        for i in guessArray {
            p += String(i)
        }
        word = p.uppercased()
        if fail <= 0 {
            word = newWord.uppercased()
            performSelector(onMainThread: #selector(error), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func error() {
        let ac = UIAlertController(title: "Dead", message: "Try again picking new word", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @objc func newWordTapped(_ sender: UIButton) {
        performSelector(inBackground: #selector(loadWord), with: nil)
    }
    
    @objc func loadWord() {
        fail = 7
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let wordsContents = try? String(contentsOf: wordsURL) {
                var lines = wordsContents.components(separatedBy: "\n")
                lines.shuffle()
                newWord = String(lines[0])
                word = String(lines[0].replacingOccurrences(of: "[a-zA-Z]", with: "?", options: .regularExpression, range: nil))
                print(newWord)
            }
        } else {
            print(Bundle.main.url(forResource: "words", withExtension: "txt") ?? "no file")
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
    }
}

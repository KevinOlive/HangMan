//
//  ViewController.swift
//  Hangman
//
//  Created by Kevin Olive on 3/15/19.
//  Copyright © 2019 Kevin Olive. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var newWordAction: UIButton!
    @IBOutlet weak var hintButton: DesignableButton!
    @IBOutlet weak var wordToGuess: UILabel!
    @IBOutlet weak var hangManImage: UIImageView!
    @IBOutlet weak var letterBank: DesignableLabel!
    @IBOutlet weak var letterToGuess: UITextField!
    @IBOutlet weak var displayHint: UILabel!
    @IBOutlet weak var hangmanView: UIView!
    
    typealias wordHintPair = (word:String,hint:String)
    let ListOfWords : [wordHintPair] = [("bug","type of car"),
                                        ("coffee","beverage"),
                                        ("kangaroo","animal that jumps"),
                                        ("cat","sometimes wears a hat"),
                                        ("brownstone","upscale city living"),
                                        ("banana","fruit"),
                                        ("olive","pizza fruit")]
    let MaxGuesses : Int = 6
    var currentWord : String!
    var currentHint : String!
    var wordAsUnderscores : String = ""
    var guesses : Int = 0
    var previousRandomNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        letterToGuess.delegate = self
        letterToGuess.isEnabled = false
    }

    @IBAction func showHint(_ sender: DesignableButton) {
        // display temporary text
        displayHint.text = currentHint
        displayHint.isHidden = false
    }
    
    @IBAction func chooseNewWord(_ sender: DesignableButton) {
        reset()
        
        let index = chooseRandomNumber()
        currentWord = ListOfWords[index].word
        currentHint = ListOfWords[index].hint
        
        for _ in 1...currentWord.count {
            wordAsUnderscores.append("_")
        }
        wordToGuess.text = wordAsUnderscores
        
    }
    
    func chooseRandomNumber() -> Int {
        var newRandomNumber : Int = Int(arc4random_uniform(UInt32(ListOfWords.count)))
        // don't return the same number twice successively
        if (newRandomNumber == previousRandomNumber) {
            newRandomNumber = chooseRandomNumber()
        } else {
            previousRandomNumber = newRandomNumber
        }
        
        return newRandomNumber
    }
 
    func reset() {
        guesses = 0
        hangManImage.image = UIImage(named: "Win")
        wordAsUnderscores = ""
        letterBank.text?.removeAll()
        letterToGuess.text?.removeAll()
        letterToGuess.isEnabled = true
        displayHint.isHidden = true
        hintButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let guess = letterToGuess.text else { return }
        letterToGuess.text?.removeAll()
        let currentLetterBank : String = letterBank.text ?? ""
        if currentLetterBank.contains(guess) {
            return
        }
        
        if currentWord.contains(guess) {
            processCorrectGuess(letterGuessed: guess)
        } else {
            processIncorrectGuess()
        }
        letterBank.text?.append("\(guess) ")
    }
    
    func processCorrectGuess(letterGuessed: String) {
        let characterGuessed = Character(letterGuessed)
        for index in currentWord.indices {
            if currentWord[index] == characterGuessed {
                let endIndex = currentWord.index(after: index)
                let charRange = index..<endIndex
                wordAsUnderscores = wordAsUnderscores.replacingCharacters(in: charRange, with: letterGuessed)
                wordToGuess.text = wordAsUnderscores
            }
        }
        if !(wordAsUnderscores.contains("_")) {
            hangManImage.image = UIImage(named: "win")
            letterToGuess.isEnabled = false
            hintButton.isHidden = true
            
        }
    }
    
    func processIncorrectGuess() {
        guesses += 1
        let hangmanImageString = "guess\(guesses)"
        hangManImage.image = UIImage(named: hangmanImageString)
        if guesses == MaxGuesses {
            hangManImage.image = UIImage(named: "lose")
            letterToGuess.isEnabled = false
            hangManImage.transform.rotated(by: 90)
            hintButton.isHidden = true
        }
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        letterToGuess.resignFirstResponder()
        displayHint.isHidden = true
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = NSCharacterSet.lowercaseLetters
        let startingLength = letterToGuess.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        if string.isEmpty {
            return true
        } else if newLength == 1 {
            if let _ = string.rangeOfCharacter(from: allowedCharacters, options: .caseInsensitive) {
                return true
            }
        }
        return false
    }
    
}

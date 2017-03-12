//
//  ViewController.swift
//  Calculator
//
//  Created by Ciprian Redinciuc on 23/02/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var userIsTypping = false

    private var brain = CalculatorBrain()

    @IBOutlet weak var display: UILabel!

    @IBOutlet weak var sequenceLabel: UILabel!

    @IBAction func didTouchDigit(_ sender: UIButton) {
        let buttonText = sender.currentTitle!
        let currentText = display.text!

        if buttonText == "." {
            if !hasPrecisionDigit {
                userIsTypping = true
            } else {
                return
            }
        }

        if userIsTypping {
            display.text = currentText + buttonText
        } else {
            display.text = buttonText
            userIsTypping = true
        }
    }

    var hasPrecisionDigit: Bool {
        get {
            return display.text!.contains(".")
        }
    }

    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }

    var operations: String {
        get {
            return sequenceLabel.text!
        }
        set {
            var operationsString = newValue
            if brain.resultIsPending {
                operationsString = newValue + "..."
            } else {
                if newValue.characters.count > 0 {
                    operationsString = newValue + " = "
                }
            }
            sequenceLabel.text = operationsString
        }
    }

    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTypping {
            brain.setOperand(displayValue)
            userIsTypping = false
        }

        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol)
        }

        if let result = brain.result {
            displayValue = result
        }

        operations = brain.description
    }
}


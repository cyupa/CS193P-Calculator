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

    @IBAction func didTouchDigit(_ sender: UIButton) {
        let buttonText = sender.currentTitle!
        if userIsTypping {
            let currentText = display.text!
            display.text = currentText + buttonText
        } else {
            display.text = buttonText
            userIsTypping = true
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
    }
}


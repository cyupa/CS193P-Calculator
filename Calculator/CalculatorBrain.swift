//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ciprian Redinciuc on 25/02/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import Foundation

struct CalculatorBrain {

    private var accumulator: (value: Double?, representation: String?)

    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equals
        case reset
    }

    private var pendingBinaryOperation: PendingBinaryOperation?

    private var operations: Dictionary <String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unary(sqrt),
        "cos" : Operation.unary(cos),
        "sin" : Operation.unary(sin),
        "x²" : Operation.unary({ pow($0, 2) }),
        "x³" : Operation.unary({ pow($0, 3) }),
        "2ˣ" : Operation.unary({ pow(2, $0) }),
        "±" : Operation.unary({ -$0 }),
        "×" : Operation.binary(*),
        "+" : Operation.binary(+),
        "-" : Operation.binary(-),
        "÷" : Operation.binary(/),
        "=" : Operation.equals,
        "C" : Operation.reset
    ]

    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double

        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }

    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }

    var description: String {
        get {
            return accumulator.representation ?? ""
        }
    }

    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                let currentRepresentation = accumulator.representation ?? ""
                accumulator = (value, currentRepresentation + "\(symbol) ")
            case .unary(let function):
                let currentRepresentation = accumulator.representation ?? ""
                if accumulator.value != nil {
                    if pendingBinaryOperation != nil {
                        accumulator = (function(accumulator.value!), currentRepresentation.replacingOccurrences(of: "\(accumulator.value!)", with: "\(symbol)(\(accumulator.value!))"))
                    } else {
                        accumulator = (function(accumulator.value!), "\(symbol)(\(currentRepresentation)) ")
                    }
                }
            case .binary(let function):
                if accumulator.value != nil {
                    if pendingBinaryOperation != nil {
                        performPendingBinaryOperation()
                    }
                    let currentRepresentation = accumulator.representation ?? ""
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator.value!)
                    accumulator = (nil, currentRepresentation + "\(symbol) ")
                }
            case .equals:
                performPendingBinaryOperation()
            case .reset :
                accumulator = (0, nil)
                pendingBinaryOperation = nil
            }
        }
    }

    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator.value != nil {
            let currentRepresentation = accumulator.representation ?? ""
            accumulator = (pendingBinaryOperation!.perform(with: accumulator.value!), currentRepresentation)
            pendingBinaryOperation = nil
        }
    }

    mutating func setOperand(_ operand: Double) {
        let currentRepresentation = accumulator.representation ?? ""
        if resultIsPending {
            accumulator = (operand, currentRepresentation + "\(operand) ")
        } else {
            accumulator = (operand, "\(operand) ")
        }
    }

    var result: Double? {
        get {
            return accumulator.value
        }
    }

}

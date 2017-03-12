//
//  CalculatorBrainTests.swift
//  Calculator
//
//  Created by Ciprian Redinciuc on 12/03/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorBrainTests: XCTestCase {

    var brain: CalculatorBrain?
    let operand = 42.0
    
    override func setUp() {
        super.setUp()
        brain = CalculatorBrain()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        brain = nil
    }
    
    func testOperandSet() {
        brain!.setOperand(operand)
        XCTAssert(brain!.result == operand)
    }

    func testResultIsPending() {
        brain!.setOperand(operand)
        brain!.performOperation("+")
        XCTAssert(brain!.resultIsPending)
    }

    func testConstantOperations() {
        brain!.performOperation("π")
        XCTAssert(brain!.result == Double.pi)

        brain!.performOperation("e")
        XCTAssert(brain!.result == M_E)
    }

    func testUnaryOperations() {
        brain!.setOperand(operand)
        brain!.performOperation("cos")
        XCTAssert(brain!.result == cos(operand))
        

        brain!.setOperand(operand)
        brain!.performOperation("sin")
        XCTAssert(brain!.result == sin(operand))

        brain!.setOperand(operand)
        brain!.performOperation("x²")
        XCTAssert(brain!.result == pow(operand, 2))

        brain!.setOperand(operand)
        brain!.performOperation("x³")
        XCTAssert(brain!.result == pow(operand, 3))

        brain!.setOperand(operand)
        brain!.performOperation("2ˣ")
        XCTAssert(brain!.result == pow(2, operand))

        brain!.setOperand(operand)
        brain!.performOperation("±")
        XCTAssert(brain!.result == -operand)

        brain!.setOperand(operand)
        brain!.performOperation("√")
        XCTAssert(brain!.result == sqrt(operand))
    }

    func testBinaryOperations() {
        brain!.setOperand(operand)
        brain!.performOperation("+")
        brain!.setOperand(operand)
        brain!.performOperation("=")
        XCTAssert(brain!.result == operand + operand)

        brain!.setOperand(operand)
        brain!.performOperation("×")
        brain!.setOperand(operand)
        brain!.performOperation("=")
        XCTAssert(brain!.result == operand * operand)

        brain!.setOperand(operand)
        brain!.performOperation("-")
        brain!.setOperand(operand)
        brain!.performOperation("=")
        XCTAssert(brain!.result == operand - operand)

        brain!.setOperand(operand)
        brain!.performOperation("÷")
        brain!.setOperand(operand)
        brain!.performOperation("=")
        XCTAssert(brain!.result == operand / operand)

    }

    func testReset() {
        brain!.setOperand(operand)
        brain!.performOperation("C")
        XCTAssert(brain!.result == 0)
    }

    func testDescription() {
        brain!.setOperand(operand)
        brain!.performOperation("+")
        XCTAssert(brain!.description == "42.0 + ")

        brain!.setOperand(9.0)
        XCTAssert(brain!.description == "42.0 + 9.0 ")

        brain!.performOperation("√")
        XCTAssert(brain!.description == "42.0 + √(9.0) ")
    }
}

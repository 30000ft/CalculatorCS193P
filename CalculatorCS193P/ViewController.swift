//
//  ViewController.swift
//  CalculatorCS193P
//
//  Created by Q on 15/2/5.
//  Copyright (c) 2015年 ywr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var historyInput: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    let welcomeString = "Welcome!"
    
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber && display.text != "0" {
            
            appendToDisplay(digit)
            
        } else {
            
            initiateDisplayWithValue(digit)
            
            userIsInTheMiddleOfTypingANumber = true
            
        }
        
    }
    
    @IBAction func operate(sender: UIButton) {
        
        let operation = sender.currentTitle!
        
        operationInitiation(operation)
        
        switch operation {
        case "×":
            performOperation { $0 * $1 }
        case "÷":
            performOperation { $1 / $0 }
        case "+":
            performOperation { $0 + $1 }
        case "−":
            performOperation { $1 - $0 }
        case "√":
            performSqrt()
        case "sin":
            performOperation { sin($0) }
        case "cos":
            performOperation { cos($0) }
        case "tan":
            performOperation { tan($0) }
        case "π":
            performPI()
        case "+/−":
            userIsInTheMiddleOfTypingANumber = true
            changeSignOfTheCurrentDisplayingNumber()
        case "AC":
            resetAll()
        case "C":
            backspace()
        case "%":
            dividedByOneHundred()
        default:
            break
        }
        
    }
    
    func operationInitiation(operation: String) {
        
        if operation != "+/−" && operation != "C" && operation != "%" && operation != "π" {
            cleanTheEqualSign()
        }
        
        if userIsInTheMiddleOfTypingANumber && operation != "+/−" && operation != "C" && operation != "%" {
            enter()
        }
        
        if operation != "+/−" && operation != "C" && operation != "%" && operation != "π" {
            insertHistory(operation)
        }
        
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 && displayValue != nil {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            
            enter()
            
            insertHistory("=")
        } else {
            insertHistory("Syntax Error")
            if operandStack.count > 0 {
                operandStack.removeLast()
            }
            userIsInTheMiddleOfTypingANumber = true
            println("operandStack = \(operandStack)")
        }
    }
    
    func performOperation(operation: Double -> Double) {
        
        if operandStack.count >= 1 {
            
            displayValue = operation(operandStack.removeLast())
            
            enter()
            
            insertHistory("=")
            
        } else {
            
            insertHistory("Syntax Error")
            
        }
    }

    
    func dividedByOneHundred(){
        if displayValue != nil {
            displayValue = displayValue! / 100
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    func appendToDisplay(str: String) {
        if (str != "." || display.text!.rangeOfString(".") == nil) {
            display.text = display.text! + str
        }
    }
    
    func initiateDisplayWithValue(str: String) {
        
        if str == "." {
            display.text = "0."
        } else {
            display.text = str
        }
        
    }
    
    func performSqrt() {
        if operandStack.last > 0 {
            performOperation { sqrt($0) }
        } else if display.text! != "0" {
            insertHistory("Math Error.")
        }
    }
    
    func performPI() {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        } else {
            displayValue = M_PI
            enter()
        }
    }
    
    func insertHistory(str: String) {
        if historyInput.text == welcomeString {
            historyInput.text = str
        } else {
            historyInput.text = historyInput.text! + " " + str
        }
    }
    
    func cleanTheEqualSign() {
        if historyInput.text!.rangeOfString("=") != nil {
            historyInput.text = dropLast(historyInput.text!)
        }
    }
    
    func changeSignOfTheCurrentDisplayingNumber() {
        if display.text!.rangeOfString("-") != nil {
            display.text!.removeAtIndex(display.text!.startIndex)
        } else {
            display.text = "-" + display.text!
        }
    }
    
    func backspace() {
        if userIsInTheMiddleOfTypingANumber && countElements(display.text!) > 1 {
            display.text = dropLast(display.text!)
        } else {
            initiateDisplayLabel()
        }
    }
    
    func resetAll() {
        operandStack = []
        displayValue = nil
        historyInput.text = welcomeString
        println("operandStack = \(operandStack)")
    }

    var operandStack = Array<Double>()

    @IBAction func enter() {
        cleanTheEqualSign()
        userIsInTheMiddleOfTypingANumber = false
        if displayValue != nil {
            operandStack.append(displayValue!)
        }
        insertHistory(display.text!)
    }
    
    var displayValue: Optional<Double> {
        get{
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set{
            if newValue != nil {
                display.text = "\(newValue!)"
            } else {
                initiateDisplayLabel()
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    func initiateDisplayLabel() {
        display.text = "0"
    }
    
}


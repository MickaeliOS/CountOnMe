//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - OUTLETS & VARIABLES

    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var operandButtons: [UIButton]!

    var continueOperation = false
    var count = Count()

    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }

    // MARK: - SWIFT FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - ACTIONS

    @IBAction func clearText(_ sender: UIButton) {
        // When AC button is pressed, we should clear the operation
        textView.text = ""
        count.number = ""
    }

    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }

        // First open, clear the screen's welcoming message
        if textView.text.contains("Welcome") {
            removeWelcomeMessage()
        }

        didUserFinished()

        count.addNumber(numberToAdd: numberText)
        textView.text.append(numberText)
    }

    @IBAction func tappedOperandButton(_ sender: UIButton) {
        if textView.text.contains("Welcome") {
            removeWelcomeMessage()
        }

        /* Here, if we got a result, that means the operation is over but we just tapped
        an operand button, so the operation continue */
        if expressionHaveResult {
            continueOperation = true
        }

        isTheOperationPossible(button: sender)
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        continueOperation = false

        guard count.expressionIsCorrect else {
            return incorrectExpressionError()
        }

        guard count.expressionHaveEnoughElement else {
            return notEnoughElementsError()
        }

        guard let operationToReduce = count.calculateOperation() else {
            return unknownOperandError()
        }

        if operationToReduce != ["DividedBy0"] {
            textView.text.append(" = \(operationToReduce.first!)")

            // If we continue the operation, we directly save the previous result
            count.number = operationToReduce.first!
        } else {
            dividedBy0Error()
            textView.text = ""
            count.number = ""
        }

        // These two lines enable the textView's auto scroll
        let range = NSRange(location: textView.text.count - 1, length: 0)
        textView.scrollRangeToVisible(range)
    }

    @IBAction func tappedCommaButton(_ sender: UIButton) {
        if textView.text.contains("Welcome") {
            removeWelcomeMessage()
        }

        if count.exepressionAlreadyHaveComma {
            doubleCommaError()
            return
        }

        // Testing if the User have finished his operation or not
        didUserFinished()

        textView.text.append(".")
        count.addComma()
        print(count.elements)
    }

    // MARK: - FUNCTIONS

    private func isTheOperationPossible(button: UIButton) {
        // We check if an operand can be added

        if count.expressionIsCorrect {
            switch button.title(for: .normal) {
            case "+":
                textView.text.append(" + ")
            case "-":
                textView.text.append(" - ")
            case "x":
                textView.text.append(" * ")
            case "/":
                textView.text.append(" / ")
            default:
                return unknownOperandError()
            }

            count.addOperand(operand: button.title(for: .normal)!)

        } else {
            operandAlreadySetError()
        }
    }

    private func removeWelcomeMessage() {
        textView.text = ""
    }

    private func didUserFinished() {
        // This function will clear the operation if the user finished it

        // Second condition means the user continued operation after pressing "=", by adding an " operand "
        if expressionHaveResult && continueOperation == false {
            textView.text = ""
            count.number = ""
        }
        return
    }

    private func incorrectExpressionError() {
        let alertVC = UIAlertController(
            title: "Zéro!", message: "Error ! Expression can't end with an operand !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    private func notEnoughElementsError() {
        let alertVC = UIAlertController(
            title: "Zéro!", message: "Error ! Expression doesn't have enough elements !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    private func unknownOperandError() {
        let alertVC = UIAlertController(
            title: "Zéro!", message: "Error ! unknown operand !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    private func operandAlreadySetError() {
        let alertVC = UIAlertController(
            title: "Zéro!", message: "Error ! An operand is already set !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    private func dividedBy0Error() {
        let alertVC = UIAlertController(
            title: "Zéro!", message: "Error ! You can't divide by 0 !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    private func doubleCommaError() {
        let alertVC = UIAlertController(
            title: "Zéro!", message: "Error ! You can't type comma twice in a row !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

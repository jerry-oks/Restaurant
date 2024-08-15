//
//  CardViewController.swift
//  Restaurant
//
//  Created by HOLY NADRUGANTIX on 20.08.2023.
//

import UIKit

final class CardViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private var frontCardView: UIView!
    @IBOutlet private var backCardView: UIView!
    
    @IBOutlet private var textFields: [UITextField]!
    @IBOutlet private var firstFourNumbersTF: UITextField!
    @IBOutlet private var secondFourNumbersTF: UITextField!
    @IBOutlet private var thirdFourNumbersTF: UITextField!
    @IBOutlet private var fourthFourNumbersTF: UITextField!
    @IBOutlet private var cardHolderTF: UITextField!
    @IBOutlet private var cvvTF: UITextField!
    
    @IBOutlet private var monthButton: UIButton!
    @IBOutlet private var yearButton: UIButton!

    // MARK: - Delegate
    weak var delegate: CardViewControllerDelegate?
    
    // MARK: - Overrided Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frontCardView.layer.cornerRadius = 8
        backCardView.layer.cornerRadius = 8
        self.textFields.forEach { textField in
            textField.delegate = self
        }
        setMenusForButtons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    // MARK: - IB Actions
    @IBAction private func cardNumberTFDidChange(_ sender: UITextField) {
        if sender.text?.count ?? 0 == 4 {
            guard let indexOfTF = textFields.firstIndex(of: sender) else { return }
            textFields[indexOfTF + 1].becomeFirstResponder()
        }
    }
    
    @IBAction private func cardHolderTFDidChange(_ sender: UITextField) {
        sender.text = sender.text?.uppercased()
    }
    
    @IBAction private func cvvTFDidChange(_ sender: UITextField) {
        if sender.text?.count == 3 {
            sender.resignFirstResponder()
        }
    }
    
    @IBAction private func magicFillButtonTapped() {
        randomCard()
    }
    
    @IBAction private func saveButtonTapped() {
        guard let card = createCard() else {
            showInvalidCredsAlert()
            return
        }
        
        delegate?.add(card: card)
        dismiss(animated: true)
        
        delegate?.askForCardAgain()
    }
}

// MARK: - UITextFieldDelegate
extension CardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let indexOfTF = textFields.firstIndex(of: textField) else {
            return textField.resignFirstResponder()
        }
        return textFields[indexOfTF + 1].becomeFirstResponder()
    }
}

// MARK: - Private Methods
private extension CardViewController {
    // Create Pull Down Buttons Method
    func setMenusForButtons() {
        func showSelection(_ action: UIAction) {
            print("MM = \(monthButton.titleLabel?.text ?? "NOT SELECTED"), YY = \(yearButton.titleLabel?.text ?? "NOT SELECTED")")
        }
        
        monthButton.menu = UIMenu(
            children: [
                UIAction(title: "MM", state: .on, handler: showSelection),
                UIAction(title: "01", handler: showSelection),
                UIAction(title: "02", handler: showSelection),
                UIAction(title: "03", handler: showSelection),
                UIAction(title: "04", handler: showSelection),
                UIAction(title: "05", handler: showSelection),
                UIAction(title: "06", handler: showSelection),
                UIAction(title: "07", handler: showSelection),
                UIAction(title: "08", handler: showSelection),
                UIAction(title: "09", handler: showSelection),
                UIAction(title: "10", handler: showSelection),
                UIAction(title: "11", handler: showSelection),
                UIAction(title: "12", handler: showSelection)
            ]
        )
        
        yearButton.menu = UIMenu(
            children: [
                UIAction(title: "YY", state: .on, handler: showSelection),
                UIAction(title: "23", handler: showSelection),
                UIAction(title: "24", handler: showSelection),
                UIAction(title: "25", handler: showSelection),
                UIAction(title: "26", handler: showSelection),
                UIAction(title: "27", handler: showSelection)
            ]
        )
        
        monthButton.showsMenuAsPrimaryAction = true
        monthButton.changesSelectionAsPrimaryAction = true
        monthButton.layer.cornerRadius = 4
        
        yearButton.showsMenuAsPrimaryAction = true
        yearButton.changesSelectionAsPrimaryAction = true
        yearButton.layer.cornerRadius = 4
    }
    
    // Create A New Card Method
    func createCard() -> Card? {
        if !credentialsIsValid() {
            return nil
        }
        
        return Card(
            firstFourNumbers: firstFourNumbersTF.text ?? "",
            secondFourNumbers: secondFourNumbersTF.text ?? "",
            thirdFourNumbers: thirdFourNumbersTF.text ?? "",
            fourthFourNumbers: fourthFourNumbersTF.text ?? "",
            month: monthButton.titleLabel?.text ?? "",
            year: yearButton.titleLabel?.text ?? "",
            cardHolder: cardHolderTF.text ?? "",
            cvv: cvvTF.text ?? ""
        )        
    }
    
    // Fill Card Credentials With Random Values Method
    func randomCard() {
        let cardHolderNames = [
        "TIM COOK",
        "CRAIG FEDERIGHI",
        "EDDY CUE",
        "KATHERINE ADAMS",
        "GREG JOSWIAK",
        "SABIH KHAN",
        "DEIRDRE O'BRIAN",
        "LISA JACKSON",
        "PHIL SCHILLER"
        ]
        var month = ""
        var year = ""
        
        firstFourNumbersTF.text = String(Int.random(in: 1000...9999))
        secondFourNumbersTF.text = String(Int.random(in: 1000...9999))
        thirdFourNumbersTF.text = String(Int.random(in: 1000...9999))
        fourthFourNumbersTF.text = String(Int.random(in: 1000...9999))
        
        cardHolderTF.text = cardHolderNames.randomElement() ?? "CARDHOLDER NAME"
        
        repeat {
            month = monthButton.menu?.children.randomElement()?.title ?? "12"
            year = yearButton.menu?.children.randomElement()?.title ?? "27"
        } while month == "MM" || year == "YY"
                    
        monthButton.setTitle(month, for: .normal)
        yearButton.setTitle(year, for: .normal)
        
        cvvTF.text = String(Int.random(in: 100...999))
    }
    
    // Check Card Credentials Method
    func credentialsIsValid() -> Bool {
        var monthCheck = false
        var yearCheck = false
        
        if let month = Int(monthButton.titleLabel?.text ?? "0") {
            if (1...12).contains(month) {
                monthCheck.toggle()
            }
        }
        
        if let year = Int(yearButton.titleLabel?.text ?? "0") {
            if (23...27).contains(year) {
                yearCheck.toggle()
            }
        }
        
        let check = [
            firstFourNumbersTF.text?.count == 4,
            secondFourNumbersTF.text?.count == 4,
            thirdFourNumbersTF.text?.count == 4,
            fourthFourNumbersTF.text?.count == 4,
            cardHolderTF.text?.count ?? 0 >= 5,
            monthCheck,
            yearCheck,
            cvvTF.text?.count == 3
            ]
        
        print(check)
        return !check.contains(false)
    }
    
    // Show Alert Of Invalid Card Credentials Method
    func showInvalidCredsAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Проверьте, что все поля заполнены верно, и повторите попытку",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
}

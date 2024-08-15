//
//  ClientViewController.swift
//  Restaurant
//
//  Created by Alexey Efimov on 16.08.2023.
//

import UIKit

// MARK: - Delegate Protocols
// Официант
protocol KitchenViewControllerDelegate: AnyObject {
    func isCrime() -> Bool
    func completeOrder()
}

// Оплата
protocol CardViewControllerDelegate: AnyObject {
    func add(card: Card)
    func askForCardAgain()
}
// MARK: - ClientViewController
// Клиент
final class ClientViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private var clientStatusLabel: UILabel!
    @IBOutlet private var clientActionButton: UIButton!
    @IBOutlet private var policeImageView: UIImageView!
    
    // MARK: - Private Properties
    private var cards: [Card] = []
    private var criminal = false
    
    // MARK: - Overrided Methods
    // Официант принимает заказ и идет на кухню
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        // Официант пришел на кухню за заказом конкретеного клиента
        if let kitchenVC = segue.destination as? KitchenViewController {
            kitchenVC.delegate = self
        } // Клиент оплачивает заказ банковской картой
        else if let cardVC = segue.destination as? CardViewController {
            cardVC.delegate = self
        }
    }
    
    // Официант уточняет готов ли клиент сделать заказ
    override func shouldPerformSegue (withIdentifier identifier: String, sender: Any?) -> Bool {
        clientActionButton.titleLabel?.text == "Сделать заказ"
    }
    
    // MARK: - IB Actions
    // Клиент подзывает официанта для оплаты счета
    @IBAction private func clientActionButtonPressed() {
        switch clientActionButton.titleLabel?.text {
        case "Оплатить счёт":
            showPayAlert(
                withTitle: "Оплата",
                message: "Каким способом вы хотите оплатить счет?",
                buttonTitles: "Pay", "банковской картой", "СБП", "наличными")
        case "DESTROY THE APP":
            performSegue(withIdentifier: "openDestroyVC", sender: nil)
        default:
            performSegue(withIdentifier: "openKitchenVC", sender: nil)
        }
    }
}

// MARK: - KitchenViewControllerDelegate
// Сегодня я буду вашим официантом
extension ClientViewController: KitchenViewControllerDelegate {
    func isCrime() -> Bool {
        criminal
    }
    
    // Передача заказа клиенту
    func completeOrder() {
        if criminal {
            prestupnikAction()
        } else {
            clientStatusLabel.text = "Спасибо!"
            clientActionButton.setTitle("Оплатить счёт", for: .normal)
        }
    }
}

// MARK: - CardViewControllerDelegate
extension ClientViewController: CardViewControllerDelegate {
    // Add Card To Saved Cards Array Method
    func add(card: Card) {
        cards.append(card)
    }
    // Show Alert With Saved Cards Method
    func askForCardAgain() {
        showCardsAlert(cards)

    }
}

// MARK: - Alert Methods
private extension ClientViewController {
    // Show Alert Of Choose Payment Way Method
    func showPayAlert(withTitle title: String, message: String, buttonTitles: String...) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )
        
        buttonTitles.forEach { buttonTitle in
            alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in
                if buttonTitle == "банковской картой" {
                    self.showCardsAlert(self.cards)
                } else {
                    self.showThanksAlert(withTitle: "Вы оплатили счет \(buttonTitle)")
                }
            }
            )
        }
        
        alert.addAction(
            UIAlertAction(
                title: "сбежать не заплатив",
                style: .destructive
            ) { _ in
                if Int.random(in: 0...1) == 0 {
                    self.showThanksAlert(
                        withTitle: "Преступление совершено!",
                        message: "Вы успешно сбежали из ресторана не оплатив счет",
                        buttonTitle: "Yeah 😎"
                    )
                    self.criminal.toggle()
                } else {
                    self.prestupnikAction()
                }
            }
        )
        alert.addAction(
            UIAlertAction(
                title: "отмена",
                style: .cancel
            )
        )
        
        present(alert, animated: true)
    }
    
    // Show Alert Of Saved Cards Method
    func showCardsAlert(withTitle title: String = "Какой картой оплатить заказ?", message: String = "", _ cards: [Card]) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )
        
        cards.forEach { card in
            alert.addAction(UIAlertAction(title: card.cardInfo, style: .default) { _ in
                self.showThanksAlert(withTitle: "Вы оплатили счет картой *\(card.fourthFourNumbers)")
                print("Payment with card: \(card.cardNumber), CVV \(card.cvv), valid thru \(card.month)/\(card.year), issued for \(card.cardHolder)")
            }
            )
        }
        
        alert.addAction(
            UIAlertAction(
                title: "добавить новую карту...",
                style: .default
            ) { _ in
                self.performSegue(withIdentifier: "openCardVC", sender: nil)
            }
        )
        
        alert.addAction(
            UIAlertAction(
                title: "отмена",
                style: .cancel
            )
        )
        
        present(alert, animated: true)
    }
    
    // Shows Alert Of Successful Payment Method
    func showThanksAlert(withTitle title: String, message: String = "Спасибо, ждем вас снова!", buttonTitle: String = "ОК") {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let buttonAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            self.clientStatusLabel.text = "Хочу есть!"
            self.clientActionButton.setTitle("Сделать заказ", for: .normal)
        }
        
        alert.addAction(buttonAction)
        present(alert, animated: true)
    }
}

// MARK: - Private Methods
private extension ClientViewController {
    // Change UI If You Are A Criminal
    func prestupnikAction() {
        updateUI()
        setConstraints()
        setAnimation()
        
        func updateUI() {
            clientStatusLabel.text = "⚠️🛑⚠️🛑⚠️\nPRESTUPNIK DETECTED\n🚨🚔🚨🚔🚨"
            clientStatusLabel.textColor = .black
            clientStatusLabel.font = .boldSystemFont(ofSize: 45)
            clientStatusLabel.textAlignment = .center
            
            clientActionButton.setTitle("DESTROY THE APP", for: .normal)
            clientActionButton.tintColor = .black
            
            view.backgroundColor = .systemRed
            
            policeImageView.image = UIImage(named: "police")
            policeImageView.isHidden.toggle()
        }
        
        func setConstraints() {
            NSLayoutConstraint.activate([
                clientStatusLabel.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: 16
                ),
                clientStatusLabel.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: 16
                ),
                clientStatusLabel.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -16
                ),
                
                clientActionButton.bottomAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                    constant: -16
                ),
                clientActionButton.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: 16
                ),
                clientActionButton.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -16
                ),
                
                clientActionButton.heightAnchor.constraint(
                    equalToConstant: 60
                )
            ])
        }
        
        func setAnimation() {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: [.autoreverse, .repeat, .allowUserInteraction],
                animations: { self.view.backgroundColor = .blue },
                completion: nil
            )
        }
    }
}

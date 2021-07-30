//
//  ViewController.swift
//  Calculator
//
//  Created by 岩渕優児 on 2021/07/16.
//

import UIKit

class ViewController: UIViewController{
    
    
    func clear() {
        firstNumber = ""
        secondNumber = ""
        originalNumber = ""
        numberLabel.text = "0"
        calculateStatus = .none
    }
    
    enum CalculateStatus {
        case none, plus, minus, multiplication, division
    }
    
    var tax = 1.1
    var firstNumber = ""
    var secondNumber = ""
    var originalNumber: String? = nil
    var calculateStatus: CalculateStatus = .none
    
    let numbers = [
        ["C","%","税抜","税込"],
        ["7","8","9","÷"],
        ["4","5","6","×"],
        ["1","2","3","-"],
        ["0",".","=","+"]
    ]
    
    
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionViewHeightConstraint.constant = view.frame.width * 1.4
        collectionView.contentInset = .init(top: 0, left: 14, bottom: 0, right: 14)
        
    }
    
    @IBAction func taxSwitch(_ sender: UISwitch) {
        if sender.isOn {
            tax = 1.1
        } else {
            tax = 1.08
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        width = ((collectionView.frame.width - 10) - 14 * 5) / 4
        let height = width
        
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CollectionViewCell
        cell.numberlabel.text = numbers[indexPath.section][indexPath.row]
        
        numbers[indexPath.section][indexPath.row].forEach { (numberString) in
            
            if "0"..."9" ~= numberString || numberString.description == "."{
                cell.numberlabel.backgroundColor = .green
            } else if numberString == "C" || numberString == "%" || numberString == "$"{
                cell.numberlabel.backgroundColor = .systemGreen
                cell.numberlabel.textColor = .white
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let number = numbers[indexPath.section][indexPath.row]
        
        switch calculateStatus {
        case .none:
            switch number {
            
            case "0"..."9":
                firstNumber += number
                numberLabel.text = firstNumber
                
                if firstNumber.hasPrefix("0"){
                    firstNumber = ""
                }
                
            case  ".":
                if !confirmDecimalPoint(numberString: firstNumber){
                    firstNumber += number
                    numberLabel.text = firstNumber
                    
                }
                
            case "+":
                calculateStatus = .plus
                
            case "-":
                calculateStatus = .minus
                
            case "×":
                calculateStatus = .multiplication
                
            case "÷":
                calculateStatus = .division
                
            case "%":
                if numberLabel.text != "E"{
                    let targetNumber = numberLabel.text!
                    let doubledTargetnumber = Double(targetNumber)!
                    let percent = doubledTargetnumber / 100
                    
                    if percent >= 0.00000001 {
                        numberLabel.text = String(percent)
                    } else {
                        numberLabel.text = "E"
                        firstNumber = ""
                        secondNumber = ""
                        calculateStatus = .none
                    }
                    
                } else {
                    clear()
                }
                
            case "税込":
                
                var resultString: String?
                
                if numberLabel.text != "0" || numberLabel.text != "E"{
                    
                    let labelNumber = Double(numberLabel.text!)!
                    let taxIncluded = labelNumber * tax
                    resultString = String(taxIncluded.removeZerosFromEnd())
                    
                } else {
                    resultString = "0"
                }
                
                numberLabel.text = resultString
                
            case "税抜":
                var resultString: String?
                
                if numberLabel.text != "0" || numberLabel.text != "E"{
                    
                    let labelNumber = Double(numberLabel.text!)!
                    let taxIncluded = labelNumber / tax
                    resultString = String(taxIncluded.removeZerosFromEnd())
                    
                } else {
                    resultString = "0"
                }
                
                numberLabel.text = resultString
                
            case "C":
                clear()
                
                
                
                
            default:
                break
            }
            
        case .plus, .minus, .division, .multiplication:
            switch number {
            
            case "0"..."9":
                secondNumber += number
                numberLabel.text = secondNumber
                
                if secondNumber.hasPrefix("0"){
                    secondNumber = ""
                }
                
            case "." :
                if !confirmDecimalPoint(numberString: secondNumber){
                    secondNumber += number
                    numberLabel.text = secondNumber
                }
                
            case "=":
                
                let firstNum = Double(firstNumber) ?? 0
                let secondNum = Double(secondNumber) ?? 0
                
                var resultString: String?
                
                switch calculateStatus {
                case .plus:
                    resultString = String(firstNum + secondNum)
                    
                case .minus:
                    resultString = String(firstNum - secondNum)
                    
                case .multiplication:
                    resultString = String(firstNum * secondNum)
                    
                case .division:
                    resultString = String(firstNum / secondNum)
                    
                default:
                    break
                }
                
                if let result = resultString, result.hasSuffix(".0") {
                    resultString = result.replacingOccurrences(of: ".0", with: "")
                    
                }
                
                numberLabel.text = resultString
                firstNumber = ""
                secondNumber = ""
                
                firstNumber += resultString ?? ""
                calculateStatus = .none
                
            case "%":
                if numberLabel.text != "E"{
                    let targetNumber = numberLabel.text!
                    let doubledTargetnumber = Double(targetNumber)!
                    let percent = doubledTargetnumber / 100
                    
                    if percent >= 0.00000001 {
                        numberLabel.text = String(percent)
                    } else {
                        numberLabel.text = "E"
                        firstNumber = ""
                        secondNumber = ""
                        calculateStatus = .none
                    }
                    
                } else {
                    clear()
                }

                
            case "税込":
                
                var resultString: String?
                
                if numberLabel.text != "0" || numberLabel.text != "E"{
                    
                    let labelNumber = Double(numberLabel.text!)!
                    let taxIncluded = labelNumber * tax
                    resultString = String(taxIncluded.removeZerosFromEnd())
                    
                } else {
                    resultString = "0"
                }
                
                numberLabel.text = resultString
                
            case "税抜":
                var resultString: String?
                
                if numberLabel.text != "0" || numberLabel.text != "E"{
                    
                    let labelNumber = Double(numberLabel.text!)!
                    let taxIncluded = labelNumber / tax
                    resultString = String(taxIncluded.removeZerosFromEnd())
                    
                } else {
                    resultString = "0"
                }
                
                numberLabel.text = resultString
                
            case "C":
                clear()
                
            default:
                break
            }
            
        }
        
    }
    
    func confirmDecimalPoint(numberString: String) -> Bool {
        if numberString.range(of: ".") != nil || numberString.count == 0{
            return true
            
        } else {
            return false
            //            firstNumber += number
            //            numberLabel.text = firstNumber
        }
        
    }
    
}

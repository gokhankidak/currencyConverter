//
//  ConverterView.swift
//  currencyConverter
//
//  Created by Gökhan Kıdak on 5.11.2023.
//

import UIKit
import SnapKit

class ConverterView: UIViewController{
    let fromLabel = UILabel()
    let toLabel = UILabel()
    let amountLabel = UILabel()
    let resultLabel = UILabel()
    let selectedCurrencyLabel = UILabel()
    
    let fromTextField = UITextField()
    let toTextField = UITextField()
    let amountTextField = UITextField()
    
    let fromView = UIView()
    let toView = UIView()
    let amountView = UIView()
    
    var screenHeight = UIScreen.main.bounds.height
    var screenWidth = UIScreen.main.bounds.width
    var subViewHeight = 0.0
    var verticalOffset = 0.0
    var horizontalOffset = 0.0
    
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func calculateConstraints()
    {
        screenHeight = UIScreen.main.bounds.height
        screenWidth = UIScreen.main.bounds.width
        subViewHeight = screenHeight / 5
        
        verticalOffset = subViewHeight / 5
        horizontalOffset = screenWidth / 10
    }
    
    func setupUI() {
        calculateConstraints()
        
        createSelectCurrencyView(subview: fromView, labelText: "From", label: fromLabel, textField: fromTextField)
        createSelectCurrencyView(subview: toView, labelText: "To", label: toLabel, textField: toTextField)
        createAmountView()
        
        fromView.snp.makeConstraints{make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        toView.snp.makeConstraints{make in
            make.top.equalTo(fromView.snp.bottom)
        }

        fromTextField.inputView = pickerView
        toTextField.inputView = pickerView
        amountTextField.keyboardType = .decimalPad
        
        resultLabel.adjustsFontSizeToFitWidth = true
        setToolBar()
    }
    
    //create select currency view which contain a text field and a label
    fileprivate func createSelectCurrencyView(subview : UIView,labelText : String,label : UILabel,textField : UITextField) {
        
        view.addSubview(subview)
        subview.backgroundColor = .green
        subview.snp.makeConstraints{make in
            make.height.equalTo(subViewHeight)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        subview.addSubview(label)
        label.text = labelText
        label.snp.makeConstraints{make in
            make.leading.equalTo(subview.snp.leading).offset(horizontalOffset)
            make.top.equalTo(subview.snp.top).offset(verticalOffset)
        }
        
        subview.addSubview(textField)
        textField.placeholder = "Select currency"
        textField.borderStyle = .roundedRect
        textField.inputView = pickerView
        textField.snp.makeConstraints{make in
            make.leading.equalTo(label)
            make.top.equalTo(label.snp.bottom).offset(verticalOffset)
        }
    }
    //create amount view which contain a label and textfield aligment different with currency view
    fileprivate func createAmountView()
    {
        amountLabel.text = "Amount"
        amountTextField.placeholder = "Enter Amount"
        amountTextField.borderStyle = .roundedRect
        
        view.addSubview(amountView)
        amountView.backgroundColor = .blue
        amountView.snp.makeConstraints{make in
            make.height.equalTo(subViewHeight)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(toView.snp.bottom)
        }
        
        amountView.addSubview(amountTextField)
        amountTextField.snp.makeConstraints{make in
            make.right.equalTo(amountView.snp.right).offset(-20)
            make.bottom.equalTo(amountView.snp.bottom).offset(-verticalOffset)
        }
        
        amountView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints{make in
            make.left.equalTo(amountTextField.snp.left)
            make.top.equalTo(amountView.snp.top).offset(verticalOffset)
        }
    }
    //add done bar for decimal keyboard
     func setToolBar(){
         let bar = UIToolbar()
         let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self.view, action: #selector(view.endEditing))
         let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

         bar.setItems([flexSpace,doneButton], animated: true)
         bar.sizeToFit()
         amountTextField.inputAccessoryView = bar
     }
     
//     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//         if let nextTextField = view.viewWithTag(textField.tag + 1) as? UITextField
//         {
//             nextTextField.becomeFirstResponder()
//         }
//         else{
//             textField.resignFirstResponder()
//         }
//     }
     
     func initializeHideKeyboard(){
         let tap: UITapGestureRecognizer = UITapGestureRecognizer(
             target: self.view,
             action: #selector(view.endEditing))
         //to solve didSelectRowAtIndex not work issue
         tap.cancelsTouchesInView = false
         //Add this tap gesture recognizer to the parent view
         view.addGestureRecognizer(tap)
     }
}

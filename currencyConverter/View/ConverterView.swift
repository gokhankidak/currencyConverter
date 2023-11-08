//
//  ConverterView.swift
//  currencyConverter
//
//  Created by Gökhan Kıdak on 5.11.2023.
//

import UIKit
import SnapKit

class ConverterView: UIView,UITextFieldDelegate{
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
    let calculateView = UIView()
    
    let calculateButton = UIButton()
    let pickerView = UIPickerView()
    
    var screenHeight = UIScreen.main.bounds.height
    var screenWidth = UIScreen.main.bounds.width
    var subViewHeight = 0.0
    var verticalOffset = 0.0
    var horizontalOffset = 0.0
    
    var controller : ConverterViewContoller?
    var moneyUnitCodes = [""]
    var selectedTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func didLoad() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        fromTextField.delegate = self
        toTextField.delegate = self
        amountTextField.delegate = self
        
        moneyUnitCodes = MoneyData.moneyUnitCodes
        
        initializeHideKeyboard()
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
        createCalculateView()
        
        fromView.snp.makeConstraints{make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        toView.snp.makeConstraints{make in
            make.top.equalTo(fromView.snp.bottom)
        }

        fromTextField.inputView = pickerView
        toTextField.inputView = pickerView
        amountTextField.keyboardType = .decimalPad
        
        resultLabel.adjustsFontSizeToFitWidth = true

        //setToolBar()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
    }
    
    //add done bar for decimal keyboard
//     func setToolBar(){
//         let bar = UIToolbar()
//         let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(endEditing))
//         let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//
//         bar.setItems([flexSpace,doneButton], animated: true)
//         bar.sizeToFit()
//         amountTextField.inputAccessoryView = bar
//     }
    
     func initializeHideKeyboard(){
         let tap: UITapGestureRecognizer = UITapGestureRecognizer(
             target: self,
             action: #selector(endEditing))
         //to solve didSelectRowAtIndex not work issue
         tap.cancelsTouchesInView = false
         //Add this tap gesture recognizer to the parent view
         addGestureRecognizer(tap)
     }
    
    //MARK: Autolayout
    //create select currency view which contain a text field and a label
    fileprivate func createSelectCurrencyView(subview : UIView,labelText : String,label : UILabel,textField : UITextField) {
        
        addSubview(subview)
        subview.backgroundColor = .green
        subview.snp.makeConstraints{make in
            make.height.equalTo(subViewHeight/1.5)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
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
            make.top.equalTo(label.snp.bottom).offset(verticalOffset/2)
        }
    }
    //create amount view which contain a label and textfield aligment different with currency view
    fileprivate func createAmountView()
    {
        amountLabel.text = "Amount"
        amountTextField.placeholder = "Enter Amount"
        amountTextField.borderStyle = .roundedRect
        
        addSubview(amountView)
        amountView.backgroundColor = .blue
        amountView.snp.makeConstraints{make in
            make.height.equalTo(subViewHeight)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
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
    
    fileprivate func createCalculateView()
    {
        addSubview(calculateView)
        calculateView.backgroundColor = .yellow
        calculateView.snp.makeConstraints { make in
            make.top.equalTo(amountView.snp.bottom)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(subViewHeight)
        }
        
        calculateView.addSubview(calculateButton)
        calculateButton.setTitle("Calculate", for: .normal)
        calculateButton.setTitleColor(.black, for: .normal)
        calculateButton.backgroundColor = .white
        calculateButton.addTarget(self, action:#selector(didCalculatePressed) , for: .touchDown)
        calculateButton.snp.makeConstraints { make in
            make.top.equalTo(calculateView.snp.top).offset(verticalOffset)
            make.width.equalTo(horizontalOffset * 4)
            make.height.equalTo(verticalOffset * 1.5)
            make.centerX.equalTo(snp.centerX)
        }
        
        calculateView.addSubview(resultLabel)
        resultLabel.text = "Result"
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(calculateButton.snp.bottom).offset(verticalOffset)
            make.centerX.equalTo(snp.centerX)
        }
        
    }
    
    @objc func didCalculatePressed(){
        guard let controller = controller
        else{
            print("Controller is nil")
            return
        }
        controller.didCalculatePressed()
        
    }
}

extension ConverterView : UIPickerViewDelegate,UIPickerViewDataSource
{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return moneyUnitCodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return moneyUnitCodes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Did select row")
        selectedTextField.text = moneyUnitCodes[row]
        selectedTextField.resignFirstResponder()
    }
    
}

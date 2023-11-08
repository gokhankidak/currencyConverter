//
//  converterViewController.swift
//  currencyConverter
//
//  Created by Gökhan Kıdak on 26.10.2023.
//

import IQKeyboardManagerSwift
import SnapKit
import UIKit

class ConverterViewContoller : ViewController,UITextFieldDelegate
{
    var selectedTextField = UITextField()
    var converterView = ConverterView()
    var moneyUnitCodes : [String] = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        converterView.pickerView.delegate = self
        converterView.pickerView.dataSource = self

        converterView.fromTextField.delegate = self
        converterView.toTextField.delegate = self
        converterView.amountTextField.delegate = self
        
        moneyUnitCodes = MoneyData.moneyUnitCodes
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
    }
    
    @IBAction func didCalculatePressed(_ sender: Any) {
        var conversionRate : Double = 0.0
        if(moneyUnitCodes.contains(converterView.fromTextField.text ?? "") && moneyUnitCodes.contains(converterView.toTextField.text ?? "")){
            DataAccess.shared.fetchData(from: converterView.fromTextField.text!, to: converterView.toTextField.text!){rate in
                conversionRate = rate
                if let amount  = Double(self.converterView.amountTextField.text ?? "0") {
                    let result = amount * conversionRate
                    self.converterView.resultLabel.text = String(format : "%.3f",result)
                }
            }
        }
        else {
            let alertController: UIAlertController = UIAlertController(title: "Error", message: "Please enter valid currencies", preferredStyle: .alert)
            alertController.addAction(
                UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                    alertController.dismiss(animated: true)
                })
            
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension ConverterViewContoller : UIPickerViewDelegate,UIPickerViewDataSource
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
        selectedTextField.text = moneyUnitCodes[row]
        selectedTextField.resignFirstResponder()
    }
    
}

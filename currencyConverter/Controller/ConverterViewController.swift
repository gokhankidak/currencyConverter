//
//  converterViewController.swift
//  currencyConverter
//
//  Created by Gökhan Kıdak on 26.10.2023.
//

import SnapKit
import UIKit

class ConverterViewContoller : UIViewController,UITextFieldDelegate
{
    var converterView : ConverterView?
    var moneyUnitCodes : [String] = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        converterView = ConverterView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.addSubview(converterView!)
        converterView!.controller = self
        
        moneyUnitCodes = MoneyData.moneyUnitCodes
    }
    
    func didCalculatePressed() {
        var conversionRate : Double = 0.0
        
        print("Did calculatePressed")
        guard let converterView = converterView
            else{
                return
            }
        
        if(moneyUnitCodes.contains(converterView.fromTextField.text ?? "") && moneyUnitCodes.contains(converterView.toTextField.text ?? "")){
            DataAccess.shared.fetchData(from: converterView.fromTextField.text!, to: converterView.toTextField.text!){rate in
                conversionRate = rate
                if let amount  = Double(converterView.amountTextField.text ?? "0") {
                    let result = amount * conversionRate
                    converterView.resultLabel.text = String(format : "%.3f",result)
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



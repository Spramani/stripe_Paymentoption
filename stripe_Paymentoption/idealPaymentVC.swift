//
//  idealPaymentVC.swift
//  stripe_Paymentoption
//
//  Created by Adsum MAC 2 on 25/10/21.
//

import UIKit
import Stripe


protocol idealValue {
    func idealvalues(bankName:String,bankCode:String,name:String)
}

enum IDEALBank: Int, CaseIterable {
    case ABNAMRO = 0,
    ASNBank,
    Bunq,
    Handlesbanked,
    ING,
    Knab,
    Moneyou,
    Rabobank,
    RegioBank,
    SNSBank,
    TriodosBank,
    VanLoschot

    var displayName: String {
        switch self {
        case .ABNAMRO:
            return "ABN AMRO"
        case .ASNBank:
            return "ASN Bank"
        case .Bunq:
            return "Bunq"
        case .Handlesbanked:
            return "Handlesbanken"
        case .ING:
            return "ING"
        case .Knab:
            return "Knab"
        case .Moneyou:
            return "Moneyou"
        case .Rabobank:
            return "Rabobank"
        case .RegioBank:
            return "RegioBank"
        case .SNSBank:
            return "SNS Bank (De Volksbank)"
        case .TriodosBank:
            return "Triodos Bank"
        case .VanLoschot:
            return "Van Lanschot"
        }
    }

    var stripeCode: String {
        switch self {
        case .ABNAMRO:
            return "abn_amro"
        case .ASNBank:
            return "asn_bank"
        case .Bunq:
            return "bunq"
        case .Handlesbanked:
            return "handelsbanken"
        case .ING:
            return "ing"
        case .Knab:
            return "knab"
        case .Moneyou:
            return "moneyou"
        case .Rabobank:
            return "rabobank"
        case .RegioBank:
            return "regiobank"
        case .SNSBank:
            return "sns_bank"
        case .TriodosBank:
            return "triodos_bank"
        case .VanLoschot:
            return "van_lanschot"
        }
    }
}


class IdealPaymentVC: UIViewController {
    
    @IBOutlet weak var selectBank: UITextField!
    @IBOutlet weak var fullName: UITextField!
    
    
    var delegateProtocol : idealValue?
    private let bankPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fullName.text = "Test"
        bankPicker.dataSource = self
        bankPicker.delegate = self
        selectBank.inputView = bankPicker
    }
    

    @IBAction func done(_ sender: UIButton) {
        
        // Collect iDEAL details on the client
        guard let selectedBank = IDEALBank(rawValue: bankPicker.selectedRow(inComponent: 0)) else {
            return
        }
    
        delegateProtocol?.idealvalues(bankName: selectedBank.displayName, bankCode: selectedBank.stripeCode, name: fullName.text ?? "")
        
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension IdealPaymentVC: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

extension IdealPaymentVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return IDEALBank.allCases.count
    }
}

extension IdealPaymentVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let bank = IDEALBank(rawValue: row) else {
            return nil
        }

        return bank.displayName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard let bank = IDEALBank(rawValue: row) else {
            return
        }
        selectBank.text = bank.displayName
        selectBank.resignFirstResponder()
    }
}

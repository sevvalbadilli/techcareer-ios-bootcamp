//
//  AddViewController.swift
//  iOSBootcamp-Task02
//
//  Created by ŞEVVAL on 15.04.2025.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var tfAddItem: UITextField!
    
    var viewModel = AddViewModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func buttonSave(_ sender: Any) {
        guard let text = tfAddItem.text, !text.isEmpty else { return }
               viewModel.kaydet(todo: text)
               navigationController?.popViewController(animated: true)
    }
}

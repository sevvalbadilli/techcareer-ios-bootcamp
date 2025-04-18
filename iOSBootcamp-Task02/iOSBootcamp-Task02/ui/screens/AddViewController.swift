//
//  AddViewController.swift
//  iOSBootcamp-Task02
//
//  Created by ŞEVVAL on 15.04.2025.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var tfAddItem: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func buttonSave(_ sender: Any) {
        guard let text = tfAddItem.text, !text.isEmpty else { return }
                let newTodo = ToDo(id: 1, name: text)  // Yeni todo oluştur
                if let mainVC = navigationController?.viewControllers.first as? MainViewController {
                    mainVC.addNewTodo(newTodo)
                }

                navigationController?.popViewController(animated: true)
    }
}

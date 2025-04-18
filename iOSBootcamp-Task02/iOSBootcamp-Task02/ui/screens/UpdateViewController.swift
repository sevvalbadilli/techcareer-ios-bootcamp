//
//  UpdateViewController.swift
//  iOSBootcamp-Task02
//
//  Created by ŞEVVAL on 15.04.2025.
//

import UIKit


class UpdateViewController: UIViewController {

    @IBOutlet weak var tfUpdate: UITextField!
    
    var todo: ToDo?
    var todoIndex: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let todo = todo {
            tfUpdate.text = todo.name
        }
    }
    

    
    @IBAction func buttonUpdate(_ sender: Any) {
        guard let newText = tfUpdate.text, !newText.isEmpty, let index = todoIndex else { return }

                if let mainVC = navigationController?.viewControllers.first as? MainViewController {
                    mainVC.updateTodo(at: index, with: newText) 
                }

                navigationController?.popViewController(animated: true)  // Geri dön
    }
    
}

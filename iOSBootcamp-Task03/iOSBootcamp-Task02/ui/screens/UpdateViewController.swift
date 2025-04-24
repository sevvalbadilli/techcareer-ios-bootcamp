//
//  UpdateViewController.swift
//  iOSBootcamp-Task02
//
//  Created by ŞEVVAL on 15.04.2025.
//

import UIKit


class UpdateViewController: UIViewController {
    
    @IBOutlet weak var tfUpdate: UITextField!
    
    var viewModel = UpdateViewModel()
    var todo: ToDos?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        if let todo = todo {
            tfUpdate.text = todo.name
        }
    }
    
    
    
    @IBAction func buttonUpdate(_ sender: Any) {
        guard let updatedText = tfUpdate.text,
              let id = todo?.id else { return }
        
        viewModel.guncelle(id: id, yeniText: updatedText)
        navigationController?.popViewController(animated: true)
        
    }
}

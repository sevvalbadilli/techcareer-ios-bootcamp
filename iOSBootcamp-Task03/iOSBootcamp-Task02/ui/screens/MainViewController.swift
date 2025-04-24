//
//  MainViewController.swift
//  iOSBootcamp-Task02
//
//  Created by ŞEVVAL on 15.04.2025.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    var todos: [ToDos] = []
    var viewModel = MainViewModel()
    var disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()

            table.delegate = self
            table.dataSource = self
            searchBar.delegate = self
               
        
               viewModel.todoListesi
                   .observe(on: MainScheduler.instance)
                   .subscribe(onNext: { liste in
                       self.todos = liste
                       self.table.reloadData()
                   })
                   .disposed(by: disposeBag)
               
               viewModel.todosuYukle() 
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "toUpdate" {
               if let todo = sender as? ToDos,
                  let destinationVC = segue.destination as? UpdateViewController {
                   destinationVC.todo = todo
               }
           }
       }

}
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.todosuYukle()
        } else {
            viewModel.ara(aramaKelimesi: searchText)
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = table.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
           let todo = todos[indexPath.row]
           cell.textLabel?.text = todo.name
           return cell
       }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = todos[indexPath.row]
        performSegue(withIdentifier: "toUpdate", sender: selectedTodo)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let silAction = UIContextualAction(style: .destructive, title: "Sil") { (action, view, completionHandler) in
            let todo = self.todos[indexPath.row]
            
            let alert = UIAlertController(title: "Silme İşlemi",message: "\"\(todo.name ?? "")\" silinsin mi?", preferredStyle: .alert)
            
            let iptalAction = UIAlertAction(title: "İptal", style: .cancel)
            alert.addAction(iptalAction)
            
            let evetAction = UIAlertAction(title: "Evet", style: .destructive) { action in
                self.viewModel.sil(id: todo.id!)
            }
            alert.addAction(evetAction)
            
            self.present(alert, animated: true)
            
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [silAction])
    }


}



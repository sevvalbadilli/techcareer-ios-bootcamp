//
//  MainViewController.swift
//  iOSBootcamp-Task02
//
//  Created by ŞEVVAL on 15.04.2025.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    var todos: [ToDo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self

        loadTodos()
    }
    
    func loadTodos() {
            todos = [
                ToDo(id: 1, name: "Test verisi 1"),
                ToDo(id: 2, name: "Test verisi 2"),
                ToDo(id: 3, name: "Test verisi 3")
            ]
            table.reloadData()
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAdd" {
            
        }
    }
    
    func addNewTodo(_ todo: ToDo) {
            todos.append(todo)
            table.reloadData()
        }

        func updateTodo(at index: Int, with newText: String) {
            todos[index].name = newText
            table.reloadData()
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
            if let updateVC = storyboard?.instantiateViewController(withIdentifier: "toUpdate") as? UpdateViewController {
                updateVC.todo = selectedTodo
                updateVC.todoIndex = indexPath.row
                navigationController?.pushViewController(updateVC, animated: true)
            }
        }
}



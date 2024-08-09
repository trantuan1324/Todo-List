//
//  ViewController.swift
//  TodoList
//
//  Created by Trần Quang Tuấn on 9/8/24.
//

import UIKit

class ViewController: UIViewController {
    
    private var viewModel = ToDoViewModel()

    @IBOutlet weak var todoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        viewModel.getAllItems()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.todoTableView.reloadData()
        }
        todoTableView.dataSource = self
        todoTableView.delegate = self
    }
    
    @IBAction func onTapListener(_ sender: Any) {
        let alert = UIAlertController(title: "New new task", message: "Enter task name", preferredStyle: .alert)
        
        alert.addTextField()
        
        let submit = UIAlertAction(title: "Add task", style: .default) { [weak self] action in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
            self!.viewModel.createItem(name: text)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.todoTableView.reloadData()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(cancel)
        alert.addAction(submit)
        
        self.present(alert, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.todoList.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            let taskRemoved = self.viewModel.todoList[indexPath.row]
            self.viewModel.deleteItem(itemPicked: taskRemoved)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.todoTableView.reloadData()
            }
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoItem = viewModel.todoList[indexPath.row]
        let cell = todoTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = todoItem.name?.capitalized
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todoTableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "Modify task", message: "Change task name", preferredStyle: .alert)
        
        alert.addTextField()
        
        let todoItem = self.viewModel.todoList[indexPath.row]
        let textfield = alert.textFields?.first
        textfield?.text = todoItem.name
        
        let sumbit = UIAlertAction(title: "Change task", style: .default) { action in
            let newTask = textfield?.text
            self.viewModel.updateItem(itemPicked: todoItem, updatedName: newTask!)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.todoTableView.reloadData()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(cancel)
        alert.addAction(sumbit)
        
        self.present(alert, animated: true)
    }
}


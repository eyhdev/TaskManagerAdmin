//
//  ViewModelClass.swift
//  TaskManagerApp
//
//  Created by eyh.mac on 7.01.2024.
//

import Foundation
import FirebaseFirestore
import Firebase

// Define a Task struct conforming to Identifiable and Codable
struct Task: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var details: String
    var color: String
    var type: String
    var deadline: Date
    var isDone: Bool
    var createdTime: String  // New property
    var userId: String?
    var progress: Int
    var fileURL: String?
}

// Define a Admins struct conforming to Codable
struct Admins: Codable {
    var name: String
    var surname: String
    var email: String
    var department: String // Corrected the typo in the property name
    var password: String
    var userId: String?
}

struct Users: Codable {
    var name: String
    var surname: String
    var email: String
    var departmant: String
    var password: String
    var userId: String?
}

// Define a TaskManager class as ObservableObject
class TaskManager: ObservableObject {
    @Published var tasks: [Task] = [] // Published property for updating UI
    @Published var users: [Users] = [] 
    private let db = Firestore.firestore() // Firestore database instance
    private let auth = Auth.auth() // Firebase authentication instance
    
    // Computed property to get the current authenticated user
    var currentUser: User? {
        return auth.currentUser
    }
    
    // Function to sign in a user with email and password
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { _, error in
            completion(error == nil)
        }
    }
    
    // Function to sign up a new admin
    func signUp(admins: Admins, completion: @escaping (Bool) -> Void) {
        auth.createUser(withEmail: admins.email, password: admins.password) { result, error in
            guard let user = result?.user, error == nil else {
                completion(false)
                return
            }
            
            var newAdmin = admins
            newAdmin.userId = user.uid
            
            do {
                // Save admin details to Firestore
                _ = try self.db.collection("admins").document(user.uid).setData(from: newAdmin)
                completion(true)
            } catch {
                print("Error saving admin details: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

    // Function to sign out the current user
    func signOut() {
        do {
            try auth.signOut()
            tasks.removeAll()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    // Add a new function to fetch users
    func fetchUsers() {
        db.collection("users").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching users: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Update users array with fetched data
            self.users = documents.compactMap { document in
                do {
                    return try document.data(as: Users.self)
                } catch {
                    print("Error decoding user: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }
    // Function to fetch tasks for the current authenticated user
    func fetchTasks() {
        // Fetch all tasks initially
        db.collection("tasks").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching tasks: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Update tasks array with fetched data
            self.tasks = documents.compactMap { document in
                do {
                    return try document.data(as: Task.self)
                } catch {
                    print("Error decoding task: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }

    // Function to get tasks for a specific user
    func tasksForUser(userId: String) -> [Task] {
        return tasks.filter { $0.userId == userId }
    }

    
    // Function to add a new task
    func addTask(title: String, details: String, color: String, type: String, userId: String,progress: Int, deadline: Date) {
        
        
        do {
            // Format current time
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let createdTime = dateFormatter.string(from: Date())
            
            // Create a new task and add it to Firestore
            let newTask = Task(title: title, details: details, color: color, type: type, deadline: deadline, isDone: false, createdTime: createdTime, userId: userId, progress: progress)
            _ = try db.collection("tasks").addDocument(from: newTask)
        } catch {
            print("Error adding task: \(error.localizedDescription)")
        }
    }

    // Function to toggle the status of a task (done or not done)
    func toggleTaskStatus(_ task: Task) {
        guard let documentID = task.id else { return }
        
        let updatedStatus = !task.isDone
        // Update task status in Firestore
        db.collection("tasks").document(documentID).updateData(["isDone": updatedStatus]) { error in
            if let error = error {
                print("Error updating task status: \(error.localizedDescription)")
            }
        }
    }
    
    // Function to edit the details of a task
    func editTask(_ task: Task, with title: String, details: String, color: String, type: String, progress: Int, deadline: Date, createdTime: String) {
        guard let documentID = task.id else { return }
        
        // Create an updated task and update it in Firestore
        let updatedTask = Task(id: documentID, title: title, details: details, color: color, type: type, deadline: deadline, isDone: task.isDone, createdTime: createdTime, userId: task.userId, progress: progress)
        
        do {
            try db.collection("tasks").document(documentID).setData(from: updatedTask, merge: true)
        } catch {
            print("Error updating task: \(error.localizedDescription)")
        }
    }
    
    // Function to delete a task
    func deleteTask(_ task: Task) {
        guard let documentID = task.id else { return }
        
        // Delete task from Firestore
        db.collection("tasks").document(documentID).delete { error in
            if let error = error {
                print("Error deleting task: \(error.localizedDescription)")
            }
        }
    }
}


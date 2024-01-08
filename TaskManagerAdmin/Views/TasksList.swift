//
//  TasksList.swift
//  TaskManagerApp
//
//  Created by eyh.mac on 7.01.2024.
//

import SwiftUI

// Extension on Date to check if the date is in the future (isNew)
extension Date {
    var isNew: Bool {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let taskDate = calendar.startOfDay(for: self)

        return taskDate >= currentDate
    }
}

// SwiftUI view struct representing a list of tasks
struct TasksList: View {
    @StateObject var taskManager: TaskManager // State object for managing the task manager
    var Tasks: [Task] {
        return taskManager.tasks.filter { !$0.isDone && $0.deadline.isNew } // Filter tasks based on completion status and whether they are new
    }
    
    var body: some View {
        // Vertical scroll view containing the list of tasks
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome Back 👋🏻")
                    .font(.title2)
                Text("Here's Update Today.")
                    .font(.title3.bold())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            VStack {
                // Check if there are no tasks, display a message and an image
                if taskManager.tasks.isEmpty {
                    VStack {
                        Text("No tasks added yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                        Image(systemName: "xmark.bin")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                } else {
                    // Display the list of tasks using LazyVStack
                    LazyVStack(spacing: 10) {
                        ForEach(Tasks) { task in
                            TaskCard(task: task, taskManager: TaskManager())
                        }
                        .padding(5)
                    }
                }
            }
            .padding(5)
        }
        .onAppear(perform: taskManager.fetchTasks) // Fetch tasks when the view appears
    }
}

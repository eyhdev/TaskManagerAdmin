//
//  TaskCard.swift
//  TaskManagerApp
//
//  Created by eyh.mac on 7.01.2024.
//

import SwiftUI

// SwiftUI view struct representing a task card
struct TaskCard: View {
    var task: Task // Task data model
    @StateObject var taskManager: TaskManager // State object for managing the task manager

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Type indicator (e.g., "Basic", "Urgent") with background color
            HStack {
                Text(task.type ?? "")
                    .foregroundColor(.white)
                    .font(.callout)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background {
                        Capsule()
                            .fill(.brown.opacity(0.8))
                    }
                Spacer()
                // Progress indicator (e.g., "100%") with background color
                Text(task.isDone ? "100%" : "\(task.progress)0%")
                    .foregroundColor(.white)
                    .font(.callout)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background {
                        Capsule()
                            .fill(.blue.opacity(0.8))
                    }
            }

            // Title of the task
            Text(task.title ?? "")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical)

            // Details of the task
            Text(task.details ?? "")
                .font(.subheadline.bold())
                .foregroundColor(.black)
                .padding(.vertical, 10)

            // Deadline and time information with icons (calendar and clock)
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    // Deadline with calendar icon
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)

                    // Time with clock icon
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Button to toggle task completion status (checkmark or circle icon)
                Button {
                    taskManager.toggleTaskStatus(task)
                } label: {
                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(.ultraThinMaterial))
    }
}

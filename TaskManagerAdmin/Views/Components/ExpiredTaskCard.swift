//
//  ExpiredTaskCard.swift
//  TaskManagerApp
//
//  Created by eyh.mac on 7.01.2024.
//

import SwiftUI

struct ExpiredTaskCard: View {
    var task: Task
    @StateObject var taskManager: TaskManager
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            //Type
            HStack {
                Text(task.type ?? "")
                    .foregroundColor(.gray)
                    .font(.callout)
                    .padding(.vertical,5)
                    .padding(.horizontal)
                    .background {
                        Capsule()
                            .fill(Color(task.color).opacity(0.7))
                    }
                Spacer()
            }
        
            Text(task.title ?? "")
                .font(.title2.bold())
                .padding(.vertical)
            
            Text(task.details ?? "")
                .font(.subheadline.bold())
                .padding(.vertical,10)
            
            
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)
                    
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))

                    } icon: {
                        Image(systemName: "clock")
                    }
                    .font(.caption)
                }
                .frame(maxWidth: .infinity,alignment: .leading)
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(.ultraThinMaterial))
    }
}

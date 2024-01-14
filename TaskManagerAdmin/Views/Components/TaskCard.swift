//
//  TaskCard.swift
//  TaskManagerApp
//
//  Created by eyh.mac on 7.01.2024.
//


import SwiftUI
import PDFKit
// SwiftUI view struct representing a task card
struct TaskCard: View {
    var task: Task // Task data model
    @StateObject var taskManager: TaskManager // State object for managing the task manager
    @State private var isShowingPDF = false
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
                            .foregroundStyle(.gray)
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)

                    // Time with clock icon
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                            .foregroundStyle(.gray)
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Button to toggle task completion status (checkmark or circle icon)
                HStack {
                    Button("Display PDF") {
                        isShowingPDF.toggle()
                    }
                    .sheet(isPresented: $isShowingPDF) {
                        PDFViewFromLink(url: task.fileURL ?? "") // Replace with your PDF URL
                    }
                    .padding(.horizontal)
                    
                    Button {
                        taskManager.toggleTaskStatus(task)
                    } label: {
                        Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                            .font(.title2)
                    }
                }
                
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(.ultraThinMaterial))
    }
}
import SwiftUI
import PDFKit

struct SharePDFView: UIViewControllerRepresentable {
    let pdfDocument: PDFDocument

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let pdfData = pdfDocument.dataRepresentation()!
        let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Update the view controller if needed
    }
}

struct PDFViewFromLink: View {
    let url: String

    @State private var isShareSheetPresented = false

    var body: some View {
        NavigationView {
            VStack {
                if let url = URL(string: url),
                   let pdfDocument = PDFDocument(url: url) {
                    PDFKitView(pdfDocument: pdfDocument)
                        .navigationBarTitle("PDF Viewer", displayMode: .inline)
                        .navigationBarItems(trailing:
                            HStack {
                                Button(action: {
                                    isShareSheetPresented.toggle()
                                }) {
                                    Image(systemName: "square.and.arrow.up")
                                }
                                .sheet(isPresented: $isShareSheetPresented) {
                                    SharePDFView(pdfDocument: pdfDocument)
                                }
                            }
                        )
                } else {
                    Text("Failed to load PDF.")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    let pdfDocument: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = pdfDocument
    }
}

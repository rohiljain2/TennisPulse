//
//  SessionDetailView.swift
//  TennisPulse
//
//  Created on [Date]
//

import SwiftUI

struct SessionDetailView: View {
    @StateObject private var viewModel: SessionDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingSetTypePicker = false
    @State private var showingDeleteConfirmation = false
    
    init(session: TrainingSession) {
        _viewModel = StateObject(wrappedValue: SessionDetailViewModel(session: session))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    sessionHeader
                    activeSetSection
                    setsList
                    notesSection
                    
                    if viewModel.isSessionCompleted {
                        NavigationLink {
                            SessionSummaryView(session: viewModel.session)
                        } label: {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                Text("View Summary")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Training Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            showingDeleteConfirmation = true
                        } label: {
                            Label("Delete Session", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .confirmationDialog(
                "Delete Session",
                isPresented: $showingDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    viewModel.deleteSession()
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this training session? This action cannot be undone.")
            }
            .sheet(isPresented: $showingSetTypePicker) {
                SetTypePickerView { type in
                    viewModel.startSet(type: type)
                    showingSetTypePicker = false
                }
            }
            .onChange(of: viewModel.isSessionCompleted) { isCompleted in
                if isCompleted {
                    // Optionally navigate to summary or show completion
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var sessionHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.session.date, style: .date)
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                Label(viewModel.session.formattedTotalDuration, systemImage: "clock")
                Spacer()
                Text("\(viewModel.session.sets.count) sets")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var activeSetSection: some View {
        Group {
            if viewModel.hasActiveSet, let activeSet = viewModel.activeSet {
                VStack(spacing: 16) {
                    // Active set card
                    VStack(spacing: 12) {
                        HStack {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 12, height: 12)
                                Text("Active Set")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            Spacer()
                        }
                        
                        Divider()
                        
                        HStack {
                            HStack(spacing: 12) {
                                Image(systemName: activeSet.type.icon)
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                    .frame(width: 40, height: 40)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(activeSet.type.displayName)
                                        .font(.headline)
                                    Text("Started \(activeSet.startTime, style: .relative)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(activeSet.formattedDuration)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .monospacedDigit()
                                    .foregroundColor(.green)
                                Text("Duration")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.green.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.green.opacity(0.2), lineWidth: 1)
                            )
                    )
                    
                    // End Set button
                    Button {
                        viewModel.endActiveSet()
                    } label: {
                        HStack {
                            Image(systemName: "stop.circle.fill")
                            Text("End Set")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
            } else {
                // Start New Set button
                Button {
                    showingSetTypePicker = true
                } label: {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .font(.title3)
                        Text("Start New Set")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var setsList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sets")
                .font(.headline)
            
            if viewModel.session.sets.isEmpty {
                Text("No sets recorded yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(viewModel.session.sets.filter { !$0.isActive }) { set in
                    SetRowView(set: set) {
                        viewModel.deleteSet(set)
                    }
                }
            }
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notes")
                .font(.headline)
            
            TextField("Add notes about this session...", text: Binding(
                get: { viewModel.session.notes ?? "" },
                set: { viewModel.updateNotes($0) }
            ), axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .lineLimit(3...6)
        }
    }
}

// MARK: - Set Row View

struct SetRowView: View {
    let set: TrainingSet
    let onDelete: () -> Void
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        HStack {
            Image(systemName: set.type.icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(set.type.displayName)
                    .font(.headline)
                
                Text(set.startTime, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(set.formattedDuration)
                .font(.headline)
                .monospacedDigit()
            
            Button {
                showingDeleteConfirmation = true
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .confirmationDialog(
            "Delete Set",
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this set?")
        }
    }
}

// MARK: - Set Type Picker View

struct SetTypePickerView: View {
    let onSelect: (SetType) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(SetType.allCases, id: \.self) { type in
                    Button {
                        onSelect(type)
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: type.icon)
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            Text(type.displayName)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Select Set Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}


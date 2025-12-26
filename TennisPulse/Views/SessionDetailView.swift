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
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("Active Set", systemImage: "circle.fill")
                            .font(.headline)
                            .foregroundColor(.green)
                        Spacer()
                        Button("End Set") {
                            viewModel.endActiveSet()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    HStack {
                        Label(activeSet.type.displayName, systemImage: activeSet.type.icon)
                        Spacer()
                        Text(activeSet.formattedDuration)
                            .font(.title3)
                            .monospacedDigit()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            } else {
                Button {
                    showingSetTypePicker = true
                } label: {
                    Label("Start New Set", systemImage: "play.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
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


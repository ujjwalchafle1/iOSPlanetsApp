//
//  PlanetListView.swift
//  Planets
//
//  Created by Ujjwal on 28/04/2023.
//

import SwiftUI

struct PlanetListView: View {
    @ObservedObject var viewModel: PlanetsViewModel
    @State private var showAlert: (Bool, String) = (false, "")
    @State private var selectedPlanetOnLaunch: Planet?
    
    init(viewModel: PlanetsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            stateView
                .navigationTitle("Planets")
        }
    }
    
    @ViewBuilder
    var stateView: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView().progressViewStyle(.circular)
                .onAppear {
                    Task {
                        await viewModel.getPlanetsData()
                    }
                }
            
        case .content(let planets):
            content(planets)
                .refreshable {
                    Task {
                        await viewModel.getPlanetsData()
                    }
                }
            
            if UIDevice.isPad {
                PlanetDetailView(planet: planets.first)
                    .navigationTitle("")
            }
            
        case .empty:
            emptyDataView()
                .onReceive(viewModel.viewChangingStateEvents, perform: { viewEvent in
                    switch viewEvent {
                    case .showErrorAlert(let message):
                        showAlert = (true, message)
                    }
                })
                .alert(isPresented: $showAlert.0) {
                    Alert(
                        title: Text("Error"),
                        message: Text(showAlert.1),
                        primaryButton: .default(Text("Cancel")),
                        secondaryButton: .default(Text("Retry")) {
                            Task {
                                await viewModel.getPlanetsData()
                            }
                        })
                }
        }
    }
}

extension PlanetListView {
    private func content(_ planets: [Planet]) -> some View {
        List {
            ForEach(planets, id: \.self) { planet in
                NavigationLink {
                    PlanetDetailView(planet: planet)
                } label: {
                    HStack {
                        Image(systemName: "globe")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.secondary)
                            .padding()
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text(planet.name)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            
                            HStack(spacing: 8) {
                                Text("Diameter:")
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                                
                                Text(planet.diameter)
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                            }
                            .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
    }
    
    private func emptyDataView() -> some View {
        VStack(spacing: 16) {
            Text("No data to display!")
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .padding()
            
            Button {
                Task {
                    await viewModel.getPlanetsData()
                }
            } label: {
                HStack {
                    Image(systemName: "icloud.and.arrow.down.fill")
                    Text("Refresh")
                }
            }
        }
    }
}


extension UIDevice {
    static var isPad: Bool {
        current.userInterfaceIdiom == .pad
    }
}

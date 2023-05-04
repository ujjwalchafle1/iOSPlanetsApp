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
    
    init(viewModel: PlanetsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.viewState {
                    case .loading:
                        ProgressView().progressViewStyle(.circular)
                        
                    case .content(let planets):
                        content(planets)
                            .refreshable {
                                viewModel.getPlanetsData()
                            }
                        
                    case .empty:
                        emptyDataView()
                }
            }
            
            .onAppear {
                viewModel.getPlanetsData()
            }
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
                        viewModel.getPlanetsData()
                    })
            }
            .navigationTitle("Planets")
        }
        .navigationViewStyle(.stack)
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
                viewModel.getPlanetsData()
            } label: {
                HStack {
                    Image(systemName: "icloud.and.arrow.down.fill")
                    Text("Refresh")
                }
            }

        }
    }
}

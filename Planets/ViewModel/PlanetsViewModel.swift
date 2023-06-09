//
//  PlanetsViewModel.swift
//  Planets
//
//  Created by Ujjwal on 28/04/2023.
//

import Foundation
import Combine
import CoreData

enum ViewState: Equatable {
    case empty
    case loading
    case content([Planet])
}

enum ViewStateChangeEvent {
    case showErrorAlert(String)
}

final class PlanetsViewModel: ObservableObject {
    
    @Published var viewState: ViewState = .loading
    private var service: PlanetsService
    var viewChangingStateEvents: AnyPublisher<ViewStateChangeEvent, Never>
    private var _viewChangingStateEvents: PassthroughSubject<ViewStateChangeEvent, Never>
    
    init(
        viewState: ViewState = .loading,
        service: PlanetsService
    ) {
        self.viewState = viewState
        self.service = service
        _viewChangingStateEvents = PassthroughSubject<ViewStateChangeEvent, Never>()
        self.viewChangingStateEvents = _viewChangingStateEvents.eraseToAnyPublisher()
    }
    
    @MainActor
    func getPlanetsData() async {
        do {
            let planets = try await service.getPlanetsData()
                self.viewState = planets.isEmpty ? .empty : .content(planets)
        } catch let error {
                self.viewState = .empty
                self._viewChangingStateEvents.send(.showErrorAlert(error.localizedDescription))
        }
    }
}

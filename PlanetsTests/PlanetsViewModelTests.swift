//
//  PlanetsViewModelTests.swift
//  PlanetsTests
//
//  Created by Ujjwal Chafle on 02/05/2023.
//

import XCTest
@testable import Planets

final class PlanetsViewModelTests: XCTestCase {

    func test_init_viewStateIsLoading() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func test_emptyViewState_success_with_no_data() {
        let (sut, service) = makeSUT()

        expect(sut) {
            service.complete(completion: .success([]))
        }

        XCTAssertEqual(sut.viewState, .empty)
    }
    
    func test_contentViewState_success_with_data() {
        let (sut, service) = makeSUT()
        let item1 = Planet(name: "planet1", diameter: "1234")
        let item2 = Planet(name: "planet2", diameter: "1234")

        expect(sut) {
            service.complete(completion: .success([item1, item2]))
        }

        XCTAssertEqual(sut.viewState, .content([item1, item2]))
    }
    
    func test_emptyViewState_failure_with_error() {
        let (sut, service) = makeSUT()
        
        expect(sut) {
            service.complete(completion: .failure(.apiError("connection error")))
        }
        
        XCTAssertEqual(sut.viewState, .empty)
    }
    
    //MARK: Helper Methods
    func makeSUT() -> (PlanetsViewModel, MockPlanetService) {
        let service = MockPlanetService()
        return (PlanetsViewModel(service: service), service)
    }
    
    func expect(_ sut: PlanetsViewModel, when action: () -> Void) {
        action()
        sut.getPlanetsData()
        executeRunLoop()
    }
    
    func executeRunLoop() {
        RunLoop.current.run(until: Date()+5)
    }
}

class MockPlanetService: PlanetsService {
    private var messages = [Result<[Planet], NetworkError>]()
    
    func getPlanetsData(completion: @escaping (Result<[Planet], NetworkError>) -> Void) {
        completion(messages.first!)
    }
    
    func complete(completion:  Result<[Planet], NetworkError>) {
        messages.append(completion)
    }
}


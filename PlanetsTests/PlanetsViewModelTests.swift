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
        let sut = makeSUT()
        
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func test_emptyViewState_success_with_no_data() {
        // Given
        let sut = makeSUT()
        // When
        sut.getPlanetsData()
        executeRunLoop()
        
        // Then
        XCTAssertEqual(sut.viewState, .empty)
    }
    
    func test_contentViewState_success_with_data() {
        // Given
        let sut = makeSUT(result: .success([.mockItem1]))
        // When
        sut.getPlanetsData()
        executeRunLoop()
        
        // Then
        XCTAssertEqual(sut.viewState, .content([.mockItem1]))
    }
    
    func test_emptyViewState_failure_with_error() {
        // Given
        let sut = makeSUT(result: .failure(.emptyData))
        // When
        sut.getPlanetsData()
        executeRunLoop()
        
        // Then
        XCTAssertEqual(sut.viewState, .empty)
    }
    
    //MARK: Helper Methods
    func makeSUT(result: Result<[Planet], NetworkError> = .success([])) -> PlanetsViewModel {
        let service = MockPlanetService(result: result)
        return PlanetsViewModel(service: service)
    }
        
    func executeRunLoop() {
        RunLoop.current.run(until: Date()+1)
    }
}

private extension Planet {
    static let mockItem1 = Self(name: "planet1", diameter: "1234")
}

private class MockPlanetService: PlanetsService {
    let result: Result<[Planet], NetworkError>
    
    init(result: Result<[Planet], NetworkError>) {
        self.result = result
    }
    
    func getPlanetsData(completion: @escaping (Result<[Planet], NetworkError>) -> Void) {
        completion(result)
    }
}


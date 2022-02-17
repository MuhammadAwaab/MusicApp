//
//  BandLabSampleTests.swift
//  BandLabSampleTests
//
//  Created by Muhammad Oneeb on 14/02/2022.
//

import XCTest
@testable import BandLabSample

class BandLabSampleTests: XCTestCase {

    
    var mockProvider: DataProviderProtocol?
    var viewModelToTest: MainViewModelProtocol?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMainViewModel() throws {
        
        viewModelToTest?.fetchParsedDataForDisplay()
        let songViewModel = viewModelToTest?.getCellViewModel(at: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(songViewModel)
        
        let songName = songViewModel?.displayData.name
        let songID = songViewModel?.displayData.id
        XCTAssertTrue(songName == "TestSong")
        XCTAssertTrue(songID == "01010101")
        
        
        
    }

    override func setUp() {
        super.setUp()
        mockProvider = MockDataProvider()
        viewModelToTest = MainViewModel(provider: mockProvider!)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

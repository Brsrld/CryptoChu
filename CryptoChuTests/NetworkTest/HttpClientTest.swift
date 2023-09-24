//
//  HttpClientTest.swift
//  CryptoChuTests
//
//  Created by Barış Şaraldı on 24.09.2023.
//

import XCTest
@testable import CryptoChu

class HttpClientTest: XCTestCase, Mockable, HTTPClient {
    var urlSession: URLSession!
    var endpoint: Endpoint!
    
    let mockString =
    """
    {
        "status": "success",
        "data": {
            "markets": [
                {
                    "market_code": "BTCTRY",
                    "url_symbol": "btctry",
                    "base_currency": "BTC",
                    "counter_currency": "TRY",
                    "minimum_order_amount": "50.00",
                    "maximum_order_amount": "1000000.00",
                    "base_currency_decimal": 8,
                    "counter_currency_decimal": 2,
                    "presentation_decimal": 2,
                    "resell_market": false,
                    "min_multiplier": "0.60",
                    "max_multiplier": "3.00",
                    "list_date": 0,
                    "base_currency_name": "Bitcoin",
                    "counter_currency_name": "Türk Lirası",
                    "trigger_order": {
                        "L": true,
                        "M": true
                    }
                }
            ]
        }
    }
    """
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        urlSession = URLSession(configuration: config)
        endpoint = ListAllMarketInfo()
    }
    
    override func tearDown() {
        urlSession = nil
        endpoint = nil
        super.tearDown()
    }
    
    func test_Get_Data_Success() async throws {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        
        let response = HTTPURLResponse(url: urlComponents.url!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])!
        
        let mockData: Data = Data(mockString.utf8)
        
        MockURLProtocol.requestHandler = { request in
            return (response, mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        Task {
            let result = await sendRequest(endpoint: endpoint,
                                           responseModel: MarketInfoModel.self,
                                           urlSession: urlSession)
            switch result {
            case .success(let success):
                XCTAssertEqual(success.data?.markets?.first?.marketCode,"BTCTRY")
                XCTAssertEqual(success.data?.markets?.count, 1)
                expectation.fulfill()
            case .failure(let failure):
                XCTAssertThrowsError(failure)
            }
        }
#if swift(>=5.8)
        await fulfillment(of: [expectation], timeout: 2)
#else
        wait(for: [expectation], timeout: 2)
#endif
        
    }
    
    func test_News_BadResponse() {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        
        let response = HTTPURLResponse(url: urlComponents.url!,
                                       statusCode: 400,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])!
        
        let mockData: Data = Data(mockString.utf8)
        
        MockURLProtocol.requestHandler = { request in
            return (response, mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        Task {
            let result = await sendRequest(endpoint: endpoint,
                                           responseModel: MarketInfoModel.self,
                                           urlSession: urlSession)
            switch result {
            case .success(_):
                XCTAssertThrowsError("Fatal Error")
            case .failure(let failure):
                XCTAssertEqual(RequestError.unexpectedStatusCode, failure)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func test_News_EncodingError() {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        
        let response = HTTPURLResponse(url: urlComponents.url!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])!
        
        let mockData: Data = Data(mockString.utf8)
        
        MockURLProtocol.requestHandler = { request in
            return (response, mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        Task {
            let result = await sendRequest(endpoint: endpoint,
                                           responseModel: MarketInfoModel.self,
                                           urlSession: urlSession)
            switch result {
            case .success(_):
                XCTAssertThrowsError("Fatal Error")
            case .failure(let failure):
                XCTAssertEqual(RequestError.decode, failure)
                expectation.fulfill()
            }
        }
    }
}


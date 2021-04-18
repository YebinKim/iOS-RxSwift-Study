//
//  SearchAPIConstant.swift
//  iTunesSearchRxSwift
//
//  Created by Yebin Kim on 2021/04/18.
//

import Foundation

// MARK: - API Constant
enum SearchAPIConstant {

    case search(String)

    static let baseUrl: String = "https://itunes.apple.com"

    var url: URL {
        switch self {
        case .search:
            return URL(string: "\(SearchAPIConstant.baseUrl)\(path)\(query)")!
        }
    }

    var method: String {
        switch self {
        case .search:
            return "GET"
        }
    }

    private var query: String {
        switch self {
        case .search(let searchItem):
            return "/media=music&entity=song&term=\(searchItem)"
        }
    }

    private var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }
}

//
//  RestaurantsListViewModel.swift
//  MVVMRxSwift
//
//  Created by Yebin Kim on 2021/04/13.
//

import Foundation
import RxSwift

final class RestaurantsListViewModel {

    let title = "Restaurants"

    private let searchService: SearchServiceProtocol

    init(restaurantService: SearchServiceProtocol = SearchService()) {
        self.searchService = restaurantService
    }

    func fetchRestaurantViewModel() -> Observable<[Track]> {
        searchService.getSearchResults(searchItem: "shawn")
            .map {
                $0
            }
    }
}

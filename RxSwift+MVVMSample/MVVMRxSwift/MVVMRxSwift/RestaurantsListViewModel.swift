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

    private let restaurantService: RestaurantServiceProtocol

    init(restaurantService: RestaurantServiceProtocol = RestaurantService()) {
        self.restaurantService = restaurantService
    }

    func fetchRestaurantViewModel() -> Observable<[RestaurantViewModel]> {
        restaurantService.fetchRestaurants()
            .map {
                $0.map { RestaurantViewModel(restaurant: $0) }
            }
    }
}

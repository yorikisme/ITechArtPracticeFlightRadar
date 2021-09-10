//
//  Service.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 9/9/21.
//

import Foundation
protocol ServiceProtocol {
    var networkService: NetworkManagerProtocol { get }
}

class Service: ServiceProtocol {
    let networkService: NetworkManagerProtocol = NetworkManager()
}

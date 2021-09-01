//
//  State.swift
//  ITechArtPracticeFlightRadar
//
//  Created by Yaroslav Karpulevich on 8/30/21.
//

enum State {
    case standby
    case processing
    case failure(Error)
}

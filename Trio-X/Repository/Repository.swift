//
//  File.swift
//  Trio-X
//
//  Created by Kunal Yelne on 28/09/24.
//

import Foundation

protocol Repository {
    func fetchProcessInfoList() async -> Result<[ProcessInfo], DataRequestError>
}

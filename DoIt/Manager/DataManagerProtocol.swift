//
//  DataManagerProtocol.swift
//  DoIt
//
//  Created by iem on 06/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation

protocol DataManagerProtocol : class {
    
    associatedtype T
    
    func addItem(item: T)
    
    func moveItem(sourceIndex: Int, destinationIndex: Int)
    
    func removeItem(item: T)
    
    func filterItems(filter: String)
}

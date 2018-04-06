//
//  DataManagerProtocol.swift
//  DoIt
//
//  Created by iem on 06/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation

protocol DataManagerProtocol : class {
    
    func addItem(text: String)
    
    func moveItem(sourceIndex: Int, destinationIndex: Int)
    
    func removeItem(index: Int)
    
    func filterItems(filter: String)
    
    func toggleCheckItem(index: Int)
    
}

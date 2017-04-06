//
//  RGAPIPagination.swift
//  iOSHomeWork
//
//  Created by Matt Andrzejczuk on 4/5/17.
//  Copyright © 2017 Harry Tormey. All rights reserved.
//

import Foundation


extension MainViewController {
    
    func loadMoreResults() {
        paginationOffset += 25
        api.search(keyword: currentSearchText, pagination: paginationOffset)
    }

}

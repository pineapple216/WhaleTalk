//
//  TableViewFetchedResultsDisplayer.swift
//  WhaleTalk
//
//  Created by Koen Hendriks on 16/05/16.
//  Copyright © 2016 Koen Hendriks. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewFetchedResultsDisplayer {
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath)
}
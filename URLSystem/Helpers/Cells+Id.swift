//
//  Cells+Id.swift
//  URLSystem
//
//  Created by Serhii Rosovskyi on 07.03.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var id: String { get { return String(describing: self) } }
}


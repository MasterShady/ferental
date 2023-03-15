//
//  SWBaseTableView.swift
//  DoFunNew
//
//  Created by mac on 2021/2/26.
//

import UIKit

open class SWBaseTableView: UITableView,UIGestureRecognizerDelegate {

    //同时识别多个收拾
    open  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

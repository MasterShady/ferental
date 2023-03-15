//
//  SWBaseTableViewCell.swift
//  DoFunNew
//
//  Created by mac on 2021/3/4.
//

import UIKit

open class SWBaseTableViewCell: UITableViewCell, PublicMethod {

    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        uiConfigure()
        myAutoLayout()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    open func uiConfigure() {
        
    }
    
    open func myAutoLayout() {
        
    }
    
}

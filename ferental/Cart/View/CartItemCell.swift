//
//  CartItemCell.swift
//  ferental
//
//  Created by 刘思源 on 2023/3/29.
//

import Foundation

class CartItemCell : UITableViewCell{
    let deviceCard: DeviceCartCard = .init(frame: .zero)
    let checkbox = UIButton()
    let itemsCount = UILabel()
    
    //var checkBoxHandler : Block!
    var addHandler: Block!
    var minusHandler: Block!
    
    var item : CartItem?{
        didSet{
            deviceCard.device = item?.device
            checkbox.isSelected = item?.selected ?? false
            itemsCount.text = String(item?.count ?? 1)
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.configSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configSubView(){
        self.contentView.addSubview(checkbox)
        checkbox.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        let cart_checkbox_normal = UIImage.init(named: "cart_checkbox_normal")?.resizeImageToSize(size: CGSize(width: 20, height: 20))
        let cart_checkbox_selected = UIImage.init(named: "cart_checkbox_selected")?.resizeImageToSize(size: CGSize(width: 20, height: 20))
        checkbox.chain.normalImage(cart_checkbox_normal).selectedImage(cart_checkbox_selected)
        
        
        self.contentView.addSubview(deviceCard)
        deviceCard.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(checkbox.snp.right).offset(14)
        }
        
        
        let minusBtn = UIButton()
        minusBtn.chain.normalImage("cart_minus")
        minusBtn.addBlock(for: .touchUpInside) {[weak self] _ in
            guard let self = self else { return }
            self.minusHandler()
            
        }
        
        let addBtn = UIButton()
        addBtn.chain.normalImage("cart_add")
        addBtn.addBlock(for: .touchUpInside) {[weak self] _ in
            guard let self = self else {return}
            self.addHandler()
        }
        

        
        itemsCount.snp.makeConstraints { make in
            make.width.equalTo(37)
        }
        
        itemsCount.chain.font(.systemFont(ofSize: 14)).text(color: .kTextBlack).textAlignment(.center).text("1")
        
        
        let stack = UIStackView(arrangedSubviews: [minusBtn,itemsCount,addBtn])
        stack.axis = .horizontal
        stack.spacing = 0
        
        contentView.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.right.equalTo(-14)
            make.bottom.equalTo(-14)
        }
    }
}

//
//  HomeTableViewCell.swift
//  SwiftTransition
//
//  Created by iOS on 2018/12/1.
//  Copyright © 2018 AidaHe. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    var bgImageView:UIImageView?
    var bgView:UIView?
    var titleLabel:UILabel?
    var contentLabel:UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupSubViews(){
        bgView = UIView(frame: CGRect(x: 20, y: 0, width: kScreenWidth-40, height: (kScreenWidth-40)*1.3 + 25))
        bgView?.backgroundColor = UIColor.clear
        self.contentView.addSubview(bgView!)
        
        bgImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth-40, height: (kScreenWidth-40)*1.3))
        bgView?.addSubview(bgImageView!)
        bgImageView?.image = UIImage(named: "Home_demo_01")
        bgImageView?.layer.cornerRadius = 15
        bgImageView?.layer.masksToBounds = true
        
        titleLabel = UILabel(frame: CGRect(x: 15, y: 20, width: kScreenWidth-30, height: 30))
        titleLabel?.textColor = UIColor.white
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        
        contentLabel = UILabel(frame: CGRect(x: 15, y: (kScreenWidth-40)*1.3-30, width: kScreenWidth-44, height: 15))
        contentLabel?.font = UIFont(name: "PingFangSC-Light", size: 15)
        contentLabel?.alpha = 0.5
        contentLabel?.textColor = UIColor.white
        bgView?.addSubview(titleLabel!)
        bgView?.addSubview(contentLabel!)
    }
    
}

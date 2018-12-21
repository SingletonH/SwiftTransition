//
//  ViewController.swift
//  SwiftTransition
//
//  Created by iOS on 2018/12/1.
//  Copyright © 2018 AidaHe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectIndexPath:IndexPath?
    var images = ["Home_demo_01","Home_demo_02","Home_demo_03"]
    var titles = ["哈弗H6Coupe震撼上市","黑天鹅蛋糕","高端健身会所入驻园区"]
    var subTitles = ["体验“中国芯”动力新哈弗H6 Coupe","“我的一生，为美而感动，为美而存在”","让运动助力工作生活"]
    var contents = ["前卫设计动感十足 体验“中国芯”动力新哈弗H6 Coupe\n新哈弗H6 Coupe是长城公司采用全新设计语言开发的一款具有酷颜值，酷动力，酷装备的SUV。此次新哈弗H6 Coupe由内而外的全面升级，必将引来大众的追捧，开创哈弗SUV新篇章...\n1.5GDIT发动机应用CVVL、缸内直喷等前沿技术，动力响应快、燃油经济性好，最大功率124kW，1400转爆发最大扭矩285N·m，百公里加速9.7s，百公里油耗仅6.8L，荣获“中国心”2017十佳发动机；\n7DCT湿式双离合变速器采用最先进的摩擦材料，速比范围高达8.0，换挡平顺、可靠性高，提升燃油经济性,荣获2018届世界十佳变速器。\n整车采用超刚性一体式安全结构车身；\n配备奥托立夫6安全气囊、帘式气囊贯穿前后，保护面积更宽泛；\n盲点侦测，保证行车安全；\n配备360环视影像系统、LED组合前灯，驾乘更安全。\n外观采用钻石形体光学设计，车身线条硬朗连贯，更动感；\n内饰采用大面贯穿式整体设计，断面式仪表板极具立体感，打造科技及尊享兼备的体验。","一兆韦德健身管理有限公司目前有员工3000多人，拥有超过一百家健身会所。公司大力倡导绿色环保和时尚健身运动。凭借先进的管理理念、丰富的行业经验、完善的管理体系和管理团队，业已成为业内发展速度快、分店数量多、会员数量众多的健身连锁机构。公司多次通过权威机构认证，目前由国际著名投资公司——新加坡淡马锡集团注资，2015年更是获得了上海市著名商标，是健身行业内首个获得该荣誉的企业。公司希望通过全体员工的努力为社会提供有价值的健康生活服务，成为具世界竞争力的连锁健身企业之一。公司将打造更多的绿色生态会馆、为美好的城市生活贡献更多力量。","黑天鹅 \n隶属于北京黑天鹅餐饮管理有限公司，公司主要打造国内品质卓越，美味安心的蛋糕。黑天鹅蛋糕源于黄金比例的配方，精选世界各地优质食材，让您和朋友轻松享受精品蛋糕。\n用新锐的艺术理念和国际化的视野，带领团队重塑品牌，开启了黑天鹅与全球顶尖的甜品大师、设计大师和顶级原料商全面合作的阶段，让黑天鹅的产品和形象获得蜕变和飞跃，迅速跻身于国际一流烘焙品牌的行列。\n黑天鹅蛋糕推出以来，一直以一种“昂贵、奢华、精美”的形象示人，北京的首家实体店铺，自然要延续这个风格。先站在门口拍一张，这种风格的铺面，在蛋糕店里绝对令人耳目一新。"]
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    
    func setupTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(HomeTableViewCell.classForCoder(), forCellReuseIdentifier: "HomeTableViewCell")
        tableView.backgroundColor = UIColor.clear
    }

    //MARK: 截屏
    func imageFromView() ->UIImage{
        UIGraphicsBeginImageContext(self.view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        self.view.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    

}

// MARK: TableView delegate
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (kScreenWidth-40)*1.3+25
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeTableViewCell(style: .default, reuseIdentifier: "HomeTableViewCell")
        
        cell.selectionStyle = .none
        cell.shouldGroupAccessibilityChildren = true
        cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        cell.titleLabel?.text = titles[indexPath.row]
        cell.bgImageView?.image = UIImage(named: images[indexPath.row])
        cell.contentLabel?.text = subTitles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = DetailViewController()
        nextVC.selectIndexPath = selectIndexPath
        nextVC.imageName = images[indexPath.row]
        nextVC.detailTitle = titles[indexPath.row]
        nextVC.subTitle = subTitles[indexPath.row]
        nextVC.content = contents[indexPath.row]
        nextVC.bgImage = imageFromView()
        let cell = tableView.cellForRow(at: indexPath)
        cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.navigationController?.pushViewController(nextVC, animated: true)

    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath)
        selectIndexPath = indexPath
        UIView.animate(withDuration: 0.2) {
            print("缩小 frame")
            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        return true
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if selectIndexPath == indexPath {
            UIView.animate(withDuration: 0.2) {
                print("恢复 frame")
                cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
                return
            }
        }
    }
}

//MARK: Navigation Delegate
extension ViewController:UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return self
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let cell:HomeTableViewCell = tableView.cellForRow(at: selectIndexPath!) as! HomeTableViewCell
        let toVC:UIViewController = transitionContext.viewController(forKey: .to)!
        let toView:UIImageView = toVC.value(forKeyPath:"headerImageView") as! UIImageView
        let fromView = cell.bgView
        
        let containerView = transitionContext.containerView
        let snapshotView = UIImageView(image: cell.bgImageView!.image)
        snapshotView.frame = containerView.convert((fromView?.frame)!, from: fromView?.superview)

        fromView?.isHidden = true
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0
        toView.isHidden = true
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 20, width: kScreenWidth-30, height: 30))
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.text = cell.titleLabel?.text
        
        let contentLabel = UILabel(frame: CGRect(x: 15, y: (kScreenWidth-40)*1.3-30, width: kScreenWidth-30, height: 15))
        contentLabel.textColor = UIColor.white
        contentLabel.text = cell.contentLabel?.text
        contentLabel.font = UIFont(name: "PingFangSC-Light", size: 15)
        contentLabel.alpha = 0.5
        snapshotView.addSubview(titleLabel)
        snapshotView.addSubview(contentLabel)
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshotView)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .curveLinear, animations: {
                    containerView.layoutIfNeeded()
                    toVC.view.alpha = 1.0
                    self.view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
                    snapshotView.frame = containerView.convert(toView.frame, from: toView.superview)
                    titleLabel.frame = CGRect(x: 22, y: 30, width: kScreenWidth - 30, height: 30)
                    contentLabel.frame = CGRect(x: 22, y: kScreenWidth*1.3-30, width: kScreenWidth*1.3-44, height: 15)
        
                }) { (finished) in
        
                    toView.isHidden = false
                    fromView?.isHidden = false
                    snapshotView.removeFromSuperview()
                    self.tableView.reloadData()
                    transitionContext.completeTransition(true)
                }
        
    }

    
    
}

//
//  DetailViewController.swift
//  SwiftTransition
//
//  Created by iOS on 2018/12/1.
//  Copyright © 2018 AidaHe. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var detailTableView:UITableView?
    @objc var headerImageView:UIImageView?
    var bgImageView:UIImageView?
    var bgImage:UIImage?
    
    var cellHeight:CGFloat?
    var startPointX:CGFloat = 0
    var startPointY:CGFloat = 0
    var scale:CGFloat = 1
    var isHorizontal:Bool = false
    var selectIndexPath:IndexPath?
    
    var detailTitle: String?
    var subTitle: String?
    var imageName: String?
    var content: String?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Detail View will appear")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orange
        print("Detail View did load")
        initData()
        setupSubView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Detail View will disappear")
    }
    
    func initData(){
        self.view.backgroundColor = UIColor.clear
        self.navigationController?.delegate = self
        scale = 1
    }
    
    func setupSubView() {
        bgImageView = UIImageView(frame: self.view.bounds)
        bgImageView?.image = bgImage!
        self.view.addSubview(bgImageView!)
        
        let effect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.view.addSubview(effectView)
        
        detailTableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        self.view.addSubview(detailTableView!)
        detailTableView?.delegate = self
        detailTableView?.dataSource = self
        detailTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        detailTableView?.showsVerticalScrollIndicator = false
        detailTableView?.tableHeaderView = setupHeaderView()
        detailTableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "TableViewCell")
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))
        detailTableView?.addGestureRecognizer(pan)
        pan.delegate = self

    }
    
    func setupHeaderView() ->UIView{
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth*1.3))
        headerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth*1.3))
        headerImageView?.image = UIImage(named: imageName!)
        let titleLabel = UILabel(frame: CGRect(x: 22, y: 30, width: kScreenWidth-44, height: 30))
        titleLabel.textColor = UIColor.white
        titleLabel.text = detailTitle!
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        let subLabel = UILabel(frame: CGRect(x: 22, y: kScreenWidth*1.3-30, width: kScreenWidth-44, height: 15))
        subLabel.text = subTitle!
        subLabel.textColor = UIColor.white
        subLabel.alpha = 0.5
        subLabel.font = UIFont(name: "PingFangSC-Light", size: 15)
        headerView.addSubview(headerImageView!)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subLabel)
        
        return headerView
    }
    
    @objc func handleGesture(_ sender:UIGestureRecognizer){
        
        weak var weakSelf = self
        
        switch sender.state {
        case .began:
            print("手势开始---")
            let currentPoint = sender.location(in: self.detailTableView)
            startPointX = currentPoint.x
            startPointY = currentPoint.y
            isHorizontal = (startPointX > CGFloat(30)) ? false : true
            break
        case .changed:
            print("拖动中----")
            let currentPoint = sender.location(in: self.detailTableView)
            
            if isHorizontal {
                if ((currentPoint.x-startPointX)>(currentPoint.y-startPointY)) {
                    scale = (kScreenWidth-(currentPoint.x-startPointX))/kScreenWidth
                } else {
                    scale = (kScreenHeight-(currentPoint.y-startPointY))/kScreenHeight
                }
            } else {
                scale = (kScreenHeight-(currentPoint.y-startPointY))/kScreenHeight
            }
            
            if (scale > CGFloat(1)) {
                scale = CGFloat(1)
            } else if (scale <= CGFloat(0.8)) {
                scale = CGFloat(0.8);
            }
            if (self.detailTableView!.contentOffset.y<=0) {
                // 缩放
                self.detailTableView!.transform = CGAffineTransform(scaleX: scale, y: scale)
                // 圆角
                self.detailTableView!.layer.cornerRadius = 15 * (1-scale)*5*1.08;
            }
            
            self.detailTableView!.isScrollEnabled = (scale < 0.99) ? false : true
            break
        case .ended:
            print("手势结束--")
            if(scale == 0.8){
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    weakSelf?.navigationController?.popViewController(animated: true)
                }
            }
            
            self.detailTableView!.isScrollEnabled = true
            if scale > CGFloat(0.8) {
                UIView.animate(withDuration: 0.2) {
                    weakSelf?.detailTableView!.layer.cornerRadius = 0
                    weakSelf?.detailTableView!.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                
            }
            break
        default:
            break
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: TableView delegate
extension DetailViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UILabel().getLabHeigh(labelStr: content!, font: UIFont(name: "PingFangSC-Light", size: 17)! , width: kScreenWidth-36)
        return 62+height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TableViewCell")
        
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = UIColor.white
        cell.backgroundColor = UIColor.white
        
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Light", size: 17)
        label.textColor = UIColor.hexadecimalColor(hexadecimal: "7f7f82")
        label.text = content!
        label.numberOfLines = 0
        let height = label.getLabHeigh(labelStr: content!, font: label.font, width: kScreenWidth-36)
        label.frame = CGRect(x: 18, y: 42, width: kScreenWidth-36, height: height)
        cell.contentView.addSubview(label)
        
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y <= 0) {
            
            var rectQ:CGRect = self.headerImageView!.frame
            rectQ.origin.y = scrollView.contentOffset.y
            self.headerImageView!.frame = rectQ
            
//            let rectT:CGRect = _titleLabel.frame;
//            rectT.origin.y = scrollView.contentOffset.y+30;
//            _titleLabel.frame = rectT;
//
//            let rectC:CGRect = _titleTwoLabel.frame;
//            rectC.origin.y = scrollView.contentOffset.y +SCREEN_WIDTH*1.3-30;
//            _titleTwoLabel.frame = rectC;
        }
    }
}


//MARK: Navigation Delegate
extension DetailViewController:UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        print("transitionDuration---2")
        return 1.0
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        print("navigationController---2")
        return self
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        print("animateTransition--2")
        let toVC:ViewController = transitionContext.viewController(forKey: .to) as! ViewController
        let fromVC:DetailViewController = transitionContext.viewController(forKey: .from) as! DetailViewController
        let containerView = transitionContext.containerView

        let fromView:UIImageView = fromVC.value(forKeyPath: "headerImageView") as! UIImageView
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        
        let cell:HomeTableViewCell = toVC.tableView.cellForRow(at: selectIndexPath!) as!HomeTableViewCell
        let originView = cell.bgImageView
        
        let snapShotView = fromView.snapshotView(afterScreenUpdates: false)
        snapShotView?.layer.masksToBounds = true
        snapShotView?.layer.cornerRadius = 15
        snapShotView?.frame = containerView.convert(fromView.frame, from: fromView.superview)
        fromView.isHidden = true
        originView?.isHidden = true
        
        let titleLabel = UILabel(frame: CGRect(x: 22, y: 20, width: kScreenWidth-30, height: 30))
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.text = detailTitle
        
        let contentLabel = UILabel(frame: CGRect(x: 22, y: kScreenWidth*1.3-30, width: kScreenWidth-44, height: 15))
        contentLabel.textColor = UIColor.white
        contentLabel.text = subTitle
        contentLabel.font = UIFont(name: "PingFangSC-Light", size: 15)
        contentLabel.alpha = 0.5
        snapShotView?.addSubview(titleLabel)
        snapShotView?.addSubview(contentLabel)
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        containerView.addSubview(snapShotView!)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            containerView.layoutIfNeeded()
            fromVC.view.alpha = 0
            snapShotView!.layer.cornerRadius = 15
            snapShotView?.frame = containerView.convert((originView?.frame)!, from: originView?.superview)
            titleLabel.frame = CGRect(x: 15, y: 20, width: kScreenWidth-30, height: 30)
            contentLabel.frame = CGRect(x: 15, y: (kScreenWidth-40)*1.3-30, width: kScreenWidth-44, height: 15)
            
        }) { (finished) in
            fromView.isHidden = true
            snapShotView?.removeFromSuperview()
            originView?.isHidden = false
            transitionContext.completeTransition(true)
        }
        
    }
    
    
}

// MARK:UIGestureRecognizerDelegate
extension DetailViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
//        if((otherGestureRecognizer.view?.isKind(of: UITableView.classForCoder()))!){
//            return true
//        }
        
        return true
    }
}

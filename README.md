# SwiftTransition
仿App Store转场动画 Swift语言实现
### 参考文档：
>[https://www.jianshu.com/p/d802eb2e5a31](https://www.jianshu.com/p/d802eb2e5a31)
本文主体思路是参考该博主的OC版本实现的
>[https://www.jianshu.com/p/8a99020d954f](https://www.jianshu.com/p/8a99020d954f) 
此文章介绍了转场动画中相关的一些概念，我感觉还是挺通俗易懂的。

### 效果图：
![效果图](https://upload-images.jianshu.io/upload_images/6695792-899f9bb7318751e1.gif?imageMogr2/auto-orient/strip)

### 场景分析：
1、某日，我看到App Store上首页花里胡哨的转场动画体验着实不错，便想着自己实现一番。
2、作为一个萌新看到这样的效果完全联想不到是用何等操作实现的，so，百度，于是找到一个OC版。
3、然后也知道此效果主要是通过重写系统的push、pop动画达到的。作为一个Swift偏好者，难免不想翻译一下。
4、既然是需要push、pop，那么第一步是需要navigationController，我是直接在StoryBoard中嵌入的。
5、接下来是首页TableView布局，cell触摸缩小放大。
6、点击cell Push到详情页，本文重点，先放到后面再详说。
7、详情页依旧是TableView布局。顶部大图为Header，底部为文本，动态计算高度即可。
8、详情页伴随着左滑手势将页面按一定比例缩小，当缩小一定程度时Pop回首页。
9、不难发现，在详情页左滑时还有一个模糊的背景正是首页的截图。

### 代码实现：
除了不知道如何重写pop和push之外其余思路清晰之后，便可以开始绘制基本UI了
![系统push、pop效果](https://upload-images.jianshu.io/upload_images/6695792-f666c487494066c5.gif?imageMogr2/auto-orient/strip)

#### 一、重写Push、实现Delegate
```(swift)
extension ViewController:UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return self
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    }
}
```

此时我们再来仔细观察从首页点击cell之后push到详情页这之间发生了什么？不难发现，其实就是将cell放大，有一种弹出的效果，而系统的push默认效果是新页面从左边覆盖过来。

>其实呢，在转场的过程中系统会提供一个视图容器用来盛装进行跳转控制器的视图，如下图所示，当前的FirstViewControllerpresent到SecondViewController的时候，此时，FirstViewController的view变成fromView，这个视图会自动加入到transtition container view中，然后在跳转过程中我们需要做的就是将SecondViewController的视图（此时是toView）加入到这个容器中，然后为这个toView的展现增加动画。
以上内容摘录自此处
作者：劉光軍_Shine
链接：https://www.jianshu.com/p/8a99020d954f
來源：简书

有了一定概念之后，我们来解读一下下面的逻辑
1、拿到toView:即将要展示的视图，fromView:当前页面已展示的view
2、拿到toView,fromView之后，即将要展示动画，先将fromView隐藏，操作toView的fram和alpha以达到弹出放大的效果
3、将需要展示动画的view设置相应位置之后添加到transitionContext中
4、展示动画toView.alpha 0~>1 逐渐显示，frame 首页cell frame~> 详情页header frame 逐渐放大
5、移除用于展示动画的view，显示详情页view，显示首页view
```(swift)
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
```
#### 二、将首页截图传递给详情页备用
```(swift)
//MARK: 截屏
    func imageFromView() ->UIImage{
        UIGraphicsBeginImageContext(self.view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        self.view.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
```

#### 三、详情页添加左滑返回手势
1、给详情页的tableView添加手势
2、滑动过程中，实时获取当前滑动位置到初始位置的距离，实时计算该距离占据屏幕比例，相应缩小tableView大小并添加适应的圆角
3、手势结束时，获取手势发生的开始位置，手势结束后获取结束位置，计算出总共滑动范围
4、依据滑动范围所占屏幕的比例从而决定是否pop回上一页。若比例达到返回上一页，重写pop动画与push类似。若比例未达到，恢复详情页tableView frame
```(swift)
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
```
### 总结
1、如果实际开发中多处需要用到这种转场效果可以抽出一个工具类来。
2、其实App Store中pop回来还有一个效果就是返回到首页时下面的文字说明会像一个抽屉一样由下往上收回的效果，有时间再去研究一下。另外，App Store上的背景配色之类一些细节处理也是非常极致的，有兴趣的朋友可以继续深究。
3、如有不足之处，望各路大神斧正。
4、[源码地址：https://github.com/SingletonH/SwiftTransition.git](https://github.com/SingletonH/SwiftTransition.git)

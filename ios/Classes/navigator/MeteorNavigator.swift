
import Flutter
import Foundation

public typealias MeteorNavigatorSearchBlock = (_ viewController: UIViewController?) -> Void

public class MeteorNavigator {


    // MARK: - Navigation
    /// Pushes to a specified page.
    ///
    /// - Parameters:
    ///   - routeName: The name of the route.
    ///   - options: Options for the page push.
    public static func push(routeName: String,
                            options: MeteorPushOptions? = nil) {
        #if DEBUG
        MeteorLog.debug("MeteorNavigator push to routeName: \(routeName), options: \(options?.toJson() ?? ["": nil])")
        #endif

        if let toPage = getViewController(routeName: routeName, options: options) {
            if let flutterVc = MeteorNavigatorHelper.topViewController() as? FlutterViewController, options?.pageType == .flutter {
                flutterVc.flutterPush(routeName: routeName, options: options)
            } else {
                MeteorNativeNavigator.push(toPage: toPage, animated: options?.animated ?? true)
            }
            options?.callBack?(nil)
        } else {
            if let flutterVc = MeteorNavigatorHelper.topViewController() as? FlutterViewController, options?.pageType == .flutter {
                flutterVc.flutterPush(routeName: routeName, options: options)
            } else {
                MeteorLog.error("MeteorNavigator push to routeName: \(routeName) not exist")
                options?.callBack?(nil)
            }
        }
    }

    /// Presents a page modally.
    ///
    /// - Parameters:
    ///   - routeName: The name of the route.
    ///   - options: Options for the page presentation.
    public static func present(routeName: String,
                               options: MeteorPushOptions? = nil) {
        #if DEBUG
        MeteorLog.debug("MeteorNavigator present to routeName: \(routeName), options: \(options?.toJson() ?? ["": nil])")
        #endif

        if let vc = getViewController(routeName: routeName, options: options) {
            if vc is UINavigationController {
                MeteorNativeNavigator.present(toPage: vc, animated: options?.animated ?? true) {
                    options?.callBack?(nil)
                }
            } else {
                let navi = UINavigationController(rootViewController: vc)
                navi.navigationBar.isHidden = true
                navi.modalPresentationStyle = vc.modalPresentationStyle
                if options?.isOpaque == false {
                    setNoOpaque(vc: navi)
                }
                MeteorNativeNavigator.present(toPage: navi, animated: options?.animated ?? true) {
                    options?.callBack?(nil)
                }
            }
        } else {
            MeteorLog.error("MeteorNavigator present to routeName: \(routeName) not exist")
            options?.callBack?(nil)
        }
    }

    /// Pushes to a specified page and removes all pages from the stack up to the target route.
    ///
    /// - Parameters:
    ///   - routeName: The name of the route.
    ///   - untilRouteName: The target route up to which pages are removed.
    ///   - options: Options for the page push.
    public static func pushToAndRemoveUntil(routeName: String,
                                            untilRouteName: String?,
                                            options: MeteorPushOptions? = nil) {
        #if DEBUG
        MeteorLog.debug("MeteorNavigator pushToAndRemoveUntil to routeName: \(routeName), removeUntilRouteName: \(untilRouteName ?? "nil"), options: \(options?.toJson() ?? ["": nil])")
        #endif

        popUntil(untilRouteName: untilRouteName, options: MeteorPopOptions(animated: false, callBack: { response in
            push(routeName: routeName, options: options)
        }))
    }

    /// Pushes to a specified page and removes all pages up to the root.
    ///
    /// - Parameters:
    ///   - routeName: The name of the route.
    ///   - options: Options for the page push.
    public static func pushNamedAndRemoveUntilRoot(routeName: String,
                                                   options: MeteorPushOptions? = nil) {
        #if DEBUG
        MeteorLog.debug("MeteorNavigator pushNamedAndRemoveUntilRoot to routeName: \(routeName), options: \(options?.toJson() ?? ["": nil])")
        #endif
        
        popToRoot(options: MeteorPopOptions(animated: false, callBack: { response in
            push(routeName: routeName, options: options)
        }))
    }

    /// Pops the current page.
    ///
    /// - Parameter options: Options for the page pop.
    public static func pop(options: MeteorPopOptions? = nil) {
        #if DEBUG
        MeteorLog.debug("MeteorNavigator pop")
        #endif
        if let flutterVc = MeteorNavigatorHelper.topViewController() as? FlutterViewController {
            flutterVc.flutterRouteNameStack { routeStack in
                if let routeStack = routeStack, routeStack.count > 1  {
                    flutterVc.flutterPop(options: options) { response in
                        options?.callBack?(nil)
                    }
                } else {
                    MeteorNativeNavigator.pop(animated: options?.animated ?? true, result: options?.result) {
                        options?.callBack?(nil)
                    }
                }
            }
        } else {
            MeteorNativeNavigator.pop(animated: options?.animated ?? true, result: options?.result) {
                options?.callBack?(nil)
            }
        }
    }
    
    /// Pushes a new page and replaces the current top page.
    ///
    /// - Parameters:
    ///   - routeName: The name of the page route.
    ///   - options: Options for the page push.
    public static func pushToReplacement(routeName: String, options: MeteorPushOptions? = nil) {
        #if DEBUG
        MeteorLog.debug("MeteorNavigator pushToReplacement to routeName: \(routeName), options: \(options?.toJson() ?? ["": nil])")
        #endif
        
        pop(options: MeteorPopOptions(animated: false, callBack: { response in
            push(routeName: routeName, options: options)
        }))
    }

    /// Pops pages up to a specified page.
    ///
    /// - Parameters:
    ///   - untilRouteName: The target page.
    ///   - isFarthest: Indicates whether to match the farthest instance of the route.
    ///   - options: Options for the page pop.
    public static func popUntil(untilRouteName: String?,
                                isFarthest: Bool = false,
                                options: MeteorPopOptions? = nil) {
        #if DEBUG
        MeteorLog.debug("MeteorNavigator popUntil: \(untilRouteName ?? "nil"), options: \(options?.toJson() ?? ["": nil])")
        #endif
       
        guard let untilRouteName = untilRouteName else {
            options?.callBack?(nil)
            MeteorLog.warning("popUntil untilRouteName is nil")
            return
        }
        searchRoute(routeName: untilRouteName, isReversed: !isFarthest) { untilPage in
            if let untilPage = untilPage {
                if let flutterVc = untilPage as? FlutterViewController, flutterVc.routeName != untilRouteName  {
                    MeteorNativeNavigator.popUntil(untilPage: untilPage, animated: false) {
                        flutterVc.flutterPopUntil(untilRouteName: untilRouteName, isFarthest: isFarthest, options: options)
                    }
                } else {
                    MeteorNativeNavigator.popUntil(untilPage: untilPage, animated: options?.animated ?? true) {
                        options?.callBack?(nil)
                    }
                }
            } else {
                options?.callBack?(nil)
                MeteorLog.warning("No page route name: \(untilRouteName)")
            }
        }
    }
    
    /// Pops pages up to the root.
    ///
    /// - Parameter options: Options for the page pop.
    public static func popToRoot(options: MeteorPopOptions? = nil) {
        #if DEBUG
        MeteorLog.debug("MeteorNavigator popToRoot, options: \(options?.toJson() ?? ["": nil])")
        #endif
        
        let rootVc = MeteorNavigatorHelper.rootViewController()
        if let flutterVc = rootVc as? FlutterViewController {
            MeteorNativeNavigator.popToRoot(animated: false) {
                flutterVc.flutterPopToRoot(options: options)
            }
        } else if let naviVc = rootVc as? UINavigationController {
            if let flutterVc = naviVc.viewControllers.first as? FlutterViewController {
                MeteorNativeNavigator.popToRoot(animated: false) {
                    flutterVc.flutterPopToRoot(options: options)
                }
            } else {
                MeteorNativeNavigator.popToRoot(animated: options?.animated ?? true) {
                    options?.callBack?(nil)
                }
            }
        } else {
            MeteorNativeNavigator.popToRoot(animated: options?.animated ?? true) {
                options?.callBack?(nil)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Retrieves the view controller for a specified route.
    ///
    /// - Parameters:
    ///   - routeName: The name of the route.
    ///   - options: Options for the page push.
    /// - Returns: The corresponding view controller.
    private static func getViewController(routeName: String?,
                                         options: MeteorPushOptions?) -> UIViewController? {
        return MeteorRouterManager.getViewController(routeName: routeName, options: options)
    }
    
    /// Sets the view controller's background to non-opaque.
    ///
    /// - Parameter vc: The view controller.
    private static func setNoOpaque(vc: UIViewController) {
        vc.view.backgroundColor = UIColor.clear
        vc.modalPresentationStyle = .overFullScreen
        vc.view.isOpaque = false
    }
}



public extension MeteorNavigator {
    // MARK: - Router Stack
    
    /**
     * Searches for a view controller by its route name in the navigation stack.
     *
     * - Parameters:
     *   - routeName: The name of the route to search for.
     *   - isReversed: Whether to search from top to bottom. Defaults to `true`.
     *   - result: Callback with the found view controller or `nil` if not found.
     */
    static func searchRoute(routeName: String,
                            isReversed: Bool = true,
                            result: @escaping MeteorNavigatorSearchBlock)
    {
        var vcStack = MeteorNavigatorHelper.viewControllerStack
        if isReversed {
            vcStack = vcStack.reversed()
        }
        let serialQueue = MeteorSerialTaskQueue(label: "cn.itbox.serialTaskQueue.routeSearch")

        func callBack(viewController: UIViewController?) {
            DispatchQueue.main.async {
                result(viewController)
            }
        }

        func search(in stack: [UIViewController], index: Int) {
            guard index < stack.count else {
                callBack(viewController: nil)
                return
            }

            let vc = stack[index]
            let continueSearch = {
                search(in: stack, index: index + 1)
            }

            serialQueue.addTask { finish in
                if let flutterVc = vc as? FlutterViewController {
                    flutterVc.flutterRouteExists(routeName: routeName, result: { exists in
                        defer { finish() }
                        if exists {
                            callBack(viewController: vc)
                        } else {
                            continueSearch()
                        }
                    })
                } else {
                    defer { finish() }
                    if routeName == vc.routeName {
                        callBack(viewController: vc)
                    } else {
                        continueSearch()
                    }
                }
            }
        }

        search(in: Array(vcStack), index: 0)
    }

    /**
     * Checks if a route exists in the navigation stack.
     *
     * - Parameters:
     *   - routeName: The name of the route to check.
     *   - result: Callback indicating if the route exists.
     */
    static func routeExists(routeName: String,
                            result: @escaping ((_ exists: Bool) -> Void))
    {
        searchRoute(routeName: routeName) { viewController in
            let exists = viewController != nil
            result(exists)
        }
    }

    /**
     * Checks if a route is the root of the navigation stack.
     *
     * - Parameters:
     *   - routeName: The name of the route to check.
     *   - result: Callback indicating if the route is the root.
     */
    static func isRoot(routeName: String,
                       result: @escaping ((_ isRoot: Bool) -> Void))
    {
        rootRouteName { rootName in
            result(rootName == routeName)
        }
    }

    /**
     * Retrieves the root route name of the navigation stack.
     *
     * - Parameter result: Callback with the root route name, if available.
     */
    static func rootRouteName(result: @escaping ((_ root: String?) -> Void)) {
        let rootVc = MeteorNavigatorHelper.rootViewController()
        if let flutterVc = rootVc as? FlutterViewController {
            flutterVc.flutterRootRouteName { rootRouteName in
                result(rootRouteName)
            }
        } else if let naviVc = rootVc as? UINavigationController {
            if let flutterVc = naviVc.viewControllers.first as? FlutterViewController {
                flutterVc.flutterRootRouteName { rootRouteName in
                    result(rootRouteName)
                }
            } else {
                result(rootVc?.routeName)
            }
        } else {
            result(rootVc?.routeName)
        }
    }

    /**
     * Retrieves the name of the top route in the navigation stack.
     *
     * - Parameter result: Callback with the top route name.
     */
    static func topRouteName(result: @escaping ((String?) -> Void)) {
        let topVc = MeteorNavigatorHelper.topViewController()
        if let flutterVc = topVc as? FlutterViewController {
            flutterVc.flutterTopRouteName { response in
                result(response)
            }
        } else {
            result(topVc?.routeName)
        }
    }

    /**
     * Retrieves the entire route stack.
     *
     * - Parameter result: Callback with the stack of route names.
     */
    static func routeNameStack(result: @escaping ((_ routeStack: [String]?) -> Void)) {
        let vcStack = MeteorNavigatorHelper.viewControllerStack
        let dispatchGroup = DispatchGroup()
        var routeStack = [String]()
        var vcMap = [UIViewController: [String]]()
        
        for vc in vcStack {
            dispatchGroup.enter()
            if let flutterVc = vc as? FlutterViewController {
                flutterVc.flutterRouteNameStack { routeStack in
                    defer { dispatchGroup.leave() }
                    vcMap[vc] = routeStack?.isEmpty ?? true ? [vc.routeName ?? "\(type(of: vc))"] : routeStack
                }
            } else {
                defer { dispatchGroup.leave() }
                vcMap[vc] = [vc.routeName ?? "\(type(of: vc))"]
            }
        }

        dispatchGroup.notify(queue: .main) {
            for vc in vcStack {
                routeStack.append(contentsOf: vcMap[vc] ?? [vc.routeName ?? "\(type(of: vc))"])
            }
            result(routeStack)
        }
    }

    /**
     * Checks if the top of the navigation stack is a native or Flutter view.
     *
     * - Parameter result: Callback indicating if the top view is native (`true`) or Flutter (`false`).
     */
    static func topRouteIsNative(result: @escaping ((_ topIsNative: Bool) -> Void)) {
        let vc = MeteorNavigatorHelper.topViewController()
        let topVc = MeteorNavigatorHelper.getTopVC(withCurrentVC: vc)
        result(!(topVc is FlutterViewController))
    }
    
    /*------------------------ Router Methods End --------------------------*/
}

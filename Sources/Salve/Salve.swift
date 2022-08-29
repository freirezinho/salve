import UIKit
import MultipeerConnectivity

public struct Salve {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}

public class LAN: NSObject, MCBrowserViewControllerDelegate {

    public static let shared = LAN()
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCNearbyServiceAdvertiser!
    let peerID = MCPeerID(displayName: UIDevice.current.name)
    var serviceTypeName = "salve-connect"
    var mcAdvertiserDelegate: LANAdvertiserDelegate!
    
    private override init() {
        super.init()
        self.mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        self.mcAdvertiserDelegate = LANAdvertiserDelegate(session: mcSession)
    }
    
    public func hostSession() {
        mcAdvertiserAssistant = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceTypeName)
        mcAdvertiserAssistant.delegate = mcAdvertiserDelegate
        mcAdvertiserAssistant.startAdvertisingPeer()
    }
    
    public func joinHostedSession(fromViewController viewController: UIViewController, animated: Bool) {
        let browser = LANMCBrowserFactory.make(withServiceType: serviceTypeName, session: mcSession)
        browser.delegate = self
        viewController.present(browser, animated: animated)
    }
    
    // MARK: - MCBrowserViewControllerDelegate
    public func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
//        dismiss(animated: true)
    }
    
    public func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
//        dismiss(animated: true)
    }
    
}

public class LANMCBrowserFactory {
    public static func make(withServiceType serviceType: String, session: MCSession) -> MCBrowserViewController {
        return MCBrowserViewController(serviceType: serviceType, session: session)
    }
}

public class LANAdvertiserDelegate: NSObject, MCNearbyServiceAdvertiserDelegate {
    var mcSession: MCSession!
    
    public convenience init(session: MCSession) {
        self.init()
        self.mcSession = session
    }
    
    // MARK: - MCNearbyServiceAdvertiserDelegate
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, mcSession)
    }
}

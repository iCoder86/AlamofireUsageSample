//
//  SessionManager.swift
//  SwiftModelProject
//
//  Created by cloudZon Infosoft on 30/05/16.
//  Copyright © 2016 cloudZon Infosoft. All rights reserved.
//

import Foundation

class SessionManager: NSObject,XMPPStreamDelegate,XMPPRosterDelegate,XMPPRosterMemoryStorageDelegate {
    
    static var sessionInstance : SessionManager?

    var xmppStream: XMPPStream!
    var xmppRoster: XMPPRoster!
    var xmppRosterMemStorage: XMPPRosterMemoryStorage?
    var xmppMessageDeliveryRecipts: XMPPMessageDeliveryReceipts?
    
    var stateList : NSArray = NSArray()
    
    class func getInstance() -> SessionManager {
        if sessionInstance == nil {
            sessionInstance = SessionManager()
            sessionInstance?.cennectToXMPPServer()
        }
        return sessionInstance!
    }
    
    override init() {
        super.init()
    }

    /****************************** XMPP Methods ******************************/
    
    func cennectToXMPPServer() -> Bool {
        if xmppStream == nil {
            xmppStream = XMPPStream()
            xmppStream?.hostName = CHAT_SERVER_LINK
            xmppStream?.hostPort = UInt16(CHAT_SERVER_PORT)
            xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
            
            xmppRosterMemStorage = XMPPRosterMemoryStorage.init()
            xmppRoster = XMPPRoster.init(rosterStorage: xmppRosterMemStorage, dispatchQueue: DispatchQueue.main)
            xmppRoster?.autoFetchRoster = true
            xmppRoster?.autoAcceptKnownPresenceSubscriptionRequests = true
            xmppRoster?.addDelegate(self, delegateQueue: DispatchQueue.main)
            xmppRoster?.activate(xmppStream)
        }
        
        let jabberId = "758@world-pc" // John Smith
        let password = CHAT_PASSWORD
        
        if (!(xmppStream?.isDisconnected())!) {
            return true
        }
        
        if (jabberId == nil || password == nil) {
            return false
        }
        
        xmppStream?.myJID = XMPPJID.init(string: jabberId)

        do {
            try xmppStream?.connect(withTimeout: 30.0)
        } catch {
            print(error)
            let alert = UIAlertController(title: "Error",
                                          message: error.localizedDescription,
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            alert.show(alert, sender: nil)
            return false
        }
        
        return true
    }
    
    func disconnectFromXMPPServer() {
        self.goOffline()
        xmppRosterMemStorage = nil
        xmppRoster = nil
        
        xmppStream?.disconnect()
        xmppStream = nil
    }
    
    func goOnline() {
        let presence = XMPPPresence()
        presence?.setXmlns("Avaliable")
//        presence?.setStringValue("Available")
        xmppStream?.send(presence)
    }
    
    func goOffline() {
        let presence = XMPPPresence()
        presence?.setXmlns("unavailable")
//        presence?.setStringValue("unavailable")
        xmppStream?.send(presence)
    }

    func sendMessage(message:NSString) {
        
        let body = DDXMLElement.element(withName: "body") as! DDXMLElement
        body.setXmlns("Hello")
//        body.setStringValue("Hello")

        let completeMessage = DDXMLElement.element(withName: "message") as! DDXMLElement
        completeMessage.addAttribute(withName: "type", stringValue: "chat")
        completeMessage.addAttribute(withName: "to", stringValue: "752@world-pc") // Cloudzon infoconnect
        completeMessage.addChild(body)
        
        xmppStream?.send(completeMessage)
    }
    
    /****************************** XMPP Delegates ******************************/


    func xmppStreamConnectDidTimeout(_ sender: XMPPStream!) {
        print("TimeOut")
        if sender.isDisconnected() {
            self.cennectToXMPPServer()
        }
    }
    
    func xmppStreamDidConnect(_ sender: XMPPStream!) {
        print("connected")
        do {
            try xmppStream?.authenticate(withPassword: CHAT_PASSWORD)
        } catch {
            print("xmppStreamDidConnect Error: \(error.localizedDescription)")
        }
    }
    
    func xmppStreamDidDisconnect(_ sender: XMPPStream, withError error:Error) {
        print("xmppStreamDidDisconnect Error:")
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        print("xmppStreamDidAuthenticate")
        self.goOnline()
    }
    
    func xmppStream(_ sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        print("didNotAuthenticate")
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceive iq: XMPPIQ!) -> Bool {
        return false;
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!) {
        print("didReceive message \(message.value(forKey: "body")!)")
        
        let composing:Any? = message.elements(forName: "composing")
        let msg:Any? = message.elements(forName: "message")
        let from:Any? = message.attribute(forName: "from")
        let received:Any? = message.attribute(forName: "received")
        
        print("Composing: \(String(describing: composing))")
        print("MSG: \(String(describing: msg))")
        print("FROM: \(from!)")
        print("Received: \(String(describing: received))")
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceive presence: XMPPPresence!) {
        print("didReceive presence")
    }
    
    func xmppRosterDidPopulate(_ sender: XMPPRosterMemoryStorage!) {
        print("xmppRosterDidPopulate")
    }

}

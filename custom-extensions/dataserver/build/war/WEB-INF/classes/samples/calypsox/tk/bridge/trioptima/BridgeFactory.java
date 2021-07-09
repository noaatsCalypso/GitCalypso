/**
 * 
 */
package calypsox.tk.bridge.trioptima;

import com.calypso.tk.bridge.IBridge;
import com.calypso.tk.bridge.IBridgeFactory;
import com.calypso.tk.bridge.trioptima.Bridge;

/**
 * The customer bridge factory.
 * This class provide a way to build a Bridge that convert trioptima information into customer one.
 * @author jean-luc_vanniere
 *
 */
public final class BridgeFactory implements IBridgeFactory {

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.IBridgeFactory#makeBridge()
	 */
	@Override
	public IBridge makeBridge() {
		return new Bridge();
	}

}

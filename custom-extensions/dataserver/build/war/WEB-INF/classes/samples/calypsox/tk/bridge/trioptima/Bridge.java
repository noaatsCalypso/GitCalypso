/**
 * 
 */
package calypsox.tk.bridge.trioptima;

import java.util.ArrayList;
import java.util.List;

import com.calypso.tk.bridge.IBridge;
import com.calypso.tk.bridge.IProductInformation;
import com.calypso.tk.core.LegalEntity;
import com.calypso.tk.event.PSConnection;
import com.calypso.tk.product.ProductCreationHelper;
import com.calypso.tk.service.DSConnection;
import com.calypso.tk.util.TradeCreationEntry;
import com.calypso.tk.util.TradeKeyword;
import com.calypso.tk.util.TradeTerminationEntry;
import com.calypso.tk.util.TriReduceAbstractException;

/**
 * This class implements the bridge for Natixis
 * @author jean-luc_vanniere
 *
 */
public class Bridge implements IBridge {
	
	// Static fields
	private static String TRIOPTIMA_BUY = "Buy";
	private static String TRIOPTIMA_SELL = "Sell";
	
	/**
	 * Default constructor
	 */
	public Bridge() {
		productMapping = new ProductMapping();
		seniorityMapping = new SeniorityMapping();
		restructuringTypeMapping = new RestructuringTypeMapping();
		tenorMapping = new TenorMapping();
		legalEntityFinder = new LegalEntityFinder();
		tradeTemplateFinder = new TradeTemplateFinder();
		stubRuleFinder = new StubRuleFinder();
		holidayFinder = new HolidayFinder();
	}

	// ------------------------------------------------------------------------
	// -- IBridge direct implementation
	// ------------------------------------------------------------------------
	
	
	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.IBridge#record(com.calypso.tk.util.TradeTerminationEntry)
	 */
	@Override
	public void record(TradeTerminationEntry entry) {
		this.legalEntityFinder.record(entry);
	}

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.IBridge#getTradeKeywords(com.calypso.tk.util.TradeCreationEntry)
	 */
	public List<TradeKeyword> getTradeKeywords(TradeCreationEntry entry) {
		ArrayList<TradeKeyword> res = new ArrayList<TradeKeyword>();
		// res.add(new TradeKeyword("IXIS_Trioptima", "Trioptima_" + tradeDate));
		res.add(new TradeKeyword("IXIS_InputSystem", "Trioptima STP"));
		res.add(new TradeKeyword("SystExt", "Trioptima"));
		return res;
	}


	// ------------------------------------------------------------------------
	// -- IBuySellBridge implementation
	// ------------------------------------------------------------------------
	
	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.IBuySellBridge#getExternalBuySell()
	 */
	public String getExternalBuySell(String internalBuySell) {
		String res = null;
		if (internalBuySell.equals(CALYPSO_BUY)) {
			res = TRIOPTIMA_BUY;
		}
		else if (internalBuySell.equals(CALYPSO_SELL)){
			res = TRIOPTIMA_SELL;
		}
		return res;
	}

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.IBuySellBridge#getInternalBuySell()
	 */
	public String getInternalBuySell(String externalBuySell) {
		String res = null;
		if (externalBuySell.equals(TRIOPTIMA_BUY)) {
			res = CALYPSO_BUY;
		}
		else if (externalBuySell.equals(TRIOPTIMA_SELL)){
			res = CALYPSO_SELL;
		}
		return res;
	}

	// ------------------------------------------------------------------------
	// -- IProductMapping implementation
	// ------------------------------------------------------------------------
	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.IProductMapping#getProduct(java.lang.String)
	 */
	public IProductInformation getProductInformation(String externalProductType) {
		IProductInformation res = null;
		if (productMapping != null) {
			res = productMapping.getProductInformation(externalProductType);
		}
		return res;
	}


	// ------------------------------------------------------------------------
	// -- ITradeTemplateFinder implementation
	// ------------------------------------------------------------------------
	
	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.ITradeTemplateFinder#findTemplate(com.calypso.tk.util.TradeCreationEntry)
	 */
	public String findTemplate(TradeCreationEntry entry) throws TriReduceAbstractException {
		String res = tradeTemplateFinder.findTemplate(entry);
		if (res.equals("")) {
			res = null;
		}
		return res;
	}

	// ------------------------------------------------------------------------
	// -- ISeniorityBridge implementation
	// ------------------------------------------------------------------------
	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.ISeniorityBridge#getExternalSeniority(java.lang.String)
	 */
	public String getExternalSeniority(String internalSeniority) {
		String res = null;
		if (seniorityMapping != null) {
			res = seniorityMapping.getExternalSeniority(internalSeniority);
		}
		return res;
	}

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.ISeniorityBridge#getInternalSeniority(java.lang.String)
	 */
	public String getInternalSeniority(String externalSeniority) {
		String res = null;
		if (seniorityMapping != null) {
			res = seniorityMapping.getInternalSeniority(externalSeniority);
		}
		return res;
	}
	
	// ------------------------------------------------------------------------
	// -- IRestructuringTypeBridge implementation
	// ------------------------------------------------------------------------
	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.IRestructuringTypeBridge#getExternalRestructuringType(java.lang.String)
	 */
	public String getExternalRestructuringType(String internalType) {
		String res = null;
		if (restructuringTypeMapping != null) {
			res = restructuringTypeMapping.getExternalRestructuringType(internalType);
		}
		return res;
	}

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.IRestructuringTypeBridge#getInternalRestructuringType(java.lang.String)
	 */
	public String getInternalRestructuringType(String externalType) {
		String res = null;
		if (restructuringTypeMapping != null) {
			res = restructuringTypeMapping.getInternalRestructuringType(externalType);
		}
		return res;
	}


	// ------------------------------------------------------------------------
	// -- ITenorBridge implementation
	// ------------------------------------------------------------------------
	
	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.ICouponPeriodBridge#getExternalTenor(java.lang.String)
	 */
	public String getExternalTenor(String internalCouponPeriod) {
		String res = null;
		if (tenorMapping != null) {
			res = tenorMapping.getExternalTenor(internalCouponPeriod);
		}
		return res;
	}

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.ICouponPeriodBridge#getInternalTenor(java.lang.String)
	 */
	public String getInternalTenor(String externalCouponPeriod) {
		String res = null;
		if (tenorMapping != null) {
			res = tenorMapping.getInternalTenor(externalCouponPeriod);
		}
		return res;
	}

	
	// ------------------------------------------------------------------------
	// -- ILegalEntityBridge implementation
	// ------------------------------------------------------------------------
	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.ILegalEntityBridge#findCounterparty(com.calypso.tk.util.TradeCreationEntry)
	 */
	public LegalEntity findCounterparty(TradeCreationEntry entry) throws TriReduceAbstractException {
		return legalEntityFinder.findCounterparty(entry);
	}

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.ILegalEntityBridge#findIssuer(com.calypso.tk.util.TradeCreationEntry)
	 */
	public LegalEntity findIssuer(TradeCreationEntry entry) throws TriReduceAbstractException {
		return legalEntityFinder.findIssuer(entry);
	}

	// ------------------------------------------------------------------------
	// -- IStubPeriodFinder implementation
	// ------------------------------------------------------------------------
	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.IStubPeriodFinder#findStubRule(com.calypso.tk.util.ProductCreationHelper)
	 */
	public String findStubRule(TradeCreationEntry entry) {
		return stubRuleFinder.findStubRule(entry);
	}

	

	// ------------------------------------------------------------------------
	// -- IHolidayFinder implementation
	// ------------------------------------------------------------------------
	

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.IHolidayFinder#findHolidays(com.calypso.tk.util.TradeCreationEntry)
	 */
	public List<String> findHolidays(TradeCreationEntry entry) {
		return holidayFinder.findHolidays(entry);
	}

	// ------------------------------------------------------------------------
	// -- Fields
	// ------------------------------------------------------------------------


	protected ProductMapping productMapping = null;
	protected SeniorityMapping seniorityMapping = null;
	protected RestructuringTypeMapping restructuringTypeMapping = null;
	protected TenorMapping tenorMapping = null;
	protected LegalEntityFinder legalEntityFinder = null;
	protected TradeTemplateFinder tradeTemplateFinder = null;
	protected StubRuleFinder stubRuleFinder = null;
	protected HolidayFinder holidayFinder = null;
}

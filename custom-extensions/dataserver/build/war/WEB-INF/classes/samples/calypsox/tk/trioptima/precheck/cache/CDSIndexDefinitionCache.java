/**
 * 
 */
package calypsox.tk.trioptima.precheck.cache;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import com.calypso.tk.core.JDate;
import com.calypso.tk.core.Log;
import com.calypso.tk.core.TrioptimaConstants;
import com.calypso.tk.core.TrioptimaUtil;
import com.calypso.tk.product.CDSIndexDefinition;
import com.calypso.tk.product.CDXAbstractHelper;
import com.calypso.tk.product.CDXHelper;
import com.calypso.tk.util.TradeCreationEntry;

/**
 * A cache of index definitions of terminated trades
 * @author jean-luc_vanniere
 *
 */
public class CDSIndexDefinitionCache {
	public CDSIndexDefinitionCache(String cache_name) {
		this(cache_name, new CDXHelper());
	}
	
	public CDSIndexDefinitionCache(String cache_name, CDXAbstractHelper helper) {
		cacheName = cache_name;
		definitions = new HashMap<String, List<CDSIndexDefinition>>();
		this.helper = helper;
	}

	public int size() {
		return definitions.size();
	}
	
	public void clear() {
		definitions.clear();
	}
	
	/**
	 * Records the given index definition 
	 * @param cdxid the index definition to record
	 */
	public void record(CDSIndexDefinition cdxid) {
		String key = helper.getDefinitionKey(cdxid);
		Log.info(TrioptimaConstants.LOG_CAT, "Recording CDS Index Definition " + key);
		if (!definitions.containsKey(key)) {
			List<CDSIndexDefinition> list = new Vector<CDSIndexDefinition>();
			list.add(cdxid);
			definitions.put(key, list);
		}
		else {
			JDate startDate = cdxid.getStartDate();
			double factor1 = cdxid.getFactor(startDate);
			List<CDSIndexDefinition> list = definitions.get(key);
			int nbdecimals = helper.getIndexScaleFactorDecimalDigits();
			boolean found = false;
			for (CDSIndexDefinition def: list) {
				double factor2 = def.getFactor(startDate);
				if (TrioptimaUtil.areEqual(factor1, factor2, nbdecimals)) {
					found = true;
					break;
				}
			}
			if (!found) {
				list.add(cdxid);
			}
		}
	}
	
	/**
	 * Returns the index definition related to the given trade creation entry
	 * @param entry a trade creation entry over CDXIndex
	 * @return
	 */
	public CDSIndexDefinition findIndexDefinition(TradeCreationEntry entry) {
		CDSIndexDefinition cdxid = null;
		String key = helper.getProductKey(entry);
		JDate tradeDate = TrioptimaUtil.readJDateFromIsoFormat(entry.getCalypsoTradeDate());
		Log.debug(TrioptimaConstants.LOG_CAT, "CDS Index searched in " + cacheName + ": key=" + key + " trade date=" + tradeDate);
		if (definitions.containsKey(key)) {
			String found_message = "CDS Index found in " + cacheName + ": key=" + key;
			List<CDSIndexDefinition> list = definitions.get(key);
			int scaleFactorDecimals = helper.getIndexScaleFactorDecimalDigits();
			for (CDSIndexDefinition def : list) {
				if (TrioptimaUtil.areEqual(def.getFactor(tradeDate), entry.getIndexScaleFactor(), scaleFactorDecimals)) {
					Log.info(TrioptimaConstants.LOG_CAT, found_message);
					cdxid = def;
					break;
				}
			}
			if (cdxid == null) {
				Log.info(TrioptimaConstants.LOG_CAT, found_message + " but index_scale_factor does not match");
			}
		}
		else {
			Log.info(TrioptimaConstants.LOG_CAT, "CDS Index not found in " + cacheName + ": key=" + key);
		}
		return cdxid;
	}

	private final String cacheName;
	private final Map<String, List<CDSIndexDefinition>> definitions;
	private final CDXAbstractHelper helper;
}

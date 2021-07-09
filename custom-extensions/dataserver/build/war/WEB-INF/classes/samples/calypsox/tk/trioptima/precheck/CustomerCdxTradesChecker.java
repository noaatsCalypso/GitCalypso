/**
 * 
 */
package calypsox.tk.trioptima.precheck;

import java.util.HashMap;
import java.util.Map;

import com.calypso.tk.bo.Task;
import com.calypso.tk.core.Product;
import com.calypso.tk.core.Trade;
import com.calypso.tk.core.TrioptimaConstants;
import com.calypso.tk.product.CDSABSIndex;
import com.calypso.tk.product.CDSABSIndexDefinition;
import com.calypso.tk.product.CDSABXHelper;
import com.calypso.tk.product.CDSIndex;
import com.calypso.tk.product.CDSIndexDefinition;
import com.calypso.tk.product.CDSIndexTranche;
import com.calypso.tk.product.CDXHelper;
import com.calypso.tk.product.CDXTrancheHelper;
import com.calypso.tk.product.CreditDefaultSwap;
import com.calypso.tk.product.CreditDerivativeHelper;
import com.calypso.tk.product.ProductHelper;
import com.calypso.tk.product.ProductHelperFactory;
import com.calypso.tk.util.ExternalTradeCreationEntry;
import com.calypso.tk.util.InternalTradeCreationEntry;
import com.calypso.tk.util.ScheduledTaskTRI_REDUCE_IMPORT;
import com.calypso.tk.util.TaskArray;
import com.calypso.tk.util.TradeCreationEntry;
import com.calypso.tk.util.TradeTerminationEntry;
import com.calypso.tk.trioptima.precheck.ICheckHandler;
import com.calypso.tk.trioptima.precheck.cache.CDSABSIndexDefinitionCache;
import calypsox.tk.trioptima.precheck.cache.CDSIndexDefinitionCache;

/**
 * Process to checks over Trades on CDS and CDS ABS indexes
 * @author jean-luc_vanniere
 *
 */
public class CustomerCdxTradesChecker implements ICheckHandler {

	public CustomerCdxTradesChecker(ScheduledTaskTRI_REDUCE_IMPORT task) {
		this.task = task;
		this.productHelperFactory = task.getProductHelperFactory();
	}
	
	/* (non-Javadoc)
	 * @see com.calypso.tk.trioptima.precheck.ICheckHandler#process(com.calypso.tk.util.ExternalTradeCreationEntry, com.calypso.tk.util.TaskArray)
	 */
	@Override
	public boolean process(ExternalTradeCreationEntry entry, TaskArray exceptions) {
		return check(entry, exceptions);
	}



	/* (non-Javadoc)
	 * @see com.calypso.tk.trioptima.precheck.ICheckHandler#process(com.calypso.tk.util.InternalTradeCreationEntry, com.calypso.tk.util.TaskArray)
	 */
	@Override
	public boolean process(InternalTradeCreationEntry entry, TaskArray exceptions) {
		return check(entry, exceptions);
	}



	/* (non-Javadoc)
	 * @see com.calypso.tk.trioptima.precheck.ICheckHandler#epilogue(com.calypso.tk.util.TaskArray)
	 */
	@Override
	public boolean epilogue(TaskArray exceptions) {
		return true;
	}



	/* (non-Javadoc)
	 * @see com.calypso.tk.trioptima.precheck.ICheckHandler#clear()
	 */
	@Override
	public void clear() {
		terminatedCDSTradeCDS.clear();
		terminatedCDXDefinitions.clear();
		terminatedCDXTrancheDefinitions.clear();
		terminatedCDSABXDefinitions.clear();
	}



	/* (non-Javadoc)
	 * @see com.calypso.tk.trioptima.precheck.ICdxTradesChecker#process(com.calypso.tk.util.TradeTerminationEntry, com.calypso.tk.util.TaskArray)
	 */
	@Override
	public boolean process(TradeTerminationEntry entry, TaskArray exceptions) {
		Trade trade = entry.getTrade();
		Product product = trade.getProduct();

		ProductHelper helper = productHelperFactory.makeHelper(product);
		if (helper != null) {
			if (helper instanceof CreditDerivativeHelper) {
				CreditDerivativeHelper cdhelper = (CreditDerivativeHelper)helper;
				String productKey = cdhelper.getProductKey(entry);
				if  (product instanceof CreditDefaultSwap) {
					CreditDefaultSwap cds = (CreditDefaultSwap)product;
					if (!terminatedCDSTradeCDS.containsKey(productKey)) {
						terminatedCDSTradeCDS.put(productKey, cds);
					}
				}
				else if (product instanceof CDSIndex) {
					CDSIndex cdx = (CDSIndex)product;
					CDSIndexDefinition cdxid = cdx.getIndexDefinition();
					terminatedCDXDefinitions.record(cdxid);
				}
				else if (product instanceof CDSIndexTranche) {
					CDSIndexTranche cdxt = (CDSIndexTranche)product;
					CDSIndexDefinition cdxid = cdxt.getIndexDefinition();
					terminatedCDXTrancheDefinitions.record(cdxid);
				}
				else if (product instanceof CDSABSIndex) {
					CDSABSIndex cdx = (CDSABSIndex)product;
					CDSABSIndexDefinition cdxid = cdx.getIndexDefinition();
					terminatedCDSABXDefinitions.record(cdxid);
				}
			}
		}
		return true;
	}
	
	
	private boolean check(TradeCreationEntry entry, TaskArray exceptions) {
		boolean result = true;
		ProductHelper helper = productHelperFactory.makeHelper(entry);
		if (helper instanceof CDXHelper) {
			result = check(entry, (CDXHelper)helper, exceptions);
		}
		else if (helper instanceof CDXTrancheHelper) {
			result = check(entry, (CDXTrancheHelper)helper, exceptions);
		}
		else if (helper instanceof CDSABXHelper) {
			result = check(entry, (CDSABXHelper)helper, exceptions);
		}
		return result;
	}
	
	private boolean check(TradeCreationEntry entry, CDXHelper helper, TaskArray exceptions) {
		boolean result = true;
		CDSIndexDefinition cdxid = terminatedCDXDefinitions.findIndexDefinition(entry);
		if (cdxid == null) {
			String redid = entry.getRedId();
			StringBuilder error = new StringBuilder("No matching cds index definition in terminated trades ");
			error.append(" for RED ").append(redid);
			error.append(" and maturity ").append(entry.getEndDate());
			error.append(" [").append(entry.toString()).append("]");
			addException(exceptions, error.toString());
			result = false;
		}
		return result;
	}
	
	private boolean check(TradeCreationEntry entry, CDXTrancheHelper helper, TaskArray exceptions) {
		boolean result = true;
		CDSIndexDefinition cdxid = terminatedCDXTrancheDefinitions.findIndexDefinition(entry);
		if (cdxid == null) {
			String redid = entry.getRedId();
			StringBuilder error = new StringBuilder("No matching cds index definition in terminated trades ");
			error.append(" for RED ").append(redid);
			error.append(" and maturity ").append(entry.getEndDate());
			error.append(" [").append(entry.toString()).append("]");
			addException(exceptions, error.toString());
			result = false;
		}
		return result;
	}
	
	private boolean check(TradeCreationEntry entry, CDSABXHelper helper, TaskArray exceptions) {
		boolean result = true;
		CDSABSIndexDefinition cdxid = terminatedCDSABXDefinitions.findIndexDefinition(entry);
		if (cdxid == null) {
			String redid = entry.getRedId();
			StringBuilder error = new StringBuilder("No matching cds abs index definition in terminated trades ");
			error.append(" for RED ").append(redid);
			error.append(" and maturity ").append(entry.getEndDate());
			error.append(" [").append(entry.toString()).append("]");
			addException(exceptions, error.toString());
			result = false;
		}
		return result;
	}
	
	
	private void addException(TaskArray tasks, String message) {
        Task exception = this.task.createTask();
        exception.setStatus(Task.NEW);
        exception.setEventType(TrioptimaConstants.TASK_EXCEPTION_TYPE);
        exception.setComment(message);
        tasks.add(exception);
    }
	

    // The CDS related to terminated CDS trades
    private final Map<String, CreditDefaultSwap> terminatedCDSTradeCDS = new HashMap<String, CreditDefaultSwap>();
    // The index definitions related to terminated CDX trades
    private final CDSIndexDefinitionCache terminatedCDXDefinitions = new CDSIndexDefinitionCache("terminated CDX trades index cache");
    // The index definitions related to terminated CDXTranche trades
    private final CDSIndexDefinitionCache terminatedCDXTrancheDefinitions =
    		new CDSIndexDefinitionCache("terminated CDXTranche trades index cache", new CDXTrancheHelper());
    // The index definitions related to terminated CDS ABX trades
    private final CDSABSIndexDefinitionCache terminatedCDSABXDefinitions = new CDSABSIndexDefinitionCache("terminated CDS ABX trades index cache");
    private final ScheduledTaskTRI_REDUCE_IMPORT task;
    private final ProductHelperFactory productHelperFactory;
}

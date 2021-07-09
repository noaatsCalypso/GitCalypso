/**
 * 
 */
package calypsox.tk.bridge.trioptima;

import java.rmi.RemoteException;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;

import com.calypso.tk.bridge.ILegalEntityFinder;
import com.calypso.tk.bridge.trioptima.IssuerKey;
import com.calypso.tk.core.LegalEntity;
import com.calypso.tk.core.Log;
import com.calypso.tk.core.Trade;
import com.calypso.tk.core.TrioptimaConstants;
import com.calypso.tk.core.Util;
import com.calypso.tk.event.PSConnection;
import com.calypso.tk.service.DSConnection;
import com.calypso.tk.service.RemoteReferenceData;
import com.calypso.tk.util.TradeCreationEntry;
import com.calypso.tk.util.TradeTerminationEntry;
import com.calypso.tk.util.TriReduceAbstractException;
import com.calypso.tk.util.TriReduceException;

/**
 * @author jean-luc_vanniere
 *
 */
public class LegalEntityFinder implements ILegalEntityFinder {
	public LegalEntityFinder() {
	}

	/**
	 * Records the related counterparty
	 * @param entry
	 */
	public void record(TradeTerminationEntry entry) {
		Trade trade = entry.getTrade();
		LegalEntity counterparty = trade.getCounterParty();
		String key = entry.getCpDtccCode();
		Vector<LegalEntity> cpties = new Vector<LegalEntity>();
		cpties.add(counterparty);
		_counterparties.put(key, cpties);
	}
	
	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.ILegalEntityFinder#findCounterparty(com.calypso.tk.util.TradeCreationEntry)
	 */
	@Override
	public synchronized LegalEntity findCounterparty(TradeCreationEntry entry)
			throws TriReduceAbstractException {
		LegalEntity res = null;
		List<LegalEntity> cpties = null;
		String key = entry.getCpDtccCode();
		cpties = _counterparties.get(key);
		if (cpties == null) {
			try {
				cpties = fetchCounterparties(key);
			}
			catch (RemoteException e) {
				String message = "DataServer error while searching counterparty for " + key + " :" + e;
				Log.error(TrioptimaConstants.LOG_CAT, message);
				throw new TriReduceException(entry, message);
			}
			if (cpties != null) {
				_counterparties.put(key, cpties);
			}
		}
		if (Util.isEmpty(cpties)) {
			String message = "No counterparty matches " + key;
			throw new TriReduceException(entry, message);
		}
		else if (cpties.size() > 1) {
			StringBuilder builder = new StringBuilder("Several counterparties match " + key + ":");
			for (LegalEntity le : cpties) {
				builder.append(" ");
				builder.append(le.getCode());
			}
			throw new TriReduceException(entry, builder.toString());
		}
		else {
			res = cpties.get(0);
		}
		return res;
	}

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.ILegalEntityFinder#findIssuer(com.calypso.tk.util.TradeCreationEntry)
	 */
	@Override
	public synchronized LegalEntity findIssuer(TradeCreationEntry entry)
			throws TriReduceAbstractException {
		LegalEntity res = null;
		List<LegalEntity> issuers = null;
		IssuerKey key = new IssuerKey(entry);
		issuers = _issuers.get(key);
		if (issuers == null) {
			try {
				issuers = fetchIssuers(key);
			} catch (RemoteException e) {
				String message = "DataServer error while searching issuer for " + key + " :" + e;
				Log.error(TrioptimaConstants.LOG_CAT, message);
				throw new TriReduceException(entry, message);
			}
			if (issuers != null) {
				_issuers.put(key, issuers);
			}
		}
		
		if (Util.isEmpty(issuers)) {
			String message = "No issuer matches " + key;
			throw new TriReduceException(entry, message);
		}
		else if (issuers.size() > 1) {
			StringBuilder builder = new StringBuilder("Several issuers match " + key + ":");
			for (LegalEntity le : issuers) {
				builder.append(" ");
				builder.append(le.getCode());
			}
			throw new TriReduceException(entry, builder.toString());
		}
		else {
			res = issuers.get(0);
		}
		return res;
	}

	private List<LegalEntity> fetchCounterparties(String key) throws RemoteException {
		List<LegalEntity> res = null;
		String from = "le_attribute LA, legal_entity_role R";
		StringBuilder builder = new StringBuilder("legal_entity.legal_entity_id = LA.legal_entity_id AND LA.attribute_type = ");
		builder.append(Util.string2SQLString("DTCC_LE_ID"));
		builder.append(" AND LA.attribute_value = ");
		builder.append(Util.string2SQLString(key));
		builder.append(" AND LA.legal_entity_role in (");
		builder.append(Util.string2SQLString("ALL"));
		builder.append(",");
		builder.append(Util.string2SQLString("CounterParty"));
		builder.append(") AND R.legal_entity_id = legal_entity.legal_entity_id and R.role_name = ");
		builder.append(Util.string2SQLString("CounterParty"));
		builder.append(" AND legal_entity.le_status = ");
		builder.append(Util.string2SQLString("Enabled"));
		String where = builder.toString();
		res = fetchLegalEntities(where, from);
		return res;
	}
	
	private List<LegalEntity> fetchIssuers(IssuerKey key) throws RemoteException {
		List<LegalEntity> res = null;
		String from = key.getFromClause();
		String where = key.getWhereClause();
		res = fetchLegalEntities(where, from);
		return res;
	}
	
	@SuppressWarnings("unchecked")
	private List<LegalEntity> fetchLegalEntities(String where, String from) throws RemoteException {
		List<LegalEntity> res = new Vector<LegalEntity>();
		DSConnection ds = DSConnection.getDefault();
		if (ds != null) {
			RemoteReferenceData remote = ds.getRemoteReferenceData();
			Vector v = remote.getAllLE(from, where, false);
			if (!Util.isEmpty(v)) {
				for (Object le : v) {
					if (le instanceof LegalEntity) {
						res.add((LegalEntity)le);
					}
				}
			}
		}
		// Collection<Integer> ids = remote.getLegalEntityIds(from, where);
		// List<Integer> le_ids = new Vector<Integer>();
		// le_ids.addAll(ids);
		// res = remote.getLegalEntitiesFromLegalEntityIds(le_ids);
		// if (res == null) {
		// 	res = new Vector<LegalEntity>();
		// }
		
		return res;
	}
	private final static HashMap<String, List<LegalEntity>> _counterparties = new HashMap<String, List<LegalEntity>>();
	private final static HashMap<IssuerKey, List<LegalEntity>> _issuers = new HashMap<IssuerKey, List<LegalEntity>>();
}

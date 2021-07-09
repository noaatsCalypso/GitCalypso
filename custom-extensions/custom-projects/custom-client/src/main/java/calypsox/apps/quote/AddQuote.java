package calypsox.apps.quote;

import java.io.BufferedReader;
import java.io.InputStreamReader;

import com.calypso.tk.core.CalypsoServiceException;
import com.calypso.tk.infosec.io.ResourceFactory;
import com.calypso.tk.marketdata.FeedAddress;
import com.calypso.tk.marketdata.RandomFeedHandler;
import com.calypso.tk.service.DSConnection;
import com.calypso.tk.service.RemoteMarketData;

public class AddQuote {
	public static void main(String[] args) throws Exception {
		DSConnection ds = DSConnection.getDefault();
		AddQuote addQuote = new AddQuote();
		addQuote.process(ds);
//		for (String data : ) {
//		for (String data : Files.readAllLines(Paths.get(resource.getURI()))) {
//			System.out.println(data);
//			String[] datasArr = data.split("\\|");
//			if(datasArr.length>=3 && !datasArr[0].equals("QuoteAddress")) {
//				System.out.println(datasArr[0]+" "+datasArr[1]);
//			}
//			FeedAddress feed = new FeedAddress();
//			feed.setFeedName("RandomFeed");
//			feed.setQuoteName(datasArr[0]);
//			feed.setFeedAddress(datasArr[0]);
//			feed.setQuoteType(datasArr[1]);
//			feed.setFeedBidName(datasArr[2]);
//			feed.setFeedAskName(datasArr[5]);
//			feed.setFeedOpenName(datasArr[8]);
//			feed.setFeedCloseName(datasArr[11]);
//			feed.setFeedLastName(datasArr[14]);
//			feed.setFeedHighName(datasArr[17]);
//			feed.setFeedLowName(datasArr[20]);
//			rm.save(feed);
//		}
	}

	public void process(DSConnection ds) {
		BufferedReader br = new BufferedReader(new InputStreamReader(
				ResourceFactory.get().getResourceAsStream(RandomFeedHandler.class.getClassLoader(), "samples/NoaQuoteGent.txt")));

		br.lines().filter(x -> x.startsWith("FXOption")).forEach(x -> {
			String[] datasArr = x.split("\\|");
			RemoteMarketData rm = ds.getRemoteMarketData();

			FeedAddress feed = new FeedAddress();
			feed.setFeedName("RandomFeed");
			feed.setQuoteName(datasArr[0]);
			feed.setFeedAddress(datasArr[0]);
			feed.setQuoteType(datasArr[1]);
			feed.setFeedBidName(datasArr[2]);
			feed.setFeedAskName(datasArr[5]);
			feed.setFeedOpenName(datasArr[8]);
			feed.setFeedCloseName(datasArr[11]);
			feed.setFeedLastName(datasArr[14]);
			feed.setFeedHighName(datasArr[17]);
			feed.setFeedLowName(datasArr[20]);
			try {
				rm.save(feed);
			} catch (CalypsoServiceException e) {
				e.printStackTrace();
			}
		});
	}

}

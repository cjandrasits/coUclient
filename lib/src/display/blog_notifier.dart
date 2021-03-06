part of couclient;

class BlogNotifier {
	static const _LS_KEY = "cou_blog_post";
	static const _RSS_URL = "http://childrenofur.com/feed/";
	static const ICON_URL = "http://childrenofur.com/assets/icon_72.png";

	static dynamic get _lastSaved {
		if (localStorage[_LS_KEY] != null) {
			return localStorage[_LS_KEY];
		} else {
			return "";
		}
	}

	static set _lastSaved(dynamic id) {
		localStorage[_LS_KEY] = id.toString();
	}

	static void _notify(String link, String title) {
		new Notification(
			"Children of Ur Blog",
			body: "Click here to read the new post: \n$title",
			icon: ICON_URL
		)..onClick.listen((_) {
			window.open(link, "_blank");
		});
	}

	static void refresh() {
		HttpRequest.getString(_RSS_URL).then((String xml) {
			// Parse RSS -> XML -> Document
			XML.XmlDocument feed = XML.parse(xml);
			// Find the latest post
			XML.XmlElement item = feed.findAllElements("item").first;
			// Get the title
			String title = item.findElements("title").first.text;
			// Get the link
			String permalink = item.findElements("guid").first.text;
			// Get the ID
			String guid = permalink.split("/?p=")[1];
			// Compare to last known post
			if (guid != _lastSaved) {
				// New post
				_notify(permalink, title);
				// Update cached
				_lastSaved = guid;
			}
		});
	}
}
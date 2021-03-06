part of couclient;

class MenuOption {
	String uiName, serverName, errorText, itemType;
	int timeRequired;
	bool enabled;
	Map dropMap;
}

class RightClickMenu {
	static Element create2(MouseEvent click, String title, List<Map> options,
		{String description: '', String itemName: ''}) {
		/**
		 * title: main text shown at the top
		 *
		 * description: smaller text, shown under title
		 *
		 * options:
		 * [
		 *   {
		 *     "name": <name of option shown in list>,
		 *     "description": <description in tooltip>,
		 *     "enabled": <true|false, will determine if the option can be selected>,
		 *     "timeRequired": <number, seconds the action takes (instant if not defined)>,
		 *     "serverCallback": <function name for server entity>,
		 *     "clientCallback": <a no-argument function>,
		 *     "entityId": <entity summoning the menu>,
		 *     "arguments": <Map of arguments the option takes>
		 *   },
		 *   ...
		 * ]
		 *
		 * itemName: string of the item selected, will show the (i) button if not null and will open the item info window when the (i) is clicked
		 */

		// allow only one open at a time

		destroy();

		// define parts

		DivElement menu, infoButton, actionList;
		SpanElement titleElement;

		// menu base

		menu = new DivElement()
			..id = "RightClickMenu";

		// main title

		titleElement = new SpanElement()
			..id = "ClickTitle"
			..text = title;

		menu.append(titleElement);

		// show item info window

		if (itemName != '') {
			infoButton = new DivElement()
				..id = "openItemWindow"
				..className = "InfoButton fa fa-info-circle"
				..setAttribute('item-name', itemName)
				..onClick.listen((_) {
					new ItemWindow(itemName).displayItem();
				});
			menu.append(infoButton);
		}

		// actions

		actionList = new DivElement()
			..id = "RCActionList";

		menu.append(actionList);

		// position

		int x, y;

		// options

		List<Element> newOptions = new List();
		for (Map option in options) {
			DivElement wrapper = new DivElement()
				..className = "action_wrapper";
			DivElement tooltip = new DivElement()
				..className = "action_error_tooltip";
			DivElement menuitem = new DivElement();
			menuitem
				..classes.add("RCItem")
				..text = option["name"];

			if (option["enabled"]) {
				menuitem.onClick.listen((_) async {
					int timeRequired = option["timeRequired"];

					bool completed = true;
					if (timeRequired > 0) {
						ActionBubble actionBubble = new ActionBubble(option['name'], timeRequired);
						completed = await actionBubble.wait;
					}

					if (completed) {
						Map arguments = null;
						if (option["arguments"] != null) {
							arguments = option["arguments"];
						}

						if (option.containsKey('serverCallback')) {
							sendAction(option["serverCallback"].toLowerCase(), option["entityId"], arguments);
						}
						if (option.containsKey('clientCallback')) {
							option['clientCallback']();
						}
					}
				});

				menuitem.onMouseOver.listen((e) {
					e.target.classes.add("RCItemSelected");
				});

				menuitem.onMouseOut.listen((e) {
					e.target.classes.remove("RCItemSelected");
				});

				document.onKeyUp.listen((KeyboardEvent k) {
					if (k.keyCode == 27) {
						destroy();
					}
				});
			} else {
				menuitem.classes.add('RCItemDisabled');
			}

			if (option["description"] != null) {
				showActionError(tooltip, option["description"]);
			}

			wrapper.append(menuitem);
			wrapper.append(tooltip);
			newOptions.add(wrapper);
		}

		// keyboard navigation

		if (!newOptions[0].children[0].classes.contains("RCItemDisabled")) {
			if (newOptions.length > 1) {
				menu.onKeyPress.listen((e) {
					if (e.keyCode == 40) {
						// down arrow
						newOptions[0].children[0].classes.toggle("RCItemSelected");
					}
					if (e.keyCode == 38) {
						// up arrow
						newOptions[0].children[newOptions.length].classes.toggle("RCItemSelected");
					}
				});
			} else if (newOptions.length == 1) {
				newOptions[0].children[0].classes.toggle("RCItemSelected");
			}
		}

		document.body.append(menu);
		if (click != null) {
			x = click.page.x - (menu.clientWidth ~/ 2);
			y = click.page.y - (40 + (options.length * 30));
		} else {
			num posX = CurrentPlayer.posX,
				posY = CurrentPlayer.posY;
			int width = CurrentPlayer.width,
				height = CurrentPlayer.height;
			num translateX = posX,
				translateY = view.worldElement.clientHeight - height;
			if (posX > currentStreet.bounds.width - width / 2 - view.worldElement.clientWidth / 2) {
				translateX = posX - currentStreet.bounds.width + view.worldElement.clientWidth;
			} else if (posX + width / 2 > view.worldElement.clientWidth / 2) {
				translateX = view.worldElement.clientWidth / 2 - width / 2;
			}
			if (posY + height / 2 < view.worldElement.clientHeight / 2) {
				translateY = posY;
			} else if (posY < currentStreet.bounds.height - height / 2 - view.worldElement.clientHeight / 2) {
				translateY = view.worldElement.clientHeight / 2 - height / 2;
			} else {
				translateY = view.worldElement.clientHeight - (currentStreet.bounds.height - posY);
			}
			x = (translateX + menu.clientWidth + 10) ~/ 1;
			y = (translateY + height / 2) ~/ 1;
		}

		actionList.children.addAll(newOptions);
		menu.style
			..opacity = '1.0'
			..transform = 'translateX(' + x.toString() + 'px) translateY(' + y.toString() + 'px)';

		document.onClick.first.then((_) => destroy());
		return menu;
	}

	static Element create(MouseEvent Click, String title, String description, List<List> options,
		{ItemDef item: null, String itemName: ''}) {
		if(item != null) {
			itemName = item.name;
		}
		destroy();
		DivElement menu = new DivElement()
			..id = "RightClickMenu";
		DivElement infoButton = new DivElement()
			..id = "openItemWindow"
			..className = "InfoButton fa fa-info-circle"
			..onClick.listen((_) => new ItemWindow(itemName).displayItem());
		SpanElement titleElement = new SpanElement()
			..id = "ClickTitle"
			..text = title;
		DivElement actionList = new DivElement()
			..id = "RCActionList";

		if (itemName != '') {
			infoButton.setAttribute('item-name', itemName);
		}

		if (itemName != '') {
			menu.append(infoButton);
		}
		menu.append(titleElement);
		menu.append(actionList);

		int x, y;

		List<Element> newOptions = new List();
		int index = 1;
		for (List option in options) {
			DivElement wrapper = new DivElement()
				..className = 'action_wrapper';
			DivElement tooltip = new DivElement()
				..className = 'action_error_tooltip';
			DivElement menuitem = new DivElement();
			String actionText = (option[0] as String).split("|")[0];
			menuitem
				..classes.add('RCItem')
				..text = "${index.toString()}: $actionText";

			MenuKeys.addListener(index, () {
				// Trigger onClick listener (below) when correct key is pressed
				if(Click != null) {
					menuitem.dispatchEvent(new MouseEvent('click', clientX: Click.client.x, clientY: Click.client.y));
				} else {
					menuitem.click();
				}

				if (menuitem.classes.contains("RCItemDisabled")) {
					toast((option[0] as String).split("|")[4]);
				}
			});

			if ((option[0] as String).split("|")[3] == "true") {
				menuitem.onClick.listen((MouseEvent event) async {
					String functionName = (option[0] as String).split("|")[0].toLowerCase();
					Function doClick = ({howMany: 1}) async {
						int timeRequired = int.parse((option[0] as String).split("|")[2]);

						bool completed = true;
						if (timeRequired > 0) {
							ActionBubble actionBubble = new ActionBubble((option[0] as String).split("|")[1], timeRequired);
							completed = await actionBubble.wait;
						}

						if(completed) {
							// Action completed
							Map arguments = null;
							if (option.length > 3) {
								arguments = option[3];
								arguments['count'] = howMany;
							}

							if(functionName == 'pickup' && howMany > 1) {
								//try to pick up howMany items that we're touching
								List<String> objectIds = CurrentPlayer.intersectingObjects.keys.toList();
								objectIds.removeWhere((String id) => querySelector('#$id').attributes['type'] != itemName);
								for(int i=0; i<howMany; i++) {
									option[1] = objectIds[i];
									sendAction(functionName, option[1], arguments);
								}
							} else {
								sendAction(functionName, option[1], arguments);
							}
						}
					};

					bool multiEnabled = false;
					if((option[0] as String).split('|').length > 5) {
						multiEnabled = (option[0] as String).split('|')[5] == 'true';
					}

					if(multiEnabled) {
						int max = 0, slot = -1, subSlot = -1;
						if(option.length > 3) {
							slot = option[3]['slot'];
							subSlot = option[3]['subSlot'];
						}
						if(functionName == 'pickup') {
							CurrentPlayer.intersectingObjects.keys.forEach((String id) {
								if(querySelector('#$id').attributes['type'] == itemName) {
									max++;
								}
							});
						} else {
							max = _getNumItems(item.itemType, slot: slot, subSlot: subSlot);
						}
						if(max == 1) {
							//don't show a how many dialog if there's only 1
							doClick();
						} else {
							HowManyMenu.create(event, functionName, max, doClick, itemName: itemName);
						}
					} else {
						doClick();
					}
				});

				menuitem.onMouseOver.listen((e) {
					e.target.classes.add("RCItemSelected");
				});

				menuitem.onMouseOut.listen((e) {
					e.target.classes.remove("RCItemSelected");
				});

				document.onKeyUp.listen((KeyboardEvent k) {
					if (k.keyCode == 27) {
						destroy();
					}
				});
			} else {
				menuitem.classes.add('RCItemDisabled');
			}

			showActionError(tooltip, (option[0] as String).split("|")[4]);

			wrapper.append(menuitem);
			wrapper.append(tooltip);
			newOptions.add(wrapper);

			index++;
		}
		if (newOptions.length > 0 && !newOptions[0].children[0].classes.contains("RCItemDisabled")) {
			if (newOptions.length > 1) {
				menu.onKeyPress.listen((e) {
					if (e.keyCode == 40) {
						// down arrow
						newOptions[0].children[0].classes.toggle("RCItemSelected");
					}
					if (e.keyCode == 38) {
						// up arrow
						newOptions[0].children[newOptions.length].classes.toggle("RCItemSelected");
					}
				});
			} else if (newOptions.length == 1) {
				newOptions[0].children[0].classes.toggle("RCItemSelected");
			}
		}

		document.body.append(menu);
		if (Click != null) {
			x = Click.client.x - (menu.clientWidth ~/ 2);
			y = Click.client.y - (40 + (options.length * 30));
		} else {
			num posX = CurrentPlayer.posX,
				posY = CurrentPlayer.posY;
			int width = CurrentPlayer.width,
				height = CurrentPlayer.height;
			num translateX = posX,
				translateY = view.worldElement.clientHeight - height;
			if (posX > currentStreet.bounds.width - width / 2 - view.worldElement.clientWidth / 2) {
				translateX = posX - currentStreet.bounds.width + view.worldElement.clientWidth;
			} else if (posX + width / 2 > view.worldElement.clientWidth / 2) {
				translateX = view.worldElement.clientWidth / 2 - width / 2;
			}
			if (posY + height / 2 < view.worldElement.clientHeight / 2) {
				translateY = posY;
			} else if (posY < currentStreet.bounds.height - height / 2 - view.worldElement.clientHeight / 2) {
				translateY = view.worldElement.clientHeight / 2 - height / 2;
			} else {
				translateY = view.worldElement.clientHeight - (currentStreet.bounds.height - posY);
			}
			x = (translateX + menu.clientWidth + 10) ~/ 1;
			y = (translateY + height / 2) ~/ 1;
		}

		actionList.children.addAll(newOptions);
		menu.style
			..opacity = '1.0'
			..transform = 'translateX(' + x.toString() + 'px) translateY(' + y.toString() + 'px)';

		document.onClick.first.then((_) => destroy());
		return menu;
	}

	static void showActionError(Element tooltip, String errorText) {
		tooltip.hidden = errorText == '';
		tooltip.text = errorText;
	}

	static void destroy() {
		Element menu = querySelector("#RightClickMenu");
		if (menu != null) {
			menu.remove();
			MenuKeys.clearListeners();
			transmit("right_click_menu", "destroy");
		}
	}
}

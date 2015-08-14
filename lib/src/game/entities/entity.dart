part of couclient;

abstract class GlowingEntity extends Entity {
	xl.DisplayObject displayObject;

	@override
	advanceTime(num time) {
		displayObject.x = left - camera.x;
		displayObject.y = top - camera.y;
		if (glow) {
			if (!displayObject.filters.contains(glowFilter)) {
				displayObject.filters.add(glowFilter);
			}
		} else {
			displayObject.filters.remove(glowFilter);
		}
	}
}

abstract class Entity implements xl.Animatable {
	xl.BitmapDataLoadOptions loadOptions = new xl.BitmapDataLoadOptions()
		..corsEnabled = true;
	xl.ResourceManager entityResourceManger = new xl.ResourceManager();
	xl.GlowFilter glowFilter;
	bool glow = false, dirty = true;
	ChatBubble chatBubble = null;
	CanvasElement canvas;
	num left = 0, top = 0, width = 0, height = 0;
	String id;
	MutableRectangle _entityRect, _destRect;

	Entity() {
		glowFilter = new xl.GlowFilter()
			..color = xl.Color.Cyan
			..blurX = 8
			..blurY = 8;
	}

	@override
	bool advanceTime(num time);

	bool get intersectingPlayer {
		return intersect(CurrentPlayer.avatarRect, entityRect);
	}

	void update(double dt) {
		if (intersectingPlayer) {
			updateGlow(true);
			CurrentPlayer.intersectingObjects[id] = entityRect;
		} else {
			CurrentPlayer.intersectingObjects.remove(id);
			updateGlow(false);
		}
	}

	Rectangle get destRect {
		if (_destRect == null) {
			_destRect = new MutableRectangle(0, 0, width, height);
		} else {
			_destRect.left = 0;
			_destRect.top = 0;
			_destRect.width = width;
			_destRect.height = height;
		}

		return _destRect;
	}

	Rectangle get entityRect {
		if (_entityRect == null) {
			_entityRect = new MutableRectangle(left, top, width, height);
		} else {
			_entityRect.left = left;
			_entityRect.top = top;
			_entityRect.width = width;
			_entityRect.height = height;
		}

		return _entityRect;
	}

	void render();

	void updateGlow(bool newGlow) {
		if (glow != newGlow) {
			dirty = true;
		}
		glow = newGlow;
	}

	void interact(String id) {
		Element element = querySelector("#$id");
		List<List> actions = [];
		bool allDisabled = true;

		if (element.attributes['actions'] != null) {
			List<Map> actionsList = JSON.decode(element.attributes['actions']);
			actionsList.forEach((Map actionMap) {
				bool enabled = actionMap['enabled'];

				if (enabled) {
					allDisabled = false;
				}

				String error = "";
				if (actionMap['requires'] != null) {
					enabled = hasRequirements(actionMap['requires']);
					if (enabled) {
						if (actionMap.containsKey('description')) {
							error = actionMap['description'];
						} else {
							error = '';
						}
					} else {
						error = getRequirementString(actionMap['requires']);
					}
				}

				actions.add([capitalizeFirstLetter(actionMap['action']) + "|" + actionMap['actionWord'] + "|${actionMap['timeRequired']}|$enabled|$error", element.id, "sendAction ${actionMap['action']} ${element.id}"]);
			});
		}

		if (!allDisabled) {
			inputManager.showClickMenu(null, element.attributes['type'], "Desc", actions);
		}
	}
}
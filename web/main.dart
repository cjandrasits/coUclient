library couclient;
/*
 *  THE CHILDREN OF UR WEBCLIENT
 *  http://www.childrenofur.com
 *
 *
*/

// DART //
import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

// LIBRARIES //
// Used for NumberFormat
import 'package:intl/intl.dart' show NumberFormat;
// Slack Webhook API
import 'package:slack/slack_html.dart' as slack;
// SoundCloud Helper
import 'package:scproxy/scproxy.dart';
// Audio and Graphics
import 'package:gorgon/gorgon.dart'; // for Webaudio api
//import 'package:dnd/dnd.dart'; //for dragging items into vendor interface
// Asset Loading
import 'package:libld/libld.dart'; // Nice and simple asset loading.
// Event Bus and Pumps // for more infomation see '/doc/pumps.md'
import 'package:pump/pump.dart';

import 'package:persona/persona_html.dart';

// SYSTEMS MODULES //
part 'package:couclient/src/systems/clock.dart';
part 'package:couclient/src/systems/commands.dart';
part 'package:couclient/src/game/input.dart';
part 'package:couclient/src/systems/util.dart';
part 'package:couclient/src/systems/preload.dart';

// NETWORKING MODULES //
part 'package:couclient/src/network/chat.dart';
part 'package:couclient/src/network/auth.dart';
part 'package:couclient/src/network/multiplayer.dart';
part 'package:couclient/src/network/metabolics.dart';

// UI/UX MODULES //
part 'package:couclient/src/display/userinterface.dart';
part 'package:couclient/src/display/chatpanel.dart';
part 'package:couclient/src/display/meters.dart';
part 'package:couclient/src/display/toast.dart';
part 'package:couclient/src/display/audio.dart';
part 'package:couclient/src/display/render.dart';
part 'package:couclient/src/display/loop.dart';

//  WINDOW MODULES //
part 'package:couclient/src/display/windows.dart';
part 'package:couclient/src/display/windows/settings_window.dart';
part 'package:couclient/src/display/windows/bag_window.dart';
part 'package:couclient/src/display/windows/bug_window.dart';
part 'package:couclient/src/display/windows/map_window.dart';
part 'package:couclient/src/display/windows/vendor_window.dart';

// STREET RENDERING MODULES //
part 'package:couclient/src/display/render/camera.dart';
part 'package:couclient/src/display/render/deco.dart';
part 'package:couclient/src/display/render/ladder.dart';
part 'package:couclient/src/display/render/wall.dart';
part 'package:couclient/src/display/render/platform.dart';
part 'package:couclient/src/display/render/signpost.dart';
part 'package:couclient/src/display/render/collision_lines_debug.dart';
part 'package:couclient/src/display/render/worldmap.dart';
part 'package:couclient/src/display/render/maps_data.dart';

// GAME MODULES //
part 'package:couclient/src/game/game.dart';
part 'package:couclient/src/game/entities/player.dart';
part 'package:couclient/src/game/animation.dart';
part 'package:couclient/src/game/chat_bubble.dart';
part 'package:couclient/src/game/entities/entity.dart';
part 'package:couclient/src/game/entities/npc.dart';
part 'package:couclient/src/game/entities/plant.dart';
part 'package:couclient/src/game/street.dart';
part 'package:couclient/src/game/entities/quoin.dart';

// UI PIECES //
part 'package:couclient/src/display/ui_templates/interactions_menu.dart';
part 'package:couclient/src/display/ui_templates/right_click_menu.dart';

// Globals //
Storage localStorage = window.localStorage;
SoundManager soundManager;
InputManager inputManager;
Storage session = window.sessionStorage;
Storage local = window.localStorage;
Random random = new Random();
NumberFormat commaFormatter = new NumberFormat("#,###");
Persona nav;





main() {

  loadTokens();
  toastService;
  errService;
  
  soundManager = new SoundManager();
  new NetChatManager();
  new MeterManager();
  new WindowManager();
  inputManager = new InputManager();

  Game game = new Game();

  
  // Test Information
  new Message(#startChat, 'Global Chat');
  new Message(#startChat, 'Local Chat');
  new Message(#toast,'testing toast');
  ui.update();
  
  // System
  new ClockManager();
  new CommandManager();
  
  // GAME ENTRY //

  
}

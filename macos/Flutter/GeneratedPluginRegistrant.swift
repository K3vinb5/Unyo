//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import desktop_keep_screen_on
import fvp
import screen_retriever
import shared_preferences_foundation
import url_launcher_macos
import video_player_avfoundation
import window_manager

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  DesktopKeepScreenOnPlugin.register(with: registry.registrar(forPlugin: "DesktopKeepScreenOnPlugin"))
  FvpPlugin.register(with: registry.registrar(forPlugin: "FvpPlugin"))
  ScreenRetrieverPlugin.register(with: registry.registrar(forPlugin: "ScreenRetrieverPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
  FVPVideoPlayerPlugin.register(with: registry.registrar(forPlugin: "FVPVideoPlayerPlugin"))
  WindowManagerPlugin.register(with: registry.registrar(forPlugin: "WindowManagerPlugin"))
}

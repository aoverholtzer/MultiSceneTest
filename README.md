# MultiSceneTest

Minimal implemenation of multiple scenes (windows) on iOS 13 and Mac Catalyst. This is useful for finding and reporting bugs with multi-window Catalyst apps.

To test, simply build and run the app on macOS Catalina or iPadOS 13. Click the top button to create new scenes/windows and click the bottom button to bring an existing scene/window to the foreground.

### Bugs I've Found:

1. **App crashes when secondary window is closed.** (Catalyst, FB6933235, FB6940492)
   
   If you've tried closing a window in Beta 5, you've seen this error:
   ```objective-c
   *** Terminating app due to uncaught exception 'NSRangeException', reason: 'Cannot remove an observer <UINSSceneViewController 0x60000350eaa0> for the key path "view.window.screen.contentLayoutRect" from <UINSSceneViewController 0x60000350eaa0> because it is not registered as an observer.'
   ```
   
2. **Activating an existing session (window) does not work.** (Catalyst, FB6528385)
   
   Calling  `requestSceneSessionActivation:userActivity:options:errorHandler:` with an existing session should bring its window to the front. This works on iOS but not in Catalyst.

3. **Windows (scenes) on MacOS do not restore state on re-launch.** (Catalyst, FB6528562)
   
   By providing a valid NSUserActivity in the method `SceneDelegate stateRestorationActivityForScene:` when the app is quit, we enable secondary windows to be restored when the app is relaunched. This works as expected on iOS: on relaunch, our `stateRestorationActivity` is passed in to `scene:willConnectToSession:options:` so we can restore the session. On macOS, this fails in one of two ways: Either no secondary windows are created at all, or they are created but no `stateRestorationActivity` is passed in.

4. **UIApplication.openSessions contains closed windows.** (Catalyst & iPadOS, FB6943824)
   
   Try this on either iPad or macOS:
   
   1. Run the app and open a bunch of windows.
   
   2. Close all of the windows, which ultimately terminates the app.
   
   3. Relaunch the app and click the "Activate Existing Scene" button.
   
   We'd expect that button to show an error, yet it is able to open an "existing" scene somehow. If you run in the debugger, you'll see that `UIApplication.sharedApplication.openSessions` includes all the sessions we closed in our last run, so the app found and restored one of those. The [documentation](https://developer.apple.com/documentation/uikit/uiapplication/3197900-opensessions?language=objc) says the list includes both active and "archived" sessions, which it defines as:
   
   > An archived session does not have a connected scene, but a snapshot of its UI does appear in the app switcher.
   
   These sessions from our last run are _not_ in the iPad app switcher, so this appears to be an error. That said, restoring state in an existing session and creating a new session may be functionally equivalent in a real app. This test app's "restore some random scene" button is not behavior I'd expect to see in real a real app.


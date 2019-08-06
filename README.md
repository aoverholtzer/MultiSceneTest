# MultiSceneTest

Minimal implemenation of multiple scenes (windows) on iOS 13 and Mac Catalyst. This is useful for finding and reporting bugs with multi-window Catalyst apps.

To test, simply build and run the app on macOS Catalina or iPadOS 13. Click the top button to create new scenes/windows and click the bottom button to bring an existing scene/window to the foreground.

### Bugs I've Found:

1. **App crashes when secondary window is closed.** (Catalyst, FB6933235, FB6940492)
   
   If you've tried closing a window in Beta 5, you've probably seen this error:
   ```objective-c
   *** Terminating app due to uncaught exception 'NSRangeException', reason: 'Cannot remove an observer <UINSSceneViewController 0x60000350eaa0> for the key path "view.window.screen.contentLayoutRect" from <UINSSceneViewController 0x60000350eaa0> because it is not registered as an observer.'
   ```
   
2. **Activating an existing session (window) does not work.** (Catalyst, FB6528385 — closed as dupe)
   
   Calling `requestSceneSessionActivation:userActivity:options:errorHandler:` with an existing session should bring its window to the front. This works on iOS but not in Catalyst, meaning the "Activate Existing Scene" button works on iPad but fails on macOS (it creates a new window).

3. **Windows (scenes) on MacOS do not restore state on re-launch.** (Catalyst, FB6528562)
   
   By returning a valid NSUserActivity from our scene delegate's `stateRestorationActivityForScene:` method when the app is quit, we enable secondary windows to be restored when the app is relaunched. This works as expected on iOS: on relaunch, our `stateRestorationActivity` is passed in to the restored scene's delegate `scene:willConnectToSession:options:`. On macOS, this fails in one of two ways: Either the scene isn't created at all, or it's created but no `stateRestorationActivity` is passed in.

4. **UIApplication.openSessions contains closed windows.** (Catalyst & iPadOS, FB6943824)
   
   `UIApplication.openSessions` contains sessions for scenes that were closed _by the user_. Try this on either iPad or macOS:
   
   1. Run the app and open a bunch of windows.
   
   2. Close all of the windows, which ultimately terminates the app.
   
   3. Relaunch the app, which should show a single window (the default config).
   
   4. Click the "Activate Existing Scene" button.
   
   We'd expect that button to show an error because there are no other windows, but it is somehow able to activate an "existing" scene. If you run in the debugger, you'll see that `UIApplication.sharedApplication.openSessions` includes all the sessions we closed in our previous run, so the app has found and restored one of those. The [documentation](https://developer.apple.com/documentation/uikit/uiapplication/3197900-opensessions?language=objc) says `openSessions` contains both active and "archived" sessions, which it defines as:
   
   > An archived session does not have a connected scene, but a snapshot of its UI does appear in the app switcher.
   
   These sessions from our last run are _not_ in the iPad app switcher, so this appears to be either a bug or a documentation error. That said, restoring state in an existing session and creating a new session may be functionally equivalent in a real app. This test app's "restore some random scene" button is not behavior I'd expect to see in a real app.


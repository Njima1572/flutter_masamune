part of masamune;

// /// A dialog box that checks for connections and gives an error when no connection is made and waits for the next step.
// ///
// /// ```
// /// UIConnectDialog.show( context );
// /// ```
class UIConnectDialog {
  const UIConnectDialog._();

  /// Show dialog.
  ///
  /// [context]: Build context.
  /// [dialogTitlePath]: Dialog title path.
  /// [dialogTextPath]: Dialog text path.
  /// [dialogRetryTextPath]: Dialog retry button text path.
  /// [dialogRetryActionPath]: The path of action when the retry button of the dialog is pressed.
  /// [dialogBackTextPath]: Dialog back button text path.
  /// [dialogBackActionPath]: The path of action when the back button of the dialog is pressed.
  /// [retryText]: Default retry button text.
  /// [onRetry]: Default retry button action.
  /// [backText]: Default back button text.
  /// [onBack]: Default back button action.
  /// [backgroundColor]: Background color.
  /// [color]: Text color.
  /// [title]: Default title.
  /// [text]: Default text.
  /// [showBackButton]: If true, the back button is displayed.
  /// [disableBackKey]: True to disable the back key.
  static Future<void> show(
    BuildContext context, {
    String retryText = "Retry",
    String backText = "Back",
    Color? backgroundColor,
    Color? color,
    String title = "Error",
    String text = "Unable to connect to the network.",
    VoidCallback? onRetry,
    VoidCallback? onBack,
    bool showBackButton = true,
    bool disableBackKey = false,
  }) async {
    bool clicked = false;
    final overlay = context.navigator.overlay;
    if (overlay == null) {
      return;
    }
    while (await Config.connect() == ConnectivityResult.none && !clicked) {
      await showDialog(
        context: overlay.context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: disableBackKey ? () async => true : null,
            child: AlertDialog(
              title: Text(title.localize(),
                  style: TextStyle(
                      color: color ?? context.theme.textColorOnSurface)),
              content: SingleChildScrollView(
                child: Text(
                  text.localize(),
                  style: TextStyle(
                    color: color ?? context.theme.textColorOnSurface,
                  ),
                ),
              ),
              backgroundColor:
                  backgroundColor ?? context.theme.colorScheme.surface,
              actions: <Widget>[
                TextButton(
                  child: Text(retryText.localize()),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    onRetry?.call();
                  },
                ),
                if (showBackButton)
                  TextButton(
                    child: Text(backText.localize()),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      onBack?.call();
                      clicked = true;
                    },
                  )
              ],
            ),
          );
        },
      );
    }
  }
}

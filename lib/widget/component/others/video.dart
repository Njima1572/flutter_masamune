part of masamune.component.others;

/// Place the video as a widget.
///
/// A preview is also possible.
class Video extends StatefulWidget {
  /// Place the video as a widget.
  ///
  /// A preview is also possible.
  const Video(
    this.videoProvider, {
    this.loop = true,
    this.width,
    this.height,
    this.fit,
    this.autoplay = false,
    this.mute = false,
    this.iconSize = 64,
    this.controllable = false,
    this.mixWithOthers = false,
    this.onTap,
    this.iconColor,
  });

  /// Mix with others.
  final bool mixWithOthers;

  /// Video Provider.
  final VideoProvider videoProvider;

  /// True to loop the video.
  final bool loop;

  /// Horizontal size of the video.
  final double? width;

  /// Vertical size of the video.
  final double? height;

  /// Video fit.
  final BoxFit? fit;

  /// True for auto play.
  final bool autoplay;

  /// True if it can be played and stopped.
  final bool controllable;

  /// True to mute.
  final bool mute;

  /// Icon size.
  final double iconSize;

  /// Tap action.
  final VoidCallback? onTap;

  /// Icon color.
  final Color? iconColor;

  /// Creates the mutable state for this widget at a given location in the tree.
  ///
  /// Subclasses should override this method to return a newly created
  /// instance of their associated [State] subclass:
  ///
  /// ```dart
  /// @override
  /// _MyState createState() => _MyState();
  /// ```
  ///
  /// The framework can call this method multiple times over the lifetime of
  /// a [StatefulWidget]. For example, if the widget is inserted into the tree
  /// in multiple locations, the framework will create a separate [State] object
  /// for each location. Similarly, if the widget is removed from the tree and
  /// later inserted into the tree again, the framework will call [createState]
  /// again to create a fresh [State] object, simplifying the lifecycle of
  /// [State] objects.
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  Completer<void>? _completer;
  VideoPlayerController? _controller;

  @override
  void initState() {
    _updateVideoController();
    super.initState();
  }

  Future<void> _updateVideoController() async {
    if (_completer != null) {
      await _completer!.future;
    }
    try {
      _completer = Completer<void>();
      _controller?.dispose();
      _controller = null;
      final provider = widget.videoProvider;
      switch (provider.runtimeType) {
        case FileVideoProvider:
          throw UnsupportedError(
              "Video playback by passing [FileVideoProvider] is not supported on this platform.");
        case NetworkVideoProvider:
          _controller = VideoPlayerController.network(
            (provider as NetworkVideoProvider).url,
            videoPlayerOptions: widget.mixWithOthers
                ? VideoPlayerOptions(mixWithOthers: true)
                : null,
          );
          break;
        case AssetVideoProvider:
          _controller = VideoPlayerController.asset(
            (provider as AssetVideoProvider).path,
            videoPlayerOptions: widget.mixWithOthers
                ? VideoPlayerOptions(mixWithOthers: true)
                : null,
          );
          break;
      }
      final initializing = _controller?.initialize();
      _controller?.setLooping(widget.loop);
      if (widget.mute) {
        _controller?.setVolume(0);
      }
      await initializing;
      if (widget.autoplay) {
        _controller?.play();
      }
      _completer?.complete();
      _completer = null;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
    } finally {
      _completer?.complete();
      _completer = null;
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(Video oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoProvider != oldWidget.videoProvider) {
      _updateVideoController();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _completer?.future,
      builder: (context, snapshot) {
        if (_controller != null &&
            snapshot.connectionState == ConnectionState.done) {
          if (widget.width != null && widget.height != null) {
            return SizedBox(
              width: widget.width!,
              height: widget.height!,
              child: _videoWidget(context),
            );
          } else if (widget.width != null) {
            return SizedBox(
              width: widget.width!,
              height: widget.width! / _controller!.value.aspectRatio,
              child: _videoWidget(context),
            );
          } else if (widget.height != null) {
            return SizedBox(
              width: widget.height! * _controller!.value.aspectRatio,
              height: widget.height!,
              child: _videoWidget(context),
            );
          } else {
            return AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: _videoWidget(context),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).disabledColor,
            ),
          );
        }
      },
    );
  }

  Widget _videoWidget(BuildContext context) {
    if (_controller == null) {
      return const Empty();
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.fit == null)
          VideoPlayer(_controller!)
        else
          FittedBox(
              fit: widget.fit!,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              )),
        if (widget.controllable)
          Center(
            child: IconButton(
              iconSize: widget.iconSize,
              icon: Icon(
                  _controller!.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: _controller!.value.isPlaying
                      ? Colors.transparent
                      : (widget.iconColor ?? context.theme.dividerColor)),
              onPressed: () {
                if (_controller!.value.isPlaying) {
                  _controller!.pause();
                } else {
                  _controller!.play();
                }
                setState(() {});
              },
            ),
          ),
        if (widget.onTap != null)
          Material(
            color: Colors.transparent,
            child: ClickableBox(
              hoverColor: context.theme.splashColor.withOpacity(0.1),
              onTap: widget.onTap,
            ),
          ),
      ],
    );
  }
}

@immutable
abstract class VideoProvider {
  const VideoProvider();
}

@immutable
class AssetVideoProvider extends VideoProvider {
  const AssetVideoProvider(this.path);
  final String path;
}

@immutable
class NetworkVideoProvider extends VideoProvider {
  const NetworkVideoProvider(this.url);
  final String url;
}

@immutable
class FileVideoProvider extends VideoProvider {
  const FileVideoProvider(this.file);
  final dynamic file;
}

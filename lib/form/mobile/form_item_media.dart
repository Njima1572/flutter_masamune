part of masamune.form.mobile;

/// Form widget for uploading media (Image and Video).
///
/// ```
/// FormItemMedia(
///   constroller: useMemoizedTextEditingController(),
///   onTap: (onUpdate){
///     final media = await UIMediaDialog();
///     onUpdate(media.path);
///   },
///   onSaved: (value){
///     context["url"] = value;
///   }
/// )
/// ```
class FormItemMedia extends FormField<String> {
  /// Form widget for uploading media (Image and Video).
  ///
  /// ```
  /// FormItemMedia(
  ///   constroller: useMemoizedTextEditingController(),
  ///   onTap: (onUpdate){
  ///     final media = await UIMediaDialog();
  ///     onUpdate(media.path);
  ///   },
  ///   onSaved: (value){
  ///     context["url"] = value;
  ///   }
  /// )
  /// ```
  FormItemMedia({
    Key? key,
    this.controller,
    required this.onTap,
    this.color,
    this.hintText = "",
    this.errorText = "",
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.allowEmpty = false,
    this.dense = false,
    this.height = 200,
    this.videoExtensionList = const [
      "mp4",
      "ogv",
      "webm",
      "avi",
      "mpeg",
    ],
    this.icon = Icons.add_a_photo,
    void Function(String? value)? onSaved,
    String Function(String? value)? validator,
    String? initialURI,
    bool enabled = true,
    this.type = FormItemMediaType.both,
  }) : super(
          key: key,
          builder: (state) {
            return const Empty();
          },
          onSaved: onSaved,
          validator: (value) {
            if (!allowEmpty && errorText.isNotEmpty && value.isEmpty) {
              return errorText;
            }
            return validator?.call(value);
          },
          initialValue: initialURI,
          enabled: enabled,
        );

  /// The height of the text display when an error occurs.
  static const double errorTextHeight = 20;

  /// Padding.
  final EdgeInsetsGeometry padding;

  /// Processing when tapped.
  ///
  /// Finally save the file using [onUpdate].
  final void Function(void Function(dynamic fileOrUrl) onUpdate) onTap;

  /// The overall color if you have not uploaded an image and video.
  final Color? color;

  /// Icon if you have not uploaded an image and video.
  final IconData icon;

  /// `True` for dense.
  final bool dense;

  /// Height of form.
  final double height;

  /// `True` if the data should be empty.
  final bool allowEmpty;

  /// Hint label.
  final String hintText;

  /// Error label.
  final String errorText;

  /// Video extension list.
  final List<String> videoExtensionList;

  /// Media type.
  final FormItemMediaType type;

  /// Text ediging controller.
  final TextEditingController? controller;

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
  _FormItemMediaState createState() => _FormItemMediaState();
}

class _FormItemMediaState extends FormFieldState<String> {
  TextEditingController? _controller;
  File? _data;
  File? _local;
  String? _path;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemMedia get widget => super.widget as FormItemMedia;

  void _onUpdate(dynamic fileOrUrl) {
    if (fileOrUrl is String) {
      if (fileOrUrl.isEmpty) {
        return;
      }
      setState(() {
        setValue(fileOrUrl);
        _path = fileOrUrl;
        _data = null;
      });
    } else if (fileOrUrl is File) {
      if (fileOrUrl.path.isEmpty) {
        return;
      }
      setState(() {
        setValue(fileOrUrl.path);
        _data = fileOrUrl;
        _path = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      setValue(widget.controller?.text ?? value);
      widget.controller?.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(FormItemMedia oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        setValue(widget.controller?.text);
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: widget.padding,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (!widget.enabled) {
                return;
              }
              widget.onTap.call(_onUpdate);
            },
            child: _buildMedia(context),
          ),
          if (errorText.isNotEmpty)
            AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Text(errorText ?? "",
                    style: Theme.of(context).inputDecorationTheme.errorStyle),
                height:
                    errorText.isNotEmpty ? FormItemMedia.errorTextHeight : 0)
        ],
      ),
    );
  }

  FormItemMediaType _platformMediaType(String path) {
    if (widget.type != FormItemMediaType.both) {
      return widget.type;
    }
    final uri = Uri.tryParse(path);
    if (uri == null) {
      return FormItemMediaType.image;
    }
    final ext = uri.path.split(".").lastOrNull;
    if (ext == null) {
      return FormItemMediaType.image;
    }
    return widget.videoExtensionList.contains(ext)
        ? FormItemMediaType.video
        : FormItemMediaType.image;
  }

  Widget _showMediaFromFile(File file) {
    final type = _platformMediaType(file.path);
    switch (type) {
      case FormItemMediaType.video:
        return Video(
          FileVideoProvider(file),
          fit: BoxFit.cover,
          autoplay: true,
          mute: true,
          mixWithOthers: true,
        );
      default:
        return Image.file(file, fit: BoxFit.cover);
    }
  }

  Widget _showMediaFromPath(String path) {
    final type = _platformMediaType(path);
    switch (type) {
      case FormItemMediaType.video:
        return Video(
          NetworkOrAsset.video(path),
          fit: BoxFit.cover,
          autoplay: true,
          mute: true,
          mixWithOthers: true,
        );
      default:
        return Image(image: NetworkOrAsset.image(path), fit: BoxFit.cover);
    }
  }

  Widget _buildMedia(BuildContext context) {
    final value = widget.initialValue.isNotEmpty
        ? widget.initialValue
        : _effectiveController?.text;
    if (_data != null) {
      return Container(
        padding: widget.dense
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 10),
        constraints: BoxConstraints.expand(
            height: errorText.isNotEmpty
                ? (widget.height - FormItemMedia.errorTextHeight)
                : widget.height),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.dense ? 0 : 8.0),
          child: _showMediaFromFile(_data!),
        ),
      );
    } else if (_path != null) {
      return Container(
        padding: widget.dense
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 10),
        constraints: BoxConstraints.expand(
            height: errorText.isNotEmpty
                ? (widget.height - FormItemMedia.errorTextHeight)
                : widget.height),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.dense ? 0 : 8.0),
          child: _showMediaFromPath(_path!),
        ),
      );
    } else if (value.isNotEmpty) {
      if (value!.startsWith("http")) {
        return Container(
          padding: widget.dense
              ? const EdgeInsets.all(0)
              : const EdgeInsets.symmetric(vertical: 10),
          constraints: BoxConstraints.expand(
              height: errorText.isNotEmpty
                  ? (widget.height - FormItemMedia.errorTextHeight)
                  : widget.height),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.dense ? 0 : 8.0),
            child: _showMediaFromPath(value),
          ),
        );
      } else {
        _local ??= File(value);
        return Container(
          padding: widget.dense
              ? const EdgeInsets.all(0)
              : const EdgeInsets.symmetric(vertical: 10),
          constraints: BoxConstraints.expand(
              height: errorText.isNotEmpty
                  ? (widget.height - FormItemMedia.errorTextHeight)
                  : widget.height),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.dense ? 0 : 8.0),
            child: _showMediaFromFile(_local!),
          ),
        );
      }
    } else {
      return Container(
        padding: widget.dense
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          constraints: BoxConstraints.expand(
              height: errorText.isNotEmpty
                  ? (widget.height - FormItemMedia.errorTextHeight)
                  : widget.height),
          decoration: BoxDecoration(
              border: Border.all(
                  color: widget.color ?? Theme.of(context).disabledColor,
                  style: widget.dense ? BorderStyle.none : BorderStyle.solid),
              borderRadius: BorderRadius.circular(8.0)),
          child: Icon(widget.icon,
              size: 56, color: widget.color ?? Theme.of(context).disabledColor),
        ),
      );
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController?.text != value) {
      _effectiveController?.text = value ?? "";
    }
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController?.text = widget.initialValue ?? "";
    });
  }

  void _handleControllerChanged() {
    if (_effectiveController?.text != value) {
      didChange(_effectiveController?.text);
    }
  }
}

/// Media type.
enum FormItemMediaType {
  /// Both.
  both,

  /// Image.
  image,

  /// Video.
  video
}

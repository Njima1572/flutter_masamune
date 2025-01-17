part of masamune.media.others;

/// Model for retrieving local images and videos and getting them with [LocalMedia].
///
/// Images and video are acquired separately.
///
/// ```
/// final media = read(localMediaProvider("test.jpg")).image();
/// if(media == null) return;
/// ```
///
/// ```
/// final media = read(localMediaProvider("test.jpg")).video();
/// if(media == null) return;
/// ```
final localMediaProvider =
    ChangeNotifierProvider.family<LocalMediaModel, String>(
  (_, path) => LocalMediaModel(path),
);

/// Model for retrieving local images and videos and getting them with [LocalMedia].
///
/// Images and video are acquired separately.
///
/// ```
/// final media = read(localMediaProvider("test.jpg")).image();
/// if(media == null) return;
/// ```
///
/// ```
/// final media = read(localMediaProvider("test.jpg")).video();
/// if(media == null) return;
/// ```
class LocalMediaModel extends ValueModel<LocalMedia> {
  /// Model for retrieving local images and videos and getting them with [LocalMedia].
  ///
  /// Images and video are acquired separately.
  ///
  /// ```
  /// final media = read(localMediaProvider("test.jpg")).image();
  /// if(media == null) return;
  /// ```
  ///
  /// ```
  /// final media = read(localMediaProvider("test.jpg")).video();
  /// if(media == null) return;
  /// ```
  LocalMediaModel(this.path) : super(const LocalMedia());

  /// Media Path.
  final String path;
  final ImagePicker _picker = ImagePicker();

  Future<LocalMedia> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null || pickedFile.path.isEmpty) {
      throw Exception("The file was not found.");
    }
    return value =
        LocalMedia(path: pickedFile.path, assetType: AssetType.image);
  }

  Future<LocalMedia> _pickVideo(ImageSource source) async {
    final pickedFile = await _picker.pickVideo(source: source);
    if (pickedFile == null || pickedFile.path.isEmpty) {
      throw Exception("The file was not found.");
    }
    return value =
        LocalMedia(path: pickedFile.path, assetType: AssetType.video);
  }

  /// Get image from camera or library.
  ///
  /// Specify [source] to specify where to get the data from.
  Future<LocalMedia> image({ImageSource source = ImageSource.camera}) async {
    assert(path.isNotEmpty, "The path is invalid.");
    final media = await _pickImage(source);
    return media;
  }

  /// Get video from camera or library.
  ///
  /// Specify [source] to specify where to get the data from.
  Future<LocalMedia> video({ImageSource source = ImageSource.camera}) async {
    assert(path.isNotEmpty, "The path is invalid.");
    return value = await _pickVideo(source);
  }

  /// Delete the file.
  Future<void> delete() async {
    value = const LocalMedia();
  }

  /// Get image from camera or library by path.
  Future<LocalMedia> loadImage() async {
    assert(path.isNotEmpty, "The path is invalid.");
    return value = LocalMedia(path: path, assetType: AssetType.image);
  }

  /// Get video from camera or library by path.
  Future<LocalMedia> loadVideo() async {
    assert(path.isNotEmpty, "The path is invalid.");
    return value = LocalMedia(path: path, assetType: AssetType.image);
  }
}

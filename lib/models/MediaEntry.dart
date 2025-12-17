class MediaEntry {
  MediaEntry({required this.path});

  final String path;

  String get title {
    final normalized = path.replaceAll('\\', '/');
    final idx = normalized.lastIndexOf('/');
    return idx >= 0 ? normalized.substring(idx + 1) : normalized;
  }
}

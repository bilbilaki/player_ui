part of '../ui/player_home_page.dart';

class _ToggleIntent extends Intent {
  const _ToggleIntent();
}

class _SeekIntent extends Intent {
  const _SeekIntent(this.delta);
  final Duration delta;
}

class _OpenFilesIntent extends Intent {
  const _OpenFilesIntent();
}

class _OpenFolderIntent extends Intent {
  const _OpenFolderIntent();
}

class _PrevIntent extends Intent {
  const _PrevIntent();
}

class _NextIntent extends Intent {
  const _NextIntent();
}

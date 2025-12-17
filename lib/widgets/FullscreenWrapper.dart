part of '../ui/player_home_page.dart';

/// Wraps the video player with fullscreen capabilities and animated UI hiding
class _FullscreenWrapper extends StatelessWidget {
  final Widget child;
  final FullscreenState fullscreenState;
  final VoidCallback onToggleFullscreen;

  const _FullscreenWrapper({
    required this.child,
    required this.fullscreenState,
    required this.onToggleFullscreen,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: fullscreenState,
      builder: (context, _) {
        if (!fullscreenState.isFullscreen) {
          return child;
        }

        return GestureDetector(
          onTap: () {
            fullscreenState.toggleControlsVisibility();
          },
          child: Stack(
            children: [
              Positioned.fill(child: child),
              // Top controls overlay (animated)
              AnimatedPositioned(
                duration: FullscreenState.controlsShowAnimationDuration,
                top: fullscreenState.controlsVisible ? 0 : -80,
                left: 0,
                right: 0,
                child: _TopControlsOverlay(
                  onToggleFullscreen: onToggleFullscreen,
                ),
              ),
              // Bottom controls overlay (animated)
              AnimatedPositioned(
                duration: FullscreenState.controlsShowAnimationDuration,
                bottom: fullscreenState.controlsVisible ? 0 : -120,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black87,
                  child: const SizedBox(height: 120, width: double.infinity),
                ),
              ),
              // Show hint when hovering over hidden areas
              if (!fullscreenState.controlsVisible)
                Positioned.fill(
                  child: MouseRegion(
                    onEnter: (_) {
                      fullscreenState.onUserInteraction();
                    },
                    child: const SizedBox.expand(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Top controls overlay shown in fullscreen mode
class _TopControlsOverlay extends StatelessWidget {
  final VoidCallback onToggleFullscreen;

  const _TopControlsOverlay({required this.onToggleFullscreen});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black87, Colors.black54, Colors.transparent],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.fullscreen, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Fullscreen Mode',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
              onPressed: onToggleFullscreen,
              tooltip: 'Exit Fullscreen',
            ),
          ],
        ),
      ),
    );
  }
}

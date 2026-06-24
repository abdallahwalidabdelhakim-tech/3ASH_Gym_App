import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';
import '../../core/models/exercise.dart';

/// Screen for displaying detailed information about an exercise
/// 
/// Shows exercise video, images, instructions, and other relevant details
class ExerciseDetailScreen extends StatefulWidget {

  const ExerciseDetailScreen({super.key, required this.exercise});
  final Exercise exercise;

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  /// Initializes video player controller based on video URL type
  Future<void> _initializePlayer() async {
    if (widget.exercise.videoUrl == null) return;

    try {
      final url = widget.exercise.videoUrl!;
      if (url.startsWith('http')) {
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
      } else if (url.startsWith('assets')) {
         _videoPlayerController = VideoPlayerController.asset(url);
      } else {
        // Assume file path if not http or assets (though less likely in this context)
        _videoPlayerController = VideoPlayerController.file(File(url));
      }

      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: true,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        placeholder: const Center(child: CircularProgressIndicator()),
        errorBuilder: (context, errorMessage) {
          return const Center(
            child: Text(
              'Error loading video',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      );

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video player: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colors from design
    const backgroundColor = Color(0xFF1C1C1E);
    const cardColor = Color(0xFF2C2C2E);
    const neonGreen = Color(0xFFD0FD3E);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Image/Video Section
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.black, // Dark background for video
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: neonGreen.withValues(alpha:0.5), width: 1), 
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11), // Match border radius
                  child: _isVideoInitialized && _chewieController != null
                      ? Chewie(controller: _chewieController!)
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: widget.exercise.mainImageUrl != null
                                  ? Image.asset(
                                      widget.exercise.mainImageUrl!,
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                    )
                                  : const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                            ),
                            if (widget.exercise.videoUrl != null && !_isVideoInitialized)
                              const Center(child: CircularProgressIndicator(color: neonGreen)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Horizontal Gallery
              if (widget.exercise.galleryImages.isNotEmpty)
                SizedBox(
                  height: 150, // Reduced height for gallery
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.exercise.galleryImages.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 25),
                    itemBuilder: (context, index) {
                      return Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            widget.exercise.galleryImages[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported, size: 20, color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
              if (widget.exercise.galleryImages.isNotEmpty) const SizedBox(height: 24),

              // Exercise Title
              Text(
                widget.exercise.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 16),

              // Instructions Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'INSTRUCTIONS',
                      style: TextStyle(
                        color: neonGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(widget.exercise.instructions.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD0FD3E).withValues(alpha:0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: neonGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.exercise.instructions[index],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

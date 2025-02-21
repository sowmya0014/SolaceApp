import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'interests_screen.dart';

class FaceRecognitionScreen extends StatefulWidget {
  final String username;
  final String password;

  const FaceRecognitionScreen({
    super.key,
    required this.username,
    required this.password,
  });

  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  Future<void> _captureImage() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (photo != null) {
        setState(() {
          _imageFile = File(photo.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error capturing image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _processFaceRecognition() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture your face first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Simulate face recognition processing
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Face registration successful!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to profile selection after successful face recognition
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InterestsScreen(
              username: widget.username,
              password: widget.password,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Face recognition failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Recognition'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Face Registration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Please position your face within the frame and ensure good lighting',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isProcessing
                  ? const Center(child: CircularProgressIndicator())
                  : _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.face,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _captureImage,
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Capture Face'),
                            ),
                          ],
                        ),
            ),
            const SizedBox(height: 30),
            if (_imageFile != null)
              ElevatedButton(
                onPressed: _processFaceRecognition,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Register Face',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Your facial data will be securely stored and used only for authentication purposes.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
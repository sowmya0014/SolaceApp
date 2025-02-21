  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart';
  import 'dart:io';
  import 'face_recognition_screen.dart';

  class IdVerificationScreen extends StatefulWidget {
    final String username;
    final String email;
    final String password;

    const IdVerificationScreen({
      super.key,
      required this.username,
      required this.email,
      required this.password,
    });

    @override
    _IdVerificationScreenState createState() => _IdVerificationScreenState();
  }

  class _IdVerificationScreenState extends State<IdVerificationScreen> {
    String? _selectedIdType;
    bool _isUploading = false;
    bool _uploadComplete = false;
    File? _imageFile;
    final ImagePicker _picker = ImagePicker();

    final List<String> _idTypes = [
      'Passport',
      'Driver\'s License',
      'National ID Card',
      'Other Government ID'
    ];

    Future<void> _getImage(ImageSource source) async {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 1800,
          maxHeight: 1800,
        );

        if (pickedFile != null) {
          setState(() {
            _imageFile = File(pickedFile.path);
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error picking image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    void _showImageSourceDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Choose Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    Future<void> _uploadImage() async {
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image first'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isUploading = true;
      });

      try {
        // Simulate upload process
        await Future.delayed(const Duration(seconds: 2));

        setState(() {
          _isUploading = false;
          _uploadComplete = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ID verification successful!'),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          // Updated navigation to go to FaceRecognitionScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FaceRecognitionScreen(
                username: widget.username,
                password: widget.password,
              ),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error uploading image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ID Verification'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Please verify your identity',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Upload a clear photo of your government-issued ID',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              DropdownButtonFormField<String>(
                value: _selectedIdType,
                decoration: const InputDecoration(
                  labelText: 'Select ID Type',
                  border: OutlineInputBorder(),
                ),
                items: _idTypes.map((String type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedIdType = newValue;
                  });
                },
              ),
              const SizedBox(height: 30),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _isUploading
                    ? const Center(child: CircularProgressIndicator())
                    : _imageFile != null
                        ? Stack(
                            children: [
                              Image.file(
                                _imageFile!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.contain,
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _imageFile = null;
                                    });
                                  },
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.upload_file,
                                size: 50,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: _selectedIdType != null
                                    ? _showImageSourceDialog
                                    : null,
                                child: const Text('Upload ID Document'),
                              ),
                            ],
                          ),
              ),
              const SizedBox(height: 20),
              if (_imageFile != null)
                ElevatedButton(
                  onPressed: _uploadImage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Submit for Verification',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              const SizedBox(height: 20),
              const Text(
                'Note: Your ID will be securely stored and used only for verification purposes.',
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
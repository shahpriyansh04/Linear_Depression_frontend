import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_gemma/flutter_gemma.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isGenerating = false;
  Timer? _generationTimer;
  bool _showPrompts = true;
  final _gemma = FlutterGemmaPlugin.instance;
  bool _isModelLoaded = false;
  StreamSubscription<String?>? _generationSubscription;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      // Load the model from assets
      await _gemma.loadAssetModel(fullPath: 'model.bin');

      // Initialize FlutterGemmaPlugin
      await _gemma.init(
        maxTokens: 256,
        temperature: 0.7,
        topK: 3,
        randomSeed: 1,
      );

      setState(() {
        _isModelLoaded = true; // Set the flag to true
      });

      debugPrint('Model loaded and plugin initialized successfully.');
    } catch (e) {
      debugPrint('Error initializing model: $e');
      // Optionally, show an error message to the user
    }
  }

  final List<PromptButton> _promptButtons = [
    PromptButton(
      icon: Icons.calculate,
      label: 'Solve math problem',
      prompt: 'Can you help me solve this math problem?',
    ),
    PromptButton(
      icon: Icons.science,
      label: 'Explain a concept',
      prompt: 'Can you explain this scientific concept?',
    ),
    PromptButton(
      icon: Icons.book,
      label: 'Recommend books',
      prompt: 'Can you recommend some books on this topic?',
    ),
    PromptButton(
      icon: Icons.checklist,
      label: 'Create checklist',
      prompt: 'Can you help me create a checklist for my tasks?',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _generationTimer?.cancel();
    super.dispose();
  }

  void _handleSubmit(String text) {
    if (text.isEmpty || _isGenerating) return;

    setState(() {
      _showPrompts = false;
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
      ));
      _controller.clear();
      // _isGenerating = true;
    });

    // _messages.add(ChatMessage(
    //   text: '...',
    //   isUser: false,
    //   isLoading: true,
    // ));

    // Use the Gemma model to generate a response
    _generateResponse(text);
  }

  Future<void> _generateResponse(String prompt) async {
    if (!_isModelLoaded) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Model is still loading. Please wait a moment.',
          isUser: false,
        ));
      });
      return;
    }

    if (_isGenerating) {
      // Optional: Notify the user or handle accordingly
      return;
    }

    try {
      // Add a loading indicator message
      setState(() {
        _messages.add(ChatMessage(
          text: '',
          isUser: false,
          isLoading: true,
        ));
        _isGenerating = true;
      });

      final flutterGemma = FlutterGemmaPlugin.instance;
      final buffer = StringBuffer(); // For accumulating response tokens

      // Fetch the response tokens from FlutterGemma in real-time
      _generationSubscription =
          flutterGemma.getResponseAsync(prompt: prompt).listen(
        (String? token) {
          if (token != null) {
            print('Received token: $token');
            buffer.write(token); // Append token to the buffer

            setState(() {
              // Update the loading message with the accumulated response
              final lastMessageIndex = _messages.length - 1;
              if (_messages[lastMessageIndex].isLoading) {
                _messages[lastMessageIndex] = ChatMessage(
                  text: buffer.toString().trim(),
                  isUser: false,
                  isLoading: true, // Keep showing the loading indicator
                );
              }
            });
          } else {
            print('Received null token');
          }
        },
        onDone: () {
          print('Response generation completed');
          print(buffer.toString().trim());
          // Replace the loading message with the final response
          setState(() {
            final lastMessageIndex = _messages.length - 1;
            if (_messages[lastMessageIndex].isLoading) {
              _messages[lastMessageIndex] = ChatMessage(
                text: buffer.toString().trim(),
                isUser: false,
                isLoading: false,
              );
            }
            _isGenerating = false; // Set to false here
            _generationSubscription = null; // Clear subscription
          });
        },
        onError: (error) {
          debugPrint('Error generating response: $error');
          setState(() {
            _messages.removeLast(); // Remove the loading message
            _messages.add(ChatMessage(
              text: 'Sorry, something went wrong. Please try again.',
              isUser: false,
            ));
            _isGenerating = false;
            _generationSubscription = null; // Clear subscription
          });
        },
      );
    } catch (e) {
      debugPrint('Error generating response: $e');
      setState(() {
        _messages.removeLast(); // Remove the loading message
        _messages.add(ChatMessage(
          text: 'Sorry, something went wrong. Please try again.',
          isUser: false,
        ));
        _isGenerating = false;
        _generationSubscription = null; // Clear subscription
      });
    }
  }

  void _handlePromptButton(String prompt) {
    _controller.text = prompt;
    _handleSubmit(prompt);
  }

  void _stopGenerating() {
    _generationSubscription?.cancel();
    _generationSubscription = null;
    setState(() {
      if (_isGenerating) {
        _isGenerating = false;
        // Update the last message to stop loading indicator
        final lastMessageIndex = _messages.length - 1;
        if (_messages[lastMessageIndex].isLoading) {
          _messages[lastMessageIndex] = ChatMessage(
            text: _messages[lastMessageIndex].text, // Keep the text
            isUser: false,
            isLoading: false, // Stop the loading indicator
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isModelLoaded) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F0EC),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F0EC),
          elevation: 0,
          title: const Text(
            'DoubtBot',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading model, please wait...'),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F0EC), // Cream background color
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F0EC),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'DoubtBot',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _messages.isEmpty && _showPrompts
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'What can I help you with?',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: _promptButtons.map((button) {
                              return SizedBox(
                                width: 150,
                                child: ElevatedButton.icon(
                                  icon: Icon(button.icon, size: 18),
                                  label: Text(button.label),
                                  onPressed: () =>
                                      _handlePromptButton(button.prompt),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black87,
                                    elevation: 1,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) => _messages[index],
                    ),
            ),
            if (_isGenerating)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton(
                  onPressed: _stopGenerating,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Stop Generating'),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_isGenerating,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      onSubmitted: !_isGenerating
                          ? _handleSubmit
                          : null, // Disable submission
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: !_isGenerating
                        ? () => _handleSubmit(_controller.text)
                        : null,
                    color: !_isGenerating
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey, // Change color when disabled
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

class PromptButton {
  final IconData icon;
  final String label;
  final String prompt;

  const PromptButton({
    required this.icon,
    required this.label,
    required this.prompt,
  });
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isLoading;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    this.isLoading = false,
  });

  Widget _buildFormattedText(String text) {
    final List<InlineSpan> spans = [];
    String currentText = '';
    bool isBold = false;
    bool isMath = false;
    bool isUser = false;    

    for (int i = 0; i < text.length; i++) {
      if (i + 1 < text.length) {
        // Check for bold markers
        if (text[i] == '*' && text[i + 1] == '*') {
          if (currentText.isNotEmpty) {
            spans.add(TextSpan(
              text: currentText,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ));
            currentText = '';
          }
          isBold = !isBold;
          i++; // Skip the second *
          continue;
        }

        // Check for math markers
        if (text[i] == '\$' && text[i + 1] == '\$') {
          if (currentText.isNotEmpty) {
            spans.add(TextSpan(
              text: currentText,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ));
            currentText = '';
          }
          isMath = !isMath;
          i++; // Skip the second $
          continue;
        }
      }

      currentText += text[i];
    }

    // Add any remaining text
    if (currentText.isNotEmpty) {
      spans.add(TextSpan(
        text: currentText,
        style: TextStyle(
          color: isUser ? Colors.white : Colors.black87,
          fontSize: 16,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontFamily: isMath ? 'Courier' : null, // Use monospace font for math
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(context),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color:
                    isUser ? const Color(0xFF65432D) : const Color(0xFFF5F0EC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormattedText(text), // Using the formatted text
                  if (isLoading) ...[
                    const SizedBox(height: 8),
                    _buildLoadingIndicator(),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildAvatar(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isUser ? const Color(0xFF9CB380) : const Color(0xFFE8A87C),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.psychology,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      width: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _LoadingDot(delay: 0),
          _LoadingDot(delay: 1),
          _LoadingDot(delay: 2),
        ],
      ),
    );
  }
}

class _LoadingDot extends StatefulWidget {
  final int delay;

  const _LoadingDot({required this.delay});

  @override
  _LoadingDotState createState() => _LoadingDotState();
}

class _LoadingDotState extends State<_LoadingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
    Future.delayed(Duration(milliseconds: widget.delay * 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -3 * _controller.value),
          child: const Text(
            '.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

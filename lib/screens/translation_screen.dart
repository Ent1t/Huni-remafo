import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../utils/app_colors.dart';
import '../services/audio_service.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  String _selectedSourceLanguage = 'English';
  String _selectedTargetLanguage = 'Ata Manobo';
  
  late AudioService _audioService;
  String? currentlyPlayingPhrase;
  bool isPlaying = false;

  final List<String> _sourceLanguages = ['English', 'Cebuano'];
  final List<String> _targetLanguages = ['Ata Manobo', 'Mansaka', 'Mandaya'];

  // Language codes for TTS
  final Map<String, String> _languageCodes = {
    'English': 'en-US',
    'Cebuano': 'fil-PH', // Filipino as closest approximation
    'Ata Manobo': 'fil-PH',
    'Mansaka': 'fil-PH',
    'Mandaya': 'fil-PH',
  };

  final Map<String, Map<String, Map<String, String>>> _phrases = {
    'Greetings': {
      'Hello': {
        'English': 'Hello',
        'Cebuano': 'Kumusta',
        'Ata Manobo': 'Maayong adlaw',
        'Mansaka': 'Maayong adlaw',
        'Mandaya': 'Maayong adlaw',
      },
      'Good morning': {
        'English': 'Good morning',
        'Cebuano': 'Maayong buntag',
        'Ata Manobo': 'Maayong ugma',
        'Mansaka': 'Maayong ugma',
        'Mandaya': 'Maayong ugma',
      },
      'Good afternoon': {
        'English': 'Good afternoon',
        'Cebuano': 'Maayong hapon',
        'Ata Manobo': 'Maayong hapon',
        'Mansaka': 'Maayong hapon',
        'Mandaya': 'Maayong hapon',
      },
      'Good evening': {
        'English': 'Good evening',
        'Cebuano': 'Maayong gabii',
        'Ata Manobo': 'Maayong gabii',
        'Mansaka': 'Maayong gabii',
        'Mandaya': 'Maayong gabii',
      },
      'Goodbye': {
        'English': 'Goodbye',
        'Cebuano': 'Paalam',
        'Ata Manobo': 'Paalam',
        'Mansaka': 'Paalam',
        'Mandaya': 'Paalam',
      },
    },
    'Basic Phrases': {
      'Thank you': {
        'English': 'Thank you',
        'Cebuano': 'Salamat',
        'Ata Manobo': 'Salamat',
        'Mansaka': 'Salamat',
        'Mandaya': 'Salamat',
      },
      'Please': {
        'English': 'Please',
        'Cebuano': 'Palihog',
        'Ata Manobo': 'Palihog',
        'Mansaka': 'Palihog',
        'Mandaya': 'Palihog',
      },
      'Excuse me': {
        'English': 'Excuse me',
        'Cebuano': 'Pasayloa ko',
        'Ata Manobo': 'Pasayloa ko',
        'Mansaka': 'Pasayloa ko',
        'Mandaya': 'Pasayloa ko',
      },
      'I\'m sorry': {
        'English': 'I\'m sorry',
        'Cebuano': 'Pasaylo',
        'Ata Manobo': 'Pasaylo',
        'Mansaka': 'Pasaylo',
        'Mandaya': 'Pasaylo',
      },
      'Yes': {
        'English': 'Yes',
        'Cebuano': 'Oo',
        'Ata Manobo': 'Oo',
        'Mansaka': 'Oo',
        'Mandaya': 'Oo',
      },
      'No': {
        'English': 'No',
        'Cebuano': 'Dili',
        'Ata Manobo': 'Dili',
        'Mansaka': 'Dili',
        'Mandaya': 'Dili',
      },
    },
    'Questions': {
      'How are you?': {
        'English': 'How are you?',
        'Cebuano': 'Kumusta ka?',
        'Ata Manobo': 'Kumusta ka?',
        'Mansaka': 'Kumusta ka?',
        'Mandaya': 'Kumusta ka?',
      },
      'What is your name?': {
        'English': 'What is your name?',
        'Cebuano': 'Unsa imong ngalan?',
        'Ata Manobo': 'Unu ngaran mo?',
        'Mansaka': 'Unu ngaran mo?',
        'Mandaya': 'Unu ngaran mo?',
      },
      'Where are you from?': {
        'English': 'Where are you from?',
        'Cebuano': 'Asa ka gikan?',
        'Ata Manobo': 'Hain ka naggikan?',
        'Mansaka': 'Hain ka naggikan?',
        'Mandaya': 'Hain ka naggikan?',
      },
      'How much is this?': {
        'English': 'How much is this?',
        'Cebuano': 'Pila ni?',
        'Ata Manobo': 'Pila ini?',
        'Mansaka': 'Pila ini?',
        'Mandaya': 'Pila ini?',
      },
    },
  };

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _initializeAudio();
  }

  void _initializeAudio() async {
    await _audioService.initialize();
  }

  Future<void> _speakText(String text, String language, String phraseKey) async {
    try {
      setState(() {
        currentlyPlayingPhrase = phraseKey;
        isPlaying = true;
      });

      bool success = await _audioService.playPhrase(
        text: text,
        language: language,
        phraseKey: phraseKey,
      );

      if (!success) {
        setState(() {
          currentlyPlayingPhrase = null;
          isPlaying = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to play audio'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }

      // Haptic feedback
      HapticFeedback.lightImpact();
      
      // Auto-update playing status
      _updatePlayingStatus();
      
    } catch (e) {
      print('Error playing audio: $e');
      setState(() {
        currentlyPlayingPhrase = null;
        isPlaying = false;
      });
    }
  }

  void _updatePlayingStatus() {
    // Check playing status every second
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _audioService.currentlyPlaying != currentlyPlayingPhrase) {
        setState(() {
          currentlyPlayingPhrase = _audioService.currentlyPlaying;
          isPlaying = _audioService.isPlaying;
        });
        
        if (isPlaying) {
          _updatePlayingStatus(); // Continue checking
        }
      }
    });
  }

  Future<void> _stopAudio() async {
    await _audioService.stopAudio();
    setState(() {
      currentlyPlayingPhrase = null;
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phrase Book'),
        centerTitle: true,
        actions: [
          if (isPlaying)
            IconButton(
              onPressed: _stopAudio,
              icon: const Icon(Icons.stop),
              color: AppColors.error,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selection Section
            _buildLanguageSelectionSection(),
            
            const SizedBox(height: 32.0),
            
            // Audio Status Indicator
            if (isPlaying) _buildAudioStatusIndicator(),
            
            Text(
              'Common Phrases',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16.0),
            
            // Phrase Categories
            ..._phrases.entries.map((categoryEntry) {
              return _buildCategorySection(categoryEntry);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Language Selection',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16.0),
        
        // Source Language Dropdown
        _buildLanguageDropdown(
          value: _selectedSourceLanguage,
          items: _sourceLanguages,
          hint: 'Select source language',
          onChanged: (value) {
            setState(() {
              _selectedSourceLanguage = value!;
            });
          },
        ),
        
        const SizedBox(height: 12.0),
        
        // Swap languages button
        Center(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              // Only swap if target language is available as source
              if (_sourceLanguages.contains(_selectedTargetLanguage)) {
                setState(() {
                  String temp = _selectedSourceLanguage;
                  _selectedSourceLanguage = _selectedTargetLanguage;
                  _selectedTargetLanguage = temp;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.tribalGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.tribalGold.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.swap_vert,
                color: AppColors.tribalGold,
                size: 24,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12.0),
        
        // Target Language Dropdown
        _buildLanguageDropdown(
          value: _selectedTargetLanguage,
          items: _targetLanguages,
          hint: 'Select target language',
          onChanged: (value) {
            setState(() {
              _selectedTargetLanguage = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildLanguageDropdown({
    required String value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppColors.boneChilling,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppColors.murmur,
          width: 1.0,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items.map((String language) {
            return DropdownMenuItem<String>(
              value: language,
              child: Text(language),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildAudioStatusIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.tribalGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.tribalGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.tribalGold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Playing: ${currentlyPlayingPhrase ?? 'Audio'}',
              style: const TextStyle(
                color: AppColors.tribalGold,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: _stopAudio,
            child: const Icon(
              Icons.stop,
              color: AppColors.tribalGold,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(MapEntry<String, Map<String, Map<String, String>>> categoryEntry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(
                _getCategoryIcon(categoryEntry.key),
                color: AppColors.tribalGold,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                categoryEntry.key,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.tribalGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        
        // Phrases in Category
        ...categoryEntry.value.entries.map((phraseEntry) {
          return _buildPhraseCard(phraseEntry);
        }),
        
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildPhraseCard(MapEntry<String, Map<String, String>> phraseEntry) {
    final sourceText = phraseEntry.value[_selectedSourceLanguage] ?? phraseEntry.key;
    final targetText = phraseEntry.value[_selectedTargetLanguage] ?? phraseEntry.key;
    final phraseKey = phraseEntry.key;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: AppColors.sparklingSnow,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppColors.murmur,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Source phrase
          _buildPhraseRow(
            language: _selectedSourceLanguage,
            text: sourceText,
            phraseKey: phraseKey,
            isSource: true,
            textColor: AppColors.lavaStone,
          ),
          
          Divider(
            color: AppColors.murmur.withOpacity(0.3),
            height: 1,
          ),
          
          // Target phrase
          _buildPhraseRow(
            language: _selectedTargetLanguage,
            text: targetText,
            phraseKey: phraseKey,
            isSource: false,
            textColor: AppColors.terrestrial,
          ),
        ],
      ),
    );
  }

  Widget _buildPhraseRow({
    required String language,
    required String text,
    required String phraseKey,
    required bool isSource,
    required Color textColor,
  }) {
    final isCurrentlyPlaying = currentlyPlayingPhrase == '${phraseKey}_$language';
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: AppColors.murmur,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: textColor,
                    fontWeight: isSource ? FontWeight.w500 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Play/Stop button
          GestureDetector(
            onTap: () {
              if (isCurrentlyPlaying) {
                _stopAudio();
              } else {
                _speakText(text, language, '${phraseKey}_$language');
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isCurrentlyPlaying 
                    ? AppColors.error.withOpacity(0.1)
                    : textColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isCurrentlyPlaying
                    ? const Icon(
                        Icons.stop,
                        color: AppColors.error,
                        size: 24,
                        key: ValueKey('stop'),
                      )
                    : Icon(
                        isSource ? Icons.play_circle_outline : Icons.play_circle_filled,
                        color: textColor,
                        size: 24,
                        key: const ValueKey('play'),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'greetings':
        return Icons.waving_hand;
      case 'basic phrases':
        return Icons.chat_bubble_outline;
      case 'questions':
        return Icons.help_outline;
      case 'numbers':
        return Icons.numbers;
      case 'food':
        return Icons.restaurant;
      case 'directions':
        return Icons.directions;
      default:
        return Icons.translate;
    }
  }
}
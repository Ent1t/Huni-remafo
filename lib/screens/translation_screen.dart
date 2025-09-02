import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  String _selectedSourceLanguage = 'English';
  String _selectedTargetLanguage = 'Ata Manobo';

  final List<String> _sourceLanguages = ['English', 'Cebuano'];
  final List<String> _targetLanguages = ['Ata Manobo', 'Mansaka', 'Mandaya'];

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
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phrase Book'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selection Section
            Text(
              'Language Selection',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16.0),
            
            // Source Language Dropdown
            Container(
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
                  value: _selectedSourceLanguage,
                  hint: const Text('Select source language'),
                  isExpanded: true,
                  items: _sourceLanguages.map((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedSourceLanguage = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 12.0),
            
            // Target Language Dropdown
            Container(
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
                  value: _selectedTargetLanguage,
                  hint: const Text('Select target language'),
                  isExpanded: true,
                  items: _targetLanguages.map((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedTargetLanguage = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 32.0),
            
            Text(
              'Common Phrases',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16.0),
            
            // Phrase Categories
            ..._phrases.entries.map((categoryEntry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      categoryEntry.key,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.terrestrial,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  // Phrases in Category
                  ...categoryEntry.value.entries.map((phraseEntry) {
                    final sourceText = phraseEntry.value[_selectedSourceLanguage] ?? phraseEntry.key;
                    final targetText = phraseEntry.value[_selectedTargetLanguage] ?? phraseEntry.key;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColors.sparklingSnow,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: AppColors.murmur,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Source phrase
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedSourceLanguage,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: AppColors.murmur,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      sourceText,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: AppColors.lavaStone,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Play button for source
                              IconButton(
                                onPressed: () {
                                  // TODO: Implement audio playback for source phrase
                                  print('Playing: $sourceText');
                                },
                                icon: const Icon(
                                  Icons.play_circle_outline,
                                  color: AppColors.evergreen,
                                  size: 28.0,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 12.0),
                          
                          // Target phrase
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedTargetLanguage,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: AppColors.murmur,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      targetText,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: AppColors.terrestrial,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Play button for target
                              IconButton(
                                onPressed: () {
                                  // TODO: Implement audio playback for target phrase
                                  print('Playing: $targetText');
                                },
                                icon: const Icon(
                                  Icons.play_circle_filled,
                                  color: AppColors.terrestrial,
                                  size: 28.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  
                  const SizedBox(height: 16.0),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

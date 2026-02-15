// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_app_is_initialized.dart';
import './step/the_vosk_model_for_english_is_loaded.dart';
import './step/i_tap_the_start_recording_button.dart';
import './step/i_speak_hello_how_are_you.dart';
import './step/i_should_see_the_text_hello_how_are_you_on_the_screen.dart';
import './step/i_am_currently_recording.dart';
import './step/i_tap_the_stop_recording_button.dart';
import './step/the_recording_should_stop.dart';
import './step/a_new_transcript_should_be_saved_in_the_history.dart';

void main() {
  group('''Offline Speech to Text''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await theAppIsInitialized(tester);
      await theVoskModelForEnglishIsLoaded(tester);
    }

    testWidgets('''Basic Real-time Transcription''', (tester) async {
      await bddSetUp(tester);
      await iTapTheStartRecordingButton(tester);
      await iSpeakHelloHowAreYou(tester);
      await iShouldSeeTheTextHelloHowAreYouOnTheScreen(tester);
    });
    testWidgets('''Stopping Transcription''', (tester) async {
      await bddSetUp(tester);
      await iAmCurrentlyRecording(tester);
      await iTapTheStopRecordingButton(tester);
      await theRecordingShouldStop(tester);
      await aNewTranscriptShouldBeSavedInTheHistory(tester);
    });
  });
}

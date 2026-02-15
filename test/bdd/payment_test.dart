// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:bdd_widget_test/data_table.dart' as bdd;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_app_is_running.dart';
import './step/i_am_on_the_premium_features_screen.dart';
import './step/i_tap_upgrade_now_button.dart';
import './step/i_select_easypaisa_payment_method.dart';
import './step/i_enter03451234567_as_mobile_number.dart';
import './step/i_tap_pay_button.dart';
import './step/i_should_see_a_success_message.dart';
import './step/the_transaction_should_be_completed.dart';
import './step/i_select_bank_card_payment_method.dart';
import './step/i_enter_card_details.dart';

void main() {
  group('''Payment Integration''', () {
    testWidgets('''User pays via EasyPaisa successfully''', (tester) async {
      await theAppIsRunning(tester);
      await iAmOnThePremiumFeaturesScreen(tester);
      await iTapUpgradeNowButton(tester);
      await iSelectEasypaisaPaymentMethod(tester);
      await iEnter03451234567AsMobileNumber(tester);
      await iTapPayButton(tester);
      await iShouldSeeASuccessMessage(tester);
      await theTransactionShouldBeCompleted(tester);
    });
    testWidgets('''User pays via Bank Card successfully''', (tester) async {
      await theAppIsRunning(tester);
      await iAmOnThePremiumFeaturesScreen(tester);
      await iTapUpgradeNowButton(tester);
      await iSelectBankCardPaymentMethod(tester);
      await iEnterCardDetails(
          tester,
          const bdd.DataTable([
            [number, expiry, cvv],
            [4242424242424242, 12 / 26, 123]
          ]));
      await iTapPayButton(tester);
      await iShouldSeeASuccessMessage(tester);
    });
  });
}

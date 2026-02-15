import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:echo_see_companion/core/constants/app_colors.dart';
import '../../../data/models/payment_method.dart';
import 'payment_details_screen.dart';

class PaymentSelectionScreen extends StatelessWidget {
  final double amount;

  const PaymentSelectionScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Payment Method'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTotalAmount(),
            const SizedBox(height: 30),
            const Text(
              'Select a payment method:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildPaymentOption(
              context,
              title: 'EasyPaisa',
              subtitle: 'Pay using mobile wallet',
              icon: FontAwesomeIcons.wallet,
              color: Colors.green,
              type: PaymentType.easyPaisa,
            ),
            _buildPaymentOption(
              context,
              title: 'JazzCash',
              subtitle: 'Pay using mobile wallet',
              icon: FontAwesomeIcons.mobileButton,
              color: Colors.orange,
              type: PaymentType.jazzCash,
            ),
            _buildPaymentOption(
              context,
              title: 'Bank Card',
              subtitle: 'Visa, Mastercard, etc.',
              icon: FontAwesomeIcons.creditCard,
              color: Colors.blue,
              type: PaymentType.bankCard,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAmount() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF1E3C72)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Total Amount',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'PKR ${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required PaymentType type,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentDetailsScreen(
                amount: amount,
                paymentType: type,
              ),
            ),
          );
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

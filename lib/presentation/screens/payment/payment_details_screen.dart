import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:echo_see_companion/core/constants/app_colors.dart';
import 'package:echo_see_companion/providers/auth_provider.dart';
import 'package:echo_see_companion/providers/payment_provider.dart';
import '../../../data/models/payment_method.dart';
import 'payment_success_screen.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final double amount;
  final PaymentType paymentType;

  const PaymentDetailsScreen({
    super.key,
    required this.amount,
    required this.paymentType,
  });

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.paymentType.name.toUpperCase()} Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter details for ${widget.paymentType.name}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              if (widget.paymentType == PaymentType.bankCard)
                _buildCardFields()
              else
                _buildWalletFields(),
              const SizedBox(height: 40),
              paymentProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () => _handlePayment(paymentProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Pay PKR ${widget.amount}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletFields() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Mobile Number',
        hintText: 'e.g. 03XXXXXXXXX',
        prefixIcon: Icon(Icons.phone),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter number';
        if (value.length < 11) return 'Invalid number format';
        return null;
      },
    );
  }

  Widget _buildCardFields() {
    return Column(
      children: [
        TextFormField(
          controller: _cardNumberController,
          decoration: const InputDecoration(
            labelText: 'Card Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.credit_card),
          ),
          keyboardType: TextInputType.number,
          validator: (value) => value == null || value.length < 16 ? 'Invalid Card' : null,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                decoration: const InputDecoration(
                  labelText: 'MM/YY',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.length < 3 ? 'Invalid' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handlePayment(PaymentProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    // Show persistent loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text(
              "Processing Payment...", 
              style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.none)
            ),
          ],
        ),
      ),
    );

    try {
      if (widget.paymentType == PaymentType.easyPaisa) {
        await provider.payWithEasyPaisa(_phoneController.text, widget.amount);
      } else if (widget.paymentType == PaymentType.jazzCash) {
        await provider.payWithJazzCash(_phoneController.text, widget.amount);
      } else {
        await provider.payWithCard(
          _cardNumberController.text,
          _expiryController.text,
          _cvvController.text,
          widget.amount,
        );
      }
      
      // Dismiss loading
      if (mounted) Navigator.pop(context);

      if (mounted && provider.lastResult != null && provider.lastResult!.success) {
        // Unlock premium instantly for the demo
        Provider.of<AuthProvider>(context, listen: false).enablePremiumAccess();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessScreen(
              result: provider.lastResult!,
              amount: widget.amount,
              paymentMethod: widget.paymentType.name.toUpperCase(),
            ),
          ),
        );
      } else if (mounted && provider.lastResult != null) {
         _showErrorDialog(context, provider.lastResult!.message);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Dismiss loading
      if (mounted) _showErrorDialog(context, "An unexpected error occurred: $e");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.error, color: Colors.red, size: 50),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yaladrive/core/theme/app_pallete.dart';
import 'package:yaladrive/features/payment/domain/entities/payment.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onMethodChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MethodOption(
                method: PaymentMethod.card,
                isSelected: selectedMethod == PaymentMethod.card,
                onTap: () => onMethodChanged(PaymentMethod.card),
                icon: Icons.credit_card,
                label: 'Card',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MethodOption(
                method: PaymentMethod.wallet,
                isSelected: selectedMethod == PaymentMethod.wallet,
                onTap: () => onMethodChanged(PaymentMethod.wallet),
                icon: Icons.account_balance_wallet,
                label: 'Wallet',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MethodOption(
                method: PaymentMethod.cash,
                isSelected: selectedMethod == PaymentMethod.cash,
                onTap: () => onMethodChanged(PaymentMethod.cash),
                icon: Icons.money,
                label: 'Cash',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MethodOption extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final String label;

  const _MethodOption({
    required this.method,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppPallete.gradient1.withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppPallete.gradient1 : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppPallete.gradient1 : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppPallete.gradient1 : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

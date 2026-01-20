import 'package:yaladrive/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerRevenue extends StatefulWidget {
  const OwnerRevenue({super.key});

  @override
  State<OwnerRevenue> createState() => _OwnerRevenueState();
}

class _OwnerRevenueState extends State<OwnerRevenue> {
  double totalRevenue = 0.0;
  List<Map<String, dynamic>> itemWiseRevenue = [];

  @override
  void initState() {
    super.initState();
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      fetchOwnerRevenue(userState.user.id);
    }
  }

  void fetchOwnerRevenue(String ownerId) async {
  try {
    final bookingsSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('ownerId', isEqualTo: ownerId)
        .where('status', isEqualTo: 'Confirmed')
        .where('paymentStatus', isEqualTo: 'Paid')
        .get();

    double revenue = 0.0;
    final itemWise = <String, double>{};

    for (var doc in bookingsSnapshot.docs) {
      final data = doc.data();
      final carNo = data['carNo'] as String;
      final price = (data['price'] ?? 0.0) as double;

      revenue += price;
      itemWise[carNo] = (itemWise[carNo] ?? 0.0) + price;
    }

    if (!mounted) return; 
    setState(() {
      totalRevenue = revenue;
      itemWiseRevenue = itemWise.entries
          .map((e) => {'item': e.key, 'revenue': e.value})
          .toList();
    });
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to fetch revenue: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revenue'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blueAccent,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Revenue',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${totalRevenue.toStringAsFixed(2)}TND',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Item-wise Revenue',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: itemWiseRevenue.length,
                itemBuilder: (context, index) {
                  final item = itemWiseRevenue[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        item['item'],
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: Text(
                        '${item['revenue'].toStringAsFixed(2)}TND',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

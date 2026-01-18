import 'package:car_rental_app_clean_arch/features/profile/presentation/widgets/help_option.dart';
import 'package:flutter/material.dart';

class CustomerHelp extends StatelessWidget {
  const CustomerHelp({super.key});

  void _showHelpBottomSheet(BuildContext context, String title, Widget content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              content,
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Get Help', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HelpOption(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: "Search a library of help articles",
              onTap: () {
                _showHelpBottomSheet(
                  context, 
                  "Help Center",
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Search for common issues:", style: TextStyle(fontWeight: FontWeight.bold)),
                      ListTile(
                        leading: Icon(Icons.article),
                        title: Text("How to book a car?"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.payment),
                        title: Text("Payment & refund policies"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.security),
                        title: Text("Safety guidelines for renters"),
                        onTap: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
            HelpOption(
              icon: Icons.phone,
              title: 'Contact Host',
              subtitle: 'Message or call your host',
              onTap: () {
                _showHelpBottomSheet(
                  context, 
                  "Contact Host",
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Reach out to your host:", style: TextStyle(fontWeight: FontWeight.bold)),
                      ListTile(
                        leading: Icon(Icons.message),
                        title: Text("Send a Message"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.call),
                        title: Text("Call Host"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text("Email Support"),
                        onTap: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
            HelpOption(
              icon: Icons.headset_mic,
              title: 'Contact Support',
              subtitle: 'Call or chat with support',
              onTap: () {
                _showHelpBottomSheet(
                  context, 
                  "Contact Support",
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Choose your preferred support option:", style: TextStyle(fontWeight: FontWeight.bold)),
                      ListTile(
                        leading: Icon(Icons.chat),
                        title: Text("Live Chat with Support"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.call),
                        title: Text("Call Customer Support"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.help),
                        title: Text("Submit a Support Ticket"),
                        onTap: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


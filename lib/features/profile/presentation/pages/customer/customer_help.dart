import 'package:yaladrive/features/profile/presentation/widgets/help_option.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerHelp extends StatelessWidget {
  const CustomerHelp({super.key});

  void _showHelpBottomSheet(
      BuildContext context, String title, Widget content) {
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
              Text(title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Request&body=Hello, I need help with...',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _openLiveChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LiveChatScreen(),
      ),
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
                      Text("Choose your preferred support option:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ListTile(
                        leading: Icon(Icons.chat, color: Colors.purple),
                        title: Text("Live Chat with Support"),
                        onTap: () {
                          Navigator.pop(context);
                          _openLiveChat(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.call, color: Colors.green),
                        title: Text("Call Customer Support"),
                        subtitle: Text("21709769"),
                        onTap: () {
                          Navigator.pop(context);
                          _makePhoneCall("21709769");
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.email, color: Colors.blue),
                        title: Text("Submit a Support Ticket"),
                        subtitle: Text("ahmed.trigui@outlook.com"),
                        onTap: () {
                          Navigator.pop(context);
                          _sendEmail("ahmed.trigui@outlook.com");
                        },
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

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  static const String _groqApiKey = "";
  static const String _groqApiUrl =
      "https://api.groq.com/openai/v1/chat/completions";

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(
      ChatMessage(
        text:
            "Hello! I'm your Car Rental support assistant. How can I help you today?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add(
        ChatMessage(
          text: userMessage,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await _getGroqResponse(userMessage);

      setState(() {
        _messages.add(
          ChatMessage(
            text: response,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text:
                "Sorry, I'm having trouble connecting right now. Please try again or contact us at ahmed.trigui@outlook.com",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  Future<String> _getGroqResponse(String userMessage) async {
    final messages = [
      {
        "role": "system",
        "content":
            """You are a car rental customer support assistant. Fonctionnalités principales
    4.1 Authentification utilisateur 🔐
    Firebase Authentication gère l'inscription et la connexion des utilisateurs de manière sécurisée.
    Comment ça fonctionne :
    •	L'utilisateur crée un compte avec son email et mot de passe
    •	Firebase vérifie les informations et crée une session
    •	Chaque utilisateur reçoit un identifiant unique stocké dans la base de données
    •	Les mots de passe sont automatiquement chiffrés par Firebase
    ✅ Avantages
    •	Pas besoin de gérer manuellement les mots de passe
    •	Protection contre les attaques courantes
    •	Récupération de mot de passe intégrée
    4.2 Recherche de voitures par localisation 📍
    Les utilisateurs peuvent chercher des voitures disponibles près d'eux grâce à Google Maps.
    Comment ça fonctionne :
    •	L'utilisateur saisit ou sélectionne un lieu sur la carte
    •	L'application récupère les coordonnées géographiques
    •	Une requête est envoyée à la base de données pour trouver les voitures dans cette zone
    •	Les résultats s'affichent sur une carte interactive
    4.3 Système de réservation 📅
    Le système permet aux clients de réserver une voiture avec validation du propriétaire.
    Processus de réservation :
    1 Le client sélectionne une voiture et choisit les dates de location
    2 Une demande est envoyée au propriétaire
    3 Le propriétaire reçoit une notification et examine la demande
    4 Il peut accepter ou refuser la réservation
    5 Le client est notifié de la décision
    4.4 Paiements sécurisés 💳
    Razorpay permet de traiter les paiements directement dans l'application.
    Comment ça fonctionne :
    •	Après validation de la réservation, le client accède à la page de paiement
    •	Razorpay gère la transaction de manière sécurisée
    •	Plusieurs moyens de paiement sont acceptés
    •	Une confirmation est envoyée automatiquement après le paiement
    🔒 Sécurité
    Conforme aux normes internationales (PCI DSS) - Transactions rapides et fiables - Gestion automatique des remboursements
    4.5 Enregistrement des voitures 🚙
    Les propriétaires peuvent ajouter leurs véhicules à la plateforme en remplissant un formulaire avec les détails du véhicule (modèle, année, prix par jour), en ajoutant des photos et en précisant la localisation.
    4.6 Suivi des revenus 💰
    Les propriétaires peuvent consulter leurs gains en temps réel. L'application calcule automatiquement le total des réservations validées et affiche un tableau de bord avec le nombre de locations et le montant généré.
    4.7 Notifications en temps réel 🔔
    Firebase Cloud Messaging envoie des alertes instantanées pour :
    •	Nouvelle demande de réservation
    •	Acceptation ou refus d'une réservation
    •	Confirmation de paiement
    •	Rappels avant le début de la location
    5. Flux utilisateur
    5.1 Parcours d'un client
    Étape 1 - Connexion : Le client se connecte ou crée un compte via Firebase Authentication.
    Étape 2 - Recherche : Sur l'écran d'accueil, il utilise la carte pour chercher des voitures dans sa zone.
    Étape 3 - Sélection : Il consulte les détails des voitures (prix, photos, disponibilité) et en sélectionne une.
    Étape 4 - Réservation : Il choisit les dates de location et envoie une demande au propriétaire.
    Étape 5 - Attente : Il reçoit une notification quand le propriétaire répond.
    Étape 6 - Paiement : Si la réservation est acceptée, il effectue le paiement via Razorpay.
    Étape 7 - Confirmation : Il reçoit une confirmation et peut consulter les détails.
    5.2 Parcours d'un propriétaire
    Étape 1 - Connexion : Le propriétaire se connecte avec son compte.
    Étape 2 - Ajout : Il enregistre un ou plusieurs véhicules avec leurs informations.
    Étape 3 - Réception : Il reçoit des notifications quand un client demande une réservation.
    Étape 4 - Validation : Il examine la demande et décide d'accepter ou de refuser.
    Étape 5 - Suivi : Il consulte son tableau de bord pour voir ses revenus.
    5.3 Double rôle
    Un utilisateur peut avoir les deux rôles simultanément. Depuis l'interface client, il peut activer le mode propriétaire en un clic, sans créer de nouveau compte."""
      },
      // Include conversation history for context
      ..._messages.where((m) => !m.isUser || m.text != userMessage).map((m) => {
            "role": m.isUser ? "user" : "assistant",
            "content": m.text,
          }),
      {
        "role": "user",
        "content": userMessage,
      }
    ];

    final response = await http.post(
      Uri.parse(_groqApiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_groqApiKey',
      },
      body: jsonEncode({
        'model': 'llama-3.3-70b-versatile',
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 500,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to get response: ${response.statusCode}');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.support_agent, color: Colors.purple),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Support Chat',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  'Online',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              ),
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    CircleAvatar(
                      backgroundColor: Colors.purple.shade100,
                      child: Icon(Icons.support_agent,
                          color: Colors.purple, size: 20),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.purple),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Typing...',
                              style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ],
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
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.purple.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.purple.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.purple,
                    radius: 24,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: Colors.purple.shade100,
              child: Icon(Icons.support_agent, color: Colors.purple, size: 20),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? Colors.purple : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: isUser ? Radius.circular(20) : Radius.circular(4),
                  bottomRight:
                      isUser ? Radius.circular(4) : Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: isUser ? Colors.white70 : Colors.grey.shade600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}

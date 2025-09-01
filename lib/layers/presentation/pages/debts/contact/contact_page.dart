import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactPage extends StatefulWidget {
  final String language;
  final bool lightMode;
  const ContactPage({super.key, required this.language, required this.lightMode});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getContactPermission();
    fetchContacts();
    searchController.addListener(() {
      filterContacts();
    });
  }


  Future<void> fetchContacts() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        final contactList = await FlutterContacts.getContacts(
            withProperties: true, withPhoto: true);

        // Agar kontaktlar bo'sh bo'lsa, test uchun qo'lda qo'shamiz
        if (contactList.isEmpty) {
          contactList.addAll([
            Contact()
              ..displayName = "Test User 1"
              ..phones = [Phone("1234567890")],
            Contact()
              ..displayName = "Test User 2"
              ..phones = [Phone("9876543210")],
          ]);
        }


        print("Kontaktlar soni: ${contactList.length}");
        setState(() {
          contacts = contactList;
          filteredContacts = contactList;
        });
      } 
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kontaktlar uchun ruxsat berilmagan")),
        );
      }
    } catch (e) {
      print("Xatolik: $e");
    }
  }

  void filterContacts() {
    String query = searchController.text.toLowerCase();
    if (contacts.isEmpty) {
      return; // Agar kontaktlar bo'lmasa, filtrlashni to'xtatish
    }
    setState(() {
      filteredContacts = contacts.where((contact) {
        return contact.displayName.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> getContactPermission() async {
    if (await FlutterContacts.requestPermission()) {
      print("Kontaktlar ruxsati berilgan.");
    } else {
      print("Kontaktlar ruxsati berilmagan.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor:
          widget. lightMode ? AppColors.homeBackgroundColor : AppColors.standartColor,
      appBar: AppBar(
        title: Text(
          'Qarzlar',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
        ),
         backgroundColor:
            widget. lightMode ? AppColors.primary : AppColors.standartColor,
              ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: 'Kontaktlarni qidirish',
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.r)),
                focusedBorder: OutlineInputBorder(
                    // borderSide: BorderSide.none,
                    borderSide: const BorderSide(color: Colors.white54),

                    borderRadius: BorderRadius.circular(10.r)),
                filled: true,
                // fillColor: Colors.grey[900],
                fillColor: Colors.white12
              ),
            ),
            const SizedBox(height: 20),

            // Contact List
            Expanded(
              child: ListView.builder(
                itemCount: filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = filteredContacts[index];
                  return ContactItem(
                    name: contact.displayName,
                    phone: contact.phones,
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

// Contact Item Widget
class ContactItem extends StatelessWidget {
  final String name;
  final List<Phone> phone;

  const ContactItem({
    super.key,
    required this.name,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    // Barcha telefon raqamlarini birlashtirish
    final phoneNumbers = phone.map((e) => e.number).join(", ");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        // color: Colors.grey[850],
        color: Colors.white12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[700],
            radius: 20,
            child: Icon(Icons.person, color: Colors.white),
          ),
          Gap(10.w),
          Expanded(
            child: InkWell(
              onTap: () {
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phoneNumbers.isNotEmpty
                        ? phoneNumbers
                        : "Telefon raqam mavjud emas",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

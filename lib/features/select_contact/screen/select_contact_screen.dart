import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/widgets/error.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/select_contact/controller/select_contact_controller.dart';

class SelectContactScreen extends ConsumerWidget {
  static const routeName = '/select_contact';
  const SelectContactScreen({Key? key}) : super(key: key);

  void selectContact(WidgetRef ref, Contact contact, BuildContext context) {
    ref.read(selectContactControllerProvider).selectContact(contact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select contact'),
          backgroundColor: backgroundColor,
          elevation: 0,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        body: ref.watch(getContactsRepositoryProvider).when(
            data: ((contactList) => contactList.isEmpty
                ? const Center(
                    child: Text("No contact Found"),
                  )
                : ListView.builder(
                    itemCount: contactList.length,
                    itemBuilder: (context, index) {
                      final contact = contactList[index];
                      return InkWell(
                        onTap: () {
                          selectContact(ref, contact, context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            title: Text(contact.displayName),
                            // subtitle: Text(data[index].number!),
                            leading: contact.photo == null
                                ? const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 30,
                                    child: Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(contact.photo!),
                                    radius: 30,
                                  ),
                            // onTap: () {
                            //   ref.read(selectContactControllerProvider).addContact(
                            //       data[index].name, data[index].number);
                            // },
                          ),
                        ),
                      );
                    })),
            error: ((error, stackTrace) {
              return ErrorScreen(error: error.toString());
            }),
            loading: () => const Loader()));
  }
}

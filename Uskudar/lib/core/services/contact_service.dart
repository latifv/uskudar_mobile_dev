import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:payinall/core/services/permission_service.dart';

final class ContactPermissionDeniedException implements Exception {
  const ContactPermissionDeniedException();
}

final class ContactLimitedAccessException implements Exception {
  const ContactLimitedAccessException();
}

final class ContactService {
  const ContactService({required this.permissionService});

  final PermissionService permissionService;

  Future<Contact?> pickContact() async {
    try {
      final hasPermission = await permissionService.requestContactsPermission();

      if (!hasPermission) {
        throw const ContactPermissionDeniedException();
      }

      final selectedContact = await FlutterContacts.openExternalPick();

      if (selectedContact == null) {
        final hasLimitedAccess = await permissionService
            .hasLimitedContactsPermission();
        if (hasLimitedAccess) {
          throw const ContactLimitedAccessException();
        }
      }

      return selectedContact;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED' ||
          e.code == 'PERMISSION_PERMANENTLY_DENIED') {
        throw const ContactPermissionDeniedException();
      }

      return null;
    } on ContactPermissionDeniedException {
      rethrow;
    } on ContactLimitedAccessException {
      rethrow;
    } on Exception catch (_) {
      return null;
    }
  }

  String? formatPhoneNumber(Contact contact) {
    if (contact.phones.isEmpty) {
      return null;
    }

    final phoneNumber = contact.phones.first.number;
    if (phoneNumber.isEmpty) {
      return null;
    }

    var cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanNumber.startsWith('90') && cleanNumber.length == 12) {
      cleanNumber = cleanNumber.substring(2);
    } else if (cleanNumber.startsWith('0') && cleanNumber.length == 11) {
      cleanNumber = cleanNumber.substring(1);
    }

    if (cleanNumber.length == 10 && cleanNumber.startsWith('5')) {
      return cleanNumber;
    }

    return null;
  }

  String? getContactDisplayName(Contact contact) {
    if (contact.displayName.isNotEmpty) {
      return contact.displayName;
    }

    final firstName = contact.name.first;
    final lastName = contact.name.last;

    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      return '$firstName $lastName'.trim();
    }

    return null;
  }
}

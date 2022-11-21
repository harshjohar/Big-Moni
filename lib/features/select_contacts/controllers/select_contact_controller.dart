import 'package:bigbucks/features/select_contacts/repository/select_contact_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactRepository.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final repository = ref.watch(selectContactsRepositoryProvider);
  return SelectContactController(ref, repository);
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController(this.ref, this.selectContactRepository);


}
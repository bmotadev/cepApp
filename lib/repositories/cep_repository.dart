import 'package:cep_app/models/address_model.dart';

abstract class CepRepository {

  Future<AddressModel> getCep(String cep);
}
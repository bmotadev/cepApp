import 'package:cep_app/models/address_model.dart';
import 'package:cep_app/repositories/cep_repository.dart';
import 'package:cep_app/repositories/cep_repository_impl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  const HomePage({ super.key });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final CepRepository cepRepository = CepRepositoryImpl();
  AddressModel? addressModel;
  bool loading = false;

  final formKey = GlobalKey<FormState>(); // forma de acessar o estado que está la dentro
  final cepEditingController = TextEditingController();

  @override
  void dispose() { // evitar o memory leak, para o app não usar mais memoria do que o normal
    cepEditingController.dispose();
    super.dispose();
  }

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(title: const Text('Buscar CEP'),),
           body: SingleChildScrollView(
             child: Form(
                key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: cepEditingController,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'CEP Obrigatorio';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async { // todo await, precisa ser async
                      final valid = formKey.currentState?.validate() ?? false; // o metodo pode ser nulo, se for nulo ele retorna como falso
                      if(valid){
                        try {
                          setState(() {
                            loading = true;
                          });
                          final address = await cepRepository.getCep(cepEditingController.text);
                          setState(() {
                            loading = false;
                            addressModel = address;
                          });
                        } catch (e) {
                          setState(() {
                            loading = false;
                            addressModel = null;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content:
                          Text('Erro ao buscar endereço')),
                          );
                        }
                      }
                    }, 
                    child: const Text('Buscar'),
                  ),
                  Visibility(
                    visible: loading,
                    child: CircularProgressIndicator(),
                  ),
                  Visibility(
                    visible: addressModel != null,
                    child: Text(
                    '${addressModel?.logradouro} ${addressModel?.complemento} ${addressModel?.cep}'
                  ))
                ],
              )),
           ),
       );
  }
}
import 'package:flutter/material.dart';

import '../data.dart';

class InventoryList extends StatefulWidget {
  const InventoryList({super.key, this.onTap});
  final ValueChanged<Inventory>? onTap;

  @override
  InventoryListState createState() => InventoryListState(onTap);
}

class InventoryListState extends State<InventoryList> {
  late Future<List<Inventory>> futureInventories;
  final ValueChanged<Inventory>? onTap;

  InventoryListState(this.onTap);

  @override
  void initState() {
    super.initState();
    futureInventories = fetchInventories();
  }

  Future<List<Inventory>> refreshInventoryState() async {
    futureInventories = fetchInventories();
    return futureInventories;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Inventory>>(
      future: refreshInventoryState(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          campusConfigSystemInstance.setInventories(snapshot.data);
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                (snapshot.data![index].asset!.name.toString()),
              ),
              subtitle: Text(
                ' ' +
                    snapshot.data![index].asset!.id.toString() +
                    ' ' +
                    snapshot.data![index].consumable!.id.toString() +
                    ' ' +
                    snapshot.data![index].organization!.id.toString() +
                    ' ' +
                    snapshot.data![index].person!.id.toString() +
                    ' ' +
                    snapshot.data![index].quantity.toString() +
                    ' ' +
                    snapshot.data![index].quantityIn.toString() +
                    ' ' +
                    snapshot.data![index].quantityOut.toString() +
                    ' ',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () async {
                        Navigator.of(context)
                            .push<void>(
                              MaterialPageRoute<void>(
                                builder: (context) => EditInventoryPage(
                                    inventory: snapshot.data![index]),
                              ),
                            )
                            .then((value) => setState(() {}));
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () async {
                        await _deleteInventory(snapshot.data![index]);
                        setState(() {});
                      },
                      icon: const Icon(Icons.delete)),
                ],
              ),
              onTap: onTap != null ? () => onTap!(snapshot.data![index]) : null,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Future<void> _deleteInventory(Inventory inventory) async {
    try {
      await deleteInventory(inventory.id!);
    } on Exception {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: const Text('Failed to delete the Inventory'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }
}

class AddInventoryPage extends StatefulWidget {
  static const String route = '/inventory/add';
  const AddInventoryPage({super.key});
  @override
  _AddInventoryPageState createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _assetIdController;
  late FocusNode _assetIdFocusNode;
  late TextEditingController _consumableIdController;
  late FocusNode _consumableIdFocusNode;
  late TextEditingController _organizationIdController;
  late FocusNode _organizationIdFocusNode;
  late TextEditingController _personIdController;
  late FocusNode _personIdFocusNode;
  late TextEditingController _quantityController;
  late FocusNode _quantityFocusNode;
  late TextEditingController _quantityInController;
  late FocusNode _quantityInFocusNode;
  late TextEditingController _quantityOutController;
  late FocusNode _quantityOutFocusNode;

  @override
  void initState() {
    super.initState();
    _assetIdController = TextEditingController();
    _assetIdFocusNode = FocusNode();
    _consumableIdController = TextEditingController();
    _consumableIdFocusNode = FocusNode();
    _organizationIdController = TextEditingController();
    _organizationIdFocusNode = FocusNode();
    _personIdController = TextEditingController();
    _personIdFocusNode = FocusNode();
    _quantityController = TextEditingController();
    _quantityFocusNode = FocusNode();
    _quantityInController = TextEditingController();
    _quantityInFocusNode = FocusNode();
    _quantityOutController = TextEditingController();
    _quantityOutFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _assetIdController.dispose();
    _consumableIdController.dispose();
    _organizationIdController.dispose();
    _personIdController.dispose();
    _quantityController.dispose();
    _quantityInController.dispose();
    _quantityOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              const Text(
                  'Fill in the details of the Inventory you want to add'),
              TextFormField(
                controller: _assetIdController,
                decoration: const InputDecoration(labelText: 'assetId'),
                onFieldSubmitted: (_) {
                  _assetIdFocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _consumableIdController,
                decoration: const InputDecoration(labelText: 'consumableId'),
                onFieldSubmitted: (_) {
                  _consumableIdFocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _organizationIdController,
                decoration: const InputDecoration(labelText: 'organizationId'),
                onFieldSubmitted: (_) {
                  _organizationIdFocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _personIdController,
                decoration: const InputDecoration(labelText: 'personId'),
                onFieldSubmitted: (_) {
                  _personIdFocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'quantity'),
                onFieldSubmitted: (_) {
                  _quantityFocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _quantityInController,
                decoration: const InputDecoration(labelText: 'quantityIn'),
                onFieldSubmitted: (_) {
                  _quantityInFocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _quantityOutController,
                decoration: const InputDecoration(labelText: 'quantityOut'),
                onFieldSubmitted: (_) {
                  _quantityOutFocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _addInventory(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  String? _mandatoryValidator(String? text) {
    return (text!.isEmpty) ? 'Required' : null;
  }

  Future<void> _addInventory(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        final Inventory inventory = Inventory(
          asset: Asset(id: int.parse(_assetIdController.text)),
          consumable: Consumable(id: int.parse(_consumableIdController.text)),
          organization:
              Organization(id: int.parse(_organizationIdController.text)),
          person: Person(id: int.parse(_personIdController.text)),
          quantity: int.parse(_quantityController.text),
          quantityIn: int.parse(_quantityInController.text),
          quantityOut: int.parse(_quantityOutController.text),
        );
        await createInventory(inventory);
        Navigator.of(context).pop(context);
      }
    } on Exception {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: const Text('Failed to add Inventory'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }
}

class EditInventory extends StatefulWidget {
  const EditInventory({super.key, this.inventory});
  final Inventory? inventory;

  @override
  EditInventoryState createState() => EditInventoryState();
}

class EditInventoryState extends State<EditInventory> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name_Controller;
  late FocusNode _name_FocusNode;
  late TextEditingController _description_Controller;
  late FocusNode _description_FocusNode;
  late TextEditingController _quantity_Controller;
  late FocusNode _quantity_FocusNode;
  late TextEditingController _price_Controller;
  late FocusNode _price_FocusNode;
  late TextEditingController _image_Controller;
  late FocusNode _image_FocusNode;



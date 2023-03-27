import 'package:ShoolManagementSystem/src/data/consumable.dart';
import 'package:ShoolManagementSystem/src/data/organization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/app_config.dart';
import 'asset.dart';
import 'avinya_type.dart';
import 'consumable.dart';
import 'person.dart';

class Inventory {
  Inventory({
    this.quantityOut,
    this.quantity,
    this.quantityIn,
    this.avinyaTypeId,
    this.id,
    this.asset,
    this.consumable,
    this.organization,
    this.person,
    this.avinyaType,
  });

  int? quantityOut;
  int? quantity;
  int? quantityIn;
  int? avinyaTypeId;
  int? id;
  Asset? asset;
  Consumable? consumable;
  Organization? organization;
  Person? person;
  AvinyaType? avinyaType;

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        quantityOut: json["quantity_out"] == null ? null : json["quantity_out"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        quantityIn: json["quantity_in"] == null ? null : json["quantity_in"],
        avinyaTypeId:
            json["avinya_type_id"] == null ? null : json["avinya_type_id"],
        id: json["id"] == null ? null : json["id"],
        asset: json["asset"] == null ? null : Asset.fromJson(json["asset"]),
        consumable: json["consumable"] == null
            ? null
            : Consumable.fromJson(json["consumable"]),
        organization: json["organization"] == null
            ? null
            : Asset.fromJson(json["organization"]),
        person: json["person"] == null ? null : Asset.fromJson(json["person"]),
        avinyaType: json["avinya_type"] == null
            ? null
            : AvinyaType.fromJson(json["avinya_type"]),
      );

  Map<String, dynamic> toJson() => {
        if (quantityOut != null) "quantity_out": quantityOut,
        if (quantity != null) "quantity": quantity,
        if (quantityIn != null) "quantity_in": quantityIn,
        if (avinyaTypeId != null) "avinya_type_id": avinyaTypeId,
        if (id != null) "id": id,
        if (asset != null) "asset": asset!.toJson(),
        if (consumable != null) "consumable": consumable!.toJson(),
        if (organization != null) "organization": organization!.toJson(),
        if (person != null) "person": person!.toJson(),
        if (avinyaType != null) "avinya_type": avinyaType!.toJson(),
      };
}

Future<List<Inventory>> fetchInventories() async {
  final response = await http.get(
    Uri.parse(AppConfig.campusConfigBffApiUrl + '/inventories'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'accept': 'application/json',
      'Authorization': 'Bearer ' + AppConfig.campusConfigBffApiKey,
    },
  );

  if (response.statusCode == 200) {
    var resultsJson = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Inventory> inventories = await resultsJson
        .map<Inventory>((json) => Inventory.fromJson(json))
        .toList();
    return inventories;
  } else {
    throw Exception('Failed to load Inventories');
  }
}

Future<Inventory> fetchInventory(int id) async {
  final response = await http.get(
    Uri.parse(AppConfig.campusConfigBffApiUrl + '/inventory?inventoryId=$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'accept': 'application/json',
      'Authorization': 'Bearer ' + AppConfig.campusConfigBffApiKey,
    },
  );

  if (response.statusCode == 200) {
    return Inventory.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Inventory');
  }
}

Future<http.Response> createInventory(Inventory inventory) async {
  final response = await http.post(
    Uri.parse(AppConfig.campusConfigBffApiUrl + '/inventory'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + AppConfig.campusConfigBffApiKey,
    },
    body: jsonEncode(inventory.toJson()),
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to create Inventory.');
  }
}

Future<http.Response> updateInventory(Inventory inventory) async {
  final response = await http.put(
    Uri.parse(AppConfig.campusConfigBffApiUrl +
        '/inventory/' +
        inventory.id.toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + AppConfig.campusConfigBffApiKey,
    },
    body: jsonEncode(inventory.toJson()),
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to update Inventory.');
  }
}

Future<http.Response> deleteInventory(int id) async {
  final response = await http.delete(
    Uri.parse(AppConfig.campusConfigBffApiUrl + '/inventory/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + AppConfig.campusConfigBffApiKey,
    },
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to delete Inventory.');
  }
}







// class Inventory {
//   int? id;
//   int? asset_id;
//   int? consumable_id;
//   int? organization_id;
//   int? person_id;
//   int? quantity;
//   int? quantity_in;
//   int? quantity_out;

//   Inventory({
//     this.id,
//     this.asset_id,
//     this.consumable_id,
//     this.organization_id,
//     this.person_id,
//     this.quantity,
//     this.quantity_in,
//     this.quantity_out,
//   });

//   factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
//         id: json["id"] == null ? null : json["id"],
//         asset_id: json["asset_id"] == null ? null : json["asset_id"],
//         consumable_id:
//             json["consumable_id"] == null ? null : json["consumable_id"],
//         organization_id:
//             json["organization_id"] == null ? null : json["organization_id"],
//         person_id: json["person_id"] == null ? null : json["person_id"],
//         quantity: json["quantity"] == null ? null : json["quantity"],
//         quantity_in: json["quantity_in"] == null ? null : json["quantity_in"],
//         quantity_out:
//             json["quantity_out"] == null ? null : json["quantity_out"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "asset_id": asset_id == null ? null : asset_id,
//         "consumable_id": consumable_id == null ? null : consumable_id,
//         "organization_id": organization_id == null ? null : organization_id,
//         "person_id": person_id == null ? null : person_id,
//         "quantity": quantity == null ? null : quantity,
//         "quantity_in": quantity_in == null ? null : quantity_in,
//         "quantity_out": quantity_out == null ? null : quantity_out,
//       };
// }

// Future<List<Inventory>> fetchInventories() async {
//   final response = await http.get(
//     Uri.parse(AppConfig.campusConfigBffApiUrl + '/inventories'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'accept': 'application/json',
//       'Authorization': 'Bearer ' + AppConfig.campusConfigBffApiKey,
//     },
//   );

//   if (response.statusCode == 200) {
//     var resultsJson = json.decode(response.body).cast<Map<String, dynamic>>();
//     List<Inventory> inventories = await resultsJson
//         .map<Inventory>((json) => Inventory.fromJson(json))
//         .toList();
//     return inventories;
//   } else {
//     throw Exception('Failed to load Inventories');
//   }
// }

// Future<Inventory> fetchInventory(int id) async {
//   final response = await http.get(
//     Uri.parse(
//         AppConfig.campusConfigBffApiUrl + '/inventories/' + id.toString()),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'accept': 'application/json',
//       'Authorization': 'Bearer ' + AppConfig.campusConfigBffApiKey,
//     },
//   );

//   if (response.statusCode == 200) {
//     return Inventory.fromJson(json.decode(response.body));
//   } else {
//     throw Exception('Failed to load Inventory');
//   }
// }

// Future<http.Response> createInventory(Inventory inventory) async {
//   final response = await http.post(
//     Uri.parse(AppConfig.campusConfigBffApiUrl + '/inventories'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Bearer ' + AppConfig.campusConfigBffApiKey,
//     },
//     body: jsonEncode(inventory.toJson()),
//   );
//   if (response.statusCode == 200) {
//     return response;
//   } else {
//     throw Exception('Failed to create Inventory.');
//   }
// }

// Future<http.Response> updateInventory(Inventory inventory) async {
//   final response = await http.put(
//     Uri.parse(AppConfig.campusConfigBffApiUrl +
//         '/inventories/' +
//         inventory.id.toString()),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Bearer ' + AppConfig.campusConfigBffApiKey,
//     },
//     body: jsonEncode(inventory.toJson()),
//   );
//   if (response.statusCode == 200) {
//     return response;
//   } else {
//     throw Exception('Failed to update Inventory.');
//   }
// }

// Future<http.Response> deleteInventory(int id) async {
//   final response = await http.delete(
//     Uri.parse(AppConfig.campusConfigBffApiUrl + '/inventories/$id'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Bearer ' + AppConfig.campusConfigBffApiKey,
//     },
//   );
//   if (response.statusCode == 200) {
//     return response;
//   } else {
//     throw Exception('Failed to delete Inventory.');
//   }
// }

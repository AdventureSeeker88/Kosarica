import 'package:hive/hive.dart';

import 'kosarica_pocetna_screen.dart';
// Import the class that the adapter will adapt

class CartItemAdapter extends TypeAdapter<CartItem> {
  @override
  int get typeId => 0; // Unique identifier for this type

  @override
  CartItem read(BinaryReader reader) {
    // Implement logic to read data from binary
    // For example:
    return CartItem(
       storeName:reader.readString(),
      storeImage: reader.readString(),
      offerImage: reader.readString(),
      offerDescription: reader.readString(),
        offerPE: reader.readString(),
      offerPK:reader.readString(),
      offerPEPoints: reader.readString(),
      offerPKPoints: reader.readString(),
      validTo: reader.readString(),
      quantity: reader.readInt(),

      // Add logic to read other properties
    );
  }

  @override
  void write(BinaryWriter writer, CartItem obj) {
    // Implement logic to write data to binary
    // For example:
    writer.writeString(obj.storeName);
    writer.writeString(obj.storeImage);
    writer.writeString(obj.offerImage);
    writer.writeString(obj.offerDescription);
    writer.writeString(obj.offerPE);
    writer.writeString(obj.offerPK);
    writer.writeString(obj.offerPEPoints);
    writer.writeString(obj.offerPKPoints);
    writer.writeString(obj.validTo);
    writer.writeInt(obj.quantity);
    // Add logic to write other properties
  }
}

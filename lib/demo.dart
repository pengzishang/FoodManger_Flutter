class Meta {
  double price;
  String name;
  Meta(this.name, this.price);
}

// 定义商品 Item 类
class Item extends Meta {
  Item(price, name) : super(price, name);
}

// 定义购物车类
class ShoppingCart extends Meta {
  DateTime date;
  String code;
  List<Item> bookings;

  double get price =>
      bookings.map((item) => item.price).reduce((value, item) => value + item);

  ShoppingCart({name}) : this.withCode(name: name, code: "");

  ShoppingCart.withCode({name, this.code})
      : date = DateTime.now(),
        super(name, 0);
  // ShoppingCart(name, [this.code])

  //       super(name, 0);

  getInfo() => '''购物车信息:
-----------------------------
用户名: $name
优惠码: ${code ?? 0}
总价: ${price.toString()}
日期: ${date.toString()}
-----------------------------
''';
}

void main() {
  ShoppingCart sc = ShoppingCart.withCode(name: "", code: "");
  sc.bookings = [Item('苹果', 10.0), Item('鸭梨', 20.0)];
  print(sc.getInfo());
}

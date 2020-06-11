class Item {
  int _id;
  String _productId;
  String _productName;
  String _productImageUrl;
  String _productImagePath;
  int _productAmount;
  String _productLocation;

  Item(this._productId, this._productName, this._productAmount, this._productLocation, [this._productImageUrl, this._productImagePath]);

  Item.withID(this._id, this._productId, this._productName, this._productAmount, this._productLocation, [this._productImageUrl, this._productImagePath]);

  int get id => _id;

  String get productId => _productId;

  String get productName => _productName;

  String get productImageUrl => _productImageUrl;

  String get productImagePath => _productImagePath;

  int get productAmount => _productAmount;

  String get productLocation => _productLocation;

  set id(int newId) {
    this._id = newId;
  }

  set productId(String newProductId){
    this._productId = newProductId;
  }

  set productName(String newProductName) {
    this._productName = newProductName;
  }

  set productImageUrl(String newProductImageUrl) {
    this._productImageUrl = newProductImageUrl;
  }

  set productImagePath(String newProductImagePath) {
    this._productImagePath = newProductImagePath;
  }

  set productAmount(int newProductAmount) {
    this._productAmount = newProductAmount;
  }

  set productLocation(String newProductLocation) {
    this._productLocation = newProductLocation;
  }
  //Convert an Item object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null){
    map['id'] = _id;
    }
    map['productId'] = _productId;
    map['productName'] = _productName;
    map['productImageUrl'] = _productImageUrl;
    map['productImagePath'] = _productImagePath;
    map['productAmount'] = _productAmount;
    map['productLocation'] = _productLocation;

    return map;
  }

  //Extract Item object from Map object
  Item.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._productId = map['productId'];
    this._productName = map['productName'];
    this._productImageUrl = map['productImageUrl'];
    this._productImagePath = map['productImagePath'];
    this._productAmount = map['productAmount'];
    this._productLocation = map['productLocation'];
  }
}

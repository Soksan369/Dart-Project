import 'dart:io';
import 'dart:convert';

class Customer {
  int _customerID;
  String _name;
  String _email;
  String _phone;

  Customer(this._customerID, this._name, this._email, this._phone);

  int get customerID => _customerID;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;

  void placeOrder(Order order) {
    // Implementation for placing an order
  }

  void reserveTable(TableReservation reservation) {
    // Implementation for reserving a table
  }

  Map<String, dynamic> toJson() => {
    'customerID': _customerID,
    'name': _name,
    'email': _email,
    'phone': _phone,
  };

  static Customer fromJson(Map<String, dynamic> json) {
    return Customer(json['customerID'], json['name'], json['email'], json['phone']);
  }

  static Future<void> saveToFile(List<Customer> customers, String filename) async {
    final file = File(filename);
    List<Map<String, dynamic>> jsonList = customers.map((customer) => customer.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  static Future<List<Customer>> loadFromFile(String filename) async {
    final file = File(filename);
    if (!await file.exists()) return [];
    String contents = await file.readAsString();
    List<dynamic> jsonList = jsonDecode(contents);
    return jsonList.map((json) => Customer.fromJson(json)).toList();
  }
}

class Menu {
  int _menuID;
  String _itemName;
  String _itemDescription;
  double _price;

  Menu(this._menuID, this._itemName, this._itemDescription, this._price);

  int get menuID => _menuID;
  String get itemName => _itemName;
  String get itemDescription => _itemDescription;
  double get price => _price;

  static List<Menu> menuItems = [];

  static void addItem(Menu item) {
    menuItems.add(item);
  }

  static void removeItem(int menuID) {
    menuItems.removeWhere((item) => item.menuID == menuID);
  }

  static List<Menu> getMenuItems() {
    return menuItems;
  }

  Map<String, dynamic> toJson() => {
    'menuID': _menuID,
    'itemName': _itemName,
    'itemDescription': _itemDescription,
    'price': _price,
  };

  static Menu fromJson(Map<String, dynamic> json) {
    return Menu(json['menuID'], json['itemName'], json['itemDescription'], json['price']);
  }

  static Future<void> saveToFile(List<Menu> menuItems, String filename) async {
    final file = File(filename);
    List<Map<String, dynamic>> jsonList = menuItems.map((item) => item.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  static Future<List<Menu>> loadFromFile(String filename) async {
    final file = File(filename);
    if (!await file.exists()) return [];
    String contents = await file.readAsString();
    List<dynamic> jsonList = jsonDecode(contents);
    return jsonList.map((json) => Menu.fromJson(json)).toList();
  }
}

class Order {
  int _orderID;
  int _customerID;
  DateTime _orderDate;
  double _totalAmount;
  String _orderStatus;
  String _paymentStatus;
  List<Menu> _items;

  Order(this._orderID, this._customerID, this._orderDate, this._totalAmount, this._orderStatus, this._paymentStatus, this._items);

  int get orderID => _orderID;
  int get customerID => _customerID;
  DateTime get orderDate => _orderDate;
  double get totalAmount => _totalAmount;
  String get orderStatus => _orderStatus;
  String get paymentStatus => _paymentStatus;
  List<Menu> get items => _items;

  void calculateTotal() {
    _totalAmount = _items.fold(0, (sum, item) => sum + item.price);
  }

  void addItem(Menu item) {
    _items.add(item);
    calculateTotal();
  }

  void removeItem(int menuID) {
    _items.removeWhere((item) => item.menuID == menuID);
    calculateTotal();
  }

  void updateOrderStatus(String status) {
    _orderStatus = status;
  }

  void updatePaymentStatus(String status) {
    _paymentStatus = status;
  }

  Map<String, dynamic> toJson() => {
    'orderID': _orderID,
    'customerID': _customerID,
    'orderDate': _orderDate.toIso8601String(),
    'totalAmount': _totalAmount,
    'orderStatus': _orderStatus,
    'paymentStatus': _paymentStatus,
    'items': _items.map((item) => item.toJson()).toList(),
  };

  static Order fromJson(Map<String, dynamic> json) {
    List<Menu> items = (json['items'] as List).map((itemJson) => Menu.fromJson(itemJson)).toList();
    return Order(json['orderID'], json['customerID'], DateTime.parse(json['orderDate']), json['totalAmount'], json['orderStatus'], json['paymentStatus'], items);
  }

  static Future<void> saveToFile(List<Order> orders, String filename) async {
    final file = File(filename);
    List<Map<String, dynamic>> jsonList = orders.map((order) => order.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  static Future<List<Order>> loadFromFile(String filename) async {
    final file = File(filename);
    if (!await file.exists()) return [];
    String contents = await file.readAsString();
    List<dynamic> jsonList = jsonDecode(contents);
    return jsonList.map((json) => Order.fromJson(json)).toList();
  }
}

class TableReservation {
  int _reservationID;
  int _customerID;
  int _tableNumber;
  DateTime _reservationTime;
  bool _isReserved;

  TableReservation(this._reservationID, this._customerID, this._tableNumber, this._reservationTime, this._isReserved);

  int get reservationID => _reservationID;
  int get customerID => _customerID;
  int get tableNumber => _tableNumber;
  DateTime get reservationTime => _reservationTime;
  bool get isReserved => _isReserved;

  static List<TableReservation> reservations = [];

  static void reserve(TableReservation reservation) {
    reservations.add(reservation);
  }

  static void cancel(int reservationID) {
    reservations.removeWhere((reservation) => reservation.reservationID == reservationID);
  }

  static bool isTableAvailable(int tableNumber, DateTime time) {
    return !reservations.any((reservation) => reservation.tableNumber == tableNumber && reservation.reservationTime == time);
  }

  Map<String, dynamic> toJson() => {
    'reservationID': _reservationID,
    'customerID': _customerID,
    'tableNumber': _tableNumber,
    'reservationTime': _reservationTime.toIso8601String(),
    'isReserved': _isReserved,
  };

  static TableReservation fromJson(Map<String, dynamic> json) {
    return TableReservation(json['reservationID'], json['customerID'], json['tableNumber'], DateTime.parse(json['reservationTime']), json['isReserved']);
  }

  static Future<void> saveToFile(List<TableReservation> reservations, String filename) async {
    final file = File(filename);
    List<Map<String, dynamic>> jsonList = reservations.map((reservation) => reservation.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  static Future<List<TableReservation>> loadFromFile(String filename) async {
    final file = File(filename);
    if (!await file.exists()) return [];
    String contents = await file.readAsString();
    List<dynamic> jsonList = jsonDecode(contents);
    return jsonList.map((json) => TableReservation.fromJson(json)).toList();
  }
}

void main() async {
  while (true) {
    print('Select an option:');
    print('1. Customer');
    print('2. Menu');
    print('3. Order');
    print('4. Table Reservation');
    print('5. Exit');
    String choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        await manageCustomers();
        break;
      case '2':
        await manageMenu();
        break;
      case '3':
        await manageOrders();
        break;
      case '4':
        await manageReservations();
        break;
      case '5':
        exit(0);
      default:
        print('Invalid choice. Please try again.');
    }
  }
}

Future<void> manageCustomers() async {
  while (true) {
    print('Customer Management:');
    print('1. Add Customer');
    print('2. View Customers');
    print('3. Back');
    String choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        print('Enter customer ID:');
        int id = int.parse(stdin.readLineSync()!);
        print('Enter customer name:');
        String name = stdin.readLineSync()!;
        print('Enter customer email:');
        String email = stdin.readLineSync()!;
        print('Enter customer phone:');
        String phone = stdin.readLineSync()!;
        var customer = Customer(id, name, email, phone);
        var customers = await Customer.loadFromFile('customers.txt');
        customers.add(customer);
        await Customer.saveToFile(customers, 'customers.txt');
        break;
      case '2':
        var customers = await Customer.loadFromFile('customers.txt');
        print('Customers:');
        for (var customer in customers) {
          print('ID: ${customer.customerID}, Name: ${customer.name}, Email: ${customer.email}, Phone: ${customer.phone}');
        }
        break;
      case '3':
        return;
      default:
        print('Invalid choice. Please try again.');
    }
  }
}

Future<void> manageMenu() async {
  while (true) {
    print('Menu Management:');
    print('1. Add Menu Item');
    print('2. View Menu Items');
    print('3. Back');
    String choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        print('Enter menu item ID:');
        int id = int.parse(stdin.readLineSync()!);
        print('Enter item name:');
        String name = stdin.readLineSync()!;
        print('Enter item description:');
        String description = stdin.readLineSync()!;
        print('Enter item price:');
        double price = double.parse(stdin.readLineSync()!);
        var menuItem = Menu(id, name, description, price);
        Menu.addItem(menuItem);
        await Menu.saveToFile(Menu.menuItems, 'menu.txt');
        break;
      case '2':
        var menuItems = await Menu.loadFromFile('menu.txt');
        print('Menu Items:');
        for (var item in menuItems) {
          print('ID: ${item.menuID}, Name: ${item.itemName}, Description: ${item.itemDescription}, Price: ${item.price}');
        }
        break;
      case '3':
        return;
      default:
        print('Invalid choice. Please try again.');
    }
  }
}

Future<void> manageOrders() async {
  while (true) {
    print('Order Management:');
    print('1. Add Order');
    print('2. View Orders');
    print('3. Back');
    String choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        print('Enter order ID:');
        int id = int.parse(stdin.readLineSync()!);
        print('Enter customer ID:');
        int customerId = int.parse(stdin.readLineSync()!);
        var orderDate = DateTime.now();
        List<Menu> items = await Menu.loadFromFile('menu.txt');
        List<Menu> orderItems = [];
        while (true) {
          print('Enter menu item ID to add to order (or type "done" to finish):');
          String itemId = stdin.readLineSync()!;
          if (itemId.toLowerCase() == 'done') break;
          Menu? menuItem = items.firstWhere(
            (item) => item.menuID == int.parse(itemId),
            orElse: () => Menu(0, 'Unknown', 'Unknown', 0.0),
            );
          if (menuItem != null) {
            orderItems.add(menuItem);
          } else {
            print('Invalid menu item ID.');
          }
        }
        var order = Order(id, customerId, orderDate, 0, 'Pending', 'Unpaid', orderItems);
        order.calculateTotal();
        var orders = await Order.loadFromFile('orders.txt');
        orders.add(order);
        await Order.saveToFile(orders, 'orders.txt');
        break;
      case '2':
        var orders = await Order.loadFromFile('orders.txt');
        print('Orders:');
        for (var order in orders) {
          print('ID: ${order.orderID}, Customer ID: ${order.customerID}, Date: ${order.orderDate}, Total: ${order.totalAmount}, Status: ${order.orderStatus}, Payment: ${order.paymentStatus}');
        }
        break;
      case '3':
        return;
      default:
        print('Invalid choice. Please try again.');
    }
  }
}

Future<void> manageReservations() async {
  while (true) {
    print('Table Reservation Management:');
    print('1. Add Reservation');
    print('2. View Reservations');
    print('3. Back');
    String choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        print('Enter reservation ID:');
        int id = int.parse(stdin.readLineSync()!);
        print('Enter customer ID:');
        int customerId = int.parse(stdin.readLineSync()!);
        print('Enter table number:');
        int tableNumber = int.parse(stdin.readLineSync()!);
        var reservationTime = DateTime.now();
        var reservation = TableReservation(id, customerId, tableNumber, reservationTime, true);
        TableReservation.reserve(reservation);
        await TableReservation.saveToFile(TableReservation.reservations, 'reservations.txt');
        break;
      case '2':
        var reservations = await TableReservation.loadFromFile('reservations.txt');
        print('Reservations:');
        for (var reservation in reservations) {
          print('ID: ${reservation.reservationID}, Customer ID: ${reservation.customerID}, Table: ${reservation.tableNumber}, Time: ${reservation.reservationTime}, Reserved: ${reservation.isReserved}');
        }
        break;
      case '3':
        return;
      default:
        print('Invalid choice. Please try again.');
    }
  }
}
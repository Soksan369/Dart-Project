import 'dart:io';

class MenuItem {
  String name;
  double price;
  int quantity;

  MenuItem(this.name, this.price, this.quantity);
}

class Customer {
  String customerID;
  String name;
  String contactDetails;

  Customer(this.customerID, this.name, this.contactDetails);

  void placeOrder(Order order) {
    print('Order placed by ${this.name}:');
    print(order.getRecipe());
  }

  void reserveTable(TableReservation reservation) {
    reservation.reserveTable();
    print('Table reserved by ${this.name}:');
    print(reservation.getReservationDetails());
  }
}

class Menu {
  List<MenuItem> items = [];

  void addItem(MenuItem item) {
    items.add(item);
  }

  void removeItem(MenuItem item) {
    items.remove(item);
  }

  MenuItem getItem(int index) {
    return items[index];
  }
}

class Order {
  String orderID;
  Customer customer;
  List<MenuItem> items = [];
  double totalPrice = 0.0;
  String orderStatus;
  String paymentStatus;

  Order(this.orderID, this.customer, this.orderStatus, this.paymentStatus);

  void addItem(MenuItem item) {
    items.add(item);
    calculateTotal();
  }

  void removeItem(MenuItem item) {
    items.remove(item);
    calculateTotal();
  }

  void calculateTotal() {
    totalPrice = 0.0;
    for (int i = 0; i < items.length; i++) {
      totalPrice += items[i].price * items[i].quantity;
    }
  }

  String getRecipe() {
    return 'Order ID: $orderID, Customer: ${customer.name}, Total Price: $totalPrice';
  }
}

class TableReservation {
  String reservationID;
  Customer customer;
  int tableNumber;
  DateTime reservationTime;
  bool isReserved;

  TableReservation(this.reservationID, this.customer, this.tableNumber, this.reservationTime, this.isReserved);

  void reserveTable() {
    isReserved = true;
  }

  void cancelReservation() {
    isReserved = false;
  }

  String getReservationDetails() {
    return 'Reservation ID: $reservationID, Customer: ${customer.name}, Table Number: $tableNumber, Reservation Time: $reservationTime';
  }
}

void main() {
  // Example usage
  Customer customer1 = Customer('C001', 'Phork Soksan', '070-458-409');
  //Customer customer2 = Customer('C002', 'Pen Sithol', '096-111-987');
  Menu menu = Menu();
  menu.addItem(MenuItem('Burger', 5.0, 1));
  menu.addItem(MenuItem('Drink', 2.0, 1));
  menu.addItem(MenuItem('Fries', 3.0, 1));
  menu.removeItem(menu.items[0]); // Remove the first item
  menu.addItem(MenuItem('Salad', 4.0, 1));
  menu.addItem(MenuItem('Pizza', 6.0, 1));
  print('Welcome to the Restaurant!');
  print('1. Place an Order');
  print('2. Reserve a Table');
  stdout.write('Please select an option: ');
  String? choice = stdin.readLineSync();

  if (choice == '1') {
    Order order = Order('O001', customer1, 'Pending', 'Unpaid');
    while (true) {
      print('Menu:');
      for (int i = 0; i < menu.items.length; i++) {
        print('${i + 1}. ${menu.items[i].name} - \$${menu.items[i].price}');
      }
      stdout.write('Select an item to add to your order (or type "done" to finish): ');
      String? itemChoice = stdin.readLineSync();
      if (itemChoice == 'done') {
        break;
      }
      int itemIndex = int.parse(itemChoice!) - 1;
      stdout.write('Enter quantity: ');
      int quantity = int.parse(stdin.readLineSync()!);
      MenuItem selectedItem = menu.getItem(itemIndex);
      order.addItem(MenuItem(selectedItem.name, selectedItem.price, quantity));
    }
    order.calculateTotal();
    customer1.placeOrder(order);
  } else if (choice == '2') {
    stdout.write('Enter table number: ');
    int tableNumber = int.parse(stdin.readLineSync()!);
    TableReservation reservation = TableReservation('R001', customer1, tableNumber, DateTime.now(), false);
    customer1.reserveTable(reservation);
  } else {
    print('Invalid choice. Please restart the program.');
  }
}
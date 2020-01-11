import 'package:flutter/material.dart';
import 'package:food_dev/Models/orders.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;
  const OrderItemWidget({Key key, this.order}) : super(key: key);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(
                '${DateFormat('MM/dd/yyyy hh:mm').format(widget.order.orderTime.toDate())} \t\t\t Order For: ${widget.order.userEmail}'),
                isThreeLine: true,
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
              height: min(widget.order.items.length * 20.0 + 10.0, 100.0),
              child: ListView(
                children: widget.order.items.map((item) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(item.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                    Text('${item.quantity}x \$${item.price.toStringAsFixed(2)}'),
                  ],
                )).toList(),
              ),
            )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/helper/loading.dart';
import 'package:salon/provider/order_provider.dart';

class SelectTimeWidget extends StatefulWidget {
  SelectTimeWidget({Key key}) : super(key: key);

  @override
  _SelectTimeWidgetState createState() => _SelectTimeWidgetState();
}

class _SelectTimeWidgetState extends State<SelectTimeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
          ),
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              timePeriod(context, 0, "Өглөө"),
              timePeriod(context, 1, "Өдөр"),
              timePeriod(context, 2, "Орой"),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: Border(
              bottom: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.2)),
            ),
          ),
          padding: EdgeInsets.only(top: 10, bottom: 5, left: 3, right: 3),
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: _buildAvTimeWidget(),
        ),
      ],
    );
  }

  Widget timePeriod(BuildContext context, int age, String name) {
    OrderProvider val = Provider.of(context);
    return Expanded(
      child: InkWell(
        onTap: () {
          if (val.order.services.last.age != age) val.setAge(age);
        },
        child: Container(
          color: val.order.services.last.age == age ? Colors.transparent : Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: val.order.services.last.age == age
                  ? BorderRadius.vertical(top: Radius.circular(5))
                  : BorderRadius.vertical(bottom: Radius.circular(5)),
              color: val.order.services.last.age == age ? Theme.of(context).colorScheme.background : Theme.of(context).scaffoldBackgroundColor,
            ),
            padding: EdgeInsets.all(8),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvTimeWidget() {
    OrderProvider val = Provider.of(context);
    if (val.order.services.last.artist == null)
      return Center(child: Text("Та үйлчилгээ авах артистаа сонгосноор цагаа сонгох боломжтой!"));
    else {
      List<String> _avtime = val.order.services.last.getAvtime;
      if (_avtime == null)
        return Center(child: Loading(15));
      else if (_avtime.isEmpty)
        return Center(child: Text("Сул цаг олдсонгүй!"));
      else {
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _avtime.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 4.5,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                val.setTimeIndx(
                  _avtime.elementAt(index),
                  index,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: val.order.services.last.indx == index ? Theme.of(context).colorScheme.secondary.withOpacity(0.5) : Colors.grey[200],
                  ),
                ),
                child: Center(
                  child: Text(
                    _avtime.elementAt(index).substring(0, 5),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }
}

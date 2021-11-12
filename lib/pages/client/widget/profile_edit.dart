import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salon/provider/app_provider.dart' as app;
import 'package:salon/repository.dart';

class ProfileEdit extends StatefulWidget {
  final String title;
  ProfileEdit(this.title);
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  TextEditingController initial = TextEditingController();
  TextInputType type = TextInputType.text;
  bool readOnly = true;
  bool isBirthday = false;
  bool isGender = false;
  int length = 32;
  String prefix = '';

  @override
  Widget build(BuildContext context) {
    app.AppProvider provider = Provider.of(context);
    switch (widget.title) {
      case 'Нэр':
        initial.text = provider.user.name;
        break;
      case 'Цахим шуудан':
        initial.text = provider.user.email;
        break;
      case 'Утас':
        type = TextInputType.number;
        initial.text = provider.user.phone;
        prefix = '+976 ';
        length = 8;
        break;
      case 'Төрсөн өдөр':
        type = TextInputType.number;
        isBirthday = true;
        length = 10;
        initial.text = provider.user.birthday == null
            ? ''
            : repo.bformat.format(provider.user.birthday);
        break;
      case 'Хүйс':
        isGender = true;
        initial.text = 's';
        break;
      default:
        initial.text = '';
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              widget.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            flex: 6,
            child: isGender
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () =>
                            provider.updateUserInfo('Хүйс', 'Эрэгтэй'),
                        child: Row(
                          children: [
                            Icon(Ionicons.male_outline),
                            SizedBox(width: 5),
                            Text('Эрэгтэй'),
                          ],
                        ),
                        style: ButtonStyle(
                          visualDensity: VisualDensity.compact,
                          foregroundColor: MaterialStateProperty.all(
                            provider.user.gender == 'Эрэгтэй'
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).hintColor.withOpacity(0.6),
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      TextButton(
                        onPressed: () =>
                            provider.updateUserInfo('Хүйс', 'Эмэгтэй'),
                        child: Row(
                          children: [
                            Icon(Ionicons.female_outline),
                            SizedBox(width: 5),
                            Text('Эмэгтэй'),
                          ],
                        ),
                        style: ButtonStyle(
                          visualDensity: VisualDensity.compact,
                          foregroundColor: MaterialStateProperty.all(
                            provider.user.gender == 'Эмэгтэй'
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).hintColor.withOpacity(0.6),
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                    ],
                  )
                : TextFormField(
                    controller: initial,
                    readOnly: readOnly,
                    maxLength: length,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      counterText: '',
                      prefixText: prefix,
                      prefixStyle:
                          TextStyle(color: Theme.of(context).hintColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).hintColor.withOpacity(0.5),
                          width: 0.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).hintColor.withOpacity(0.5),
                          width: 0.2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).hintColor.withOpacity(0.5),
                          width: 0.2,
                        ),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    ),
                  ),
          ),
          isGender
              ? Container()
              : IconButton(
                  onPressed: () {
                    if (isBirthday)
                      selectDate(provider);
                    else {
                      if (!readOnly && initial.text != '')
                        provider.updateUserInfo(widget.title, initial.text);

                      setState(() {
                        readOnly = !readOnly;
                      });
                    }
                  },
                  icon: Icon(
                    readOnly
                        ? Ionicons.create_outline
                        : Ionicons.checkmark_sharp,
                    color: readOnly
                        ? Colors.green[800]
                        : Theme.of(context).colorScheme.secondary,
                  ),
                  color: readOnly
                      ? Theme.of(context).hintColor.withOpacity(0.65)
                      : Theme.of(context).colorScheme.secondary,
                ),
        ],
      ),
    );
  }

  selectDate(app.AppProvider provider) {
    DatePicker.showDatePicker(
      context,
      onConfirm: (time) => provider.updateUserInfo('Төрсөн өдөр', time),
      locale: LocaleType.en,
      minTime: DateTime(1900),
      maxTime: DateTime.now(),
      currentTime: provider.user.birthday ?? DateTime.now(),
    );
  }
}
